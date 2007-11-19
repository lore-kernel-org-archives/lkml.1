Return-Path: <linux-kernel-owner+w=401wt.eu-S1753461AbXKSICj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbXKSICj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 03:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbXKSICa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 03:02:30 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:58472 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbXKSIC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 03:02:28 -0500
Date: Mon, 19 Nov 2007 09:02:22 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: davem@davemloft.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/5] arch/sparc64: Add missing pci_dev_put
Message-ID: <Pine.LNX.4.64.0711190901330.19198@ask.diku.dk>
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

diff -u -p a/arch/sparc64/kernel/isa.c b/arch/sparc64/kernel/isa.c
--- a/arch/sparc64/kernel/isa.c	2007-08-12 13:27:06.000000000 +0200
+++ b/arch/sparc64/kernel/isa.c	2007-11-19 08:06:48.000000000 +0100
@@ -155,6 +155,7 @@ void __init isa_init(void)
  		isa_br = kzalloc(sizeof(*isa_br), GFP_KERNEL);
  		if (!isa_br) {
  			printk(KERN_DEBUG "isa: cannot allocate sparc_isa_bridge");
+			pci_dev_put(pdev);
  			return;
  		}

@@ -168,6 +169,7 @@ void __init isa_init(void)
  			printk(KERN_DEBUG "isa: device registration error for %s!\n",
  			       dp->path_component_name);
  			kfree(isa_br);
+			pci_dev_put(pdev);
  			return;
  		}
