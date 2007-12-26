Return-Path: <linux-kernel-owner+w=401wt.eu-S1752920AbXLZUZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbXLZUZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 15:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbXLZUZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 15:25:07 -0500
Received: from www.miniblade.com ([65.14.39.133]:29778 "EHLO coraid.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752754AbXLZUZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 15:25:06 -0500
From: "Ed L. Cashin" <ecashin@coraid.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Ed L. Cashin" <ecashin@coraid.com>
Subject: [PATCH] aoe: initialize locking structures before registering char devices
Date: Wed, 26 Dec 2007 15:25:21 -0500
Message-Id: <1198700721-14521-1-git-send-email-ecashin@coraid.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071221220040.5862b43b.akpm@linux-foundation.org>
References: <20071221220040.5862b43b.akpm@linux-foundation.org>
In-Reply-To: <20071221220040.5862b43b.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch was made against 2.6.24-rc6-mm1.

In March 2007, Alexey Dobriyan suggested this change, which
eliminates a race after register_chardev has been called but
the locking primitives protecting the error messages ring
buffer have not yet been initialized.

The initialization could happen at compile time, but that
would leave aoe as the only user of __DECLARE_SEMAPHORE_GENERIC.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoechr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/aoe/aoechr.c b/drivers/block/aoe/aoechr.c
index e8e60e7..2620073 100644
--- a/drivers/block/aoe/aoechr.c
+++ b/drivers/block/aoe/aoechr.c
@@ -259,13 +259,13 @@ aoechr_init(void)
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
1.5.3.4

