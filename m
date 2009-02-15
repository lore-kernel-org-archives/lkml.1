Return-Path: <linux-kernel-owner+w=401wt.eu-S1751663AbZBOIAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbZBOIAZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 03:00:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZBOIAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 03:00:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:37212 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbZBOIAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 03:00:00 -0500
Message-ID: <4997CB56.7000703@kernel.org>
Date: Sat, 14 Feb 2009 23:59:18 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix typo in filter_cpuid_features()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix wrong diabling cpu features

on amd system got strange:
CPU: CPU feature monitor disabled due to lack of CPUID level 0x5
but in /proc/cpuinfo do have
cpuid level	: 5

on intel system:
CPU: CPU feature monitor disabled due to lack of CPUID level 0x5
CPU: CPU feature dca disabled due to lack of CPUID level 0x9
but in /proc/cpuinfo do have
cpuid level     : 11

it turns out there is one typo, and should use level member in df

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/cpu/common.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/common.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common.c
+++ linux-2.6/arch/x86/kernel/cpu/common.c
@@ -255,9 +255,9 @@ static void __cpuinit filter_cpuid_featu
 		 * signs here...
 		 */
 		if (cpu_has(c, df->feature) &&
-		    ((s32)df->feature < 0 ?
-		     (u32)df->feature > (u32)c->extended_cpuid_level :
-		     (s32)df->feature > (s32)c->cpuid_level)) {
+		    ((s32)df->level < 0 ?
+		     (u32)df->level > (u32)c->extended_cpuid_level :
+		     (s32)df->level > (s32)c->cpuid_level)) {
 			clear_cpu_cap(c, df->feature);
 			if (warn)
 				printk(KERN_WARNING
@@ -267,7 +267,7 @@ static void __cpuinit filter_cpuid_featu
 				       df->level);
 		}
 	}
-}	
+}
 
 /*
  * Naming convention should be: <Name> [(<Codename>)]
