Return-Path: <linux-kernel-owner+w=401wt.eu-S1759572AbZAHUqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572AbZAHUqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 15:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbZAHUqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 15:46:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53214 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbZAHUqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 15:46:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 5/8] PCI PCIe portdrv: Fix allocation of interrupts
Date: Thu, 8 Jan 2009 21:45:38 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200901042346.42723.rjw@sisk.pl> <4965B74E.8000309@jp.fujitsu.com> <200901081753.01637.rjw@sisk.pl>
In-Reply-To: <200901081753.01637.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901082145.39429.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 January 2009, Rafael J. Wysocki wrote:
> On Thursday 08 January 2009, Kenji Kaneshige wrote:
> > Rafael J. Wysocki wrote:
> > > On Thursday 08 January 2009, Kenji Kaneshige wrote:
> > >> Rafael J. Wysocki wrote:
> > >>> From: Rafael J. Wysocki <rjw@sisk.pl>
> > >>>
> > >>> If MSI-X interrupt mode is used by the PCI Express port driver, too
> > >>> many vectors are allocated and it is not ensured that the right
> > >>> vectors will be used for various services.  Namely, the PCI Express
> > >>> specification states that both PCI Express native PME and PCI Express
> > >>> hotplug will always use the same MSI or MSI-X message for signalling
> > >>> interrupts, which implies that the same vector will be used by both
> > >>> of them.  Also, the VC service does not use interrupts at all.
> > >>> Moreover, is not clear which of the vectors allocated by
> > >>> pci_enable_msix() will be used for PME and hotplug and which of them
> > >>> will be used for AER if all of these services are configured.
> > >>>
> > >>> For these reasons, rework the allocation of interrupts for PCI
> > >>> Express ports so that at most two vectors are allocated and ensure
> > >>> that the right vector will be used for the right purpose.

Appended is a cleaned-up version of the patch that also contains comments
with references to the appropriate sections of the PCI Express spec.

Thanks,
Rafael

---
Subject: PCI PCIe portdrv: Fix allocation of interrupts (rev. 2)
From: Rafael J. Wysocki <rjw@sisk.pl>

If MSI-X interrupt mode is used by the PCI Express port driver, too
many vectors are allocated and it is not ensured that the right
vectors will be used for various services.  Namely, the PCI Express
specification states that both PCI Express native PME and PCI Express
hotplug will always use the same MSI or MSI-X message for signalling
interrupts, which implies that the same vector will be used by both
of them.  Also, the VC service does not use interrupts at all.
Moreover, is not clear which of the vectors allocated by
pci_enable_msix() will be used for PME and hotplug and which of them
will be used for AER if all of these services are configured.

For these reasons, rework the allocation of interrupts for PCI
Express ports so that at most two vectors are allocated and ensure
that the right vector will be used for the right purpose.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pcie/portdrv.h      |    1 
 drivers/pci/pcie/portdrv_core.c |  168 ++++++++++++++++++++++++++++++----------
 2 files changed, 130 insertions(+), 39 deletions(-)

Index: linux-2.6/drivers/pci/pcie/portdrv.h
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv.h
+++ linux-2.6/drivers/pci/pcie/portdrv.h
@@ -25,6 +25,7 @@
 #define PCIE_CAPABILITIES_REG		0x2
 #define PCIE_SLOT_CAPABILITIES_REG	0x14
 #define PCIE_PORT_DEVICE_MAXSERVICES	4
+#define PORT_MSI_VECTOR_MASK		0x1f
 
 #define get_descriptor_id(type, service) (((type - 4) << 4) | service)
 
