Return-Path: <linux-kernel-owner+w=401wt.eu-S1757993AbXFLBzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbXFLBzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 21:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757103AbXFLBzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 21:55:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:7780 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756981AbXFLBzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 21:55:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,409,1175497200"; 
   d="scan'208";a="255767013"
Date: Tue, 12 Jun 2007 09:54:59 +0800
From: Wang Zhenyu <zhenyu.z.wang@intel.com>
To: Dave Jones <davej@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, andi@rhlx01.fht-esslingen.de,
       Keith Packard <keithp@keithp.com>
Subject: [RFC][AGPGART]intel-agp: save whole config space in suspend/resume
Message-ID: <20070612015459.GB28668@zhen-devel.sh.intel.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>, andi@rhlx01.fht-esslingen.de,
	Keith Packard <keithp@keithp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.15-1.2054_FC5smp i686
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Dave,

It looks that config space save/restore for intel-agp still has problem
that might affect some chip models. Andreas Mohr's work on his i815 suspend/resume
support showed that we need to save extra bits in config space on this old chip type. 
His patch is in -mm tree, http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm2/broken-out/working-3d-dri-intel-agpko-resume-for-i815-chip.patch

And recently James Bottomley also reported that save/restore whole 256 bytes config 
space for gfx device can fix his s3 issue on Fujitsu P7120 i915. 
http://lists.freedesktop.org/archives/xorg/2007-June/025346.html

So here's my suggested patch for save whole 256 bytes config space for intel-agp,
which could fix these issues. I tested it on my 965GM, that s3 works fine with X. 

This patch bases on latest kernel git and my intel-agp patch set on agpgart.git tip.
http://git.kernel.org/?p=linux/kernel/git/davej/agpgart.git;a=summary


Signed-off-by: Wang Zhenyu <zhenyu.z.wang@intel.com>
---
 drivers/char/agp/intel-agp.c |   44 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 43 insertions(+), 1 deletions(-)

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index d383168..bc18241 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -110,6 +110,7 @@ static struct _intel_private {
 	 * popup and for the GTT.
 	 */
 	int gtt_entries;			/* i830+ */
+	u32 extra_saved_config[48];	/* suspend/resume */
 } intel_private;
 
 static int intel_i810_fetch_size(void)
@@ -1974,9 +1975,33 @@ static void __devexit agp_intel_remove(struct pci_dev *pdev)
 }
 
 #ifdef CONFIG_PM
+static int agp_intel_suspend (struct pci_dev *pdev, pm_message_t state)
+{
+	int i;
+
+	pci_save_state(pdev);
+
+	if (intel_private.pcidev) {
+		pci_save_state(intel_private.pcidev);
+
+		for (i = 0; i < 48; i++)
+			pci_read_config_dword(intel_private.pcidev, i*4+64,
+				&intel_private.extra_saved_config[i]);
+
+		pci_set_power_state(intel_private.pcidev,
+			pci_choose_state(intel_private.pcidev, state));
+	}
+
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+
+	return 0;
+}
+
 static int agp_intel_resume(struct pci_dev *pdev)
 {
 	struct agp_bridge_data *bridge = pci_get_drvdata(pdev);
+	int i = 0;
+	u32 val;
 
 	pci_restore_state(pdev);
 
@@ -1984,8 +2009,24 @@ static int agp_intel_resume(struct pci_dev *pdev)
 	 * as host bridge (00:00) resumes before graphics device (02:00),
 	 * then our access to its pci space can work right.
 	 */
-	if (intel_private.pcidev)
+	if (intel_private.pcidev) {
+		pci_set_power_state(intel_private.pcidev, PCI_D0);
 		pci_restore_state(intel_private.pcidev);
+		for (i = 0; i < 48; i++) {
+			pci_read_config_dword(intel_private.pcidev, i*4+64,
+						&val);
+			if (val != intel_private.extra_saved_config[i]) {
+				printk(KERN_DEBUG "intel-agp: Writing back"
+					"config space at offset %x"
+					" (was %x, writing %x)\n",
+					i*4+64, val,
+					intel_private.extra_saved_config[i]);
+				pci_write_config_dword(intel_private.pcidev,
+					i*4+64,
+					intel_private.extra_saved_config[i]);
+			}
+		}
+	}
 
 	if (bridge->driver == &intel_generic_driver)
 		intel_configure();
@@ -2062,6 +2103,7 @@ static struct pci_driver agp_intel_pci_driver = {
 	.probe		= agp_intel_probe,
 	.remove		= __devexit_p(agp_intel_remove),
 #ifdef CONFIG_PM
+	.suspend	= agp_intel_suspend,
 	.resume		= agp_intel_resume,
 #endif
 };
-- 
1.4.4.4
