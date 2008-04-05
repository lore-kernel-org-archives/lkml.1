Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbYDENwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbYDENwL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 09:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbYDENuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 09:50:50 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:9009 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956AbYDENus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 09:50:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=sGQhojLx4Ybcj45/JuYqTJCX9Tl13mQbegTqP4jKPj3YllvabSR1fW0iesKKbVPwrACinFFSkB/y7dpPSCFPRop6wbgfde643s+mJD04Os6kkRxirFjNSm3KAnJ21kiVfgUZxj4yLIOb6pQjQJ2RnsbXuArCZEqCOicZ8rOrf10=
References: <20080405133903.770639386@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 05 Apr 2008 22:39:10 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 7/9] use BUILD_BUG_ON() for the size of struct intel_mp_floating
Content-Disposition: inline; filename=x86-use-build-bug-on.patch
Message-ID: <47f783b5.0886460a.3f87.5f49@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use BUILD_BUG_ON() rather than runtime diagnosis (in i386)
or compile-time error technology with extern non-exsistent function
(in x86_64)

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/x86/kernel/mpparse_32.c |    7 +++----
 arch/x86/kernel/mpparse_64.c |    8 +++-----
 2 files changed, 6 insertions(+), 9 deletions(-)

Index: 2.6-git/arch/x86/kernel/mpparse_32.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/mpparse_32.c
+++ 2.6-git/arch/x86/kernel/mpparse_32.c
@@ -716,14 +716,13 @@ void __init get_smp_config (void)
 	 */
 }
 
-static int __init smp_scan_config (unsigned long base, unsigned long length)
+static int __init smp_scan_config(unsigned long base, unsigned long length)
 {
 	unsigned long *bp = phys_to_virt(base);
 	struct intel_mp_floating *mpf;
 
-	printk(KERN_INFO "Scan SMP from %p for %ld bytes.\n", bp,length);
-	if (sizeof(*mpf) != 16)
-		printk("Error: MPF size\n");
+	printk(KERN_INFO "Scan SMP from %p for %ld bytes.\n", bp, length);
+	BUILD_BUG_ON(sizeof(*mpf) != 16);
 
 	while (length > 0) {
 		mpf = (struct intel_mp_floating *)bp;
Index: 2.6-git/arch/x86/kernel/mpparse_64.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/mpparse_64.c
+++ 2.6-git/arch/x86/kernel/mpparse_64.c
@@ -534,15 +534,13 @@ void __init get_smp_config (void)
 	 */
 }
 
-static int __init smp_scan_config (unsigned long base, unsigned long length)
+static int __init smp_scan_config(unsigned long base, unsigned long length)
 {
-	extern void __bad_mpf_size(void); 
 	unsigned int *bp = phys_to_virt(base);
 	struct intel_mp_floating *mpf;
 
-	Dprintk("Scan SMP from %p for %ld bytes.\n", bp,length);
-	if (sizeof(*mpf) != 16)
-		__bad_mpf_size();
+	Dprintk("Scan SMP from %p for %ld bytes.\n", bp, length);
+	BUILD_BUG_ON(sizeof(*mpf) != 16);
 
 	while (length > 0) {
 		mpf = (struct intel_mp_floating *)bp;

-- 
