Return-Path: <linux-kernel-owner+w=401wt.eu-S1755765AbZG1WGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765AbZG1WGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 18:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbZG1WGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 18:06:20 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:37763 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509AbZG1WGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 18:06:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=ESA6tJttcYs3HzqvOVSnbx41uPWe9XJmg5USgV43Ioq4hx9SMJnPd/x1s3MOHHLQds
         zuJUGwYI/Ey1d22zwwFvdTQw8ad6ka3BiYiOGZR05PY+WG/duVdEaXzhc8rDub6GmMsF
         YhIsBhDi4Q5FMSYypXJOwwHnlZO/uAqHHMfY8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] x86: fix reporting of Thermal Monitoring mechanism enabled
Date: Wed, 29 Jul 2009 00:04:59 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc4-next-20090728-04869-gdae50fe-dirty; KDE/4.2.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907290005.00070.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] x86: fix reporting of Thermal Monitoring mechanism enabled

Early Pentium M models use different method for enabling TM2
(per paragraph 13.5.2.3 of the "Intel 64 and IA-32 Architectures
Software Developer's Manual Volume 3A: System Programming Guide,
Part 1").

Tested on the affected Pentium M variant (model == 13).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 arch/x86/include/asm/msr-index.h         |    4 ++++
 arch/x86/kernel/cpu/mcheck/therm_throt.c |   13 ++++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

Index: b/arch/x86/include/asm/msr-index.h
===================================================================
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -215,6 +215,10 @@
 
 #define THERM_STATUS_PROCHOT		(1 << 0)
 
+#define MSR_THERM2_CTL			0x0000019d
+
+#define MSR_THERM2_CTL_TM_SELECT	(1ULL << 16)
+
 #define MSR_IA32_MISC_ENABLE		0x000001a0
 
 /* MISC_ENABLE bits: architectural */
Index: b/arch/x86/kernel/cpu/mcheck/therm_throt.c
===================================================================
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -253,9 +253,6 @@ void intel_init_thermal(struct cpuinfo_x
 		return;
 	}
 
-	if (cpu_has(c, X86_FEATURE_TM2) && (l & MSR_IA32_MISC_ENABLE_TM2))
-		tm2 = 1;
-
 	/* Check whether a vector already exists */
 	if (h & APIC_VECTOR_MASK) {
 		printk(KERN_DEBUG
@@ -264,6 +261,16 @@ void intel_init_thermal(struct cpuinfo_x
 		return;
 	}
 
+	/* early Pentium M models use different method for enabling TM2 */
+	if (cpu_has(c, X86_FEATURE_TM2)) {
+		if (c->x86 == 6 && (c->x86_model == 9 || c->x86_model == 13)) {
+			rdmsr(MSR_THERM2_CTL, l, h);
+			if (l & MSR_THERM2_CTL_TM_SELECT)
+				tm2 = 1;
+		} else if (l & MSR_IA32_MISC_ENABLE_TM2)
+			tm2 = 1;
+	}
+
 	/* We'll mask the thermal vector in the lapic till we're ready: */
 	h = THERMAL_APIC_VECTOR | APIC_DM_FIXED | APIC_LVT_MASKED;
 	apic_write(APIC_LVTTHMR, h);
