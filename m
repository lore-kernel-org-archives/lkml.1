Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab0BMNGG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 08:06:06 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:49010 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab0BMNDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 08:03:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XbXOsMTBOa8UBmLXHiOK7t/BVe1Q933DeR+9lxkDDPdr2/jvvhvbdk+dQjCq47+eRC
         VP5H7XjZ3Zd21wHFPP/2D0qdGQCIdXNjmWJEcXIs6/90HBhVPG0TkdG6v1j5d3Fmcr/X
         iTFRa9EQ2q55uvUGNHiDfzH/0BdTbtmVpWTVM=
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
Date: Sat, 13 Feb 2010 15:03:05 +0200
Message-Id: <1266066193-17625-7-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1266066193-17625-1-git-send-email-maximlevitsky@gmail.com>
References: <1266066193-17625-1-git-send-email-maximlevitsky@gmail.com>
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

