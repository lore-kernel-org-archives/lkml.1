Return-Path: <linux-kernel-owner+w=401wt.eu-S1752242AbYLXTNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbYLXTNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 14:13:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbYLXTNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 14:13:25 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:50759 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751371AbYLXTNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 14:13:18 -0500
Date: Wed, 24 Dec 2008 22:13:16 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Timur Tabi <timur@freescale.com>, Li Yang <leoli@freescale.com>,
       linux-usb@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 2/3] USB: FHCI: Fix namespace pollution
Message-ID: <20081224191316.GB21815@oksana.dev.rtsoft.ru>
References: <20081223210322.GA2802@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081223210322.GA2802@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepend fhci_ prefixes to the external function names.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/usb/host/fhci-hcd.c   |   36 ++++++++--------
 drivers/usb/host/fhci-hub.c   |   29 +++++++------
 drivers/usb/host/fhci-mem.c   |   14 +++---
 drivers/usb/host/fhci-q.c     |   28 ++++++------
 drivers/usb/host/fhci-sched.c |   94 ++++++++++++++++++++--------------------
 drivers/usb/host/fhci-tds.c   |   51 +++++++++++-----------
 drivers/usb/host/fhci.h       |   90 +++++++++++++++++++-------------------
 7 files changed, 171 insertions(+), 171 deletions(-)

diff --git a/drivers/usb/host/fhci-hcd.c b/drivers/usb/host/fhci-hcd.c
index 47ac33f..269af3c 100644
--- a/drivers/usb/host/fhci-hcd.c
+++ b/drivers/usb/host/fhci-hcd.c
@@ -55,7 +55,7 @@ void fhci_stop_sof_timer(struct fhci_hcd *fhci)
 	fhci_dbg(fhci, "<- %s\n", __func__);
 }
 
-u16 get_sof_timer_count(struct fhci_usb *usb)
+u16 fhci_get_sof_timer_count(struct fhci_usb *usb)
 {
 	return be16_to_cpu(in_be16(&usb->fhci->regs->usb_sof_tmr) / 12);
 }
@@ -67,12 +67,12 @@ static u32 endpoint_zero_init(struct fhci_usb *usb,
 {
 	u32 rc;
 
-	rc = create_endpoint(usb, data_mem, ring_len);
+	rc = fhci_create_ep(usb, data_mem, ring_len);
 	if (rc)
 		return rc;
 
 	/* inilialize endpoint registers */
-	init_endpoint_registers(usb, usb->ep0, data_mem);
+	fhci_init_ep_registers(usb, usb->ep0, data_mem);
 
 	return 0;
 }
@@ -133,12 +133,12 @@ static u32 fhci_usb_disable(struct fhci_hcd *fhci)
 	struct fhci_usb *usb = fhci->usb_lld;
 
 	fhci_usb_disable_interrupt(usb);
-	usb_port_disable(fhci);
+	fhci_port_disable(fhci);
 
 	/* disable the usb controller */
 	if (usb->port_status == FHCI_PORT_FULL ||
 			usb->port_status == FHCI_PORT_LOW)
-		device_disconnected_interrupt(fhci);
+		fhci_device_disconnected_interrupt(fhci);
 
 	clrbits8(&usb->fhci->regs->usb_mod, USB_MODE_EN);
 
@@ -213,7 +213,7 @@ static int fhci_mem_init(struct fhci_hcd *fhci)
 			error = 1;
 			break;
 		}
-		recycle_empty_td(fhci, td);
+		fhci_recycle_empty_td(fhci, td);
 	}
 	for (i = 0; i < MAX_EDS; i++) {
 		struct ed *ed = kmalloc(sizeof(*ed), GFP_KERNEL);
@@ -222,7 +222,7 @@ static int fhci_mem_init(struct fhci_hcd *fhci)
 			error = 1;
 			break;
 		}
-		recycle_empty_ed(fhci, ed);
+		fhci_recycle_empty_ed(fhci, ed);
 	}
 
 	if (error) {
@@ -242,8 +242,8 @@ static void fhci_usb_free(void *lld)
 	struct fhci_hcd *fhci = usb->fhci;
 
 	if (usb) {
-		config_transceiver(fhci, FHCI_PORT_POWER_OFF);
-		endpoint_zero_free(usb);
+		fhci_config_transceiver(fhci, FHCI_PORT_POWER_OFF);
+		fhci_ep0_free(usb);
 		kfree(usb->actual_frame);
 		kfree(usb);
 	}
@@ -312,7 +312,7 @@ static struct fhci_usb *fhci_create_lld(struct fhci_hcd *fhci)
 	usb->hc_list = fhci->hc_list;
 	usb->vroot_hub = fhci->vroot_hub;
 
-	usb->transfer_confirm = transfer_confirm_callback;
+	usb->transfer_confirm = fhci_transfer_confirm_callback;
 
 	return usb;
 }
@@ -449,7 +449,7 @@ static int fhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 	urb->error_count = 0;
 	urb->hcpriv = urb_priv;
 
-	queue_urb(fhci, urb);
+	fhci_queue_urb(fhci, urb);
 err:
 	if (ret) {
 		kfree(urb_priv->tds);
@@ -493,7 +493,7 @@ static int fhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 		/* already pending? */
 		urb_priv->ed->state = FHCI_ED_URB_DEL;
 	} else {
-		urb_complete_free(fhci, urb);
+		fhci_urb_complete_free(fhci, urb);
 	}
 
 out2:
