Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbZJSGb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbZJSGb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 02:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbZJSGb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 02:31:28 -0400
Received: from mail-px0-f171.google.com ([209.85.216.171]:33933 "EHLO
	mail-px0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbZJSGb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 02:31:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=hoyYtObf7pjuBvw85mcJh0fShmrnPE4NV0OZFnu9+ab1AqEZmDjXdNJ9nRHTjGlJ4L
         KNR28QlMcEKly31j8xP4unc7rJLz8he4oUAwMKtl1qYYrrBuVrSF8QgnPIiKpWCxb7Ag
         WVvL0UvAZccH9hPAcabFARFyMtpJwyYALeDxw=
Date: Mon, 19 Oct 2009 14:24:41 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: marcel@holtmann.org
Cc: alan@lxorguk.ukuu.org.uk, oliver@hartkopp.net, netdev@vger.kernel.org,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] bluetooth: scheduling while atomic bug fix
Message-ID: <20091019062441.GA4102@darkstar.vlan7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to driver core changes dev_set_drvdata will call kzalloc which should be
in might_sleep context, but hci_conn_add will be called in atomic context

Like dev_set_name move dev_set_drvdata to work queue function.

oops as following:

Oct  2 17:41:59 darkstar kernel: [  438.001341] BUG: sleeping function called from invalid context at mm/slqb.c:1546
Oct  2 17:41:59 darkstar kernel: [  438.001345] in_atomic(): 1, irqs_disabled(): 0, pid: 2133, name: sdptool
Oct  2 17:41:59 darkstar kernel: [  438.001348] 2 locks held by sdptool/2133:
Oct  2 17:41:59 darkstar kernel: [  438.001350]  #0:  (sk_lock-AF_BLUETOOTH-BTPROTO_L2CAP){+.+.+.}, at: [<faa1d2f5>] lock_sock+0xa/0xc [l2cap]
Oct  2 17:41:59 darkstar kernel: [  438.001360]  #1:  (&hdev->lock){+.-.+.}, at: [<faa20e16>] l2cap_sock_connect+0x103/0x26b [l2cap]
Oct  2 17:41:59 darkstar kernel: [  438.001371] Pid: 2133, comm: sdptool Not tainted 2.6.31-mm1 #2
Oct  2 17:41:59 darkstar kernel: [  438.001373] Call Trace:
Oct  2 17:41:59 darkstar kernel: [  438.001381]  [<c022433f>] __might_sleep+0xde/0xe5
Oct  2 17:41:59 darkstar kernel: [  438.001386]  [<c0298843>] __kmalloc+0x4a/0x15a
Oct  2 17:41:59 darkstar kernel: [  438.001392]  [<c03f0065>] ? kzalloc+0xb/0xd
Oct  2 17:41:59 darkstar kernel: [  438.001396]  [<c03f0065>] kzalloc+0xb/0xd
Oct  2 17:41:59 darkstar kernel: [  438.001400]  [<c03f04ff>] device_private_init+0x15/0x3d
Oct  2 17:41:59 darkstar kernel: [  438.001405]  [<c03f24c5>] dev_set_drvdata+0x18/0x26
Oct  2 17:41:59 darkstar kernel: [  438.001414]  [<fa51fff7>] hci_conn_init_sysfs+0x40/0xd9 [bluetooth]
Oct  2 17:41:59 darkstar kernel: [  438.001422]  [<fa51cdc0>] ? hci_conn_add+0x128/0x186 [bluetooth]
Oct  2 17:41:59 darkstar kernel: [  438.001429]  [<fa51ce0f>] hci_conn_add+0x177/0x186 [bluetooth]
Oct  2 17:41:59 darkstar kernel: [  438.001437]  [<fa51cf8a>] hci_connect+0x3c/0xfb [bluetooth]
Oct  2 17:41:59 darkstar kernel: [  438.001442]  [<faa20e87>] l2cap_sock_connect+0x174/0x26b [l2cap]
Oct  2 17:41:59 darkstar kernel: [  438.001448]  [<c04c8df5>] sys_connect+0x60/0x7a
Oct  2 17:41:59 darkstar kernel: [  438.001453]  [<c024b703>] ? lock_release_non_nested+0x84/0x1de
Oct  2 17:41:59 darkstar kernel: [  438.001458]  [<c028804b>] ? might_fault+0x47/0x81
Oct  2 17:41:59 darkstar kernel: [  438.001462]  [<c028804b>] ? might_fault+0x47/0x81
Oct  2 17:41:59 darkstar kernel: [  438.001468]  [<c033361f>] ? __copy_from_user_ll+0x11/0xce
Oct  2 17:41:59 darkstar kernel: [  438.001472]  [<c04c9419>] sys_socketcall+0x82/0x17b
Oct  2 17:41:59 darkstar kernel: [  438.001477]  [<c020329d>] syscall_call+0x7/0xb

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
net/bluetooth/hci_sysfs.c |    4 ++--
1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.31.orig/net/bluetooth/hci_sysfs.c	2009-10-09 20:50:43.000000000 +0800
+++ linux-2.6.31/net/bluetooth/hci_sysfs.c	2009-10-10 21:24:56.000000000 +0800
@@ -92,6 +92,8 @@ static void add_conn(struct work_struct 
 
 	dev_set_name(&conn->dev, "%s:%d", hdev->name, conn->handle);
 
+	dev_set_drvdata(&conn->dev, conn);
+
 	if (device_add(&conn->dev) < 0) {
 		BT_ERR("Failed to register connection device");
 		return;
@@ -144,8 +146,6 @@ void hci_conn_init_sysfs(struct hci_conn
 	conn->dev.class = bt_class;
 	conn->dev.parent = &hdev->dev;
 
-	dev_set_drvdata(&conn->dev, conn);
-
 	device_initialize(&conn->dev);
 
 	INIT_WORK(&conn->work_add, add_conn);
