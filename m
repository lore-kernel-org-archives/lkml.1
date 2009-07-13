Return-Path: <linux-kernel-owner+w=401wt.eu-S1757472AbZGMV2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbZGMV2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757322AbZGMV2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:28:06 -0400
Received: from server1.wserver.cz ([82.113.45.157]:50005 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204AbZGMV2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:28:05 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] MTD: sst25l, fix lock imbalance
Date: Mon, 13 Jul 2009 23:22:04 +0200
Message-Id: <1247520124-31875-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an omitted unlock to one sst25l_erase fail path.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/mtd/devices/sst25l.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/devices/sst25l.c b/drivers/mtd/devices/sst25l.c
index 1648685..5022ab2 100644
--- a/drivers/mtd/devices/sst25l.c
+++ b/drivers/mtd/devices/sst25l.c
@@ -180,8 +180,10 @@ static int sst25l_erase(struct mtd_info *mtd, struct erase_info *instr)
 	mutex_lock(&flash->lock);
 
 	err = sst25l_wait_till_ready(flash);
-	if (err)
+	if (err) {
+		mutex_unlock(&flash->lock);
 		return err;
+	}
 
 	while (addr < end) {
 		err = sst25l_erase_sector(flash, addr);
-- 
1.6.3.2

