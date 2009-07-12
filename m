Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbZGLWqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbZGLWqw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 18:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbZGLWqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 18:46:32 -0400
Received: from kroah.org ([198.145.64.141]:33493 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475AbZGLWqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 18:46:31 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/9] partitions: fix broken uevent_suppress conversion
Date: Sun, 12 Jul 2009 15:45:59 -0700
Message-Id: <1247438766-17266-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090712223717.GB16600@kroah.com>
References: <20090712223717.GB16600@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

git commit f67f129e "Driver core: implement uevent suppress in kobject"
contains this chunk for fs/partitions/check.c:

 	/* suppress uevent if the disk supresses it */
-	if (!ddev->uevent_suppress)
+	if (!dev_get_uevent_suppress(pdev))
 		kobject_uevent(&pdev->kobj, KOBJ_ADD);

However that should have been

-	if (!ddev->uevent_suppress)
+	if (!dev_get_uevent_suppress(ddev))

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Ming Lei <tom.leiming@gmail.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/partitions/check.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 1a9c787..ea4e6cb 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -436,7 +436,7 @@ struct hd_struct *add_partition(struct gendisk *disk, int partno,
 	rcu_assign_pointer(ptbl->part[partno], p);
 
 	/* suppress uevent if the disk supresses it */
-	if (!dev_get_uevent_suppress(pdev))
+	if (!dev_get_uevent_suppress(ddev))
 		kobject_uevent(&pdev->kobj, KOBJ_ADD);
 
 	return p;
-- 
1.6.3.2

