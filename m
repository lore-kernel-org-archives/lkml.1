Return-Path: <linux-kernel-owner+w=401wt.eu-S1752841AbXDWNyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbXDWNyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 09:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbXDWNye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 09:54:34 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40369 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752841AbXDWNyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 09:54:33 -0400
Date: Mon, 23 Apr 2007 14:57:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, greg@kroah.com, linux-kernel@vger.kernel.org
Subject: [PATCH] pci syscall.c: Switch to refcounting API
Message-ID: <20070423145737.2d0a8ce5@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc6-mm1/drivers/pci/syscall.c linux-2.6.21-rc6-mm1/drivers/pci/syscall.c
--- linux.vanilla-2.6.21-rc6-mm1/drivers/pci/syscall.c	2007-04-12 14:14:44.000000000 +0100
+++ linux-2.6.21-rc6-mm1/drivers/pci/syscall.c	2007-04-23 11:43:53.667542736 +0100
@@ -30,7 +30,7 @@
 		goto error;
 
 	err = -ENODEV;
-	dev = pci_find_slot(bus, dfn);
+	dev = pci_get_bus_and_slot(bus, dfn);
 	if (!dev)
 		goto error;
 
@@ -67,6 +67,7 @@
 		err = put_user(dword, (unsigned int __user *)buf);
 		break;
 	};
+	pci_dev_put(dev);
 	return err;
 
 error:
@@ -84,6 +85,7 @@
 		put_user(-1, (unsigned int __user *)buf);
 		break;
 	};
+	pci_dev_put(dev);
 	return err;
 }
 
@@ -101,7 +103,7 @@
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	dev = pci_find_slot(bus, dfn);
+	dev = pci_get_bus_and_slot(bus, dfn);
 	if (!dev)
 		return -ENODEV;
 
@@ -139,6 +141,6 @@
 		break;
 	};
 	unlock_kernel();
-
+	pci_dev_put(dev);
 	return err;
 }
