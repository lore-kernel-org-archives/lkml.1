Return-Path: <linux-kernel-owner+w=401wt.eu-S1759018AbZLJNX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018AbZLJNX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 08:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758659AbZLJNXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 08:23:55 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:56291 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbZLJNXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 08:23:55 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, jirislaby@gmail.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] MTD: cfi chip, fix lock imbalance
Date: Thu, 10 Dec 2009 14:23:57 +0100
Message-Id: <1260451437-29645-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found a double unlock in get_chip. get_chip is called with
chip->mutex held and caller is responsible for unlocking it too.

Do not unlock the lock in get_chip on a fail path. This would mean
a double unlock.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mtd/chips/cfi_cmdset_0002.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index 1d49e18..f3600e8 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -569,7 +569,6 @@ static int get_chip(struct map_info *map, struct flchip *chip, unsigned long adr
 
 			if (time_after(jiffies, timeo)) {
 				printk(KERN_ERR "Waiting for chip to be ready timed out.\n");
-				spin_unlock(chip->mutex);
 				return -EIO;
 			}
 			spin_unlock(chip->mutex);
-- 
1.6.5.5

