Return-Path: <linux-kernel-owner+w=401wt.eu-S936120AbZDJCjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936120AbZDJCjB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 22:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934853AbZDJCgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 22:36:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:50884 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934858AbZDJCgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 22:36:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=aCdbDXaVspk1Nd/88JUlZ6twlGAOjaMf/zAWQSX7i5QoDvMEl8Q0VcApGq/TsrF5oA
         u8xO0VXcH+vmJZ1Hh+exg5+9qXQwxtjKmmBAxtE55/P3zmn1NZtTNBr72CIZq/vwKvfl
         tiB8PLo1X+icfyoNpGg011l9HIvf5Yc0DdzxQ=
Date: Fri, 10 Apr 2009 06:36:10 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, containers@lists.linux-foundation.org
Cc: xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, orenl@cs.columbia.edu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/30] cr: i386 xstate support
Message-ID: <20090410023610.GM27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/cr.h    |    3 +++
 kernel/cr/cr-x86_32.c |   49 ++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 45 insertions(+), 7 deletions(-)

--- a/include/linux/cr.h
+++ b/include/linux/cr.h
@@ -96,6 +96,9 @@ struct cr_image_arch_x86_32 {
 	__u32		cr_dr7;
 
 	__u64		cr_tls_array[3];
+
+	__u32		cr_len_xstate;
+	/* __u8	cr_xstate[cr_len_xstate]; */
 } __packed;
 
 struct cr_image_mm_struct {
--- a/kernel/cr/cr-x86_32.c
+++ b/kernel/cr/cr-x86_32.c
@@ -1,5 +1,6 @@
 /* Copyright (C) 2000-2009 Parallels Holdings, Ltd. */
 #include <linux/sched.h>
+#include <asm/i387.h>
 
 #include <linux/cr.h>
 #include "cr.h"
@@ -23,22 +24,30 @@ __u32 cr_task_struct_arch(struct task_struct *tsk)
 
 int cr_arch_check_image_task_struct(struct cr_image_task_struct *i)
 {
+	struct cr_image_arch_x86_32 *arch_i = (struct cr_image_arch_x86_32 *)(i + 1);
+	unsigned int len_xstate = arch_i->cr_len_xstate;
+
 	if (i->cr_tsk_arch != CR_ARCH_X86_32)
 		return -EINVAL;
+	if (len_xstate > 0 && len_xstate != xstate_size) {
+		WARN(1, "xstate size mismatch %u:%u, tsk '%s'\n", len_xstate, xstate_size, i->cr_comm);
+		return -EINVAL;
+	}
 	return 0;
 }
 
 unsigned int cr_arch_len_task_struct(struct task_struct *tsk)
 {
-	return sizeof(struct cr_image_arch_x86_32);
+	unsigned int len;
+
+	len = sizeof(struct cr_image_arch_x86_32);
+	if (tsk->thread.xstate)
+		len += xstate_size;
+	return len;
 }
 
 int cr_arch_check_task_struct(struct task_struct *tsk)
 {
-	if (tsk->thread.xstate) {
-		WARN_ON(1);
-		return -EINVAL;
-	}
 	if (tsk->thread.vm86_info) {
 		WARN_ON(1);
 		return -EINVAL;
@@ -97,6 +106,26 @@ static u16 decode_segment(__u16 reg)
 	BUG();
 }
 
+static int cr_dump_xstate(struct cr_context *ctx, struct task_struct *tsk)
+{
+	if (tsk->thread.xstate)
+		return cr_write(ctx, tsk->thread.xstate, xstate_size);
+	return 0;
+}
+
+static int cr_restore_xstate(struct task_struct *tsk, void *xstate, unsigned int len)
+{
+	int rv;
+
+	if (len == 0)
+		return 0;
+
+	rv = init_fpu(tsk);
+	if (rv == 0)
+		memcpy(tsk->thread.xstate, xstate, len);
+	return rv;
+}
+
 int cr_arch_dump_task_struct(struct cr_context *ctx, struct task_struct *tsk)
 {
 	struct cr_image_arch_x86_32 *i;
@@ -137,9 +166,15 @@ int cr_arch_dump_task_struct(struct cr_context *ctx, struct task_struct *tsk)
 	BUILD_BUG_ON(sizeof(tsk->thread.tls_array) != 3 * 8);
 	memcpy(i->cr_tls_array, tsk->thread.tls_array, sizeof(i->cr_tls_array));
 
+	i->cr_len_xstate = 0;
+	if (tsk->thread.xstate)
+		i->cr_len_xstate = xstate_size;
+
 	rv = cr_write(ctx, i, sizeof(*i));
 	kfree(i);
-	return rv;
+	if (rv < 0)
+		return rv;
+	return cr_dump_xstate(ctx, tsk);
 }
 
 asmlinkage void ret_from_fork(void);
@@ -179,7 +214,7 @@ static int cr_restore_task_struct_x86_32(struct task_struct *tsk, struct cr_imag
 
 	memcpy(tsk->thread.tls_array, i->cr_tls_array, 3 * 8);
 
-	return 0;
+	return cr_restore_xstate(tsk, i + 1, i->cr_len_xstate);
 }
 
 int cr_arch_restore_task_struct(struct task_struct *tsk, struct cr_image_task_struct *i)
