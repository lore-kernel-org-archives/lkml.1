Return-Path: <linux-kernel-owner+w=401wt.eu-S1757402AbYBRHy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402AbYBRHy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 02:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbYBRHyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 02:54:14 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:12512 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbYBRHyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 02:54:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=UoUja2NghBZkkcHVTPfncD7RamDl9j8hftHZlH3tetzGj/NG1R/hNl51FMrBOhhcMINja6Nv6a+W0uApaEfhRBjwLt6XoHFNmFyWe7z2bpMBL5i96XYYuAy0JnhaRvhDUXfJk2TDAg48AynXZwNZLkpZdidWsQEjCsNBhAhZtUI=
Date: Mon, 18 Feb 2008 15:58:05 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: marcel@holtmann.org
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH 2/2] bluetooth : do not move child device other than rfcomm
Message-ID: <20080218075805.GB5940@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hci conn child devices other than rfcomm tty should not be moved here.
This is my lost, thanks for Barnaby's reporting and testing.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
net/bluetooth/hci_sysfs.c |   13 ++++++-------
1 file changed, 6 insertions(+), 7 deletions(-)

diff -upr linux/net/bluetooth/hci_sysfs.c linux.new/net/bluetooth/hci_sysfs.c
--- linux/net/bluetooth/hci_sysfs.c	2008-02-16 06:38:56.000000000 +0800
+++ linux.new/net/bluetooth/hci_sysfs.c	2008-02-17 15:45:15.000000000 +0800
@@ -320,15 +320,14 @@ void hci_conn_add_sysfs(struct hci_conn 
 	queue_work(btaddconn, &conn->work);
 }
 
+/*
+ * The rfcomm tty device will possibly retain even when conn
+ * is down, and sysfs doesn't support move zombie device,
+ * so we should move the device before conn device is destroyed.
+ */
 static int __match_tty(struct device *dev, void *data)
 {
-	/* The rfcomm tty device will possibly retain even when conn
-	 * is down, and sysfs doesn't support move zombie device,
-	 * so we should move the device before conn device is destroyed.
-	 * Due to the only child device of hci_conn dev is rfcomm
-	 * tty_dev, here just return 1
-	 */
-	return 1;
+	return !strncmp(dev->bus_id, "rfcomm", 6);
 }
 
 static void del_conn(struct work_struct *work)
