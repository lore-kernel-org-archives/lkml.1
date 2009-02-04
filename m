Return-Path: <linux-kernel-owner+w=401wt.eu-S1760665AbZBDSpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760665AbZBDSpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:45:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755675AbZBDSha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:37:30 -0500
Received: from kroah.org ([198.145.64.141]:51138 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758550AbZBDShU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:37:20 -0500
Date: Wed, 4 Feb 2009 10:35:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
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
       alan@lxorguk.ukuu.org.uk, linville@tuxdriver.com,
       Larry.Finger@lwfinger.net, Christian Lamparter <chunkeey@web.de>
Subject: [patch 23/33] p54usb: rewriting rx/tx routines to make use of
	usb_anchors facilities
Message-ID: <20090204183501.GX13936@kroah.com>
References: <20090204182823.831027530@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="p54usb-rewriting-rx-tx-routines-to-make-use-of-usb_anchor-s-facilities.patch"
In-Reply-To: <20090204183403.GA13936@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christian Lamparter <chunkeey@web.de>

commit dd397dc9dddfa2149a1bbc9e52ac7d5630737cec upstream

Alan Stern found several flaws in p54usb's implementation and annotated:
"usb_kill_urb() and similar routines do not expect an URB's completion
routine to deallocate it.  This is almost obvious -- if the URB is deallocated
before the completion routine returns then there's no way for usb_kill_urb
to detect when the URB actually is complete."

This patch addresses all known limitations in the old implementation and fixes
khub's "use-after-freed" hang, when SLUB debug's poisoning option is enabled.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/p54/p54usb.c |  143 +++++++++++++++++++++++---------------
 drivers/net/wireless/p54/p54usb.h |    1 
 2 files changed, 89 insertions(+), 55 deletions(-)

--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -85,13 +85,13 @@ static void p54u_rx_cb(struct urb *urb)
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
@@ -104,7 +104,6 @@ static void p54u_rx_cb(struct urb *urb)
 	if (p54_rx(dev, skb)) {
 		skb = dev_alloc_skb(priv->common.rx_mtu + 32);
 		if (unlikely(!skb)) {
-			usb_free_urb(urb);
 			/* TODO check rx queue length and refill *somewhere* */
 			return;
 		}
@@ -114,7 +113,6 @@ static void p54u_rx_cb(struct urb *urb)
 		info->dev = dev;
 		urb->transfer_buffer = skb_tail_pointer(skb);
 		urb->context = skb;
-		skb_queue_tail(&priv->rx_queue, skb);
 	} else {
 		if (priv->hw_type == P54U_NET2280)
 			skb_push(skb, priv->common.tx_hdr_len);
@@ -129,22 +127,23 @@ static void p54u_rx_cb(struct urb *urb)
 			WARN_ON(1);
 			urb->transfer_buffer = skb_tail_pointer(skb);
 		}
-
-		skb_queue_tail(&priv->rx_queue, skb);
 	}
 
-	usb_submit_urb(urb, GFP_ATOMIC);
+	usb_anchor_urb(urb, &priv->submitted);
+	if (usb_submit_urb(urb, GFP_ATOMIC)) {
+		usb_unanchor_urb(urb);
+		dev_kfree_skb_irq(skb);
+	} else
+		skb_queue_tail(&priv->rx_queue, skb);
 }
 
-static void p54u_tx_cb(struct urb *urb)
-{
-	usb_free_urb(urb);
-}
+static void p54u_tx_cb(struct urb *urb) { }
 
-static void p54u_tx_free_cb(struct urb *urb)
+static void p54u_free_urbs(struct ieee80211_hw *dev)
 {
-	kfree(urb->transfer_buffer);
-	usb_free_urb(urb);
+	struct p54u_priv *priv = dev->priv;
+
+	usb_kill_anchored_urbs(&priv->submitted);
 }
 
 static int p54u_init_urbs(struct ieee80211_hw *dev)
@@ -153,15 +152,18 @@ static int p54u_init_urbs(struct ieee802
 	struct urb *entry;
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
 		usb_fill_bulk_urb(entry, priv->udev,
 				  usb_rcvbulkpipe(priv->udev, P54U_PIPE_DATA),
@@ -171,26 +173,25 @@ static int p54u_init_urbs(struct ieee802
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
+err:
+	usb_free_urb(entry);
+	kfree_skb(skb);
+	p54u_free_urbs(dev);
+	return ret;
 }
 
 static void p54u_tx_3887(struct ieee80211_hw *dev, struct p54_control_hdr *data,
@@ -210,16 +211,29 @@ static void p54u_tx_3887(struct ieee8021
 	}
 
 	usb_fill_bulk_urb(addr_urb, priv->udev,
-		usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA), &data->req_id,
-		sizeof(data->req_id), p54u_tx_cb, dev);
+			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA),
+			  &data->req_id, sizeof(data->req_id), p54u_tx_cb,
+			  dev);
 	usb_fill_bulk_urb(data_urb, priv->udev,
-		usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA), data, len,
-		free_on_tx ? p54u_tx_free_cb : p54u_tx_cb, dev);
+			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA),
+			  data, len, p54u_tx_cb, dev);
 	addr_urb->transfer_flags |= URB_ZERO_PACKET;
