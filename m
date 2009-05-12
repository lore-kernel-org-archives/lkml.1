Return-Path: <linux-kernel-owner+w=401wt.eu-S1758627AbZELPse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627AbZELPse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758358AbZELPrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:47:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:51110 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758213AbZELPrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:47:39 -0400
Subject: [PATCH 4/10 -tip] x86: check_powernow() for K7 user of Advanced
 Power Management features
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Robert Richter <robert.richter@amd.com>,
       Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       x86 maintainers <x86@kernel.org>
In-Reply-To: <1242142753.2547.16.camel@ht.satnam>
References: <1242142530.2547.11.camel@ht.satnam>
	 <1242142623.2547.13.camel@ht.satnam>  <1242142692.2547.15.camel@ht.satnam>
	 <1242142753.2547.16.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 12 May 2009 21:10:07 +0530
Message-Id: <1242142807.2547.18.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use X86_FEATURE_FID and X86_FEATURE_VID to determine K7 PowerNOW.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k7.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k7.c b/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
index 3c28ccd..1f35474 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
@@ -118,7 +118,6 @@ static int check_fsb(unsigned int fsbspeed)
 static int check_powernow(void)
 {
 	struct cpuinfo_x86 *c = &cpu_data(0);
-	unsigned int maxei, eax, ebx, ecx, edx;
 
 	if ((c->x86_vendor != X86_VENDOR_AMD) || (c->x86 != 6)) {
 #ifdef MODULE
@@ -128,9 +127,8 @@ static int check_powernow(void)
 		return 0;
 	}
 
-	/* Get maximum capabilities */
-	maxei = cpuid_eax(0x80000000);
-	if (maxei < 0x80000007) {	/* Any powernow info ? */
+	/* Advanced Power Management capabilities */
+	if (c->x86_capability[9]) {	/* Any powernow info ? */
 #ifdef MODULE
 		printk(KERN_INFO PFX "No powernow capabilities detected\n");
 #endif
@@ -143,23 +141,21 @@ static int check_powernow(void)
 		have_a0 = 1;
 	}
 
-	cpuid(0x80000007, &eax, &ebx, &ecx, &edx);
-
 	/* Check we can actually do something before we say anything.*/
-	if (!(edx & (1 << 1 | 1 << 2)))
+	if (!cpu_has(c, X86_FEATURE_FID) && !cpu_has(c, X86_FEATURE_VID))
 		return 0;
 
 	printk(KERN_INFO PFX "PowerNOW! Technology present. Can scale: ");
 
-	if (edx & 1 << 1) {
+	if (cpu_has(c, X86_FEATURE_FID)) {
 		printk("frequency");
 		can_scale_bus = 1;
 	}
 
-	if ((edx & (1 << 1 | 1 << 2)) == 0x6)
+	if (cpu_has(c, X86_FEATURE_FID) && cpu_has(c, X86_FEATURE_VID))
 		printk(" and ");
 
-	if (edx & 1 << 2) {
+	if (cpu_has(c, X86_FEATURE_VID)) {
 		printk("voltage");
 		can_scale_vid = 1;
 	}
-- 
1.6.0.6



