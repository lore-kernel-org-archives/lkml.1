Return-Path: <linux-kernel-owner+w=401wt.eu-S1753050AbYLFUJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbYLFUJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 15:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbYLFUJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 15:09:45 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:55640 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbYLFUJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 15:09:44 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Greg KH <gregkh@suse.de>
Subject: [RFC][PATCH] p54usb: rewriting rx/tx routines to make use of usb_anchor's facilities
Date: Sat, 6 Dec 2008 21:09:39 +0100
User-Agent: KMail/1.10.0 (Linux/2.6.28-rc7-wl; KDE/4.1.0; x86_64; ; )
Cc: Larry Finger <Larry.Finger@lwfinger.net>, linux-wireless@vger.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>,
       John W Linville <linville@tuxdriver.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
References: <200812051547.45790.chunkeey@web.de> <4939B6AF.2060901@lwfinger.net> <20081205232321.GA8557@suse.de>
In-Reply-To: <20081205232321.GA8557@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812062109.40590.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX18SOyQWXaCENVyegqRFt2H64Vut17JPaDMai5rs
	9T5o3OQMVx+ub6NfEoAYrsY8mNK6X6UDv+5ZclfeB6+JuviWO3
	LgQVNHPOc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern found several flaws in p54usb's implementation and annotated: 
"usb_kill_urb() and similar routines do not expect an URB's completion
routine to deallocate it.  This is almost obvious -- if the URB is deallocated
before the completion routine returns then there's no way for usb_kill_urb
to detect when the URB actually is complete."

I really hope this patch addresses all of Alan's comments and fixes the 
"use-after-freed" hang, when SLUB debug's poisoning option is enabled.
---
patch is from wireless-testing. 
As far as I can see the usb_anchor code works now rather well
and the skb leak should be gone as well.

Alan, I've got a question about:
"Create and initialize a usb_anchor structure, and each time you create
a new URB, call usb_anchor_urb().  Then you can free the URB as soon as
it is submitted; the anchor will keep it pinned until it completes, and
it is automatically removed from the anchor when the completion routine
is called."

Do we have to call usb_free_urb again, if we're resubmitting the urb in the
complete callback? (the code what I'm referring to is p54u_rx_cb in p54usb.c)

Regards,
	Chr
---
diff -Nurp a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
--- a/drivers/net/wireless/p54/p54usb.c	2008-12-06 20:06:23.000000000 +0100
+++ b/drivers/net/wireless/p54/p54usb.c	2008-12-06 20:32:58.000000000 +0100
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
@@ -134,7 +133,11 @@ static void p54u_rx_cb(struct urb *urb)
 		skb_queue_tail(&priv->rx_queue, skb);
 	}
 
-	usb_submit_urb(urb, GFP_ATOMIC);
+	if (usb_submit_urb(urb, GFP_ATOMIC)) {
+		skb_unlink(skb, &priv->rx_queue);
+		usb_unanchor_urb(urb);
+		dev_kfree_skb_irq(skb);
+	}
 }
 
 static void p54u_tx_reuse_skb_cb(struct urb *urb)
@@ -144,18 +147,6 @@ static void p54u_tx_reuse_skb_cb(struct 
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
@@ -165,25 +156,36 @@ static void p54u_tx_free_skb_cb(struct u
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
@@ -192,26 +194,25 @@ static int p54u_init_urbs(struct ieee802
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
-
-static void p54u_free_urbs(struct ieee80211_hw *dev)
-{
-	struct p54u_priv *priv = dev->priv;
-	struct p54u_rx_info *info;
-	struct sk_buff *skb;
 
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
@@ -219,6 +220,7 @@ static void p54u_tx_3887(struct ieee8021
 {
 	struct p54u_priv *priv = dev->priv;
 	struct urb *addr_urb, *data_urb;
+	int err = 0;
 
 	addr_urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!addr_urb)
@@ -233,15 +235,31 @@ static void p54u_tx_3887(struct ieee8021
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
@@ -281,7 +299,13 @@ static void p54u_tx_lm87(struct ieee8021
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
@@ -291,6 +315,7 @@ static void p54u_tx_net2280(struct ieee8
 	struct urb *int_urb, *data_urb;
 	struct net2280_tx_hdr *hdr;
 	struct net2280_reg_write *reg;
+	int err = 0;
 
 	reg = kmalloc(sizeof(*reg), GFP_ATOMIC);
 	if (!reg)
@@ -318,17 +343,38 @@ static void p54u_tx_net2280(struct ieee8
 	hdr->device_addr = ((struct p54_hdr *)skb->data)->req_id;
 	hdr->len = cpu_to_le16(skb->len + sizeof(struct p54_hdr));
 
+	int_urb->transfer_flags |= URB_FREE_BUFFER;
 	usb_fill_bulk_urb(int_urb, priv->udev,
 		usb_sndbulkpipe(priv->udev, P54U_PIPE_DEV), reg, sizeof(*reg),
-		p54u_tx_free_cb, dev);
-	usb_submit_urb(int_urb, GFP_ATOMIC);
+		p54u_tx_dummy_cb, dev);
 
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
@@ -886,6 +932,7 @@ static int __devinit p54u_probe(struct u
 		goto err_free_dev;
 
 	skb_queue_head_init(&priv->rx_queue);
+	init_usb_anchor(&priv->submitted);
 
 	p54u_open(dev);
 	err = p54_read_eeprom(dev);
diff -Nurp a/drivers/net/wireless/p54/p54usb.h b/drivers/net/wireless/p54/p54usb.h
--- a/drivers/net/wireless/p54/p54usb.h	2008-12-06 20:06:23.000000000 +0100
+++ b/drivers/net/wireless/p54/p54usb.h	2008-12-06 20:16:19.000000000 +0100
@@ -133,6 +133,7 @@ struct p54u_priv {
 
 	spinlock_t lock;
 	struct sk_buff_head rx_queue;
+	struct usb_anchor submitted;
 };
 
 #endif /* P54USB_H */
