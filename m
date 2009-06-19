Return-Path: <linux-kernel-owner+w=401wt.eu-S1758917AbZFSWbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbZFSWbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 18:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096AbZFSWa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 18:30:58 -0400
Received: from cobra.newdream.net ([66.33.216.30]:44715 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbZFSWay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 18:30:54 -0400
From: Sage Weil <sage@newdream.net>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       greg@kroah.com
Cc: Sage Weil <sage@newdream.net>
Subject: [PATCH 01/21] fs: add fs/staging directory
Date: Fri, 19 Jun 2009 15:31:22 -0700
Message-Id: <1245450702-31343-2-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1245450702-31343-1-git-send-email-sage@newdream.net>
References: <1245450702-31343-1-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an fs/staging directory, analogous to drivers/staging, for file
systems that are not yet ready to be merged into the kernel proper.
This makes them easier to find by keeping them under the appropriate
menu/section.  It also makes them accessible when ARCH=um, which hides
the entire drivers tree.

As with drivers/staging, modules from fs/staging are marked with 'staging'
by modpost.

Evgeniy's pohmelfs (drivers/staging/pohmelfs) should presumably be moved
to fs/staging/pohmelfs.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/Kconfig             |    2 ++
 fs/Makefile            |    1 +
 fs/staging/Kconfig     |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/staging/Makefile    |    5 +++++
 fs/staging/fsstaging.c |   19 +++++++++++++++++++
 scripts/mod/modpost.c  |    4 +++-
 6 files changed, 76 insertions(+), 1 deletions(-)
 create mode 100644 fs/staging/Kconfig
 create mode 100644 fs/staging/Makefile
 create mode 100644 fs/staging/fsstaging.c

diff --git a/fs/Kconfig b/fs/Kconfig
index 9f7270f..3374de2 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -265,4 +265,6 @@ endif
 source "fs/nls/Kconfig"
 source "fs/dlm/Kconfig"
 
+source "fs/staging/Kconfig"
+
 endmenu
diff --git a/fs/Makefile b/fs/Makefile
index af6d047..a6e3c51 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -64,6 +64,7 @@ obj-$(CONFIG_DLM)		+= dlm/
  
 # Do not add any filesystems before this line
 obj-$(CONFIG_FSCACHE)		+= fscache/
+obj-$(CONFIG_FSSTAGING)		+= staging/
 obj-$(CONFIG_REISERFS_FS)	+= reiserfs/
 obj-$(CONFIG_EXT3_FS)		+= ext3/ # Before ext2 so root fs can be ext3
 obj-$(CONFIG_EXT2_FS)		+= ext2/
diff --git a/fs/staging/Kconfig b/fs/staging/Kconfig
new file mode 100644
index 0000000..605d8ae
--- /dev/null
+++ b/fs/staging/Kconfig
@@ -0,0 +1,46 @@
+menuconfig FSSTAGING
+	bool "Staging file systems"
+	default n
+	---help---
+	  This option allows you to select a number of file systems
+	  that are not of the "normal" Linux kernel quality level.
+	  These are placed here in order to get a wider audience to
+	  make use of them.  Please note that these are under heavy
+	  development, may or may not work, and may contain userspace
+	  interfaces that most likely will be changed in the near
+	  future.
+
+	  Using any of these file systems will taint your kernel which
+	  might affect support options from both the community, and
+	  various commercial support organizations.
+
+	  If you wish to work on these file systems, to help improve
+	  them, or to report problems you have with them, please see
+	  the fs_name.README file in the fs/staging/ directory to see
+	  what needs to be worked on, and who to contact.
+
+	  If in doubt, say N here.
+
+
+if FSSTAGING
+
+config FSSTAGING_EXCLUDE_BUILD
+	bool "Exclude Staging file systems from being built" if FSSTAGING
+	default y
+	---help---
+	  Are you sure you really want to build the staging file
+	  systems?  They taint your kernel, don't live up to the
+	  normal Linux kernel quality standards, are a bit crufty
+	  around the edges, and might go off and kick your dog when
+	  you aren't paying attention.
+
+	  Say N here to be able to select and build the Staging file
+	  systems.  This option is primarily here to prevent them from
+	  being built when selecting 'make allyesconfg' and 'make
+	  allmodconfig' so don't be all that put off, your dog will be
+	  just fine.
+
+if !FSSTAGING_EXCLUDE_BUILD
+
+endif # !FSSTAGING_EXCLUDE_BUILD
+endif # FSSTAGING
diff --git a/fs/staging/Makefile b/fs/staging/Makefile
new file mode 100644
index 0000000..7ddeb16
--- /dev/null
+++ b/fs/staging/Makefile
@@ -0,0 +1,5 @@
+# Makefile for fs/staging directory
+
+# fix for build system bug...
+obj-$(CONFIG_FSSTAGING)		+= fsstaging.o
+
diff --git a/fs/staging/fsstaging.c b/fs/staging/fsstaging.c
new file mode 100644
index 0000000..c9a0a8c
--- /dev/null
+++ b/fs/staging/fsstaging.c
@@ -0,0 +1,19 @@
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+
+static int __init fsstaging_init(void)
+{
+	return 0;
+}
+
+static void __exit fsstaging_exit(void)
+{
+}
+
+module_init(fsstaging_init);
+module_exit(fsstaging_exit);
+
+MODULE_AUTHOR("Sage Weil <sage@newdream.net>");
+MODULE_DESCRIPTION("FS Staging Core");
+MODULE_LICENSE("GPL");
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 161b784..3e92bbe 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1721,8 +1721,10 @@ static void add_header(struct buffer *b, struct module *mod)
 void add_staging_flag(struct buffer *b, const char *name)
 {
 	static const char *staging_dir = "drivers/staging";
+	static const char *fsstaging_dir = "fs/staging";
 
-	if (strncmp(staging_dir, name, strlen(staging_dir)) == 0)
+	if (strncmp(staging_dir, name, strlen(staging_dir)) == 0 ||
+	    strncmp(fsstaging_dir, name, strlen(fsstaging_dir)) == 0)
 		buf_printf(b, "\nMODULE_INFO(staging, \"Y\");\n");
 }
 
-- 
1.5.6.5

