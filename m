Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab0CIRxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:53:12 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:4725 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069Ab0CIRwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:52:55 -0500
Subject: [PATCH 2/2] USB: xhci: move all debug code under
	CONFIG_XHCI_HCD_DEBUGGING
To: sarah.a.sharp@linux.intel.com
From: Alex Chiang <achiang@hp.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 09 Mar 2010 10:52:54 -0700
Message-ID: <20100309175254.29339.99634.stgit@bob.kio>
In-Reply-To: <20100309174815.29339.96173.stgit@bob.kio>
References: <20100309174815.29339.96173.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per $subject, only build (and run) xhci debug code when the user
wants it.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/usb/host/Makefile   |    5 ++-
 drivers/usb/host/xhci-dbg.c |   76 ++++++++++++++++++++++++++++++++++++++++++
 drivers/usb/host/xhci.c     |   78 ++-----------------------------------------
 drivers/usb/host/xhci.h     |   19 ++++++++++
 4 files changed, 103 insertions(+), 75 deletions(-)

diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
index af25ace..2af3351 100644
--- a/drivers/usb/host/Makefile
+++ b/drivers/usb/host/Makefile
@@ -12,7 +12,10 @@ fhci-objs := fhci-hcd.o fhci-hub.o fhci-q.o fhci-mem.o \
 ifeq ($(CONFIG_FHCI_DEBUG),y)
 fhci-objs += fhci-dbg.o
 endif
-xhci-hcd-objs := xhci.o xhci-mem.o xhci-pci.o xhci-ring.o xhci-hub.o xhci-dbg.o
+xhci-hcd-objs := xhci.o xhci-mem.o xhci-pci.o xhci-ring.o xhci-hub.o
+ifeq ($(CONFIG_XHCI_HCD_DEBUGGING),y)
+xhci-hcd-objs += xhci-dbg.o
+endif
 
 obj-$(CONFIG_USB_WHCI_HCD)	+= whci/
 
diff --git a/drivers/usb/host/xhci-dbg.c b/drivers/usb/host/xhci-dbg.c
index 33128d5..6ae5cd6 100644
--- a/drivers/usb/host/xhci-dbg.c
+++ b/drivers/usb/host/xhci-dbg.c
@@ -529,3 +529,79 @@ void xhci_dbg_ctx(struct xhci_hcd *xhci,
 	xhci_dbg_slot_ctx(xhci, ctx);
 	xhci_dbg_ep_ctx(xhci, ctx, last_ep);
 }
+
+static void xhci_dbg_event_ring_work(unsigned long arg)
+{
+	unsigned long flags;
+	int temp;
+	u64 temp_64;
+	struct xhci_hcd *xhci = (struct xhci_hcd *) arg;
+	int i, j;
+
+	xhci_dbg(xhci, "Poll event ring: %lu\n", jiffies);
+
+	spin_lock_irqsave(&xhci->lock, flags);
+	temp = xhci_readl(xhci, &xhci->op_regs->status);
+	xhci_dbg(xhci, "op reg status = 0x%x\n", temp);
+	if (temp == 0xffffffff || (xhci->xhc_state & XHCI_STATE_DYING)) {
+		xhci_dbg(xhci, "HW died, polling stopped.\n");
+		spin_unlock_irqrestore(&xhci->lock, flags);
+		return;
+	}
+
+	temp = xhci_readl(xhci, &xhci->ir_set->irq_pending);
+	xhci_dbg(xhci, "ir_set 0 pending = 0x%x\n", temp);
+	xhci_dbg(xhci, "No-op commands handled = %d\n", xhci->noops_handled);
+	xhci_dbg(xhci, "HC error bitmask = 0x%x\n", xhci->error_bitmask);
+	xhci->error_bitmask = 0;
+	xhci_dbg(xhci, "Event ring:\n");
+	xhci_debug_segment(xhci, xhci->event_ring->deq_seg);
+	xhci_dbg_ring_ptrs(xhci, xhci->event_ring);
+	temp_64 = xhci_read_64(xhci, &xhci->ir_set->erst_dequeue);
+	temp_64 &= ~ERST_PTR_MASK;
+	xhci_dbg(xhci, "ERST deq = 64'h%0lx\n", (long unsigned int) temp_64);
+	xhci_dbg(xhci, "Command ring:\n");
+	xhci_debug_segment(xhci, xhci->cmd_ring->deq_seg);
+	xhci_dbg_ring_ptrs(xhci, xhci->cmd_ring);
+	xhci_dbg_cmd_ptrs(xhci);
+	for (i = 0; i < MAX_HC_SLOTS; ++i) {
+		if (!xhci->devs[i])
+			continue;
+		for (j = 0; j < 31; ++j) {
+			struct xhci_ring *ring = xhci->devs[i]->eps[j].ring;
+			if (!ring)
+				continue;
+			xhci_dbg(xhci, "Dev %d endpoint ring %d:\n", i, j);
+			xhci_debug_segment(xhci, ring->deq_seg);
+		}
+	}
+
+	if (xhci->noops_submitted != NUM_TEST_NOOPS)
+		if (xhci_setup_one_noop(xhci))
+			xhci_ring_cmd_db(xhci);
+	spin_unlock_irqrestore(&xhci->lock, flags);
+
+	if (!xhci->zombie)
+		mod_timer(&xhci->event_ring_timer, jiffies + POLL_TIMEOUT * HZ);
+	else
+		xhci_dbg(xhci, "Quit polling the event ring.\n");
+}
+
+void xhci_dbg_init_ring_polling(struct xhci_hcd *xhci)
+{
+	init_timer(&xhci->event_ring_timer);
+	xhci->event_ring_timer.data = (unsigned long) xhci;
+	xhci->event_ring_timer.function = xhci_dbg_event_ring_work;
+	/* Poll the event ring */
+	xhci->event_ring_timer.expires = jiffies + POLL_TIMEOUT * HZ;
+	xhci->zombie = 0;
+	xhci_dbg(xhci, "Setting event ring polling timer\n");
+	add_timer(&xhci->event_ring_timer);
+}
+
+void xhci_dbg_stop_ring_polling(struct xhci_hcd *xhci)
+{
+	/* Tell the event ring poll function not to reschedule */
+	xhci->zombie = 1;
+	del_timer_sync(&xhci->event_ring_timer);
+}
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 5e92c72..89474b2 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -312,65 +312,6 @@ hw_died:
 	return IRQ_HANDLED;
 }
 
