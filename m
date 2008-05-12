Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759AbYELMkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbYELMkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 08:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559AbYELMkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 08:40:19 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:42552 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564AbYELMkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 08:40:16 -0400
Subject: [RFC][PATCH] security:  split ptrace checking in proc
From: Stephen Smalley <sds@tycho.nsa.gov>
To: lsm <linux-security-module@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 12 May 2008 08:39:59 -0400
Message-Id: <1210595999.6206.30.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable security modules to distinguish reading of process state
information from full ptrace access by introducing a distinct helper
function for such checks and passing a boolean flag down to the
security_ptrace hook.  This allows security modules to permit access
to reading process state without granting full ptrace access.

The patch only changes the environ and open file checking in proc.
Other cases such as mem and maps checking still use a full ptrace
check at present.

In the SELinux case, we model such reading of process state as a
reading of the proc file labeled with the process' label.  This enables
SELinux policy to permit such reading of process state without permitting control
or manipulation of the target process, as there are a number of cases
where programs probe for such information via proc but do not need to
be able to control the target.  This restores SELinux behavior prior to
2.6.18.

Signed-off-by:  Stephen Smalley <sds@tycho.nsa.gov>

---

 fs/proc/base.c             |    4 ++--
 include/linux/ptrace.h     |    1 +
 include/linux/security.h   |   15 ++++++++++-----
 kernel/ptrace.c            |   20 +++++++++++++++++---
 security/commoncap.c       |    3 ++-
 security/dummy.c           |    3 ++-
 security/security.c        |    5 +++--
 security/selinux/hooks.c   |   13 +++++++++++--
 security/smack/smack_lsm.c |    5 +++--
 9 files changed, 51 insertions(+), 18 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 808cbdc..bbc74a0 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -499,7 +499,7 @@ static int proc_fd_access_allowed(struct inode *inode)
 	 */
 	task = get_proc_task(inode);
 	if (task) {
-		allowed = ptrace_may_attach(task);
+		allowed = ptrace_may_readstate(task);
 		put_task_struct(task);
 	}
 	return allowed;
