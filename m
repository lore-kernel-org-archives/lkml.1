Return-Path: <linux-kernel-owner+w=401wt.eu-S1752507AbZAZGV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbZAZGV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 01:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbZAZGVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 01:21:46 -0500
Received: from colo.lackof.org ([198.49.126.79]:58677 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbZAZGVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 01:21:45 -0500
Date: Sun, 25 Jan 2009 23:21:32 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       "Barnes, Jesse" <jesse.barnes@intel.com>, shaohua.li@intel.com
Subject: Re: ACPI hotplug panic with current git head
Message-ID: <20090126062132.GC4376@colo.lackof.org>
References: <alpine.LFD.2.00.0901151421110.4737@localhost.localdomain> <1232049269.5966.64.camel@localhost.localdomain> <1232050347.5966.66.camel@localhost.localdomain> <4970242C.4010404@jp.fujitsu.com> <1232115546.3224.5.camel@localhost.localdomain> <4973D2EE.3060203@jp.fujitsu.com> <1232328216.3247.68.camel@localhost.localdomain> <4973EF64.2050404@jp.fujitsu.com> <1232558780.736.24.camel@localhost.localdomain> <497D1BD7.9000609@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497D1BD7.9000609@jp.fujitsu.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 11:11:35AM +0900, Kenji Kaneshige wrote:
...
> Thanks to you, I found the root cause of the
> problem. The acpi_pci_get_bridge_handle() function assumes
> pci_bus->self is NULL on the root bus.

Mea culpa: I contributed this mess too. This worked for PA-RISC
and lacking better guidance, is what I used in 1/2 the places.

> But it is not true
> and pci_bus->self can have a non-NULL value on some
> platfroms (like yours). So it must check pci_bus->parent
> instead.

It is true for PA-RISC and some other architectures.
These architectures don't provide fake PCI devices
(emulated PCI config space) for Host-PCI Bus controllers.

> I found some other code that has the same wrong assumption.
> I'll make a fix for them and send it soon.

I would like to keep the code consistent. Attached is a patch
for drivers/parisc. Please include with my
    Signed-off-by: Grant Grundler <grundler@parisc-linux.org>

Or if you prefer, I can repost as a separate patch.

I've compiled the iosapic/lba changes and will test those shortly.
I have no HW (by choice) to test the dino code change.

thanks,
grant


diff --git a/drivers/parisc/dino.c b/drivers/parisc/dino.c
index d539d9d..f79266c 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -587,7 +587,7 @@ dino_fixup_bus(struct pci_bus *bus)
 			bus->resource[i+1] = &res[i];
 		}
 
-	} else if(bus->self) {
+	} else if (bus->parent) {
 		int i;
 
 		pci_read_bridge_bases(bus);
diff --git a/drivers/parisc/iosapic.c b/drivers/parisc/iosapic.c
index 0797659..1cdfdea 100644
--- a/drivers/parisc/iosapic.c
+++ b/drivers/parisc/iosapic.c
@@ -487,7 +487,7 @@ iosapic_xlate_pin(struct iosapic_info *isi, struct pci_dev *pcidev)
 	}
 
 	/* Check if pcidev behind a PPB */
-	if (NULL != pcidev->bus->self) {
+	if (pcidev->bus->parent) {
 		/* Convert pcidev INTR_PIN into something we
 		** can lookup in the IRT.
 		*/
@@ -523,10 +523,9 @@ iosapic_xlate_pin(struct iosapic_info *isi, struct pci_dev *pcidev)
 #endif /* PCI_BRIDGE_FUNCS */
 
 		/*
-		** Locate the host slot the PPB nearest the Host bus
-		** adapter.
-		*/
-		while (NULL != p->parent->self)
+		 * Locate the host slot of the PPB.
+		 */
+		while (p->parent->parent)
 			p = p->parent;
 
 		intr_slot = PCI_SLOT(p->self->devfn);
diff --git a/drivers/parisc/lba_pci.c b/drivers/parisc/lba_pci.c
index d8233de..59fbbf1 100644
--- a/drivers/parisc/lba_pci.c
+++ b/drivers/parisc/lba_pci.c
@@ -644,7 +644,7 @@ lba_fixup_bus(struct pci_bus *bus)
 	** Properly Setup MMIO resources for this bus.
 	** pci_alloc_primary_bus() mangles this.
 	*/
-	if (bus->self) {
+	if (bus->parent) {
 		int i;
 		/* PCI-PCI Bridge */
 		pci_read_bridge_bases(bus);
@@ -802,7 +802,7 @@ lba_fixup_bus(struct pci_bus *bus)
 ** Can't fixup here anyway....garr...
 */
 	if (fbb_enable) {
-		if (bus->self) {
+		if (bus->parent) {
 			u8 control;
 			/* enable on PPB */
 			(void) pci_read_config_byte(bus->self, PCI_BRIDGE_CONTROL, &control);
