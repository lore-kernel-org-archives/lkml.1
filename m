Return-Path: <linux-kernel-owner+w=401wt.eu-S1753643AbYJOPvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbYJOPvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 11:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbYJOPu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 11:50:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46672 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbYJOPu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 11:50:56 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/7] frv: use generic pci_enable_resources()
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       David Howells <dhowells@redhat.com>
Date: Wed, 15 Oct 2008 16:50:48 +0100
Message-ID: <20081015155048.2158.35981.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Use the generic pci_enable_resources() instead of the arch-specific code.

Unlike this arch-specific code, the generic version:
    - checks PCI_NUM_RESOURCES (11), not 6, resources
    - skips resources that have neither IORESOURCE_IO nor IORESOURCE_MEM set
    - skips ROM resources unless IORESOURCE_ROM_ENABLE is set
    - checks for resource collisions with "!r->parent"

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/mb93090-mb00/pci-frv.c |   32 --------------------------------
 arch/frv/mb93090-mb00/pci-frv.h |    1 -
 arch/frv/mb93090-mb00/pci-vdk.c |    2 +-
 3 files changed, 1 insertions(+), 34 deletions(-)


diff --git a/arch/frv/mb93090-mb00/pci-frv.c b/arch/frv/mb93090-mb00/pci-frv.c
index edae117..43d6753 100644
--- a/arch/frv/mb93090-mb00/pci-frv.c
+++ b/arch/frv/mb93090-mb00/pci-frv.c
@@ -201,38 +201,6 @@ void __init pcibios_resource_survey(void)
 	pcibios_assign_resources();
 }
 
-int pcibios_enable_resources(struct pci_dev *dev, int mask)
-{
-	u16 cmd, old_cmd;
-	int idx;
-	struct resource *r;
-
-	pci_read_config_word(dev, PCI_COMMAND, &cmd);
-	old_cmd = cmd;
-	for(idx=0; idx<6; idx++) {
-		/* Only set up the requested stuff */
-		if (!(mask & (1<<idx)))
-			continue;
-
-		r = &dev->resource[idx];
-		if (!r->start && r->end) {
-			printk(KERN_ERR "PCI: Device %s not available because of resource collisions\n", pci_name(dev));
-			return -EINVAL;
-		}
-		if (r->flags & IORESOURCE_IO)
-			cmd |= PCI_COMMAND_IO;
-		if (r->flags & IORESOURCE_MEM)
-			cmd |= PCI_COMMAND_MEMORY;
-	}
-	if (dev->resource[PCI_ROM_RESOURCE].start)
-		cmd |= PCI_COMMAND_MEMORY;
-	if (cmd != old_cmd) {
-		printk("PCI: Enabling device %s (%04x -> %04x)\n", pci_name(dev), old_cmd, cmd);
-		pci_write_config_word(dev, PCI_COMMAND, cmd);
-	}
-	return 0;
-}
-
 /*
  *  If we set up a device for bus mastering, we need to check the latency
  *  timer as certain crappy BIOSes forget to set it properly.
diff --git a/arch/frv/mb93090-mb00/pci-frv.h b/arch/frv/mb93090-mb00/pci-frv.h
index 0c7bf39..f3fe559 100644
--- a/arch/frv/mb93090-mb00/pci-frv.h
+++ b/arch/frv/mb93090-mb00/pci-frv.h
@@ -29,7 +29,6 @@ extern unsigned int __nongpreldata pci_probe;
 extern unsigned int pcibios_max_latency;
 
 void pcibios_resource_survey(void);
-int pcibios_enable_resources(struct pci_dev *, int);
 
 /* pci-vdk.c */
 
diff --git a/arch/frv/mb93090-mb00/pci-vdk.c b/arch/frv/mb93090-mb00/pci-vdk.c
index f003cfa..0f41c3a 100644
--- a/arch/frv/mb93090-mb00/pci-vdk.c
+++ b/arch/frv/mb93090-mb00/pci-vdk.c
@@ -412,7 +412,7 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
 {
 	int err;
 
-	if ((err = pcibios_enable_resources(dev, mask)) < 0)
+	if ((err = pci_enable_resources(dev, mask)) < 0)
 		return err;
 	if (!dev->msi_enabled)
 		pcibios_enable_irq(dev);

