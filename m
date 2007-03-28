Return-Path: <linux-kernel-owner+w=401wt.eu-S932309AbXC1Pcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbXC1Pcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 11:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932286AbXC1PcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 11:32:19 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:49250 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbXC1PcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 11:32:16 -0400
Date: Wed, 28 Mar 2007 11:28:48 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Blaisorblade <blaisorblade@yahoo.it>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 3/4] UML - Eliminate temporary buffer in eth_configure
Message-ID: <20070328152848.GA6340@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
  
Avoid using the temporary buffer introduced by previous patch to hold the
device name.

Btw, avoid leaking device on an error path. Other error paths may need cleanup.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/drivers/net_kern.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

Index: linux-2.6.21-mm/arch/um/drivers/net_kern.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/net_kern.c	2007-03-28 09:06:37.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/net_kern.c	2007-03-28 10:14:52.000000000 -0400
@@ -348,17 +348,24 @@ static void eth_configure(int n, void *i
 	struct net_device *dev;
 	struct uml_net_private *lp;
 	int save, err, size;
-	char name[sizeof(dev->name)];
 
 	size = transport->private_size + sizeof(struct uml_net_private) +
 		sizeof(((struct uml_net_private *) 0)->user);
 
 	device = kzalloc(sizeof(*device), GFP_KERNEL);
 	if (device == NULL) {
-		printk(KERN_ERR "eth_configure failed to allocate uml_net\n");
+		printk(KERN_ERR "eth_configure failed to allocate struct "
+		       "uml_net\n");
 		return;
 	}
 
+	dev = alloc_etherdev(size);
+	if (dev == NULL) {
+		printk(KERN_ERR "eth_configure: failed to allocate struct "
+		       "net_device for eth%d\n", n);
+		goto out_free_device;
+	}
+
 	INIT_LIST_HEAD(&device->list);
 	device->index = n;
 
@@ -366,9 +373,9 @@ static void eth_configure(int n, void *i
 	 * netdevice, that is OK, register_netdev{,ice}() will notice this
 	 * and fail.
 	 */
-	snprintf(name, sizeof(name), "eth%d", n);
+	snprintf(dev->name, sizeof(dev->name), "eth%d", n);
 
-	setup_etheraddr(mac, device->mac, name);
+	setup_etheraddr(mac, device->mac, dev->name);
 
 	printk(KERN_INFO "Netdevice %d ", n);
 	printk("(%02x:%02x:%02x:%02x:%02x:%02x) ",
@@ -376,11 +383,6 @@ static void eth_configure(int n, void *i
 	       device->mac[2], device->mac[3],
 	       device->mac[4], device->mac[5]);
 	printk(": ");
-	dev = alloc_etherdev(size);
-	if (dev == NULL) {
-		printk(KERN_ERR "eth_configure: failed to allocate device\n");
-		goto out_free_device;
-	}
 
 	lp = dev->priv;
 	/* This points to the transport private data. It's still clear, but we
@@ -399,7 +401,6 @@ static void eth_configure(int n, void *i
 		goto out_free_netdev;
 	SET_NETDEV_DEV(dev,&device->pdev.dev);
 
-	strcpy(dev->name, name);
 	device->dev = dev;
 
 	/*
@@ -466,13 +467,13 @@ static void eth_configure(int n, void *i
 	return;
 
 out_undo_user_init:
-	if (transport->user->init != NULL)
+	if (transport->user->remove != NULL)
 		(*transport->user->remove)(&lp->user);
 out_unregister:
 	platform_device_unregister(&device->pdev);
 out_free_netdev:
 	free_netdev(dev);
-out_free_device: ;
+out_free_device:
 	kfree(device);
 }
 
