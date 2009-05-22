Return-Path: <linux-kernel-owner+w=401wt.eu-S1757799AbZEVFBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799AbZEVFBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 01:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754618AbZEVE4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 00:56:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:33823 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445AbZEVE4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 00:56:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=j5V9eR6PXy/2ep1jOUwsbMyJ0Zw7mb7xU/g8vgHJ8gxmiEcV37n6rf9LBP8N5cWCGG
         Myg7vs1kYaaaTWF8p3LO8ecEibHQtmUwxV26oj12rtawx+d3aqUYEXYPdmLDq0isK+r6
         IDaQZ3tWUgBxJxMrwtqMbrkfQohEpv0pNKRuc=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       torvalds@linux-foundation.org, xemul@parallels.com,
       orenl@cs.columbia.edu, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 22/38] C/R: i386 xstate
Date: Fri, 22 May 2009 08:55:16 +0400
Message-Id: <1242968132-1044-22-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only check is if xstate length doesn't match.
This is insufficient, but posted anyway, because glibc manages
to do FP calculations and create xstate which would prevent
checkpointing.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 include/linux/kstate-image.h  |    3 ++
 kernel/kstate/kstate-x86_32.c |   44 ++++++++++++++++++++++++++++++++++++----
 2 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/include/linux/kstate-image.h b/include/linux/kstate-image.h
index 6f11b4d..3c93432 100644
--- a/include/linux/kstate-image.h
+++ b/include/linux/kstate-image.h
@@ -105,6 +105,9 @@ struct kstate_image_task_struct_i386 {
 	__u32		dr7;
 
 	__u64		tls_array[3];
+
+	__u32		len_xstate;
+	/* __u8	xstate[len_xstate]; */
 } __packed;
 
 struct kstate_image_mm_struct {
diff --git a/kernel/kstate/kstate-x86_32.c b/kernel/kstate/kstate-x86_32.c
index c738e16..d5c162b 100644
--- a/kernel/kstate/kstate-x86_32.c
+++ b/kernel/kstate/kstate-x86_32.c
@@ -1,5 +1,6 @@
 /* Copyright (C) 2000-2009 Parallels Holdings, Ltd. */
 #include <linux/sched.h>
+#include <asm/i387.h>
 
 #include <linux/kstate.h>
 #include <linux/kstate-image.h>
@@ -74,12 +75,16 @@ static int check_tls(struct desc_struct *desc)
 int kstate_arch_check_image_task_struct(struct kstate_image_task_struct *tsk_i)
 {
 	struct kstate_image_task_struct_i386 *i = (void *)(tsk_i + 1);
+	unsigned int len_xstate;
 	int rv;
 
 	if (tsk_i->tsk_arch != KSTATE_ARCH_I386)
 		return -EINVAL;
 	if (tsk_i->hdr.obj_len < sizeof(*tsk_i) + sizeof(*i))
 		return -EINVAL;
+	len_xstate = i->len_xstate;
+	if (tsk_i->hdr.obj_len - sizeof(*tsk_i) - sizeof(*i) < len_xstate)
+		return -EINVAL;
 
 	rv = check_eflags(i->eflags);
 	if (rv < 0)
@@ -126,22 +131,28 @@ int kstate_arch_check_image_task_struct(struct kstate_image_task_struct *tsk_i)
 			return rv;
 	}
 
+	if (len_xstate > 0 && len_xstate != xstate_size) {
+		WARN(1, "xstate size mismatch %u:%u\n", len_xstate, xstate_size);
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
 unsigned int kstate_arch_len_task_struct(struct task_struct *tsk)
 {
-	return sizeof(struct kstate_image_task_struct_i386);
+	unsigned int len;
+
+	len = sizeof(struct kstate_image_task_struct_i386);
+	if (tsk->thread.xstate)
+		len += xstate_size;
+	return len;
 }
 
 int kstate_arch_check_task_struct(struct task_struct *tsk)
 {
 	struct restart_block *rb;
 
-	if (tsk->thread.xstate) {
-		WARN_ON(1);
-		return -EINVAL;
-	}
 	rb = &task_thread_info(tsk)->restart_block;
 	if (rb->fn != current_thread_info()->restart_block.fn) {
 		WARN(1, "rb->fn = %pF\n", rb->fn);
@@ -237,13 +248,30 @@ int kstate_arch_dump_task_struct(struct kstate_context *ctx, struct task_struct
 	BUILD_BUG_ON(sizeof(tsk->thread.tls_array) != 3 * 8);
 	memcpy(i->tls_array, tsk->thread.tls_array, sizeof(i->tls_array));
 
+	i->len_xstate = 0;
+	if (tsk->thread.xstate) {
+		i->len_xstate = xstate_size;
+		memcpy(i + 1, tsk->thread.xstate, xstate_size);
+	}
+
 	return 0;
 }
 
+static int restore_xstate(struct task_struct *tsk, void *xstate, unsigned int len)
+{
+	int rv;
+
+	rv = init_fpu(tsk);
+	if (rv == 0)
+		memcpy(tsk->thread.xstate, xstate, len);
+	return rv;
+}
+
 asmlinkage void ret_from_fork(void);
 static int restore_task_struct_i386(struct task_struct *tsk, struct kstate_image_task_struct_i386 *i)
 {
 	struct pt_regs *regs = task_pt_regs(tsk);
+	int rv;
 
 	tsk->thread.sp = (unsigned long)regs;
 	tsk->thread.sp0 = (unsigned long)(regs + 1);
@@ -281,6 +309,12 @@ static int restore_task_struct_i386(struct task_struct *tsk, struct kstate_image
 
 	memcpy(tsk->thread.tls_array, i->tls_array, 3 * 8);
 
+	if (i->len_xstate) {
+		rv = restore_xstate(tsk, i + 1, i->len_xstate);
+		if (rv < 0)
+			return rv;
+	}
+
 	return 0;
 }
 
-- 
1.5.6.5

