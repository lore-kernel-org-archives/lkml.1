Return-Path: <linux-kernel-owner+w=401wt.eu-S1758472AbZKRUcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472AbZKRUcp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 15:32:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756013AbZKRUco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 15:32:44 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:24052 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122AbZKRUco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 15:32:44 -0500
Subject: [PATCH] cciss: fix scatter gather cleanup problems
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, linux-kernel@vger.kernel.org,
       brace@beardog.cce.hp.com
Date: Wed, 18 Nov 2009 14:34:18 -0600
Message-ID: <20091118203418.8353.83196.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: fix scatter gather cleanup problems
On driver unload, only free up the extra scatter gather data
if they were allocated in the first place (the controller
supports it) and don't forget to free up the sg_cmd_list
array of pointers.

Signed-off-by: Don Brace <brace@beardog.cce.hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   25 ++++++++++++++++++-------
 1 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index eab81c6..873e594 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4326,10 +4326,15 @@ clean4:
 	for (k = 0; k < hba[i]->nr_cmds; k++)
 		kfree(hba[i]->scatter_list[k]);
 	kfree(hba[i]->scatter_list);
-	for (j = 0; j < hba[i]->nr_cmds; j++) {
-		if (hba[i]->cmd_sg_list[j])
-			kfree(hba[i]->cmd_sg_list[j]->sgchain);
-		kfree(hba[i]->cmd_sg_list[j]);
+	/* Only free up extra s/g lists if controller supports them */
+	if (hba[i]->chainsize > 0) {
+		for (j = 0; j < hba[i]->nr_cmds; j++) {
+			if (hba[i]->cmd_sg_list[j]) {
+				kfree(hba[i]->cmd_sg_list[j]->sgchain);
+				kfree(hba[i]->cmd_sg_list[j]);
+			}
+		}
+		kfree(hba[i]->cmd_sg_list);
 	}
 	if (hba[i]->cmd_pool)
 		pci_free_consistent(hba[i]->pdev,
@@ -4448,9 +4453,15 @@ static void __devexit cciss_remove_one(struct pci_dev *pdev)
 	for (j = 0; j < hba[i]->nr_cmds; j++)
 		kfree(hba[i]->scatter_list[j]);
 	kfree(hba[i]->scatter_list);
-	for (j = 0; j < hba[i]->nr_cmds; j++) {
-		kfree(hba[i]->cmd_sg_list[j]->sgchain);
-		kfree(hba[i]->cmd_sg_list[j]);
+	/* Only free up extra s/g lists if controller supports them */
+	if (hba[i]->chainsize > 0) {
+		for (j = 0; j < hba[i]->nr_cmds; j++) {
+			if (hba[i]->cmd_sg_list[j]) {
+				kfree(hba[i]->cmd_sg_list[j]->sgchain);
+				kfree(hba[i]->cmd_sg_list[j]);
+			}
+		}
+		kfree(hba[i]->cmd_sg_list);
 	}
 	/*
 	 * Deliberately omit pci_disable_device(): it does something nasty to

