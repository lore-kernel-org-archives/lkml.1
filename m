Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbYCZWrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbYCZWrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 18:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbYCZWre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 18:47:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400AbYCZWrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 18:47:33 -0400
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] selinux: remove ptrace_sid
X-Windows: complex nonsolutions to simple nonproblems.
Message-Id: <20080326224639.50F8726FA1C@magilla.localdomain>
Date: Wed, 26 Mar 2008 15:46:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes checks related to ptrace to get rid of the ptrace_sid
tracking.  It's good to disentangle the security model from the
ptrace implementation internals.  It's sufficient to check against
the SID of the ptracer at the time a tracee attempts a transition.

Signed-off-by: Roland McGrath <roland@redhat.com>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
---
 security/selinux/hooks.c          |   71 ++++++++++++++++++++++++------------
 security/selinux/include/objsec.h |    1 -
 2 files changed, 47 insertions(+), 25 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 41a049f..ef9eb7e 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -162,7 +162,7 @@ static int task_alloc_security(struct task_struct *task)
 		return -ENOMEM;
 
 	tsec->task = task;
-	tsec->osid = tsec->sid = tsec->ptrace_sid = SECINITSID_UNLABELED;
+	tsec->osid = tsec->sid = SECINITSID_UNLABELED;
 	task->security = tsec;
 
 	return 0;
@@ -1638,19 +1638,13 @@ static inline u32 file_to_av(struct file *file)
 
 static int selinux_ptrace(struct task_struct *parent, struct task_struct *child)
 {
-	struct task_security_struct *psec = parent->security;
-	struct task_security_struct *csec = child->security;
 	int rc;
 
 	rc = secondary_ops->ptrace(parent,child);
 	if (rc)
 		return rc;
 
-	rc = task_has_perm(parent, child, PROCESS__PTRACE);
-	/* Save the SID of the tracing process for later use in apply_creds. */
-	if (!(child->ptrace & PT_PTRACED) && !rc)
-		csec->ptrace_sid = psec->sid;
-	return rc;
+	return task_has_perm(parent, child, PROCESS__PTRACE);
 }
 
 static int selinux_capget(struct task_struct *target, kernel_cap_t *effective,
@@ -1872,6 +1866,22 @@ static int selinux_vm_enough_memory(struct mm_struct *mm, long pages)
 	return __vm_enough_memory(mm, pages, cap_sys_admin);
 }
 
+/**
+ * task_tracer_task - return the task that is tracing the given task
+ * @task:		task to consider
+ *
+ * Returns NULL if noone is tracing @task, or the &struct task_struct
+ * pointer to its tracer.
+ *
+ * Must be called under rcu_read_lock().
+ */
+static struct task_struct *task_tracer_task(struct task_struct *task)
+{
+	if (task->ptrace & PT_PTRACED)
+		return rcu_dereference(task->parent);
+	return NULL;
+}
+
 /* binprm security operations */
 
 static int selinux_bprm_alloc_security(struct linux_binprm *bprm)
@@ -2119,12 +2129,25 @@ static void selinux_bprm_apply_creds(struct linux_binprm *bprm, int unsafe)
 		/* Check for ptracing, and update the task SID if ok.
 		   Otherwise, leave SID unchanged and kill. */
 		if (unsafe & (LSM_UNSAFE_PTRACE | LSM_UNSAFE_PTRACE_CAP)) {
-			rc = avc_has_perm(tsec->ptrace_sid, sid,
-					  SECCLASS_PROCESS, PROCESS__PTRACE,
-					  NULL);
-			if (rc) {
-				bsec->unsafe = 1;
-				return;
+			struct task_struct *tracer;
+			struct task_security_struct *sec;
+			u32 ptsid = 0;
+
+			rcu_read_lock();
+			tracer = task_tracer_task(current);
+			if (likely(tracer != NULL)) {
+				sec = tracer->security;
+				ptsid = sec->sid;
+			}
+			rcu_read_unlock();
+
+			if (ptsid != 0) {
+				rc = avc_has_perm(ptsid, sid, SECCLASS_PROCESS,
+						  PROCESS__PTRACE, NULL);
+				if (rc) {
+					bsec->unsafe = 1;
+					return;
+				}
 			}
 		}
 		tsec->sid = sid;
@@ -3080,11 +3103,6 @@ static int selinux_task_alloc_security(struct task_struct *tsk)
 	tsec2->keycreate_sid = tsec1->keycreate_sid;
 	tsec2->sockcreate_sid = tsec1->sockcreate_sid;
 
-	/* Retain ptracer SID across fork, if any.
-	   This will be reset by the ptrace hook upon any
-	   subsequent ptrace_attach operations. */
-	tsec2->ptrace_sid = tsec1->ptrace_sid;
-
 	return 0;
 }
 
@@ -5050,6 +5068,7 @@ static int selinux_setprocattr(struct task_struct *p,
 			       char *name, void *value, size_t size)
 {
 	struct task_security_struct *tsec;
+	struct task_struct *tracer;
 	u32 sid = 0;
 	int error;
 	char *str = value;
@@ -5138,18 +5157,24 @@ static int selinux_setprocattr(struct task_struct *p,
 		/* Check for ptracing, and update the task SID if ok.
 		   Otherwise, leave SID unchanged and fail. */
 		task_lock(p);
-		if (p->ptrace & PT_PTRACED) {
-			error = avc_has_perm_noaudit(tsec->ptrace_sid, sid,
+		rcu_read_lock();
+		tracer = task_tracer_task(p);
+		if (tracer != NULL) {
+			struct task_security_struct *ptsec = tracer->security;
+			u32 ptsid = ptsec->sid;
+			rcu_read_unlock();
+			error = avc_has_perm_noaudit(ptsid, sid,
 						     SECCLASS_PROCESS,
 						     PROCESS__PTRACE, 0, &avd);
 			if (!error)
 				tsec->sid = sid;
 			task_unlock(p);
-			avc_audit(tsec->ptrace_sid, sid, SECCLASS_PROCESS,
+			avc_audit(ptsid, sid, SECCLASS_PROCESS,
 				  PROCESS__PTRACE, &avd, error, NULL);
 			if (error)
 				return error;
 		} else {
+			rcu_read_unlock();
 			tsec->sid = sid;
 			task_unlock(p);
 		}
@@ -5624,5 +5649,3 @@ int selinux_disable(void)
 	return 0;
 }
 #endif
-
-
diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
index c6c2bb4..1db31c2 100644
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -35,7 +35,6 @@ struct task_security_struct {
 	u32 create_sid;      /* fscreate SID */
 	u32 keycreate_sid;   /* keycreate SID */
 	u32 sockcreate_sid;  /* fscreate SID */
-	u32 ptrace_sid;      /* SID of ptrace parent */
 };
 
 struct inode_security_struct {
