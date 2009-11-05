Return-Path: <linux-kernel-owner+w=401wt.eu-S1758624AbZKES7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624AbZKES7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 13:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758500AbZKES7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 13:59:23 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:45882 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758589AbZKES7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:59:22 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: [PATCH] pci/pcie: Avoid unnecessary PCIe link retrains
Date: Thu, 5 Nov 2009 12:59:25 -0600
User-Agent: KMail/1.9.10
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, rdh@east.sun.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
References: <19184.41676.262206.134000@gargle.gargle.HOWL> <200911041628.17905.bjorn.helgaas@hp.com> <4AF240E7.8050200@jp.fujitsu.com>
In-Reply-To: <4AF240E7.8050200@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911051159.26046.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009 08:05:11 pm Kenji Kaneshige wrote:
> Bjorn Helgaas wrote:
> > On Wednesday 04 November 2009 12:03:21 pm Jesse Barnes wrote:
> >> [Cc'ing linux-pci@vger.kernel.org too]
> >>
> >> On Tue, 3 Nov 2009 16:38:20 -0500
> >> RDH <rdh@east.sun.com> wrote:

> >>> +	/* Check upstream component for Common Clock Config */
> >>> +	pci_read_config_word(parent, ppos + PCI_EXP_LNKCTL, &reg16);
> >>> +	lnkctl_ccc_and = lnkctl_ccc_or = (reg16 &
> >>> PCI_EXP_LNKCTL_CCC); +
> >>> +	/* Scan downstream component for CCC, all functions */
> >>> +	list_for_each_entry(child, &linkbus->devices, bus_list) {
> >>> +		cpos = pci_find_capability(child, PCI_CAP_ID_EXP);
> > 
> > Some other places in pcie/aspm (e.g., pcie_set_clkpm_nocheck() and
> > pcie_clkpm_cap_init()) check cpos for NULL.  Your code looks
> > superficially similar, so maybe you should check it, too, although
> > I do see many other place in aspm where we *don't* check it.
> > 
> > We look up this capability so often, I wonder if we should save it
> > in the struct pci_dev or struct pcie_link or something in such a
> > way that if we have a struct pcie_link, we are guaranteed that there
> > is a PCIe capability, and we don't have to search for it again.
> > 
> 
> I agree. There are a lot of codes using pci_find_capability() to
> search PCIe capability offset in addition to ASPM driver. So I
> think it's good idea to have PCIe cap offset in struct pci_dev.
> 
> To be honest, I have already made a following patch to add a new
> field into struct pci_dev and some other patches to use this new
> field a few months ago. But I have never posted them yet. If it
> is a right direction, I would like to update and post them soon.
> 
> Thanks,
> Kenji Kaneshige
> 
> 
> There are a lot of codes that searches PCI express capability offset
> in the PCI configuration space using pci_find_capability(). Caching it
> in the struct pci_dev will reduce unncecessary search. This patch adds
> an additional 'pcie_cap' fields into struct pci_dev, which is
> initialized at pci device scan time (in set_pcie_port_type()).
> 
> Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> 
> ---
>  drivers/pci/probe.c |    1 +
>  include/linux/pci.h |    1 +
>  2 files changed, 2 insertions(+)
> 
> Index: 20090825/drivers/pci/probe.c
> ===================================================================
> --- 20090825.orig/drivers/pci/probe.c
> +++ 20090825/drivers/pci/probe.c
> @@ -693,6 +693,7 @@ static void set_pcie_port_type(struct pc
>  	if (!pos)
>  		return;
>  	pdev->is_pcie = 1;
> +	pdev->pcie_cap = pos;
>  	pci_read_config_word(pdev, pos + PCI_EXP_FLAGS, &reg16);
>  	pdev->pcie_type = (reg16 & PCI_EXP_FLAGS_TYPE) >> 4;
>  }
> Index: 20090825/include/linux/pci.h
> ===================================================================
> --- 20090825.orig/include/linux/pci.h
> +++ 20090825/include/linux/pci.h
> @@ -218,6 +218,7 @@ struct pci_dev {
>  	unsigned int	class;		/* 3 bytes: (base,sub,prog-if) */
>  	u8		revision;	/* PCI revision, low byte of class word */
>  	u8		hdr_type;	/* PCI header type (`multi' flag masked out) */
> +	u8		pcie_cap;	/* PCI-E capability offset */
>  	u8		pcie_type;	/* PCI-E device/port type */
>  	u8		rom_base_reg;	/* which config register controls the ROM */
>  	u8		pin;  		/* which interrupt pin this device uses */
> 

Here's another possibility, the idea being to collect all the PCIe
stuff in one place.  This would require a lot of changes in the PCIe
driver code, but most of them would be trivial.


diff --git a/include/linux/pci.h b/include/linux/pci.h
index f5c7cd3..29272ab 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -198,6 +198,14 @@ struct pci_vpd;
 struct pci_sriov;
 struct pci_ats;
 
+struct pcie_dev {
+#ifdef CONFIG_PCIEASPM
+	struct pcie_link_state	*link_state;	/* ASPM link state. */
+#endif
+	u8		cap;	/* PCI-E capability offset */
+	u8		type;	/* PCI-E device/port type */
+};
+
 /*
  * The pci_dev structure is used to describe PCI devices.
  */
@@ -218,7 +226,6 @@ struct pci_dev {
 	unsigned int	class;		/* 3 bytes: (base,sub,prog-if) */
 	u8		revision;	/* PCI revision, low byte of class word */
 	u8		hdr_type;	/* PCI header type (`multi' flag masked out) */
-	u8		pcie_type;	/* PCI-E device/port type */
 	u8		rom_base_reg;	/* which config register controls the ROM */
 	u8		pin;  		/* which interrupt pin this device uses */
 
@@ -243,10 +250,6 @@ struct pci_dev {
 	unsigned int	no_d1d2:1;	/* Only allow D0 and D3 */
 	unsigned int	wakeup_prepared:1;
 
-#ifdef CONFIG_PCIEASPM
-	struct pcie_link_state	*link_state;	/* ASPM link state. */
-#endif
-
 	pci_channel_state_t error_state;	/* current connectivity state */
 	struct	device	dev;		/* Generic device interface */
 
@@ -273,7 +276,6 @@ struct pci_dev {
 	unsigned int	msix_enabled:1;
 	unsigned int	ari_enabled:1;	/* ARI forwarding */
 	unsigned int	is_managed:1;
-	unsigned int	is_pcie:1;
 	unsigned int    needs_freset:1; /* Dev requires fundamental reset */
 	unsigned int	state_saved:1;
 	unsigned int	is_physfn:1;
@@ -293,6 +295,7 @@ struct pci_dev {
 	struct list_head msi_list;
 #endif
 	struct pci_vpd *vpd;
+	struct pci_pcie *pcie;
 #ifdef CONFIG_PCI_IOV
 	union {
 		struct pci_sriov *sriov;	/* SR-IOV capability related */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 5c4ce1b..f85f2e7 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -684,13 +684,21 @@ static void set_pcie_port_type(struct pci_dev *pdev)
 {
 	int pos;
 	u16 reg16;
+	struct pcie_dev *pcie;
 
 	pos = pci_find_capability(pdev, PCI_CAP_ID_EXP);
 	if (!pos)
 		return;
-	pdev->is_pcie = 1;
+
+	pcie = kzalloc(sizeof(struct pci_dev), GFP_KERNEL);
+	if (!pcie)
+		return;
+
 	pci_read_config_word(pdev, pos + PCI_EXP_FLAGS, &reg16);
-	pdev->pcie_type = (reg16 & PCI_EXP_FLAGS_TYPE) >> 4;
+
+	pcie->type = (reg16 & PCI_EXP_FLAGS_TYPE) >> 4;
+	pcie->cap = pos;
+	pdev->pcie = pcie;
 }
 
 static void set_pcie_hotplug_bridge(struct pci_dev *pdev)

