Return-Path: <linux-kernel-owner+w=401wt.eu-S1760608AbZAQNlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760608AbZAQNlg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 08:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757590AbZAQNl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 08:41:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53490 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757507AbZAQNlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 08:41:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: [PATCH PCI PCIe portdrv: Fix allocation of interrupts (rev. 5) (was: Re: [PATCH] PCI PCIe portdrv: Fix allocation ...)
Date: Sat, 17 Jan 2009 14:40:42 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200901131457.58164.rjw@sisk.pl> <496F0CA8.7040001@jp.fujitsu.com> <200901170119.54262.rjw@sisk.pl>
In-Reply-To: <200901170119.54262.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901171440.42840.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 January 2009, Rafael J. Wysocki wrote:
> On Thursday 15 January 2009, Kenji Kaneshige wrote:
> > Hidetoshi Seto wrote:
> > > Kenji Kaneshige wrote:
> > >> Rafael J. Wysocki wrote:
> > >>> Hi,
> > >>>
> > >>> The patch below fixes the problem with MSI-X vectors allocation by the PCIe
> > >>> port driver.  It applies on top of the series of PCIe port driver cleanups and
> > >>> bug fixes I've just sent.
> > >>>
> > >>> Please review.
> > >>>
> > >> The patch seems to still have the following assumptions.
> > >>
> > >>  - The number of MSI-X table entries is less than or equal to two.
> > >>  - MSI-X table entries are mapped only to PME/HP and/or AER.
> > > 
> > > It is not true.
> > > 
> > 
> > Maybe I should have said:
> > 
> > The patch will not work if any of PME/HP or AER requires entry
> > other than first two.
> > 
> > > If any of PME/HP and AER requires entry other than first two ([0],[1]),
> > > this code will give up MSI-X and fall back to MSI (or INTx).
> > > 
> > 
> > Yes. My opinion is MSI-X should work even if PME/HP or AER requires
> > entry other than first two.
> > 
> > > In other words, the portdrv will use MSI-X only if entries for PME/PM
> > > and AER is in the first two entries of the MSI-X table.
> > > 
> > 
> > This is exactly my worry, and it's why I want to eliminate the
> > assumptions above.
> 
> OK, appended is yet another version of the patch.
> 
> If MSI-X are supported, it allocates as many vectors as there are entries
> in the port's MSI-X table, but no more than 32, and figures out which of them
> will be used for the port services.

The patch didn't check which services are available during the MSI-X set up
which was wrong.

Also, in the meantime, i thought it might be a good idea to free the interrupt
routing table entries that aren't going to be used after all.

The patch below adds this to the previous version and checks for the
availability of port services in the MSI-X setup resume.  I hope it will
be acceptable to everyone.

Thanks,
Rafael

---
Subject: PCI PCIe portdrv: Fix allocation of interrupts (rev. 5)
From: Rafael J. Wysocki <rjw@sisk.pl>

If MSI-X interrupt mode is used by the PCI Express port driver, too
many vectors are allocated and it is not ensured that the right
vectors will be used for the right services.  Namely, the PCI Express
specification states that both PCI Express native PME and PCI Express
hotplug will always use the same MSI or MSI-X message for signalling
interrupts, which implies that the same vector will be used by both
of them.  Also, the VC service does not use interrupts at all.
Moreover, is not clear which of the vectors allocated by
pci_enable_msix() in the current code will be used for PME and
hotplug and which of them will be used for AER if all of these
services are configured.

For these reasons, rework the allocation of interrupts for PCI
Express ports so that if MSI-X are enabled, the right vectors will be
used for the right purposes.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/msi.c               |   24 +++-
 drivers/pci/pcie/portdrv.h      |    6 +
 drivers/pci/pcie/portdrv_core.c |  195 ++++++++++++++++++++++++++++++++--------
 include/linux/pci.h             |    5 +
 include/linux/pcieport_if.h     |   12 +-
 5 files changed, 194 insertions(+), 48 deletions(-)

Index: linux-2.6/drivers/pci/pcie/portdrv_core.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv_core.c
+++ linux-2.6/drivers/pci/pcie/portdrv_core.c
@@ -31,6 +31,141 @@ static void release_pcie_device(struct d
 }
 
 /**
+ * pcie_port_msix_add_entry - add entry to given array of MSI-X entries
+ * @entries: Array of MSI-X entries
+ * @new_entry: Index of the entry to add to the array
+ * @nr_entries: Number of entries aleady in the array
+ *
+ * Return value: Position of the added entry in the array
+ */
+static int pcie_port_msix_add_entry(
+	struct msix_entry *entries, int new_entry, int nr_entries)
+{
+	int j;
+
+	for (j = 0; j < nr_entries; j++)
+		if (entries[j].entry == new_entry)
+			return j;
+
+	entries[j].entry = new_entry;
+	return j;
+}
+
+/**
+ * pcie_port_enable_msix - try to set up MSI-X as interrupt mode for given port
+ * @dev: PCI Express port to handle
+ * @vectors: Array of interrupt vectors to populate
+ * @mask: Bitmask of port capabilities returned by get_port_device_capability()
+ *
+ * Return value: 0 on success, error code on failure
+ */
+static int pcie_port_enable_msix(struct pci_dev *dev, int *vectors, int mask)
+{
+	struct msix_entry *msix_entries;
+	int idx[PCIE_PORT_DEVICE_MAXSERVICES];
+	int nr_entries, status, pos, i, nvec;
+	u16 reg16;
+	u32 reg32;
+
+	nr_entries = pci_msix_table_size(dev);
+	if (!nr_entries)
+		return -EINVAL;
+	if (nr_entries > PCIE_PORT_MAX_MSIX_ENTRIES)
+		nr_entries = PCIE_PORT_MAX_MSIX_ENTRIES;
+
+	msix_entries = kzalloc(sizeof(*msix_entries) * nr_entries, GFP_KERNEL);
+	if (!msix_entries)
+		return -ENOMEM;
+
+	/*
+	 * Allocate as many entries as the device wants temporarily, so that we
+	 * can check which of them will be useful.
+	 */
+	for (i = 0; i < nr_entries; i++)
+		msix_entries[i].entry = i;
+
+	status = pci_enable_msix(dev, msix_entries, nr_entries);
+	if (status)
+		goto Exit;
+
+	for (i = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++)
+		idx[i] = -1;
+	status = -EIO;
+	nvec = 0;
+
+	if (mask & (PCIE_PORT_SERVICE_PME | PCIE_PORT_SERVICE_HP)) {
+		int entry;
+
+		/*
+		 * The code below follows the PCI Express Base Specification 2.0
+		 * stating in Section 6.1.6 that "PME and Hot-Plug Event
+		 * interrupts (when both are implemented) always share the same
+		 * MSI or MSI-X vector, as indicated by the Interrupt Message
+		 * Number field in the PCI Express Capabilities register", where
+		 * according to Section 7.8.2 of the specification "For MSI-X,
+		 * the value in this field indicates which MSI-X Table entry is
+		 * used to generate the interrupt message."
+		 */
+		pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
+		pci_read_config_word(dev, pos + PCIE_CAPABILITIES_REG, &reg16);
+		entry = (reg16 >> 9) & PCIE_PORT_MSI_VECTOR_MASK;
+		if (entry >= nr_entries)
+			goto Error;
+
+		i = pcie_port_msix_add_entry(msix_entries, entry, nvec);
+		if (i == nvec)
+			nvec++;
+
+		idx[PCIE_PORT_SERVICE_PME_SHIFT] = i;
+		idx[PCIE_PORT_SERVICE_HP_SHIFT] = i;
+	}
+
+	if (mask & PCIE_PORT_SERVICE_AER) {
+		int entry;
+
+		/*
+		 * The code below follows Section 7.10.10 of the PCI Express
+		 * Base Specification 2.0 stating that bits 31-27 of the Root
+		 * Error Status Register contain a value indicating which of the
+		 * MSI/MSI-X vectors assigned to the port is going to be used
+		 * for AER, where "For MSI-X, the value in this register
+		 * indicates which MSI-X Table entry is used to generate the
+		 * interrupt message."
+		 */
+		pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR);
+		pci_read_config_dword(dev, pos + PCI_ERR_ROOT_STATUS, &reg32);
+		entry = reg32 >> 27;
+		if (entry >= nr_entries)
+			goto Error;
+
+		i = pcie_port_msix_add_entry(msix_entries, entry, nvec);
+		if (i == nvec)
+			nvec++;
+
+		idx[PCIE_PORT_SERVICE_AER_SHIFT] = i;
+	}
+
+	/* Drop the temporary MSI-X setup */
+	pci_disable_msix(dev);
+
+	/* Now allocate the MSI-X vectors for real */
+	status = pci_enable_msix(dev, msix_entries, nvec);
+	if (status)
+		goto Error;
+
+	for (i = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++)
+		vectors[i] = idx[i] >= 0 ? msix_entries[idx[i]].vector : -1;
+
+ Exit:
+	kfree(msix_entries);
+	return status;
+
+ Error:
+	pci_disable_msix(dev);
+	goto Exit;
+}
+
+/**
  * assign_interrupt_mode - choose interrupt mode for PCI Express port services
  *                         (INTx, MSI-X, MSI) and set up vectors
  * @dev: PCI Express port to handle
@@ -42,49 +177,31 @@ static void release_pcie_device(struct d
 static int assign_interrupt_mode(struct pci_dev *dev, int *vectors, int mask)
 {
 	struct pcie_port_data *port_data = pci_get_drvdata(dev);
-	int i, pos, nvec, status = -EINVAL;
-	int interrupt_mode = PCIE_PORT_NO_IRQ;
-
-	/* Set INTx as default */
-	for (i = 0, nvec = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++) {
-		if (mask & (1 << i)) 
-			nvec++;
-		vectors[i] = dev->irq;
-	}
-	if (dev->pin)
-		interrupt_mode = PCIE_PORT_INTx_MODE;
+	int irq, interrupt_mode = PCIE_PORT_NO_IRQ;
+	int i;
 
 	/* Check MSI quirk */
 	if (port_data->port_type == PCIE_RC_PORT && pcie_mch_quirk)
