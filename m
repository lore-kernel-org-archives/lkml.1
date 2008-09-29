Return-Path: <linux-kernel-owner+w=401wt.eu-S1753445AbYI2VyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbYI2VyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 17:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbYI2Vxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 17:53:51 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58592 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbYI2Vxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 17:53:49 -0400
Date: Mon, 29 Sep 2008 16:53:49 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 5/6] file capabilities: remove needless inline functions
Message-ID: <20080929215349.GA10126@us.ibm.com>
References: <1222482472-12847-1-git-send-email-serue@us.ibm.com> <7004aef68d149ffb4a11835f37469948496ffc18.1222451103.git.serue@us.ibm.com> <89d3843fc1aaf91ded89d741b2e6d425508e0146.1222451103.git.serue@us.ibm.com> <178a4b5984b7559cb5cdb93b242484386ec3e3ab.1222451103.git.serue@us.ibm.com> <c9c64bbdfd3f1c665f0d1b08b82f77622be701cc.1222451103.git.serue@us.ibm.com> <06b2774a667bc535442305193417ff1a479ef1aa.1222451103.git.serue@us.ibm.com> <48DDB8F5.7040208@kernel.org> <20080927134007.GB10978@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080927134007.GB10978@us.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge E. Hallyn (serue@us.ibm.com):
> Quoting Andrew G. Morgan (morgan@kernel.org):
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> > 
> > Serge,
> > 
> > I'd much rather simply remove the target argument from the
> > security_capset_check() call. Relying on the caller to not do something
> 
> Yes, I did do that in a patch on top of all of these.  It increased the
> kernel size by 8 (or was it 16) bytes :)  I assume that was because
> now there were more references to 'current' which is inlined?  So I
> should be able to fix that by saving current() away at the top of
> the fn.
> 
> Will try that.
> 
> thanks,
> -serge
> 
> > bad seems fragile... If the code internally operates on current only,
> > then it doesn't need a target argument... No? (Evidently, such a change
> > is also needed to selinux_capset_check() too, but this doesn't look like
> > it will pose a problem for the selinux code.)

Here is a patch (on top of the others) doing that.

thanks,
-serge

Subject: [PATCH] capabilities: remove target argument from capset_check and set

Since it is no longer possible to set capabilities on another task,
remove the 'target' option from capset_set and capset_check.

Since the userspace API shouldn't change, we maintain 'pid' as a
valid option to the actual sys_capset(), continuing to return
-EPERM when pid is not current's pid.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>

---

 include/linux/security.h |   49 ++++++++++++++++------------------------------
 kernel/capability.c      |    6 ++----
 security/commoncap.c     |   29 +++++++++++++++------------
 security/security.c      |   18 ++++++++---------
 security/selinux/hooks.c |   15 ++++++++------
 5 files changed, 51 insertions(+), 66 deletions(-)

