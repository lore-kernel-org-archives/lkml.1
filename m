Return-Path: <linux-kernel-owner+w=401wt.eu-S1763752AbYFFDA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763752AbYFFDA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 23:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbYFFDAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 23:00:15 -0400
Received: from sous-sol.org ([216.99.217.87]:60132 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830AbYFFDAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 23:00:13 -0400
Date: Thu, 5 Jun 2008 20:00:02 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [git pull] please pull lsm-2.6.git for-linus branch
Message-ID: <20080606030001.GN30402@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the 'for-linus' branch of
    master.kernel.org:/pub/scm/linux/kernel/git/chrisw/lsm-2.6.git for-linus

to receive the following updates:

 MAINTAINERS                |    1 -
 fs/proc/array.c            |    2 +-
 include/linux/capability.h |   29 ++++++++---
 kernel/capability.c        |  111 +++++++++++++++++++++++++++++---------------
 4 files changed, 95 insertions(+), 48 deletions(-)

Andrew G. Morgan (1):
      capabilities: remain source compatible with 32-bit raw legacy capability support.

Chris Wright (1):
      LSM: remove stale web site from MAINTAINERS

diff --git a/MAINTAINERS b/MAINTAINERS
index 0a6d2ca..2852a02 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2565,7 +2565,6 @@ LINUX SECURITY MODULE (LSM) FRAMEWORK
 P:	Chris Wright
 M:	chrisw@sous-sol.org
 L:	linux-security-module@vger.kernel.org
-W:	http://lsm.immunix.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/chrisw/lsm-2.6.git
 S:	Supported
 
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 9e3b8c3..797d775 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -288,7 +288,7 @@ static void render_cap_t(struct seq_file *m, const char *header,
 	seq_printf(m, "%s", header);
 	CAP_FOR_EACH_U32(__capi) {
 		seq_printf(m, "%08x",
-			   a->cap[(_LINUX_CAPABILITY_U32S-1) - __capi]);
+			   a->cap[(_KERNEL_CAPABILITY_U32S-1) - __capi]);
 	}
 	seq_printf(m, "\n");
 }
diff --git a/include/linux/capability.h b/include/linux/capability.h
index f4ea0dd..fa830f8 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -31,11 +31,11 @@ struct task_struct;
 #define _LINUX_CAPABILITY_VERSION_1  0x19980330
 #define _LINUX_CAPABILITY_U32S_1     1
 
-#define _LINUX_CAPABILITY_VERSION_2  0x20071026
+#define _LINUX_CAPABILITY_VERSION_2  0x20071026  /* deprecated - use v3 */
 #define _LINUX_CAPABILITY_U32S_2     2
 
-#define _LINUX_CAPABILITY_VERSION    _LINUX_CAPABILITY_VERSION_2
-#define _LINUX_CAPABILITY_U32S       _LINUX_CAPABILITY_U32S_2
+#define _LINUX_CAPABILITY_VERSION_3  0x20080522
+#define _LINUX_CAPABILITY_U32S_3     2
 
 typedef struct __user_cap_header_struct {
 	__u32 version;
@@ -77,10 +77,23 @@ struct vfs_cap_data {
 	} data[VFS_CAP_U32];
 };
 
-#ifdef __KERNEL__
+#ifndef __KERNEL__
+
+/*
+ * Backwardly compatible definition for source code - trapped in a
+ * 32-bit world. If you find you need this, please consider using
+ * libcap to untrap yourself...
+ */
+#define _LINUX_CAPABILITY_VERSION  _LINUX_CAPABILITY_VERSION_1
+#define _LINUX_CAPABILITY_U32S     _LINUX_CAPABILITY_U32S_1
+
+#else
+
+#define _KERNEL_CAPABILITY_VERSION _LINUX_CAPABILITY_VERSION_3
+#define _KERNEL_CAPABILITY_U32S    _LINUX_CAPABILITY_U32S_3
 
 typedef struct kernel_cap_struct {
-	__u32 cap[_LINUX_CAPABILITY_U32S];
+	__u32 cap[_KERNEL_CAPABILITY_U32S];
 } kernel_cap_t;
 
 #define _USER_CAP_HEADER_SIZE  (sizeof(struct __user_cap_header_struct))