-		return interrupt_mode;
+		goto Fallback;
+
+	/* Try to use MSI-X if supported */
+	if (!pcie_port_enable_msix(dev, vectors, mask))
+		return PCIE_PORT_MSIX_MODE;
+
+	/* We're not going to use MSI-X, so try MSI and fall back to INTx */
+	if (!pci_enable_msi(dev))
+		interrupt_mode = PCIE_PORT_MSI_MODE;
+
+ Fallback:
+	if (interrupt_mode == PCIE_PORT_NO_IRQ && dev->pin)
+		interrupt_mode = PCIE_PORT_INTx_MODE;
+
+	irq = interrupt_mode != PCIE_PORT_NO_IRQ ? dev->irq : -1;
+	for (i = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++)
+		vectors[i] = irq;
+
+	vectors[PCIE_PORT_SERVICE_VC_SHIFT] = -1;
 
-	/* Select MSI-X over MSI if supported */		
-	pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
-	if (pos) {
-		struct msix_entry msix_entries[PCIE_PORT_DEVICE_MAXSERVICES] = 
-			{{0, 0}, {0, 1}, {0, 2}, {0, 3}};
-		status = pci_enable_msix(dev, msix_entries, nvec);
-		if (!status) {
-			int j = 0;
-
-			interrupt_mode = PCIE_PORT_MSIX_MODE;
-			for (i = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++) {
-				if (mask & (1 << i)) 
-					vectors[i] = msix_entries[j++].vector;
-			}
-		}
-	} 
-	if (status) {
-		pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
-		if (pos) {
-			status = pci_enable_msi(dev);
-			if (!status) {
-				interrupt_mode = PCIE_PORT_MSI_MODE;
-				for (i = 0;i < PCIE_PORT_DEVICE_MAXSERVICES;i++)
-					vectors[i] = dev->irq;
-			}
-		}
-	} 
 	return interrupt_mode;
 }
 
