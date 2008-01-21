Return-Path: <linux-kernel-owner+w=401wt.eu-S1757844AbYAUEsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844AbYAUEsF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 23:48:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757051AbYAUErw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 23:47:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:45258 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757027AbYAUEru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 23:47:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=FaXooPnMGGoyaZW++TEoNX3qsU0IE8oRN1qkY9djrvencNrs9+vLijAgaaMw9OxhFIk3Np1wp02bwrvVKz5EOp2QRtKybo4kUqu+ZWkMp8wgRAJy5oYv1QGvYtKSXNMGuPlEpt5aAPvWWn0BxGOTHwcS8kCJIxAAUw48QUyy90o=
Date: Mon, 21 Jan 2008 12:49:13 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: marcel@holtmann.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net
Subject: [PATCH] bluetooth : move children of connection device to NULL
	before connection down
Message-ID: <20080121044913.GA4162@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rfcomm tty device will possibly retain even when conn is down,
and sysfs doesn't support zombie device moving, so this patch
move the tty device before conn device is destroyed.

For the bug refered please see :
http://lkml.org/lkml/2007/12/28/87

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
 net/bluetooth/hci_sysfs.c  |   17 +++++++++++++++++
 net/bluetooth/rfcomm/tty.c |    3 ++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff -upr linux/net/bluetooth/hci_sysfs.c linux.new/net/bluetooth/hci_sysfs.c
--- linux/net/bluetooth/hci_sysfs.c	2008-01-21 11:29:34.000000000 +0800
+++ linux.new/net/bluetooth/hci_sysfs.c	2008-01-21 11:33:46.000000000 +0800
@@ -316,9 +316,26 @@ void hci_conn_add_sysfs(struct hci_conn 
 	schedule_work(&conn->work);
 }
 
+static int __match_tty(struct device *dev, void *data)
+{
+	/* The rfcomm tty device will possibly retain even when conn
+	 * is down, and sysfs doesn't support move zombie device,
+	 * so we should move the device before conn device is destroyed.
+	 * Due to the only child device of hci_conn dev is rfcomm
+	 * tty_dev, here just return 1
+	 */
+	return 1;
+}
+
 static void del_conn(struct work_struct *work)
 {
+	struct device *dev;
 	struct hci_conn *conn = container_of(work, struct hci_conn, work);
+
+	while (dev = device_find_child(&conn->dev, NULL, __match_tty)) {
+		device_move(dev, NULL);
+		put_device(dev);
+	}
 	device_del(&conn->dev);
 	put_device(&conn->dev);
 }
diff -upr linux/net/bluetooth/rfcomm/tty.c linux.new/net/bluetooth/rfcomm/tty.c
--- linux/net/bluetooth/rfcomm/tty.c	2008-01-21 11:30:44.000000000 +0800
+++ linux.new/net/bluetooth/rfcomm/tty.c	2008-01-21 11:32:23.000000000 +0800
@@ -696,7 +696,8 @@ static void rfcomm_tty_close(struct tty_
 	BT_DBG("tty %p dev %p dlc %p opened %d", tty, dev, dev->dlc, dev->opened);
 
 	if (--dev->opened == 0) {
-		device_move(dev->tty_dev, NULL);
+		if (dev->tty_dev->parent)
+			device_move(dev->tty_dev, NULL);
 
 		/* Close DLC and dettach TTY */
 		rfcomm_dlc_close(dev->dlc, 0);
