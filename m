Return-Path: <linux-kernel-owner+w=401wt.eu-S1762931AbYDVSnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762931AbYDVSnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 14:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755387AbYDVSmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 14:42:50 -0400
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154]:47308 "EHLO
	pne-smtpout4-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751944AbYDVSmt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 14:42:49 -0400
Date: Tue, 22 Apr 2008 21:42:40 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: [repost PATCH] Fix SMP alternatives : use mutex instead of
 spinlock, text_poke is sleepable
Message-ID: <20080422214240.33e79a94@daedalus.pq.iki.fi>
In-Reply-To: <20080419161956.GA24685@Krystal>
References: <20080413224207.4430a09c@daedalus.pq.iki.fi>
 <20080413230552.33ca587a@daedalus.pq.iki.fi>
 <20080414065713.GB16163@elte.hu>
 <20080419184137.79957a07@daedalus.pq.iki.fi>
 <20080419161956.GA24685@Krystal>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 58390e93507669d860ef2d178b60ad447d5260c4 Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Sat, 19 Apr 2008 23:22:11 +0300
Subject: [PATCH] x86: Fix SMP alternatives: use mutex instead of spinlock.

text_poke is sleepable.
The original fix by Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---

> Mathieu,
> 
> thank you for the quick reply. Your patch did not apply on sched-devel/latest
> so I made the changes by hand, resulting patch here. The change was in the
> context lines, which made `patch' fail, e.g. __FUNCTION__ -> __func__.
> Now my enter_uniprocessor(), that disables all but the first cpu, works fine.
> 
> My next quest is, why attempting to re-enable the cpus makes the whole
> machine reboot after a short hang.

Ingo,

I see you applied the NX fix. This patch is the other one needed to make
CPU hotplug working. Could you apply this, unless Mathieu has something
against it?

After this one I can resubmit the mmiotrace CPU auto-disable patch
(modified a bit). Though it will be a couple of days before I can get
back to coding.


Thanks.

 arch/x86/kernel/alternative.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 5412fd7..7ce0939 100644
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
-- 
1.5.3.7

