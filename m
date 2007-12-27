Return-Path: <linux-kernel-owner+w=401wt.eu-S1753238AbXL0FYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbXL0FYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 00:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750747AbXL0FYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 00:24:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:46990 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbXL0FYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 00:24:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=seAmrZ8SVp+xUZ0GfxOuLU9i5/Am+pgoYA/wXUdfzhzuWuFnkn1/c5X7REoH4V4R6HqQsJEPqY7YVv19LrplGMqsPsld5FOfk+0ww+UQ5ejRMe6vuwnXY1gZrNx4xfKbP6iZf064sxq+gj+wEJHArmIN5iPkpLfAhFy5BQMUl2A=
Date: Thu, 27 Dec 2007 13:27:50 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: marcel@holtmann.org
Cc: akpm@linux-foundation.org, greg@kroah.com, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net
Subject: [BUG][PATCH] bluetooth: put_device before device_del fix
Message-ID: <20071227052750.GA6296@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of workqueue delay, the put_device could be called before device_del, so move it to del_conn.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
net/bluetooth/hci_conn.c  |   10 +---------
net/bluetooth/hci_sysfs.c |    1 +
2 files changed, 2 insertions(+), 9 deletions(-)

diff -upr linux/net/bluetooth/hci_conn.c linux.new/net/bluetooth/hci_conn.c
--- linux/net/bluetooth/hci_conn.c	2007-12-27 13:12:48.000000000 +0800
+++ linux.new/net/bluetooth/hci_conn.c	2007-12-27 13:17:50.000000000 +0800
@@ -254,22 +254,14 @@ int hci_conn_del(struct hci_conn *conn)
 	}
 
 	tasklet_disable(&hdev->tx_task);
-
-	hci_conn_del_sysfs(conn);
-
 	hci_conn_hash_del(hdev, conn);
 	if (hdev->notify)
 		hdev->notify(hdev, HCI_NOTIFY_CONN_DEL);
-
 	tasklet_enable(&hdev->tx_task);
-
 	skb_queue_purge(&conn->data_q);
-
+	hci_conn_del_sysfs(conn);
 	hci_dev_put(hdev);
 
-	/* will free via device release */
-	put_device(&conn->dev);
-
 	return 0;
 }
 
diff -upr linux/net/bluetooth/hci_sysfs.c linux.new/net/bluetooth/hci_sysfs.c
--- linux/net/bluetooth/hci_sysfs.c	2007-12-27 13:12:48.000000000 +0800
+++ linux.new/net/bluetooth/hci_sysfs.c	2007-12-27 13:14:06.000000000 +0800
@@ -320,6 +320,7 @@ static void del_conn(struct work_struct 
 {
 	struct hci_conn *conn = container_of(work, struct hci_conn, work);
 	device_del(&conn->dev);
+	put_device(&conn->dev);
 }
 
 void hci_conn_del_sysfs(struct hci_conn *conn)
