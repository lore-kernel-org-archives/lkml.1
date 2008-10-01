Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbYJBADw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbYJBADw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 20:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYJBADn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 20:03:43 -0400
Received: from ns2.suse.de ([195.135.220.15]:56757 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbYJBADl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 20:03:41 -0400
Subject: patch x86-fix-smp-alternatives-use-mutex-instead-of-spinlock-text_poke-is-sleepable.patch added to 2.6.26-stable tree
To: pq@iki.fi, 20080914134233.GE554@elte.hu, gregkh@suse.de,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       mingo@elte.hu, raziebe@gmail.com, tglx@linutronix.de,
       vegard.nossum@gmail.com, x86@kernel.org
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@suse.de>
Date: Wed, 01 Oct 2008 16:59:39 -0700
Message-Id: <20081002000339.6AA0C14543E5@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that we have just queued up the patch titled

    Subject: x86: fix SMP alternatives: use mutex instead of spinlock, text_poke is sleepable

to the 2.6.26-stable tree.  Its filename is

    x86-fix-smp-alternatives-use-mutex-instead-of-spinlock-text_poke-is-sleepable.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From mingo@elte.hu  Wed Oct  1 16:51:38 2008
From: Pekka Paalanen <pq@iki.fi>
Date: Mon, 12 May 2008 21:21:01 +0200
Subject: x86: fix SMP alternatives: use mutex instead of spinlock, text_poke is sleepable
To: Raz <raziebe@gmail.com>, stable@kernel.org
Cc: the arch/x86 maintainers <x86@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, Vegard Nossum <vegard.nossum@gmail.com>, carlos@strangeworlds.co.uk, Pekka Paalanen <pq@iki.fi>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Message-ID: <20080914134233.GE554@elte.hu>
Content-Disposition: inline

From: Pekka Paalanen <pq@iki.fi>

commit 2f1dafe50cc4e58a239fd81bd47f87f32042a1ee upstream

text_poke is sleepable.
The original fix by Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/alternative.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

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
@@ -312,12 +312,12 @@ void alternatives_smp_module_add(struct 
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
@@ -327,17 +327,17 @@ void alternatives_smp_module_del(struct 
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


Patches currently in stable-queue which might be from pq@iki.fi are

queue-2.6.26/x86-fix-smp-alternatives-use-mutex-instead-of-spinlock-text_poke-is-sleepable.patch
