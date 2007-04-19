Return-Path: <linux-kernel-owner+w=401wt.eu-S1751149AbXDSLKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751149AbXDSLKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 07:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbXDSLKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 07:10:32 -0400
Received: from ccerelrim04.cce.hp.com ([161.114.21.25]:20563 "EHLO
	ccerelrim04.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbXDSLKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 07:10:31 -0400
From: "Bob Picco" <bob.picco@hp.com>
Date: Thu, 19 Apr 2007 07:10:26 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Bob Picco <bob.picco@hp.com>, Christian Hesse <mail@earthworm.de>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, suspend2-devel@lists.suspend2.net
Subject: Re: CFS and suspend2: hang in atomic copy
Message-ID: <20070419111026.GD10564@localhost>
References: <20070413202100.GA9957@elte.hu> <200704182245.24156.mail@earthworm.de> <20070418211632.GA7610@elte.hu> <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu> <20070418225652.GC10564@localhost> <20070419062936.GE18894@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419062936.GE18894@elte.hu>
User-Agent: Mutt/1.5.11
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.4.19.35835
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:	[Thu Apr 19 2007, 02:29:36AM EDT]
> 
> * Bob Picco <bob.picco@hp.com> wrote:
> 
> > I had hoped to collect more data with CFS V2. It crashes in 
> > scale_nice_down for s2ram when attempting to disable_nonboot_cpus. So 
> > part of traceback looks like (typed by hand with obvious omissions):
> > 
> > scale_nice_down
> > update_stats_wait_end - not shown in traceback because inlined
> > pick_next_task_fair
> > migration_call
> > task_rq_lock
> > notifier_call_chain
> > _cpu_down
> > disable_nonboot_cpus
> 
> ok, this looks similar to the jpeg Christian did. Does the patch below 
> fix the crash for you?
> 
> 	Ingo
> 
> ---
>  kernel/sched.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux/kernel/sched.c
> ===================================================================
> --- linux.orig/kernel/sched.c
> +++ linux/kernel/sched.c
> @@ -4425,6 +4425,8 @@ static void migrate_dead_tasks(unsigned 
>  	struct task_struct *next;
>  
>  	for (;;) {
> +		if (!rq->nr_running)
> +			break;
>  		next = pick_next_task(rq, rq->curr);
>  		if (!next)
>  			break;
This patch repairs s2ram issue. 

Thanks.

bob
