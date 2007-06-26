Return-Path: <linux-kernel-owner+w=401wt.eu-S1759888AbXFZTHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759888AbXFZTHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 15:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759556AbXFZTFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 15:05:49 -0400
Received: from ns1.coraid.com ([65.14.39.133]:25149 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759541AbXFZTFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 15:05:48 -0400
Message-Id: <2823ea0d22cb0a4aea5a5c22bb8e6b63b2b07441.1182883861.git.ecashin@coraid.com>
In-Reply-To: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com>
References: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com>
From: "Ed L. Cashin" <ecashin@coraid.com>
Date: Tue, 26 Jun 2007 14:50:12 -0400
Subject: [PATCH 09/12] remove race between use and initialization of locks
To: linux-kernel@vger.kernel.org
Cc: Greg K-H <greg@kroah.com>, ecashin@coraid.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This change was originally submitted by Alexey Dobriyan in an email
with ...

  Message-ID: <20070325190221.GA5308@martell.zuzino.mipt.ru>

and the comment,

  Some drivers do register_chrdev() before lock or semaphore used in
  corresponding file_operations is initialized.

Andrew Morton commented that these locks should be initialized at
compile time, but Alexey Debriyan pointed out that the Documentation
tells us to use dynamic initialization whenever possible, and then the
discussion petered out.

  http://preview.tinyurl.com/2pxq6p

I believe we made these locks dynamic because of the notice in
Documentation/spinlocks.txt, which says that static initializers are
deprecated:

  UPDATE March 21 2005 Amit Gud <gud@eth.net>

  Macros SPIN_LOCK_UNLOCKED and RW_LOCK_UNLOCKED are deprecated and will be
  removed soon. So for any new code dynamic initialization should be used:
...

In any case, the patch below makes the code correct and in keeping
with the existing documentation.  If the existing docs are wrong, I'd
be happy to follow up with a patch that corrects them and makes these
aoechr.c locks static.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoechr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/aoe/aoechr.c b/drivers/block/aoe/aoechr.c
index 10b38a7..2b4f873 100644
--- a/drivers/block/aoe/aoechr.c
+++ b/drivers/block/aoe/aoechr.c
@@ -256,13 +256,13 @@ aoechr_init(void)
 {
 	int n, i;
 
+	sema_init(&emsgs_sema, 0);
+	spin_lock_init(&emsgs_lock);
 	n = register_chrdev(AOE_MAJOR, "aoechr", &aoe_fops);
 	if (n < 0) { 
 		printk(KERN_ERR "aoe: can't register char device\n");
 		return n;
 	}
-	sema_init(&emsgs_sema, 0);
-	spin_lock_init(&emsgs_lock);
 	aoe_class = class_create(THIS_MODULE, "aoe");
 	if (IS_ERR(aoe_class)) {
 		unregister_chrdev(AOE_MAJOR, "aoechr");
-- 
1.5.2.1

