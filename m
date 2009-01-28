Return-Path: <linux-kernel-owner+w=401wt.eu-S1761702AbZA2AEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761702AbZA2AEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757691AbZA1XpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:45:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:53028 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758108AbZA1XpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:45:20 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 049/114] x86, es7000: clean up es7000_enable_apic_mode()
Date: Wed, 28 Jan 2009 23:41:55 +0000
Message-Id: <1233186180-29883-50-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:44:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- eliminate the needless es7000_enable_apic_mode() complication which
  was not apparent prior the namespace cleanups

- clean up the control flow in es7000_enable_apic_mode()

- other cleanups

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/es7000/apic.h |    2 ++
 arch/x86/kernel/es7000_32.c        |   27 ++++++++++++++-------------
 arch/x86/mach-generic/es7000.c     |    7 -------
 3 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
index 717c27f..038c4f0 100644
--- a/arch/x86/include/asm/es7000/apic.h
+++ b/arch/x86/include/asm/es7000/apic.h
@@ -36,6 +36,8 @@ static inline unsigned long es7000_check_apicid_present(int bit)
 	return physid_isset(bit, phys_cpu_present_map);
 }
 
+extern void es7000_enable_apic_mode(void);
+
 #define apicid_cluster(apicid) (apicid & 0xF0)
 
 static inline unsigned long calculate_ldr(int cpu)
diff --git a/arch/x86/kernel/es7000_32.c b/arch/x86/kernel/es7000_32.c
index 20a2a43..e73fe18 100644
--- a/arch/x86/kernel/es7000_32.c
+++ b/arch/x86/kernel/es7000_32.c
@@ -359,20 +359,21 @@ es7000_mip_write(struct mip_reg *mip_reg)
 	return status;
 }
 
-void __init
-es7000_sw_apic(void)
+void __init es7000_enable_apic_mode(void)
 {
-	if (es7000_plat) {
-		int mip_status;
-		struct mip_reg es7000_mip_reg;
-
-		printk("ES7000: Enabling APIC mode.\n");
-        	memset(&es7000_mip_reg, 0, sizeof(struct mip_reg));
-        	es7000_mip_reg.off_0 = MIP_SW_APIC;
-        	es7000_mip_reg.off_38 = (MIP_VALID);
-        	while ((mip_status = es7000_mip_write(&es7000_mip_reg)) != 0)
-              		printk("es7000_sw_apic: command failed, status = %x\n",
-				mip_status);
+	struct mip_reg es7000_mip_reg;
+	int mip_status;
+
+	if (!es7000_plat)
 		return;
+
+	printk("ES7000: Enabling APIC mode.\n");
+       	memset(&es7000_mip_reg, 0, sizeof(struct mip_reg));
+       	es7000_mip_reg.off_0 = MIP_SW_APIC;
+       	es7000_mip_reg.off_38 = MIP_VALID;
+
+       	while ((mip_status = es7000_mip_write(&es7000_mip_reg)) != 0) {
+		printk("es7000_enable_apic_mode: command failed, status = %x\n",
+			mip_status);
 	}
 }
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 9acb711..1185964 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -35,13 +35,6 @@ static int probe_es7000(void)
 	return 0;
 }
 
-extern void es7000_sw_apic(void);
-
-static void __init es7000_enable_apic_mode(void)
-{
-	es7000_sw_apic();
-}
-
 static __init int
 mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 {
-- 
1.6.0.2

