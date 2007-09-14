Return-Path: <linux-kernel-owner+w=401wt.eu-S1756870AbXINLOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870AbXINLOO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 07:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbXINLN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 07:13:59 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:53437 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbXINLN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 07:13:59 -0400
Date: Fri, 14 Sep 2007 15:14:01 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Greg KH <gregkh@suse.de>, Matthew Wilcox <matthew@wil.cx>,
       Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH]PCI:disable resource decode in PCI BAR detection
Message-ID: <20070914151401.A5586@jurassic.park.msu.ru>
References: <fa.ggBqx6W3i6hfs6jdfg64oXKSxW8@ifi.uio.no> <fa.o5cJ0O7pLVWRzUiVPDEZL6nKqA8@ifi.uio.no> <fa.tyYt4GOpTOmJTUbzsxpiCAObJPQ@ifi.uio.no> <fa.13eJumylqINOxOaoEj9cthw0d0M@ifi.uio.no> <fa.tAIuIM02CoL+ixB11n9Fmcqyz9M@ifi.uio.no> <fa.pxFYhTaUz2NVN7Vux7b5xVRrKTw@ifi.uio.no> <46EA00DA.6010704@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <46EA00DA.6010704@shaw.ca>; from hancockr@shaw.ca on Thu, Sep 13, 2007 at 09:32:42PM -0600
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 09:32:42PM -0600, Robert Hancock wrote:
> Disabling the BAR decoding does not mean disabling the device (aside 
> from the one  group of host bridge that apparently disables CPU to RAM 
> access, whose designers were apparently on crack when they read the PCI 
> spec and which is why we don't disable the decode on host bridges). 
> There really is no other sane way to do it.

Disabling IO and MEM decode effectively disables device as a PCI target.
Worse, it's often not just BARs that get disabled, but some non-standard
or hidden address ranges as well. Host bridges are just one common
example, there is a lot of other insane hardware, more than one could
expect.
BTW, the way how the internal address decode works on these latest Intel
whippets doesn't look sane either. ;-)

> If we do encounter other devices that choke on having the BAR disabled 
> during probing then we can add additional quirk logic, but we haven't 
> run into anything like that yet.

As Greg said, the main point is "no regression".

Folks, can you check if the patch below helps?

Ivan.

--- 2.6.23-rc6-git4/include/linux/pci.h	2007-09-12 17:22:57.000000000 +0400
+++ linux/include/linux/pci.h	2007-09-14 10:26:29.000000000 +0400
@@ -183,6 +183,7 @@ struct pci_dev {
 	unsigned int 	msi_enabled:1;
 	unsigned int	msix_enabled:1;
 	unsigned int	is_managed:1;
+	unsigned int	disable_while_probe:1; /* Probe BARs with IO and MMIO turned off */
 	atomic_t	enable_cnt;	/* pci_enable_device has been called */
 
 	u32		saved_config_space[16]; /* config space saved at suspend time */
--- 2.6.23-rc6-git4/arch/i386/pci/fixup.c	2007-09-12 17:22:55.000000000 +0400
+++ linux/arch/i386/pci/fixup.c	2007-09-14 14:43:13.000000000 +0400
@@ -444,3 +444,21 @@ static void __devinit pci_siemens_interr
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SIEMENS, 0x0015,
 			  pci_siemens_interrupt_controller);
+
+/*
+ * Work around apparent quirk in internal address decoding on
+ * some Intel chipsets (G31, G33, Q965 etc.): 
+ * when some MMIO address range of integrated peripheral overlaps
+ * mmconfig area, mmconfig accesses are blocked. This can happen
+ * when we size the BAR writing all ones to it.
+ * In practice, only integrated graphics controller has MMIO range
+ * large enough (BAR2, 256Mb) to cause a trouble, so we disable
+ * address decoders just on that function during PCI BAR probe.
+ */
+static void __devinit pci_intel_mmconfig(struct pci_dev *dev)
+{
+	if ((dev->class >> 8) == PCI_CLASS_DISPLAY_VGA &&
+	    pci_domain_nr(dev->bus) == 0 && dev->bus->number == 0)
+		dev->disable_while_probe = 1;
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_ANY_ID, pci_intel_mmconfig);
--- 2.6.23-rc6-git4/drivers/pci/probe.c	2007-09-14 00:35:47.000000000 +0400
+++ linux/drivers/pci/probe.c	2007-09-14 10:27:45.000000000 +0400
@@ -185,6 +185,13 @@ static void pci_read_bases(struct pci_de
 	unsigned int pos, reg, next;
 	u32 l, sz;
 	struct resource *res;
+	u16 cmd, orig_cmd;
+
+	if (dev->disable_while_probe) {
+		pci_read_config_word(dev, PCI_COMMAND, &orig_cmd);
+		cmd |= orig_cmd & ~(PCI_COMMAND_MEMORY | PCI_COMMAND_IO);
+		pci_write_config_word(dev, PCI_COMMAND, cmd);
+	}
 
 	for(pos=0; pos<howmany; pos = next) {
 		u64 l64;
@@ -283,6 +290,8 @@ static void pci_read_bases(struct pci_de
 			}
 		}
 	}
+	if (dev->disable_while_probe)
+		pci_write_config_word(dev, PCI_COMMAND, orig_cmd);
 }
 
 void pci_read_bridge_bases(struct pci_bus *child)
