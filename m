Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbYIMNwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbYIMNwy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 09:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbYIMNwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 09:52:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:21895 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbYIMNwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 09:52:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=gw7T2wkCoK/EoGNfKmRiA1Pd/jRpCkF/l1X2Y8gepM07Obz/MraxAU0n09MtUcyhr8
         EeUXIG2zrv5xOkdXoPkR05f5yeI93QoVFAXU8oLrA57JqA2oUBgVROKsCMdbNf4rZxnQ
         kOuYp6Jfz6hthIJGPDODm+PFguh6z6cJVLVNw=
Message-ID: <5d96567b0809130652i7bc86cbfv6cdc103f595e1e11@mail.gmail.com>
Date: Sat, 13 Sep 2008 15:52:40 +0200
From: Raz <raziebe@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Subject: [PATCH] linux-acpi: smp_alternatives sleeping in spinlock
Cc: carlos@strangeworlds.co.uk
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raz Ben Yehuda <raziebe@gmail.com>

When booting a kernel with PREEMPT_ENABLE and SLAB_DEBUG, unplugging a processor
results in BUG in slab.
Signed-off-by: Raz Ben Yehuda <raziebe@gmail.com>
---
arch/x86/kernel/alternative.c |   17 +++++++++--------
1 file changed, 9 insertions(+), 8 deletions(-)
this bug fix refers to bug numner 11562 in bugzilla.kernel.org

diff -urpN -X dontdiff
linux-2.6.26-5-vanilla/arch/x86/kernel/alternative.c
linux-2.6.26-5-dbg/arch/x86/kernel/alternative.c
--- linux-2.6.26-5-vanilla/arch/x86/kernel/alternative.c	2008-07-13
23:51:29.000000000 +0200
+++ linux-2.6.26-5-dbg/arch/x86/kernel/alternative.c	2008-09-13
15:31:52.000000000 +0200
@@ -13,6 +13,7 @@
 #include <asm/vsyscall.h>
 #include <asm/cacheflush.h>
 #include <asm/io.h>
+#include <linux/semaphore.h>

 #define MAX_PATCH_LEN (255-1)

@@ -279,7 +280,7 @@ struct smp_alt_module {
 	struct list_head next;
 };
 static LIST_HEAD(smp_alt_modules);
-static DEFINE_SPINLOCK(smp_alt);
+static __DECLARE_SEMAPHORE_GENERIC(smp_alt_lock, 1);
 static int smp_mode = 1;	/* protected by smp_alt */

 void alternatives_smp_module_add(struct module *mod, char *name,
@@ -312,12 +313,12 @@ void alternatives_smp_module_add(struct
 		__func__, smp->locks, smp->locks_end,
 		smp->text, smp->text_end, smp->name);

-	spin_lock(&smp_alt);
+	down(&smp_alt_lock);
 	list_add_tail(&smp->next, &smp_alt_modules);
 	if (boot_cpu_has(X86_FEATURE_UP))
 		alternatives_smp_unlock(smp->locks, smp->locks_end,
 					smp->text, smp->text_end);
-	spin_unlock(&smp_alt);
+	up(&smp_alt_lock);
 }

 void alternatives_smp_module_del(struct module *mod)
@@ -327,17 +328,17 @@ void alternatives_smp_module_del(struct
 	if (smp_alt_once || noreplace_smp)
 		return;

-	spin_lock(&smp_alt);
+	down(&smp_alt_lock);
 	list_for_each_entry(item, &smp_alt_modules, next) {
 		if (mod != item->mod)
 			continue;
 		list_del(&item->next);
-		spin_unlock(&smp_alt);
+		up(&smp_alt_lock);
 		DPRINTK("%s: %s\n", __func__, item->name);
 		kfree(item);
 		return;
 	}
-	spin_unlock(&smp_alt);
+	up(&smp_alt_lock);
 }

 void alternatives_smp_switch(int smp)
@@ -359,7 +360,7 @@ void alternatives_smp_switch(int smp)
 		return;
 	BUG_ON(!smp && (num_online_cpus() > 1));

-	spin_lock(&smp_alt);
+	down(&smp_alt_lock);

 	/*
 	 * Avoid unnecessary switches because it forces JIT based VMs to
@@ -383,7 +384,7 @@ void alternatives_smp_switch(int smp)
 						mod->text, mod->text_end);
 	}
 	smp_mode = smp;
-	spin_unlock(&smp_alt);
+	up(&smp_alt_lock);
 }

 #endif
