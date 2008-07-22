Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbYGVFY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbYGVFY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbYGVFWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:22:05 -0400
Received: from ns.suse.de ([195.135.220.2]:53710 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbYGVFWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:22:04 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/79] device create: dca: convert device_create to device_create_drvdata
Date: Mon, 21 Jul 2008 22:18:32 -0700
Message-Id: <1216703983-21448-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_create() is race-prone, so use the race-free
device_create_drvdata() instead as device_create() is going away.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/dca/dca-sysfs.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/dca/dca-sysfs.c b/drivers/dca/dca-sysfs.c
index 011328f..9a70377 100644
--- a/drivers/dca/dca-sysfs.c
+++ b/drivers/dca/dca-sysfs.c
@@ -14,8 +14,9 @@ int dca_sysfs_add_req(struct dca_provider *dca, struct device *dev, int slot)
 {
 	struct device *cd;
 
-	cd = device_create(dca_class, dca->cd, MKDEV(0, slot + 1),
-			   "requester%d", slot);
+	cd = device_create_drvdata(dca_class, dca->cd,
+				   MKDEV(0, slot + 1), NULL,
+				   "requester%d", slot);
 	if (IS_ERR(cd))
 		return PTR_ERR(cd);
 	return 0;
@@ -46,7 +47,8 @@ idr_try_again:
 		return err;
 	}
 
-	cd = device_create(dca_class, dev, MKDEV(0, 0), "dca%d", dca->id);
+	cd = device_create_drvdata(dca_class, dev, MKDEV(0, 0), NULL,
+				   "dca%d", dca->id);
 	if (IS_ERR(cd)) {
 		spin_lock(&dca_idr_lock);
 		idr_remove(&dca_idr, dca->id);
-- 
1.5.6.3

