Return-Path: <linux-kernel-owner+w=401wt.eu-S1758935AbYEEDsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935AbYEEDsw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 23:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757237AbYEEDnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 23:43:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756946AbYEEDnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 23:43:25 -0400
Date: Sun, 4 May 2008 23:42:46 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200805050342.m453gkY4029814@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 01/18] flag parameters: helper function
Cc: akpm@linux-foundation.org, davidel@xmailserver.org, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the following patches we have to map one set of flags to another one
in numerous locations.  This patch provides a generic implementation for
this.  It is basically the code Davide Libenzi suggested on 4/27/08.

I haven't checked whether this functionality can be applied to any existing
code.


 include/linux/flagsremap.h |   15 +++++++++++++++
 lib/Makefile               |    2 +-
 lib/flagsremap.c           |   17 +++++++++++++++++
 3 files changed, 33 insertions(+), 1 deletion(-)


Signed-off-by: Ulrich Drepper <drepper@redhat.com>

diff --git a/include/linux/flagsremap.h b/include/linux/flagsremap.h
new file mode 100644
index 0000000..6ea0ee3
--- /dev/null
+++ b/include/linux/flagsremap.h
@@ -0,0 +1,15 @@
+/*
+ * Generic flag remapping functionality.
+ */
+#ifndef _LINUX_FLAPREMAP_H
+#define _LINUX_FLAGREMAP_H
+
+struct flags_rmap {
+	int f;
+	int of;
+};
+
+extern int flags_remap(const struct flags_rmap *m, int n,
+		       int f, int *rf);
+
+#endif /* _LINUX_FLAGREMAP_H */
diff --git a/lib/Makefile b/lib/Makefile
index 74b0cfb..ab861ad 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -6,7 +6,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
-	 proportions.o prio_heap.o ratelimit.o
+	 proportions.o prio_heap.o ratelimit.o flagsremap.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
diff --git a/lib/flagsremap.c b/lib/flagsremap.c
new file mode 100644
index 0000000..7dbe8f5
--- /dev/null
+++ b/lib/flagsremap.c
@@ -0,0 +1,17 @@
+/*
+ * Implement generic flag remapping.
+ */
+#include <linux/flagsremap.h>
+
+
+int flags_remap(const struct flags_rmap *m, int n,
+		int f, int *rf)
+{
+	int i;
+	for (i = 0, *rf = 0; f && i < n; i++, m++)
+		if (f & m->f) {
+			*rf |= m->of;
+			f &= ~m->f;
+		}
+	return f;
+}
