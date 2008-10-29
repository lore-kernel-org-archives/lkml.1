Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbYJ2THm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbYJ2THm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 15:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbYJ2THK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 15:07:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37666 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbYJ2THG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 15:07:06 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v1 1/3] SECURITY: new capable_noaudit interface
To: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Cc: sds@tycho.nsa.gov, jmorris@nameil.org, serue@us.ibm.com, morgan@kernel.org,
       casey@schaufler-ca.com, esandeen@redhat.com
Date: Wed, 29 Oct 2008 15:06:52 -0400
Message-ID: <20081029190652.31292.5901.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new capable interface that will be used by systems that use audit to
make an A or B type decision instead of a security decision.  Currently
this is the case at least for filesystems when deciding if a process can use
the reserved 'root' blocks and for the case of things like the oom
algorithm determining if processes are root processes and should be less
likely to be killed.  These types of security system requests should not be
audited or logged since they are not really security decisions.  It would be
possible to solve this problem like the vm_enough_memory security check did
by creating a new LSM interface and moving all of the policy into that
interface but proves the needlessly bloat the LSM and provide complex
indirection.

This merely allows those decisions to be made where they belong and to not
flood logs or printk with denials for thing that are not security decisions.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/capability.h |    1 +
 include/linux/security.h   |   12 +++++++++---
 security/commoncap.c       |    8 ++++----
 security/security.c        |    7 ++++++-
 security/selinux/hooks.c   |   20 +++++++++++++-------
 5 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index 9d1fe30..67b6fa9 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -514,6 +514,7 @@ kernel_cap_t cap_set_effective(const kernel_cap_t pE_new);
  * Note that this does not set PF_SUPERPRIV on the task.
  */
 #define has_capability(t, cap) (security_capable((t), (cap)) == 0)
+#define has_capability_noaudit(t, cap) (security_capable_noaudit((t), (cap)) == 0)
 
 extern int capable(int cap);
 
diff --git a/include/linux/security.h b/include/linux/security.h
index f5c4a51..88375e4 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -44,7 +44,7 @@ struct audit_krule;
  * These functions are in security/capability.c and are used
  * as the default capabilities functions
  */
-extern int cap_capable(struct task_struct *tsk, int cap);
+extern int cap_capable(struct task_struct *tsk, int cap, int audit);
 extern int cap_settime(struct timespec *ts, struct timezone *tz);
 extern int cap_ptrace_may_access(struct task_struct *child, unsigned int mode);
 extern int cap_ptrace_traceme(struct task_struct *parent);
@@ -1307,7 +1307,7 @@ struct security_operations {
 			    kernel_cap_t *effective,
 			    kernel_cap_t *inheritable,
 			    kernel_cap_t *permitted);
-	int (*capable) (struct task_struct *tsk, int cap);
+	int (*capable) (struct task_struct *tsk, int cap, int audit);
 	int (*acct) (struct file *file);
 	int (*sysctl) (struct ctl_table *table, int op);
 	int (*quotactl) (int cmds, int type, int id, struct super_block *sb);
@@ -1577,6 +1577,7 @@ void security_capset_set(struct task_struct *target,
 			 kernel_cap_t *inheritable,
 			 kernel_cap_t *permitted);
 int security_capable(struct task_struct *tsk, int cap);
+int security_capable_noaudit(struct task_struct *tsk, int cap);
 int security_acct(struct file *file);
 int security_sysctl(struct ctl_table *table, int op);
 int security_quotactl(int cmds, int type, int id, struct super_block *sb);
