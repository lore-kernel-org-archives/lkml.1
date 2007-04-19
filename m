Return-Path: <linux-kernel-owner+w=401wt.eu-S1161175AbXDSIOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161175AbXDSIOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 04:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993175AbXDSINe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 04:13:34 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33950 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993201AbXDSINb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 04:13:31 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "<Andrew Morton" <akpm@osdl.org>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH] arm ecard: Conver to use the kthread API.
Date: Thu, 19 Apr 2007 01:58:43 -0600
Message-Id: <11769695722834-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.5.1.1.g2de0
In-Reply-To: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

This patch modifies the startup of kecardd to use
kthread_run not a kernel_thread combination of kernel_thread
and daemonize.  Making the code slightly simpler and more
maintainable.

Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/arm/kernel/ecard.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/kernel/ecard.c b/arch/arm/kernel/ecard.c
index f1c0fb9..6c15f5f 100644
--- a/arch/arm/kernel/ecard.c
+++ b/arch/arm/kernel/ecard.c
@@ -40,6 +40,7 @@
 #include <linux/device.h>
 #include <linux/init.h>
 #include <linux/mutex.h>
+#include <linux/kthread.h>
 
 #include <asm/dma.h>
 #include <asm/ecard.h>
@@ -263,8 +264,6 @@ static int ecard_init_mm(void)
 static int
 ecard_task(void * unused)
 {
-	daemonize("kecardd");
-
 	/*
 	 * Allocate a mm.  We're not a lazy-TLB kernel task since we need
 	 * to set page table entries where the user space would be.  Note
@@ -1058,13 +1057,14 @@ ecard_probe(int slot, card_type_t type)
  */
 static int __init ecard_init(void)
 {
-	int slot, irqhw, ret;
+	struct task_struct *task;
+	int slot, irqhw;
 
-	ret = kernel_thread(ecard_task, NULL, CLONE_KERNEL);
-	if (ret < 0) {
+	task = kthread_run(ecard_task, NULL, "kecardd");
+	if (IS_ERR(task)) {
 		printk(KERN_ERR "Ecard: unable to create kernel thread: %d\n",
-		       ret);
-		return ret;
+		       PTR_ERR(task));
+		return PTR_ERR(task);
 	}
 
 	printk("Probing expansion cards\n");
-- 
1.5.0.g53756

