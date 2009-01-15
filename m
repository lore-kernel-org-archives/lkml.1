Return-Path: <linux-kernel-owner+w=401wt.eu-S935319AbZAOWvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935319AbZAOWvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932400AbZAOWEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:04:13 -0500
Received: from kroah.org ([198.145.64.141]:39213 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934114AbZAOWEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:04:01 -0500
Date: Thu, 15 Jan 2009 14:02:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 84/85] PCI: handle PCI state saving with interrupts disabled
Message-ID: <20090115220210.GG17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pci-handle-pci-state-saving-with-interrupts-disabled.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rafael J. Wysocki <rjw@sisk.pl>

commit 63f4898ace2788a89ed685672aab092e1c3e50e6 upstream.

Since interrupts will soon be disabled at PCI resume time, we need to
pre-allocate memory to save/restore PCI config space (or use GFP_ATOMIC,
but this is safer).

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pci.c   |   72 ++++++++++++++++++++++++++++++++++++----------------
 drivers/pci/pci.h   |    1 
 drivers/pci/probe.c |    3 ++
 3 files changed, 54 insertions(+), 22 deletions(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -636,19 +636,14 @@ static int pci_save_pcie_state(struct pc
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
@@ -657,9 +652,7 @@ static int pci_save_pcie_state(struct pc
 	pci_read_config_word(dev, pos + PCI_EXP_LNKCTL, &cap[i++]);
 	pci_read_config_word(dev, pos + PCI_EXP_SLTCTL, &cap[i++]);
 	pci_read_config_word(dev, pos + PCI_EXP_RTCTL, &cap[i++]);
-	save_state->cap_nr = PCI_CAP_ID_EXP;
-	if (!found)
-		pci_add_saved_cap(dev, save_state);
+
 	return 0;
 }
 
@@ -684,30 +677,21 @@ static void pci_restore_pcie_state(struc
 
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
 
@@ -726,6 +710,50 @@ static void pci_restore_pcix_state(struc
 	pci_write_config_word(dev, pos + PCI_X_CMD, cap[i++]);
 }
 
+ /**
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
 
 /**
  * pci_save_state - save the PCI configuration space of a device before suspending
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -35,6 +35,7 @@ struct pci_platform_pm_ops {
 
 extern int pci_set_platform_pm(struct pci_platform_pm_ops *ops);
 extern void pci_pm_init(struct pci_dev *dev);
+extern void pci_allocate_cap_save_buffers(struct pci_dev *dev);
 
 extern int pci_user_read_config_byte(struct pci_dev *dev, int where, u8 *val);
 extern int pci_user_read_config_word(struct pci_dev *dev, int where, u16 *val);
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1028,6 +1028,9 @@ void pci_device_add(struct pci_dev *dev,
 	/* Fix up broken headers */
 	pci_fixup_device(pci_fixup_header, dev);
 
+	/* Buffers for saving PCIe and PCI-X capabilities */
+	pci_allocate_cap_save_buffers(dev);
+
 	/* Initialize power management of the device */
 	pci_pm_init(dev);
 