@@ -514,10 +514,10 @@ static void fhci_endpoint_disable(struct usb_hcd *hcd,
 	ed = ep->hcpriv;
 	if (ed) {
 		while (ed->td_head != NULL) {
-			struct td *td = remove_td_from_ed(ed);
-			urb_complete_free(fhci, td->urb);
+			struct td *td = fhci_remove_td_from_ed(ed);
+			fhci_urb_complete_free(fhci, td->urb);
 		}
-		recycle_empty_ed(fhci, ed);
+		fhci_recycle_empty_ed(fhci, ed);
 		ep->hcpriv = NULL;
 	}
 	spin_unlock_irqrestore(&fhci->lock, flags);
@@ -726,14 +726,14 @@ static int __devinit of_fhci_probe(struct of_device *ofdev,
 
 	dev_info(dev, "at 0x%p, irq %d\n", hcd->regs, usb_irq);
 
-	config_transceiver(fhci, FHCI_PORT_POWER_OFF);
+	fhci_config_transceiver(fhci, FHCI_PORT_POWER_OFF);
 
 	/* Start with full-speed, if possible. */
 	if (fhci->fullspeed_clk != QE_CLK_NONE) {
-		config_transceiver(fhci, FHCI_PORT_FULL);
+		fhci_config_transceiver(fhci, FHCI_PORT_FULL);
 		qe_usb_clock_set(fhci->fullspeed_clk, USB_CLOCK);
 	} else {
-		config_transceiver(fhci, FHCI_PORT_LOW);
+		fhci_config_transceiver(fhci, FHCI_PORT_LOW);
 		qe_usb_clock_set(fhci->lowspeed_clk, USB_CLOCK >> 3);
 	}
 
diff --git a/drivers/usb/host/fhci-hub.c b/drivers/usb/host/fhci-hub.c
index 540e165..0cfaedc 100644
--- a/drivers/usb/host/fhci-hub.c
+++ b/drivers/usb/host/fhci-hub.c
@@ -52,7 +52,8 @@ static void fhci_gpio_set_value(struct fhci_hcd *fhci, int gpio_nr, bool on)
 	mdelay(5);
 }
 
-void config_transceiver(struct fhci_hcd *fhci, enum fhci_port_status status)
+void fhci_config_transceiver(struct fhci_hcd *fhci,
+			     enum fhci_port_status status)
 {
 	fhci_dbg(fhci, "-> %s: %d\n", __func__, status);
 
@@ -79,7 +80,7 @@ void config_transceiver(struct fhci_hcd *fhci, enum fhci_port_status status)
 }
 
 /* disable the USB port by clearing the EN bit in the USBMOD register */
-void usb_port_disable(struct fhci_hcd *fhci)
+void fhci_port_disable(struct fhci_hcd *fhci)
 {
 	struct fhci_usb *usb = (struct fhci_usb *)fhci->usb_lld;
 	enum fhci_port_status port_status;
@@ -88,7 +89,7 @@ void usb_port_disable(struct fhci_hcd *fhci)
 
 	fhci_stop_sof_timer(fhci);
 
-	flush_all_transmissions(usb);
+	fhci_flush_all_transmissions(usb);
 
 	fhci_usb_disable_interrupt((struct fhci_usb *)fhci->usb_lld);
 	port_status = usb->port_status;
@@ -100,7 +101,7 @@ void usb_port_disable(struct fhci_hcd *fhci)
 
 	/* check if during the disconnection process attached new device */
 	if (port_status == FHCI_PORT_WAITING)
-		device_connected_interrupt(fhci);
+		fhci_device_connected_interrupt(fhci);
 	usb->vroot_hub->port.wPortStatus &= ~USB_PORT_STAT_ENABLE;
 	usb->vroot_hub->port.wPortChange |= USB_PORT_STAT_C_ENABLE;
 	fhci_usb_enable_interrupt((struct fhci_usb *)fhci->usb_lld);
@@ -109,14 +110,14 @@ void usb_port_disable(struct fhci_hcd *fhci)
 }
 
 /* enable the USB port by setting the EN bit in the USBMOD register */
-void usb_port_enable(void *lld)
+void fhci_port_enable(void *lld)
 {
 	struct fhci_usb *usb = (struct fhci_usb *)lld;
 	struct fhci_hcd *fhci = usb->fhci;
 
 	fhci_dbg(fhci, "-> %s\n", __func__);
 
-	config_transceiver(fhci, usb->port_status);
+	fhci_config_transceiver(fhci, usb->port_status);
 
 	if ((usb->port_status != FHCI_PORT_FULL) &&
 			(usb->port_status != FHCI_PORT_LOW))
@@ -128,7 +129,7 @@ void usb_port_enable(void *lld)
 	fhci_dbg(fhci, "<- %s\n", __func__);
 }
 
-void io_port_generate_reset(struct fhci_hcd *fhci)
+void fhci_io_port_generate_reset(struct fhci_hcd *fhci)
 {
 	fhci_dbg(fhci, "-> %s\n", __func__);
 
@@ -146,7 +147,7 @@ void io_port_generate_reset(struct fhci_hcd *fhci)
 }
 
 /* generate the RESET condition on the bus */
-void usb_port_reset(void *lld)
+void fhci_port_reset(void *lld)
 {
 	struct fhci_usb *usb = (struct fhci_usb *)lld;
 	struct fhci_hcd *fhci = usb->fhci;
@@ -164,7 +165,7 @@ void usb_port_reset(void *lld)
 	mask = in_be16(&fhci->regs->usb_mask);
 	out_be16(&fhci->regs->usb_mask, mask & (~USB_E_IDLE_MASK));
 
-	io_port_generate_reset(fhci);
+	fhci_io_port_generate_reset(fhci);
 
 	/* enable interrupt on this endpoint */
 	out_be16(&fhci->regs->usb_mask, mask);
@@ -233,7 +234,7 @@ int fhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		case USB_PORT_FEAT_ENABLE:
 			fhci->vroot_hub->port.wPortStatus &=
 			    ~USB_PORT_STAT_ENABLE;
-			usb_port_disable(fhci);
+			fhci_port_disable(fhci);
 			break;
 		case USB_PORT_FEAT_C_ENABLE:
 			fhci->vroot_hub->port.wPortChange &=
@@ -251,7 +252,7 @@ int fhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		case USB_PORT_FEAT_POWER:
 			fhci->vroot_hub->port.wPortStatus &=
 			    ~USB_PORT_STAT_POWER;
-			config_transceiver(fhci, FHCI_PORT_POWER_OFF);
+			fhci_config_transceiver(fhci, FHCI_PORT_POWER_OFF);
 			break;
 		case USB_PORT_FEAT_C_CONNECTION:
 			fhci->vroot_hub->port.wPortChange &=
@@ -306,7 +307,7 @@ int fhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		case USB_PORT_FEAT_ENABLE:
 			fhci->vroot_hub->port.wPortStatus |=
 			    USB_PORT_STAT_ENABLE;
-			usb_port_enable(fhci->usb_lld);
+			fhci_port_enable(fhci->usb_lld);
 			break;
 		case USB_PORT_FEAT_SUSPEND:
 			fhci->vroot_hub->port.wPortStatus |=
@@ -316,7 +317,7 @@ int fhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		case USB_PORT_FEAT_RESET:
 			fhci->vroot_hub->port.wPortStatus |=
 			    USB_PORT_STAT_RESET;
-			usb_port_reset(fhci->usb_lld);
+			fhci_port_reset(fhci->usb_lld);
 			fhci->vroot_hub->port.wPortStatus |=
 			    USB_PORT_STAT_ENABLE;
 			fhci->vroot_hub->port.wPortStatus &=
@@ -325,7 +326,7 @@ int fhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		case USB_PORT_FEAT_POWER:
 			fhci->vroot_hub->port.wPortStatus |=
 			    USB_PORT_STAT_POWER;
-			config_transceiver(fhci, FHCI_PORT_WAITING);
+			fhci_config_transceiver(fhci, FHCI_PORT_WAITING);
 			break;
 		default:
 			goto error;
diff --git a/drivers/usb/host/fhci-mem.c b/drivers/usb/host/fhci-mem.c
index c5ba0b0..2c0736c 100644
--- a/drivers/usb/host/fhci-mem.c
+++ b/drivers/usb/host/fhci-mem.c
@@ -55,13 +55,13 @@ static struct td *get_empty_td(struct fhci_hcd *fhci)
 	return td;
 }
 
-void recycle_empty_td(struct fhci_hcd *fhci, struct td *td)
+void fhci_recycle_empty_td(struct fhci_hcd *fhci, struct td *td)
 {
 	init_td(td);
 	list_add(&td->node, &fhci->empty_tds);
 }
 
-struct ed *get_empty_ed(struct fhci_hcd *fhci)
+struct ed *fhci_get_empty_ed(struct fhci_hcd *fhci)
 {
 	struct ed *ed;
 
@@ -79,16 +79,16 @@ struct ed *get_empty_ed(struct fhci_hcd *fhci)
 	return ed;
 }
 
-void recycle_empty_ed(struct fhci_hcd *fhci, struct ed *ed)
+void fhci_recycle_empty_ed(struct fhci_hcd *fhci, struct ed *ed)
 {
 	init_ed(ed);
 	list_add(&ed->node, &fhci->empty_eds);
 }
 
-struct td *td_fill(struct fhci_hcd *fhci, struct urb *urb,
-		struct urb_priv *urb_priv, struct ed *ed, u16 index,
-		enum fhci_ta_type type, int toggle, u8 *data, u32 len,
-		u16 interval, u16 start_frame, bool ioc)
+struct td *fhci_td_fill(struct fhci_hcd *fhci, struct urb *urb,
+			struct urb_priv *urb_priv, struct ed *ed, u16 index,
+			enum fhci_ta_type type, int toggle, u8 *data, u32 len,
+			u16 interval, u16 start_frame, bool ioc)
 {
 	struct td *td = get_empty_td(fhci);
 
diff --git a/drivers/usb/host/fhci-q.c b/drivers/usb/host/fhci-q.c
index 1173318..b0a1446 100644
--- a/drivers/usb/host/fhci-q.c
+++ b/drivers/usb/host/fhci-q.c
@@ -53,12 +53,12 @@ static int status_to_error(u32 status)
 		return -EINVAL;
 }
 
-void add_td_to_frame(struct fhci_time_frame *frame, struct td *td)
+void fhci_add_td_to_frame(struct fhci_time_frame *frame, struct td *td)
 {
 	list_add_tail(&td->frame_lh, &frame->tds_list);
 }
 
-void add_tds_to_ed(struct ed *ed, struct td **td_list, int number)
+void fhci_add_tds_to_ed(struct ed *ed, struct td **td_list, int number)
 {
 	int i;
 
@@ -82,7 +82,7 @@ static struct td *peek_td_from_ed(struct ed *ed)
 	return td;
 }
 
-struct td *remove_td_from_frame(struct fhci_time_frame *frame)
+struct td *fhci_remove_td_from_frame(struct fhci_time_frame *frame)
 {
 	struct td *td;
 
@@ -95,7 +95,7 @@ struct td *remove_td_from_frame(struct fhci_time_frame *frame)
 	return td;
 }
 
-struct td *peek_td_from_frame(struct fhci_time_frame *frame)
+struct td *fhci_peek_td_from_frame(struct fhci_time_frame *frame)
 {
 	struct td *td;
 
@@ -107,7 +107,7 @@ struct td *peek_td_from_frame(struct fhci_time_frame *frame)
 	return td;
 }
 
-struct td *remove_td_from_ed(struct ed *ed)
+struct td *fhci_remove_td_from_ed(struct ed *ed)
 {
 	struct td *td;
 
@@ -127,7 +127,7 @@ struct td *remove_td_from_ed(struct ed *ed)
 	return td;
 }
 
-struct td *remove_td_from_done_list(struct fhci_controller_list *p_list)
+struct td *fhci_remove_td_from_done_list(struct fhci_controller_list *p_list)
 {
 	struct td *td;
 
@@ -140,7 +140,7 @@ struct td *remove_td_from_done_list(struct fhci_controller_list *p_list)
 	return td;
 }
 
-void move_td_from_ed_to_done_list(struct fhci_usb *usb, struct ed *ed)
+void fhci_move_td_from_ed_to_done_list(struct fhci_usb *usb, struct ed *ed)
 {
 	struct td *td;
 
@@ -169,7 +169,7 @@ static void free_urb_priv(struct fhci_hcd *fhci, struct urb *urb)
 
 	for (i = 0; i < urb_priv->num_of_tds; i++) {
 		list_del_init(&urb_priv->tds[i]->node);
-		recycle_empty_td(fhci, urb_priv->tds[i]);
+		fhci_recycle_empty_td(fhci, urb_priv->tds[i]);
 	}
 
 	/* if this TD was the ED's head,find the next TD */
@@ -189,7 +189,7 @@ static void free_urb_priv(struct fhci_hcd *fhci, struct urb *urb)
 }
 
 /* this routine called to complete and free done URB */
-void urb_complete_free(struct fhci_hcd *fhci, struct urb *urb)
+void fhci_urb_complete_free(struct fhci_hcd *fhci, struct urb *urb)
 {
 	free_urb_priv(fhci, urb);
 
@@ -214,7 +214,7 @@ void urb_complete_free(struct fhci_hcd *fhci, struct urb *urb)
  * caculate transfer length/stats and update the urb
  * Precondition: irqsafe(only for urb-?status locking)
  */
-void done_td(struct urb *urb, struct td *td)
+void fhci_done_td(struct urb *urb, struct td *td)
 {
 	struct ed *ed = td->ed;
 	u32 cc = td->status;
@@ -265,20 +265,20 @@ void done_td(struct urb *urb, struct td *td)
 }
 
 /* there are some pedning request to unlink */
-void del_ed_list(struct fhci_hcd *fhci, struct ed *ed)
+void fhci_del_ed_list(struct fhci_hcd *fhci, struct ed *ed)
 {
 	struct td *td = peek_td_from_ed(ed);
 	struct urb *urb = td->urb;
 	struct urb_priv *urb_priv = urb->hcpriv;
 
 	if (urb_priv->state == URB_DEL) {
-		td = remove_td_from_ed(ed);
+		td = fhci_remove_td_from_ed(ed);
 		/* HC may have partly processed this TD */
 		if (td->status != USB_TD_INPROGRESS)
-			done_td(urb, td);
+			fhci_done_td(urb, td);
 
 		/* URB is done;clean up */
 		if (++(urb_priv->tds_cnt) == urb_priv->num_of_tds)
-			urb_complete_free(fhci, urb);
+			fhci_urb_complete_free(fhci, urb);
 	}
 }
diff --git a/drivers/usb/host/fhci-sched.c b/drivers/usb/host/fhci-sched.c
index 4d39b40..bb63b68 100644
--- a/drivers/usb/host/fhci-sched.c
+++ b/drivers/usb/host/fhci-sched.c
@@ -41,7 +41,7 @@ static void recycle_frame(struct fhci_usb *usb, struct packet *pkt)
 }
 
 /* confirm submitted packet */
-void transaction_confirm(struct fhci_usb *usb, struct packet *pkt)
+void fhci_transaction_confirm(struct fhci_usb *usb, struct packet *pkt)
 {
 	struct td *td;
 	struct packet *td_pkt;
@@ -49,7 +49,7 @@ void transaction_confirm(struct fhci_usb *usb, struct packet *pkt)
 	u32 trans_len;
 	bool td_done = false;
 
-	td = remove_td_from_frame(usb->actual_frame);
+	td = fhci_remove_td_from_frame(usb->actual_frame);
 	td_pkt = td->pkt;
 	trans_len = pkt->len;
 	td->status = pkt->status;
@@ -119,7 +119,7 @@ void transaction_confirm(struct fhci_usb *usb, struct packet *pkt)
 	}
 
 	if (td_done)
-		move_td_from_ed_to_done_list(usb, ed);
+		fhci_move_td_from_ed_to_done_list(usb, ed);
 }
 
 /*
@@ -127,7 +127,7 @@ void transaction_confirm(struct fhci_usb *usb, struct packet *pkt)
  * This routine is called when disabling the USB port to flush all
  * transmissions that are allready scheduled in the BDs
  */
