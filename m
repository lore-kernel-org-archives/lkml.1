Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbYLOQoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbYLOQoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 11:44:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754381AbYLOQoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 11:44:13 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48618 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192AbYLOQoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 11:44:12 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 1/3] filesystem notification: create fs/notify to contain all
	fs notification
To: linux-kernel@vger.kernel.org
Cc: hch@infradead.org, akpm@linux-foundation.org
Date: Mon, 15 Dec 2008 11:44:09 -0500
Message-ID: <20081215164409.2018.26639.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081215164016.2018.4813.stgit@paris.rdu.redhat.com>
References: <20081215164016.2018.4813.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Creating a generic filesystem notification interface, fsnotify, which will be
used by inotify, dnotify, and eventually fanotify is really starting to
clutter the fs directory.  This patch simply moves inotify and dnotify into
fs/notify/inotify and fs/notify/dnotify respectively.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/Kconfig                       |   39 --
 fs/Makefile                      |    5 
 fs/dnotify.c                     |  194 --------
 fs/inotify.c                     |  913 --------------------------------------
 fs/inotify_user.c                |  778 --------------------------------
 fs/notify/Kconfig                |    2 
 fs/notify/Makefile               |    2 
 fs/notify/dnotify/Kconfig        |   10 
 fs/notify/dnotify/Makefile       |    1 
 fs/notify/dnotify/dnotify.c      |  194 ++++++++
 fs/notify/inotify/Kconfig        |   27 +
 fs/notify/inotify/Makefile       |    2 
 fs/notify/inotify/inotify.c      |  913 ++++++++++++++++++++++++++++++++++++++
 fs/notify/inotify/inotify_user.c |  778 ++++++++++++++++++++++++++++++++
 14 files changed, 1931 insertions(+), 1927 deletions(-)
 delete mode 100644 fs/dnotify.c
 delete mode 100644 fs/inotify.c
 delete mode 100644 fs/inotify_user.c
 create mode 100644 fs/notify/Kconfig
 create mode 100644 fs/notify/Makefile
 create mode 100644 fs/notify/dnotify/Kconfig
 create mode 100644 fs/notify/dnotify/Makefile
 create mode 100644 fs/notify/dnotify/dnotify.c
 create mode 100644 fs/notify/inotify/Kconfig
 create mode 100644 fs/notify/inotify/Makefile
 create mode 100644 fs/notify/inotify/inotify.c
 create mode 100644 fs/notify/inotify/inotify_user.c

diff --git a/fs/Kconfig b/fs/Kconfig
index 522469a..ff0e819 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -270,44 +270,7 @@ config OCFS2_COMPAT_JBD
 
 endif # BLOCK
 
-config DNOTIFY
-	bool "Dnotify support"
-	default y
-	help
-	  Dnotify is a directory-based per-fd file change notification system
-	  that uses signals to communicate events to user-space.  There exist
-	  superior alternatives, but some applications may still rely on
-	  dnotify.
-
-	  If unsure, say Y.
-
-config INOTIFY
-	bool "Inotify file change notification support"
-	default y
-	---help---
-	  Say Y here to enable inotify support.  Inotify is a file change
-	  notification system and a replacement for dnotify.  Inotify fixes
-	  numerous shortcomings in dnotify and introduces several new features
-	  including multiple file events, one-shot support, and unmount
-	  notification.
-
-	  For more information, see <file:Documentation/filesystems/inotify.txt>
-
-	  If unsure, say Y.
-
-config INOTIFY_USER
-	bool "Inotify support for userspace"
-	depends on INOTIFY
-	default y
-	---help---
-	  Say Y here to enable inotify support for userspace, including the
-	  associated system calls.  Inotify allows monitoring of both files and
-	  directories via a single open fd.  Events are read from the file
-	  descriptor, which is also select()- and poll()-able.
-
-	  For more information, see <file:Documentation/filesystems/inotify.txt>
-
-	  If unsure, say Y.
+source "fs/notify/Kconfig"
 
 config QUOTA
 	bool "Quota support"
diff --git a/fs/Makefile b/fs/Makefile
index d9f8afe..e6f423d 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -20,8 +20,7 @@ obj-y +=	no-block.o
 endif
 
 obj-$(CONFIG_BLK_DEV_INTEGRITY) += bio-integrity.o
