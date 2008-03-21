Return-Path: <linux-kernel-owner+w=401wt.eu-S1763581AbYCUWtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763581AbYCUWtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762725AbYCUWq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:46:27 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:34758 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762726AbYCUWq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:46:26 -0400
Message-Id: <20080321224455.451697559@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:44:05 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
       David S Miller <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 75/76] BLUETOOTH: Fix bugs in previous conn add/del workqueue changes.
Content-Disposition: inline; filename=bluetooth-fix-bugs-in-previous-conn-add-del-workqueue-changes.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Dave Young <hidave.darkstar@gmail.com>

Jens Axboe noticed that we were queueing &conn->work on both btaddconn
and keventd_wq.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 net/bluetooth/hci_sysfs.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/bluetooth/hci_sysfs.c
+++ b/net/bluetooth/hci_sysfs.c
@@ -282,6 +282,7 @@ static void add_conn(struct work_struct 
 	int i;
 
 	flush_workqueue(btdelconn);
+
 	if (device_add(&conn->dev) < 0) {
 		BT_ERR("Failed to register connection device");
 		return;
@@ -317,7 +318,6 @@ void hci_conn_add_sysfs(struct hci_conn 
 	INIT_WORK(&conn->work, add_conn);
 
 	queue_work(btaddconn, &conn->work);
-	schedule_work(&conn->work);
 }
 
 static int __match_tty(struct device *dev, void *data)
@@ -354,7 +354,6 @@ void hci_conn_del_sysfs(struct hci_conn 
 	INIT_WORK(&conn->work, del_conn);
 
 	queue_work(btdelconn, &conn->work);
-	schedule_work(&conn->work);
 }
 
 int hci_register_sysfs(struct hci_dev *hdev)
@@ -408,6 +407,7 @@ int __init bt_sysfs_init(void)
 		err = -ENOMEM;
 		goto out;
 	}
+
 	btdelconn = create_singlethread_workqueue("btdelconn");
 	if (!btdelconn) {
 		err = -ENOMEM;
@@ -447,8 +447,12 @@ out:
 void bt_sysfs_cleanup(void)
 {
 	destroy_workqueue(btaddconn);
+
 	destroy_workqueue(btdelconn);
+
 	class_destroy(bt_class);
+
 	bus_unregister(&bt_bus);
+
 	platform_device_unregister(bt_platform);
 }

-- 
