Return-Path: <linux-kernel-owner+w=401wt.eu-S1760506AbXK1BdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760506AbXK1BdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 20:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbXK1BdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 20:33:04 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:42509 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbXK1BdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 20:33:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=LkriKcLLNKxis7pf6/fGzGhB+bcf2zCj7hwXF2BjRurx/hCKT56euhsbAh9p9H+j53Ul/Dvdlk/FYCI82v+SGfnYadQWEX2rJFAGnyacJEn61bZPzr1EmGqdEdR4iYHoxUlUxsrCEMFgRywUbFbcFvi5Oe1BkvCkopv+ZavL/SY=
Date: Wed, 28 Nov 2007 09:33:53 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Marco Pracucci <development@pracucci.com>
Cc: marcel@holtmann.org, linux-kernel@vger.kernel.org,
       Bluez Development ML <bluez-devel@lists.sourceforge.net>
Subject: Re: [Bluez-devel] 2.6.23.8: kernel panic
Message-ID: <20071128013353.GA3028@darkstar.te-china.tietoenator.com>
References: <4746EC10.5080509@pracucci.com> <20071127103239.GA4477@darkstar.te-china.tietoenator.com> <474C398D.1000701@pracucci.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474C398D.1000701@pracucci.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 04:36:45PM +0100, Marco Pracucci wrote:
> Hi Dave,
> > This problem is caused by the workqueue in hci_sysfs.c, the del_conn
> > is scheduled after the add_conn with same bluetooth address.
> > Please try this patch:
> > ----------------------------
> >
> > The bluetooth hci conn sysfs add/del executed in the default workqueue. If the conn del function is executed after the new conn add function with same bluetooth target address, the connection add will failed and warning about same kobject name.
> >
> > Here add a btconn workqueue, and flush the workqueue in the add_conn function to avoid the above issue. 
> >   
> I have applied your patch against kernel 2.6.24-rc3 and I've got the
> following error:
> 
> Jan 1 00:13:01 user.warn kernel: run_workqueue: recursion depth exceeded: 4
> Jan 1 00:13:01 user.warn kernel: [<c0022a88>] (dump_stack+0x0/0x14) from
> [<c00485cc>] (run_workqueue+0x4c/0x144)
> Jan 1 00:13:01 user.warn kernel: [<c0048580>] (run_workqueue+0x0/0x144)
> from [<c00486f8>] (flush_cpu_workqueue+0x34/0x94)
> Jan 1 00:13:01 user.warn kernel: r6:c020d624 r5:c05bc088 r4:00000001
> Jan 1 00:13:01 user.warn kernel: [<c00486c4>]
> (flush_cpu_workqueue+0x0/0x94) from [<c0048cc0>] (flush_workqueue+0x14/0x18)
> Jan 1 00:13:01 user.warn kernel: r4:c03c9420
> Jan 1 00:13:01 user.warn kernel: [<c0048cac>] (flush_workqueue+0x0/0x18)
> from [<c020d640>] (add_conn+0x1c/0x80)
> Jan 1 00:13:01 user.warn kernel: [<c020d624>] (add_conn+0x0/0x80) from
> [<c0048634>] (run_workqueue+0xb4/0x144)
> Jan 1 00:13:01 user.warn kernel: r5:c0340000 r4:c03c9420
> Jan 1 00:13:01 user.warn kernel: [<c0048580>] (run_workqueue+0x0/0x144)
> from [<c00486f8>] (flush_cpu_workqueue+0x34/0x94)
> Jan 1 00:13:01 user.warn kernel: r6:c020d624 r5:c1051e88 r4:00000001
> Jan 1 00:13:01 user.warn kernel: [<c00486c4>]
> (flush_cpu_workqueue+0x0/0x94) from [<c0048cc0>] (flush_workqueue+0x14/0x18)
> Jan 1 00:13:01 user.warn kernel: r4:c03c9420
> Jan 1 00:13:01 user.warn kernel: [<c0048cac>] (flush_workqueue+0x0/0x18)
> from [<c020d640>] (add_conn+0x1c/0x80)
> Jan 1 00:13:01 user.warn kernel: [<c020d624>] (add_conn+0x0/0x80) from
> [<c0048634>] (run_workqueue+0xb4/0x144)
> Jan 1 00:13:01 user.warn kernel: r5:c0340000 r4:c03c9420
> Jan 1 00:13:01 user.warn kernel: [<c0048580>] (run_workqueue+0x0/0x144)
> from [<c00486f8>] (flush_cpu_workqueue+0x34/0x94)
> Jan 1 00:13:01 user.warn kernel: r6:c020d624 r5:c042ca88 r4:00000001
> Jan 1 00:13:01 user.warn kernel: [<c00486c4>]
> (flush_cpu_workqueue+0x0/0x94) from [<c0048cc0>] (flush_workqueue+0x14/0x18)
> Jan 1 00:13:01 user.warn kernel: r4:c03c9420
> Jan 1 00:13:01 user.warn kernel: [<c0048cac>] (flush_workqueue+0x0/0x18)
> from [<c020d640>] (add_conn+0x1c/0x80)
> Jan 1 00:13:01 user.warn kernel: [<c020d624>] (add_conn+0x0/0x80) from
> [<c0048634>] (run_workqueue+0xb4/0x144)
> Jan 1 00:13:01 user.warn kernel: r5:c0340000 r4:c03c9420
> Jan 1 00:13:01 user.warn kernel: [<c0048580>] (run_workqueue+0x0/0x144)
> from [<c0048888>] (worker_thread+0xa4/0xb8)
> Jan 1 00:13:01 user.warn kernel: r6:c00487e4 r5:c03c9420 r4:c03c9428
> Jan 1 00:13:01 user.warn kernel: [<c00487e4>] (worker_thread+0x0/0xb8)
> from [<c004c598>] (kthread+0x5c/0x90)
> Jan 1 00:13:01 user.warn kernel: r5:c03c9420 r4:c0340000
> Jan 1 00:13:01 user.warn kernel: [<c004c53c>] (kthread+0x0/0x90) from
> [<c003b348>] (do_exit+0x0/0x690)
> Jan 1 00:13:01 user.warn kernel: r6:00000000 r5:00000000 r4:00000000
> 

