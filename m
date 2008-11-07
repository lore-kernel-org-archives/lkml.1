Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbYKGTXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbYKGTXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 14:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbYKGTXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 14:23:40 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44103 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbYKGTXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 14:23:39 -0500
From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] i5000-edac: Hold reference to mci kobject
To: "Darrick J. Wong" <djwong@us.ibm.com>,
       Douglas Thompson <norsk5@xmission.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 07 Nov 2008 11:23:37 -0800
Message-ID: <20081107192337.13505.76764.stgit@elm3a70.beaverton.ibm.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It turns out that edac_mc_del_mc will kobject_put the last kref on the mci
object.  If the timing is just right, that means that the mci object is freed
before before i5000_remove_one has a chance to free the resources associated
with it, causing a null pointer exceptions when unloading the driver.  Insert
a kobject_{get,put} pair so that this doesn't happen.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/edac/i5000_edac.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index f0d9b41..d335086 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -1381,6 +1381,7 @@ static int i5000_probe1(struct pci_dev *pdev, int dev_idx)
 	if (mci == NULL)
 		return -ENOMEM;
 
+	kobject_get(&mci->edac_mci_kobj);
 	debugf0("MC: " __FILE__ ": %s(): mci = %p\n", __func__, mci);
 
 	mci->dev = &pdev->dev;	/* record ptr  to the generic device */
@@ -1453,6 +1454,7 @@ fail1:
 	i5000_put_devices(mci);
 
 fail0:
+	kobject_put(&mci->edac_mci_kobj);
 	edac_mc_free(mci);
 	return -ENODEV;
 }
@@ -1498,7 +1500,7 @@ static void __devexit i5000_remove_one(struct pci_dev *pdev)
 
 	/* retrieve references to resources, and free those resources */
 	i5000_put_devices(mci);
-
+	kobject_put(&mci->edac_mci_kobj);
 	edac_mc_free(mci);
 }
 

