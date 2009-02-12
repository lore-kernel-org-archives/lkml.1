Return-Path: <linux-kernel-owner+w=401wt.eu-S1759295AbZBLMjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295AbZBLMjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758772AbZBLMig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:38:36 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49213 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758758AbZBLMif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:38:35 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20090212137.750180365@firstfloor.org>
In-Reply-To: <20090212137.750180365@firstfloor.org>
To: akpm@linux-foundation.org, x86@firstfloor.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [5/10] x86: MCE: Don't set up mce sysdev devices with mce=off
Message-Id: <20090212123724.54A863E6674@basil.firstfloor.org>
Date: Thu, 12 Feb 2009 13:37:24 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: bug fix, in this case the resume handler shouldn't run which
	avoids incorrectly reenabling machine checks on resume

When MCEs are completely disabled on the command line don't set 
up the sysdev devices for them either.

Includes a comment fix from Thomas Gleixner.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 11:30:51.000000000 +0100
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 12:10:21.000000000 +0100
@@ -151,6 +151,8 @@
 
 static int mce_available(struct cpuinfo_x86 *c)
 {
+	if (mce_dont_init)
+		return 0;
 	return cpu_has(c, X86_FEATURE_MCE) && cpu_has(c, X86_FEATURE_MCA);
 }
 
@@ -532,8 +534,7 @@
 {
 	mce_cpu_quirks(c);
 
-	if (mce_dont_init ||
-	    !mce_available(c))
+	if (!mce_available(c))
 		return;
 
 	mce_init(NULL);
@@ -710,8 +711,7 @@
 	return 1;
 }
 
-/* mce=off disables machine check. Note you can re-enable it later
-   using sysfs.
+/* mce=off disables machine check.
    mce=TOLERANCELEVEL (number, see above)
    mce=bootlog Log MCEs from before booting. Disabled by default on AMD.
    mce=nobootlog Don't log MCEs from before booting. */
