Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbYICK5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbYICK5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 06:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbYICKzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 06:55:19 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:4176 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbYICKzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 06:55:12 -0400
From: Andrey Mirkin <major@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: containers@lists.linux-foundation.org, Andrey Mirkin <major@openvz.org>
Subject: [PATCH 7/9] Introduce function for restarting a container
Date: Wed,  3 Sep 2008 14:57:54 +0400
Message-Id: <1220439476-16465-8-git-send-email-major@openvz.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1220439476-16465-7-git-send-email-major@openvz.org>
References: <1220439476-16465-1-git-send-email-major@openvz.org>
 <1220439476-16465-2-git-send-email-major@openvz.org>
 <1220439476-16465-3-git-send-email-major@openvz.org>
 <1220439476-16465-4-git-send-email-major@openvz.org>
 <1220439476-16465-5-git-send-email-major@openvz.org>
 <1220439476-16465-6-git-send-email-major@openvz.org>
 <1220439476-16465-7-git-send-email-major@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually, right now this function will restart only one process.
Function to read head of dump file is introduced.

Signed-off-by: Andrey Mirkin <major@openvz.org>
---
 cpt/Makefile  |    2 +-
 cpt/cpt.h     |    1 +
 cpt/restart.c |   87 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 cpt/sys.c     |    2 +-
 4 files changed, 90 insertions(+), 2 deletions(-)
 create mode 100644 cpt/restart.c

diff --git a/cpt/Makefile b/cpt/Makefile
index bbb0e37..47c7852 100644
--- a/cpt/Makefile
+++ b/cpt/Makefile
@@ -2,4 +2,4 @@ obj-y += sys_core.o
 
 obj-$(CONFIG_CHECKPOINT) += cptrst.o
 
-cptrst-objs := sys.o checkpoint.o cpt_process.o cpt_mm.o
+cptrst-objs := sys.o checkpoint.o cpt_process.o cpt_mm.o restart.o
diff --git a/cpt/cpt.h b/cpt/cpt.h
index 73ae296..6471246 100644
--- a/cpt/cpt.h
+++ b/cpt/cpt.h
@@ -59,3 +59,4 @@ extern int debug_level;
 int dump_container(struct cpt_context *ctx);
 int cpt_dump_task(struct task_struct *tsk, struct cpt_context *ctx);
 int cpt_dump_mm(struct task_struct *tsk, struct cpt_context *ctx);
+int restart_container(struct cpt_context *ctx);
diff --git a/cpt/restart.c b/cpt/restart.c
new file mode 100644
index 0000000..5770985
--- /dev/null
+++ b/cpt/restart.c
@@ -0,0 +1,87 @@
+/*
+ *  Copyright (C) 2008 Parallels, Inc.
+ *
+ *  Author: Andrey Mirkin <major@openvz.org>
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License as
+ *  published by the Free Software Foundation, version 2 of the
+ *  License.
+ *
+ */
+
+#include <linux/sched.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+#include <linux/version.h>
+
+#include "cpt.h"
+#include "cpt_image.h"
+
+int rst_get_object(int type, void *tmp, int size, struct cpt_context *ctx)
+{
+	int err;
+	struct cpt_object_hdr *hdr = tmp;
+	err = ctx->read(hdr, sizeof(struct cpt_object_hdr), ctx);
+	if (err)
+		return err;
+	if (type > 0 && type != hdr->cpt_type)
+		return -EINVAL;
+	if (hdr->cpt_hdrlen < sizeof(struct cpt_object_hdr))
+		return -EINVAL;
+	if (size < sizeof(struct cpt_object_hdr))
+		return -EINVAL;
+	if (hdr->cpt_len < hdr->cpt_hdrlen)
+		return -EINVAL;
+	if (size > hdr->cpt_hdrlen)
+		size = hdr->cpt_hdrlen;
+	if (size > sizeof(*hdr))
+		err = ctx->read(hdr + 1, size - sizeof(*hdr), ctx);
+	return err;
+}
+
+static int rst_read_head(struct cpt_context *ctx)
+{
+	struct cpt_head hdr;
+	int err;
+
+	err = -EBADF;
+	if (!ctx->file)
+		return err;
+
+	err = ctx->read(&hdr, sizeof(hdr), ctx);
+	if (err < 0)
+		return err;
+
+	if (hdr.cpt_signature[0] != CPT_SIGNATURE0 ||
+	    hdr.cpt_signature[1] != CPT_SIGNATURE1 ||
+	    hdr.cpt_signature[2] != CPT_SIGNATURE2 ||
+	    hdr.cpt_signature[3] != CPT_SIGNATURE3) {
+		return -EINVAL;
+	}
+	if (KERNEL_VERSION(hdr.cpt_image_major, hdr.cpt_image_minor,
+				hdr.cpt_image_sublevel) != LINUX_VERSION_CODE)
+		return -EINVAL;
+
+#if defined(CONFIG_X86_32)
+	if (hdr.cpt_arch != CPT_ARCH_I386)
+		return -ENOSYS;
+#else
+#error  Arch is not supported
+#endif
+
+	return 0;
+}
+
+int restart_container(struct cpt_context *ctx)
+{
+	int err;
+
+	err = rst_read_head(ctx);
+
+	/* Restart process */
+	if (!err)
+		err = -ENOSYS;
+
+	return err;
+}
diff --git a/cpt/sys.c b/cpt/sys.c
index 6801c22..5b453f2 100644
--- a/cpt/sys.c
+++ b/cpt/sys.c
@@ -142,7 +142,7 @@ static int restart(int ctid, int fd, unsigned long flags)
 	ctx->ctx_state = CPT_CTX_UNDUMPING;
 
 	/* restart */
-	err = -ENOSYS;
+	err = restart_container(ctx);
 
 	context_put(ctx);
 
-- 
1.5.6

