Return-Path: <linux-kernel-owner+w=401wt.eu-S1762228AbYDPKmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762228AbYDPKmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 06:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757258AbYDPKmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 06:42:23 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:49015 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757163AbYDPKmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 06:42:22 -0400
Date: Wed, 16 Apr 2008 12:42:57 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>,
       marcel@holtmann.org, maxk@qualcomm.com, linux-bluetooth@vger.kernel.org
Subject: hci_usb: remove macro code obfuscation
Message-ID: <20080416104257.GA1621@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I had trouble figuring out what the code does. atomic_inc/dec
management is actually pretty simple, but it is needlessly obfuscated
with macros. Fix that.

Signed-off-by: Pavel Machek <pavel@suse.cz>

I had trouble figuring out what the code does. atomic_inc/dec
management is actually pretty simple, but it is needlessly obfuscated
with macros. Fix that.

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit 88c139ba08abddb52636e0ac25af0cabf8345e54
tree 30f9fd7c7051e63edaaa24a93ad9686492a0bc63
parent 43cfc0427c14f482e36adac447409c82b5cbbe09
author Pavel <pavel@amd.ucw.cz> Wed, 16 Apr 2008 12:42:32 +0200
committer Pavel <pavel@amd.ucw.cz> Wed, 16 Apr 2008 12:42:32 +0200

 drivers/bluetooth/hci_usb.c |   41 ++++++++++++++++++-----------------------
 1 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/drivers/bluetooth/hci_usb.c b/drivers/bluetooth/hci_usb.c
index 2597f63..6e0efc7 100644
--- a/drivers/bluetooth/hci_usb.c
+++ b/drivers/bluetooth/hci_usb.c
@@ -201,14 +201,9 @@ static struct _urb *_urb_dequeue(struct 
 static void hci_usb_rx_complete(struct urb *urb);
 static void hci_usb_tx_complete(struct urb *urb);
 
-#define __pending_tx(husb, type)  (&husb->pending_tx[type-1])
-#define __pending_q(husb, type)   (&husb->pending_q[type-1])
-#define __completed_q(husb, type) (&husb->completed_q[type-1])
-#define __transmit_q(husb, type)  (&husb->transmit_q[type-1])
-
 static inline struct _urb *__get_completed(struct hci_usb *husb, int type)
 {
-	return _urb_dequeue(__completed_q(husb, type)); 
+	return _urb_dequeue(&husb->completed_q[type-1]); 
 }
 
 #ifdef CONFIG_BT_HCIUSB_SCO
@@ -254,7 +249,7 @@ static int hci_usb_intr_rx_submit(struct
 		return -ENOMEM;
 	}
 	_urb->type = HCI_EVENT_PKT;
-	_urb_queue_tail(__pending_q(husb, _urb->type), _urb);
+	_urb_queue_tail(&husb->pending_q[_urb->type-1], _urb);
 
 	urb = &_urb->urb;
 	pipe     = usb_rcvintpipe(husb->udev, husb->intr_in_ep->desc.bEndpointAddress);
@@ -289,7 +284,7 @@ static int hci_usb_bulk_rx_submit(struct
 		return -ENOMEM;
 	}
 	_urb->type = HCI_ACLDATA_PKT;
-	_urb_queue_tail(__pending_q(husb, _urb->type), _urb);
+	_urb_queue_tail(&husb->pending_q[_urb->type-1], _urb);
 
 	urb  = &_urb->urb;
 	pipe = usb_rcvbulkpipe(husb->udev, husb->bulk_in_ep->desc.bEndpointAddress);
@@ -330,7 +325,7 @@ static int hci_usb_isoc_rx_submit(struct
 		return -ENOMEM;
 	}
 	_urb->type = HCI_SCODATA_PKT;
-	_urb_queue_tail(__pending_q(husb, _urb->type), _urb);
+	_urb_queue_tail(&husb->pending_q[_urb->type-1], _urb);
 
 	urb = &_urb->urb;
 
@@ -423,7 +418,7 @@ static void hci_usb_unlink_urbs(struct h
 			BT_DBG("%s unlinking _urb %p type %d urb %p", 
 					husb->hdev->name, _urb, _urb->type, urb);
 			usb_kill_urb(urb);
-			_urb_queue_tail(__completed_q(husb, _urb->type), _urb);
+			_urb_queue_tail(&husb->completed_q[_urb->type-1], _urb);
 		}
 
 		/* Release completed requests */
@@ -474,15 +469,15 @@ static int __tx_submit(struct hci_usb *h
 
 	BT_DBG("%s urb %p type %d", husb->hdev->name, urb, _urb->type);
 
-	_urb_queue_tail(__pending_q(husb, _urb->type), _urb);
+	_urb_queue_tail(&husb->pending_q[_urb->type-1], _urb);
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err) {
 		BT_ERR("%s tx submit failed urb %p type %d err %d",
 				husb->hdev->name, urb, _urb->type, err);
 		_urb_unlink(_urb);
-		_urb_queue_tail(__completed_q(husb, _urb->type), _urb);
+		_urb_queue_tail(&husb->completed_q[_urb->type-1], _urb);
 	} else
-		atomic_inc(__pending_tx(husb, _urb->type));
+		atomic_inc(&husb->pending_tx[_urb->type-1]);
 
 	return err;
 }
