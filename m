Return-Path: <linux-kernel-owner+w=401wt.eu-S1753153AbZALL7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbZALL7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 06:59:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbZALL7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 06:59:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47941 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbZALL7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 06:59:43 -0500
Date: Mon, 12 Jan 2009 12:59:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Pavel Machek <pavel@suse.cz>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, venkatesh.pallipadi@intel.com,
       shaohua.li@intel.com
Subject: Re: 2.6.28-rc6: hpet: object is on stack, but not annotated
Message-ID: <20090112115934.GA24266@elte.hu>
References: <a4423d670811240839q54e6b7afxfc49d28b3ea127cb@mail.gmail.com> <a4423d670811241014n2b2192beh931d374bf063894f@mail.gmail.com> <alpine.LFD.2.00.0811241916560.3301@localhost.localdomain> <20081204111621.GA2466@elf.ucw.cz> <a4423d670901120240m6ee29951ucc1c0f16c27d398c@mail.gmail.com> <1231761143.4371.0.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231761143.4371.0.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> > > (No, introducing WARN_ON()s is not fine; it spams kerneloops.org at 
> > > least...)
> > 
> > The warning is still here on 2.6.29-rc1. It taints the kernel.
> 
> Does this fix it?

i've applied it to tip/timers/urgent and will send it to Linus if it 
passes Alexander's testing too. Below is the prettified commit.

Thanks guys,

	Ingo
-------------->
>From b1f1006971b6f8d330c6e8ecf240f51c9eb67f4d Mon Sep 17 00:00:00 2001
From: Peter Zijlstra <peterz@infradead.org>
Date: Mon, 12 Jan 2009 12:52:23 +0100
Subject: [PATCH] locking, hpet: annotate false positive warning

Alexander Beregalov reported that this warning is caused by the HPET code:

> hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> hpet0: 3 comparators, 64-bit 14.318180 MHz counter
> ODEBUG: object is on stack, but not annotated
> ------------[ cut here ]------------
> WARNING: at lib/debugobjects.c:251 __debug_object_init+0x2a4/0x352()

> Bisected down to 26afe5f2fbf06ea0765aaa316640c4dd472310c0
> (x86: HPET_MSI Initialise per-cpu HPET timers)

The commit is fine - but the on-stack workqueue entry needs annotation.

Reported-and-bisected-by: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/hpet.c    |    2 +-
 include/linux/workqueue.h |    6 ++++++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index cd759ad..bb2e0f0 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -628,7 +628,7 @@ static int hpet_cpuhp_notify(struct notifier_block *n,
 
 	switch (action & 0xf) {
 	case CPU_ONLINE:
-		INIT_DELAYED_WORK(&work.work, hpet_work);
+		INIT_DELAYED_WORK_ON_STACK(&work.work, hpet_work);
 		init_completion(&work.complete);
 		/* FIXME: add schedule_work_on() */
 		schedule_delayed_work_on(cpu, &work.work, 0);
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index b362911..47151c8 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -118,6 +118,12 @@ struct execute_work {
 		init_timer(&(_work)->timer);			\
 	} while (0)
 
+#define INIT_DELAYED_WORK_ON_STACK(_work, _func)		\
+	do {							\
+		INIT_WORK(&(_work)->work, (_func));		\
+		init_timer_on_stack(&(_work)->timer);		\
+	} while (0)
+
 #define INIT_DELAYED_WORK_DEFERRABLE(_work, _func)			\
 	do {							\
 		INIT_WORK(&(_work)->work, (_func));		\
