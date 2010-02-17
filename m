Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab0BQVwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 16:52:18 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:6987 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757449Ab0BQVtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 16:49:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=D8Ha7FBk+4zt36gpXzOnH6SFU9dttytNJYWJnofOQ3tk02GxE8FYig5i7ipEe5cAHt
         HqHSp+27Kav4aXvpapn/TOCcB7q593dGXBA3XXyAGOvAXVlVlX5EE0LGEuU2DV7jj4ws
         vi/HRD9a4FcoN8fdei5FjQDbxZjqrr+zXOZq0=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "stanley.miao" <stanley.miao@windriver.com>,
       Vitaly Wool <vitalywool@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 06/14] MTD: nand: make suspend work if device is accessed by kernel threads.
Date: Wed, 17 Feb 2010 23:49:16 +0200
Message-Id: <1266443364-4538-7-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1266443364-4538-1-git-send-email-maximlevitsky@gmail.com>
References: <1266443364-4538-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since all userspace threads are frozen at the time the nand_suspend is called,
they aren't inside any nand function.

We don't call try_to_freeze in nand ether. Thus the only user that can be inside
the nand functions is an non freezeable kernel thread.
Thus we can safely wait for it to finish.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/nand/nand_base.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 8f2958f..279b960 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -744,9 +744,6 @@ nand_get_device(struct nand_chip *chip, struct mtd_info *mtd, int new_state)
 			chip->state = FL_PM_SUSPENDED;
 			spin_unlock(lock);
 			return 0;
-		} else {
-			spin_unlock(lock);
-			return -EAGAIN;
 		}
 	}
 	set_current_state(TASK_UNINTERRUPTIBLE);
-- 
1.6.3.3

