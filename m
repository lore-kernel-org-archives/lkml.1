Return-Path: <linux-kernel-owner+w=401wt.eu-S1761614AbYDCHNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761614AbYDCHNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 03:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761473AbYDCHNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 03:13:09 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:39849 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150AbYDCHNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 03:13:07 -0400
From: "Satoshi UCHIDA" <s-uchida@ap.jp.nec.com>
To: "'Satoshi UCHIDA'" <s-uchida@ap.jp.nec.com>,
       "'Paul Menage'" <menage@google.com>, <linux-kernel@vger.kernel.org>,
       <containers@lists.linux-foundation.org>
Cc: <axboe@kernel.dk>, <tom-sugawara@ap.jp.nec.com>
References: <007801c893d9$d89726f0$89c574d0$@jp.nec.com>		<008001c893db$4e2eccf0$ea8c66d0$@jp.nec.com>	<6599ad830804021541s3c1e3197y77d87f63bf47e4b3@mail.gmail.com> <005d01c89559$9e538200$dafa8600$@jp.nec.com>
In-Reply-To: <005d01c89559$9e538200$dafa8600$@jp.nec.com>
Subject: [RFC][patch 3/12][CFQ-cgroup] Introduce cgroup subsystem
Date: Thu, 3 Apr 2008 16:12:54 +0900
Message-Id: <006001c8955a$23267fa0$69737ee0$@jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AciVEsqJacziMmPnQjKpkKdoNO90TwARhoqAAABL1CA=
Content-Language: ja
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a simple cgroup subsystem.
New cgroup subsystem is called cfq_cgroup.

   Signed-off-by: Satoshi UCHIDA <uchida@ap.jp.nec.com>

---
 block/Makefile                |    1 +
 block/cfq-cgroup.c            |   57 +++++++++++++++++++++++++++++++++++++++++
 include/linux/cgroup_subsys.h |    6 ++++
 3 files changed, 64 insertions(+), 0 deletions(-)
 create mode 100644 block/cfq-cgroup.c

diff --git a/block/Makefile b/block/Makefile
index 5a43c7d..ea07b46 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_IOSCHED_NOOP)	+= noop-iosched.o
 obj-$(CONFIG_IOSCHED_AS)	+= as-iosched.o
 obj-$(CONFIG_IOSCHED_DEADLINE)	+= deadline-iosched.o
 obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched.o
+obj-$(CONFIG_CGROUP_CFQ)	+= cfq-cgroup.o
 
 obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
 obj-$(CONFIG_BLOCK_COMPAT)	+= compat_ioctl.o
diff --git a/block/cfq-cgroup.c b/block/cfq-cgroup.c
new file mode 100644
index 0000000..de00a0d
--- /dev/null
+++ b/block/cfq-cgroup.c
@@ -0,0 +1,57 @@
+/*
+ *  CFQ CGROUP disk scheduler.
+ *
+ *     This program is a wrapper program that is
+ *     extend CFQ disk scheduler for handling
+ *     cgroup subsystem. 
+ *
+ *     This program is based on original CFQ code.
+ * 
+ *  Copyright (C) 2008 Satoshi UCHIDA <s-uchida@ap.jp.nec.com>
+ *   and NEC Corp.
+ */
+
+#include <linux/blkdev.h>
+#include <linux/cgroup.h>
+#include <linux/cfq-iosched.h>
+
+struct cfq_cgroup {
+	struct cgroup_subsys_state css;
+};
+
+
+static inline struct cfq_cgroup *cgroup_to_cfq_cgroup(struct cgroup *cont)
+{
+	return container_of(cgroup_subsys_state(cont, cfq_subsys_id),
+			    struct cfq_cgroup, css);
+}
+
+static struct cgroup_subsys_state *
+cfq_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
+{
+	struct cfq_cgroup *cfqc;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return ERR_PTR(-EPERM);
+
+	if (!cgroup_is_descendant(cont))
+		return ERR_PTR(-EPERM);
+
+	cfqc = kzalloc(sizeof(struct cfq_cgroup), GFP_KERNEL);
+	if (unlikely(!cfqc))
+		return ERR_PTR(-ENOMEM);
+
+	return &cfqc->css;	
+}
+
+static void cfq_cgroup_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
+{
+	kfree(cgroup_to_cfq_cgroup(cont));
+}
+
+struct cgroup_subsys cfq_subsys = {
+	.name = "cfq",
+	.create = cfq_cgroup_create,
+	.destroy = cfq_cgroup_destroy,
+	.subsys_id = cfq_subsys_id,
+};
diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index 1ddebfc..217ecb9 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -42,3 +42,9 @@ SUBSYS(mem_cgroup)
 #endif
 
 /* */
+
+#ifdef CONFIG_CGROUP_CFQ
+SUBSYS(cfq)
+#endif
+
+/* */
-- 
1.5.4.1


