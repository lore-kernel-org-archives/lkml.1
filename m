Return-Path: <linux-kernel-owner+w=401wt.eu-S1760124AbYBWAnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124AbYBWAnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:43:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763707AbYBWAfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:35:12 -0500
Received: from mail.suse.de ([195.135.220.2]:44864 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654AbYBWAfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:35:08 -0500
Date: Fri, 22 Feb 2008 16:30:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dave Young <hidave.darkstar@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 21/38] BLUETOOTH: Add conn add/del workqueues to avoid
	connection fail.
Message-ID: <20080223003051.GV7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="bluetooth-add-conn-add-del-workqueues-to-avoid-connection-fail.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------
Upstream commit: b6c0632105f7d7548f1d642ba830088478d4f2b0

The bluetooth hci_conn sysfs add/del executed in the default
workqueue.  If the del_conn is executed after the new add_conn with
same target, add_conn will failed with warning of "same kobject name".

Here add btaddconn & btdelconn workqueues, flush the btdelconn
workqueue in the add_conn function to avoid the issue.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/bluetooth/hci_sysfs.c |   48 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 37 insertions(+), 11 deletions(-)

--- a/net/bluetooth/hci_sysfs.c
+++ b/net/bluetooth/hci_sysfs.c
@@ -12,6 +12,8 @@
 #undef  BT_DBG
 #define BT_DBG(D...)
 #endif
+static struct workqueue_struct *btaddconn;
+static struct workqueue_struct *btdelconn;
 
 static inline char *typetostr(int type)
 {
@@ -279,6 +281,7 @@ static void add_conn(struct work_struct 
 	struct hci_conn *conn = container_of(work, struct hci_conn, work);
 	int i;
 
+	flush_workqueue(btdelconn);
 	if (device_add(&conn->dev) < 0) {
 		BT_ERR("Failed to register connection device");
 		return;
@@ -313,6 +316,7 @@ void hci_conn_add_sysfs(struct hci_conn 
 
 	INIT_WORK(&conn->work, add_conn);
 
+	queue_work(btaddconn, &conn->work);
 	schedule_work(&conn->work);
 }
 
@@ -349,6 +353,7 @@ void hci_conn_del_sysfs(struct hci_conn 
 
 	INIT_WORK(&conn->work, del_conn);
 
+	queue_work(btdelconn, &conn->work);
 	schedule_work(&conn->work);
 }
 
@@ -398,31 +403,52 @@ int __init bt_sysfs_init(void)
 {
 	int err;
 
+	btaddconn = create_singlethread_workqueue("btaddconn");
+	if (!btaddconn) {
+		err = -ENOMEM;
+		goto out;
+	}
+	btdelconn = create_singlethread_workqueue("btdelconn");
+	if (!btdelconn) {
+		err = -ENOMEM;
+		goto out_del;
+	}
+
 	bt_platform = platform_device_register_simple("bluetooth", -1, NULL, 0);
-	if (IS_ERR(bt_platform))
-		return PTR_ERR(bt_platform);
+	if (IS_ERR(bt_platform)) {
+		err = PTR_ERR(bt_platform);
+		goto out_platform;
+	}
 
 	err = bus_register(&bt_bus);
-	if (err < 0) {
-		platform_device_unregister(bt_platform);
-		return err;
-	}
+	if (err < 0)
+		goto out_bus;
 
 	bt_class = class_create(THIS_MODULE, "bluetooth");
 	if (IS_ERR(bt_class)) {
-		bus_unregister(&bt_bus);
-		platform_device_unregister(bt_platform);
-		return PTR_ERR(bt_class);
+		err = PTR_ERR(bt_class);
+		goto out_class;
 	}
 
 	return 0;
+
+out_class:
+	bus_unregister(&bt_bus);
+out_bus:
+	platform_device_unregister(bt_platform);
+out_platform:
+	destroy_workqueue(btdelconn);
+out_del:
+	destroy_workqueue(btaddconn);
+out:
+	return err;
 }
 
 void bt_sysfs_cleanup(void)
 {
+	destroy_workqueue(btaddconn);
+	destroy_workqueue(btdelconn);
 	class_destroy(bt_class);
-
 	bus_unregister(&bt_bus);
-
 	platform_device_unregister(bt_platform);
 }

-- 
