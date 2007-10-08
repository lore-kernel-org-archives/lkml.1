Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbXJHN7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbXJHN7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 09:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbXJHN67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 09:58:59 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:43498 "EHLO
	outbound5-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751375AbXJHN65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 09:58:57 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
cc: "Joerg Roedel" <joerg.roedel@amd.com>,
       "Christoph Egger" <christoph.egger@amd.com>
Subject: [PATCH] i386: some MCE cleanups
Date: Mon,  8 Oct 2007 15:58:39 +0200
Message-ID: <11918519193283-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.2.5
X-OriginalArrivalTime: 08 Oct 2007 13:58:40.0023 (UTC)
 FILETIME=[546C2A70:01C809B3]
MIME-Version: 1.0
X-WSS-ID: 6B14E81B0601216067-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

MCG_CAP never reports a negative count of available error-reporting
banks. Make it unsigned.
Check for MCA/MCE feature bits as early as possible.  While here, do an
indent cleanup.

Signed-off-by: Christoph Egger <christoph.egger@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/i386/kernel/cpu/mcheck/mce.c |   57 ++++++++++++++++++++++--------------
 arch/i386/kernel/cpu/mcheck/mce.h |    2 +-
 2 files changed, 36 insertions(+), 23 deletions(-)

diff --git a/arch/i386/kernel/cpu/mcheck/mce.c b/arch/i386/kernel/cpu/mcheck/mce.c
index 34c781e..2eb72ad 100644
--- a/arch/i386/kernel/cpu/mcheck/mce.c
+++ b/arch/i386/kernel/cpu/mcheck/mce.c
@@ -17,7 +17,7 @@
 #include "mce.h"
 
 int mce_disabled = 0;
-int nr_mce_banks;
+unsigned int nr_mce_banks;
 
 EXPORT_SYMBOL_GPL(nr_mce_banks);	/* non-fatal.o */
 
@@ -33,30 +33,43 @@ void fastcall (*machine_check_vector)(struct pt_regs *, long error_code) = unexp
 /* This has to be run for each processor */
 void mcheck_init(struct cpuinfo_x86 *c)
 {
-	if (mce_disabled==1)
+	uint32_t mca, mce;
+
+	if (mce_disabled == 1) {
+		printk("MCE support disabled by bootparam\n");
+		return;
+	}
+
+	mca = cpu_has(c, X86_FEATURE_MCA);
+	mce = cpu_has(c, X86_FEATURE_MCE);
+
+	if (!mca || !mce) {
+		printk(KERN_INFO "CPU%i: No machine check support available\n",
+			smp_processor_id());
 		return;
+	}
 
 	switch (c->x86_vendor) {
-		case X86_VENDOR_AMD:
-			amd_mcheck_init(c);
-			break;
-
-		case X86_VENDOR_INTEL:
-			if (c->x86==5)
-				intel_p5_mcheck_init(c);
-			if (c->x86==6)
-				intel_p6_mcheck_init(c);
-			if (c->x86==15)
-				intel_p4_mcheck_init(c);
-			break;
-
-		case X86_VENDOR_CENTAUR:
-			if (c->x86==5)
-				winchip_mcheck_init(c);
-			break;
-
-		default:
-			break;
+	case X86_VENDOR_AMD:
+		amd_mcheck_init(c);
+		break;
+
+	case X86_VENDOR_INTEL:
+		if (c->x86==5)
+			intel_p5_mcheck_init(c);
+		if (c->x86==6)
+		intel_p6_mcheck_init(c);
+		if (c->x86==15)
+			intel_p4_mcheck_init(c);
+		break;
+
+	case X86_VENDOR_CENTAUR:
+		if (c->x86==5)
+			winchip_mcheck_init(c);
+		break;
+
+	default:
+		break;
 	}
 }
 
diff --git a/arch/i386/kernel/cpu/mcheck/mce.h b/arch/i386/kernel/cpu/mcheck/mce.h
index 81fb6e2..9cbe812 100644
--- a/arch/i386/kernel/cpu/mcheck/mce.h
+++ b/arch/i386/kernel/cpu/mcheck/mce.h
@@ -10,5 +10,5 @@ void winchip_mcheck_init(struct cpuinfo_x86 *c);
 /* Call the installed machine check handler for this CPU setup. */
 extern fastcall void (*machine_check_vector)(struct pt_regs *, long error_code);
 
-extern int nr_mce_banks;
+extern unsigned int nr_mce_banks;
 
-- 
1.5.1.6



