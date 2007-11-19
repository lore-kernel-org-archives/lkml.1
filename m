Return-Path: <linux-kernel-owner+w=401wt.eu-S1754451AbXKSIFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbXKSIFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 03:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbXKSIFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 03:05:13 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:44618 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755AbXKSIFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 03:05:11 -0500
Date: Mon, 19 Nov 2007 09:05:08 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 3/5] drivers/pci/pci-sysfs.c: Add missing pci_dev_put
Message-ID: <Pine.LNX.4.64.0711190903550.19198@ask.diku.dk>
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

diff -u -p a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
--- a/drivers/pci/pci-sysfs.c   2007-07-20 17:45:56.000000000 +0200
+++ b/drivers/pci/pci-sysfs.c   2007-11-19 08:17:43.000000000 +0100
@@ -702,8 +702,10 @@ static int __init pci_sysfs_init(void)
         sysfs_initialized = 1;
         for_each_pci_dev(pdev) {
                 retval = pci_create_sysfs_dev_files(pdev);
-               if (retval)
+               if (retval) {
+                       pci_dev_put(pdev);
                         return retval;
+               }
         }

         return 0;
