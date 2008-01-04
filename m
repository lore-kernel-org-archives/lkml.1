Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbYADOqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbYADOqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 09:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbYADOqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 09:46:33 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:37178 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbYADOqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 09:46:32 -0500
Date: Fri, 4 Jan 2008 15:46:19 +0100 (MET)
From: Julia Lawall <julia@diku.dk>
To: adaplas@gmail.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/video: Add missing pci_dev_get
Message-ID: <Pine.LNX.4.58.0801041545340.1184@pc-041.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

pci_get_device does a pci_dev_get, so pci_dev_put needs to be called in an
error case

The problem was fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@exists@
type T1,T2;
identifier E;
statement S,S1;
expression x1,x2,x3;
expression test;
int ret != 0;
@@

  struct pci_dev *E;
  ...
(
  E = \(pci_get_slot\|pci_get_device\|pci_get_bus_and_slot\)(...);
  if (E == NULL) S
|
  if ((E = \(pci_get_slot\|pci_get_device\|pci_get_bus_and_slot\)(...)) == NULL) S
)
  ... when != pci_dev_put(...,(T1)E,...)
      when != if (E != NULL) { ... pci_dev_put(...,(T1)E,...); ...}
      when != x1 = (T1)E
      when != E = x3;
      when any
(
  if (E == NULL) S1
|
  if (test)
+   {
(
+   pci_dev_put(E);
    return;
|
+   pci_dev_put(E);
    return ret;
)
+   }
|
  if (test) {
    ... when != pci_dev_put(...,(T2)E,...)
        when != if (E != NULL) { ... pci_dev_put(...,(T2)E,...); ...}
        when != x2 = (T2)E
(
+   pci_dev_put(E);
    return;
|
+   pci_dev_put(E);
    return ret;
)
  }
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p a/drivers/video/igafb.c b/drivers/video/igafb.c
--- a/drivers/video/igafb.c 2007-07-23 11:27:17.000000000 +0200
+++ b/drivers/video/igafb.c 2008-01-04 14:01:30.000000000 +0100
@@ -400,6 +400,7 @@ int __init igafb_init(void)
         info = kzalloc(size, GFP_ATOMIC);
         if (!info) {
                 printk("igafb_init: can't alloc fb_info\n");
+		 pci_dev_put(pdev);
                 return -ENOMEM;
         }

@@ -409,12 +410,14 @@ int __init igafb_init(void)
 	if ((addr = pdev->resource[0].start) == 0) {
                 printk("igafb_init: no memory start\n");
 		kfree(info);
+		pci_dev_put(pdev);
 		return -ENXIO;
 	}

 	if ((info->screen_base = ioremap(addr, 1024*1024*2)) == 0) {
                 printk("igafb_init: can't remap %lx[2M]\n", addr);
 		kfree(info);
+		pci_dev_put(pdev);
 		return -ENXIO;
 	}

@@ -449,6 +452,7 @@ int __init igafb_init(void)
                 printk("igafb_init: can't remap %lx[4K]\n", igafb_fix.mmio_start);
 		iounmap((void *)info->screen_base);
 		kfree(info);
+		pci_dev_put(pdev);
 		return -ENXIO;
 	}

@@ -466,6 +470,7 @@ int __init igafb_init(void)
 		iounmap((void *)par->io_base);
 		iounmap(info->screen_base);
 		kfree(info);
+		pci_dev_put(pdev);
 		return -ENOMEM;
 	}