@@ -351,7 +364,7 @@ typedef struct kernel_cap_struct {
  */
 
 #define CAP_FOR_EACH_U32(__capi)  \
-	for (__capi = 0; __capi < _LINUX_CAPABILITY_U32S; ++__capi)
+	for (__capi = 0; __capi < _KERNEL_CAPABILITY_U32S; ++__capi)
 
 # define CAP_FS_MASK_B0     (CAP_TO_MASK(CAP_CHOWN)		\
 			    | CAP_TO_MASK(CAP_DAC_OVERRIDE)	\
@@ -361,7 +374,7 @@ typedef struct kernel_cap_struct {
 
 # define CAP_FS_MASK_B1     (CAP_TO_MASK(CAP_MAC_OVERRIDE))
 
-#if _LINUX_CAPABILITY_U32S != 2
+#if _KERNEL_CAPABILITY_U32S != 2
 # error Fix up hand-coded capability macro initializers
 #else /* HAND-CODED capability initializers */
 
@@ -372,7 +385,7 @@ typedef struct kernel_cap_struct {
 # define CAP_NFSD_SET     ((kernel_cap_t){{ CAP_FS_MASK_B0|CAP_TO_MASK(CAP_SYS_RESOURCE), \
 					CAP_FS_MASK_B1 } })
 
-#endif /* _LINUX_CAPABILITY_U32S != 2 */
+#endif /* _KERNEL_CAPABILITY_U32S != 2 */
 
 #define CAP_INIT_INH_SET    CAP_EMPTY_SET
 
