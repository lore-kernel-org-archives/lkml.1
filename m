Return-Path: <linux-kernel-owner+w=401wt.eu-S933742AbYCFBVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933742AbYCFBVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 20:21:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762916AbYCFBPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 20:15:25 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:20188 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759032AbYCFBPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 20:15:05 -0500
From: Joel Becker <joel.becker@oracle.com>
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       mark.fasheh@oracle.com, teigland@redhat.com
Subject: [PATCH 10/10] ocfs2: Allow selection of cluster plug-ins.
Date: Wed,  5 Mar 2008 17:13:58 -0800
Message-Id: <1204766038-31721-11-git-send-email-joel.becker@oracle.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1204766038-31721-1-git-send-email-joel.becker@oracle.com>
References: <1204766038-31721-1-git-send-email-joel.becker@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ocfs2 now supports plug-ins for the classic O2CB stack as well as
userspace cluster stacks in conjunction with fs/dlm.  This allows zero,
one, or both of the plug-ins to be selected in Kconfig.  For local mounts
(non-clustered), neither plug-in is needed.  Both plugins can be loaded
at one time, the runtime will select the one needed for the cluster
systme in use.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/Kconfig        |   26 ++++++++++++++++++++++++++
 fs/ocfs2/Makefile |   10 ++++++----
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index d731282..1b0e775 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -444,6 +444,32 @@ config OCFS2_FS
 	  For more information on OCFS2, see the file
 	  <file:Documentation/filesystems/ocfs2.txt>.
 
+config OCFS2_FS_O2CB
+	tristate "O2CB Kernelspace Clustering"
+	depends on OCFS2_FS
+	default y
+	help
+	  OCFS2 includes a simple kernelspace clustering package, the OCFS2
+	  Cluster Base.  It only requires a very small userspace compontent
+	  to configure it. This comes with the standard ocfs2-tools package.
+	  O2CB is limited to maintaining a cluster for OCFS2 file systems.
+	  It cannot manage any other cluster applications.
+
+	  It is always safe to say Y here, as the clustering method is
+	  run-time selectable.
+
+config OCFS2_FS_USERSPACE_CLUSTER
+	tristate "OCFS2 Userspace Clustering"
+	depends on OCFS2_FS && DLM
+	default y
+	help
+	  This option will allow OCFS2 to use userspace clustering services
+	  in conjunction with the DLM in fs/dlm.  If you are using a
+	  userspace cluster manager, say Y here.
+
+	  It is safe to say Y, as the clustering method is run-time
+	  selectable.
+
 config OCFS2_DEBUG_MASKLOG
 	bool "OCFS2 logging support"
 	depends on OCFS2_FS
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index b8d6d02..f6956de 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -4,9 +4,10 @@ EXTRA_CFLAGS += -DCATCH_BH_JBD_RACES
 
 obj-$(CONFIG_OCFS2_FS) += 	\
 	ocfs2.o			\
-	ocfs2_stackglue.o	\
-	ocfs2_stack_o2cb.o	\
-	ocfs2_stack_user.o
+	ocfs2_stackglue.o
+
+obj-$(CONFIG_OCFS2_FS_O2CB) += ocfs2_stack_o2cb.o
+obj-$(CONFIG_OCFS2_FS_USERSPACE_CLUSTER) += ocfs2_stack_user.o
 
 ocfs2-objs := \
 	alloc.o 		\
@@ -39,5 +40,6 @@ ocfs2_stackglue-objs := stackglue.o
 ocfs2_stack_o2cb-objs := stack_o2cb.o
 ocfs2_stack_user-objs := stack_user.o
 
+# cluster/ is always needed when OCFS2_FS for masklog support
 obj-$(CONFIG_OCFS2_FS) += cluster/
-obj-$(CONFIG_OCFS2_FS) += dlm/
+obj-$(CONFIG_OCFS2_FS_O2CB) += dlm/
-- 
1.5.3.8

