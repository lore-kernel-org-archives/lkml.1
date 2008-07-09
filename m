Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbYGIDCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbYGIDCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 23:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbYGIDCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 23:02:06 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:58842 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752950AbYGIDCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 23:02:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAE7Hc0hMQWVt/2dsb2JhbACBXK8x
Date: Tue, 8 Jul 2008 23:02:01 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Hideo AOKI <haoki@redhat.com>,
       Takahiro Yasui <tyasui@redhat.com>
Subject: Re: [PATCH -mm] markers: avoid call_rcu_sched if old is NULL
Message-ID: <20080709030200.GA4378@Krystal>
References: <4873CE05.2030001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4873CE05.2030001@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:53:20 up 34 days,  7:34,  4 users,  load average: 2.19, 1.96,
	1.71
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Introduce marker_entry_free_old() and check old pointer is NULL before
> setting call_rcu_sched(), because marker_entry_remove/add_probe() can
> return NULL.
> 

Hi Masami,

I doubt this is a bug per se, because kfree accepts NULL pointers (and
kfree is the only action done on the oldptr by free_old_closure).

This cleans up the code, so I think it's good to merge your patch, but I
would definitely not classify this as a bugfix.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Mathieu

> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> ---
>  kernel/marker.c |   29 ++++++++++++++---------------
>  1 file changed, 14 insertions(+), 15 deletions(-)
> 
> Mathieu, I think this might be a bug. Tracepoint also has
> same bug...
> 
> Index: 2.6.26-rc8-mm1/kernel/marker.c
> ===================================================================
> --- 2.6.26-rc8-mm1.orig/kernel/marker.c	2008-07-07 11:42:04.000000000 -0400
> +++ 2.6.26-rc8-mm1/kernel/marker.c	2008-07-07 11:42:04.000000000 -0400
> @@ -201,6 +201,17 @@ static void free_old_closure(struct rcu_
>  	entry->rcu_pending = 0;
>  }
> 
> +static void marker_entry_free_old(struct marker_entry *entry, void *old)
> +{
> +	if (!old)
> +		return;
> +	entry->oldptr = old;
> +	entry->rcu_pending = 1;
> +	/* write rcu_pending before calling the RCU callback */
> +	smp_wmb();
> +	call_rcu_sched(&entry->rcu, free_old_closure);
> +}
> +
>  static void debug_print_probes(struct marker_entry *entry)
>  {
>  	int i;
> @@ -666,11 +677,7 @@ int marker_probe_register(const char *na
>  	mutex_lock(&markers_mutex);
>  	entry = get_marker(name);
>  	WARN_ON(!entry);
> -	entry->oldptr = old;
> -	entry->rcu_pending = 1;
> -	/* write rcu_pending before calling the RCU callback */
> -	smp_wmb();
> -	call_rcu_sched(&entry->rcu, free_old_closure);
> +	marker_entry_free_old(entry, old);
>  end:
>  	mutex_unlock(&markers_mutex);
>  	return ret;
> @@ -709,11 +716,7 @@ int marker_probe_unregister(const char *
>  	entry = get_marker(name);
>  	if (!entry)
>  		goto end;
> -	entry->oldptr = old;
> -	entry->rcu_pending = 1;
> -	/* write rcu_pending before calling the RCU callback */
> -	smp_wmb();
> -	call_rcu_sched(&entry->rcu, free_old_closure);
> +	marker_entry_free_old(entry, old);
>  	remove_marker(name);	/* Ignore busy error message */
>  	ret = 0;
>  end:
> @@ -787,11 +790,7 @@ int marker_probe_unregister_private_data
>  	mutex_lock(&markers_mutex);
>  	entry = get_marker_from_private_data(probe, probe_private);
>  	WARN_ON(!entry);
> -	entry->oldptr = old;
> -	entry->rcu_pending = 1;
> -	/* write rcu_pending before calling the RCU callback */
> -	smp_wmb();
> -	call_rcu_sched(&entry->rcu, free_old_closure);
> +	marker_entry_free_old(entry, old);
>  	remove_marker(entry->name);	/* Ignore busy error message */
>  end:
>  	mutex_unlock(&markers_mutex);
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
