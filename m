Return-Path: <linux-kernel-owner+w=401wt.eu-S1759513AbYESMfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513AbYESMfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 08:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759467AbYESMdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 08:33:22 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:37146 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759380AbYESMdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 08:33:18 -0400
Subject: [PATCH] security:  split proc ptrace checking into read vs. attach
From: Stephen Smalley <sds@tycho.nsa.gov>
To: James Morris <jmorris@namei.org>
Cc: lsm <linux-security-module@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 19 May 2008 08:32:49 -0400
Message-Id: <1211200369.7486.38.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable security modules to distinguish reading of process state via
proc from full ptrace access by renaming ptrace_may_attach to
ptrace_may_access and adding a mode argument indicating whether only
read access or full attach access is requested.  This allows security
modules to permit access to reading process state without granting
full ptrace access.  The base DAC/capability checking remains unchanged.

Read access to /proc/pid/mem continues to apply a full ptrace attach
check since check_mem_permission() already requires the current task
to already be ptracing the target.  The other ptrace checks within
proc for elements like environ, maps, and fds are changed to pass the
read mode instead of attach.

In the SELinux case, we model such reading of process state as a
reading of a proc file labeled with the target process' label.  This
enables SELinux policy to permit such reading of process state without
permitting control or manipulation of the target process, as there are
a number of cases where programs probe for such information via proc
but do not need to be able to control the target (e.g. procps,
lsof, PolicyKit, ConsoleKit).  At present we have to choose between
allowing full ptrace in policy (more permissive than required/desired)
or breaking functionality (or in some cases just silencing the denials
via dontaudit rules but this can hide genuine attacks).

This version of the patch incorporates comments from Casey Schaufler
(change/replace existing ptrace_may_attach interface, pass access
mode), and Chris Wright (provide greater consistency in the checking).

Note that like their predecessors __ptrace_may_attach and
ptrace_may_attach, the __ptrace_may_access and ptrace_may_access
interfaces use different return value conventions from each other (0
or -errno vs. 1 or 0).  I retained this difference to avoid any
changes to the caller logic but made the difference clearer by
changing the latter interface to return a bool rather than an int and
by adding a comment about it to ptrace.h for any future callers.

Signed-off-by:  Stephen Smalley <sds@tycho.nsa.gov>

---

No change in the patch since the prior RFC.  I think this is ready for the
for-akpm branch of selinux, targeting 2.6.27.

 fs/proc/base.c             |    9 +++++----
 fs/proc/task_mmu.c         |    8 ++++----
 fs/proc/task_nommu.c       |    2 +-
 include/linux/ptrace.h     |    8 ++++++--
 include/linux/security.h   |   16 +++++++++++-----
 kernel/ptrace.c            |   15 ++++++++-------
 security/commoncap.c       |    3 ++-
 security/dummy.c           |    3 ++-
 security/security.c        |    5 +++--
 security/selinux/hooks.c   |   13 +++++++++++--
 security/smack/smack_lsm.c |    5 +++--
 11 files changed, 56 insertions(+), 31 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 808cbdc..2f92003 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -214,7 +214,7 @@ static int check_mem_permission(struct task_struct *task)
 	 */
 	if (task->parent == current && (task->ptrace & PT_PTRACED) &&
 	    task_is_stopped_or_traced(task) &&
-	    ptrace_may_attach(task))
+	    ptrace_may_access(task, PTRACE_MODE_ATTACH))
 		return 0;
 
 	/*
@@ -232,7 +232,8 @@ struct mm_struct *mm_for_maps(struct task_struct *task)
 	task_lock(task);
 	if (task->mm != mm)
 		goto out;
-	if (task->mm != current->mm && __ptrace_may_attach(task) < 0)
+	if (task->mm != current->mm &&
+	    __ptrace_may_access(task, PTRACE_MODE_READ) < 0)
 		goto out;
 	task_unlock(task);
 	return mm;
@@ -499,7 +500,7 @@ static int proc_fd_access_allowed(struct inode *inode)
 	 */
 	task = get_proc_task(inode);
 	if (task) {
-		allowed = ptrace_may_attach(task);
+		allowed = ptrace_may_access(task, PTRACE_MODE_READ);
 		put_task_struct(task);
 	}
 	return allowed;
