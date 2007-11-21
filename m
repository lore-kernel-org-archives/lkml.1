Return-Path: <linux-kernel-owner+w=401wt.eu-S1761813AbXKULP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761813AbXKULP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 06:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757390AbXKULPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 06:15:05 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:36446 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761649AbXKULPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 06:15:03 -0500
Date: Wed, 21 Nov 2007 12:14:57 +0100 (MET)
From: Julia Lawall <julia@diku.dk>
To: marcel@holtmann.org, maxk@qualcomm.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/bluetooth: Convert kfree/kfree_skb to dev_kfree_skb_irq
Message-ID: <Pine.LNX.4.58.0711211213350.1184@pc-041.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

When values of type struct sk_buff * are freed from within an interrupt
handler, dev_kfree_skb_irq should be used rather than kfree or kfree_skb.

In most of the cases below, the function containing the free ends up as a
URB completion callback.  Such callbacks are called from an interrupt
handler.  In drivers/bluetooth/btsdio.c, the enclosing function is
ultimately referenced from the second argument of sdio_claim_irq, which is
also used as an interrupt handler.

All of these cases except the last were fixed using the following semantic
patch (http://www.emn.fr/x-info/coccinelle/).

// <smpl>
@rule1@
identifier f;
@@

f(...) {
<+...
   kfree_skb(...)
...+>
}

@ call @
identifier rule1.f;
@@

(
usb_fill_bulk_urb(...,f,...)
|
usb_fill_control_urb(...,f,...)
|
usb_fill_int_urb(...,f,...)
)

@ toplevel @
identifier rule1.f;
struct urb u;
@@

u.complete = f;

@ depends on call || toplevel @
identifier rule1.f;
expression E;
@@

f(...) {
<...
-  kfree_skb(E)
+  dev_kfree_skb_irq(E)
...>
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p a/drivers/bluetooth/bfusb.c b/drivers/bluetooth/bfusb.c
--- a/drivers/bluetooth/bfusb.c 2007-06-02 22:32:10.000000000 +0200
+++ b/drivers/bluetooth/bfusb.c 2007-11-21 09:28:22.000000000 +0100
@@ -396,7 +396,7 @@ static void bfusb_rx_complete(struct urb
 	}

 	skb_unlink(skb, &data->pending_q);
-	kfree_skb(skb);
+	dev_kfree_skb_irq(skb);

 	bfusb_rx_submit(data, urb);

diff -u -p a/drivers/bluetooth/bpa10x.c b/drivers/bluetooth/bpa10x.c
--- a/drivers/bluetooth/bpa10x.c 2007-11-01 10:30:39.000000000 +0100
+++ b/drivers/bluetooth/bpa10x.c 2007-11-21 09:28:23.000000000 +0100
@@ -190,7 +190,7 @@ static void bpa10x_tx_complete(struct ur
 done:
 	kfree(urb->setup_packet);

-	kfree_skb(skb);
+	dev_kfree_skb_irq(skb);
 }

 static void bpa10x_rx_complete(struct urb *urb)
diff -u -p a/drivers/bluetooth/hci_usb.c b/drivers/bluetooth/hci_usb.c
--- a/drivers/bluetooth/hci_usb.c 2007-10-22 11:25:05.000000000 +0200
+++ b/drivers/bluetooth/hci_usb.c 2007-11-21 09:28:26.000000000 +0100
@@ -733,7 +733,7 @@ static void hci_usb_tx_complete(struct u
 	atomic_dec(__pending_tx(husb, _urb->type));

 	urb->transfer_buffer = NULL;
-	kfree_skb((struct sk_buff *) _urb->priv);
+	dev_kfree_skb_irq((struct sk_buff*) _urb->priv);

 	if (!test_bit(HCI_RUNNING, &hdev->flags))
 		return;
diff -u -p a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
--- a/drivers/bluetooth/btusb.c 2007-11-01 10:30:39.000000000 +0100
+++ b/drivers/bluetooth/btusb.c 2007-11-21 09:28:26.000000000 +0100
@@ -254,7 +254,7 @@ static void btusb_tx_complete(struct urb
 done:
 	kfree(urb->setup_packet);

-	kfree_skb(skb);
+	dev_kfree_skb_irq(skb);
 }

 static int btusb_open(struct hci_dev *hdev)
diff -u -p a/drivers/bluetooth/btsdio.c b/drivers/bluetooth/btsdio.c
--- a/drivers/bluetooth/btsdio.c	2007-11-01 10:30:39.000000000 +0100
+++ b/drivers/bluetooth/btsdio.c	2007-11-21 11:25:48.000000000 +0100
@@ -152,7 +152,7 @@ static int btsdio_rx_packet(struct btsdi

 	err = sdio_readsb(data->func, skb->data, REG_RDAT, len - 4);
 	if (err < 0) {
-		kfree(skb);
+		dev_kfree_skb_irq(skb);
 		return err;
 	}

@@ -163,7 +163,7 @@ static int btsdio_rx_packet(struct btsdi

 	err = hci_recv_frame(skb);
 	if (err < 0) {
-		kfree(skb);
+		dev_kfree_skb_irq(skb);
 		return err;
 	}

