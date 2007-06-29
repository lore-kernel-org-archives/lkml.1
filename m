Return-Path: <linux-kernel-owner+w=401wt.eu-S1758993AbXF2VwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758993AbXF2VwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 17:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757814AbXF2VuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 17:50:07 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2559 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757703AbXF2VuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 17:50:03 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@gmail.com>, Ingo Molnar <mingo@elte.hu>
Date: Fri, 29 Jun 2007 14:48:52 -0700
Subject: [patch 6/6] sys_indirect RFC - example usage from kernel POV
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.28360.1183153739.6>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an example of how to add a context set/unset wrapper inside
the kernel, for something like open flags:

1) Alloc a new SYSIND_CTX_* sequential index inside linux/indirect.h

2) Define a new "struct sysind_ctx_*" to be used by userspace

3) Define proper set/unset functions inside kernel/sys_indirect.c



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



---
 include/linux/indirect.h |    7 +++++++
 kernel/sys_indirect.c    |   32 +++++++++++++++++++++++++++++++-
 2 files changed, 38 insertions(+), 1 deletion(-)

Index: linux-2.6.mod/include/linux/indirect.h
===================================================================
--- linux-2.6.mod.orig/include/linux/indirect.h	2007-06-29 12:58:11.000000000 -0700
+++ linux-2.6.mod/include/linux/indirect.h	2007-06-29 12:58:11.000000000 -0700
@@ -8,10 +8,17 @@
 #ifndef _LINUX_INDIRECT_H
 #define _LINUX_INDIRECT_H
 
+#define SYSIND_CTX_OPENFLAGS	0
+
 struct indirect_ctx {
 	__u32 ctx;
 };
 
+struct sysind_ctx_OPENFLAGS {
+	__u32 ctx;
+	__u32 flags;
+};
+
 #ifdef __KERNEL__
 
 #include <linux/fsalloc.h>
Index: linux-2.6.mod/kernel/sys_indirect.c
===================================================================
--- linux-2.6.mod.orig/kernel/sys_indirect.c	2007-06-29 12:58:11.000000000 -0700
+++ linux-2.6.mod/kernel/sys_indirect.c	2007-06-29 12:58:11.000000000 -0700
@@ -24,9 +24,39 @@
 	void (*unset)(struct indirect_op *);
 };
 
+struct indirect_op_OPENFLAGS {
+	struct indirect_op op;
+	unsigned long flags;
+};
+
+static int set_OPENFLAGS(struct fsa_context *ator,
+			 const struct indirect_ctx __user *uctx,
+			 struct indirect_op **pnew)
+{
+	struct indirect_op_OPENFLAGS *iop;
+	struct sysind_ctx_OPENFLAGS kctx;
+
+	if (copy_from_user(&kctx, uctx, sizeof(*uctx)))
+		return -EFAULT;
+	iop = fsa_alloc(ator, sizeof(struct indirect_op_OPENFLAGS));
+	if (unlikely(!iop))
+		return -ENOMEM;
+	iop->op.ctx = kctx.ctx;
+	/* iop->flags = current->def_open_flags; */
+	/* current->def_open_flags = kctx.flags; */
+	*pnew = (struct indirect_op *) iop;
+
+	return 0;
+}
+
+static void unset_OPENFLAGS(struct indirect_op *iop)
+{
+	/* current->def_open_flags = ((struct indirect_op_OPENFLAGS *) iop)->flags; */
+}
+
 static const struct indirect_procs inprocs[] =
 {
-	{ NULL, NULL },
+	[SYSIND_CTX_OPENFLAGS] =	{ set_OPENFLAGS, unset_OPENFLAGS },
 };
 
 /**

