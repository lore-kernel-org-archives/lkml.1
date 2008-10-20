Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbYJTW0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbYJTW0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 18:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbYJTW0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 18:26:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55620 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754612AbYJTW0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 18:26:13 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 2/4] AUDIT: output permitted and inheritable fcaps in PATH
	records
To: linux-kernel@vger.kernel.org, linux-audit@redhat.com
Cc: viro@zeniv.linux.org.ok, sgrubb@redhat.com, serue@us.ibm.com,
       morgan@kernel.org
Date: Mon, 20 Oct 2008 18:26:07 -0400
Message-ID: <20081020222607.3895.68585.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081020222538.3895.50175.stgit@paris.rdu.redhat.com>
References: <20081020222538.3895.50175.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch will print cap_permitted and cap_inheritable data in the PATH
records of any file that has file capabilities set.  Files which do not
have fcaps set will not have different PATH records.

An example audit record if you run:
setcap "cap_net_admin+pie" /bin/bash
/bin/bash

type=SYSCALL msg=audit(1224539233.882:54): arch=c000003e syscall=59 success=yes exit=0 a0=207fc80 a1=2083cb0 a2=2083c70 a3=7fffb32dff60 items=2 ppid=2326 pid=2328 auid=0 uid=500 gid=500 euid=500 suid=500 fsuid=500 egid=500 sgid=500 fsgid=500 tty=pts0 ses=1 comm="bash" exe="/bin/bash" subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=(null)
type=EXECVE msg=audit(1224539233.882:54): argc=1 a0="-bash" 
type=CWD msg=audit(1224539233.882:54):  cwd="/home/test"
type=PATH msg=audit(1224539233.882:54): item=0 name="/bin/bash" inode=49161 dev=fd:00 mode=0100755 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:shell_exec_t:s0 cap_fP=0000000000001000 cap_fI=0000000000001000 cap_fE=1 cap_fVer=2
type=PATH msg=audit(1224539233.882:54): item=1 name=(null) inode=507963 dev=fd:00 mode=0100755 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:ld_so_t:s0

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/capability.h |    5 +++
 kernel/auditsc.c           |   82 +++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 82 insertions(+), 5 deletions(-)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index 9d64a9c..3f7920b 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -53,6 +53,7 @@ typedef struct __user_cap_data_struct {
 #define XATTR_NAME_CAPS XATTR_SECURITY_PREFIX XATTR_CAPS_SUFFIX
 
 #define VFS_CAP_REVISION_MASK	0xFF000000
+#define VFS_CAP_REVISION_SHIFT	24
 #define VFS_CAP_FLAGS_MASK	~VFS_CAP_REVISION_MASK
 #define VFS_CAP_FLAGS_EFFECTIVE	0x000001
 
@@ -524,6 +525,10 @@ kernel_cap_t cap_set_effective(const kernel_cap_t pE_new);
 
 extern int capable(int cap);
 
+/* audit system wants to get cap info from files as well */
+struct dentry;
+extern int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data *cpu_caps);
+
 #endif /* __KERNEL__ */
 
 #endif /* !_LINUX_CAPABILITY_H */
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index cf5bc2f..bf1f11a 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -65,6 +65,7 @@
 #include <linux/highmem.h>
 #include <linux/syscalls.h>
 #include <linux/inotify.h>
+#include <linux/capability.h>
 
 #include "audit.h"
 
@@ -84,6 +85,15 @@ int audit_n_rules;
 /* determines whether we collect data for signals sent */
 int audit_signals;
 