diff --git a/kernel/capability.c b/kernel/capability.c
index 39e8193..cfbe442 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -53,6 +53,69 @@ static void warn_legacy_capability_use(void)
 }
 
 /*
+ * Version 2 capabilities worked fine, but the linux/capability.h file
+ * that accompanied their introduction encouraged their use without
+ * the necessary user-space source code changes. As such, we have
+ * created a version 3 with equivalent functionality to version 2, but
+ * with a header change to protect legacy source code from using
+ * version 2 when it wanted to use version 1. If your system has code
+ * that trips the following warning, it is using version 2 specific
+ * capabilities and may be doing so insecurely.
+ *
+ * The remedy is to either upgrade your version of libcap (to 2.10+,
+ * if the application is linked against it), or recompile your
+ * application with modern kernel headers and this warning will go
+ * away.
+ */
+
+static void warn_deprecated_v2(void)
+{
+	static int warned;
+
+	if (!warned) {
+		char name[sizeof(current->comm)];
+
+		printk(KERN_INFO "warning: `%s' uses deprecated v2"
+		       " capabilities in a way that may be insecure.\n",
+		       get_task_comm(name, current));
+		warned = 1;
+	}
+}
+
+/*
+ * Version check. Return the number of u32s in each capability flag
+ * array, or a negative value on error.
+ */
+static int cap_validate_magic(cap_user_header_t header, unsigned *tocopy)
+{
+	__u32 version;
+
+	if (get_user(version, &header->version))
+		return -EFAULT;
+
+	switch (version) {
+	case _LINUX_CAPABILITY_VERSION_1:
+		warn_legacy_capability_use();
+		*tocopy = _LINUX_CAPABILITY_U32S_1;
+		break;
+	case _LINUX_CAPABILITY_VERSION_2:
+		warn_deprecated_v2();
+		/*
+		 * fall through - v3 is otherwise equivalent to v2.
+		 */
+	case _LINUX_CAPABILITY_VERSION_3:
+		*tocopy = _LINUX_CAPABILITY_U32S_3;
+		break;
+	default:
+		if (put_user((u32)_KERNEL_CAPABILITY_VERSION, &header->version))
+			return -EFAULT;
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
  * For sys_getproccap() and sys_setproccap(), any of the three
  * capability set pointers may be NULL -- indicating that that set is
  * uninteresting and/or not to be changed.
@@ -71,27 +134,13 @@ asmlinkage long sys_capget(cap_user_header_t header, cap_user_data_t dataptr)
 {
 	int ret = 0;
 	pid_t pid;
-	__u32 version;
 	struct task_struct *target;
 	unsigned tocopy;
 	kernel_cap_t pE, pI, pP;
 
-	if (get_user(version, &header->version))
-		return -EFAULT;
-
-	switch (version) {
-	case _LINUX_CAPABILITY_VERSION_1:
-		warn_legacy_capability_use();
-		tocopy = _LINUX_CAPABILITY_U32S_1;
-		break;
-	case _LINUX_CAPABILITY_VERSION_2:
-		tocopy = _LINUX_CAPABILITY_U32S_2;
-		break;
-	default:
-		if (put_user(_LINUX_CAPABILITY_VERSION, &header->version))
-			return -EFAULT;
-		return -EINVAL;
-	}
+	ret = cap_validate_magic(header, &tocopy);
+	if (ret != 0)
+		return ret;
 
 	if (get_user(pid, &header->pid))
 		return -EFAULT;
@@ -118,7 +167,7 @@ out:
 	spin_unlock(&task_capability_lock);
 
 	if (!ret) {
-		struct __user_cap_data_struct kdata[_LINUX_CAPABILITY_U32S];
+		struct __user_cap_data_struct kdata[_KERNEL_CAPABILITY_U32S];
 		unsigned i;
 
 		for (i = 0; i < tocopy; i++) {
@@ -128,7 +177,7 @@ out:
 		}
 
 		/*
-		 * Note, in the case, tocopy < _LINUX_CAPABILITY_U32S,
+		 * Note, in the case, tocopy < _KERNEL_CAPABILITY_U32S,
 		 * we silently drop the upper capabilities here. This
 		 * has the effect of making older libcap
 		 * implementations implicitly drop upper capability
@@ -240,30 +289,16 @@ static inline int cap_set_all(kernel_cap_t *effective,
  */
 asmlinkage long sys_capset(cap_user_header_t header, const cap_user_data_t data)
 {
-	struct __user_cap_data_struct kdata[_LINUX_CAPABILITY_U32S];
+	struct __user_cap_data_struct kdata[_KERNEL_CAPABILITY_U32S];
 	unsigned i, tocopy;
 	kernel_cap_t inheritable, permitted, effective;
-	__u32 version;
 	struct task_struct *target;
 	int ret;
 	pid_t pid;
 
-	if (get_user(version, &header->version))
-		return -EFAULT;
-
-	switch (version) {
-	case _LINUX_CAPABILITY_VERSION_1:
-		warn_legacy_capability_use();
-		tocopy = _LINUX_CAPABILITY_U32S_1;
-		break;
-	case _LINUX_CAPABILITY_VERSION_2:
-		tocopy = _LINUX_CAPABILITY_U32S_2;
-		break;
-	default:
-		if (put_user(_LINUX_CAPABILITY_VERSION, &header->version))
-			return -EFAULT;
-		return -EINVAL;
-	}
+	ret = cap_validate_magic(header, &tocopy);
+	if (ret != 0)
+		return ret;
 
 	if (get_user(pid, &header->pid))
 		return -EFAULT;
@@ -281,7 +316,7 @@ asmlinkage long sys_capset(cap_user_header_t header, const cap_user_data_t data)
 		permitted.cap[i] = kdata[i].permitted;
 		inheritable.cap[i] = kdata[i].inheritable;
 	}
-	while (i < _LINUX_CAPABILITY_U32S) {
+	while (i < _KERNEL_CAPABILITY_U32S) {
 		effective.cap[i] = 0;
 		permitted.cap[i] = 0;
 		inheritable.cap[i] = 0;
