Return-Path: <linux-kernel-owner+w=401wt.eu-S1161603AbXD2XvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161603AbXD2XvF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161618AbXD2Xqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:46:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:38494 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161607AbXD2Xqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:46:34 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430146.588463000@suse.de>
In-Reply-To: <20070430146.588463000@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [23/26] i386: Allow boot-time disable of SMP altinstructions
Message-Id: <20070429234633.40953150F2@wotan.suse.de>
Date: Mon, 30 Apr 2007 01:46:33 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
Add "noreplace-smp" to disable SMP instruction replacement.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>
 
---
 Documentation/kernel-parameters.txt |    6 ++++++
 arch/i386/kernel/alternative.c      |   23 +++++++++++++++++++----
 2 files changed, 25 insertions(+), 4 deletions(-)

===================================================================
Index: linux/Documentation/kernel-parameters.txt
===================================================================
--- linux.orig/Documentation/kernel-parameters.txt
+++ linux/Documentation/kernel-parameters.txt
@@ -1142,6 +1142,9 @@ and is between 256 and 4096 characters. 
 
 	nomce		[IA-32] Machine Check Exception
 
+	noreplace-smp	[IA-32,SMP] Don't replace SMP instructions
+			with UP alternatives
+
 	noresidual	[PPC] Don't use residual data on PReP machines.
 
 	noresume	[SWSUSP] Disables resume and restores original swap
@@ -1547,6 +1550,9 @@ and is between 256 and 4096 characters. 
 	smart2=		[HW]
 			Format: <io1>[,<io2>[,...,<io8>]]
 
+	smp-alt-once	[IA-32,SMP] On a hotplug CPU system, only
+			attempt to substitute SMP alternatives once at boot.
+
 	snd-ad1816a=	[HW,ALSA]
 
 	snd-ad1848=	[HW,ALSA]
Index: linux/arch/i386/kernel/alternative.c
===================================================================
--- linux.orig/arch/i386/kernel/alternative.c
+++ linux/arch/i386/kernel/alternative.c
@@ -5,6 +5,7 @@
 #include <asm/alternative.h>
 #include <asm/sections.h>
 
+static int noreplace_smp     = 0;
 static int smp_alt_once      = 0;
 static int debug_alternative = 0;
 
@@ -13,15 +14,23 @@ static int __init bootonly(char *str)
 	smp_alt_once = 1;
 	return 1;
 }
+__setup("smp-alt-boot", bootonly);
+
 static int __init debug_alt(char *str)
 {
 	debug_alternative = 1;
 	return 1;
 }
-
-__setup("smp-alt-boot", bootonly);
 __setup("debug-alternative", debug_alt);
 
+static int __init setup_noreplace_smp(char *str)
+{
+	noreplace_smp = 1;
+	return 1;
+}
+__setup("noreplace-smp", setup_noreplace_smp);
+
+
 #define DPRINTK(fmt, args...) if (debug_alternative) \
 	printk(KERN_DEBUG fmt, args)
 
@@ -185,6 +194,9 @@ static void alternatives_smp_unlock(u8 *
 {
 	u8 **ptr;
 
+	if (noreplace_smp)
+		return;
+
 	for (ptr = start; ptr < end; ptr++) {
 		if (*ptr < text)
 			continue;
@@ -219,6 +231,9 @@ void alternatives_smp_module_add(struct 
 	struct smp_alt_module *smp;
 	unsigned long flags;
 
+	if (noreplace_smp)
+		return;
+
 	if (smp_alt_once) {
 		if (boot_cpu_has(X86_FEATURE_UP))
 			alternatives_smp_unlock(locks, locks_end,
@@ -253,7 +268,7 @@ void alternatives_smp_module_del(struct 
 	struct smp_alt_module *item;
 	unsigned long flags;
 
-	if (smp_alt_once)
+	if (smp_alt_once || noreplace_smp)
 		return;
 
 	spin_lock_irqsave(&smp_alt, flags);
@@ -284,7 +299,7 @@ void alternatives_smp_switch(int smp)
 	return;
 #endif
 
-	if (smp_alt_once)
+	if (noreplace_smp || smp_alt_once)
 		return;
 	BUG_ON(!smp && (num_online_cpus() > 1));
 