-void flush_all_transmissions(struct fhci_usb *usb)
+void fhci_flush_all_transmissions(struct fhci_usb *usb)
 {
 	u8 mode;
 	struct td *td;
@@ -135,13 +135,13 @@ void flush_all_transmissions(struct fhci_usb *usb)
 	mode = in_8(&usb->fhci->regs->usb_mod);
 	clrbits8(&usb->fhci->regs->usb_mod, USB_MODE_EN);
 
-	flush_bds(usb);
+	fhci_flush_bds(usb);
 
-	while ((td = peek_td_from_frame(usb->actual_frame)) != NULL) {
+	while ((td = fhci_peek_td_from_frame(usb->actual_frame)) != NULL) {
 		struct packet *pkt = td->pkt;
 
 		pkt->status = USB_TD_TX_ER_TIMEOUT;
-		transaction_confirm(usb, pkt);
+		fhci_transaction_confirm(usb, pkt);
 	}
 
 	usb->actual_frame->frame_status = FRAME_END_TRANSMISSION;
@@ -207,7 +207,7 @@ static int add_packet(struct fhci_usb *usb, struct ed *ed, struct td *td)
 	if (usb->actual_frame->frame_status != FRAME_IS_PREPARED &&
 	    (usb->actual_frame->frame_status & FRAME_END_TRANSMISSION ||
 	     (fw_transaction_time + usb->sw_transaction_time >=
-	      1000 - get_sof_timer_count(usb)))) {
+	      1000 - fhci_get_sof_timer_count(usb)))) {
 		fhci_dbg(usb->fhci, "not enough time in this frame\n");
 		return -1;
 	}
