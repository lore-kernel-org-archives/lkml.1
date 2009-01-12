Return-Path: <linux-kernel-owner+w=401wt.eu-S1753586AbZALLwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbZALLwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 06:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbZALLwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 06:52:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:33733 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbZALLwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 06:52:34 -0500
Subject: Re: 2.6.28-rc6: hpet: object is on stack, but not annotated
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Pavel Machek <pavel@suse.cz>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       venkatesh.pallipadi@intel.com, shaohua.li@intel.com
In-Reply-To: <a4423d670901120240m6ee29951ucc1c0f16c27d398c@mail.gmail.com>
References: <a4423d670811240839q54e6b7afxfc49d28b3ea127cb@mail.gmail.com>
	 <a4423d670811241014n2b2192beh931d374bf063894f@mail.gmail.com>
	 <alpine.LFD.2.00.0811241916560.3301@localhost.localdomain>
	 <20081204111621.GA2466@elf.ucw.cz>
	 <a4423d670901120240m6ee29951ucc1c0f16c27d398c@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 12:52:23 +0100
Message-Id: <1231761143.4371.0.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-12 at 13:40 +0300, Alexander Beregalov wrote:
> 2008/12/4 Pavel Machek <pavel@suse.cz>:
> > On Mon 2008-11-24 19:17:44, Thomas Gleixner wrote:
> >> On Mon, 24 Nov 2008, Alexander Beregalov wrote:
> >>
> >> > 2008/11/24 Alexander Beregalov <a.beregalov@gmail.com>:
> >> > > hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> >> > > hpet0: 3 comparators, 64-bit 14.318180 MHz counter
> >> > > ODEBUG: object is on stack, but not annotated
> >> > > ------------[ cut here ]------------
> >> > > WARNING: at lib/debugobjects.c:251 __debug_object_init+0x2a4/0x352()
> >> >
> >> > Bisected down to 26afe5f2fbf06ea0765aaa316640c4dd472310c0
> >> > (x86: HPET_MSI Initialise per-cpu HPET timers)
> >> >
> >> > Revert helps
> >>
> >> That's just a warning about a missing annotation. The commit is fine.
> >
> > You must be using very different metric of what "fine" means than rest
> > of the world.
> >
> > (No, introducing WARN_ON()s is not fine; it spams kerneloops.org at least...)
> 
> The warning is still here on 2.6.29-rc1.
> It taints the kernel.

Does this fix it?

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
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


