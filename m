Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbXKSIHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbXKSIHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 03:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbXKSIH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 03:07:26 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:44833 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbXKSIHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 03:07:25 -0500
Date: Mon, 19 Nov 2007 09:07:22 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: ambx1@neo.rr.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 4/5] drivers/pnp/resource.c: Add missing pci_dev_put
Message-ID: <Pine.LNX.4.64.0711190905100.19198@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

There should be a pci_dev_put when breaking out of a loop that iterates
over calls to pci_get_device and similar functions.

This was fixed using the following semantic patch.

// <smpl>
@@
identifier d;
type T;
expression e;
iterator for_each_pci_dev;
@@

T *d;
...
for_each_pci_dev(d)
   {... when != pci_dev_put(d)
        when != e = d
(
    return d;
|
+  pci_dev_put(d);
?  return ...;
)
...}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p a/drivers/pnp/resource.c b/drivers/pnp/resource.c
--- a/drivers/pnp/resource.c    2007-10-22 11:25:20.000000000 +0200
+++ b/drivers/pnp/resource.c    2007-11-19 08:18:44.000000000 +0100
@@ -367,8 +367,10 @@ int pnp_check_irq(struct pnp_dev *dev, i
         {
                 struct pci_dev *pci = NULL;
                 for_each_pci_dev(pci) {
-                       if (pci->irq == *irq)
+                       if (pci->irq == *irq) {
+                               pci_dev_put(pci);
                                 return 0;
+                       }
                 }
         }
  #endif