+struct audit_cap_data {
+	kernel_cap_t		permitted;
+	kernel_cap_t		inheritable;
+	union {
+		unsigned int	fE;
+		kernel_cap_t	effective;
+	};
+};
+
 /* When fs/namei.c:getname() is called, we store the pointer in name and
  * we don't let putname() free it (instead we free all of the saved
  * pointers at syscall exit time).
@@ -100,6 +110,8 @@ struct audit_names {
 	gid_t		gid;
 	dev_t		rdev;
 	u32		osid;
+	struct audit_cap_data fcap;
+	unsigned int	fcap_ver;
 };
 
 struct audit_aux_data {
@@ -1171,6 +1183,35 @@ static void audit_log_execve_info(struct audit_context *context,
 	kfree(buf);
 }
 
+static void audit_log_cap(struct audit_buffer *ab, char *prefix, kernel_cap_t *cap)
+{
+	int i;
+
+	audit_log_format(ab, " %s=", prefix);
+	CAP_FOR_EACH_U32(i) {
+		audit_log_format(ab, "%08x", cap->cap[(_KERNEL_CAPABILITY_U32S-1) - i]);
+	}
+}
+
+static void audit_log_fcaps(struct audit_buffer *ab, struct audit_names *name)
+{
+	kernel_cap_t *perm = &name->fcap.permitted;
+	kernel_cap_t *inh = &name->fcap.inheritable;
+	int log = 0;
+
+	if (!cap_isclear(*perm)) {
+		audit_log_cap(ab, "cap_fP", perm);
+		log = 1;
+	}
+	if (!cap_isclear(*inh)) {
+		audit_log_cap(ab, "cap_fI", inh);
+		log = 1;
+	}
+
+	if (log)
+		audit_log_format(ab, " cap_fE=%d cap_fVer=%x", name->fcap.fE, name->fcap_ver);
+}
+
 static void audit_log_exit(struct audit_context *context, struct task_struct *tsk)
 {
 	int i, call_panic = 0;
@@ -1421,6 +1462,8 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 			}
 		}
 
+		audit_log_fcaps(ab, n);
+
 		audit_log_end(ab);
 	}
 
@@ -1787,8 +1830,36 @@ static int audit_inc_name_count(struct audit_context *context,
 	return 0;
 }
 
+
+static inline int audit_copy_fcaps(struct audit_names *name, const struct dentry *dentry)
+{
+	struct cpu_vfs_cap_data caps;
+	int rc;
+
+	memset(&name->fcap.permitted, 0, sizeof(kernel_cap_t));
+	memset(&name->fcap.inheritable, 0, sizeof(kernel_cap_t));
+	name->fcap.fE = 0;
+	name->fcap_ver = 0;
+
+	if (!dentry)
+		return 0;
+
+	rc = get_vfs_caps_from_disk(dentry, &caps);
+	if (rc)
+		return rc;
+
+	name->fcap.permitted = caps.permitted;
+	name->fcap.inheritable = caps.inheritable;
+	name->fcap.fE = !!(caps.magic_etc & VFS_CAP_FLAGS_EFFECTIVE);
+	name->fcap_ver = (caps.magic_etc & VFS_CAP_REVISION_MASK) >> VFS_CAP_REVISION_SHIFT;
+	
+	return 0;
+}
+
+
 /* Copy inode data into an audit_names. */
-static void audit_copy_inode(struct audit_names *name, const struct inode *inode)
+static void audit_copy_inode(struct audit_names *name, const struct dentry *dentry,
+			     const struct inode *inode)
 {
 	name->ino   = inode->i_ino;
 	name->dev   = inode->i_sb->s_dev;
@@ -1797,6 +1868,7 @@ static void audit_copy_inode(struct audit_names *name, const struct inode *inode
 	name->gid   = inode->i_gid;
 	name->rdev  = inode->i_rdev;
 	security_inode_getsecid(inode, &name->osid);
+	audit_copy_fcaps(name, dentry);
 }
 
 /**
@@ -1831,7 +1903,7 @@ void __audit_inode(const char *name, const struct dentry *dentry)
 		context->names[idx].name = NULL;
 	}
 	handle_path(dentry);
-	audit_copy_inode(&context->names[idx], inode);
+	audit_copy_inode(&context->names[idx], dentry, inode);
 }
 
 /**
@@ -1892,7 +1964,7 @@ void __audit_inode_child(const char *dname, const struct dentry *dentry,
 		if (!strcmp(dname, n->name) ||
 		     !audit_compare_dname_path(dname, n->name, &dirlen)) {
 			if (inode)
-				audit_copy_inode(n, inode);
+				audit_copy_inode(n, NULL, inode);
 			else
 				n->ino = (unsigned long)-1;
 			found_child = n->name;
@@ -1906,7 +1978,7 @@ add_names:
 			return;
 		idx = context->name_count - 1;
 		context->names[idx].name = NULL;
-		audit_copy_inode(&context->names[idx], parent);
+		audit_copy_inode(&context->names[idx], NULL, parent);
 	}
 
 	if (!found_child) {
@@ -1927,7 +1999,7 @@ add_names:
 		}
 
 		if (inode)
-			audit_copy_inode(&context->names[idx], inode);
+			audit_copy_inode(&context->names[idx], NULL, inode);
 		else
 			context->names[idx].ino = (unsigned long)-1;
 	}

