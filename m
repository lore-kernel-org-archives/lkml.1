Return-Path: <linux-kernel-owner+w=401wt.eu-S1761752AbZCTKMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761752AbZCTKMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759466AbZCTKEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:04:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45837 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759485AbZCTKEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:04:30 -0400
Subject: Re: [patch] don't preempt not TASK_RUNNING tasks
From: Peter Zijlstra <peterz@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: mingo@elte.hu, roland@redhat.com, efault@gmx.de, rjw@sisk.pl,
       jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
In-Reply-To: <E1LkbGe-00039U-Hc@pomaz-ex.szeredi.hu>
References: <E1LkbGe-00039U-Hc@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 20 Mar 2009 11:03:12 +0100
Message-Id: <1237543392.24626.49.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-20 at 10:43 +0100, Miklos Szeredi wrote:
> Ingo,
> 
> I tested this one, and I think it makes sense in any case as an
> optimization.  It should also be good for -stable kernels.
> 
> Does it look OK?

The idea is good, but there is a risk of preemption latencies here. Some
code paths aren't real quick between setting ->state != TASK_RUNNING and
calling schedule.

[ Both quick: as in O(1) and few instructions ]

So if we're going to do this, we'd need to audit all such code paths --
and there be lots.

The first line of attack for this problem is making wait_task_inactive()
sucks less, which shouldn't be too hard, that unconditional 1 jiffy
sleep is simply retarded.

> Index: linux.git/kernel/sched.c
> ===================================================================
> --- linux.git.orig/kernel/sched.c	2009-03-20 09:40:47.000000000 +0100
> +++ linux.git/kernel/sched.c	2009-03-20 10:28:56.000000000 +0100
> @@ -4632,6 +4632,10 @@ asmlinkage void __sched preempt_schedule
>  	if (likely(ti->preempt_count || irqs_disabled()))
>  		return;
>  
> +	/* No point in preempting we are just about to go to sleep. */
> +	if (current->state != TASK_RUNNING)
> +		return;
> +
>  	do {
>  		add_preempt_count(PREEMPT_ACTIVE);
>  		schedule();
