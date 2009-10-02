Return-Path: <linux-kernel-owner+w=401wt.eu-S1757651AbZJBK6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651AbZJBK6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 06:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757626AbZJBK6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 06:58:06 -0400
Received: from mail-qy0-f174.google.com ([209.85.221.174]:40415 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757615AbZJBK6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 06:58:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BmbIEuGvEEaGKus/UEXLHUdBBJ+feLY84sF8Fkr3Kc9gdTwOnISwqTs8LIq6BFhHHN
         QuVWcM7p5q+ZkYOdvbibcFRrTOmMjd6j2CKpYUQsWQ9AqMwgaxcVnnhZZ7QENCHeR2V4
         4OocPVegorVwQ+U1qdHTxRT3slR/UhX+GPb4E=
Date: Fri, 2 Oct 2009 18:57:40 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
       marcel@holtmann.org
Subject: Re: Bluetooth is very ill in -next
Message-ID: <20091002105740.GA2809@darkstar>
References: <20090930142636.5366dafe@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930142636.5366dafe@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 02:26:36PM +0100, Alan Cox wrote:
> 
> Doing "sdptool search DUN" reliably crashes the kernel when using a USB
> bluetooth dongle
> 
> Language Base Attr List:
>   code_ISO639: 0x656e
>   encoding:    0x6a
>   base_offset: 0x100
> Profile Descriptor List:
>   "Dialup Networking" (0x1103)
>     Version: 0x0100
> 
> 
> is as far as it gets
> 
> It then explodes
> 
> _spin_lock_irqsave
> ?skb_dequeue
> skb_dequeue
> skb_queue_purge
> l2cap_recv_frame
> ?__lock_acquire
> ?__usb_hcd_submit_urb
> ?__lock_acquire
> l2cap_recv_acldata
> hci_rx_task
> ?l2cap_recv_acldata
> tasklet_action
> 
> reliably.
> 

Marcel, please take a look at following patch, same as previous
dev_set_name problem.

---
Due to driver core changes dev_set_drvdata will call kzalloc which should be
in might_sleep context, but hci_conn_add will be called in atomic context

Like dev_set_name just put all other device callbacks to work queue function.

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
net/bluetooth/hci_sysfs.c |   18 ++++++++----------
1 file changed, 8 insertions(+), 10 deletions(-)

--- linux-2.6.31.orig/net/bluetooth/hci_sysfs.c	2009-10-02 18:04:14.000000000 +0800
+++ linux-2.6.31/net/bluetooth/hci_sysfs.c	2009-10-02 18:05:22.000000000 +0800
@@ -90,6 +90,14 @@ static void add_conn(struct work_struct 
 	struct hci_conn *conn = container_of(work, struct hci_conn, work_add);
 	struct hci_dev *hdev = conn->hdev;
 
+	conn->dev.type = &bt_link;
+	conn->dev.class = bt_class;
+	conn->dev.parent = &hdev->dev;
+
+	dev_set_drvdata(&conn->dev, conn);
+
+	device_initialize(&conn->dev);
+
 	dev_set_name(&conn->dev, "%s:%d", hdev->name, conn->handle);
 
 	if (device_add(&conn->dev) < 0) {
@@ -136,18 +144,8 @@ static void del_conn(struct work_struct 
 
 void hci_conn_init_sysfs(struct hci_conn *conn)
 {
-	struct hci_dev *hdev = conn->hdev;
-
 	BT_DBG("conn %p", conn);
 
-	conn->dev.type = &bt_link;
-	conn->dev.class = bt_class;
-	conn->dev.parent = &hdev->dev;
-
-	dev_set_drvdata(&conn->dev, conn);
-
-	device_initialize(&conn->dev);
-
 	INIT_WORK(&conn->work_add, add_conn);
 	INIT_WORK(&conn->work_del, del_conn);
 }
