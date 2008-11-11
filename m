Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbYKKM4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbYKKM4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 07:56:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbYKKM4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 07:56:22 -0500
Received: from ms01.sssup.it ([193.205.80.99]:46068 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755655AbYKKM4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 07:56:21 -0500
Date: Tue, 11 Nov 2008 13:58:31 +0100
From: Fabio Checconi <fchecconi@gmail.com>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, paolo.valente@unimore.it,
       fabio@gandalf.sssup.it
Subject: [PATCH 03/03] block: add cgroups, kconfig and build bits for BFQ
Message-ID: <20081111125830.GG9508@gandalf.sssup.it>
References: <20081111125148.GD9508@gandalf.sssup.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111125148.GD9508@gandalf.sssup.it>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a Kconfig option and do the related Makefile changes to compile
the BFQ I/O scheduler.  Also let the cgroups subsystem know about the
BFQ I/O controller.

Signed-off-by: Fabio Checconi <fabio@gandalf.sssup.it>
Signed-off-by: Paolo Valente <paolo.valente@unimore.it>
---
 block/Kconfig.iosched         |   25 +++++++++++++++++++++++++
 block/Makefile                |    1 +
 include/linux/cgroup_subsys.h |    6 ++++++
 3 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/block/Kconfig.iosched b/block/Kconfig.iosched
index 7e803fc..f0681b3 100644
--- a/block/Kconfig.iosched
+++ b/block/Kconfig.iosched
@@ -40,6 +40,27 @@ config IOSCHED_CFQ
 	  working environment, suitable for desktop systems.
 	  This is the default I/O scheduler.
 
+config IOSCHED_BFQ
+	tristate "BFQ I/O scheduler"
+	depends on EXPERIMENTAL
+	default n
+	---help---
+	  The BFQ I/O scheduler tries to distribute bandwidth among
+	  all processes in the system, according to their weights,
+	  which can be set using task ioprio values.  It aims at giving
+	  deterministic guarantees on the distribution of the service
+	  provided.  If compiled built-in (saying Y here), BFQ can
+	  be configured to support hierarchical scheduling.
+
+config CGROUP_BFQIO
+	bool "BFQ hierarchical scheduling support"
+	depends on CGROUPS && IOSCHED_BFQ=y
+	default n
+	---help---
+	  Enable hierarchical scheduling in BFQ, using the cgroups
+	  filesystem interface.  The name of the subsystem will be
+	  bfqio.
+
 choice
 	prompt "Default I/O scheduler"
 	default DEFAULT_CFQ
@@ -56,6 +77,9 @@ choice
 	config DEFAULT_CFQ
 		bool "CFQ" if IOSCHED_CFQ=y
 
+	config DEFAULT_BFQ
+		bool "BFQ" if IOSCHED_BFQ=y
+
 	config DEFAULT_NOOP
 		bool "No-op"
 
@@ -66,6 +90,7 @@ config DEFAULT_IOSCHED
 	default "anticipatory" if DEFAULT_AS
 	default "deadline" if DEFAULT_DEADLINE
 	default "cfq" if DEFAULT_CFQ
+	default "bfq" if DEFAULT_BFQ
 	default "noop" if DEFAULT_NOOP
 
 endmenu
diff --git a/block/Makefile b/block/Makefile
index 208000b..fa41b6e 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_IOSCHED_NOOP)	+= noop-iosched.o
 obj-$(CONFIG_IOSCHED_AS)	+= as-iosched.o
 obj-$(CONFIG_IOSCHED_DEADLINE)	+= deadline-iosched.o
 obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched.o
+obj-$(CONFIG_IOSCHED_BFQ)	+= bfq-iosched.o
 
 obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
 obj-$(CONFIG_BLOCK_COMPAT)	+= compat_ioctl.o
diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index e287745..981b199 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -48,3 +48,9 @@ SUBSYS(devices)
 #endif
 
 /* */
+
+#ifdef CONFIG_CGROUP_BFQIO
+SUBSYS(bfqio)
+#endif
+
+/* */