@@ -885,7 +885,7 @@ static ssize_t environ_read(struct file *file, char __user *buf,
 	if (!task)
 		goto out_no_task;
 
-	if (!ptrace_may_attach(task))
+	if (!ptrace_may_readstate(task))
 		goto out;
 
 	ret = -ENOMEM;
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index f98501b..f8a5e75 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -97,6 +97,7 @@ extern void __ptrace_unlink(struct task_struct *child);
 extern void ptrace_untrace(struct task_struct *child);
 extern int ptrace_may_attach(struct task_struct *task);
 extern int __ptrace_may_attach(struct task_struct *task);
+extern int ptrace_may_readstate(struct task_struct *task);
 
 static inline int ptrace_reparented(struct task_struct *child)
 {
diff --git a/include/linux/security.h b/include/linux/security.h
index 50737c7..8841322 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -46,7 +46,8 @@ struct audit_krule;
  */
 extern int cap_capable(struct task_struct *tsk, int cap);
 extern int cap_settime(struct timespec *ts, struct timezone *tz);
-extern int cap_ptrace(struct task_struct *parent, struct task_struct *child);
+extern int cap_ptrace(struct task_struct *parent, struct task_struct *child,
+		      bool readstate);
 extern int cap_capget(struct task_struct *target, kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
 extern int cap_capset_check(struct task_struct *target, kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
 extern void cap_capset_set(struct task_struct *target, kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
@@ -1170,6 +1171,7 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	attributes would be changed by the execve.
  *	@parent contains the task_struct structure for parent process.
  *	@child contains the task_struct structure for child process.
+ *	@readstate is true if this is only a check for reading state from proc.
  *	Return 0 if permission is granted.
  * @capget:
  *	Get the @effective, @inheritable, and @permitted capability sets for
@@ -1295,7 +1297,8 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
 struct security_operations {
 	char name[SECURITY_NAME_MAX + 1];
 
-	int (*ptrace) (struct task_struct *parent, struct task_struct *child);
+	int (*ptrace) (struct task_struct *parent, struct task_struct *child,
+		       bool readstate);
 	int (*capget) (struct task_struct *target,
 		       kernel_cap_t *effective,
 		       kernel_cap_t *inheritable, kernel_cap_t *permitted);
@@ -1573,7 +1576,8 @@ extern struct dentry *securityfs_create_dir(const char *name, struct dentry *par
 extern void securityfs_remove(struct dentry *dentry);
 
 /* Security operations */
-int security_ptrace(struct task_struct *parent, struct task_struct *child);
+int security_ptrace(struct task_struct *parent, struct task_struct *child,
+		    bool readstate);
 int security_capget(struct task_struct *target,
 		    kernel_cap_t *effective,
 		    kernel_cap_t *inheritable,
@@ -1755,9 +1759,10 @@ static inline int security_init(void)
 	return 0;
 }
 
-static inline int security_ptrace(struct task_struct *parent, struct task_struct *child)
+static inline int security_ptrace(struct task_struct *parent,
+				  struct task_struct *child, bool readstate)
 {
-	return cap_ptrace(parent, child);
+	return cap_ptrace(parent, child, readstate);
 }
 
 static inline int security_capget(struct task_struct *target,
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 6c19e94..4b8b3d4 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -121,7 +121,7 @@ int ptrace_check_attach(struct task_struct *child, int kill)
 	return ret;
 }
 
-int __ptrace_may_attach(struct task_struct *task)
+static int ptrace_may_inspect(struct task_struct *task, bool readstate)
 {
 	/* May we inspect the given task?
 	 * This check is used both for attaching with ptrace
@@ -148,7 +148,12 @@ int __ptrace_may_attach(struct task_struct *task)
 	if (!dumpable && !capable(CAP_SYS_PTRACE))
 		return -EPERM;
 
-	return security_ptrace(current, task);
+	return security_ptrace(current, task, readstate);
+}
+
+int __ptrace_may_attach(struct task_struct *task)
+{
+	return ptrace_may_inspect(task, false);
 }
 
 int ptrace_may_attach(struct task_struct *task)
@@ -160,6 +165,15 @@ int ptrace_may_attach(struct task_struct *task)
 	return !err;
 }
 
+int ptrace_may_readstate(struct task_struct *task)
+{
+	int err;
+	task_lock(task);
+	err = ptrace_may_inspect(task, true);
+	task_unlock(task);
+	return !err;
+}
+
 int ptrace_attach(struct task_struct *task)
 {
 	int retval;
@@ -494,7 +508,7 @@ int ptrace_traceme(void)
 	 */
 	task_lock(current);
 	if (!(current->ptrace & PT_PTRACED)) {
-		ret = security_ptrace(current->parent, current);
+		ret = security_ptrace(current->parent, current, false);
 		/*
 		 * Set the ptrace bit in the process ptrace flags.
 		 */
diff --git a/security/commoncap.c b/security/commoncap.c
index 5edabc7..5cdb370 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -63,7 +63,8 @@ int cap_settime(struct timespec *ts, struct timezone *tz)
 	return 0;
 }
 
-int cap_ptrace (struct task_struct *parent, struct task_struct *child)
+int cap_ptrace (struct task_struct *parent, struct task_struct *child,
+		bool readstate)
 {
 	/* Derived from arch/i386/kernel/ptrace.c:sys_ptrace. */
 	if (!cap_issubset(child->cap_permitted, parent->cap_permitted) &&
diff --git a/security/dummy.c b/security/dummy.c
index f50c6c3..94b5836 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -28,7 +28,8 @@
 #include <linux/ptrace.h>
 #include <linux/file.h>
 
-static int dummy_ptrace (struct task_struct *parent, struct task_struct *child)
+static int dummy_ptrace (struct task_struct *parent, struct task_struct *child,
+			 bool readstate)
 {
 	return 0;
 }
diff --git a/security/security.c b/security/security.c
index 59838a9..7867665 100644
--- a/security/security.c
+++ b/security/security.c
@@ -161,9 +161,10 @@ int mod_reg_security(const char *name, struct security_operations *ops)
 
 /* Security operations */
 
-int security_ptrace(struct task_struct *parent, struct task_struct *child)
+int security_ptrace(struct task_struct *parent, struct task_struct *child,
+		    bool readstate)
 {
-	return security_ops->ptrace(parent, child);
+	return security_ops->ptrace(parent, child, readstate);
 }
 
 int security_capget(struct task_struct *target,
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 59c6e98..d30bb92 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1682,14 +1682,23 @@ static inline u32 file_to_av(struct file *file)
 
 /* Hook functions begin here. */
 
-static int selinux_ptrace(struct task_struct *parent, struct task_struct *child)
+static int selinux_ptrace(struct task_struct *parent,
+			  struct task_struct *child,
+			  bool readstate)
 {
 	int rc;
 
-	rc = secondary_ops->ptrace(parent, child);
+	rc = secondary_ops->ptrace(parent, child, readstate);
 	if (rc)
 		return rc;
 
+	if (readstate) {
+		struct task_security_struct *tsec = parent->security;
+		struct task_security_struct *csec = child->security;
+		return avc_has_perm(tsec->sid, csec->sid,
+				    SECCLASS_FILE, FILE__READ, NULL);
+	}
+
 	return task_has_perm(parent, child, PROCESS__PTRACE);
 }
 
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index b5c8f92..88f158e 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -95,11 +95,12 @@ struct inode_smack *new_inode_smack(char *smack)
  *
  * Do the capability checks, and require read and write.
  */
-static int smack_ptrace(struct task_struct *ptp, struct task_struct *ctp)
+static int smack_ptrace(struct task_struct *ptp, struct task_struct *ctp,
+			bool readstate)
 {
 	int rc;
 
-	rc = cap_ptrace(ptp, ctp);
+	rc = cap_ptrace(ptp, ctp, readstate);
 	if (rc != 0)
 		return rc;
 

-- 
Stephen Smalley
National Security Agency

