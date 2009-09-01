Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbZIANPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbZIANPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 09:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbZIANPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 09:15:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41313 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707AbZIANPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 09:15:49 -0400
Date: Tue, 1 Sep 2009 15:14:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: arjan@infradead.org, jeremy@goop.org, mschmidt@redhat.com,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tj@kernel.org, tglx@linutronix.de,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH] kthreads: Fix startup synchronization boot crash
Message-ID: <20090901131440.GA29783@elte.hu>
References: <20090829182718.10f566b1@leela> <tip-23386d63bbb3199cf247313ec088878d72debcfd@git.kernel.org> <20090901100351.GA3361@elte.hu> <20090901113914.GA23578@elte.hu> <20090901130436.GA22514@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090901130436.GA22514@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 09/01, Ingo Molnar wrote:
> >
> > In fact i dont see any proper serialization here: there appears to
> > be a race between the initial task and the init task (which are not
> > one and the same). The race is possibly timing dependent as well,
> > hence the (in hindsight, false) dependency on the stackprotector
> > commit.
> 
> Yes, this looks racy, and I think this was always racy.
> 
> > I think the bug was introduced
> > via:
> >
> >   cdd140b: kthreads: simplify the startup synchronization
> 
> Cough ;) No, I don't think this patch introduced this bug. With or 
> without this patch, kthread_create() assumes kthreadd_task != 
> NULL, otherwise wake_up_process(kthreadd_task) is obviously can 
> crash.

yeah - was just a guess.

> >  static DEFINE_SPINLOCK(kthread_create_lock);
> >  static LIST_HEAD(kthread_create_list);
> > +
> >  struct task_struct *kthreadd_task;
> > +DECLARE_COMPLETION(kthreadd_task_init_done);
> >
> >  struct kthread_create_info
> >  {
> > @@ -129,6 +131,9 @@ struct task_struct *kthread_create(int (*threadfn)(void *data),
> >  	list_add_tail(&create.list, &kthread_create_list);
> >  	spin_unlock(&kthread_create_lock);
> >
> > +	if (unlikely(!kthreadd_task))
> > +		wait_for_completion(&kthreadd_task_init_done);
> > +
> 
> Yes, this should work. But I _think_ we can make the better fix...
> 
> I'll try to make the patch soon. Afaics we don't need 
> kthreadd_task_init_done.

ok.

	Ingo
