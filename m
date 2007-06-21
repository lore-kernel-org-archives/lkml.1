Return-Path: <linux-kernel-owner+w=401wt.eu-S1756069AbXFULBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbXFULBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 07:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753899AbXFULBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 07:01:13 -0400
Received: from mx2.go2.pl ([193.17.41.42]:55741 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753508AbXFULBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 07:01:12 -0400
Date: Thu, 21 Jun 2007 13:09:09 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, cebbert@redhat.com, chris@atlee.ca,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070621110909.GB1685@ff.dom.local>
References: <20070620093612.GA1626@ff.dom.local> <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org> <20070621073800.GA1685@ff.dom.local> <20070621083931.GA18105@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070621083931.GA18105@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2007 at 10:39:31AM +0200, Ingo Molnar wrote:
> 
> * Jarek Poplawski <jarkao2@o2.pl> wrote:
> 
> > BTW, I've looked a bit at these NMI watchdog traces, and now I'm not 
> > even sure it's necessarily the spinlock's problem (but I don't exclude 
> > this possibility yet). It seems both processors use task_rq_lock(), so 
> > there could be also a problem with that loop. The way the correctness 
> > of the taken lock is verified is racy: there is a small probability 
> > that if we have taken the wrong lock the check inside the loop is done 
> > just before the value is beeing changed elsewhere under the right 
> > lock. Another possible problem could be a result of some wrong 
> > optimization or wrong propagation of change of this task_rq(p) value.
> 
> ok, could you elaborate this in a bit more detail? You say it's racy - 
> any correctness bug in task_rq_lock() will cause the kernel to blow up 
> in spectacular ways. It's a fairly straightforward loop:
> 
>  static inline struct rq *__task_rq_lock(struct task_struct *p)
>          __acquires(rq->lock)
>  {
>          struct rq *rq;
> 
>  repeat_lock_task:
>          rq = task_rq(p);
>          spin_lock(&rq->lock);
>          if (unlikely(rq != task_rq(p))) {
>                  spin_unlock(&rq->lock);
>                  goto repeat_lock_task;
>          }
>          return rq;
>  }
> 
> the result of task_rq() depends on p->thread_info->cpu wich will only 
> change if a task has migrated over to another CPU. That is a 
> fundamentally 'slow' operation, but even if a task does it intentionally 
> in a high frequency way (for example via repeated calls to 
> sched_setaffinity) there's no way it could be faster than the spinlock 
> code here. So ... what problems can you see with it?

OK, you are right - I withdraw this "idea". Sorry!

Jarek P.