Index: linux-2.6/drivers/pci/pcie/portdrv_core.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv_core.c
+++ linux-2.6/drivers/pci/pcie/portdrv_core.c
@@ -30,55 +30,133 @@ static void release_pcie_device(struct d
 }
 
 /**
+ * fix_up_vectors - ensure the right ordering of MSI-X interrupt vectors
+ * @dev: PCI Express port that is going to use the vectors
+ * @vectors: Array of interrupt vectors to check (2 entries)
+ *
+ * Return value:
+ * 0 on success, error code if the values read from config registers are not as
+ * expected
+ *
+ * If this function is called, we are going to use two interrupt vectors which
+ * may be different, but we have to make sure they are in the right order such
+ * that the vector to be used for the PME and hotplug signalling is the first
+ * one.
+ */
+static int fix_up_vectors(struct pci_dev *dev, int *vectors)
+{
+	int pos, vec0, vec1;
+	unsigned int index;
+	u16 reg16;
+	u32 reg32;
+
+	if (vectors[0] == vectors[1])
+		return 0;
+
+	/*
+	 * The code below follows the PCI Express Base Specification 2.0 clearly
+	 * stating in Section 6.1.6 that "PME and Hot-Plug Event interrupts
+	 * (when both are implemented) always share the same MSI or MSI-X
+	 * vector, as indicated by the Interrupt Message Number field in the PCI
+	 * Express Capabilities register", where according to Section 7.8.2 of
+	 * the Specification "For MSI-X, the value in this field indicates which
+	 * MSI-X Table entry is used to generate the interrupt message."
+	 */
+	pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
+	pci_read_config_word(dev, pos + PCIE_CAPABILITIES_REG, &reg16);
+	index = (reg16 >> 9) & PORT_MSI_VECTOR_MASK;
+	if (index > 1)
+		return -EIO;
+	else
+		vec0 = vectors[index];
+	/*
+	 * The code below follows Section 7.10.10 of the PCI Express Base
+	 * Specification 2.0 stating that bits 31-27 of the Root Error Status
+	 * Register contain a value indicating which of the MSI/MSI-X vectors
+	 * assigned to the port is going to be used for AER, where "For MSI-X,
+	 * the value in this register indicates which MSI-X Table entry is used
+	 * to generate the interrupt message."
+	 */
+	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR);
+	pci_read_config_dword(dev, pos + PCI_ERR_ROOT_STATUS, &reg32);
+	index = (reg32 >> 27) & PORT_MSI_VECTOR_MASK;
+	if (index > 1)
+		return -EIO;
+	else
+		vec1 = vectors[index];
+
+	vectors[0] = vec0;
+	vectors[1] = vec1;
+
+	return 0;
+}
+
+/**
+ * pcie_port_enable_msix - try to set up MSI-X as interrupt mode for given port
+ * @dev: PCI Express port to handle
+ * @vectors: Array of interrupt vectors to populate (2 entries)
+ * @mask: Bitmask of port capabilities returned by get_port_device_capability()
+ *
+ * Return value: 0 on success, error code on failure
+ */
+static int pcie_port_enable_msix(struct pci_dev *dev, int *vectors, int mask)
+{
+	struct msix_entry msix_entries[] = {{0, 0}, {0, 1}};
+	int nvec, status;
+
+	/*
+	 * According to the PCI Express specification both PME and PCI Express
+	 * hotplug always use the same interrupt vector, while AER can use
+	 * a different one.
+	 */
+	nvec = ((mask & (PCIE_PORT_SERVICE_PME | PCIE_PORT_SERVICE_HP))
+		&& (mask & PCIE_PORT_SERVICE_AER)) ? 2 : 1;
+
+	status = pci_enable_msix(dev, msix_entries, nvec);
+	if (status)
+		return status;
+
+	vectors[0] = msix_entries[0].vector;
+	vectors[1] = nvec > 1 ? msix_entries[1].vector : vectors[0];
+
+	status = fix_up_vectors(dev, vectors);
+	if (status)
+		pci_disable_msix(dev);
+
+	return status;
+}
+
+/**
  * assign_interrupt_mode - choose interrupt mode for PCI Express port services
  *                         (INTx, MSI-X, MSI) and set up vectors
  * @dev: PCI Express port to handle
- * @vectors: Array of interrupt vectors to populate
+ * @vectors: Array of interrupt vectors to populate (2 entries)
  * @mask: Bitmask of port capabilities returned by get_port_device_capability()
  *
  * Return value: Interrupt mode associated with the port
  */
 static int assign_interrupt_mode(struct pci_dev *dev, int *vectors, int mask)
 {
-	int i, pos, nvec, status = -EINVAL;
 	int interrupt_mode = PCIE_PORT_NO_IRQ;
 
-	/* Set INTx as default */
-	for (i = 0, nvec = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++) {
-		if (mask & (1 << i)) 
-			nvec++;
-		vectors[i] = dev->irq;
-		if (dev->pin)
-			interrupt_mode = PCIE_PORT_INTx_MODE;
+	/* Use MSI-X if supported */
+	if (!pcie_port_enable_msix(dev, vectors, mask)) {
+		interrupt_mode = PCIE_PORT_MSIX_MODE;
+		goto Exit;
 	}
 
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
+	/* We can't use MSI-X, so try MSI and fall back to INTx */
+	if (!pci_enable_msi(dev))
+		interrupt_mode = PCIE_PORT_MSI_MODE;
+	else if (dev->pin)
+		interrupt_mode = PCIE_PORT_INTx_MODE;
+	else
+		goto Exit;
+
+	vectors[0] = dev->irq;
+	vectors[1] = vectors[0];
+
+ Exit:
 	return interrupt_mode;
 }
 
@@ -205,7 +283,7 @@ int pcie_port_device_probe(struct pci_de
 int pcie_port_device_register(struct pci_dev *dev)
 {
 	int status, type, capabilities, irq_mode, i, nr_serv;
-	int vectors[PCIE_PORT_DEVICE_MAXSERVICES];
+	int vectors[] = { -1, -1 };
 	u16 reg16;
 
 	/* Get port type */
@@ -229,7 +307,7 @@ int pcie_port_device_register(struct pci
 	/* Allocate child services if any */
 	for (i = 0, nr_serv = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++) {
 		struct pcie_device *child;
-		int service = 1 << i;
+		int irq, service = 1 << i;
 
 		if (!(capabilities & service))
 			continue;
@@ -242,11 +320,23 @@ int pcie_port_device_register(struct pci
 		    && service != PCIE_PORT_SERVICE_VC)
 			continue;
 
+		switch (service) {
+		case PCIE_PORT_SERVICE_PME:
+		case PCIE_PORT_SERVICE_HP:
+			irq = vectors[0];
+			break;
+		case PCIE_PORT_SERVICE_AER:
+			irq = vectors[1];
+			break;
+		default:
+			irq = -1;
+		}
+
 		child = alloc_pcie_device(
 				dev, 		/* parent */
 				type,		/* port type */
 				service,	/* service type */
-				vectors[i],	/* irq */
+				irq,		/* interrupt vector */
 				irq_mode	/* interrupt mode */);
 		if (!child)
 			continue;

