Return-Path: <linux-kernel-owner+w=401wt.eu-S1758304AbXJKMSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304AbXJKMSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 08:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbXJKMSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 08:18:18 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:50897 "EHLO
	outbound3-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754439AbXJKMSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 08:18:17 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Joerg Roedel" <joerg.roedel@amd.com>,
       "Christoph Egger" <Christoph.Egger@amd.com>
Subject: [PATCH 1/2] x86: mce init optimization and signedness fixup
Date: Thu, 11 Oct 2007 14:17:53 +0200
Message-ID: <1192105075473-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <11921050742274-git-send-email-joerg.roedel@amd.com>
References: <11921050742274-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 11 Oct 2007 12:17:55.0492 (UTC)
 FILETIME=[C0D72E40:01C80C00]
MIME-Version: 1.0
X-WSS-ID: 6B10CBF61DW1494538-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

MCG_CAP never reports a negative count of available error-reporting banks.
Therefore, make nr_mce_banks unsigned.
Check for MCA/MCE feature bits as early as possible.

Signed-off-by: Christoph Egger <Christoph.Egger@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   12 ++++++++++--
 arch/x86/kernel/cpu/mcheck/mce.h |    2 +-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 34c781e..e1ac4f7 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -17,7 +17,7 @@
 #include "mce.h"
 
 int mce_disabled = 0;
-int nr_mce_banks;
+unsigned int nr_mce_banks;
 
 EXPORT_SYMBOL_GPL(nr_mce_banks);	/* non-fatal.o */
 
@@ -33,8 +33,16 @@ void fastcall (*machine_check_vector)(struct pt_regs *, long error_code) = unexp
 /* This has to be run for each processor */
 void mcheck_init(struct cpuinfo_x86 *c)
 {
-	if (mce_disabled==1)
+	if (mce_disabled == 1) {
+		printk(KERN_INFO "MCE support disabled by bootparam\n");
 		return;
+	}
+
+	if (!cpu_has(c, X86_FEATURE_MCA) || !cpu_has(c, X86_FEATURE_MCE)) {
+		printk(KERN_INFO "CPU%i: No machine check support available\n",
+			smp_processor_id());
+		return;
+	}
 
 	switch (c->x86_vendor) {
 		case X86_VENDOR_AMD:
diff --git a/arch/x86/kernel/cpu/mcheck/mce.h b/arch/x86/kernel/cpu/mcheck/mce.h
index 81fb6e2..9cbe812 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.h
+++ b/arch/x86/kernel/cpu/mcheck/mce.h
@@ -10,5 +10,5 @@ void winchip_mcheck_init(struct cpuinfo_x86 *c);
 /* Call the installed machine check handler for this CPU setup. */
 extern fastcall void (*machine_check_vector)(struct pt_regs *, long error_code);
 
-extern int nr_mce_banks;
+extern unsigned int nr_mce_banks;
 
-- 
1.5.2.5



