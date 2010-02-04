Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab0BDRh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:37:58 -0500
Received: from kroah.org ([198.145.64.141]:34582 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932772Ab0BDRV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:21:29 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:14:49 2010
Message-Id: <20100204171449.412633582@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:11:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [05/74] firewire: ohci: fix crashes with TSB43AB23 on 64bit systems
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

commit 7a481436787cbc932af6c407b317ac603969a242 upstream.

Unsurprisingly, Texas Instruments TSB43AB23 exhibits the same behaviour
as TSB43AB22/A in dual buffer IR DMA mode:  If descriptors are located
at physical addresses above the 31 bit address range (2 GB), the
controller will overwrite random memory.  With luck, this merely
prevents video reception.  With only a little less luck, the machine
crashes.

We use the same workaround here as with TSB43AB22/A:  Switch off the
dual buffer capability flag and use packet-per-buffer IR DMA instead.
Another possible workaround would be to limit the coherent DMA mask to
31 bits.

In Linux 2.6.33, this change serves effectively only as documentation
since dual buffer mode is not used for any controller anymore.  But
somebody might want to re-enable it in the future to make use of
features of dual buffer DMA that are not available in packet-per-buffer
mode.

In Linux 2.6.32 and older, this update is vital for anyone with this
controller, more than 2 GB RAM, a 64 bit kernel, and FireWire video or
audio applications.

We have at least four reports:
http://bugzilla.kernel.org/show_bug.cgi?id=13808
http://marc.info/?l=linux1394-user&m=126154279004083
https://bugzilla.redhat.com/show_bug.cgi?id=552142
http://marc.info/?l=linux1394-user&m=126432246128386

Reported-by: Paul Johnson
Reported-by: Ronneil Camara
Reported-by: G Zornetzer
Reported-by: Mark Thompson
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firewire/ohci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2412,6 +2412,7 @@ static void ohci_pmac_off(struct pci_dev
 
 #define PCI_VENDOR_ID_AGERE		PCI_VENDOR_ID_ATT
 #define PCI_DEVICE_ID_AGERE_FW643	0x5901
+#define PCI_DEVICE_ID_TI_TSB43AB23	0x8024
 
 static int __devinit pci_probe(struct pci_dev *dev,
 			       const struct pci_device_id *ent)
@@ -2477,7 +2478,8 @@ static int __devinit pci_probe(struct pc
 #if !defined(CONFIG_X86_32)
 	/* dual-buffer mode is broken with descriptor addresses above 2G */
 	if (dev->vendor == PCI_VENDOR_ID_TI &&
-	    dev->device == PCI_DEVICE_ID_TI_TSB43AB22)
+	    (dev->device == PCI_DEVICE_ID_TI_TSB43AB22 ||
+	     dev->device == PCI_DEVICE_ID_TI_TSB43AB23))
 		ohci->use_dualbuffer = false;
 #endif
 