-obj-$(CONFIG_INOTIFY)		+= inotify.o
-obj-$(CONFIG_INOTIFY_USER)	+= inotify_user.o
+obj-y				+= notify/
 obj-$(CONFIG_EPOLL)		+= eventpoll.o
 obj-$(CONFIG_ANON_INODES)	+= anon_inodes.o
 obj-$(CONFIG_SIGNALFD)		+= signalfd.o
@@ -57,8 +56,6 @@ obj-$(CONFIG_QFMT_V1)		+= quota_v1.o
 obj-$(CONFIG_QFMT_V2)		+= quota_v2.o
 obj-$(CONFIG_QUOTACTL)		+= quota.o
 
-obj-$(CONFIG_DNOTIFY)		+= dnotify.o
-
 obj-$(CONFIG_PROC_FS)		+= proc/
 obj-y				+= partitions/
 obj-$(CONFIG_SYSFS)		+= sysfs/
diff --git a/fs/notify/Kconfig b/fs/notify/Kconfig
new file mode 100644
index 0000000..50914d7
--- /dev/null
+++ b/fs/notify/Kconfig
@@ -0,0 +1,2 @@
+source "fs/notify/dnotify/Kconfig"
+source "fs/notify/inotify/Kconfig"
diff --git a/fs/notify/Makefile b/fs/notify/Makefile
new file mode 100644
index 0000000..5a95b60
--- /dev/null
+++ b/fs/notify/Makefile
@@ -0,0 +1,2 @@
+obj-y			+= dnotify/
+obj-y			+= inotify/
diff --git a/fs/notify/dnotify/Kconfig b/fs/notify/dnotify/Kconfig
new file mode 100644
index 0000000..26adf5d
--- /dev/null
+++ b/fs/notify/dnotify/Kconfig
@@ -0,0 +1,10 @@
+config DNOTIFY
+	bool "Dnotify support"
+	default y
+	help
+	  Dnotify is a directory-based per-fd file change notification system
+	  that uses signals to communicate events to user-space.  There exist
+	  superior alternatives, but some applications may still rely on
+	  dnotify.
+
+	  If unsure, say Y.
diff --git a/fs/notify/dnotify/Makefile b/fs/notify/dnotify/Makefile
new file mode 100644
index 0000000..f145251
--- /dev/null
+++ b/fs/notify/dnotify/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_DNOTIFY)		+= dnotify.o
diff --git a/fs/dnotify.c b/fs/notify/dnotify/dnotify.c
similarity index 100%
rename from fs/dnotify.c
rename to fs/notify/dnotify/dnotify.c
diff --git a/fs/notify/inotify/Kconfig b/fs/notify/inotify/Kconfig
new file mode 100644
index 0000000..4467928
--- /dev/null
+++ b/fs/notify/inotify/Kconfig
@@ -0,0 +1,27 @@
+config INOTIFY
+	bool "Inotify file change notification support"
+	default y
+	---help---
+	  Say Y here to enable inotify support.  Inotify is a file change
+	  notification system and a replacement for dnotify.  Inotify fixes
+	  numerous shortcomings in dnotify and introduces several new features
+	  including multiple file events, one-shot support, and unmount
+	  notification.
+
+	  For more information, see <file:Documentation/filesystems/inotify.txt>
+
+	  If unsure, say Y.
+
+config INOTIFY_USER
+	bool "Inotify support for userspace"
+	depends on INOTIFY
+	default y
+	---help---
+	  Say Y here to enable inotify support for userspace, including the
+	  associated system calls.  Inotify allows monitoring of both files and
+	  directories via a single open fd.  Events are read from the file
+	  descriptor, which is also select()- and poll()-able.
+
+	  For more information, see <file:Documentation/filesystems/inotify.txt>
+
+	  If unsure, say Y.
diff --git a/fs/notify/inotify/Makefile b/fs/notify/inotify/Makefile
new file mode 100644
index 0000000..e290f3b
--- /dev/null
+++ b/fs/notify/inotify/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_INOTIFY)		+= inotify.o
+obj-$(CONFIG_INOTIFY_USER)	+= inotify_user.o
diff --git a/fs/inotify.c b/fs/notify/inotify/inotify.c
similarity index 100%
rename from fs/inotify.c
rename to fs/notify/inotify/inotify.c
diff --git a/fs/inotify_user.c b/fs/notify/inotify/inotify_user.c
similarity index 100%
rename from fs/inotify_user.c
rename to fs/notify/inotify/inotify_user.c

