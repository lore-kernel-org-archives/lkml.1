Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbYBRHuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbYBRHuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 02:50:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757015AbYBRHtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 02:49:51 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:9631 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944AbYBRHtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 02:49:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=XOJ946Nd37GQ/Pta2yghVZnbe5EikGSgwNYE/u0OkBt2gEvEVOwq5gmhQ4mi0ENxJzRW8vEZNSYrr2bpvwv0HCc/8SsglhKqeUHLYx4tEi9vwYSExQEojvO+WHy8QxhZQJRIqZY5E4/aazq9+kSJtuWYm/ZceBiZIbDfXkUhXvU=
Date: Mon, 18 Feb 2008 15:55:55 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: marcel@holtmann.org
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH 1/2] bluetooth : put hci dev after del conn
Message-ID: <20080218075555.GA5940@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move hci_dev_put to del_conn to avoid hci dev going away before hci conn.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
net/bluetooth/hci_conn.c  |    1 -
net/bluetooth/hci_sysfs.c |    5 ++++-
2 files changed, 4 insertions(+), 2 deletions(-)

diff -upr linux/net/bluetooth/hci_conn.c linux.new/net/bluetooth/hci_conn.c
--- linux/net/bluetooth/hci_conn.c	2008-02-16 06:38:56.000000000 +0800
+++ linux.new/net/bluetooth/hci_conn.c	2008-02-16 06:54:17.000000000 +0800
@@ -260,7 +260,6 @@ int hci_conn_del(struct hci_conn *conn)
 	tasklet_enable(&hdev->tx_task);
 	skb_queue_purge(&conn->data_q);
 	hci_conn_del_sysfs(conn);
-	hci_dev_put(hdev);
 
 	return 0;
 }
diff -upr linux/net/bluetooth/hci_sysfs.c linux.new/net/bluetooth/hci_sysfs.c
--- linux/net/bluetooth/hci_sysfs.c	2008-02-16 06:38:56.000000000 +0800
+++ linux.new/net/bluetooth/hci_sysfs.c	2008-02-16 06:54:17.000000000 +0800
@@ -333,15 +333,18 @@ static int __match_tty(struct device *de
 
 static void del_conn(struct work_struct *work)
 {
-	struct device *dev;
 	struct hci_conn *conn = container_of(work, struct hci_conn, work);
+	struct hci_dev *hdev = conn->hdev;
+	struct device *dev;
 
 	while (dev = device_find_child(&conn->dev, NULL, __match_tty)) {
 		device_move(dev, NULL);
 		put_device(dev);
 	}
+
 	device_del(&conn->dev);
 	put_device(&conn->dev);
+	hci_dev_put(hdev);
 }
 
 void hci_conn_del_sysfs(struct hci_conn *conn)
