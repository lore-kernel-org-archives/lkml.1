Return-Path: <linux-kernel-owner+w=401wt.eu-S1753190AbYLHOH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbYLHOH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 09:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbYLHOHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 09:07:14 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:43156 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbYLHOHL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 09:07:11 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: [RFC][PATCH v2] p54usb: rewriting rx/tx routines to make use of usb_anchor's facilities
Date: Mon, 8 Dec 2008 15:06:54 +0100
User-Agent: KMail/1.9.9
Cc: Larry Finger <Larry.Finger@lwfinger.net>, Greg KH <gregkh@suse.de>,
       linux-wireless@vger.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>,
       John W Linville <linville@tuxdriver.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0812061919480.16554-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0812061919480.16554-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200812081506.54173.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX1/TkGNi9p84TPYGz0qCu7C+FoMHnN2mjr1IFL2g
	HBy3HgGul66yMTjkC2uZTURdCkg668ZTnGcxtG8IAC9rddB645
	S3wkQwOpA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern found several flaws in p54usb's implementation and annotated: 
"usb_kill_urb() and similar routines do not expect an URB's completion
routine to deallocate it.  This is almost obvious -- if the URB is deallocated
before the completion routine returns then there's no way for usb_kill_urb
to detect when the URB actually is complete."

I really hope this patch addresses all of Alan's comments and fixes the 
"use-after-freed" hang, when SLUB debug's poisoning option is enabled.
---
> I looked quickly at your new code.  It seems basically right, but there
> are few things that still need attention.  For instance, you removed a
> line to free an URB's transfer buffer.

yeah, it was there in the last patch, but probably in the wrong place.
Anyway, there's now a small comment so it's easier to spot it.

So here's the new "final" version, unless someone files a complain within 24 hours. 
---
diff -Nurp a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
--- a/drivers/net/wireless/p54/p54usb.c	2008-12-07 21:21:04.017774898 +0100
+++ b/drivers/net/wireless/p54/p54usb.c	2008-12-08 14:17:51.863521490 +0100
@@ -86,13 +86,13 @@ static void p54u_rx_cb(struct urb *urb)
 	struct ieee80211_hw *dev = info->dev;
 	struct p54u_priv *priv = dev->priv;
 
+	skb_unlink(skb, &priv->rx_queue);
+
 	if (unlikely(urb->status)) {
-		info->urb = NULL;
-		usb_free_urb(urb);
+		dev_kfree_skb_irq(skb);
 		return;
 	}
 
-	skb_unlink(skb, &priv->rx_queue);
 	skb_put(skb, urb->actual_length);
 
 	if (priv->hw_type == P54U_NET2280)
@@ -105,7 +105,6 @@ static void p54u_rx_cb(struct urb *urb)
 	if (p54_rx(dev, skb)) {
 		skb = dev_alloc_skb(priv->common.rx_mtu + 32);
 		if (unlikely(!skb)) {
-			usb_free_urb(urb);
 			/* TODO check rx queue length and refill *somewhere* */
 			return;
 		}
@@ -115,7 +114,6 @@ static void p54u_rx_cb(struct urb *urb)
 		info->dev = dev;
 		urb->transfer_buffer = skb_tail_pointer(skb);
 		urb->context = skb;
-		skb_queue_tail(&priv->rx_queue, skb);
 	} else {
 		if (priv->hw_type == P54U_NET2280)
 			skb_push(skb, priv->common.tx_hdr_len);
@@ -130,11 +128,14 @@ static void p54u_rx_cb(struct urb *urb)
 			WARN_ON(1);
 			urb->transfer_buffer = skb_tail_pointer(skb);
 		}
-
-		skb_queue_tail(&priv->rx_queue, skb);
 	}
-
-	usb_submit_urb(urb, GFP_ATOMIC);
+	skb_queue_tail(&priv->rx_queue, skb);
+	usb_anchor_urb(urb, &priv->submitted);
+	if (usb_submit_urb(urb, GFP_ATOMIC)) {
+		skb_unlink(skb, &priv->rx_queue);
+		usb_unanchor_urb(urb);
+		dev_kfree_skb_irq(skb);
+	}
 }
 
 static void p54u_tx_reuse_skb_cb(struct urb *urb)
@@ -144,18 +145,6 @@ static void p54u_tx_reuse_skb_cb(struct 
 		usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0)))->priv;
 
 	skb_pull(skb, priv->common.tx_hdr_len);
