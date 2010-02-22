Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab0BVSkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:40:08 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:56979 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab0BVSkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:40:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xeHtkh9+fB32g3eKjd31EBRSH92Mj6sqBc5Nb7huJ88Yn+HX+Ubrh90zJ6hfUoPouE
         09r+oOUt+1+f5SWP2GbHmfjsClE6/U+v9d6gV9rLprgC4TKsNfMFg45PGnqElkhk8NhM
         BhMXLMzhbDARnw3XdNCIhk2Vd0GlHSQXtQE/o=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>, <stanley.miao@windriver.com>,
       Vitaly Wool <vitalywool@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 04/15] MTD: mtdblock: test return value of add_mtd_blktrans_dev, because if can fail
Date: Mon, 22 Feb 2010 20:39:31 +0200
Message-Id: <1266863982-5258-5-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1266863982-5258-1-git-send-email-maximlevitsky@gmail.com>
References: <1266863982-5258-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This prevents a memory leak

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/mtdblock.c    |    3 ++-
 drivers/mtd/mtdblock_ro.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/mtdblock.c b/drivers/mtd/mtdblock.c
index 8e5da1e..7ce30a2 100644
--- a/drivers/mtd/mtdblock.c
+++ b/drivers/mtd/mtdblock.c
@@ -348,7 +348,8 @@ static void mtdblock_add_mtd(struct mtd_blktrans_ops *tr, struct mtd_info *mtd)
 	if (!(mtd->flags & MTD_WRITEABLE))
 		dev->mbd.readonly = 1;
 
-	add_mtd_blktrans_dev(&dev->mbd);
+	if (add_mtd_blktrans_dev(&dev->mbd))
+		kfree(dev);
 }
 
 static void mtdblock_remove_dev(struct mtd_blktrans_dev *dev)
diff --git a/drivers/mtd/mtdblock_ro.c b/drivers/mtd/mtdblock_ro.c
index 54ff288..d0d3f79 100644
--- a/drivers/mtd/mtdblock_ro.c
+++ b/drivers/mtd/mtdblock_ro.c
@@ -43,7 +43,8 @@ static void mtdblock_add_mtd(struct mtd_blktrans_ops *tr, struct mtd_info *mtd)
 	dev->tr = tr;
 	dev->readonly = 1;
 
-	add_mtd_blktrans_dev(dev);
+	if (add_mtd_blktrans_dev(dev))
+		kfree(dev);
 }
 
 static void mtdblock_remove_dev(struct mtd_blktrans_dev *dev)
-- 
1.6.3.3

