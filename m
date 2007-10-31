Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbXJaCXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbXJaCXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 22:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbXJaCXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 22:23:14 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:59027 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbXJaCXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 22:23:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=EaoNZd8ugaYReNFDvp7a9wuhqdaz/EzD0OU/iQyDPvcFICnpIAuWsUSJcH0EIx58pnUGGV6PS++2QLVQY00+eI0Sj3ZTc3TNyrdJG44TzdcljXfat1+dlz1X08P2nbD4Esz5txzLamZmZWZbavr4n5WxRbMcRlUjqhKjkLHKUm0=
Date: Wed, 31 Oct 2007 10:30:17 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: LKML <linux-kernel@vger.kernel.org>, bluez-devel@lists.sourceforge.net
Subject: [PATCH]bluetooth: hci_sysfs connection bus_id add support for diffrent hci device
Message-ID: <20071031023017.GA3896@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For multi hci devices host, connection from/to same destination
bluetooth device, add_conn will failed due to sysfs duplicate name.

sysfs: duplicate filename 'acl0018C5B6B456' can not be created
WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
 [<c01c0120>] sysfs_add_one+0xa0/0xe0
 [<c01c0d7b>] sysfs_create_link+0x9b/0x140
 [<c01c1671>] create_files+0x31/0x60
 [<c02b537b>] bus_add_device+0x5b/0xf0
 [<c02b391c>] device_add+0x11c/0x350
 [<f8951410>] add_conn+0x0/0x90 [bluetooth]
 [<f895141f>] add_conn+0xf/0x90 [bluetooth]
 [<c013baee>] run_workqueue+0x5e/0x110
 [<c013bc4c>] worker_thread+0xac/0x100
 [<c0140000>] autoremove_wake_function+0x0/0x50
 [<c0140000>] autoremove_wake_function+0x0/0x50
 [<c013bba0>] worker_thread+0x0/0x100
 [<c013fa39>] kthread+0x59/0xa0
 [<c013f9e0>] kthread+0x0/0xa0
 [<c0104f83>] kernel_thread_helper+0x7/0x14
 =======================
add_conn: Failed to register connection device

Add prefix hdev->name to bus_id to fix this problem.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
net/bluetooth/hci_sysfs.c |    3 ++-
1 file changed, 2 insertions(+), 1 deletion(-)

diff -upr linux/net/bluetooth/hci_sysfs.c linux.new/net/bluetooth/hci_sysfs.c
--- linux/net/bluetooth/hci_sysfs.c	2007-10-31 10:21:00.000000000 +0800
+++ linux.new/net/bluetooth/hci_sysfs.c	2007-10-31 10:21:55.000000000 +0800
@@ -302,7 +302,8 @@ void hci_conn_add_sysfs(struct hci_conn 
 	conn->dev.release = bt_release;
 
 	snprintf(conn->dev.bus_id, BUS_ID_SIZE,
-			"%s%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X",
+			"%s%s%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X",
+			hdev->name,
 			conn->type == ACL_LINK ? "acl" : "sco",
 			ba->b[5], ba->b[4], ba->b[3],
 			ba->b[2], ba->b[1], ba->b[0]);
