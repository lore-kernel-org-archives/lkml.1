Return-Path: <linux-kernel-owner+w=401wt.eu-S934889AbZJNQXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934889AbZJNQXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 12:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932262AbZJNQXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 12:23:33 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:38045 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762009AbZJNQXb (ORCPT
	<rfc822;groupwise-GHaskins@novell.com;0:0>);
	Wed, 14 Oct 2009 12:23:31 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [ALACRITYVM PATCH 2/2] vbus: register shm-signal events as standard
	Linux IRQ vectors
To: alacrityvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Date: Wed, 14 Oct 2009 12:22:41 -0400
Message-ID: <20091014162241.19298.18475.stgit@dev.haskins.net>
In-Reply-To: <20091014162030.19298.48508.stgit@dev.haskins.net>
References: <20091014162030.19298.48508.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will allow us to view the vector statistics in a uniform way, as
well as pave the way for supporting irqbalance in the future.

The VBUS PCI-BRIDGE will present itself as an irqchip device to the
kernel proper.  Each shm-signal that is created by a specific driver
will show up as a "VBUS-edge" IRQ in /proc/interrupts.  For instane,
here is example output from running a venet device as "eth1" (see
vectors 28-31):

vbus-guest:/home/ghaskins # cat /proc/interrupts
            CPU0
   0:         89   IO-APIC-edge      timer
   1:          6   IO-APIC-edge      i8042
   4:       1620   IO-APIC-edge      serial
   6:          2   IO-APIC-edge      floppy
   7:          0   IO-APIC-edge      parport0
   8:          0   IO-APIC-edge      rtc0
   9:          0   IO-APIC-fasteoi   acpi
  10:          0   IO-APIC-fasteoi   virtio1
  12:         90   IO-APIC-edge      i8042
  14:       3474   IO-APIC-edge      ata_piix
  15:       7778   IO-APIC-edge      ata_piix
  24:     185849   PCI-MSI-edge      vbus
  25:          0   PCI-MSI-edge      virtio0-config
  26:        210   PCI-MSI-edge      virtio0-input
  27:         28   PCI-MSI-edge      virtio0-output
  28:     167062      VBUS-edge      eth1-evq
  29:          0      VBUS-edge      eth1-pageq
  30:     161593      VBUS-edge      eth1-rx
  31:          0      VBUS-edge      eth1-tx
 NMI:          0   Non-maskable interrupts
 LOC:      72010   Local timer interrupts
 SPU:          0   Spurious interrupts
 CNT:          0   Performance counter interrupts
 PND:          0   Performance pending work
 RES:          0   Rescheduling interrupts
 CAL:          0   Function call interrupts
 TLB:          0   TLB shootdowns
 TRM:          0   Thermal event interrupts
 THR:          0   Threshold APIC interrupts
 MCE:          0   Machine check exceptions
 MCP:         20   Machine check polls
 ERR:          0
 MIS:          0

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 drivers/vbus/Kconfig      |    4 +-
 drivers/vbus/pci-bridge.c |   91 ++++++++++++++++++++++++++++++++++++---------
 2 files changed, 74 insertions(+), 21 deletions(-)

diff --git a/drivers/vbus/Kconfig b/drivers/vbus/Kconfig
index 08667aa..f51cba1 100644
--- a/drivers/vbus/Kconfig
+++ b/drivers/vbus/Kconfig
@@ -3,7 +3,7 @@
 #
 
 config VBUS_PROXY
-       tristate "Virtual-Bus support"
+       bool "Virtual-Bus support"
        select SHM_SIGNAL
        select IOQ
        default n
@@ -14,7 +14,7 @@ config VBUS_PROXY
 	on the backend, say Y.  If unsure, say N.
 
 config VBUS_PCIBRIDGE
-       tristate "PCI to Virtual-Bus bridge"
+       bool "PCI to Virtual-Bus bridge"
        depends on PCI
        depends on VBUS_PROXY
        select IOQ
