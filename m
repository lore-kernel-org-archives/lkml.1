Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbYKLIew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbYKLIew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 03:34:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbYKLIe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 03:34:29 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:33664 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbYKLIe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 03:34:28 -0500
From: "Satoshi UCHIDA" <s-uchida@ap.jp.nec.com>
To: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
       <virtualization@lists.linux-foundation.org>, <jens.axboe@oracle.com>,
       "'Ryo Tsuruta'" <ryov@valinux.co.jp>,
       "'Andrea Righi'" <righi.andrea@gmail.com>, <ngupta@google.com>,
       <fernando@oss.ntt.co.jp>, <vtaras@openvz.org>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'SUGAWARA Tomoyoshi'" <tom-sugawara@ap.jp.nec.com>,
       <menage@google.com>, <balbir@linux.vnet.ibm.com>
References: <000c01c9449e$c5bcdc20$51369460$@jp.nec.com>
In-Reply-To: <000c01c9449e$c5bcdc20$51369460$@jp.nec.com>
Subject: [PATCH][cfq-cgroups][03/12] Add cgroup file and modify configure files.
Date: Wed, 12 Nov 2008 17:25:35 +0900
Message-ID: <001001c944a0$3c1ed700$b45c8500$@jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AclEnsU5YPNAeH0jT4OGyB1wwkbE/wAAVn8w
Content-Language: ja
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  This patch adds the cfq-cgroup file and modifies configure files.
  The cfq-cgroup file store some functions which use to expand CFQ
  scheduler for handling cgroups.
  Expanded CFQ scheduler is registered for "cfq-cgroups".


    Signed-off-by: Satoshi UCHIDA <s-uchida@ap.jp.nec.com>

---
 block/Kconfig.iosched |   16 ++++++++++++++++
 block/Makefile        |    1 +
 block/cfq-cgroup.c    |   32 ++++++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+), 0 deletions(-)
 create mode 100644 block/cfq-cgroup.c

diff --git a/block/Kconfig.iosched b/block/Kconfig.iosched
index 7e803fc..dc61120 100644
--- a/block/Kconfig.iosched
+++ b/block/Kconfig.iosched
@@ -40,6 +40,18 @@ config IOSCHED_CFQ
 	  working environment, suitable for desktop systems.
 	  This is the default I/O scheduler.
 
+config IOSCHED_CFQ_CGROUP
+	tristate "expanded CFQ I/O Scheduler for cgroups"
+	default n
+	depends on IOSCHED_CFQ && CGROUPS
+	---help---
+	  The expanded CFQ I/O scheduelr for cgroups tries to distribute
+	  bandwidth equally among all groups and among all processes within
+	  groups in the system. It should provide a fair working environment,
+	  suitable for consolidated environment which have some destop systems.
+	  This scheduler expands the CFQ I/O scheduler into two layer control
+	  -- per group layer and per task layer --.
+
 choice
 	prompt "Default I/O scheduler"
 	default DEFAULT_CFQ
@@ -56,6 +68,9 @@ choice
 	config DEFAULT_CFQ
 		bool "CFQ" if IOSCHED_CFQ=y
 
+	config DEFAULT_CFQ_CGROUP
+		bool "CFQ-Cgroups" if IOSCHED_CFQ_CGROUP=y
+
 	config DEFAULT_NOOP
 		bool "No-op"
 
@@ -66,6 +81,7 @@ config DEFAULT_IOSCHED
 	default "anticipatory" if DEFAULT_AS
 	default "deadline" if DEFAULT_DEADLINE
 	default "cfq" if DEFAULT_CFQ
+	default "cfq-cgroups" if DEFAULT_CFQ_CGROUP
 	default "noop" if DEFAULT_NOOP
 
 endmenu
diff --git a/block/Makefile b/block/Makefile
index bfe7304..3c0f59d 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_IOSCHED_NOOP)	+= noop-iosched.o
 obj-$(CONFIG_IOSCHED_AS)	+= as-iosched.o
 obj-$(CONFIG_IOSCHED_DEADLINE)	+= deadline-iosched.o
 obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched.o
+obj-$(CONFIG_IOSCHED_CFQ_CGROUP)	+= cfq-cgroup.o
 
 obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
 obj-$(CONFIG_BLOCK_COMPAT)	+= compat_ioctl.o
diff --git a/block/cfq-cgroup.c b/block/cfq-cgroup.c
new file mode 100644
index 0000000..3deef41
--- /dev/null
+++ b/block/cfq-cgroup.c
@@ -0,0 +1,32 @@
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
+static int __init cfq_cgroup_init(void)
+{
+	return 0;
+}
+
+static void __exit cfq_cgroup_exit(void)
+{
+}
+
+module_init(cfq_cgroup_init);
+module_exit(cfq_cgroup_exit);
+
+MODULE_AUTHOR("Satoshi UCHIDA");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Expanded CFQ IO scheduler for CGROUPS");
-- 
1.5.6.5