@@ -594,8 +589,8 @@ static void hci_usb_tx_process(struct hc
 		clear_bit(HCI_USB_TX_WAKEUP, &husb->state);
 
 		/* Process command queue */
-		q = __transmit_q(husb, HCI_COMMAND_PKT);
-		if (!atomic_read(__pending_tx(husb, HCI_COMMAND_PKT)) &&
+		q = &husb->transmit_q[HCI_COMMAND_PKT-1];
+		if (!atomic_read(&husb->pending_tx[HCI_COMMAND_PKT-1]) &&
 				(skb = skb_dequeue(q))) {
 			if (hci_usb_send_ctrl(husb, skb) < 0)
 				skb_queue_head(q, skb);
@@ -603,8 +598,8 @@ static void hci_usb_tx_process(struct hc
 
 #ifdef CONFIG_BT_HCIUSB_SCO
 		/* Process SCO queue */
-		q = __transmit_q(husb, HCI_SCODATA_PKT);
-		if (atomic_read(__pending_tx(husb, HCI_SCODATA_PKT)) < HCI_MAX_ISOC_TX &&
+		q = &husb->transmit_q[HCI_SCODATA_PKT-1];
+		if (atomic_read(&husb->pending_tx[HCI_SCODATA_PKT-1]) < HCI_MAX_ISOC_TX &&
 				(skb = skb_dequeue(q))) {
 			if (hci_usb_send_isoc(husb, skb) < 0)
 				skb_queue_head(q, skb);
@@ -612,8 +607,8 @@ #ifdef CONFIG_BT_HCIUSB_SCO
 #endif
 
 		/* Process ACL queue */
-		q = __transmit_q(husb, HCI_ACLDATA_PKT);
-		while (atomic_read(__pending_tx(husb, HCI_ACLDATA_PKT)) < HCI_MAX_BULK_TX &&
+		q = &husb->transmit_q[HCI_ACLDATA_PKT-1];
+		while (atomic_read(&husb->pending_tx[HCI_ACLDATA_PKT-1]) < HCI_MAX_BULK_TX &&
 				(skb = skb_dequeue(q))) {
 			if (hci_usb_send_bulk(husb, skb) < 0) {
 				skb_queue_head(q, skb);
@@ -675,7 +670,7 @@ #endif
 
 	read_lock(&husb->completion_lock);
 
-	skb_queue_tail(__transmit_q(husb, bt_cb(skb)->pkt_type), skb);
+	skb_queue_tail(&husb->transmit_q[bt_cb(skb)->pkt_type-1], skb);
 	hci_usb_tx_wakeup(husb);
 
 	read_unlock(&husb->completion_lock);
@@ -752,7 +747,7 @@ static void hci_usb_tx_complete(struct u
 		return;
 
 	/* _urb may have been already cleared by hci_usb_unlink_urbs */
-	atomic_dec(__pending_tx(husb, _urb->type));
+	atomic_dec(&husb->pending_tx[_urb->type-1]);
 
 	urb->transfer_buffer = NULL;
 	kfree_skb((struct sk_buff *) _urb->priv);
@@ -765,7 +760,7 @@ static void hci_usb_tx_complete(struct u
 	read_lock(&husb->completion_lock);
 
 	_urb_unlink(_urb);
-	_urb_queue_tail(__completed_q(husb, _urb->type), _urb);
+	_urb_queue_tail(&husb->completed_q[_urb->type-1], _urb);
 
 	hci_usb_tx_wakeup(husb);
 


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
