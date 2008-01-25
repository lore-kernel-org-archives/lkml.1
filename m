Return-Path: <linux-kernel-owner+w=401wt.eu-S1760714AbYAYHZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760714AbYAYHZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757361AbYAYHQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:16:04 -0500
Received: from ns2.suse.de ([195.135.220.15]:47518 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757463AbYAYHQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:16:01 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       =?utf-8?q?Max=20Asb=C3=B6ck?= <amax@us.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 033/196] kobject: convert ibmasm to use kref, not kobject
Date: Thu, 24 Jan 2008 23:09:31 -0800
Message-Id: <1201245134-4876-33-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IBM asm driver is using a kobject only for reference counting,
nothing else.  So switch it to use a kref instead, which is all that is
needed, and is much smaller.

Cc: Max Asböck <amax@us.ibm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/misc/ibmasm/command.c |   12 +++---------
 drivers/misc/ibmasm/ibmasm.h  |   10 ++++++----
 2 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/misc/ibmasm/command.c b/drivers/misc/ibmasm/command.c
index 6497872..1a0e797 100644
--- a/drivers/misc/ibmasm/command.c
+++ b/drivers/misc/ibmasm/command.c
@@ -26,11 +26,6 @@
 #include "lowlevel.h"
 
 static void exec_next_command(struct service_processor *sp);
-static void free_command(struct kobject *kobj);
-
-static struct kobj_type ibmasm_cmd_kobj_type = {
-	.release = free_command,
-};
 
 static atomic_t command_count = ATOMIC_INIT(0);
 
@@ -53,8 +48,7 @@ struct command *ibmasm_new_command(struct service_processor *sp, size_t buffer_s
 	}
 	cmd->buffer_size = buffer_size;
 
-	kobject_init(&cmd->kobj);
-	cmd->kobj.ktype = &ibmasm_cmd_kobj_type;
+	kref_init(&cmd->kref);
 	cmd->lock = &sp->lock;
 
 	cmd->status = IBMASM_CMD_PENDING;
@@ -67,9 +61,9 @@ struct command *ibmasm_new_command(struct service_processor *sp, size_t buffer_s
 	return cmd;
 }
 
-static void free_command(struct kobject *kobj)
+void ibmasm_free_command(struct kref *kref)
 {
-	struct command *cmd = to_command(kobj);
+	struct command *cmd = to_command(kref);
 
 	list_del(&cmd->queue_node);
 	atomic_dec(&command_count);
diff --git a/drivers/misc/ibmasm/ibmasm.h b/drivers/misc/ibmasm/ibmasm.h
index de860bc..4d8a4e2 100644
--- a/drivers/misc/ibmasm/ibmasm.h
+++ b/drivers/misc/ibmasm/ibmasm.h
@@ -31,6 +31,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
+#include <linux/kref.h>
 #include <linux/device.h>
 #include <linux/input.h>
 
@@ -92,24 +93,25 @@ struct command {
 	unsigned char		*buffer;
 	size_t			buffer_size;
 	int			status;
-	struct kobject		kobj;
+	struct kref		kref;
 	spinlock_t		*lock;
 };
-#define to_command(c) container_of(c, struct command, kobj)
+#define to_command(c) container_of(c, struct command, kref)
 
+void ibmasm_free_command(struct kref *kref);
 static inline void command_put(struct command *cmd)
 {
 	unsigned long flags;
 	spinlock_t *lock = cmd->lock;
 
 	spin_lock_irqsave(lock, flags);
-	kobject_put(&cmd->kobj);
+	kref_put(&cmd->kref, ibmasm_free_command);
 	spin_unlock_irqrestore(lock, flags);
 }
 
 static inline void command_get(struct command *cmd)
 {
-	kobject_get(&cmd->kobj);
+	kref_get(&cmd->kref);
 }
 
 
-- 
1.5.3.8

