Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbZJPRSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbZJPRSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754616AbZJPRSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:18:37 -0400
Received: from kroah.org ([198.145.64.141]:48562 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199AbZJPRSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:32 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:12:00 2009
Message-Id: <20091016171200.183091048@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:10:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcel Holtmann <marcel@holtmann.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [26/46] Bluetooth: Add extra device reference counting for connections
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=bluetooth-add-extra-device-reference-counting-for-connections.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Marcel Holtmann <marcel@holtmann.org>

commit 9eba32b86d17ef87131fa0bce43c614904ab5781 upstream.

The device model itself has no real usable reference counting at the
moment and this causes problems if parents are deleted before their
children. The device model itself handles the memory details of this
correctly, but the uevent order is not consistent. This causes various
problems for systems like HAL or even X.

So until device_put() does a proper cleanup, the device for Bluetooth
connection will be protected with an extra reference counting to ensure
the correct order of uevents when connections are terminated.

This is not an automatic feature. Higher Bluetooth layers like HIDP or
BNEP should grab this new reference to ensure that their uevents are
send before the ones from the parent device.

Based on a report by Brian Rogers <brian@xyzw.org>

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/net/bluetooth/hci_core.h |    4 ++++
 net/bluetooth/hci_conn.c         |   17 ++++++++++++++++-
 net/bluetooth/hci_event.c        |    2 ++
 3 files changed, 22 insertions(+), 1 deletion(-)

--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -187,6 +187,7 @@ struct hci_conn {
 	struct work_struct work_del;
 
 	struct device	dev;
+	atomic_t	devref;
 
 	struct hci_dev	*hdev;
 	void		*l2cap_data;
@@ -339,6 +340,9 @@ int hci_conn_switch_role(struct hci_conn
 void hci_conn_enter_active_mode(struct hci_conn *conn);
 void hci_conn_enter_sniff_mode(struct hci_conn *conn);
 
+void hci_conn_hold_device(struct hci_conn *conn);
+void hci_conn_put_device(struct hci_conn *conn);
+
 static inline void hci_conn_hold(struct hci_conn *conn)
 {
 	atomic_inc(&conn->refcnt);
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -246,6 +246,8 @@ struct hci_conn *hci_conn_add(struct hci
 	if (hdev->notify)
 		hdev->notify(hdev, HCI_NOTIFY_CONN_ADD);
 
+	atomic_set(&conn->devref, 0);
+
 	hci_conn_init_sysfs(conn);
 
 	tasklet_enable(&hdev->tx_task);
@@ -288,7 +290,7 @@ int hci_conn_del(struct hci_conn *conn)
 
 	skb_queue_purge(&conn->data_q);
 
-	hci_conn_del_sysfs(conn);
+	hci_conn_put_device(conn);
 
 	hci_dev_put(hdev);
 
@@ -583,6 +585,19 @@ void hci_conn_check_pending(struct hci_d
 	hci_dev_unlock(hdev);
 }
 
+void hci_conn_hold_device(struct hci_conn *conn)
+{
+	atomic_inc(&conn->devref);
+}
+EXPORT_SYMBOL(hci_conn_hold_device);
+
+void hci_conn_put_device(struct hci_conn *conn)
+{
+	if (atomic_dec_and_test(&conn->devref))
+		hci_conn_del_sysfs(conn);
+}
+EXPORT_SYMBOL(hci_conn_put_device);
+
 int hci_get_conn_list(void __user *arg)
 {
 	struct hci_conn_list_req req, *cl;
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -887,6 +887,7 @@ static inline void hci_conn_complete_evt
 		} else
 			conn->state = BT_CONNECTED;
 
+		hci_conn_hold_device(conn);
 		hci_conn_add_sysfs(conn);
 
 		if (test_bit(HCI_AUTH, &hdev->flags))
@@ -1693,6 +1694,7 @@ static inline void hci_sync_conn_complet
 		conn->handle = __le16_to_cpu(ev->handle);
 		conn->state  = BT_CONNECTED;
 
+		hci_conn_hold_device(conn);
 		hci_conn_add_sysfs(conn);
 		break;
 


