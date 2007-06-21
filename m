Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbXFUIjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbXFUIjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 04:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbXFUIjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 04:39:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52476 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101AbXFUIjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 04:39:46 -0400
Date: Thu, 21 Jun 2007 10:39:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, cebbert@redhat.com, chris@atlee.ca,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070621083931.GA18105@elte.hu>
References: <20070620093612.GA1626@ff.dom.local> <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org> <20070621073800.GA1685@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070621073800.GA1685@ff.dom.local>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jarek Poplawski <jarkao2@o2.pl> wrote:

> BTW, I've looked a bit at these NMI watchdog traces, and now I'm not 
> even sure it's necessarily the spinlock's problem (but I don't exclude 
> this possibility yet). It seems both processors use task_rq_lock(), so 
> there could be also a problem with that loop. The way the correctness 
> of the taken lock is verified is racy: there is a small probability 
> that if we have taken the wrong lock the check inside the loop is done 
> just before the value is beeing changed elsewhere under the right 
> lock. Another possible problem could be a result of some wrong 
> optimization or wrong propagation of change of this task_rq(p) value.

ok, could you elaborate this in a bit more detail? You say it's racy - 
any correctness bug in task_rq_lock() will cause the kernel to blow up 
in spectacular ways. It's a fairly straightforward loop:

 static inline struct rq *__task_rq_lock(struct task_struct *p)
         __acquires(rq->lock)
 {
         struct rq *rq;

 repeat_lock_task:
         rq = task_rq(p);
         spin_lock(&rq->lock);
         if (unlikely(rq != task_rq(p))) {
                 spin_unlock(&rq->lock);
                 goto repeat_lock_task;
         }
         return rq;
 }

the result of task_rq() depends on p->thread_info->cpu wich will only 
change if a task has migrated over to another CPU. That is a 
fundamentally 'slow' operation, but even if a task does it intentionally 
in a high frequency way (for example via repeated calls to 
sched_setaffinity) there's no way it could be faster than the spinlock 
code here. So ... what problems can you see with it?

	Ingo
