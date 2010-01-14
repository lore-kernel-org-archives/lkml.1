Return-Path: <linux-kernel-owner+w=401wt.eu-S1757763Ab0ANWrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763Ab0ANWrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578Ab0ANWrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:47:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:56061 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394Ab0ANWrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:47:45 -0500
Message-ID: <4B4F9ECB.4060805@kernel.org>
Date: Thu, 14 Jan 2010 14:46:35 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Jeff Garrett <jeff@jgarrett.org>, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       David Airlie <airlied@linux.ie>
Subject: [PATCH] x86/pci: intel ioh need to subtract mmconf range
References: <20100113053736.GA6720@jgarrett.org> <20100113132407.GA11350@jgarrett.org> <4B4ECBCE.1010502@kernel.org> <201001141108.03129.bjorn.helgaas@hp.com>
In-Reply-To: <201001141108.03129.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Bjorn pointed out we need to remove mmconf range

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/intel_bus.c |   29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/pci/intel_bus.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/intel_bus.c
+++ linux-2.6/arch/x86/pci/intel_bus.c
@@ -46,6 +46,20 @@ static inline void print_ioh_resources(s
 
 #define RANGE_NUM 16
 
+static void __devinit subtract_mmconf(struct range *range, int nr)
+{
+#ifdef CONFIG_PCI_MMCONFIG
+	struct pci_mmcfg_region *cfg;
+
+	if (list_empty(&pci_mmcfg_list))
+		return;
+
+        list_for_each_entry(cfg, &pci_mmcfg_list, list)
+		subtract_range(range, nr, cfg->res.start,
+			 cfg->res.end + 1);
+#endif
+}
+
 static void __devinit pci_root_bus_res(struct pci_dev *dev)
 {
 	u16 word;
@@ -96,6 +110,7 @@ static void __devinit pci_root_bus_res(s
 
 		subtract_range(range, RANGE_NUM, vt_base, vt_end + 1);
 	}
+	subtract_mmconf(range, RANGE_NUM);
 	for (i = 0; i < RANGE_NUM; i++) {
 		if (!range[i].end)
 			continue;
@@ -112,8 +127,18 @@ static void __devinit pci_root_bus_res(s
 	mmioh_base |= ((u64)(dword & 0x7ffff)) << 32;
 	pci_read_config_dword(dev, IOH_LMMIOH_LIMITU, &dword);
 	mmioh_end |= ((u64)(dword & 0x7ffff)) << 32;
-	update_res(info, cap_resource(mmioh_base), cap_resource(mmioh_end),
-			 IORESOURCE_MEM, 0);
+	memset(range, 0, sizeof(range));
+	add_range(range, RANGE_NUM, 0, mmioh_base, mmioh_end + 1);
+	/* mmconf could be above 4g */
+	subtract_mmconf(range, RANGE_NUM);
+	for (i = 0; i < RANGE_NUM; i++) {
+		if (!range[i].end)
+			continue;
+
+		update_res(info, cap_resource(range[i].start),
+			   cap_resource(range[i].end - 1),
+			   IORESOURCE_MEM, 0);
+	}
 
 	print_ioh_resources(info);
 }