@@ -885,7 +886,7 @@ static ssize_t environ_read(struct file *file, char __user *buf,
 	if (!task)
 		goto out_no_task;
 
-	if (!ptrace_may_attach(task))
+	if (!ptrace_may_access(task, PTRACE_MODE_READ))
 		goto out;
 
 	ret = -ENOMEM;
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e2b8e76..c6906e7 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -212,7 +212,7 @@ static int show_map(struct seq_file *m, void *v)
 	dev_t dev = 0;
 	int len;
 
-	if (maps_protect && !ptrace_may_attach(task))
+	if (maps_protect && !ptrace_may_access(task, PTRACE_MODE_READ))
 		return -EACCES;
 
 	if (file) {
@@ -631,7 +631,7 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
 		goto out;
 
 	ret = -EACCES;
-	if (!ptrace_may_attach(task))
+	if (!ptrace_may_access(task, PTRACE_MODE_READ))
 		goto out_task;
 
 	ret = -EINVAL;
@@ -669,7 +669,7 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
 	pm.out = buf;
 	pm.end = buf + count;
 
-	if (!ptrace_may_attach(task)) {
+	if (!ptrace_may_access(task, PTRACE_MODE_READ)) {
 		ret = -EIO;
 	} else {
 		unsigned long src = *ppos;
@@ -728,7 +728,7 @@ static int show_numa_map_checked(struct seq_file *m, void *v)
 	struct proc_maps_private *priv = m->private;
 	struct task_struct *task = priv->task;
 
-	if (maps_protect && !ptrace_may_attach(task))
+	if (maps_protect && !ptrace_may_access(task, PTRACE_MODE_READ))
 		return -EACCES;
 
 	return show_numa_map(m, v);
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 4b4f9cc..5d84e71 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -113,7 +113,7 @@ static int show_map(struct seq_file *m, void *_vml)
 	struct proc_maps_private *priv = m->private;
 	struct task_struct *task = priv->task;
 
-	if (maps_protect && !ptrace_may_attach(task))
+	if (maps_protect && !ptrace_may_access(task, PTRACE_MODE_READ))
 		return -EACCES;
 
 	return nommu_vma_show(m, vml->vma);
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index f98501b..c6f5f9d 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -95,8 +95,12 @@ extern void __ptrace_link(struct task_struct *child,
 			  struct task_struct *new_parent);
 extern void __ptrace_unlink(struct task_struct *child);
 extern void ptrace_untrace(struct task_struct *child);
-extern int ptrace_may_attach(struct task_struct *task);
-extern int __ptrace_may_attach(struct task_struct *task);
+#define PTRACE_MODE_READ   1
+#define PTRACE_MODE_ATTACH 2
+/* Returns 0 on success, -errno on denial. */
+extern int __ptrace_may_access(struct task_struct *task, unsigned int mode);
+/* Returns true on success, false on denial. */
+extern bool ptrace_may_access(struct task_struct *task, unsigned int mode);
 
 static inline int ptrace_reparented(struct task_struct *child)
 {
diff --git a/include/linux/security.h b/include/linux/security.h
index 50737c7..62bd80c 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -46,7 +46,8 @@ struct audit_krule;
  */
 extern int cap_capable(struct task_struct *tsk, int cap);
 extern int cap_settime(struct timespec *ts, struct timezone *tz);
-extern int cap_ptrace(struct task_struct *parent, struct task_struct *child);
+extern int cap_ptrace(struct task_struct *parent, struct task_struct *child,
+		      unsigned int mode);
 extern int cap_capget(struct task_struct *target, kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
 extern int cap_capset_check(struct task_struct *target, kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
 extern void cap_capset_set(struct task_struct *target, kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
@@ -1170,6 +1171,7 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	attributes would be changed by the execve.
  *	@parent contains the task_struct structure for parent process.
  *	@child contains the task_struct structure for child process.
+ *	@mode contains the PTRACE_MODE flags indicating the form of access.
  *	Return 0 if permission is granted.
  * @capget:
  *	Get the @effective, @inheritable, and @permitted capability sets for
@@ -1295,7 +1297,8 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
 struct security_operations {
 	char name[SECURITY_NAME_MAX + 1];
 
-	int (*ptrace) (struct task_struct *parent, struct task_struct *child);
+	int (*ptrace) (struct task_struct *parent, struct task_struct *child,
+		       unsigned int mode);
 	int (*capget) (struct task_struct *target,
 		       kernel_cap_t *effective,
 		       kernel_cap_t *inheritable, kernel_cap_t *permitted);
@@ -1573,7 +1576,8 @@ extern struct dentry *securityfs_create_dir(const char *name, struct dentry *par
 extern void securityfs_remove(struct dentry *dentry);
 
 /* Security operations */
-int security_ptrace(struct task_struct *parent, struct task_struct *child);
+int security_ptrace(struct task_struct *parent, struct task_struct *child,
+		    unsigned int mode);
 int security_capget(struct task_struct *target,
 		    kernel_cap_t *effective,
 		    kernel_cap_t *inheritable,
@@ -1755,9 +1759,11 @@ static inline int security_init(void)
 	return 0;
 }
 
-static inline int security_ptrace(struct task_struct *parent, struct task_struct *child)
+static inline int security_ptrace(struct task_struct *parent,
+				  struct task_struct *child,
+				  unsigned int mode)
 {
-	return cap_ptrace(parent, child);
+	return cap_ptrace(parent, child, mode);
 }
 
 static inline int security_capget(struct task_struct *target,
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 6c19e94..e337390 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -121,7 +121,7 @@ int ptrace_check_attach(struct task_struct *child, int kill)
 	return ret;
 }
 
-int __ptrace_may_attach(struct task_struct *task)
+int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 {
 	/* May we inspect the given task?
 	 * This check is used both for attaching with ptrace
@@ -148,16 +148,16 @@ int __ptrace_may_attach(struct task_struct *task)
 	if (!dumpable && !capable(CAP_SYS_PTRACE))
 		return -EPERM;
 
-	return security_ptrace(current, task);
+	return security_ptrace(current, task, mode);
 }
 
-int ptrace_may_attach(struct task_struct *task)
+bool ptrace_may_access(struct task_struct *task, unsigned int mode)
 {
 	int err;
 	task_lock(task);
-	err = __ptrace_may_attach(task);
+	err = __ptrace_may_access(task, mode);
 	task_unlock(task);
-	return !err;
+	return (!err ? true : false);
 }
 
 int ptrace_attach(struct task_struct *task)
@@ -195,7 +195,7 @@ repeat:
 	/* the same process cannot be attached many times */
 	if (task->ptrace & PT_PTRACED)
 		goto bad;
-	retval = __ptrace_may_attach(task);
+	retval = __ptrace_may_access(task, PTRACE_MODE_ATTACH);
 	if (retval)
 		goto bad;
 
@@ -494,7 +494,8 @@ int ptrace_traceme(void)
 	 */
 	task_lock(current);
 	if (!(current->ptrace & PT_PTRACED)) {
-		ret = security_ptrace(current->parent, current);
+		ret = security_ptrace(current->parent, current,
+				      PTRACE_MODE_ATTACH);
 		/*
 		 * Set the ptrace bit in the process ptrace flags.
 		 */
diff --git a/security/commoncap.c b/security/commoncap.c
index 5edabc7..c53855f 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -63,7 +63,8 @@ int cap_settime(struct timespec *ts, struct timezone *tz)
 	return 0;
 }
 
-int cap_ptrace (struct task_struct *parent, struct task_struct *child)
+int cap_ptrace (struct task_struct *parent, struct task_struct *child,
+		unsigned int mode)
 {
 	/* Derived from arch/i386/kernel/ptrace.c:sys_ptrace. */
 	if (!cap_issubset(child->cap_permitted, parent->cap_permitted) &&
diff --git a/security/dummy.c b/security/dummy.c
index f50c6c3..4b7f877 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -28,7 +28,8 @@
 #include <linux/ptrace.h>
 #include <linux/file.h>
 
-static int dummy_ptrace (struct task_struct *parent, struct task_struct *child)
+static int dummy_ptrace (struct task_struct *parent, struct task_struct *child,
+			 unsigned int mode)
 {
 	return 0;
 }
diff --git a/security/security.c b/security/security.c
index 59838a9..c4507ce 100644
--- a/security/security.c
+++ b/security/security.c
@@ -161,9 +161,10 @@ int mod_reg_security(const char *name, struct security_operations *ops)
 
 /* Security operations */
 
-int security_ptrace(struct task_struct *parent, struct task_struct *child)
+int security_ptrace(struct task_struct *parent, struct task_struct *child,
+		    unsigned int mode)
 {
-	return security_ops->ptrace(parent, child);
+	return security_ops->ptrace(parent, child, mode);
 }
 
 int security_capget(struct task_struct *target,
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 59c6e98..2ca9a06 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1682,14 +1682,23 @@ static inline u32 file_to_av(struct file *file)
 
 /* Hook functions begin here. */
 
-static int selinux_ptrace(struct task_struct *parent, struct task_struct *child)
+static int selinux_ptrace(struct task_struct *parent,
+			  struct task_struct *child,
+			  unsigned int mode)
 {
 	int rc;
 
-	rc = secondary_ops->ptrace(parent, child);
+	rc = secondary_ops->ptrace(parent, child, mode);
 	if (rc)
 		return rc;
 
+	if (mode == PTRACE_MODE_READ) {
+		struct task_security_struct *tsec = parent->security;
+		struct task_security_struct *csec = child->security;
+		return avc_has_perm(tsec->sid, csec->sid,
+				    SECCLASS_FILE, FILE__READ, NULL);
+	}
+
 	return task_has_perm(parent, child, PROCESS__PTRACE);
 }
 
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index b5c8f92..f2d54bc 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -95,11 +95,12 @@ struct inode_smack *new_inode_smack(char *smack)
  *
  * Do the capability checks, and require read and write.
  */
-static int smack_ptrace(struct task_struct *ptp, struct task_struct *ctp)
+static int smack_ptrace(struct task_struct *ptp, struct task_struct *ctp,
+			unsigned int mode)
 {
 	int rc;
 
-	rc = cap_ptrace(ptp, ctp);
+	rc = cap_ptrace(ptp, ctp, mode);
 	if (rc != 0)
 		return rc;
 

-- 
Stephen Smalley
National Security Agency

