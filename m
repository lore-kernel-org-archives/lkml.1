Return-Path: <linux-kernel-owner+w=401wt.eu-S1763953AbYCEHFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763953AbYCEHFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 02:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760757AbYCEHFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 02:05:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36230 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760243AbYCEHFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 02:05:35 -0500
Date: Wed, 5 Mar 2008 08:05:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86_64: set cfg_size for AMD Family 10h in case MMCONFIG
	should be material for 2.6.25
Message-ID: <20080305070521.GB32434@elte.hu>
References: <86802c440803042104p77f44d5fnd4aeb86e21ec8c66@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440803042104p77f44d5fnd4aeb86e21ec8c66@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> Ingo/greg,
> 
> one patch in x86.git#testing
> 
>     x86_64: set cfg_size for AMD Family 10h in case MMCONFIG
> 
>     reuse pci_cfg_space_size but skip check pci express and pci-x CAP ID.
> 
> should be get into 2.6.25. instead of waiting for 2.6.26
> 
> it just one quirk to update AMD fam10h cfg_size if MMCONFIG is there.
> 
> otherwise lspci -vvxxxx still report 512 for those NB.

i have no objections and the patch has been in the tree for some time. 
Greg, if you agree, could you send it to Linus. (or i can do it too if 
you Ack the change)

	Ingo

------------------->
Subject: x86_64: set cfg_size for AMD Family 10h in case MMCONFIG
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Date: Fri, 15 Feb 2008 01:32:50 -0800

reuse pci_cfg_space_size but skip check pci express and pci-x CAP ID.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
===================================================================
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/pci/fixup.c |   17 +++++++++++++++++
 drivers/pci/probe.c  |   11 ++++++++++-
 include/linux/pci.h  |    1 +
 3 files changed, 28 insertions(+), 1 deletion(-)

Index: linux-x86.q/arch/x86/pci/fixup.c
===================================================================
--- linux-x86.q.orig/arch/x86/pci/fixup.c
+++ linux-x86.q/arch/x86/pci/fixup.c
@@ -493,3 +493,20 @@ static void __devinit pci_siemens_interr
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SIEMENS, 0x0015,
 			  pci_siemens_interrupt_controller);
+
+/*
+ * Regular PCI devices have 256 bytes, but AMD Family 10h Opteron ext config
+ * have 4096 bytes.  Even if the device is capable, that doesn't mean we can
+ * access it.  Maybe we don't have a way to generate extended config space
+ * accesses.   So check it
+ */
+static void fam10h_pci_cfg_space_size(struct pci_dev *dev)
+{
+	dev->cfg_size = pci_cfg_space_size_ext(dev, 0);
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1200, fam10h_pci_cfg_space_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1201, fam10h_pci_cfg_space_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1202, fam10h_pci_cfg_space_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1203, fam10h_pci_cfg_space_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1204, fam10h_pci_cfg_space_size);
Index: linux-x86.q/drivers/pci/probe.c
===================================================================
--- linux-x86.q.orig/drivers/pci/probe.c
+++ linux-x86.q/drivers/pci/probe.c
@@ -809,11 +809,14 @@ static void set_pcie_port_type(struct pc
  * reading the dword at 0x100 which must either be 0 or a valid extended
  * capability header.
  */
-int pci_cfg_space_size(struct pci_dev *dev)
+int pci_cfg_space_size_ext(struct pci_dev *dev, unsigned check_exp_pcix)
 {
 	int pos;
 	u32 status;
 
+	if (!check_exp_pcix)
+		goto skip;
+
 	pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
 	if (!pos) {
 		pos = pci_find_capability(dev, PCI_CAP_ID_PCIX);
@@ -825,6 +828,7 @@ int pci_cfg_space_size(struct pci_dev *d
 			goto fail;
 	}
 
+ skip:
 	if (pci_read_config_dword(dev, 256, &status) != PCIBIOS_SUCCESSFUL)
 		goto fail;
 	if (status == 0xffffffff)
@@ -836,6 +840,11 @@ int pci_cfg_space_size(struct pci_dev *d
 	return PCI_CFG_SPACE_SIZE;
 }
 
+int pci_cfg_space_size(struct pci_dev *dev)
+{
+	return pci_cfg_space_size_ext(dev, 1);
+}
+
 static void pci_release_bus_bridge_dev(struct device *dev)
 {
 	kfree(dev);
Index: linux-x86.q/include/linux/pci.h
===================================================================
--- linux-x86.q.orig/include/linux/pci.h
+++ linux-x86.q/include/linux/pci.h
@@ -654,6 +654,7 @@ int pci_scan_bridge(struct pci_bus *bus,
 
 void pci_walk_bus(struct pci_bus *top, void (*cb)(struct pci_dev *, void *),
 		  void *userdata);
+int pci_cfg_space_size_ext(struct pci_dev *dev, unsigned check_exp_pcix);
 int pci_cfg_space_size(struct pci_dev *dev);
 unsigned char pci_bus_max_busnr(struct pci_bus *bus);
 
