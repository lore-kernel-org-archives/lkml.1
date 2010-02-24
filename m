Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab0BXII7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 03:08:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:58664 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924Ab0BXII4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 03:08:56 -0500
Date: Wed, 24 Feb 2010 08:08:31 GMT
From: tip-bot for Jacob Pan <jacob.jun.pan@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jacob.jun.pan@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jacob.jun.pan@intel.com, tglx@linutronix.de
In-Reply-To: <43F901BD926A4E43B106BF17856F07559FB80D0B@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F07559FB80D0B@orsmsx508.amr.corp.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86, mrst: Add platform timer info parsing code
Message-ID: <tip-16ab5395856d8953ae3d81e81bd6a8c269a1bfd6@git.kernel.org>
Git-Commit-ID: 16ab5395856d8953ae3d81e81bd6a8c269a1bfd6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 24 Feb 2010 08:08:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  16ab5395856d8953ae3d81e81bd6a8c269a1bfd6
Gitweb:     http://git.kernel.org/tip/16ab5395856d8953ae3d81e81bd6a8c269a1bfd6
Author:     Jacob Pan <jacob.jun.pan@intel.com>
AuthorDate: Fri, 12 Feb 2010 03:08:30 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 23 Feb 2010 23:15:19 -0800

x86, mrst: Add platform timer info parsing code

Moorestown platform timer information is obtained from SFI FW tables.
This patch parses SFI table then assign the irq information to mp_irqs.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
LKML-Reference: <43F901BD926A4E43B106BF17856F07559FB80D0B@orsmsx508.amr.corp.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/mrst.h |    2 +
 arch/x86/kernel/mrst.c      |  110 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 112 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/mrst.h b/arch/x86/include/asm/mrst.h
index 57a177a..fa144f2 100644
--- a/arch/x86/include/asm/mrst.h
+++ b/arch/x86/include/asm/mrst.h
@@ -12,4 +12,6 @@
 #define _ASM_X86_MRST_H
 extern int pci_mrst_init(void);
 
+#define SFI_MTMR_MAX_NUM 8
+
 #endif /* _ASM_X86_MRST_H */
diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
index 98440e1..bb6e45c 100644
--- a/arch/x86/kernel/mrst.c
+++ b/arch/x86/kernel/mrst.c
@@ -10,12 +10,122 @@
  * of the License.
  */
 #include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/sfi.h>
+#include <linux/irq.h>
 
 #include <asm/setup.h>
+#include <asm/mpspec_def.h>
+#include <asm/hw_irq.h>
+#include <asm/apic.h>
+#include <asm/io_apic.h>
 #include <asm/mrst.h>
 #include <asm/io.h>
 #include <asm/i8259.h>
 
+static u32 sfi_mtimer_usage[SFI_MTMR_MAX_NUM];
+static struct sfi_timer_table_entry sfi_mtimer_array[SFI_MTMR_MAX_NUM];
+int sfi_mtimer_num;
+
+static inline void assign_to_mp_irq(struct mpc_intsrc *m,
+				    struct mpc_intsrc *mp_irq)
+{
+	memcpy(mp_irq, m, sizeof(struct mpc_intsrc));
+}
+
+static inline int mp_irq_cmp(struct mpc_intsrc *mp_irq,
+				struct mpc_intsrc *m)
+{
+	return memcmp(mp_irq, m, sizeof(struct mpc_intsrc));
+}
+
+static void save_mp_irq(struct mpc_intsrc *m)
+{
+	int i;
+
+	for (i = 0; i < mp_irq_entries; i++) {
+		if (!mp_irq_cmp(&mp_irqs[i], m))
+			return;
+	}
+
+	assign_to_mp_irq(m, &mp_irqs[mp_irq_entries]);
+	if (++mp_irq_entries == MAX_IRQ_SOURCES)
+		panic("Max # of irq sources exceeded!!\n");
+}
+
+/* parse all the mtimer info to a static mtimer array */
+static int __init sfi_parse_mtmr(struct sfi_table_header *table)
+{
+	struct sfi_table_simple *sb;
+	struct sfi_timer_table_entry *pentry;
+	struct mpc_intsrc mp_irq;
+	int totallen;
+
+	sb = (struct sfi_table_simple *)table;
+	if (!sfi_mtimer_num) {
+		sfi_mtimer_num = SFI_GET_NUM_ENTRIES(sb,
+					struct sfi_timer_table_entry);
+		pentry = (struct sfi_timer_table_entry *) sb->pentry;
+		totallen = sfi_mtimer_num * sizeof(*pentry);
+		memcpy(sfi_mtimer_array, pentry, totallen);
+	}
+
+	printk(KERN_INFO "SFI: MTIMER info (num = %d):\n", sfi_mtimer_num);
+	pentry = sfi_mtimer_array;
+	for (totallen = 0; totallen < sfi_mtimer_num; totallen++, pentry++) {
+		printk(KERN_INFO "timer[%d]: paddr = 0x%08x, freq = %dHz,"
+			" irq = %d\n", totallen, (u32)pentry->phys_addr,
+			pentry->freq_hz, pentry->irq);
+			if (!pentry->irq)
+				continue;
+			mp_irq.type = MP_IOAPIC;
+			mp_irq.irqtype = mp_INT;
+/* triggering mode edge bit 2-3, active high polarity bit 0-1 */
+			mp_irq.irqflag = 5;
+			mp_irq.srcbus = 0;
+			mp_irq.srcbusirq = pentry->irq;	/* IRQ */
+			mp_irq.dstapic = MP_APIC_ALL;
+			mp_irq.dstirq = pentry->irq;
+			save_mp_irq(&mp_irq);
+	}
+
+	return 0;
+}
+
+struct sfi_timer_table_entry *sfi_get_mtmr(int hint)
+{
+	int i;
+	if (hint < sfi_mtimer_num) {
+		if (!sfi_mtimer_usage[hint]) {
+			pr_debug("hint taken for timer %d irq %d\n",\
+				hint, sfi_mtimer_array[hint].irq);
+			sfi_mtimer_usage[hint] = 1;
+			return &sfi_mtimer_array[hint];
+		}
+	}
+	/* take the first timer available */
+	for (i = 0; i < sfi_mtimer_num;) {
+		if (!sfi_mtimer_usage[i]) {
+			sfi_mtimer_usage[i] = 1;
+			return &sfi_mtimer_array[i];
+		}
+		i++;
+	}
+	return NULL;
+}
+
+void sfi_free_mtmr(struct sfi_timer_table_entry *mtmr)
+{
+	int i;
+	for (i = 0; i < sfi_mtimer_num;) {
+		if (mtmr->irq == sfi_mtimer_array[i].irq) {
+			sfi_mtimer_usage[i] = 0;
+			return;
+		}
+		i++;
+	}
+}
+
 /*
  * Moorestown specific x86_init function overrides and early setup
  * calls.