@@ -1781,7 +1782,12 @@ static inline void security_capset_set(struct task_struct *target,
 
 static inline int security_capable(struct task_struct *tsk, int cap)
 {
-	return cap_capable(tsk, cap);
+	return cap_capable(tsk, cap, 1);
+}
+
+static inline int security_capable_noaudit(struct task_struct *tsk, int cap)
+{
+	return cap_capable(tsk, cap, 0);
 }
 
 static inline int security_acct(struct file *file)
diff --git a/security/commoncap.c b/security/commoncap.c
index 399bfdb..243e223 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -48,7 +48,7 @@ EXPORT_SYMBOL(cap_netlink_recv);
  * returns 0 when a task has a capability, but the kernel's capable()
  * returns 1 for this case.
  */
-int cap_capable (struct task_struct *tsk, int cap)
+int cap_capable(struct task_struct *tsk, int cap, int audit)
 {
 	/* Derived from include/linux/sched.h:capable. */
 	if (cap_raised(tsk->cap_effective, cap))
@@ -111,7 +111,7 @@ static inline int cap_inh_is_capped(void)
 	 * to the old permitted set. That is, if the current task
 	 * does *not* possess the CAP_SETPCAP capability.
 	 */
-	return (cap_capable(current, CAP_SETPCAP) != 0);
+	return (cap_capable(current, CAP_SETPCAP, 1) != 0);
 }
 
 static inline int cap_limit_ptraced_target(void) { return 1; }
@@ -640,7 +640,7 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 		    || ((current->securebits & SECURE_ALL_LOCKS
 			 & ~arg2))                                    /*[2]*/
 		    || (arg2 & ~(SECURE_ALL_LOCKS | SECURE_ALL_BITS)) /*[3]*/
-		    || (cap_capable(current, CAP_SETPCAP) != 0)) {    /*[4]*/
+		    || (cap_capable(current, CAP_SETPCAP, 1) != 0)) { /*[4]*/
 			/*
 			 * [1] no changing of bits that are locked
 			 * [2] no unlocking of locks
@@ -705,7 +705,7 @@ int cap_vm_enough_memory(struct mm_struct *mm, long pages)
 {
 	int cap_sys_admin = 0;
 
-	if (cap_capable(current, CAP_SYS_ADMIN) == 0)
+	if (cap_capable(current, CAP_SYS_ADMIN, 0) == 0)
 		cap_sys_admin = 1;
 	return __vm_enough_memory(mm, pages, cap_sys_admin);
 }
diff --git a/security/security.c b/security/security.c
index 255b085..271f9a7 100644
--- a/security/security.c
+++ b/security/security.c
@@ -163,7 +163,12 @@ void security_capset_set(struct task_struct *target,
 
 int security_capable(struct task_struct *tsk, int cap)
 {
-	return security_ops->capable(tsk, cap);
+	return security_ops->capable(tsk, cap, 1);
+}
+
+int security_capable_noaudit(struct task_struct *tsk, int cap)
+{
+	return security_ops->capable(tsk, cap, 0);
 }
 
 int security_acct(struct file *file)
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 3e3fde7..74a28bc 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1365,12 +1365,14 @@ static int task_has_perm(struct task_struct *tsk1,
 
 /* Check whether a task is allowed to use a capability. */
 static int task_has_capability(struct task_struct *tsk,
-			       int cap)
+			       int cap, int audit)
 {
 	struct task_security_struct *tsec;
 	struct avc_audit_data ad;
+	struct av_decision avd;
 	u16 sclass;
 	u32 av = CAP_TO_MASK(cap);
+	int rc;
 
 	tsec = tsk->security;
 
@@ -1390,7 +1392,11 @@ static int task_has_capability(struct task_struct *tsk,
 		       "SELinux:  out of range capability %d\n", cap);
 		BUG();
 	}
-	return avc_has_perm(tsec->sid, tsec->sid, sclass, av, &ad);
+
+	rc = avc_has_perm_noaudit(tsec->sid, tsec->sid, sclass, av, 0, &avd);
+	if (audit)
+		avc_audit(tsec->sid, tsec->sid, sclass, av, &avd, rc, &ad);
+	return rc;
 }
 
 /* Check whether a task is allowed to use a system operation. */
@@ -1801,15 +1807,15 @@ static void selinux_capset_set(struct task_struct *target, kernel_cap_t *effecti
 	secondary_ops->capset_set(target, effective, inheritable, permitted);
 }
 
-static int selinux_capable(struct task_struct *tsk, int cap)
+static int selinux_capable(struct task_struct *tsk, int cap, int audit)
 {
 	int rc;
 
-	rc = secondary_ops->capable(tsk, cap);
+	rc = secondary_ops->capable(tsk, cap, audit);
 	if (rc)
 		return rc;
 
-	return task_has_capability(tsk, cap);
+	return task_has_capability(tsk, cap, audit);
 }
 
 static int selinux_sysctl_get_sid(ctl_table *table, u16 tclass, u32 *sid)
@@ -1974,7 +1980,7 @@ static int selinux_vm_enough_memory(struct mm_struct *mm, long pages)
 	int rc, cap_sys_admin = 0;
 	struct task_security_struct *tsec = current->security;
 
-	rc = secondary_ops->capable(current, CAP_SYS_ADMIN);
+	rc = secondary_ops->capable(current, CAP_SYS_ADMIN, 0);
 	if (rc == 0)
 		rc = avc_has_perm_noaudit(tsec->sid, tsec->sid,
 					  SECCLASS_CAPABILITY,
@@ -2819,7 +2825,7 @@ static int selinux_inode_getsecurity(const struct inode *inode, const char *name
 	 * and lack of permission just means that we fall back to the
 	 * in-core context value, not a denial.
 	 */
-	error = secondary_ops->capable(current, CAP_MAC_ADMIN);
+	error = secondary_ops->capable(current, CAP_MAC_ADMIN, 1);
 	if (!error)
 		error = avc_has_perm_noaudit(tsec->sid, tsec->sid,
 					     SECCLASS_CAPABILITY2,

