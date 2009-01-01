Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbZAATGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbZAATGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 14:06:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbZAATGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 14:06:31 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:44959 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376AbZAATGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 14:06:30 -0500
Date: Thu, 1 Jan 2009 20:06:28 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       bluesmoke-devel@lists.sourceforge.net
Subject: [PATCH 2.6.28 3/3] EDAC: Add support for i82865P/PE chipsets
Message-ID: <20090101190628.GC22845@rere.qmqm.pl>
References: <20081223215030.GA32525@rere.qmqm.pl> <20090101190254.GA22845@rere.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090101190254.GA22845@rere.qmqm.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i82865P have the same registers as i82875P but without support for ECC
memory modules, so this change only allows to see some information from
/sys/devices/system/edac, but no memory errors will be detected.
Checked in chipset's datasheet and tested on HP nx9500 laptop.

This is a actually the same code as previous version. I resend it for
completeness, as it depends on previous patches in this series.

Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

--- tmp/drivers/edac/i82875p_edac.c	2008-12-07 13:02:32.000000000 +0100
+++ rechot/drivers/edac/i82875p_edac.c	2008-12-07 13:01:37.000000000 +0100
@@ -30,6 +30,10 @@
 #define i82875p_mc_printk(mci, level, fmt, arg...) \
 	edac_mc_chipset_printk(mci, level, "i82875p", fmt, ##arg)
 
+#ifndef PCI_DEVICE_ID_INTEL_82865_6
+#define PCI_DEVICE_ID_INTEL_82865_6	0x2576
+#endif				/* PCI_DEVICE_ID_INTEL_82865_6 */
+
 #ifndef PCI_DEVICE_ID_INTEL_82875_6
 #define PCI_DEVICE_ID_INTEL_82875_6	0x257e
 #endif				/* PCI_DEVICE_ID_INTEL_82875_6 */
@@ -150,6 +154,7 @@
 
 enum i82875p_chips {
 	I82875P = 0,
+	I82865P = 1,	/* this one lacks support for ECC memory */
 };
 
 struct i82875p_pvt {
@@ -159,6 +164,9 @@
 
 struct i82875p_dev_info {
 	const char *ctl_name;
+	unsigned long edac_ctl_cap;
+	void (*check)(struct mem_ctl_info *mci);
+	unsigned long drc_mask;	/* valid DRC register bits according to datasheet */
 };
 
 struct i82875p_error_info {
@@ -169,11 +177,6 @@
 	u16 errsts2;
 };
 
-static const struct i82875p_dev_info i82875p_devs[] = {
-	[I82875P] = {
-		.ctl_name = "i82875p"},
-};
-
 static struct edac_pci_ctl_info *i82875p_pci;
 
 static void i82875p_get_error_info(struct mem_ctl_info *mci,
@@ -253,6 +256,26 @@
 	i82875p_process_error_info(mci, &info, 1);
 }
 
+static void i82865p_check(struct mem_ctl_info *mci)
+{
+}
+
+static const struct i82875p_dev_info i82875p_devs[] = {
+	[I82875P] = {
+		.ctl_name = "i82875p",
+		.edac_ctl_cap = EDAC_FLAG_NONE|EDAC_FLAG_SECDED,
+		.check = i82875p_check,
+		.drc_mask = 0x20660773,
+	},
+	[I82865P] = {
+		.ctl_name = "i82865p",
+		.edac_ctl_cap = EDAC_FLAG_NONE,
+		.check = i82865p_check,
+		.drc_mask = 0x20600773,
+	},
+};
+
+
 /* Return 1 if dual channel mode is active.  Else return 0. */
 static inline int dual_channel_active(u32 drc)
 {
@@ -318,7 +341,7 @@
 	if (!ovrfl_window)
 		return -EBUSY;
 
-	drc = readl(ovrfl_window + I82875P_DRC);
+	drc = readl(ovrfl_window + I82875P_DRC) & i82875p_devs[dev_idx].drc_mask;
 	nr_chans = dual_channel_active(drc) + 1;
 	mci = edac_mc_alloc(sizeof(*pvt), I82875P_NR_CSROWS(nr_chans),
 			nr_chans, 0);
@@ -334,13 +357,13 @@
 	debugf3("%s(): init mci\n", __func__);
 	mci->dev = &ovrfl_pdev->dev;
 	mci->mtype_cap = MEM_FLAG_DDR;
-	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED;
+	mci->edac_ctl_cap = i82875p_devs[dev_idx].edac_ctl_cap;
 	mci->edac_cap = EDAC_FLAG_UNKNOWN;
 	mci->mod_name = EDAC_MOD_STR;
 	mci->mod_ver = I82875P_REVISION;
 	mci->ctl_name = i82875p_devs[dev_idx].ctl_name;
 	mci->dev_name = pci_name(mci_pdev);
-	mci->edac_check = i82875p_check;
+	mci->edac_check = i82875p_devs[dev_idx].check;
 	mci->ctl_page_to_phys = NULL;
 
 	debugf3("%s(): init pvt\n", __func__);
@@ -429,8 +452,6 @@
 
 static void __devexit i82875p_remove_one(struct pci_dev *pdev)
 {
-	int mci_devfn = PCI_DEVFN(PCI_SLOT(pdev->devfn), 0);
-	struct pci_dev *mci_pdev;
 	struct mem_ctl_info *mci;
 	struct i82875p_pvt *pvt;
 
@@ -454,6 +475,7 @@
 
 static DEFINE_PCI_DEVICE_TABLE(i82875p_pci_tbl) = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82875_6), I82875P },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82865_6), I82865P },
 	{ 0, }	 	/* 0 terminated list. */
 };
 
