Return-Path: <linux-kernel-owner+w=401wt.eu-S1754379AbXJIMuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbXJIMuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 08:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbXJIMuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 08:50:07 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:22567 "EHLO
	outbound3-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752643AbXJIMuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 08:50:04 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
cc: "Joerg Roedel" <joerg.roedel@amd.com>,
       "Christoph Egger" <Christoph.Egger@amd.com>
Subject: [PATCH 1/2] i386: mce cleanup part1: functional change
Date: Tue,  9 Oct 2007 14:49:55 +0200
Message-ID: <11919341961530-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <11919341961890-git-send-email-joerg.roedel@amd.com>
References: <11919341961890-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Oct 2007 12:49:57.0211 (UTC)
 FILETIME=[E572BAB0:01C80A72]
MIME-Version: 1.0
X-WSS-ID: 6B15A77D1DW1286356-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

MCG_CAP never reports a negative count of available error-reporting banks.
Therefore, make it unsigned.
Check for MCA/MCE feature bits as early as possible.

Signed-off-by: Christoph Egger <Christoph.Egger@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/i386/kernel/cpu/mcheck/mce.c |   13 ++++++++++++-
 arch/i386/kernel/cpu/mcheck/mce.h |    2 +-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/i386/kernel/cpu/mcheck/mce.c b/arch/i386/kernel/cpu/mcheck/mce.c
index 34c781e..bad2c64 100644
--- a/arch/i386/kernel/cpu/mcheck/mce.c
+++ b/arch/i386/kernel/cpu/mcheck/mce.c
@@ -17,7 +17,7 @@
 #include "mce.h"
 
 int mce_disabled = 0;
-int nr_mce_banks;
+unsigned int nr_mce_banks;
 
 EXPORT_SYMBOL_GPL(nr_mce_banks);	/* non-fatal.o */
 
@@ -33,9 +33,20 @@ void fastcall (*machine_check_vector)(struct pt_regs *, long error_code) = unexp
 /* This has to be run for each processor */
 void mcheck_init(struct cpuinfo_x86 *c)
 {
+	uint32_t mca, mce;
+
 	if (mce_disabled==1)
 		return;
 
+	mca = cpu_has(c, X86_FEATURE_MCA);
+	mce = cpu_has(c, X86_FEATURE_MCE);
+
+	if (!mca || !mce) {
+		printk(KERN_INFO "CPU%i: No machine check support available\n",
+			smp_processor_id());
+		return;
+	}
+
 	switch (c->x86_vendor) {
 		case X86_VENDOR_AMD:
 			amd_mcheck_init(c);
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
1.5.2.5



