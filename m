Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab0BMBlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 20:41:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:15079 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755766Ab0BMBk7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 20:40:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,464,1262592000"; 
   d="scan'208,223";a="595625857"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "Du, Alek" <alek.du@intel.com>, "Tang, Feng" <feng.tang@intel.com>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Date: Fri, 12 Feb 2010 17:40:58 -0800
Subject: [PATCH 6/8] x86/mrst: add vrtc platform data setup code
Thread-Topic: [PATCH 6/8] x86/mrst: add vrtc platform data setup code
Thread-Index: AcqsTZdoC9v183iQSziglnZHHx5PEA==
Message-ID: <43F901BD926A4E43B106BF17856F07559FB80D0D@orsmsx508.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c5ef69d7e1ddd91ba1a58ab0e3c38ce3299e5d5e Mon Sep 17 00:00:00 2001
From: Feng Tang <feng.tang@intel.com>
Date: Fri, 12 Feb 2010 03:37:38 -0800
Subject: [PATCH 6/8] x86/mrst: add vrtc platform data setup code

vRTC information is obtained from SFI tables on Moorestown, this patch parses
these tables and assign the information.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
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
-- 
1.6.5.3

