Return-Path: <linux-kernel-owner+w=401wt.eu-S1752752AbYKWUpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbYKWUpR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 15:45:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbYKWUpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 15:45:05 -0500
Received: from smooth.piipiip.net ([194.100.76.170]:44463 "EHLO
	smooth.piipiip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbYKWUpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 15:45:04 -0500
Date: Sun, 23 Nov 2008 22:44:59 +0200
From: Jarkko Lavinen <jlavi@iki.fi>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net,
       Doug Thompson <dougthompson@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: i82875p_edac: BAR 0 collision
Message-ID: <20081123204459.GA11725@piipiip.net>
References: <20081107114355.GA31730@piipiip.net> <20081111000152.271d9706.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111000152.271d9706.akpm@linux-foundation.org>
X-Operating-System: Linux smooth.piipiip.net 2.6.18-5-k7
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: jlavi@piipiip.net
X-SA-Exim-Scanned: No (on smooth.piipiip.net); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 12:01:52AM -0800, Andrew Morton wrote:
> Might be an EDAC driver regression.  It might also be a consequence of
> PCI address space management fiddlings, but I think most of the changes
> there post-date 2.6.26?

There were 3 issues:
 1, PCI resources of the hidden overflow device had to be added separately
 2. In nodule exit there is one more mci struct kobject put than
     correspondig gets.
 3. The edac_mc waitqueue must be stopped before the polled memory
    area disappears.

Th attached patch fixes these problems. Module loads and removes now
without problems, with pci, edac, slab and kobject debug options
enabled.

i82875p code looks so simlar to i82875p that is has likely the same
ref count issues as i82875p.

Cheers
Jarkko Lavinen

>From 3abc62242a219d1466b32b59bb88b4c1b0e86a65 Mon Sep 17 00:00:00 2001
From: Jarkko Lavinen <jlavi@iki.fi>
Date: Sun, 23 Nov 2008 22:18:39 +0200
Subject: [PATCH] i82875p_edac: Fix module init and exit

The PCI resources of the hidden overflow device are missing after the overflow
device is revealed and resources must be added separately.

When exiting both edac_remove_sysfs_mci_device() in edac_mc_del_mc()
and edac_mc_free() in i82875p_remove_one() decrement the mci ref count.
Use an additional kobject_get() to keep mci valid edac_mc_del_mc() till the
final edac_mc_free().

Also i82875p_remove_one() should be called before pci_unregister_driver()
to stop the polling before the checked memory area disappearr.

Signed-off-by: Jarkko Lavinen <jlavi@iki.fi>
---
 drivers/edac/i82875p_edac.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/edac/i82875p_edac.c b/drivers/edac/i82875p_edac.c
index e43bdc4..ebb037b 100644
--- a/drivers/edac/i82875p_edac.c
+++ b/drivers/edac/i82875p_edac.c
@@ -182,8 +182,6 @@ static struct pci_dev *mci_pdev;	/* init dev: in case that AGP code has
 					 * already registered driver
 					 */
 
-static int i82875p_registered = 1;
-
 static struct edac_pci_ctl_info *i82875p_pci;
 
 static void i82875p_get_error_info(struct mem_ctl_info *mci,
@@ -295,6 +293,7 @@ static int i82875p_setup_overfl_dev(struct pci_dev *pdev,
 				"%s(): pci_bus_add_device() Failed\n",
 				__func__);
 		}
+		pci_bus_assign_resources(dev->bus);
 	}
 
 	*ovrfl_pdev = dev;
@@ -409,6 +408,9 @@ static int i82875p_probe1(struct pci_dev *pdev, int dev_idx)
 		goto fail0;
 	}
 
+	/* Keeps mci available after edac_mc_del_mc() till edac_mc_free() */
+	kobject_get(&mci->edac_mci_kobj);
+
 	debugf3("%s(): init mci\n", __func__);
 	mci->dev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_DDR;
@@ -451,6 +453,7 @@ static int i82875p_probe1(struct pci_dev *pdev, int dev_idx)
 	return 0;
 
 fail1:
+	kobject_put(&mci->edac_mci_kobj);
 	edac_mc_free(mci);
 
 fail0:
@@ -578,12 +581,11 @@ static void __exit i82875p_exit(void)
 {
 	debugf3("%s()\n", __func__);
 
+	i82875p_remove_one(mci_pdev);
+	pci_dev_put(mci_pdev);
+
 	pci_unregister_driver(&i82875p_driver);
 
-	if (!i82875p_registered) {
-		i82875p_remove_one(mci_pdev);
-		pci_dev_put(mci_pdev);
-	}
 }
 
 module_init(i82875p_init);
-- 
1.5.6.5

