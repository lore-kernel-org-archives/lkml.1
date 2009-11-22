Return-Path: <linux-kernel-owner+w=401wt.eu-S1755053AbZKVNQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbZKVNQI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 08:16:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754929AbZKVNQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 08:16:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:37706 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032AbZKVNQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 08:16:05 -0500
Subject: Re: [patch] sched: add the other missing clock update to
 migrate_task()
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1258891879.14325.36.camel@marge.simson.net>
References: <1258891879.14325.36.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 Nov 2009 14:16:10 +0100
Message-ID: <1258895770.28730.528.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-22 at 13:11 +0100, Mike Galbraith wrote:
> sched: add the other missing clock update to migrate_task()
> 
> When calling set_task_cpu(), we must update both runqueue clocks in order
> to get an accurate clock offset.  Add it.
> 
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <new-submission>
> 
> ---
>  kernel/sched.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -2126,6 +2126,7 @@ migrate_task(struct task_struct *p, int
>  	 */
>  	if (!p->se.on_rq && !task_running(rq, p)) {
>  		update_rq_clock(rq);
> +		update_rq_clock(cpu_rq(dest_cpu));
>  		set_task_cpu(p, dest_cpu);
>  		return 0;
>  	}


We should make double_rq_lock() and double_lock_balance() behave
equivalent wrt update_rq_clock().

Current, depending on CONFIG_PREEMPT, double_lock_balance() already
updates both rq clocks.

