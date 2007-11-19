Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbXKSIIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbXKSIIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 03:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbXKSIIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 03:08:44 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:46425 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbXKSIIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 03:08:43 -0500
Date: Mon, 19 Nov 2007 09:08:40 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: perex@suse.cz, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 5/5] sound/core/memalloc.c: Add missing pci_dev_put
Message-ID: <Pine.LNX.4.64.0711190907230.19198@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

There should be a pci_dev_put when breaking out of a loop that iterates
over calls to pci_get_device and similar functions.

In this case, the return under the initial if needs a pci_dev_put in the
same way that the return under the subsequent for loop has a pci_dev_put.

This was fixed using the following semantic patch.

// <smpl>
@@
type T;
identifier d;
expression e;
@@

T *d;
...
while ((d = \(pci_get_device\|pci_get_device_reverse\|pci_get_subsys\|pci_get_class\)(..., d)) != NULL)
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

diff -u -p a/sound/core/memalloc.c b/sound/core/memalloc.c
--- a/sound/core/memalloc.c	2007-10-22 11:25:51.000000000 +0200
+++ b/sound/core/memalloc.c	2007-11-19 08:08:08.000000000 +0100
@@ -568,6 +568,7 @@ static ssize_t snd_mem_proc_write(struct
  				if (pci_set_dma_mask(pci, mask) < 0 ||
  				    pci_set_consistent_dma_mask(pci, mask) < 0) {
  					printk(KERN_ERR "snd-page-alloc: cannot set DMA mask %lx for pci %04x:%04x\n", mask, vendor, device);
+					pci_dev_put(pci);
  					return count;
  				}
  			}
