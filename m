Return-Path: <linux-kernel-owner+w=401wt.eu-S1761341AbXGDLIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761341AbXGDLIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 07:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759738AbXGDLID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 07:08:03 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:57157 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761446AbXGDLIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 07:08:01 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Joel Becker <joel.becker@oracle.com>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       David Teigland <david.teigland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed, 04 Jul 2007 16:37:06 +0530
Message-Id: <20070704110706.28503.65615.sendpatchset@cselinux1.cse.iitk.ac.in>
In-Reply-To: <20070704110701.28503.95359.sendpatchset@cselinux1.cse.iitk.ac.in>
References: <20070704110701.28503.95359.sendpatchset@cselinux1.cse.iitk.ac.in>
Subject: [PATCH -mm 1/3] configfs+dlm: Separate out __CONFIGFS_ATTR into configfs.h
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

[1/3] configfs+dlm: Separate out __CONFIGFS_ATTR into configfs.h

fs/dlm/config.c contains a useful generic macro called __CONFIGFS_ATTR
that is similar to sysfs' __ATTR macro that makes defining attributes
easy for any user of configfs. Separate it out into configfs.h so that
other users (forthcoming in dynamic netconsole patchset) can use it too.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: David Teigland <teigland@redhat.com>

---

 fs/dlm/config.c          |    8 --------
 include/linux/configfs.h |   16 ++++++++++++++++
 2 files changed, 16 insertions(+), 8 deletions(-)

---

diff -ruNp a/fs/dlm/config.c b/fs/dlm/config.c
--- a/fs/dlm/config.c	2007-06-28 17:32:57.000000000 +0530
+++ b/fs/dlm/config.c	2007-07-03 16:56:35.000000000 +0530
@@ -133,14 +133,6 @@ static ssize_t cluster_set(struct cluste
 	return len;
 }
 
-#define __CONFIGFS_ATTR(_name,_mode,_read,_write) {                           \
-	.attr   = { .ca_name = __stringify(_name),                            \
-		    .ca_mode = _mode,                                         \
-		    .ca_owner = THIS_MODULE },                                \
-	.show   = _read,                                                      \
-	.store  = _write,                                                     \
-}
-
 #define CLUSTER_ATTR(name, check_zero)                                        \
 static ssize_t name##_write(struct cluster *cl, const char *buf, size_t len)  \
 {                                                                             \
diff -ruNp a/include/linux/configfs.h b/include/linux/configfs.h
--- a/include/linux/configfs.h	2007-06-28 17:33:19.000000000 +0530
+++ b/include/linux/configfs.h	2007-07-03 16:56:35.000000000 +0530
@@ -130,6 +130,22 @@ struct configfs_attribute {
 	mode_t			ca_mode;
 };
 
+/*
+ * Users often need to create attribute structures for their configurable
+ * attributes, containing a configfs_attribute member and function pointers
+ * for the show() and store() operations on that attribute. They can use
+ * this macro (similar to sysfs' __ATTR) to make defining attributes easier.
+ */
+#define __CONFIGFS_ATTR(_name, _mode, _show, _store)			\
+{									\
+	.attr	= {							\
+			.ca_name = __stringify(_name),			\
+			.ca_mode = _mode,				\
+			.ca_owner = THIS_MODULE,			\
+	},								\
+	.show	= _show,						\
+	.store	= _store,						\
+}
 
 /*
  * If allow_link() exists, the item can symlink(2) out to other