-	usb_free_urb(urb);
-}
-
-static void p54u_tx_cb(struct urb *urb)
-{
-	usb_free_urb(urb);
-}
-
-static void p54u_tx_free_cb(struct urb *urb)
-{
-	kfree(urb->transfer_buffer);
-	usb_free_urb(urb);
 }
 
 static void p54u_tx_free_skb_cb(struct urb *urb)
@@ -165,25 +154,36 @@ static void p54u_tx_free_skb_cb(struct u
 		usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0));
 
 	p54_free_skb(dev, skb);
-	usb_free_urb(urb);
+}
+
+static void p54u_tx_dummy_cb(struct urb *urb) { }
+
+static void p54u_free_urbs(struct ieee80211_hw *dev)
+{
+	struct p54u_priv *priv = dev->priv;
+	usb_kill_anchored_urbs(&priv->submitted);
 }
 
 static int p54u_init_urbs(struct ieee80211_hw *dev)
 {
 	struct p54u_priv *priv = dev->priv;
-	struct urb *entry;
+	struct urb *entry = NULL;
 	struct sk_buff *skb;
 	struct p54u_rx_info *info;
+	int ret = 0;
 
 	while (skb_queue_len(&priv->rx_queue) < 32) {
 		skb = __dev_alloc_skb(priv->common.rx_mtu + 32, GFP_KERNEL);
-		if (!skb)
-			break;
+		if (!skb) {
+			ret = -ENOMEM;
+			goto err;
+		}
 		entry = usb_alloc_urb(0, GFP_KERNEL);
 		if (!entry) {
-			kfree_skb(skb);
-			break;
+			ret = -ENOMEM;
+			goto err;
 		}
+
 		usb_fill_bulk_urb(entry, priv->udev,
 				  usb_rcvbulkpipe(priv->udev, P54U_PIPE_DATA),
 				  skb_tail_pointer(skb),
@@ -192,26 +192,25 @@ static int p54u_init_urbs(struct ieee802
 		info->urb = entry;
 		info->dev = dev;
 		skb_queue_tail(&priv->rx_queue, skb);
-		usb_submit_urb(entry, GFP_KERNEL);
+
+		usb_anchor_urb(entry, &priv->submitted);
+		ret = usb_submit_urb(entry, GFP_KERNEL);
+		if (ret) {
+			skb_unlink(skb, &priv->rx_queue);
+			usb_unanchor_urb(entry);
+			goto err;
+		}
+		usb_free_urb(entry);
+		entry = NULL;
 	}
 
 	return 0;
-}
 
-static void p54u_free_urbs(struct ieee80211_hw *dev)
-{
-	struct p54u_priv *priv = dev->priv;
-	struct p54u_rx_info *info;
-	struct sk_buff *skb;
-
-	while ((skb = skb_dequeue(&priv->rx_queue))) {
-		info = (struct p54u_rx_info *) skb->cb;
-		if (!info->urb)
-			continue;
-
-		usb_kill_urb(info->urb);
-		kfree_skb(skb);
-	}
+ err:
+	usb_free_urb(entry);
+	kfree_skb(skb);
+	p54u_free_urbs(dev);
+	return ret;
 }
 
 static void p54u_tx_3887(struct ieee80211_hw *dev, struct sk_buff *skb,
@@ -219,6 +218,7 @@ static void p54u_tx_3887(struct ieee8021
 {
 	struct p54u_priv *priv = dev->priv;
 	struct urb *addr_urb, *data_urb;
+	int err = 0;
 
 	addr_urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!addr_urb)
@@ -233,15 +233,31 @@ static void p54u_tx_3887(struct ieee8021
 	usb_fill_bulk_urb(addr_urb, priv->udev,
 			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA),
 			  &((struct p54_hdr *)skb->data)->req_id, 4,
-			  p54u_tx_cb, dev);
+			  p54u_tx_dummy_cb, dev);
 	usb_fill_bulk_urb(data_urb, priv->udev,
 			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA),
 			  skb->data, skb->len,
 			  free_on_tx ? p54u_tx_free_skb_cb :
 				       p54u_tx_reuse_skb_cb, skb);
 
-	usb_submit_urb(addr_urb, GFP_ATOMIC);
-	usb_submit_urb(data_urb, GFP_ATOMIC);
+	usb_anchor_urb(addr_urb, &priv->submitted);
+	err = usb_submit_urb(addr_urb, GFP_ATOMIC);
+	if (err) {
+		usb_unanchor_urb(addr_urb);
+		goto out;
+	}
+
+	usb_anchor_urb(addr_urb, &priv->submitted);
+	err = usb_submit_urb(data_urb, GFP_ATOMIC);
+	if (err)
+		usb_unanchor_urb(data_urb);
+
+ out:
+	usb_free_urb(addr_urb);
+	usb_free_urb(data_urb);
+
+	if (err)
+		p54_free_skb(dev, skb);
 }
 
 static __le32 p54u_lm87_chksum(const __le32 *data, size_t length)
@@ -281,7 +297,13 @@ static void p54u_tx_lm87(struct ieee8021
 			  free_on_tx ? p54u_tx_free_skb_cb :
 				       p54u_tx_reuse_skb_cb, skb);
 
-	usb_submit_urb(data_urb, GFP_ATOMIC);
+	usb_anchor_urb(data_urb, &priv->submitted);
+	if (usb_submit_urb(data_urb, GFP_ATOMIC)) {
+		usb_unanchor_urb(data_urb);
+		skb_pull(skb, sizeof(*hdr));
+		p54_free_skb(dev, skb);
+	}
+	usb_free_urb(data_urb);
 }
 
 static void p54u_tx_net2280(struct ieee80211_hw *dev, struct sk_buff *skb,
@@ -291,6 +313,7 @@ static void p54u_tx_net2280(struct ieee8
 	struct urb *int_urb, *data_urb;
 	struct net2280_tx_hdr *hdr;
 	struct net2280_reg_write *reg;
+	int err = 0;
 
 	reg = kmalloc(sizeof(*reg), GFP_ATOMIC);
 	if (!reg)
@@ -320,15 +343,42 @@ static void p54u_tx_net2280(struct ieee8
 
 	usb_fill_bulk_urb(int_urb, priv->udev,
 		usb_sndbulkpipe(priv->udev, P54U_PIPE_DEV), reg, sizeof(*reg),
-		p54u_tx_free_cb, dev);
-	usb_submit_urb(int_urb, GFP_ATOMIC);
+		p54u_tx_dummy_cb, dev);
+
+	/*
+	 * This flag triggers a code path in the USB subsystem that will
+	 * free what's inside the transfer_buffer after the callback routine
+	 * has completed.
+	 */
+	int_urb->transfer_flags |= URB_FREE_BUFFER;
 
 	usb_fill_bulk_urb(data_urb, priv->udev,
 			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA),
 			  skb->data, skb->len,
 			  free_on_tx ? p54u_tx_free_skb_cb :
 				       p54u_tx_reuse_skb_cb, skb);
-	usb_submit_urb(data_urb, GFP_ATOMIC);
+
+	usb_anchor_urb(int_urb, &priv->submitted);
+	err = usb_submit_urb(int_urb, GFP_ATOMIC);
+	if (err) {
+		usb_unanchor_urb(int_urb);
+		goto out;
+	}
+
+	usb_anchor_urb(data_urb, &priv->submitted);
+	err = usb_submit_urb(data_urb, GFP_ATOMIC);
+	if (err) {
+		usb_unanchor_urb(data_urb);
+		goto out;
+	}
+ out:
+	usb_free_urb(int_urb);
+	usb_free_urb(data_urb);
+
+	if (err) {
+		skb_pull(skb, sizeof(*hdr));
+		p54_free_skb(dev, skb);
+	}
 }
 
 static int p54u_write(struct p54u_priv *priv,
@@ -886,6 +936,7 @@ static int __devinit p54u_probe(struct u
 		goto err_free_dev;
 
 	skb_queue_head_init(&priv->rx_queue);
+	init_usb_anchor(&priv->submitted);
 
 	p54u_open(dev);
 	err = p54_read_eeprom(dev);
diff -Nurp a/drivers/net/wireless/p54/p54usb.h b/drivers/net/wireless/p54/p54usb.h
--- a/drivers/net/wireless/p54/p54usb.h	2008-12-07 21:21:04.017774898 +0100
+++ b/drivers/net/wireless/p54/p54usb.h	2008-12-07 22:04:45.956897502 +0100
@@ -133,6 +133,7 @@ struct p54u_priv {
 
 	spinlock_t lock;
 	struct sk_buff_head rx_queue;
+	struct usb_anchor submitted;
 };
 
 #endif /* P54USB_H */
