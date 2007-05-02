Return-Path: <linux-kernel-owner+w=401wt.eu-S2992589AbXEBAuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992589AbXEBAuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 20:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992614AbXEBAuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 20:50:16 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:1823 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992589AbXEBAuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 20:50:13 -0400
Date: Wed, 2 May 2007 02:50:11 +0200
From: Olivier Galibert <galibert@pobox.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de,
       greg@kroah.com, jesse.barnes@intel.com
Subject: [PATCH] mmconfig: Some additional chipset register values validation.
Message-ID: <20070502005011.GA41935@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de,
	greg@kroah.com, jesse.barnes@intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On i945, a mmconfig range hitting the f0000000-ffffffff zone conflicts
with the APIC registers and others.  Consider it invalid.

On E7520, values 0000 and f000 for the window register are defined
invalid in the documentation.

---

I haven't seen a bios use these values, but who trusts biosen these
days?


 arch/i386/pci/mmconfig-shared.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/arch/i386/pci/mmconfig-shared.c b/arch/i386/pci/mmconfig-shared.c
index 747d8c6..c7cabee 100644
--- a/arch/i386/pci/mmconfig-shared.c
+++ b/arch/i386/pci/mmconfig-shared.c
@@ -60,14 +60,19 @@ static const char __init *pci_mmcfg_e7520(void)
 	u32 win;
 	pci_conf1_read(0, 0, PCI_DEVFN(0,0), 0xce, 2, &win);
 
-	pci_mmcfg_config_num = 1;
-	pci_mmcfg_config = kzalloc(sizeof(pci_mmcfg_config[0]), GFP_KERNEL);
-	if (!pci_mmcfg_config)
-		return NULL;
-	pci_mmcfg_config[0].address = (win & 0xf000) << 16;
-	pci_mmcfg_config[0].pci_segment = 0;
-	pci_mmcfg_config[0].start_bus_number = 0;
-	pci_mmcfg_config[0].end_bus_number = 255;
+	win = win & 0xf000;
+	if(win == 0x0000 || win == 0xf000)
+		pci_mmcfg_config_num = 0;
+	else {
+		pci_mmcfg_config_num = 1;
+		pci_mmcfg_config = kzalloc(sizeof(pci_mmcfg_config[0]), GFP_KERNEL);
+		if (!pci_mmcfg_config)
+			return NULL;
+		pci_mmcfg_config[0].address = win << 16;
+		pci_mmcfg_config[0].pci_segment = 0;
+		pci_mmcfg_config[0].start_bus_number = 0;
+		pci_mmcfg_config[0].end_bus_number = 255;
+	}
 
 	return "Intel Corporation E7520 Memory Controller Hub";
 }
@@ -108,6 +113,10 @@ static const char __init *pci_mmcfg_intel_945(void)
 	if ((pciexbar & mask) & 0x0fffffffU)
 		pci_mmcfg_config_num = 0;
 
+	/* Don't hit the APIC registers and their friends */
+	if ((pciexbar & mask) >= 0xf0000000U)
+		pci_mmcfg_config_num = 0;
+
 	if (pci_mmcfg_config_num) {
 		pci_mmcfg_config = kzalloc(sizeof(pci_mmcfg_config[0]), GFP_KERNEL);
 		if (!pci_mmcfg_config)
-- 
1.5.1.81.gee969

