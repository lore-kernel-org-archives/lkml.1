Return-Path: <linux-kernel-owner+w=401wt.eu-S966259AbXDDBft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966259AbXDDBft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966257AbXDDBft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:35:49 -0400
Received: from 250.sub-75-209-50.myvzw.com ([75.209.50.250]:34563 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966255AbXDDBfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:35:36 -0400
Message-Id: <20070404011453.778754570@goop.org>
References: <20070404010655.400913479@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 03 Apr 2007 18:07:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [patch 5/6] Allow boot-time disable of SMP altinstructions
Content-Disposition: inline; filename=disable-smp-alternatives.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add "noreplace-smp" to disable SMP instruction replacement.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
 
---
 Documentation/kernel-parameters.txt |    6 ++++++
 arch/i386/kernel/alternative.c      |   23 +++++++++++++++++++----
 2 files changed, 25 insertions(+), 4 deletions(-)

===================================================================
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1134,6 +1134,9 @@ and is between 256 and 4096 characters. 
 	nomca		[IA-64] Disable machine check abort handling
 
 	nomce		[IA-32] Machine Check Exception
+
+	noreplace-smp	[IA-32,SMP] Don't replace SMP instructions
+			with UP alternatives
 
 	noresidual	[PPC] Don't use residual data on PReP machines.
 
@@ -1540,6 +1543,9 @@ and is between 256 and 4096 characters. 
 	smart2=		[HW]
 			Format: <io1>[,<io2>[,...,<io8>]]
 
+	smp-alt-once	[IA-32,SMP] On a hotplug CPU system, only
+			attempt to substitute SMP alternatives once at boot.
+
 	snd-ad1816a=	[HW,ALSA]
 
 	snd-ad1848=	[HW,ALSA]
===================================================================
--- a/arch/i386/kernel/alternative.c
+++ b/arch/i386/kernel/alternative.c
@@ -5,6 +5,7 @@
 #include <asm/alternative.h>
 #include <asm/sections.h>
 
+static int noreplace_smp     = 0;
 static int smp_alt_once      = 0;
 static int debug_alternative = 0;
 
@@ -13,14 +14,22 @@ static int __init bootonly(char *str)
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
+
+static int __init setup_noreplace_smp(char *str)
+{
+	noreplace_smp = 1;
+	return 1;
+}
+__setup("noreplace-smp", setup_noreplace_smp);
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
@@ -218,6 +230,9 @@ void alternatives_smp_module_add(struct 
 {
 	struct smp_alt_module *smp;
 	unsigned long flags;
+
+	if (noreplace_smp)
+		return;
 
 	if (smp_alt_once) {
 		if (boot_cpu_has(X86_FEATURE_UP))
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
 

-- 

