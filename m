Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939AbXKZLOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbXKZLOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 06:14:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbXKZLOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 06:14:05 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:6427 "EHLO
	outbound4-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753479AbXKZLOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 06:14:03 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
In-Reply-To: <20071126000145.fc4056bb.akpm@linux-foundation.org>
References: <20071126000145.fc4056bb.akpm@linux-foundation.org>
From: "Robert Richter" <robert.richter@amd.com>
Subject: [PATCH] Extended interrupt LVT support for AMD Barcelona
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Message-ID: <20071126105458.BE9B68098@erda.amd.com>
Date: Mon, 26 Nov 2007 11:54:58 +0100 (CET)
X-OriginalArrivalTime: 26 Nov 2007 10:54:58.0761 (UTC)
 FILETIME=[C97ACB90:01C8301A]
MIME-Version: 1.0
X-WSS-ID: 6B54798F24S3500876-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds extended interrupt support for AMD Barcelona CPUs. The
patch provides functions to setup MCE and IBS interrupt
vectors. Compared to the previous K8 implementation the vector offsets
are centrally handled now in apic_64.c. Thus, the APIC setup code is
responsible for vector mappings. The vector mapping is hardcoded for
now.

Also macro definitions in apicdef.h has been updated.

The patch is relative to x86/cleanup tree.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/apic_64.c               |   26 ++++++++++++++++++++++----
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c |   10 +++++-----
 include/asm-x86/apic.h                  |    4 ++--
 include/asm-x86/apicdef.h               |   19 ++++++++++++-------
 4 files changed, 41 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index da3dc68..e24b6e2 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -187,17 +187,35 @@ static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
 }
 
 /*
- * Setup extended LVT (K8 specific)
+ * Setup extended LVT, AMD specific (K8, family 10h)
+ *
+ * Vector mappings are hard coded. On K8 only offset 0 (APIC500) and
+ * MCE interrupts are supported. Thus MCE offset must be set to 0.
  */
-void setup_APIC_extended_lvt(unsigned char lvt_off, unsigned char vector,
-			     unsigned char msg_type, unsigned char mask)
+
+#define APIC_EILVT_LVTOFF_MCE 0
+#define APIC_EILVT_LVTOFF_IBS 1
+
+static void setup_APIC_eilvt(u8 lvt_off, u8 vector, u8 msg_type, u8 mask)
 {
-	unsigned long reg = (lvt_off << 4) + K8_APIC_EXT_LVT_BASE;
+	unsigned long reg = (lvt_off << 4) + APIC_EILVT0;
 	unsigned int  v   = (mask << 16) | (msg_type << 8) | vector;
 
 	apic_write(reg, v);
 }
 
+u8 setup_APIC_eilvt_mce(u8 vector, u8 msg_type, u8 mask)
+{
+	setup_APIC_eilvt(APIC_EILVT_LVTOFF_MCE, vector, msg_type, mask);
+	return APIC_EILVT_LVTOFF_MCE;
+}
+
+u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask)
+{
+	setup_APIC_eilvt(APIC_EILVT_LVTOFF_IBS, vector, msg_type, mask);
+	return APIC_EILVT_LVTOFF_IBS;
+}
+
 /*
  * Program the next event, relative to now
  */
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
index 752fb16..5cd7db5 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -118,6 +118,7 @@ void __cpuinit mce_amd_feature_init(struct cpuinfo_x86 *c)
 {
 	unsigned int bank, block;
 	unsigned int cpu = smp_processor_id();
+	u8 lvt_off;
 	u32 low = 0, high = 0, address = 0;
 
 	for (bank = 0; bank < NR_BANKS; ++bank) {
@@ -153,14 +154,13 @@ void __cpuinit mce_amd_feature_init(struct cpuinfo_x86 *c)
 			if (shared_bank[bank] && c->cpu_core_id)
 				break;
 #endif
+			lvt_off = setup_APIC_eilvt_mce(THRESHOLD_APIC_VECTOR,
+						       APIC_EILVT_MSG_FIX, 0);
+
 			high &= ~MASK_LVTOFF_HI;
-			high |= K8_APIC_EXT_LVT_ENTRY_THRESHOLD << 20;
+			high |= lvt_off << 20;
 			wrmsr(address, low, high);
 
-			setup_APIC_extended_lvt(K8_APIC_EXT_LVT_ENTRY_THRESHOLD,
-						THRESHOLD_APIC_VECTOR,
-						K8_APIC_EXT_INT_MSG_FIX, 0);
-
 			threshold_defaults.address = address;
 			threshold_restart_bank(&threshold_defaults, 0, 0);
 		}
diff --git a/include/asm-x86/apic.h b/include/asm-x86/apic.h
index 5e8192d..4230227 100644
--- a/include/asm-x86/apic.h
+++ b/include/asm-x86/apic.h
@@ -126,8 +126,8 @@ extern void enable_NMI_through_LVT0(void *dummy);
 extern void setup_apic_routing(void);
 #endif
 
-extern void setup_APIC_extended_lvt(unsigned char lvt_off, unsigned char vector,
-				    unsigned char msg_type, unsigned char mask);
+extern u8 setup_APIC_eilvt_mce(u8 vector, u8 msg_type, u8 mask);
+extern u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask);
 
 extern int apic_is_clustered_box(void);
 
diff --git a/include/asm-x86/apicdef.h b/include/asm-x86/apicdef.h
index 5f7abe9..550af7a 100644
--- a/include/asm-x86/apicdef.h
+++ b/include/asm-x86/apicdef.h
@@ -116,13 +116,18 @@
 #define		APIC_TDR_DIV_32		0x8
 #define		APIC_TDR_DIV_64		0x9
 #define		APIC_TDR_DIV_128	0xA
-
-#define K8_APIC_EXT_LVT_BASE		0x500
-#define K8_APIC_EXT_INT_MSG_FIX		0x0
-#define K8_APIC_EXT_INT_MSG_SMI		0x2
-#define K8_APIC_EXT_INT_MSG_NMI		0x4
-#define K8_APIC_EXT_INT_MSG_EXT		0x7
-#define K8_APIC_EXT_LVT_ENTRY_THRESHOLD	0
+#define	APIC_EILVT0     0x500
+#define		APIC_EILVT_NR_AMD_K8	1	/* Number of extended interrupts */
+#define		APIC_EILVT_NR_AMD_10H	4
+#define		APIC_EILVT_LVTOFF(x)	(((x)>>4)&0xF)
+#define		APIC_EILVT_MSG_FIX	0x0
+#define		APIC_EILVT_MSG_SMI	0x2
+#define		APIC_EILVT_MSG_NMI	0x4
+#define		APIC_EILVT_MSG_EXT	0x7
+#define		APIC_EILVT_MASKED	(1<<16)
+#define	APIC_EILVT1     0x510
+#define	APIC_EILVT2     0x520
+#define	APIC_EILVT3     0x530
 
 #define APIC_BASE (fix_to_virt(FIX_APIC_BASE))
 
-- 
1.5.1.6