Index: linux-2.6/include/linux/pcieport_if.h
===================================================================
--- linux-2.6.orig/include/linux/pcieport_if.h
+++ linux-2.6/include/linux/pcieport_if.h
@@ -16,10 +16,14 @@
 #define PCIE_ANY_PORT			7
 
 /* Service Type */
-#define PCIE_PORT_SERVICE_PME		1	/* Power Management Event */
-#define PCIE_PORT_SERVICE_AER		2	/* Advanced Error Reporting */
-#define PCIE_PORT_SERVICE_HP		4	/* Native Hotplug */
-#define PCIE_PORT_SERVICE_VC		8	/* Virtual Channel */
+#define PCIE_PORT_SERVICE_PME_SHIFT	0	/* Power Management Event */
+#define PCIE_PORT_SERVICE_PME		(1 << PCIE_PORT_SERVICE_PME_SHIFT)
+#define PCIE_PORT_SERVICE_AER_SHIFT	1	/* Advanced Error Reporting */
+#define PCIE_PORT_SERVICE_AER		(1 << PCIE_PORT_SERVICE_AER_SHIFT)
+#define PCIE_PORT_SERVICE_HP_SHIFT	2	/* Native Hotplug */
+#define PCIE_PORT_SERVICE_HP		(1 << PCIE_PORT_SERVICE_HP_SHIFT)
+#define PCIE_PORT_SERVICE_VC_SHIFT	3	/* Virtual Channel */
+#define PCIE_PORT_SERVICE_VC		(1 << PCIE_PORT_SERVICE_VC_SHIFT)
 
 /* Root/Upstream/Downstream Port's Interrupt Mode */
 #define PCIE_PORT_NO_IRQ		(-1)
