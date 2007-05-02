Return-Path: <linux-kernel-owner+w=401wt.eu-S2992970AbXEBJte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992970AbXEBJte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 05:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992980AbXEBJte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 05:49:34 -0400
Received: from twin.jikos.cz ([213.151.79.26]:52705 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992970AbXEBJtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 05:49:33 -0400
Date: Wed, 2 May 2007 11:49:02 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Marcel Holtmann <marcel@holtmann.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net
Subject: [PATCH] Bluetooth: postpone hci_dev unregistration
Message-ID: <Pine.LNX.4.64.0705021144291.21227@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(I sent this a week ago but it seems to have got lost in other noise, 
resending)

From: Jiri Kosina <jkosina@suse.cz>

Bluetooth: postpone hci_dev unregistration
    
Commit b40df57 substituted bh_lock_sock() in hci_sock_dev_event() for 
lock_sock() when unregistering HCI device, in order to prevent deadlock 
against locking in l2cap_connect_cfm() from softirq context.
    
This however introduces another problem - hci_sock_dev_event() for 
HCI_DEV_UNREG can also be triggered in atomic context, in which calling 
lock_sock() is not safe as it could sleep. Reported by Jeremy Fitzhardinge 
at http://lkml.org/lkml/2007/4/23/271

This patch moves the detaching of sockets from hci_device into workqueue, 
so that lock_sock() can be used safely. This requires movement of 
deallocation of hci_dev - deallocating device just after 
hci_unregister_dev() would be too soon, as it could happen before the 
workqueue has been run.
    
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

---
 drivers/bluetooth/bfusb.c        |    2 -
 drivers/bluetooth/bluecard_cs.c  |    2 -
 drivers/bluetooth/bpa10x.c       |    2 -
 drivers/bluetooth/bt3c_cs.c      |    2 -
 drivers/bluetooth/btuart_cs.c    |    2 -
 drivers/bluetooth/dtl1_cs.c      |    2 -
 drivers/bluetooth/hci_ldisc.c    |    1 -
 drivers/bluetooth/hci_usb.c      |    2 -
 drivers/bluetooth/hci_vhci.c     |    2 -
 include/net/bluetooth/hci_core.h |    3 ++
 net/bluetooth/hci_core.c         |    9 +++++++
 net/bluetooth/hci_sock.c         |   44 ++++++++++++++++++++-----------------
 12 files changed, 36 insertions(+), 37 deletions(-)

diff --git a/drivers/bluetooth/bfusb.c b/drivers/bluetooth/bfusb.c
index 4c766f3..db6809e 100644
--- a/drivers/bluetooth/bfusb.c
+++ b/drivers/bluetooth/bfusb.c
@@ -762,8 +762,6 @@ static void bfusb_disconnect(struct usb_
 
 	if (hci_unregister_dev(hdev) < 0)
 		BT_ERR("Can't unregister HCI device %s", hdev->name);
-
-	hci_free_dev(hdev);
 }
 
 static struct usb_driver bfusb_driver = {
diff --git a/drivers/bluetooth/bluecard_cs.c b/drivers/bluetooth/bluecard_cs.c
index acfb6a4..1184113 100644
--- a/drivers/bluetooth/bluecard_cs.c
+++ b/drivers/bluetooth/bluecard_cs.c
@@ -851,8 +851,6 @@ static int bluecard_close(bluecard_info_
 	if (hci_unregister_dev(hdev) < 0)
 		BT_ERR("Can't unregister HCI device %s", hdev->name);
 
-	hci_free_dev(hdev);
-
 	return 0;
 }
 
diff --git a/drivers/bluetooth/bpa10x.c b/drivers/bluetooth/bpa10x.c
index 9fca651..7dfaa95 100644
--- a/drivers/bluetooth/bpa10x.c
+++ b/drivers/bluetooth/bpa10x.c
@@ -613,8 +613,6 @@ static void bpa10x_disconnect(struct usb
 
 	if (hci_unregister_dev(hdev) < 0)
 		BT_ERR("Can't unregister HCI device %s", hdev->name);
-
-	hci_free_dev(hdev);
 }
 
 static struct usb_driver bpa10x_driver = {
diff --git a/drivers/bluetooth/bt3c_cs.c b/drivers/bluetooth/bt3c_cs.c
index 18b0f39..6ab7b56 100644
--- a/drivers/bluetooth/bt3c_cs.c
+++ b/drivers/bluetooth/bt3c_cs.c
@@ -640,8 +640,6 @@ static int bt3c_close(bt3c_info_t *info)
 	if (hci_unregister_dev(hdev) < 0)
 		BT_ERR("Can't unregister HCI device %s", hdev->name);
 
-	hci_free_dev(hdev);
-
 	return 0;
 }
 
diff --git a/drivers/bluetooth/btuart_cs.c b/drivers/bluetooth/btuart_cs.c
index c1bce75..93ca675 100644
--- a/drivers/bluetooth/btuart_cs.c
+++ b/drivers/bluetooth/btuart_cs.c
@@ -570,8 +570,6 @@ static int btuart_close(btuart_info_t *i
 	if (hci_unregister_dev(hdev) < 0)
 		BT_ERR("Can't unregister HCI device %s", hdev->name);
 
-	hci_free_dev(hdev);
-
 	return 0;
 }
 
diff --git a/drivers/bluetooth/dtl1_cs.c b/drivers/bluetooth/dtl1_cs.c
index 459aa97..4fc7c02 100644
--- a/drivers/bluetooth/dtl1_cs.c
+++ b/drivers/bluetooth/dtl1_cs.c
@@ -552,8 +552,6 @@ static int dtl1_close(dtl1_info_t *info)
 	if (hci_unregister_dev(hdev) < 0)
 		BT_ERR("Can't unregister HCI device %s", hdev->name);
 
-	hci_free_dev(hdev);
-
 	return 0;
 }
 
diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index 0f4203b..4c4d555 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -312,7 +312,6 @@ static void hci_uart_tty_close(struct tt
 		if (test_and_clear_bit(HCI_UART_PROTO_SET, &hu->flags)) {
 			hu->proto->close(hu);
 			hci_unregister_dev(hdev);
-			hci_free_dev(hdev);
 		}
 	}
 }
