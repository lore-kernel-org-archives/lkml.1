Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbYINNnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbYINNnS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 09:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbYINNnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 09:43:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53580 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472AbYINNm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 09:42:59 -0400
Date: Sun, 14 Sep 2008 15:42:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Raz <raziebe@gmail.com>, stable@kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       carlos@strangeworlds.co.uk, Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Paalanen <pq@iki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: Subject: [PATCH] linux-acpi: smp_alternatives sleeping in
	spinlock
Message-ID: <20080914134233.GE554@elte.hu>
References: <5d96567b0809130652i7bc86cbfv6cdc103f595e1e11@mail.gmail.com> <20080914131818.GA30643@elte.hu> <5d96567b0809140637n7eff9881y367aeacdd885ab1a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d96567b0809140637n7eff9881y367aeacdd885ab1a@mail.gmail.com>
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


* Raz <raziebe@gmail.com> wrote:

> > is already done correctly in the latest upstream kernel, see this 
> > commit:
> >
> >  # 2f1dafe: x86: fix SMP alternatives: use mutex instead of spinlock
> >
> > the better solution is to use a mutex, not a semaphore. This fix is 
> > part of the v2.6.26 kernel.
>
> yes. I understand.

ah, sorry - it's actually part of .27-rc, so not yet part of the stable 
kernel.

I've Cc:-ed stable@kernel.org. Stable folks, please apply the commit 
below to -stable. I've checked that it cherry-picks cleanly on v2.6.26.

	Ingo

-------------->
>From 2f1dafe50cc4e58a239fd81bd47f87f32042a1ee Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Mon, 12 May 2008 21:21:01 +0200
Subject: [PATCH] x86: fix SMP alternatives: use mutex instead of spinlock, text_poke is sleepable

text_poke is sleepable.
The original fix by Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/alternative.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index de240ba..2763cb3 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -1,6 +1,6 @@
 #include <linux/module.h>
 #include <linux/sched.h>
-#include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/kprobes.h>
 #include <linux/mm.h>
@@ -279,7 +279,7 @@ struct smp_alt_module {
 	struct list_head next;
 };
 static LIST_HEAD(smp_alt_modules);
-static DEFINE_SPINLOCK(smp_alt);
+static DEFINE_MUTEX(smp_alt);
 static int smp_mode = 1;	/* protected by smp_alt */
 
 void alternatives_smp_module_add(struct module *mod, char *name,
@@ -312,12 +312,12 @@ void alternatives_smp_module_add(struct module *mod, char *name,
 		__func__, smp->locks, smp->locks_end,
 		smp->text, smp->text_end, smp->name);
 
-	spin_lock(&smp_alt);
+	mutex_lock(&smp_alt);
 	list_add_tail(&smp->next, &smp_alt_modules);
 	if (boot_cpu_has(X86_FEATURE_UP))
 		alternatives_smp_unlock(smp->locks, smp->locks_end,
 					smp->text, smp->text_end);
-	spin_unlock(&smp_alt);
+	mutex_unlock(&smp_alt);
 }
 
 void alternatives_smp_module_del(struct module *mod)
@@ -327,17 +327,17 @@ void alternatives_smp_module_del(struct module *mod)
 	if (smp_alt_once || noreplace_smp)
 		return;
 
-	spin_lock(&smp_alt);
+	mutex_lock(&smp_alt);
 	list_for_each_entry(item, &smp_alt_modules, next) {
 		if (mod != item->mod)
 			continue;
 		list_del(&item->next);
-		spin_unlock(&smp_alt);
+		mutex_unlock(&smp_alt);
 		DPRINTK("%s: %s\n", __func__, item->name);
 		kfree(item);
 		return;
 	}
-	spin_unlock(&smp_alt);
+	mutex_unlock(&smp_alt);
 }
 
 void alternatives_smp_switch(int smp)
@@ -359,7 +359,7 @@ void alternatives_smp_switch(int smp)
 		return;
 	BUG_ON(!smp && (num_online_cpus() > 1));
 
-	spin_lock(&smp_alt);
+	mutex_lock(&smp_alt);
 
 	/*
 	 * Avoid unnecessary switches because it forces JIT based VMs to
@@ -383,7 +383,7 @@ void alternatives_smp_switch(int smp)
 						mod->text, mod->text_end);
 	}
 	smp_mode = smp;
-	spin_unlock(&smp_alt);
+	mutex_unlock(&smp_alt);
 }
 
 #endif
