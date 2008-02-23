Return-Path: <linux-kernel-owner+w=401wt.eu-S937339AbYBWApA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937339AbYBWApA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:45:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933379AbYBWAfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:35:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:55605 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765759AbYBWAfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:35:22 -0500
Date: Fri, 22 Feb 2008 16:31:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [patch 24/38] Disable G5 NAP mode during SMU commands on U3
Message-ID: <20080223003106.GY7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="disable-g5-nap-mode-during-smu-commands-on-u3.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

patch 592a607bbc053bc6f614a0e619326009f4b3829e in mainline.

It appears that with the U3 northbridge, if the processor is in NAP
mode the whole time while waiting for an SMU command to complete,
then the SMU will fail.  It could be related to the weird backward
mechanism the SMU uses to get to system memory via i2c to the
northbridge that doesn't operate properly when the said bridge is
in napping along with the CPU.  That is on U3 at least, U4 doesn't
seem to be affected.

This didn't show before NO_HZ as the timer wakeup was enough to make
it work it seems, but that is no longer the case.

This fixes it by disabling NAP mode on those machines while
an SMU command is in flight.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/platforms/powermac/feature.c |   11 ++++++++++-
 drivers/macintosh/smu.c                   |   25 ++++++++++++++++++++++++-
 include/asm-powerpc/pmac_feature.h        |    8 ++++++++
 3 files changed, 42 insertions(+), 2 deletions(-)

--- a/arch/powerpc/platforms/powermac/feature.c
+++ b/arch/powerpc/platforms/powermac/feature.c
@@ -2565,6 +2565,8 @@ static void __init probe_uninorth(void)
 
 	/* Locate core99 Uni-N */
 	uninorth_node = of_find_node_by_name(NULL, "uni-n");
+	uninorth_maj = 1;
+
 	/* Locate G5 u3 */
 	if (uninorth_node == NULL) {
 		uninorth_node = of_find_node_by_name(NULL, "u3");
@@ -2575,8 +2577,10 @@ static void __init probe_uninorth(void)
 		uninorth_node = of_find_node_by_name(NULL, "u4");
 		uninorth_maj = 4;
 	}
-	if (uninorth_node == NULL)
+	if (uninorth_node == NULL) {
+		uninorth_maj = 0;
 		return;
+	}
 
 	addrp = of_get_property(uninorth_node, "reg", NULL);
 	if (addrp == NULL)
@@ -3029,3 +3033,8 @@ void pmac_resume_agp_for_card(struct pci
 	pmac_agp_resume(pmac_agp_bridge);
 }
 EXPORT_SYMBOL(pmac_resume_agp_for_card);
+
+int pmac_get_uninorth_variant(void)
+{
+	return uninorth_maj;
+}
--- a/drivers/macintosh/smu.c
+++ b/drivers/macintosh/smu.c
@@ -85,6 +85,7 @@ struct smu_device {
 	u32			cmd_buf_abs;	/* command buffer absolute */
 	struct list_head	cmd_list;
 	struct smu_cmd		*cmd_cur;	/* pending command */
+	int			broken_nap;
 	struct list_head	cmd_i2c_list;
 	struct smu_i2c_cmd	*cmd_i2c_cur;	/* pending i2c command */
 	struct timer_list	i2c_timer;
@@ -135,6 +136,19 @@ static void smu_start_cmd(void)
 	fend = faddr + smu->cmd_buf->length + 2;
 	flush_inval_dcache_range(faddr, fend);
 
+
+	/* We also disable NAP mode for the duration of the command
+	 * on U3 based machines.
+	 * This is slightly racy as it can be written back to 1 by a sysctl
+	 * but that never happens in practice. There seem to be an issue with
+	 * U3 based machines such as the iMac G5 where napping for the
+	 * whole duration of the command prevents the SMU from fetching it
+	 * from memory. This might be related to the strange i2c based
+	 * mechanism the SMU uses to access memory.
+	 */
+	if (smu->broken_nap)
+		powersave_nap = 0;
+
 	/* This isn't exactly a DMA mapping here, I suspect
 	 * the SMU is actually communicating with us via i2c to the
 	 * northbridge or the CPU to access RAM.
@@ -211,6 +225,10 @@ static irqreturn_t smu_db_intr(int irq, 
 	misc = cmd->misc;
 	mb();
 	cmd->status = rc;
+
+	/* Re-enable NAP mode */
+	if (smu->broken_nap)
+		powersave_nap = 1;
  bail:
 	/* Start next command if any */
 	smu_start_cmd();
@@ -461,7 +479,7 @@ int __init smu_init (void)
         if (np == NULL)
 		return -ENODEV;
 
-	printk(KERN_INFO "SMU driver %s %s\n", VERSION, AUTHOR);
+	printk(KERN_INFO "SMU: Driver %s %s\n", VERSION, AUTHOR);
 
 	if (smu_cmdbuf_abs == 0) {
 		printk(KERN_ERR "SMU: Command buffer not allocated !\n");
@@ -533,6 +551,11 @@ int __init smu_init (void)
 		goto fail;
 	}
 
+	/* U3 has an issue with NAP mode when issuing SMU commands */
+	smu->broken_nap = pmac_get_uninorth_variant() < 4;
+	if (smu->broken_nap)
+		printk(KERN_INFO "SMU: using NAP mode workaround\n");
+
 	sys_ctrler = SYS_CTRLER_SMU;
 	return 0;
 
--- a/include/asm-powerpc/pmac_feature.h
+++ b/include/asm-powerpc/pmac_feature.h
@@ -392,6 +392,14 @@ extern u32 __iomem *uninorth_base;
 #define UN_BIS(r,v)	(UN_OUT((r), UN_IN(r) | (v)))
 #define UN_BIC(r,v)	(UN_OUT((r), UN_IN(r) & ~(v)))
 
+/* Uninorth variant:
+ *
+ * 0 = not uninorth
+ * 1 = U1.x or U2.x
+ * 3 = U3
+ * 4 = U4
+ */
+extern int pmac_get_uninorth_variant(void);
 
 #endif /* __ASM_POWERPC_PMAC_FEATURE_H */
 #endif /* __KERNEL__ */

-- 
