Return-Path: <linux-kernel-owner+w=401wt.eu-S1758199AbZLFXjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199AbZLFXjE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 18:39:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758180AbZLFXi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 18:38:59 -0500
Received: from kroah.org ([198.145.64.141]:33833 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758159AbZLFXiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 18:38:50 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 15:32:10 2009
Message-Id: <20091206233210.538424805@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 15:30:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Libin Yang <libin.yang@amd.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [16/20] USB: ohci: quirk AMD prefetch for USB 1.1 ISO transfer
References: <20091206233032.387950574@mini.kroah.org>
Content-Disposition: inline; filename=usb-ohci-quirk-amd-prefetch-for-usb-1.1-iso-transfer.patch
In-Reply-To: <20091206233711.GA11609@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Libin Yang <libin.yang@amd.com>

commit a1f17a872bc7b1cb7efdd5486a2963e88a536e61 upstream.

The following patch in the driver is required to avoid USB 1.1 device
failures that may occur due to requests from USB OHCI controllers may
be overwritten if the latency for any pending request by the USB
controller is very long (in the range of milliseconds).

Signed-off-by: Libin Yang <libin.yang@amd.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ohci-hcd.c |    5 +++++
 drivers/usb/host/ohci-pci.c |   20 ++++++++++++++++++++
 drivers/usb/host/ohci-q.c   |   18 ++++++++++++------
 drivers/usb/host/ohci.h     |    9 +++++++++
 4 files changed, 46 insertions(+), 6 deletions(-)

--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -89,6 +89,7 @@ static int ohci_restart (struct ohci_hcd
 #ifdef CONFIG_PCI
 static void quirk_amd_pll(int state);
 static void amd_iso_dev_put(void);
+static void sb800_prefetch(struct ohci_hcd *ohci, int on);
 #else
 static inline void quirk_amd_pll(int state)
 {
@@ -98,6 +99,10 @@ static inline void amd_iso_dev_put(void)
 {
 	return;
 }
+static inline void sb800_prefetch(struct ohci_hcd *ohci, int on)
+{
+	return;
+}
 #endif
 
 
--- a/drivers/usb/host/ohci-pci.c
+++ b/drivers/usb/host/ohci-pci.c
@@ -177,6 +177,13 @@ static int ohci_quirk_amd700(struct usb_
 		return 0;
 
 	pci_read_config_byte(amd_smbus_dev, PCI_REVISION_ID, &rev);
+
+	/* SB800 needs pre-fetch fix */
+	if ((rev >= 0x40) && (rev <= 0x4f)) {
+		ohci->flags |= OHCI_QUIRK_AMD_PREFETCH;
+		ohci_dbg(ohci, "enabled AMD prefetch quirk\n");
+	}
+
 	if ((rev > 0x3b) || (rev < 0x30)) {
 		pci_dev_put(amd_smbus_dev);
 		amd_smbus_dev = NULL;
@@ -262,6 +269,19 @@ static void amd_iso_dev_put(void)
 
 }
 
+static void sb800_prefetch(struct ohci_hcd *ohci, int on)
+{
+	struct pci_dev *pdev;
+	u16 misc;
+
+	pdev = to_pci_dev(ohci_to_hcd(ohci)->self.controller);
+	pci_read_config_word(pdev, 0x50, &misc);
+	if (on == 0)
+		pci_write_config_word(pdev, 0x50, misc & 0xfcff);
+	else
+		pci_write_config_word(pdev, 0x50, misc | 0x0300);
+}
+
 /* List of quirks for OHCI */
 static const struct pci_device_id ohci_pci_quirks[] = {
 	{
--- a/drivers/usb/host/ohci-q.c
+++ b/drivers/usb/host/ohci-q.c
@@ -49,9 +49,12 @@ __acquires(ohci->lock)
 	switch (usb_pipetype (urb->pipe)) {
 	case PIPE_ISOCHRONOUS:
 		ohci_to_hcd(ohci)->self.bandwidth_isoc_reqs--;
-		if (ohci_to_hcd(ohci)->self.bandwidth_isoc_reqs == 0
-				&& quirk_amdiso(ohci))
-			quirk_amd_pll(1);
+		if (ohci_to_hcd(ohci)->self.bandwidth_isoc_reqs == 0) {
+			if (quirk_amdiso(ohci))
+				quirk_amd_pll(1);
+			if (quirk_amdprefetch(ohci))
+				sb800_prefetch(ohci, 0);
+		}
 		break;
 	case PIPE_INTERRUPT:
 		ohci_to_hcd(ohci)->self.bandwidth_int_reqs--;
@@ -680,9 +683,12 @@ static void td_submit_urb (
 				data + urb->iso_frame_desc [cnt].offset,
 				urb->iso_frame_desc [cnt].length, urb, cnt);
 		}
-		if (ohci_to_hcd(ohci)->self.bandwidth_isoc_reqs == 0
-				&& quirk_amdiso(ohci))
-			quirk_amd_pll(0);
+		if (ohci_to_hcd(ohci)->self.bandwidth_isoc_reqs == 0) {
+			if (quirk_amdiso(ohci))
+				quirk_amd_pll(0);
+			if (quirk_amdprefetch(ohci))
+				sb800_prefetch(ohci, 1);
+		}
 		periodic = ohci_to_hcd(ohci)->self.bandwidth_isoc_reqs++ == 0
 			&& ohci_to_hcd(ohci)->self.bandwidth_int_reqs == 0;
 		break;
--- a/drivers/usb/host/ohci.h
+++ b/drivers/usb/host/ohci.h
@@ -402,6 +402,7 @@ struct ohci_hcd {
 #define	OHCI_QUIRK_FRAME_NO	0x80			/* no big endian frame_no shift */
 #define	OHCI_QUIRK_HUB_POWER	0x100			/* distrust firmware power/oc setup */
 #define	OHCI_QUIRK_AMD_ISO	0x200			/* ISO transfers*/
+#define	OHCI_QUIRK_AMD_PREFETCH	0x400			/* pre-fetch for ISO transfer */
 	// there are also chip quirks/bugs in init logic
 
 	struct work_struct	nec_work;	/* Worker for NEC quirk */
@@ -433,6 +434,10 @@ static inline int quirk_amdiso(struct oh
 {
 	return ohci->flags & OHCI_QUIRK_AMD_ISO;
 }
+static inline int quirk_amdprefetch(struct ohci_hcd *ohci)
+{
+	return ohci->flags & OHCI_QUIRK_AMD_PREFETCH;
+}
 #else
 static inline int quirk_nec(struct ohci_hcd *ohci)
 {
@@ -446,6 +451,10 @@ static inline int quirk_amdiso(struct oh
 {
 	return 0;
 }
+static inline int quirk_amdprefetch(struct ohci_hcd *ohci)
+{
+	return 0;
+}
 #endif
 
 /* convert between an hcd pointer and the corresponding ohci_hcd */