diff --git a/drivers/bluetooth/hci_usb.c b/drivers/bluetooth/hci_usb.c
index 406af57..e9e0183 100644
--- a/drivers/bluetooth/hci_usb.c
+++ b/drivers/bluetooth/hci_usb.c
@@ -1069,8 +1069,6 @@ static void hci_usb_disconnect(struct us
 
 	if (hci_unregister_dev(hdev) < 0)
 		BT_ERR("Can't unregister HCI device %s", hdev->name);
-
-	hci_free_dev(hdev);
 }
 
 static int hci_usb_suspend(struct usb_interface *intf, pm_message_t message)
diff --git a/drivers/bluetooth/hci_vhci.c b/drivers/bluetooth/hci_vhci.c
index b71a5cc..e5a3a8c 100644
--- a/drivers/bluetooth/hci_vhci.c
+++ b/drivers/bluetooth/hci_vhci.c
@@ -308,8 +308,6 @@ static int vhci_release(struct inode *in
 		BT_ERR("Can't unregister HCI device %s", hdev->name);
 	}
 
-	hci_free_dev(hdev);
-
 	file->private_data = NULL;
 
 	return 0;
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index c0fc396..a0a0a15 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -132,6 +132,8 @@ struct hci_dev {
 
 	struct module 		*owner;
 
+	struct work_struct	hci_dev_unreg_work;
+
 	int (*open)(struct hci_dev *hdev);
 	int (*close)(struct hci_dev *hdev);
 	int (*flush)(struct hci_dev *hdev);
@@ -622,6 +624,7 @@ void hci_si_event(struct hci_dev *hdev,
 
 /* ----- HCI Sockets ----- */
 void hci_send_to_sock(struct hci_dev *hdev, struct sk_buff *skb);
+void hci_sock_detach(struct hci_dev *hdev);
 
 /* HCI info for socket */
 #define hci_pi(sk) ((struct hci_pinfo *) sk)
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 4917919..54a50ee 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -795,6 +795,14 @@ int hci_get_dev_info(void __user *arg)
 	return err;
 }
 
+void hci_dev_unreg(struct work_struct *work)
+{
+	struct hci_dev *hdev = 
+		container_of(work, struct hci_dev, hci_dev_unreg_work);
+	hci_sock_detach(hdev);
+	hci_free_dev(hdev);
+}
+
 /* ---- Interface to HCI drivers ---- */
 
 /* Alloc HCI device */
@@ -807,6 +815,7 @@ struct hci_dev *hci_alloc_dev(void)
 		return NULL;
 
 	skb_queue_head_init(&hdev->driver_init);
+	INIT_WORK(&hdev->hci_dev_unreg_work, hci_dev_unreg);
 
 	return hdev;
 }
diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 71f5cfb..fb59408 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -141,6 +141,28 @@ void hci_send_to_sock(struct hci_dev *hd
 	read_unlock(&hci_sk_list.lock);
 }
 
+void hci_sock_detach(struct hci_dev *hdev)
+{
+	struct sock *sk;
+	struct hlist_node *node;
+
+	/* Detach sockets from device */
+	read_lock(&hci_sk_list.lock);
+	sk_for_each(sk, node, &hci_sk_list.head) {
+		lock_sock(sk);
+		if (hci_pi(sk)->hdev == hdev) {
+			hci_pi(sk)->hdev = NULL;
+			sk->sk_err = EPIPE;
+			sk->sk_state = BT_OPEN;
+			sk->sk_state_change(sk);
+
+			hci_dev_put(hdev);
+		}
+		release_sock(sk);
+	}
+	read_unlock(&hci_sk_list.lock);
+}
+
 static int hci_sock_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
@@ -649,26 +671,8 @@ static int hci_sock_dev_event(struct not
 	ev.dev_id = hdev->id;
 	hci_si_event(NULL, HCI_EV_SI_DEVICE, sizeof(ev), &ev);
 
-	if (event == HCI_DEV_UNREG) {
-		struct sock *sk;
-		struct hlist_node *node;
-
-		/* Detach sockets from device */
-		read_lock(&hci_sk_list.lock);
-		sk_for_each(sk, node, &hci_sk_list.head) {
-			lock_sock(sk);
-			if (hci_pi(sk)->hdev == hdev) {
-				hci_pi(sk)->hdev = NULL;
-				sk->sk_err = EPIPE;
-				sk->sk_state = BT_OPEN;
-				sk->sk_state_change(sk);
-
-				hci_dev_put(hdev);
-			}
-			release_sock(sk);
-		}
-		read_unlock(&hci_sk_list.lock);
-	}
+	if (event == HCI_DEV_UNREG)
+		schedule_work(&hdev->hci_dev_unreg_work);
 
 	return NOTIFY_DONE;
 }