-	data_urb->transfer_flags |= URB_ZERO_PACKET;
+	data_urb->transfer_flags |= URB_ZERO_PACKET |
+				    (free_on_tx ? URB_FREE_BUFFER : 0);
 
-	usb_submit_urb(addr_urb, GFP_ATOMIC);
-	usb_submit_urb(data_urb, GFP_ATOMIC);
+	usb_anchor_urb(addr_urb, &priv->submitted);
+	if (usb_submit_urb(addr_urb, GFP_ATOMIC)) {
+		usb_unanchor_urb(addr_urb);
+		goto out;
+	}
+
+	usb_anchor_urb(data_urb, &priv->submitted);
+	if (usb_submit_urb(data_urb, GFP_ATOMIC))
+		usb_unanchor_urb(data_urb);
+
+out:
+	usb_free_urb(addr_urb);
+	usb_free_urb(data_urb);
 }
 
 static __le32 p54u_lm87_chksum(const __le32 *data, size_t length)
@@ -251,12 +265,16 @@ static void p54u_tx_lm87(struct ieee8021
 	hdr->device_addr = data->req_id;
 
 	usb_fill_bulk_urb(data_urb, priv->udev,
-		usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA), hdr,
-		len + sizeof(*hdr), free_on_tx ? p54u_tx_free_cb : p54u_tx_cb,
-		dev);
-	data_urb->transfer_flags |= URB_ZERO_PACKET;
+			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA), hdr,
+			  len + sizeof(*hdr), p54u_tx_cb, dev);
+	data_urb->transfer_flags |= URB_ZERO_PACKET |
+				    (free_on_tx ? URB_FREE_BUFFER : 0);
+
+	usb_anchor_urb(data_urb, &priv->submitted);
+	if (usb_submit_urb(data_urb, GFP_ATOMIC))
+		usb_unanchor_urb(data_urb);
 
-	usb_submit_urb(data_urb, GFP_ATOMIC);
+	usb_free_urb(data_urb);
 }
 
 static void p54u_tx_net2280(struct ieee80211_hw *dev, struct p54_control_hdr *data,
@@ -295,16 +313,30 @@ static void p54u_tx_net2280(struct ieee8
 	hdr->len = cpu_to_le16(len);
 
 	usb_fill_bulk_urb(int_urb, priv->udev,
-		usb_sndbulkpipe(priv->udev, P54U_PIPE_DEV), reg, sizeof(*reg),
-		p54u_tx_free_cb, dev);
-	int_urb->transfer_flags |= URB_ZERO_PACKET;
-	usb_submit_urb(int_urb, GFP_ATOMIC);
+			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DEV),
+			  reg, sizeof(*reg), p54u_tx_cb, dev);
+	int_urb->transfer_flags |= URB_ZERO_PACKET | URB_FREE_BUFFER;
+	usb_anchor_urb(int_urb, &priv->submitted);
+	if (usb_submit_urb(int_urb, GFP_ATOMIC)) {
+		usb_unanchor_urb(int_urb);
+		goto out;
+	}
 
 	usb_fill_bulk_urb(data_urb, priv->udev,
-		usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA), hdr, len + sizeof(*hdr),
-		free_on_tx ? p54u_tx_free_cb : p54u_tx_cb, dev);
-	data_urb->transfer_flags |= URB_ZERO_PACKET;
-	usb_submit_urb(data_urb, GFP_ATOMIC);
+			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA), hdr,
+			  len + sizeof(*hdr), p54u_tx_cb, dev);
+	data_urb->transfer_flags |= URB_ZERO_PACKET |
+				    (free_on_tx ? URB_FREE_BUFFER : 0);
+
+	usb_anchor_urb(int_urb, &priv->submitted);
+	if (usb_submit_urb(data_urb, GFP_ATOMIC)) {
+		usb_unanchor_urb(data_urb);
+		goto out;
+	}
+
+out:
+	usb_free_urb(int_urb);
+	usb_free_urb(data_urb);
 }
 
 static int p54u_write(struct p54u_priv *priv,
@@ -805,6 +837,7 @@ static int __devinit p54u_probe(struct u
 	SET_IEEE80211_DEV(dev, &intf->dev);
 	usb_set_intfdata(intf, dev);
 	priv->udev = udev;
+	init_usb_anchor(&priv->submitted);
 
 	usb_get_dev(udev);
 
--- a/drivers/net/wireless/p54/p54usb.h
+++ b/drivers/net/wireless/p54/p54usb.h
@@ -133,6 +133,7 @@ struct p54u_priv {
 
 	spinlock_t lock;
 	struct sk_buff_head rx_queue;
+	struct usb_anchor submitted;
 };
 
 #endif /* P54USB_H */

