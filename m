Return-Path: <linux-kernel-owner+w=401wt.eu-S1754297AbXLGRwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbXLGRwr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 12:52:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756425AbXLGRuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 12:50:22 -0500
Received: from baron.coraid.com ([65.14.39.133]:21121 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756382AbXLGRuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 12:50:20 -0500
From: "Ed L. Cashin" <ecashin@coraid.com>
To: linux-kernel@vger.kernel.org
Cc: "Ed L. Cashin" <ecashin@coraid.com>, Greg KH <greg@kroah.com>
Subject: [PATCH 09/13] remove race between use and initialization of locks
Date: Fri,  7 Dec 2007 12:48:07 -0500
Message-Id: <1197049691-27462-9-git-send-email-ecashin@coraid.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1197049691-27462-1-git-send-email-ecashin@coraid.com>
References: <1197049691-27462-1-git-send-email-ecashin@coraid.com>
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
index 166f54f..0ce9bda 100644
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

