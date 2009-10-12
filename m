Return-Path: <linux-kernel-owner+w=401wt.eu-S1757234AbZJLPfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234AbZJLPfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756345AbZJLPfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:35:06 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:15457 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757214AbZJLPe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:34:56 -0400
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH] cciss: Fix multiple calls to pci_release_regions
To: akpm@linux-foundation.org, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com,
       scameron@beardog.cce.hp.com
Date: Mon, 12 Oct 2009 10:35:10 -0500
Message-ID: <20091012153427.4315.49876.stgit@beardog.cce.hp.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix multiple calls to pci_release_regions.  If cciss_pci_init
fails, it already does any necessary call to pci_release_regions,
so this does not need to be done again in cciss_init_one in that
case.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/block/cciss.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index fb5be2d..52f53c1 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4254,7 +4254,7 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	mutex_init(&hba[i]->busy_shutting_down);
 
 	if (cciss_pci_init(hba[i], pdev) != 0)
-		goto clean0;
+		goto clean_no_release_regions;
 
 	sprintf(hba[i]->devname, "cciss%d", i);
 	hba[i]->ctlr = i;
@@ -4391,13 +4391,14 @@ clean2:
 clean1:
 	cciss_destroy_hba_sysfs_entry(hba[i]);
 clean0:
+	pci_release_regions(pdev);
+clean_no_release_regions:
 	hba[i]->busy_initializing = 0;
 
 	/*
 	 * Deliberately omit pci_disable_device(): it does something nasty to
 	 * Smart Array controllers that pci_enable_device does not undo
 	 */
-	pci_release_regions(pdev);
 	pci_set_drvdata(pdev, NULL);
 	free_hba(i);
 	return -1;

