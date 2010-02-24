Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab0BXIJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 03:09:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:58679 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893Ab0BXIJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 03:09:17 -0500
Date: Wed, 24 Feb 2010 08:08:49 GMT
From: tip-bot for Feng Tang <feng.tang@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jacob.jun.pan@intel.com, tglx@linutronix.de, feng.tang@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jacob.jun.pan@intel.com, tglx@linutronix.de, feng.tang@intel.com
In-Reply-To: <43F901BD926A4E43B106BF17856F07559FB80D0D@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F07559FB80D0D@orsmsx508.amr.corp.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86, mrst: Add vrtc platform data setup code
Message-ID: <tip-cf089455966e21aeb8e4cd2669e0c1885667b04e@git.kernel.org>
Git-Commit-ID: cf089455966e21aeb8e4cd2669e0c1885667b04e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 24 Feb 2010 08:08:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf089455966e21aeb8e4cd2669e0c1885667b04e
Gitweb:     http://git.kernel.org/tip/cf089455966e21aeb8e4cd2669e0c1885667b04e
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Fri, 12 Feb 2010 03:37:38 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 23 Feb 2010 23:15:19 -0800

x86, mrst: Add vrtc platform data setup code

vRTC information is obtained from SFI tables on Moorestown, this patch parses
these tables and assign the information.

Signed-off-by: Feng Tang <feng.tang@intel.com>
LKML-Reference: <43F901BD926A4E43B106BF17856F07559FB80D0D@orsmsx508.amr.corp.intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/mrst.h |    2 +
 arch/x86/kernel/mrst.c      |   45 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/mrst.h b/arch/x86/include/asm/mrst.h
index fa144f2..451d30e 100644
--- a/arch/x86/include/asm/mrst.h
+++ b/arch/x86/include/asm/mrst.h
@@ -11,7 +11,9 @@
 #ifndef _ASM_X86_MRST_H
 #define _ASM_X86_MRST_H
 extern int pci_mrst_init(void);
+int __init sfi_parse_mrtc(struct sfi_table_header *table);
 
 #define SFI_MTMR_MAX_NUM 8
+#define SFI_MRTC_MAX	8
 
 #endif /* _ASM_X86_MRST_H */
diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
index bb6e45c..b7fa049 100644
--- a/arch/x86/kernel/mrst.c
+++ b/arch/x86/kernel/mrst.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/sfi.h>
 #include <linux/irq.h>
+#include <linux/module.h>
 
 #include <asm/setup.h>
 #include <asm/mpspec_def.h>
@@ -27,6 +28,10 @@ static u32 sfi_mtimer_usage[SFI_MTMR_MAX_NUM];
 static struct sfi_timer_table_entry sfi_mtimer_array[SFI_MTMR_MAX_NUM];
 int sfi_mtimer_num;
 
+struct sfi_rtc_table_entry sfi_mrtc_array[SFI_MRTC_MAX];
+EXPORT_SYMBOL_GPL(sfi_mrtc_array);
+int sfi_mrtc_num;
+
 static inline void assign_to_mp_irq(struct mpc_intsrc *m,
 				    struct mpc_intsrc *mp_irq)
 {
@@ -126,6 +131,46 @@ void sfi_free_mtmr(struct sfi_timer_table_entry *mtmr)
 	}
 }
 
+/* parse all the mrtc info to a global mrtc array */
+int __init sfi_parse_mrtc(struct sfi_table_header *table)
+{
+	struct sfi_table_simple *sb;
+	struct sfi_rtc_table_entry *pentry;
+	struct mpc_intsrc mp_irq;
+
+	int totallen;
+
+	sb = (struct sfi_table_simple *)table;
+	if (!sfi_mrtc_num) {
+		sfi_mrtc_num = SFI_GET_NUM_ENTRIES(sb,
+						struct sfi_rtc_table_entry);
+		pentry = (struct sfi_rtc_table_entry *)sb->pentry;
+		totallen = sfi_mrtc_num * sizeof(*pentry);
+		memcpy(sfi_mrtc_array, pentry, totallen);
+	}
+
+	printk(KERN_INFO "SFI: RTC info (num = %d):\n", sfi_mrtc_num);
+	pentry = sfi_mrtc_array;
+	for (totallen = 0; totallen < sfi_mrtc_num; totallen++, pentry++) {
+		printk(KERN_INFO "RTC[%d]: paddr = 0x%08x, irq = %d\n",
+			totallen, (u32)pentry->phys_addr, pentry->irq);
+		mp_irq.type = MP_IOAPIC;
+		mp_irq.irqtype = mp_INT;
+		mp_irq.irqflag = 0;
+		mp_irq.srcbus = 0;
+		mp_irq.srcbusirq = pentry->irq;	/* IRQ */
+		mp_irq.dstapic = MP_APIC_ALL;
+		mp_irq.dstirq = pentry->irq;
+		save_mp_irq(&mp_irq);
+	}
+	return 0;
+}
+
+void __init mrst_rtc_init(void)
+{
+	sfi_table_parse(SFI_SIG_MRTC, NULL, NULL, sfi_parse_mrtc);
+}
+
 /*
  * Moorestown specific x86_init function overrides and early setup
  * calls.
