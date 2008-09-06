Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbYIFIwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbYIFIwn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 04:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbYIFIwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 04:52:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:35306 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbYIFIwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 04:52:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=r/manSeBcPjYHC6TNj8Jd2J8Ns8o41yiWstbNJoH5h4bdOl6ZzvcWdveg6ET8x6i1R
         yzn7HO33SUKlHoU/HCT0Hcmo0MfZYfGW4MJZk9lq5SmrIJNj7CYCaJ7rrld8wX4Tg19k
         VmiFFs0tF+UMWFFL8mqXU3ZS5HptZN9k3QRRo=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 1/2] x86: remove duplicated get_mode_name calling
Date: Sat,  6 Sep 2008 01:52:27 -0700
Message-Id: <1220691148-5608-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/cpu/amd.c       |    3 ---
 arch/x86/kernel/cpu/amd_64.c    |    3 +--
 arch/x86/kernel/cpu/centaur.c   |    1 -
 arch/x86/kernel/cpu/common.c    |    9 +++------
 arch/x86/kernel/cpu/cpu.h       |    1 -
 arch/x86/kernel/cpu/cyrix.c     |    1 -
 arch/x86/kernel/cpu/transmeta.c |    1 -
 7 files changed, 4 insertions(+), 15 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/amd.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/amd.c
+++ linux-2.6/arch/x86/kernel/cpu/amd.c
@@ -42,7 +42,6 @@ static void __cpuinit init_amd(struct cp
 {
 	u32 l, h;
 	int mbytes = num_physpages >> (20-PAGE_SHIFT);
-	int r;
 
 #ifdef CONFIG_SMP
 	unsigned long long value;
@@ -75,8 +74,6 @@ static void __cpuinit init_amd(struct cp
 	 */
 	clear_cpu_cap(c, 0*32+31);
 
-	r = get_model_name(c);
-
 	switch (c->x86) {
 	case 4:
 		/*
Index: linux-2.6/arch/x86/kernel/cpu/amd_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/amd_64.c
+++ linux-2.6/arch/x86/kernel/cpu/amd_64.c
@@ -157,8 +157,7 @@ static void __cpuinit init_amd(struct cp
 	if (c->x86 >= 6)
 		set_cpu_cap(c, X86_FEATURE_FXSAVE_LEAK);
 
-	level = get_model_name(c);
-	if (!level) {
+	if (!c->x86_model_id[0]) {
 		switch (c->x86) {
 		case 0xf:
 			/* Should distinguish Models here, but this is only
Index: linux-2.6/arch/x86/kernel/cpu/centaur.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/centaur.c
+++ linux-2.6/arch/x86/kernel/cpu/centaur.c
@@ -289,7 +289,6 @@ static void __cpuinit init_c3(struct cpu
 	if (c->x86_model >= 6 && c->x86_model < 9)
 		set_cpu_cap(c, X86_FEATURE_3DNOW);
 
-	get_model_name(c);
 	display_cacheinfo(c);
 }
 
Index: linux-2.6/arch/x86/kernel/cpu/common.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common.c
+++ linux-2.6/arch/x86/kernel/cpu/common.c
@@ -252,13 +252,13 @@ static struct cpu_dev __cpuinitdata defa
 	.c_x86_vendor = X86_VENDOR_UNKNOWN,
 };
 
-int __cpuinit get_model_name(struct cpuinfo_x86 *c)
+static void __cpuinit get_model_name(struct cpuinfo_x86 *c)
 {
 	unsigned int *v;
 	char *p, *q;
 
 	if (c->extended_cpuid_level < 0x80000004)
-		return 0;
+		return;
 
 	v = (unsigned int *) c->x86_model_id;
 	cpuid(0x80000002, &v[0], &v[1], &v[2], &v[3]);
@@ -277,8 +277,6 @@ int __cpuinit get_model_name(struct cpui
 	     while (q <= &c->x86_model_id[48])
 		  *q++ = '\0';	/* Zero-pad the rest */
 	}
-
-	return 1;
 }
 
 void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
@@ -610,8 +608,7 @@ static void __cpuinit generic_identify(s
 #endif
 	}
 
-	if (c->extended_cpuid_level >= 0x80000004)
-		get_model_name(c); /* Default name */
+	get_model_name(c); /* Default name */
 
 	init_scattered_cpuid_features(c);
 	detect_nopl(c);
Index: linux-2.6/arch/x86/kernel/cpu/cpu.h
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/cpu.h
+++ linux-2.6/arch/x86/kernel/cpu/cpu.h
@@ -31,7 +31,6 @@ struct cpu_dev {
 
 extern struct cpu_dev *__x86_cpu_dev_start[], *__x86_cpu_dev_end[];
 
-extern int get_model_name(struct cpuinfo_x86 *c);
 extern void display_cacheinfo(struct cpuinfo_x86 *c);
 
 #endif
Index: linux-2.6/arch/x86/kernel/cpu/cyrix.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/cyrix.c
+++ linux-2.6/arch/x86/kernel/cpu/cyrix.c
@@ -301,7 +301,6 @@ static void __cpuinit init_cyrix(struct
 			 */
 			if ((0x30 <= dir1 && dir1 <= 0x6f) || (0x80 <= dir1 && dir1 <= 0x8f))
 				geode_configure();
-			get_model_name(c);  /* get CPU marketing name */
 			return;
 		} else { /* MediaGX */
 			Cx86_cb[2] = (dir0_lsn & 1) ? '3' : '4';
Index: linux-2.6/arch/x86/kernel/cpu/transmeta.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/transmeta.c
+++ linux-2.6/arch/x86/kernel/cpu/transmeta.c
@@ -12,7 +12,6 @@ static void __cpuinit init_transmeta(str
 	unsigned int cpu_rev, cpu_freq = 0, cpu_flags, new_cpu_rev;
 	char cpu_info[65];
 
-	get_model_name(c);	/* Same as AMD/Cyrix */
 	display_cacheinfo(c);
 
 	/* Print CMS and CPU revision */