35b1a7906d26fd10da34e5cd350470abb812a91c
diff --git a/include/linux/security.h b/include/linux/security.h
index 80c4d00..7b9f7a2 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -49,8 +49,8 @@ extern int cap_settime(struct timespec *
 extern int cap_ptrace_may_access(struct task_struct *child, unsigned int mode);
 extern int cap_ptrace_traceme(struct task_struct *parent);
 extern int cap_capget(struct task_struct *target, kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
-extern int cap_capset_check(struct task_struct *target, kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
-extern void cap_capset_set(struct task_struct *target, kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
+extern int cap_capset_check(kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
+extern void cap_capset_set(kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
 extern int cap_bprm_set_security(struct linux_binprm *bprm);
 extern void cap_bprm_apply_creds(struct linux_binprm *bprm, int unsafe);
 extern int cap_bprm_secureexec(struct linux_binprm *bprm);
@@ -1187,24 +1187,15 @@ static inline void security_free_mnt_opt
  *	Return 0 if the capability sets were successfully obtained.
  * @capset_check:
  *	Check permission before setting the @effective, @inheritable, and
- *	@permitted capability sets for the @target process.
- *	Caveat:  @target is also set to current if a set of processes is
- *	specified (i.e. all processes other than current and init or a
- *	particular process group).  Hence, the capset_set hook may need to
- *	revalidate permission to the actual target process.
- *	@target contains the task_struct structure for target process.
+ *	@permitted capability sets for the current process.
  *	@effective contains the effective capability set.
  *	@inheritable contains the inheritable capability set.
  *	@permitted contains the permitted capability set.
  *	Return 0 if permission is granted.
  * @capset_set:
  *	Set the @effective, @inheritable, and @permitted capability sets for
- *	the @target process.  Since capset_check cannot always check permission
- *	to the real @target process, this hook may also perform permission
- *	checking to determine if the current process is allowed to set the
- *	capability sets of the @target process.  However, this hook has no way
- *	of returning an error due to the structure of the sys_capset code.
- *	@target contains the task_struct structure for target process.
+ *	the current process.  This hook has no way of returning an error due to
+ *	the structure of the sys_capset code.
  *	@effective contains the effective capability set.
  *	@inheritable contains the inheritable capability set.
  *	@permitted contains the permitted capability set.
@@ -1299,12 +1290,10 @@ struct security_operations {
 	int (*capget) (struct task_struct *target,
 		       kernel_cap_t *effective,
 		       kernel_cap_t *inheritable, kernel_cap_t *permitted);
-	int (*capset_check) (struct task_struct *target,
-			     kernel_cap_t *effective,
+	int (*capset_check) (kernel_cap_t *effective,
 			     kernel_cap_t *inheritable,
 			     kernel_cap_t *permitted);
-	void (*capset_set) (struct task_struct *target,
-			    kernel_cap_t *effective,
+	void (*capset_set) (kernel_cap_t *effective,
 			    kernel_cap_t *inheritable,
 			    kernel_cap_t *permitted);
 	int (*capable) (struct task_struct *tsk, int cap);
@@ -1573,12 +1562,10 @@ int security_capget(struct task_struct *
 		    kernel_cap_t *effective,
 		    kernel_cap_t *inheritable,
 		    kernel_cap_t *permitted);
-int security_capset_check(struct task_struct *target,
-			  kernel_cap_t *effective,
+int security_capset_check(kernel_cap_t *effective,
 			  kernel_cap_t *inheritable,
 			  kernel_cap_t *permitted);
-void security_capset_set(struct task_struct *target,
-			 kernel_cap_t *effective,
+void security_capset_set(kernel_cap_t *effective,
 			 kernel_cap_t *inheritable,
 			 kernel_cap_t *permitted);
 int security_capable(struct task_struct *tsk, int cap);
@@ -1768,20 +1755,18 @@ static inline int security_capget(struct
 	return cap_capget(target, effective, inheritable, permitted);
 }
 
-static inline int security_capset_check(struct task_struct *target,
-					 kernel_cap_t *effective,
-					 kernel_cap_t *inheritable,
-					 kernel_cap_t *permitted)
+static inline int security_capset_check(kernel_cap_t *effective,
+					kernel_cap_t *inheritable,
+					kernel_cap_t *permitted)
 {
-	return cap_capset_check(target, effective, inheritable, permitted);
+	return cap_capset_check(effective, inheritable, permitted);
 }
 
-static inline void security_capset_set(struct task_struct *target,
-					kernel_cap_t *effective,
-					kernel_cap_t *inheritable,
-					kernel_cap_t *permitted)
+static inline void security_capset_set(kernel_cap_t *effective,
+				       kernel_cap_t *inheritable,
+				       kernel_cap_t *permitted)
 {
-	cap_capset_set(target, effective, inheritable, permitted);
+	cap_capset_set(effective, inheritable, permitted);
 }
 
 static inline int security_capable(struct task_struct *tsk, int cap)
diff --git a/kernel/capability.c b/kernel/capability.c
index 92dd85b..f119288 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -305,15 +305,13 @@ asmlinkage long sys_capset(cap_user_head
 	 */
 	spin_lock(&task_capability_lock);
 
-	ret = security_capset_check(current, &effective, &inheritable,
-				    &permitted);
+	ret = security_capset_check(&effective, &inheritable, &permitted);
 	/*
 	 * Having verified that the proposed changes are
 	 * legal, we now put them into effect.
 	 */
 	if (!ret)
-		security_capset_set(current, &effective, &inheritable,
-				    &permitted);
+		security_capset_set(&effective, &inheritable, &permitted);
 	spin_unlock(&task_capability_lock);
 
 
diff --git a/security/commoncap.c b/security/commoncap.c
index 43bba7a..031bb90 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -103,27 +103,29 @@ static inline int cap_inh_is_capped(void
 	return (cap_capable(current, CAP_SETPCAP) != 0);
 }
 
-int cap_capset_check (struct task_struct *target, kernel_cap_t *effective,
-		      kernel_cap_t *inheritable, kernel_cap_t *permitted)
+int cap_capset_check (kernel_cap_t *effective, kernel_cap_t *inheritable,
+		      kernel_cap_t *permitted)
 {
+	struct task_struct *t = current;
+
 	if (cap_inh_is_capped()
 	    && !cap_issubset(*inheritable,
-			     cap_combine(target->cap_inheritable,
-					 current->cap_permitted))) {
+			     cap_combine(t->cap_inheritable,
+					 t->cap_permitted))) {
 		/* incapable of using this inheritable set */
 		return -EPERM;
 	}
 	if (!cap_issubset(*inheritable,
-			   cap_combine(target->cap_inheritable,
-				       current->cap_bset))) {
+			   cap_combine(t->cap_inheritable,
+				       t->cap_bset))) {
 		/* no new pI capabilities outside bounding set */
 		return -EPERM;
 	}
 
 	/* verify restrictions on target's new Permitted set */
 	if (!cap_issubset (*permitted,
-			   cap_combine (target->cap_permitted,
-					current->cap_permitted))) {
+			   cap_combine (t->cap_permitted,
+					t->cap_permitted))) {
 		return -EPERM;
 	}
 
@@ -135,12 +137,13 @@ int cap_capset_check (struct task_struct
 	return 0;
 }
 
-void cap_capset_set (struct task_struct *target, kernel_cap_t *effective,
-		     kernel_cap_t *inheritable, kernel_cap_t *permitted)
+void cap_capset_set (kernel_cap_t *effective, kernel_cap_t *inheritable,
+		     kernel_cap_t *permitted)
 {
-	target->cap_effective = *effective;
-	target->cap_inheritable = *inheritable;
-	target->cap_permitted = *permitted;
+	struct task_struct *t = current;
+	t->cap_effective = *effective;
+	t->cap_inheritable = *inheritable;
+	t->cap_permitted = *permitted;
 }
 
 static inline void bprm_clear_caps(struct linux_binprm *bprm)
diff --git a/security/security.c b/security/security.c
index 3a4b4f5..78502ac 100644
--- a/security/security.c
+++ b/security/security.c
@@ -145,20 +145,18 @@ int security_capget(struct task_struct *
 	return security_ops->capget(target, effective, inheritable, permitted);
 }
 
-int security_capset_check(struct task_struct *target,
-			   kernel_cap_t *effective,
-			   kernel_cap_t *inheritable,
-			   kernel_cap_t *permitted)
+int security_capset_check(kernel_cap_t *effective,
+			  kernel_cap_t *inheritable,
+			  kernel_cap_t *permitted)
 {
-	return security_ops->capset_check(target, effective, inheritable, permitted);
+	return security_ops->capset_check(effective, inheritable, permitted);
 }
 
-void security_capset_set(struct task_struct *target,
-			  kernel_cap_t *effective,
-			  kernel_cap_t *inheritable,
-			  kernel_cap_t *permitted)
+void security_capset_set(kernel_cap_t *effective,
+			 kernel_cap_t *inheritable,
+			 kernel_cap_t *permitted)
 {
-	security_ops->capset_set(target, effective, inheritable, permitted);
+	security_ops->capset_set(effective, inheritable, permitted);
 }
 
 int security_capable(struct task_struct *tsk, int cap)
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 03fc6a8..d06e943 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1780,22 +1780,23 @@ static int selinux_capget(struct task_st
 	return secondary_ops->capget(target, effective, inheritable, permitted);
 }
 
-static int selinux_capset_check(struct task_struct *target, kernel_cap_t *effective,
-				kernel_cap_t *inheritable, kernel_cap_t *permitted)
+static int selinux_capset_check(kernel_cap_t *effective, kernel_cap_t *inheritable,
+				kernel_cap_t *permitted)
 {
 	int error;
+	struct task_struct *t = current;
 
-	error = secondary_ops->capset_check(target, effective, inheritable, permitted);
+	error = secondary_ops->capset_check(effective, inheritable, permitted);
 	if (error)
 		return error;
 
-	return task_has_perm(current, target, PROCESS__SETCAP);
+	return task_has_perm(t, t, PROCESS__SETCAP);
 }
 
-static void selinux_capset_set(struct task_struct *target, kernel_cap_t *effective,
-			       kernel_cap_t *inheritable, kernel_cap_t *permitted)
+static void selinux_capset_set(kernel_cap_t *effective, kernel_cap_t *inheritable,
+			       kernel_cap_t *permitted)
 {
-	secondary_ops->capset_set(target, effective, inheritable, permitted);
+	secondary_ops->capset_set(effective, inheritable, permitted);
 }
 
 static int selinux_capable(struct task_struct *tsk, int cap)
-- 
1.1.6
