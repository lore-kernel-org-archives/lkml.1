Return-Path: <linux-kernel-owner+w=401wt.eu-S1760596AbXJXQqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760596AbXJXQqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760094AbXJXQ0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:26:07 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60993 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759386AbXJXQ0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:26:04 -0400
Date: Wed, 24 Oct 2007 18:26:32 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Marcel Holtmann <marcel@holtmann.org>, maxk@qualcomm.com
Cc: bluez-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/bluetooth/bpa10x.c: fix memleak
Message-ID: <20071024162632.GL30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixea a memleak spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/bluetooth/bpa10x.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6/drivers/bluetooth/bpa10x.c.old	2007-10-23 22:20:10.000000000 +0200
+++ linux-2.6/drivers/bluetooth/bpa10x.c	2007-10-23 22:22:01.000000000 +0200
@@ -378,96 +378,97 @@ static int bpa10x_send_frame(struct sk_b
 	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!urb)
 		return -ENOMEM;
 
 	/* Prepend skb with frame type */
 	*skb_push(skb, 1) = bt_cb(skb)->pkt_type;
 
 	switch (bt_cb(skb)->pkt_type) {
 	case HCI_COMMAND_PKT:
 		dr = kmalloc(sizeof(*dr), GFP_ATOMIC);
 		if (!dr) {
 			usb_free_urb(urb);
 			return -ENOMEM;
 		}
 
 		dr->bRequestType = USB_TYPE_VENDOR;
 		dr->bRequest     = 0;
 		dr->wIndex       = 0;
 		dr->wValue       = 0;
 		dr->wLength      = __cpu_to_le16(skb->len);
 
 		pipe = usb_sndctrlpipe(data->udev, 0x00);
 
 		usb_fill_control_urb(urb, data->udev, pipe, (void *) dr,
 				skb->data, skb->len, bpa10x_tx_complete, skb);
 
 		hdev->stat.cmd_tx++;
 		break;
 
 	case HCI_ACLDATA_PKT:
 		pipe = usb_sndbulkpipe(data->udev, 0x02);
 
 		usb_fill_bulk_urb(urb, data->udev, pipe,
 				skb->data, skb->len, bpa10x_tx_complete, skb);
 
 		hdev->stat.acl_tx++;
 		break;
 
 	case HCI_SCODATA_PKT:
 		pipe = usb_sndbulkpipe(data->udev, 0x02);
 
 		usb_fill_bulk_urb(urb, data->udev, pipe,
 				skb->data, skb->len, bpa10x_tx_complete, skb);
 
 		hdev->stat.sco_tx++;
 		break;
 
 	default:
+		usb_free_urb(urb);
 		return -EILSEQ;
 	}
 
 	usb_anchor_urb(urb, &data->tx_anchor);
 
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err < 0) {
 		BT_ERR("%s urb %p submission failed", hdev->name, urb);
 		kfree(urb->setup_packet);
 		usb_unanchor_urb(urb);
 	}
 
 	usb_free_urb(urb);
 
 	return 0;
 }
 
 static void bpa10x_destruct(struct hci_dev *hdev)
 {
 	struct bpa10x_data *data = hdev->driver_data;
 
 	BT_DBG("%s", hdev->name);
 
 	kfree(data->rx_skb[0]);
 	kfree(data->rx_skb[1]);
 	kfree(data);
 }
 
 static int bpa10x_probe(struct usb_interface *intf, const struct usb_device_id *id)
 {
 	struct bpa10x_data *data;
 	struct hci_dev *hdev;
 	int err;
 
 	BT_DBG("intf %p id %p", intf, id);
 
 	if (ignore)
 		return -ENODEV;
 
 	if (intf->cur_altsetting->desc.bInterfaceNumber != 0)
 		return -ENODEV;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
 	data->udev = interface_to_usbdev(intf);
 

