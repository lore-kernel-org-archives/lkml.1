Return-Path: <linux-kernel-owner+w=401wt.eu-S1757126AbZKWKwC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126AbZKWKwC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 05:52:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757074AbZKWKwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 05:52:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49216 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756945AbZKWKwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 05:52:00 -0500
Date: Mon, 23 Nov 2009 11:51:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8][RFC] perf: be paranoid about child times?
Message-ID: <20091123105156.GA14736@elte.hu>
References: <20091123103722.140831906@chello.nl>
 <20091123103820.070649058@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123103820.070649058@chello.nl>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Normally we flatten the inherited hierarchy by attaching all childs to
> the top parent, therefore a child's child_total_time_* should never
> get incremented, add it anyway?
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/perf_event.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/kernel/perf_event.c
> ===================================================================
> --- linux-2.6.orig/kernel/perf_event.c
> +++ linux-2.6/kernel/perf_event.c
> @@ -1780,8 +1780,10 @@ u64 perf_event_read_value(struct perf_ev
>  
>  	list_for_each_entry(child, &event->child_list, child_list) {
>  		total += perf_event_read(child);
> -		*enabled += child->total_time_enabled;
> -		*running += child->total_time_running;
> +		*enabled += child->total_time_enabled +
> +			atomic64_read(&child->child_total_time_enabled);
> +		*running += child->total_time_running +
> +			atomic64_read(&child->child_total_time_running);

Stick in a WARN_ON_ONCE() instead?

	Ingo
