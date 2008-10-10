Return-Path: <linux-kernel-owner+w=401wt.eu-S1756264AbYJJGUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264AbYJJGUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 02:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbYJJGUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 02:20:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58160 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbYJJGUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 02:20:37 -0400
Message-ID: <48EEF3A6.3050205@cn.fujitsu.com>
Date: Fri, 10 Oct 2008 14:18:14 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Markers : fix check format with rcu callback race
References: <20081010054444.GB19481@Krystal>
In-Reply-To: <20081010054444.GB19481@Krystal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> The fix "markers: fix unchecked format" introduced an RCU callback race. This
> patch takes care of calling any pending RCU callback before set_format is
> called.
> 

marker_set_format() has this statement:

	if ((*entry)->rcu_pending)
		rcu_barrier_sched();

> 
> * Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
>> bit-field is not thread-safe nor smp-safe.
>>
>> struct marker_entry.rcu_pending is not protected by any lock
>> in rcu-callback free_old_closure().
>> so we must turn it into a safe type.
>>
> 
> All struct marker_entry.rcu_pending accesses are done with the
> markers_mutex held, except the one done in free_old_closure(). Normally,
> there should be a
>         if (entry->rcu_pending)
>            rcu_barrier_sched();
> 
> At the beginning of each markers_mutex section (just after get_marker())
> to make sure any pending callback is executed at that point before any
> of rcu_pending or ptype are touched. 
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/marker.c |   24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)
> 
> Index: linux-2.6-lttng/kernel/marker.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/marker.c	2008-10-10 01:35:32.000000000 -0400
> +++ linux-2.6-lttng/kernel/marker.c	2008-10-10 01:35:32.000000000 -0400
> @@ -657,21 +657,23 @@ int marker_probe_register(const char *na
>  		entry = add_marker(name, format);
>  		if (IS_ERR(entry))
>  			ret = PTR_ERR(entry);
> -	} else if (format) {
> -		if (!entry->format)
> -			ret = marker_set_format(&entry, format);
> -		else if (strcmp(entry->format, format))
> -			ret = -EPERM;
> +	} else {
> +		/*
> +		 * If we detect that a call_rcu is pending for this marker,
> +		 * make sure it's executed now.
> +		 */
> +		if (entry->rcu_pending)
> +			rcu_barrier_sched();
> +		if (format) {
> +			if (!entry->format)
> +				ret = marker_set_format(&entry, format);
> +			else if (strcmp(entry->format, format))
> +				ret = -EPERM;
> +		}
>  	}
>  	if (ret)
>  		goto end;
>  
> -	/*
> -	 * If we detect that a call_rcu is pending for this marker,
> -	 * make sure it's executed now.
> -	 */
> -	if (entry->rcu_pending)
> -		rcu_barrier_sched();
>  	old = marker_entry_add_probe(entry, probe, probe_private);
>  	if (IS_ERR(old)) {
>  		ret = PTR_ERR(old);