@@ -233,14 +233,14 @@ static int add_packet(struct fhci_usb *usb, struct ed *ed, struct td *td)
 	td->status = USB_TD_INPROGRESS;
 	/* update actual frame time object with the actual transmission */
 	usb->actual_frame->total_bytes += (len + PROTOCOL_OVERHEAD);
-	add_td_to_frame(usb->actual_frame, td);
+	fhci_add_td_to_frame(usb->actual_frame, td);
 
 	if (usb->port_status != FHCI_PORT_FULL &&
 			usb->port_status != FHCI_PORT_LOW) {
 		pkt->status = USB_TD_TX_ER_TIMEOUT;
 		pkt->len = 0;
-		transaction_confirm(usb, pkt);
-	} else if (host_transaction(usb, pkt, td->type, ed->dev_addr,
+		fhci_transaction_confirm(usb, pkt);
+	} else if (fhci_host_transaction(usb, pkt, td->type, ed->dev_addr,
 			ed->ep_addr, ed->mode, ed->speed, td->toggle)) {
 		/* remove TD from actual frame */
 		list_del_init(&td->frame_lh);
@@ -295,7 +295,7 @@ static int scan_ed_list(struct fhci_usb *usb,
 		if (ed->state != FHCI_ED_OPER) {
 			if (ed->state == FHCI_ED_URB_DEL) {
 				td->status = USB_TD_OK;
-				move_td_from_ed_to_done_list(usb, ed);
+				fhci_move_td_from_ed_to_done_list(usb, ed);
 				ed->state = FHCI_ED_SKIP;
 			}
 			continue;
@@ -321,7 +321,7 @@ static int scan_ed_list(struct fhci_usb *usb,
 					usb->max_bytes_per_frame) {
 			usb->actual_frame->frame_status =
 				FRAME_DATA_END_TRANSMISSION;
-			push_dummy_bd(usb->ep0);
+			fhci_push_dummy_bd(usb->ep0);
 			ans = 0;
 			break;
 		}
@@ -344,7 +344,7 @@ static u32 rotate_frames(struct fhci_usb *usb)
 	if (!list_empty(&usb->actual_frame->tds_list)) {
 		if ((((in_be16(&fhci->pram->frame_num) & 0x07ff) -
 		      usb->actual_frame->frame_num) & 0x7ff) > 5)
-			flush_actual_frame(usb);
+			fhci_flush_actual_frame(usb);
 		else
 			return -EINVAL;
 	}
@@ -360,7 +360,7 @@ static u32 rotate_frames(struct fhci_usb *usb)
  * This function schedule the USB transaction and will process the
  * endpoint in the following order: iso, interrupt, control and bulk.
  */
-void schedule_transactions(struct fhci_usb *usb)
+void fhci_schedule_transactions(struct fhci_usb *usb)
 {
 	int left = 1;
 
@@ -419,14 +419,14 @@ static void sof_interrupt(struct fhci_hcd *fhci)
 
 	gtm_set_exact_timer16(fhci->timer, usb->max_frame_usage, false);
 
-	host_transmit_actual_frame(usb);
+	fhci_host_transmit_actual_frame(usb);
 	usb->actual_frame->frame_status = FRAME_IS_TRANSMITTED;
 
-	schedule_transactions(usb);
+	fhci_schedule_transactions(usb);
 }
 
 /* Handles device disconnected interrupt on port */
-void device_disconnected_interrupt(struct fhci_hcd *fhci)
+void fhci_device_disconnected_interrupt(struct fhci_hcd *fhci)
 {
 	struct fhci_usb *usb = fhci->usb_lld;
 
@@ -451,7 +451,7 @@ void device_disconnected_interrupt(struct fhci_hcd *fhci)
 }
 
 /* detect a new device connected on the USB port */
-void device_connected_interrupt(struct fhci_hcd *fhci)
+void fhci_device_connected_interrupt(struct fhci_hcd *fhci)
 {
 
 	struct fhci_usb *usb = fhci->usb_lld;
@@ -481,7 +481,7 @@ void device_connected_interrupt(struct fhci_hcd *fhci)
 		    USB_PORT_STAT_C_CONNECTION;
 		usb->max_bytes_per_frame =
 		    (MAX_BYTES_PER_FRAME >> 3) - 7;
-		usb_port_enable(usb);
+		fhci_port_enable(usb);
 	} else if (state == 2) {
 		ret = qe_usb_clock_set(fhci->fullspeed_clk, USB_CLOCK);
 		if (ret) {
@@ -499,7 +499,7 @@ void device_connected_interrupt(struct fhci_hcd *fhci)
 		usb->vroot_hub->port.wPortChange |=
 		    USB_PORT_STAT_C_CONNECTION;
 		usb->max_bytes_per_frame = (MAX_BYTES_PER_FRAME - 15);
-		usb_port_enable(usb);
+		fhci_port_enable(usb);
 	}
 out:
 	fhci_usb_enable_interrupt(usb);
@@ -518,10 +518,10 @@ irqreturn_t fhci_frame_limit_timer_irq(int irq, void *_hcd)
 
 	if (usb->actual_frame->frame_status == FRAME_IS_TRANSMITTED) {
 		usb->actual_frame->frame_status = FRAME_TIMER_END_TRANSMISSION;
-		push_dummy_bd(usb->ep0);
+		fhci_push_dummy_bd(usb->ep0);
 	}
 
-	schedule_transactions(usb);
+	fhci_schedule_transactions(usb);
 
 	spin_unlock(&fhci->lock);
 
@@ -538,7 +538,7 @@ static void abort_transmission(struct fhci_usb *usb)
 	out_8(&usb->fhci->regs->usb_comm, USB_CMD_FLUSH_FIFO | EP_ZERO);
 	udelay(1000);
 	/* reset Tx BDs */
-	flush_bds(usb);
+	fhci_flush_bds(usb);
 	/* issue restart Tx command */
 	qe_issue_cmd(QE_USB_RESTART_TX, QE_CR_SUBBLOCK_USB, EP_ZERO, 0);
 	fhci_dbg(usb->fhci, "<- %s\n", __func__);
@@ -566,7 +566,7 @@ irqreturn_t fhci_irq(struct usb_hcd *hcd)
 	if (usb_er & USB_E_RESET_MASK) {
 		if ((usb->port_status == FHCI_PORT_FULL) ||
 				(usb->port_status == FHCI_PORT_LOW)) {
-			device_disconnected_interrupt(fhci);
+			fhci_device_disconnected_interrupt(fhci);
 			usb_er &= ~USB_E_IDLE_MASK;
 		} else if (usb->port_status == FHCI_PORT_WAITING) {
 			usb->port_status = FHCI_PORT_DISCONNECTING;
@@ -579,7 +579,7 @@ irqreturn_t fhci_irq(struct usb_hcd *hcd)
 			if (fhci_ioports_check_bus_state(fhci) == 1 &&
 					usb->port_status != FHCI_PORT_LOW &&
 					usb->port_status != FHCI_PORT_FULL)
-				device_connected_interrupt(fhci);
+				fhci_device_connected_interrupt(fhci);
 		}
 		usb_er &= ~USB_E_RESET_MASK;
 	}
@@ -595,12 +595,12 @@ irqreturn_t fhci_irq(struct usb_hcd *hcd)
 	}
 
 	if (usb_er & USB_E_TXB_MASK) {
-		tx_conf_interrupt(fhci->usb_lld);
+		fhci_tx_conf_interrupt(fhci->usb_lld);
 		usb_er &= ~USB_E_TXB_MASK;
 	}
 
 	if (usb_er & USB_E_TXE1_MASK) {
-		tx_conf_interrupt(fhci->usb_lld);
+		fhci_tx_conf_interrupt(fhci->usb_lld);
 		usb_er &= ~USB_E_TXE1_MASK;
 	}
 
@@ -609,7 +609,7 @@ irqreturn_t fhci_irq(struct usb_hcd *hcd)
 				usb->port_status != FHCI_PORT_LOW &&
 				usb->port_status != FHCI_PORT_FULL) {
 			usb_er &= ~USB_E_RESET_MASK;
-			device_connected_interrupt(fhci);
+			fhci_device_connected_interrupt(fhci);
 		} else if (usb->port_status ==
 				FHCI_PORT_DISCONNECTING) {
 			/* XXX usb->port_status = FHCI_PORT_WAITING; */
@@ -649,14 +649,14 @@ static void process_done_list(unsigned long data)
 	disable_irq(fhci_to_hcd(fhci)->irq);
 	spin_lock(&fhci->lock);
 
-	td = remove_td_from_done_list(fhci->hc_list);
+	td = fhci_remove_td_from_done_list(fhci->hc_list);
 	while (td != NULL) {
 		urb = td->urb;
 		urb_priv = urb->hcpriv;
 		ed = td->ed;
 
 		/* update URB's length and status from TD */
-		done_td(urb, td);
+		fhci_done_td(urb, td);
 		urb_priv->tds_cnt++;
 
 		/*
@@ -666,19 +666,19 @@ static void process_done_list(unsigned long data)
 		 * (real work done in a SOF intr, by process_del_list)
 		 */
 		if (urb_priv->tds_cnt == urb_priv->num_of_tds) {
-			urb_complete_free(fhci, urb);
+			fhci_urb_complete_free(fhci, urb);
 		} else if (urb_priv->state == URB_DEL &&
 				ed->state == FHCI_ED_SKIP) {
-			del_ed_list(fhci, ed);
+			fhci_del_ed_list(fhci, ed);
 			ed->state = FHCI_ED_OPER;
 		} else if (ed->state == FHCI_ED_HALTED) {
 			urb_priv->state = URB_DEL;
 			ed->state = FHCI_ED_URB_DEL;
-			del_ed_list(fhci, ed);
+			fhci_del_ed_list(fhci, ed);
 			ed->state = FHCI_ED_OPER;
 		}
 
-		td = remove_td_from_done_list(fhci->hc_list);
+		td = fhci_remove_td_from_done_list(fhci->hc_list);
 	}
 
 	spin_unlock(&fhci->lock);
@@ -689,7 +689,7 @@ static void process_done_list(unsigned long data)
 DECLARE_TASKLET(fhci_tasklet, process_done_list, 0);
 
 /* transfer complted callback */
-u32 transfer_confirm_callback(struct fhci_hcd *fhci)
+u32 fhci_transfer_confirm_callback(struct fhci_hcd *fhci)
 {
 	if (!fhci->process_done_task->state)
 		tasklet_schedule(fhci->process_done_task);
@@ -703,7 +703,7 @@ u32 transfer_confirm_callback(struct fhci_hcd *fhci)
  * ep		USB Host endpoint data structure
  * urb		USB request block data structure
  */
-void queue_urb(struct fhci_hcd *fhci, struct urb *urb)
+void fhci_queue_urb(struct fhci_hcd *fhci, struct urb *urb)
 {
 	struct ed *ed = urb->ep->hcpriv;
 	struct urb_priv *urb_priv = urb->hcpriv;
@@ -715,7 +715,7 @@ void queue_urb(struct fhci_hcd *fhci, struct urb *urb)
 	u16 cnt = 0;
 
 	if (ed == NULL) {
-		ed = get_empty_ed(fhci);
+		ed = fhci_get_empty_ed(fhci);
 		ed->dev_addr = usb_pipedevice(urb->pipe);
 		ed->ep_addr = usb_pipeendpoint(urb->pipe);
 		switch (usb_pipetype(urb->pipe)) {
@@ -777,7 +777,7 @@ void queue_urb(struct fhci_hcd *fhci, struct urb *urb)
 				usb_pipeout(urb->pipe))) == 0))
 			urb_state = US_BULK0;
 		while (data_len > 4096) {
-			td = td_fill(fhci, urb, urb_priv, ed, cnt,
+			td = fhci_td_fill(fhci, urb, urb_priv, ed, cnt,
 				usb_pipeout(urb->pipe) ? FHCI_TA_OUT :
 							 FHCI_TA_IN,
 				cnt ? USB_TD_TOGGLE_CARRY :
@@ -788,7 +788,7 @@ void queue_urb(struct fhci_hcd *fhci, struct urb *urb)
 			cnt++;
 		}
 
-		td = td_fill(fhci, urb, urb_priv, ed, cnt,
+		td = fhci_td_fill(fhci, urb, urb_priv, ed, cnt,
 			usb_pipeout(urb->pipe) ? FHCI_TA_OUT : FHCI_TA_IN,
 			cnt ? USB_TD_TOGGLE_CARRY : toggle,
 			data, data_len, 0, 0, true);
@@ -796,7 +796,7 @@ void queue_urb(struct fhci_hcd *fhci, struct urb *urb)
 
 		if (urb->transfer_flags & URB_ZERO_PACKET &&
 				cnt < urb_priv->num_of_tds) {
-			td = td_fill(fhci, urb, urb_priv, ed, cnt,
+			td = fhci_td_fill(fhci, urb, urb_priv, ed, cnt,
 				usb_pipeout(urb->pipe) ? FHCI_TA_OUT :
 							 FHCI_TA_IN,
 				USB_TD_TOGGLE_CARRY, NULL, 0, 0, 0, true);
@@ -805,7 +805,7 @@ void queue_urb(struct fhci_hcd *fhci, struct urb *urb)
 		break;
 	case FHCI_TF_INTR:
 		urb->start_frame = get_frame_num(fhci) + 1;
-		td = td_fill(fhci, urb, urb_priv, ed, cnt++,
+		td = fhci_td_fill(fhci, urb, urb_priv, ed, cnt++,
 			usb_pipeout(urb->pipe) ? FHCI_TA_OUT : FHCI_TA_IN,
 			USB_TD_TOGGLE_DATA0, data, data_len,
 			urb->interval, urb->start_frame, true);
@@ -814,17 +814,17 @@ void queue_urb(struct fhci_hcd *fhci, struct urb *urb)
 		ed->dev_addr = usb_pipedevice(urb->pipe);
 		ed->max_pkt_size = usb_maxpacket(urb->dev, urb->pipe,
 			usb_pipeout(urb->pipe));
-		td = td_fill(fhci, urb, urb_priv, ed, cnt++, FHCI_TA_SETUP,
+		td = fhci_td_fill(fhci, urb, urb_priv, ed, cnt++, FHCI_TA_SETUP,
 			USB_TD_TOGGLE_DATA0, urb->setup_packet, 8, 0, 0, true);
 
 		if (data_len > 0) {
-			td = td_fill(fhci, urb, urb_priv, ed, cnt++,
+			td = fhci_td_fill(fhci, urb, urb_priv, ed, cnt++,
 				usb_pipeout(urb->pipe) ? FHCI_TA_OUT :
 							 FHCI_TA_IN,
 				USB_TD_TOGGLE_DATA1, data, data_len, 0, 0,
 				true);
 		}
-		td = td_fill(fhci, urb, urb_priv, ed, cnt++,
+		td = fhci_td_fill(fhci, urb, urb_priv, ed, cnt++,
 			usb_pipeout(urb->pipe) ? FHCI_TA_IN : FHCI_TA_OUT,
 			USB_TD_TOGGLE_DATA1, data, 0, 0, 0, true);
 		urb_state = US_CTRL_SETUP;
@@ -840,7 +840,7 @@ void queue_urb(struct fhci_hcd *fhci, struct urb *urb)
 			 */
 			frame += cnt * urb->interval;
 			frame &= 0x07ff;
-			td = td_fill(fhci, urb, urb_priv, ed, cnt,
+			td = fhci_td_fill(fhci, urb, urb_priv, ed, cnt,
 				usb_pipeout(urb->pipe) ? FHCI_TA_OUT :
 							 FHCI_TA_IN,
 				USB_TD_TOGGLE_DATA0,
@@ -883,6 +883,6 @@ void queue_urb(struct fhci_hcd *fhci, struct urb *urb)
 		}
 	}
 
-	add_tds_to_ed(ed, urb_priv->tds, urb_priv->num_of_tds);
+	fhci_add_tds_to_ed(ed, urb_priv->tds, urb_priv->num_of_tds);
 	fhci->active_urbs++;
 }
diff --git a/drivers/usb/host/fhci-tds.c b/drivers/usb/host/fhci-tds.c
index 90e74ca..b403322 100644
--- a/drivers/usb/host/fhci-tds.c
+++ b/drivers/usb/host/fhci-tds.c
@@ -82,7 +82,7 @@ static struct usb_td __iomem *next_bd(struct usb_td __iomem *base,
 		return ++td;
 }
 
-void push_dummy_bd(struct endpoint *ep)
+void fhci_push_dummy_bd(struct endpoint *ep)
 {
 	if (ep->already_pushed_dummy_bd == false) {
 		u16 td_status = in_be16(&ep->empty_td->status);
@@ -95,7 +95,7 @@ void push_dummy_bd(struct endpoint *ep)
 }
 
 /* destroy an USB endpoint */
-void endpoint_zero_free(struct fhci_usb *usb)
+void fhci_ep0_free(struct fhci_usb *usb)
 {
 	struct endpoint *ep;
 	int size;
@@ -148,7 +148,7 @@ void endpoint_zero_free(struct fhci_usb *usb)
  * data_mem	The data memory partition(BUS)
  * ring_len	TD ring length
  */
-u32 create_endpoint(struct fhci_usb *usb, enum fhci_mem_alloc data_mem,
+u32 fhci_create_ep(struct fhci_usb *usb, enum fhci_mem_alloc data_mem,
 			   u32 ring_len)
 {
 	struct endpoint *ep;
@@ -229,7 +229,7 @@ u32 create_endpoint(struct fhci_usb *usb, enum fhci_mem_alloc data_mem,
 
 	return 0;
 err:
-	endpoint_zero_free(usb);
+	fhci_ep0_free(usb);
 	kfree(ep);
 	fhci_err(usb->fhci, "no memory for the %s\n", err_for);
 	return -ENOMEM;
@@ -243,9 +243,8 @@ err:
  * ep		A pointer to the endpoint structre
  * data_mem	The data memory partition(BUS)
  */
-void init_endpoint_registers(struct fhci_usb *usb,
-				    struct endpoint *ep,
-				    enum fhci_mem_alloc data_mem)
+void fhci_init_ep_registers(struct fhci_usb *usb, struct endpoint *ep,
+			    enum fhci_mem_alloc data_mem)
 {
 	u8 rt;
 
@@ -277,9 +276,9 @@ void init_endpoint_registers(struct fhci_usb *usb,
  * confirmation about the submitted frames. Otherwise, the routine is
  * called frome the interrupt service routine during the Tx interrupt.
  * In that case the application is informed by calling the application
- * specific 'transaction_confirm' routine
+ * specific 'fhci_transaction_confirm' routine
  */
-static void td_transaction_confirm(struct fhci_usb *usb)
+static void fhci_td_transaction_confirm(struct fhci_usb *usb)
 {
 	struct endpoint *ep = usb->ep0;
 	struct packet *pkt;
@@ -361,7 +360,7 @@ static void td_transaction_confirm(struct fhci_usb *usb)
 		else
 			pkt->len = td_length;
 
-		transaction_confirm(usb, pkt);
+		fhci_transaction_confirm(usb, pkt);
 	}
 }
 
@@ -379,13 +378,13 @@ static void td_transaction_confirm(struct fhci_usb *usb)
  * dest_speed   USB speed - Low speed or FULL speed
  * data_toggle  Data sequence toggle - 0 or 1
  */
-u32 host_transaction(struct fhci_usb *usb,
-			    struct packet *pkt,
-			    enum fhci_ta_type trans_type,
-			    u8 dest_addr,
-			    u8 dest_ep,
-			    enum fhci_tf_mode trans_mode,
-			    enum fhci_speed dest_speed, u8 data_toggle)
+u32 fhci_host_transaction(struct fhci_usb *usb,
+			  struct packet *pkt,
+			  enum fhci_ta_type trans_type,
+			  u8 dest_addr,
+			  u8 dest_ep,
+			  enum fhci_tf_mode trans_mode,
+			  enum fhci_speed dest_speed, u8 data_toggle)
 {
 	struct endpoint *ep = usb->ep0;
 	struct usb_td __iomem *td;
@@ -470,7 +469,7 @@ u32 host_transaction(struct fhci_usb *usb,
 }
 
 /* Reset the Tx BD ring */
-void flush_bds(struct fhci_usb *usb)
+void fhci_flush_bds(struct fhci_usb *usb)
 {
 	u16 extra_data;
 	u16 td_status;
@@ -497,7 +496,7 @@ void flush_bds(struct fhci_usb *usb)
 		td++;
 	}
 
-	td_transaction_confirm(usb);
+	fhci_td_transaction_confirm(usb);
 
 	td = ep->td_base;
 	do {
@@ -525,7 +524,7 @@ void flush_bds(struct fhci_usb *usb)
  * This routine is called when something wrong with the controller and
  * we want to get rid of the actual frame and start again next frame
  */
-void flush_actual_frame(struct fhci_usb *usb)
+void fhci_flush_actual_frame(struct fhci_usb *usb)
 {
 	u8 mode;
 	u16 tb_ptr;
@@ -560,7 +559,7 @@ void flush_actual_frame(struct fhci_usb *usb)
 		extra_data = in_be16(&td->extra);
 	} while ((td_status & TD_R) || buf_ptr);
 
-	td_transaction_confirm(usb);
+	fhci_td_transaction_confirm(usb);
 
 	out_be16(&ep->ep_pram_ptr->tx_bd_ptr,
 		 in_be16(&ep->ep_pram_ptr->tx_base));
@@ -578,21 +577,21 @@ void flush_actual_frame(struct fhci_usb *usb)
 }
 
 /* handles Tx confirm and Tx error interrupt */
-void tx_conf_interrupt(struct fhci_usb *usb)
+void fhci_tx_conf_interrupt(struct fhci_usb *usb)
 {
-	td_transaction_confirm(usb);
+	fhci_td_transaction_confirm(usb);
 
 	/*
 	 * Schedule another transaction to this frame only if we have
 	 * already confirmed all transaction in the frame.
 	 */
-	if (((get_sof_timer_count(usb) < usb->max_frame_usage) ||
+	if (((fhci_get_sof_timer_count(usb) < usb->max_frame_usage) ||
 	     (usb->actual_frame->frame_status & FRAME_END_TRANSMISSION)) &&
 	    (list_empty(&usb->actual_frame->tds_list)))
-		schedule_transactions(usb);
+		fhci_schedule_transactions(usb);
 }
 
-void host_transmit_actual_frame(struct fhci_usb *usb)
+void fhci_host_transmit_actual_frame(struct fhci_usb *usb)
 {
 	u16 tb_ptr;
 	u16 td_status;
diff --git a/drivers/usb/host/fhci.h b/drivers/usb/host/fhci.h
index d1b6bbe..7116284 100644
--- a/drivers/usb/host/fhci.h
+++ b/drivers/usb/host/fhci.h
@@ -524,71 +524,71 @@ static inline void *cq_get(struct kfifo *kfifo)
 /* fhci-hcd.c */
 void fhci_start_sof_timer(struct fhci_hcd *fhci);
 void fhci_stop_sof_timer(struct fhci_hcd *fhci);
-u16 get_sof_timer_count(struct fhci_usb *usb);
+u16 fhci_get_sof_timer_count(struct fhci_usb *usb);
 void fhci_usb_enable_interrupt(struct fhci_usb *usb);
 void fhci_usb_disable_interrupt(struct fhci_usb *usb);
 int fhci_ioports_check_bus_state(struct fhci_hcd *fhci);
 
 /* fhci-mem.c */
-void recycle_empty_td(struct fhci_hcd *fhci, struct td *td);
-void recycle_empty_ed(struct fhci_hcd *fhci, struct ed *ed);
-struct ed *get_empty_ed(struct fhci_hcd *fhci);
-struct td *td_fill(struct fhci_hcd *fhci, struct urb *urb,
-		   struct urb_priv *urb_priv, struct ed *ed, u16 index,
-		   enum fhci_ta_type type, int toggle, u8 *data, u32 len,
-		   u16 interval, u16 start_frame, bool ioc);
-void add_tds_to_ed(struct ed *ed, struct td **td_list, int number);
+void fhci_recycle_empty_td(struct fhci_hcd *fhci, struct td *td);
+void fhci_recycle_empty_ed(struct fhci_hcd *fhci, struct ed *ed);
+struct ed *fhci_get_empty_ed(struct fhci_hcd *fhci);
+struct td *fhci_td_fill(struct fhci_hcd *fhci, struct urb *urb,
+			struct urb_priv *urb_priv, struct ed *ed, u16 index,
+			enum fhci_ta_type type, int toggle, u8 *data, u32 len,
+			u16 interval, u16 start_frame, bool ioc);
+void fhci_add_tds_to_ed(struct ed *ed, struct td **td_list, int number);
 
 /* fhci-hub.c */
-void config_transceiver(struct fhci_hcd *fhci,
+void fhci_config_transceiver(struct fhci_hcd *fhci,
 			enum fhci_port_status status);
-void usb_port_disable(struct fhci_hcd *fhci);
-void usb_port_enable(void *lld);
-void io_port_generate_reset(struct fhci_hcd *fhci);
-void usb_port_reset(void *lld);
+void fhci_port_disable(struct fhci_hcd *fhci);
+void fhci_port_enable(void *lld);
+void fhci_io_port_generate_reset(struct fhci_hcd *fhci);
+void fhci_port_reset(void *lld);
 int fhci_hub_status_data(struct usb_hcd *hcd, char *buf);
 int fhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		     u16 wIndex, char *buf, u16 wLength);
 
 /* fhci-tds.c */
-void flush_bds(struct fhci_usb *usb);
-void flush_actual_frame(struct fhci_usb *usb);
-u32 host_transaction(struct fhci_usb *usb,
-		     struct packet *pkt, enum fhci_ta_type trans_type,
-		     u8 dest_addr, u8 dest_ep, enum fhci_tf_mode trans_mode,
-		     enum fhci_speed dest_speed, u8 data_toggle);
-void host_transmit_actual_frame(struct fhci_usb *usb);
-void tx_conf_interrupt(struct fhci_usb *usb);
-void push_dummy_bd(struct endpoint *ep);
-u32 create_endpoint(struct fhci_usb *usb, enum fhci_mem_alloc data_mem,
-		    u32 ring_len);
-void init_endpoint_registers(struct fhci_usb *usb,
-			     struct endpoint *ep,
-			     enum fhci_mem_alloc data_mem);
-void endpoint_zero_free(struct fhci_usb *usb);
+void fhci_flush_bds(struct fhci_usb *usb);
+void fhci_flush_actual_frame(struct fhci_usb *usb);
+u32 fhci_host_transaction(struct fhci_usb *usb, struct packet *pkt,
+			  enum fhci_ta_type trans_type, u8 dest_addr,
+			  u8 dest_ep, enum fhci_tf_mode trans_mode,
+			  enum fhci_speed dest_speed, u8 data_toggle);
+void fhci_host_transmit_actual_frame(struct fhci_usb *usb);
+void fhci_tx_conf_interrupt(struct fhci_usb *usb);
+void fhci_push_dummy_bd(struct endpoint *ep);
+u32 fhci_create_ep(struct fhci_usb *usb, enum fhci_mem_alloc data_mem,
+		   u32 ring_len);
+void fhci_init_ep_registers(struct fhci_usb *usb,
+			    struct endpoint *ep,
+			    enum fhci_mem_alloc data_mem);
+void fhci_ep0_free(struct fhci_usb *usb);
 
 /* fhci-sched.c */
 extern struct tasklet_struct fhci_tasklet;
-void transaction_confirm(struct fhci_usb *usb, struct packet *pkt);
-void flush_all_transmissions(struct fhci_usb *usb);
-void schedule_transactions(struct fhci_usb *usb);
-void device_connected_interrupt(struct fhci_hcd *fhci);
-void device_disconnected_interrupt(struct fhci_hcd *fhci);
-void queue_urb(struct fhci_hcd *fhci, struct urb *urb);
-u32 transfer_confirm_callback(struct fhci_hcd *fhci);
+void fhci_transaction_confirm(struct fhci_usb *usb, struct packet *pkt);
+void fhci_flush_all_transmissions(struct fhci_usb *usb);
+void fhci_schedule_transactions(struct fhci_usb *usb);
+void fhci_device_connected_interrupt(struct fhci_hcd *fhci);
+void fhci_device_disconnected_interrupt(struct fhci_hcd *fhci);
+void fhci_queue_urb(struct fhci_hcd *fhci, struct urb *urb);
+u32 fhci_transfer_confirm_callback(struct fhci_hcd *fhci);
 irqreturn_t fhci_irq(struct usb_hcd *hcd);
 irqreturn_t fhci_frame_limit_timer_irq(int irq, void *_hcd);
 
 /* fhci-q.h */
-void urb_complete_free(struct fhci_hcd *fhci, struct urb *urb);
-struct td *remove_td_from_ed(struct ed *ed);
-struct td *remove_td_from_frame(struct fhci_time_frame *frame);
-void move_td_from_ed_to_done_list(struct fhci_usb *usb, struct ed *ed);
-struct td *peek_td_from_frame(struct fhci_time_frame *frame);
-void add_td_to_frame(struct fhci_time_frame *frame, struct td *td);
-struct td *remove_td_from_done_list(struct fhci_controller_list *p_list);
-void done_td(struct urb *urb, struct td *td);
-void del_ed_list(struct fhci_hcd *fhci, struct ed *ed);
+void fhci_urb_complete_free(struct fhci_hcd *fhci, struct urb *urb);
+struct td *fhci_remove_td_from_ed(struct ed *ed);
+struct td *fhci_remove_td_from_frame(struct fhci_time_frame *frame);
+void fhci_move_td_from_ed_to_done_list(struct fhci_usb *usb, struct ed *ed);
+struct td *fhci_peek_td_from_frame(struct fhci_time_frame *frame);
+void fhci_add_td_to_frame(struct fhci_time_frame *frame, struct td *td);
+struct td *fhci_remove_td_from_done_list(struct fhci_controller_list *p_list);
+void fhci_done_td(struct urb *urb, struct td *td);
+void fhci_del_ed_list(struct fhci_hcd *fhci, struct ed *ed);
 
 #ifdef CONFIG_FHCI_DEBUG
 
-- 
1.5.6.5