Index: linux-2.6/drivers/pci/pcie/portdrv.h
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv.h
+++ linux-2.6/drivers/pci/pcie/portdrv.h
@@ -25,6 +25,12 @@
 #define PCIE_CAPABILITIES_REG		0x2
 #define PCIE_SLOT_CAPABILITIES_REG	0x14
 #define PCIE_PORT_DEVICE_MAXSERVICES	4
+#define PCIE_PORT_MSI_VECTOR_MASK	0x1f
+/*
+ * According to the PCI Express Base Specification 2.0, the indices of the MSI-X
+ * table entires used by port services must not exceed 31
+ */
+#define PCIE_PORT_MAX_MSIX_ENTRIES	32
 
 #define get_descriptor_id(type, service) (((type - 4) << 4) | service)
 
Index: linux-2.6/drivers/pci/msi.c
===================================================================
--- linux-2.6.orig/drivers/pci/msi.c
+++ linux-2.6/drivers/pci/msi.c
@@ -670,6 +670,23 @@ static int msi_free_irqs(struct pci_dev*
 }
 
 /**
+ * pci_msix_table_size - return the number of device's MSI-X table entries
+ * @dev: pointer to the pci_dev data structure of MSI-X device function
+ */
+int pci_msix_table_size(struct pci_dev *dev)
+{
+	int pos;
+	u16 control;
+
+	pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
+	if (!pos)
+		return 0;
+
+	pci_read_config_word(dev, msi_control_reg(pos), &control);
+	return multi_msix_capable(control);
+}
+
+/**
  * pci_enable_msix - configure device's MSI-X capability structure
  * @dev: pointer to the pci_dev data structure of MSI-X device function
  * @entries: pointer to an array of MSI-X entries
@@ -686,9 +703,8 @@ static int msi_free_irqs(struct pci_dev*
  **/
 int pci_enable_msix(struct pci_dev* dev, struct msix_entry *entries, int nvec)
 {
-	int status, pos, nr_entries;
+	int status, nr_entries;
 	int i, j;
-	u16 control;
 
 	if (!entries)
  		return -EINVAL;
@@ -697,9 +713,7 @@ int pci_enable_msix(struct pci_dev* dev,
 	if (status)
 		return status;
 
-	pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
-	pci_read_config_word(dev, msi_control_reg(pos), &control);
-	nr_entries = multi_msix_capable(control);
+	nr_entries = pci_msix_table_size(dev);
 	if (nvec > nr_entries)
 		return -EINVAL;
 
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -799,6 +799,10 @@ static inline void pci_msi_shutdown(stru
 static inline void pci_disable_msi(struct pci_dev *dev)
 { }
 
+static inline int pci_msix_table_size(struct pci_dev *dev)
+{
+	return 0;
+}
 static inline int pci_enable_msix(struct pci_dev *dev,
 				  struct msix_entry *entries, int nvec)
 {
@@ -823,6 +827,7 @@ static inline int pci_msi_enabled(void)
 extern int pci_enable_msi(struct pci_dev *dev);
 extern void pci_msi_shutdown(struct pci_dev *dev);
 extern void pci_disable_msi(struct pci_dev *dev);
+extern int pci_msix_table_size(struct pci_dev *dev);
 extern int pci_enable_msix(struct pci_dev *dev,
 	struct msix_entry *entries, int nvec);
 extern void pci_msix_shutdown(struct pci_dev *dev);