-#ifdef CONFIG_USB_XHCI_HCD_DEBUGGING
-void xhci_event_ring_work(unsigned long arg)
-{
-	unsigned long flags;
-	int temp;
-	u64 temp_64;
-	struct xhci_hcd *xhci = (struct xhci_hcd *) arg;
-	int i, j;
-
-	xhci_dbg(xhci, "Poll event ring: %lu\n", jiffies);
-
-	spin_lock_irqsave(&xhci->lock, flags);
-	temp = xhci_readl(xhci, &xhci->op_regs->status);
-	xhci_dbg(xhci, "op reg status = 0x%x\n", temp);
-	if (temp == 0xffffffff || (xhci->xhc_state & XHCI_STATE_DYING)) {
-		xhci_dbg(xhci, "HW died, polling stopped.\n");
-		spin_unlock_irqrestore(&xhci->lock, flags);
-		return;
-	}
-
-	temp = xhci_readl(xhci, &xhci->ir_set->irq_pending);
-	xhci_dbg(xhci, "ir_set 0 pending = 0x%x\n", temp);
-	xhci_dbg(xhci, "No-op commands handled = %d\n", xhci->noops_handled);
-	xhci_dbg(xhci, "HC error bitmask = 0x%x\n", xhci->error_bitmask);
-	xhci->error_bitmask = 0;
-	xhci_dbg(xhci, "Event ring:\n");
-	xhci_debug_segment(xhci, xhci->event_ring->deq_seg);
-	xhci_dbg_ring_ptrs(xhci, xhci->event_ring);
-	temp_64 = xhci_read_64(xhci, &xhci->ir_set->erst_dequeue);
-	temp_64 &= ~ERST_PTR_MASK;
-	xhci_dbg(xhci, "ERST deq = 64'h%0lx\n", (long unsigned int) temp_64);
-	xhci_dbg(xhci, "Command ring:\n");
-	xhci_debug_segment(xhci, xhci->cmd_ring->deq_seg);
-	xhci_dbg_ring_ptrs(xhci, xhci->cmd_ring);
-	xhci_dbg_cmd_ptrs(xhci);
-	for (i = 0; i < MAX_HC_SLOTS; ++i) {
-		if (!xhci->devs[i])
-			continue;
-		for (j = 0; j < 31; ++j) {
-			struct xhci_ring *ring = xhci->devs[i]->eps[j].ring;
-			if (!ring)
-				continue;
-			xhci_dbg(xhci, "Dev %d endpoint ring %d:\n", i, j);
-			xhci_debug_segment(xhci, ring->deq_seg);
-		}
-	}
-
-	if (xhci->noops_submitted != NUM_TEST_NOOPS)
-		if (xhci_setup_one_noop(xhci))
-			xhci_ring_cmd_db(xhci);
-	spin_unlock_irqrestore(&xhci->lock, flags);
-
-	if (!xhci->zombie)
-		mod_timer(&xhci->event_ring_timer, jiffies + POLL_TIMEOUT * HZ);
-	else
-		xhci_dbg(xhci, "Quit polling the event ring.\n");
-}
-#endif
-
 /*
  * Start the HC after it was halted.
  *
@@ -402,16 +343,8 @@ int xhci_run(struct usb_hcd *hcd)
 
 	return -ENOSYS;
 #endif
-#ifdef CONFIG_USB_XHCI_HCD_DEBUGGING
-	init_timer(&xhci->event_ring_timer);
-	xhci->event_ring_timer.data = (unsigned long) xhci;
-	xhci->event_ring_timer.function = xhci_event_ring_work;
-	/* Poll the event ring */
-	xhci->event_ring_timer.expires = jiffies + POLL_TIMEOUT * HZ;
-	xhci->zombie = 0;
-	xhci_dbg(xhci, "Setting event ring polling timer\n");
-	add_timer(&xhci->event_ring_timer);
-#endif
+
+	xhci_dbg_init_ring_polling(xhci);
 
 	xhci_dbg(xhci, "Command ring memory map follows:\n");
 	xhci_debug_ring(xhci, xhci->cmd_ring);