Hi,Marco 
Thanks for testing, could you please try the below patch instead?

Marcel, thanks for consider my patch. there's some recursion problem in flush workqueue in itself, so maybe we should use two workqueue.

Regards
dave
-------------------

The bluetooth hci conn sysfs add/del executed in the default workqueue. If the conn del function is executed after the new conn add function with same bluetooth target address, the connection add will failed and warning about same kobject name.

Here add a btconn workqueue, and flush the workqueue in the add_conn function to avoid the above issue. 

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
net/bluetooth/hci_sysfs.c |   25 ++++++++++++++++++++++++-
1 file changed, 24 insertions(+), 1 deletion(-)

diff -upr linux/net/bluetooth/hci_sysfs.c linux.new/net/bluetooth/hci_sysfs.c
--- linux/net/bluetooth/hci_sysfs.c	2007-11-27 18:11:11.000000000 +0800
+++ linux.new/net/bluetooth/hci_sysfs.c	2007-11-28 09:18:45.000000000 +0800
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
 
@@ -331,6 +335,7 @@ void hci_conn_del_sysfs(struct hci_conn 
 
 	INIT_WORK(&conn->work, del_conn);
 
+	queue_work(btdelconn, &conn->work);
 	schedule_work(&conn->work);
 }
 
@@ -380,18 +385,34 @@ int __init bt_sysfs_init(void)
 {
 	int err;
 
+	btaddconn = create_singlethread_workqueue("btaddconn");
+	if (!btaddconn)
+		return -ENOMEM;
+	btdelconn = create_singlethread_workqueue("btdelconn");
+	if (!btdelconn) {
+		destroy_workqueue(btaddconn);
+		return -ENOMEM;
+	}
+
 	bt_platform = platform_device_register_simple("bluetooth", -1, NULL, 0);
-	if (IS_ERR(bt_platform))
+	if (IS_ERR(bt_platform)) {
+		destroy_workqueue(btaddconn);
+		destroy_workqueue(btdelconn);
 		return PTR_ERR(bt_platform);
+	}
 
 	err = bus_register(&bt_bus);
 	if (err < 0) {
+		destroy_workqueue(btaddconn);
+		destroy_workqueue(btdelconn);
 		platform_device_unregister(bt_platform);
 		return err;
 	}
 
 	bt_class = class_create(THIS_MODULE, "bluetooth");
 	if (IS_ERR(bt_class)) {
+		destroy_workqueue(btaddconn);
+		destroy_workqueue(btdelconn);
 		bus_unregister(&bt_bus);
 		platform_device_unregister(bt_platform);
 		return PTR_ERR(bt_class);
@@ -402,6 +423,8 @@ int __init bt_sysfs_init(void)
 
 void bt_sysfs_cleanup(void)
 {
+	destroy_workqueue(btaddconn);
+	destroy_workqueue(btdelconn);
 	class_destroy(bt_class);
 
 	bus_unregister(&bt_bus);
