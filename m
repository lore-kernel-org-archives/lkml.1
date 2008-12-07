Return-Path: <linux-kernel-owner+w=401wt.eu-S1753686AbYLGVEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbYLGVEI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 16:04:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbYLGVDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 16:03:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34665 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbYLGVDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 16:03:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/3] PCI: Rework default handling of suspend and resume
Date: Sun, 7 Dec 2008 22:02:58 +0100
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812071347.18608.rjw@sisk.pl> <alpine.LFD.2.00.0812070835040.3425@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812070835040.3425@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812072202.58618.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 7 of December 2008, Linus Torvalds wrote:
> 
> On Sun, 7 Dec 2008, Rafael J. Wysocki wrote:
> > 
> > If there is no objection from Jesse and if you don't mind, I'll prepare a
> > version of the $subject patch on top of the patch in your tree and send it to
> > you.
> 
> Rafael: there's a bug in your 1/3 patch. 
> 
> It looks like "pci_save_state()" is currently unhappy with being called 
> with interrupts disabled. Or at least "pci_save_pci[ex]_state()" state 
> are. They both do a kzalloc(GFP_KERNEL).
> 
> So you should change that GFP_KERNEL into a GFP_ATOMIC. Or do something 
> more complicated like pre-allocate them during early suspend, but just 
> changing it to GFP_ATOMIC seems to be the trivial fix.
> 
> I'm not seeing any other issues with saving/restoring things with irq's 
> disabled, but people should be on the lookout for details like this.

I overlooked that, sorry.

What about doing the following in addition to patch [1/3]?

Rafael

---
 drivers/pci/pci.c   |   73 ++++++++++++++++++++++++++++++++++++----------------
 drivers/pci/pci.h   |    1 
 drivers/pci/probe.c |    3 ++
 3 files changed, 55 insertions(+), 22 deletions(-)

Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c
+++ linux-2.6/drivers/pci/probe.c
@@ -958,6 +958,9 @@ static void pci_init_capabilities(struct
 	/* MSI/MSI-X list */
 	pci_msi_init_pci_dev(dev);
 
+	/* Buffers for saving PCIe and PCI-X capabilities */
+	pci_allocate_cap_save_buffers(dev);
+
 	/* Power Management */
 	pci_pm_init(dev);
 
Index: linux-2.6/drivers/pci/pci.h
===================================================================
--- linux-2.6.orig/drivers/pci/pci.h
+++ linux-2.6/drivers/pci/pci.h
@@ -41,6 +41,7 @@ struct pci_platform_pm_ops {
 
 extern int pci_set_platform_pm(struct pci_platform_pm_ops *ops);
 extern void pci_pm_init(struct pci_dev *dev);
+extern void pci_allocate_cap_save_buffers(struct pci_dev *dev);
 
 extern int pci_user_read_config_byte(struct pci_dev *dev, int where, u8 *val);
 extern int pci_user_read_config_word(struct pci_dev *dev, int where, u16 *val);
Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -640,19 +640,14 @@ static int pci_save_pcie_state(struct pc
 	int pos, i = 0;
 	struct pci_cap_saved_state *save_state;
 	u16 *cap;
-	int found = 0;
 
 	pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
 	if (pos <= 0)
 		return 0;
 
 	save_state = pci_find_saved_cap(dev, PCI_CAP_ID_EXP);
-	if (!save_state)
-		save_state = kzalloc(sizeof(*save_state) + sizeof(u16) * 4, GFP_KERNEL);
-	else
-		found = 1;
 	if (!save_state) {
-		dev_err(&dev->dev, "out of memory in pci_save_pcie_state\n");
+		dev_err(&dev->dev, "buffer not found in %s\n", __FUNCTION__);
 		return -ENOMEM;
 	}
 	cap = (u16 *)&save_state->data[0];
@@ -661,9 +656,7 @@ static int pci_save_pcie_state(struct pc
 	pci_read_config_word(dev, pos + PCI_EXP_LNKCTL, &cap[i++]);
 	pci_read_config_word(dev, pos + PCI_EXP_SLTCTL, &cap[i++]);
 	pci_read_config_word(dev, pos + PCI_EXP_RTCTL, &cap[i++]);
-	save_state->cap_nr = PCI_CAP_ID_EXP;
-	if (!found)
-		pci_add_saved_cap(dev, save_state);
+
 	return 0;
 }
 
@@ -688,30 +681,21 @@ static void pci_restore_pcie_state(struc
 
 static int pci_save_pcix_state(struct pci_dev *dev)
 {
-	int pos, i = 0;
+	int pos;
 	struct pci_cap_saved_state *save_state;
-	u16 *cap;
-	int found = 0;
 
 	pos = pci_find_capability(dev, PCI_CAP_ID_PCIX);
 	if (pos <= 0)
 		return 0;
 
 	save_state = pci_find_saved_cap(dev, PCI_CAP_ID_PCIX);
-	if (!save_state)
-		save_state = kzalloc(sizeof(*save_state) + sizeof(u16), GFP_KERNEL);
-	else
-		found = 1;
 	if (!save_state) {
-		dev_err(&dev->dev, "out of memory in pci_save_pcie_state\n");
+		dev_err(&dev->dev, "buffer not found in %s\n", __FUNCTION__);
 		return -ENOMEM;
 	}
-	cap = (u16 *)&save_state->data[0];
 
-	pci_read_config_word(dev, pos + PCI_X_CMD, &cap[i++]);
-	save_state->cap_nr = PCI_CAP_ID_PCIX;
-	if (!found)
-		pci_add_saved_cap(dev, save_state);
+	pci_read_config_word(dev, pos + PCI_X_CMD, (u16 *)save_state->data);
+
 	return 0;
 }
 
@@ -1301,6 +1285,51 @@ void pci_pm_init(struct pci_dev *dev)
 }
 
 /**
+ * pci_add_save_buffer - allocate buffer for saving given capability registers
+ * @dev: the PCI device
+ * @cap: the capability to allocate the buffer for
+ * @size: requested size of the buffer
+ */
+static int pci_add_cap_save_buffer(
+	struct pci_dev *dev, char cap, unsigned int size)
+{
+	int pos;
+	struct pci_cap_saved_state *save_state;
+
+	pos = pci_find_capability(dev, cap);
+	if (pos <= 0)
+		return 0;
+
+	save_state = kzalloc(sizeof(*save_state) + size, GFP_KERNEL);
+	if (!save_state)
+		return -ENOMEM;
+
+	save_state->cap_nr = cap;
+	pci_add_saved_cap(dev, save_state);
+
+	return 0;
+}
+
+/**
+ * pci_allocate_cap_save_buffers - allocate buffers for saving capabilities
+ * @dev: the PCI device
+ */
+void pci_allocate_cap_save_buffers(struct pci_dev *dev)
+{
+	int error;
+
+	error = pci_add_cap_save_buffer(dev, PCI_CAP_ID_EXP, 4 * sizeof(u16));
+	if (error)
+		dev_err(&dev->dev,
+			"unable to preallocate PCI Express save buffer\n");
+
+	error = pci_add_cap_save_buffer(dev, PCI_CAP_ID_PCIX, sizeof(u16));
+	if (error)
+		dev_err(&dev->dev,
+			"unable to preallocate PCI-X save buffer\n");
+}
+
+/**
  * pci_enable_ari - enable ARI forwarding if hardware support it
  * @dev: the PCI device
  */
