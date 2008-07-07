Return-Path: <linux-kernel-owner+w=401wt.eu-S1756195AbYGGGan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbYGGGan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 02:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbYGGG26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 02:28:58 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:56828 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbYGGG24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 02:28:56 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080707828.405203787@firstfloor.org>
In-Reply-To: <20080707828.405203787@firstfloor.org>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [5/9] MCE: Rename mce_dont_init on 64bit to mce_disabled
Message-Id: <20080707062837.A6F7C1B4315@basil.firstfloor.org>
Date: Mon,  7 Jul 2008 08:28:37 +0200 (CEST)
X-OriginalArrivalTime: 07 Jul 2008 06:21:13.0906 (UTC) FILETIME=[A808D120:01C8DFF9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This way they are the same between 32bit and 64bit and no special
cases needed. The semantics were always the same.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    8 ++++----
 include/asm-x86/mce.h               |    2 --
 2 files changed, 4 insertions(+), 6 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -35,7 +35,7 @@
 
 atomic_t mce_entry;
 
-static int mce_dont_init;
+int mce_disabled __cpuinitdata;
 
 /*
  * Tolerant levels:
@@ -535,7 +535,7 @@ void __cpuinit mcheck_init(struct cpuinf
 
 	mce_cpu_quirks(c);
 
-	if (mce_dont_init ||
+	if (mce_disabled ||
 	    cpu_test_and_set(smp_processor_id(), mce_cpus) ||
 	    !mce_available(c))
 		return;
@@ -722,7 +722,7 @@ void __init restart_mce(void)
  */
 static int __init mcheck_disable(char *str)
 {
-	mce_dont_init = 1;
+	mce_disabled = 1;
 	return 1;
 }
 
@@ -734,7 +734,7 @@ static int __init mcheck_disable(char *s
 static int __init mcheck_enable(char *str)
 {
 	if (!strcmp(str, "off"))
-		mce_dont_init = 1;
+		mce_disabled = 1;
 	else if (!strcmp(str, "bootlog") || !strcmp(str,"nobootlog"))
 		mce_bootlog = str[0] == 'b';
 	else if (isdigit(str[0]))
Index: linux/include/asm-x86/mce.h
===================================================================
--- linux.orig/include/asm-x86/mce.h
+++ linux/include/asm-x86/mce.h
@@ -84,9 +84,7 @@ struct mce_log {
 
 #ifdef __KERNEL__
 
-#ifdef CONFIG_X86_32
 extern int mce_disabled;
-#else /* CONFIG_X86_32 */
 
 #include <asm/atomic.h>
 
