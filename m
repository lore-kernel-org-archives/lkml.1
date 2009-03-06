Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbZCFDa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbZCFDa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 22:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbZCFDaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 22:30:14 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:23483 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbZCFDaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 22:30:13 -0500
X-IronPort-AV: E=Sophos;i="4.38,312,1233550800"; 
   d="scan'208";a="83876970"
From: Bryan Wu <cooloney@kernel.org>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Graf Yang <graf.yang@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH] mtd: CFI: fix bug - bonnie++ error on BF548 NOR flash
Date: Fri,  6 Mar 2009 11:32:18 +0800
Message-Id: <1236310338-24256-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

The function inval_cache_and_wait_for_operation() is called both
by write and erase operation. If erase call it and stayed there, then write
call it and male-cleared chip->erase_suspended, the time out error may arise.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/mtd/chips/cfi_cmdset_0001.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0001.c b/drivers/mtd/chips/cfi_cmdset_0001.c
index f5ab6fa..c151075 100644
--- a/drivers/mtd/chips/cfi_cmdset_0001.c
+++ b/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -1236,10 +1236,14 @@ static int inval_cache_and_wait_for_operation(
 			remove_wait_queue(&chip->wq, &wait);
 			spin_lock(chip->mutex);
 		}
-		if (chip->erase_suspended || chip->write_suspended)  {
-			/* Suspend has occured while sleep: reset timeout */
+		if (chip->erase_suspended && chip_state == FL_ERASING)  {
+			/* Erase suspend has occured while sleep: reset timeout */
 			timeo = reset_timeo;
 			chip->erase_suspended = 0;
+		}
+		if (chip->write_suspended && chip_state == FL_WRITING)  {
+			/* Write suspend has occured while sleep: reset timeout */
+			timeo = reset_timeo;
 			chip->write_suspended = 0;
 		}
 	}
-- 
1.5.6.3