@@ -488,11 +421,8 @@ void xhci_stop(struct usb_hcd *hcd)
 #if 0	/* No MSI yet */
 	xhci_cleanup_msix(xhci);
 #endif
-#ifdef CONFIG_USB_XHCI_HCD_DEBUGGING
-	/* Tell the event ring poll function not to reschedule */
-	xhci->zombie = 1;
-	del_timer_sync(&xhci->event_ring_timer);
-#endif
+
+	xhci_dbg_stop_ring_polling(xhci);
 
 	xhci_dbg(xhci, "// Disabling event ring interrupts\n");
 	temp = xhci_readl(xhci, &xhci->op_regs->status);
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 8778135..8d39f88 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1198,6 +1198,7 @@ static inline int xhci_link_trb_quirk(struct xhci_hcd *xhci)
 }
 
 /* xHCI debugging */
+#ifdef CONFIG_USB_XHCI_DEBUGGING
 void xhci_print_ir_set(struct xhci_hcd *xhci, struct xhci_intr_reg *ir_set, int set_num);
 void xhci_print_registers(struct xhci_hcd *xhci);
 void xhci_dbg_regs(struct xhci_hcd *xhci);
@@ -1210,6 +1211,24 @@ void xhci_dbg_erst(struct xhci_hcd *xhci, struct xhci_erst *erst);
 void xhci_dbg_cmd_ptrs(struct xhci_hcd *xhci);
 void xhci_dbg_ring_ptrs(struct xhci_hcd *xhci, struct xhci_ring *ring);
 void xhci_dbg_ctx(struct xhci_hcd *xhci, struct xhci_container_ctx *ctx, unsigned int last_ep);
+void xhci_dbg_init_ring_polling(struct xhci_hcd *xhci);
+void xhci_dbg_stop_ring_polling(struct xhci_hcd *xhci);
+#else
+static inline void xhci_print_ir_set(struct xhci_hcd *xhci, struct xhci_intr_reg *ir_set, int set_num) { }
+static inline void xhci_print_registers(struct xhci_hcd *xhci) { }
+static inline void xhci_dbg_regs(struct xhci_hcd *xhci) { }
+static inline void xhci_print_run_regs(struct xhci_hcd *xhci) { }
+static inline void xhci_print_trb_offsets(struct xhci_hcd *xhci, union xhci_trb *trb) { }
+static inline void xhci_debug_trb(struct xhci_hcd *xhci, union xhci_trb *trb) { }
+static inline void xhci_debug_segment(struct xhci_hcd *xhci, struct xhci_segment *seg) { }
+static inline void xhci_debug_ring(struct xhci_hcd *xhci, struct xhci_ring *ring) { }
+static inline void xhci_dbg_erst(struct xhci_hcd *xhci, struct xhci_erst *erst) { }
+static inline void xhci_dbg_cmd_ptrs(struct xhci_hcd *xhci) { }
+static inline void xhci_dbg_ring_ptrs(struct xhci_hcd *xhci, struct xhci_ring *ring) { }
+static inline void xhci_dbg_ctx(struct xhci_hcd *xhci, struct xhci_container_ctx *ctx, unsigned int last_ep) { }
+static inline void xhci_dbg_init_ring_polling(struct xhci_hcd *xhci) { }
+static inline void xhci_dbg_stop_ring_polling(struct xhci_hcd *xhci) { }
+#endif
 
 /* xHCI memory management */
 void xhci_mem_cleanup(struct xhci_hcd *xhci);

