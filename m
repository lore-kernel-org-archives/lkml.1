Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933340Ab0BDXdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 18:33:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:3474 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933270Ab0BDXbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 18:31:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cxzEFaF0hnbvmyXYO+kkzafS64rgHMQqVYy84Eb5LlhNqdjAVm8FwhqRnKy1Lmv17N
         KMdqefZZJWT4QUaduSBMC3eBxtmrORkwGGchDKzmH6HufKOSDanZZL6LzUceU38a2KEP
         Foww7FR+I+n2ONuWT1UD/kMii7KYUuRB+Mh3U=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 12/17] MTD: nand: make suspend work if device is accessed by kernel threads.
Date: Fri,  5 Feb 2010 01:30:52 +0200
Message-Id: <1265326257-4446-13-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265326257-4446-1-git-send-email-maximlevitsky@gmail.com>
References: <1265326257-4446-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since all userspace threads are frozen at the time the nand_suspend is called,
they aren't inside any nand function.

We don't call try_to_freeze in nand ether. Thus the only user that can be insize
the nand functions is an non freezeable kernel thread.
Thus we can safely wait for it to finish.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/nand/nand_base.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 29e986e..961c98f 100644
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