diff --git a/drivers/vbus/pci-bridge.c b/drivers/vbus/pci-bridge.c
index fa77318..fcde495 100644
--- a/drivers/vbus/pci-bridge.c
+++ b/drivers/vbus/pci-bridge.c
@@ -147,15 +147,14 @@ _signal_init(struct shm_signal *signal, struct shm_signal_desc *desc,
  */
 
 struct _signal {
+	char               name[64];
 	struct vbus_pci   *pcivbus;
 	struct shm_signal  signal;
 	u32                handle;
 	struct rb_node     node;
 	struct list_head   list;
-	struct {
-		int        notify;
-		int        inject;
-	} stats;
+	int                irq;
+	struct irq_desc   *desc;
 };
 
 static struct _signal *
@@ -170,7 +169,6 @@ _signal_inject(struct shm_signal *signal)
 	struct _signal *_signal = to_signal(signal);
 
 	vbus_pci.stats.inject++;
-	_signal->stats.inject++;
 	iowrite32(_signal->handle, &vbus_pci.signals->shmsignal);
 
 	return 0;
@@ -236,6 +234,7 @@ vbus_pci_device_close(struct vbus_device_proxy *vdev, int flags)
 		_signal = list_first_entry(&dev->shms, struct _signal, list);
 
 		list_del(&_signal->list);
+		free_irq(_signal->irq, _signal);
 
 		spin_unlock_irqrestore(&vbus_pci.lock, iflags);
 		shm_signal_put(&_signal->signal);
@@ -261,6 +260,27 @@ vbus_pci_device_close(struct vbus_device_proxy *vdev, int flags)
 	return 0;
 }
 
+static void vbus_irq_chip_noop(unsigned int irq)
+{
+}
+
+static struct irq_chip vbus_irq_chip = {
+	.name		= "VBUS",
+	.mask		= vbus_irq_chip_noop,
+	.unmask		= vbus_irq_chip_noop,
+	.eoi		= vbus_irq_chip_noop,
+};
+
+irqreturn_t
+shm_signal_intr(int irq, void *dev)
+{
+	struct _signal *_signal = (struct _signal *)dev;
+
+	_shm_signal_wakeup(&_signal->signal);
+
+	return IRQ_HANDLED;
+}
+
 static int
 vbus_pci_device_shm(struct vbus_device_proxy *vdev, const char *name,
 		    int id, int prio,
@@ -315,24 +335,45 @@ vbus_pci_device_shm(struct vbus_device_proxy *vdev, const char *name,
 
 	ret = vbus_pci_buscall(VBUS_PCI_HC_DEVSHM,
 				 &params, sizeof(params));
-	if (ret < 0) {
-		if (_signal) {
-			/*
-			 * We held two references above, so we need to drop
-			 * both of them
-			 */
-			shm_signal_put(&_signal->signal);
-			shm_signal_put(&_signal->signal);
-		}
-
-		return ret;
-	}
+	if (ret < 0)
+		goto fail;
 
 	if (signal) {
+		int irq;
+
 		BUG_ON(ret < 0);
 
 		_signal->handle = ret;
 
+		irq = create_irq();
+		if (irq < 0) {
+			printk(KERN_ERR "Failed to create IRQ: %d\n", irq);
+			ret = -ENOSPC;
+			goto fail;
+		}
+
+		_signal->irq = irq;
+		_signal->desc = irq_to_desc(irq);
+
+		set_irq_chip_and_handler_name(irq,
+					      &vbus_irq_chip,
+					      handle_percpu_irq,
+					      "edge");
+
+		if (!name)
+			snprintf(_signal->name, sizeof(_signal->name),
+				"dev%lld-id%d", vdev->id, id);
+		else
+			snprintf(_signal->name, sizeof(_signal->name),
+				"%s", name);
+
+		ret = request_irq(irq, shm_signal_intr, 0,
+				  _signal->name, _signal);
+		if (ret) {
+			printk(KERN_ERR "Failed to request irq: %d\n", irq);
+			goto fail;
+		}
+
 		spin_lock_irqsave(&vbus_pci.lock, iflags);
 
 		list_add_tail(&_signal->list, &dev->shms);
@@ -344,6 +385,18 @@ vbus_pci_device_shm(struct vbus_device_proxy *vdev, const char *name,
 	}
 
 	return 0;
+
+fail:
+	if (_signal) {
+		/*
+		 * We held two references above, so we need to drop
+		 * both of them
+		 */
+		shm_signal_put(&_signal->signal);
+		shm_signal_put(&_signal->signal);
+	}
+
+	return ret;
 }
 
 static int
@@ -454,10 +507,10 @@ static void
 event_shmsignal(struct vbus_pci_handle_event *event)
 {
 	struct _signal *_signal = (struct _signal *)event->handle;
+	struct irq_desc *desc = _signal->desc;
 
 	vbus_pci.stats.notify++;
-	_signal->stats.notify++;
-	_shm_signal_wakeup(&_signal->signal);
+	desc->handle_irq(_signal->irq, desc);
 }
 
 static void

