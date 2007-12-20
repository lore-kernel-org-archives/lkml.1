Return-Path: <linux-kernel-owner+w=401wt.eu-S1759517AbXLTWTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517AbXLTWTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759346AbXLTWQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:16:36 -0500
Received: from baron.coile-labs.com ([65.14.39.133]:28914 "EHLO coraid.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762348AbXLTWQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:16:34 -0500
From: "Ed L. Cashin" <ecashin@coraid.com>
To: linux-kernel@vger.kernel.org
Cc: "Ed L. Cashin" <ecashin@coraid.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 09/13] remove race between use and initialization of locks
Date: Thu, 20 Dec 2007 17:15:57 -0500
Message-Id: <1198188961-25147-9-git-send-email-ecashin@coraid.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1198188961-25147-1-git-send-email-ecashin@coraid.com>
References: <1198188961-25147-1-git-send-email-ecashin@coraid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan noticed a race in the initialization of the dynamic
locks in ...

  Message-ID: <20070325190221.GA5308@martell.zuzino.mipt.ru>

Andrew Morton commented that these locks should be initialized at
compile time, so this patch does that.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoechr.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/block/aoe/aoechr.c b/drivers/block/aoe/aoechr.c
index 1bc85aa..670bba6 100644
--- a/drivers/block/aoe/aoechr.c
+++ b/drivers/block/aoe/aoechr.c
@@ -35,8 +35,8 @@ struct ErrMsg {
 
 static struct ErrMsg emsgs[NMSG];
 static int emsgs_head_idx, emsgs_tail_idx;
-static struct semaphore emsgs_sema;
-static spinlock_t emsgs_lock;
+static __DECLARE_SEMAPHORE_GENERIC(emsgs_sema, 0);
+static DEFINE_SPINLOCK(emsgs_lock);
 static int nblocked_emsgs_readers;
 static struct class *aoe_class;
 static struct aoe_chardev chardevs[] = {
@@ -264,8 +264,6 @@ aoechr_init(void)
 		printk(KERN_ERR "aoe: can't register char device\n");
 		return n;
 	}
-	sema_init(&emsgs_sema, 0);
-	spin_lock_init(&emsgs_lock);
 	aoe_class = class_create(THIS_MODULE, "aoe");
 	if (IS_ERR(aoe_class)) {
 		unregister_chrdev(AOE_MAJOR, "aoechr");
-- 
1.5.3.4

