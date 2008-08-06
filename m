Return-Path: <linux-kernel-owner+w=401wt.eu-S1030581AbYHFPuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030581AbYHFPuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758853AbYHFPhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:37:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758308AbYHFPhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:37:51 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 05/24] CRED: Constify the kernel_cap_t arguments to the capset
	LSM hooks [ver #7]
To: jmorris@namei.org, akpm@linux-foundation.org, morgan@kernel.org
Cc: sfr@canb.auug.org.au, dhowells@redhat.com, viro@ftp.linux.org.uk,
       casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Wed, 06 Aug 2008 16:37:39 +0100
Message-ID: <20080806153739.14351.13364.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
References: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Constify the kernel_cap_t arguments to the capset LSM hooks.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: James Morris <jmorris@namei.org>
---

 include/linux/security.h |   44 ++++++++++++++++++++++++--------------------
 security/commoncap.c     |   10 ++++++----
 security/security.c      |   12 ++++++------
 security/selinux/hooks.c |   10 ++++++----
 4 files changed, 42 insertions(+), 34 deletions(-)


diff --git a/include/linux/security.h b/include/linux/security.h
index dc23a3d..c3eed5a 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -49,8 +49,12 @@ extern int cap_settime(struct timespec *ts, struct timezone *tz);
 extern int cap_ptrace_may_access(struct task_struct *child, unsigned int mode);
 extern int cap_ptrace_traceme(struct task_struct *parent);
 extern int cap_capget(struct task_struct *target, kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
-extern int cap_capset_check(kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
-extern void cap_capset_set(kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
+extern int cap_capset_check(const kernel_cap_t *effective,
+			    const kernel_cap_t *inheritable,
+			    const kernel_cap_t *permitted);
+extern void cap_capset_set(const kernel_cap_t *effective,
+			   const kernel_cap_t *inheritable,
+			   const kernel_cap_t *permitted);
 extern int cap_bprm_set_security(struct linux_binprm *bprm);
 extern void cap_bprm_apply_creds(struct linux_binprm *bprm, int unsafe);
 extern int cap_bprm_secureexec(struct linux_binprm *bprm);
@@ -1289,12 +1293,12 @@ struct security_operations {
 	int (*capget) (struct task_struct *target,
 		       kernel_cap_t *effective,
 		       kernel_cap_t *inheritable, kernel_cap_t *permitted);
-	int (*capset_check) (kernel_cap_t *effective,
-			     kernel_cap_t *inheritable,
-			     kernel_cap_t *permitted);
-	void (*capset_set) (kernel_cap_t *effective,
-			    kernel_cap_t *inheritable,
-			    kernel_cap_t *permitted);
+	int (*capset_check) (const kernel_cap_t *effective,
+			     const kernel_cap_t *inheritable,
+			     const kernel_cap_t *permitted);
+	void (*capset_set) (const kernel_cap_t *effective,
+			    const kernel_cap_t *inheritable,
+			    const kernel_cap_t *permitted);
 	int (*capable) (struct task_struct *tsk, int cap);
 	int (*acct) (struct file *file);
 	int (*sysctl) (struct ctl_table *table, int op);
@@ -1561,12 +1565,12 @@ int security_capget(struct task_struct *target,
 		    kernel_cap_t *effective,
 		    kernel_cap_t *inheritable,
 		    kernel_cap_t *permitted);
-int security_capset_check(kernel_cap_t *effective,
-			  kernel_cap_t *inheritable,
-			  kernel_cap_t *permitted);
-void security_capset_set(kernel_cap_t *effective,
-			 kernel_cap_t *inheritable,
-			 kernel_cap_t *permitted);
+int security_capset_check(const kernel_cap_t *effective,
+			  const kernel_cap_t *inheritable,
+			  const kernel_cap_t *permitted);
+void security_capset_set(const kernel_cap_t *effective,
+			 const kernel_cap_t *inheritable,
+			 const kernel_cap_t *permitted);
 int security_capable(struct task_struct *tsk, int cap);
 int security_acct(struct file *file);
 int security_sysctl(struct ctl_table *table, int op);
@@ -1754,16 +1758,16 @@ static inline int security_capget(struct task_struct *target,
 	return cap_capget(target, effective, inheritable, permitted);
 }
 
-static inline int security_capset_check(kernel_cap_t *effective,
-					kernel_cap_t *inheritable,
-					kernel_cap_t *permitted)
+static inline int security_capset_check(const kernel_cap_t *effective,
+					const kernel_cap_t *inheritable,
+					const kernel_cap_t *permitted)
 {
 	return cap_capset_check(effective, inheritable, permitted);
 }
 
-static inline void security_capset_set(kernel_cap_t *effective,
-				       kernel_cap_t *inheritable,
-				       kernel_cap_t *permitted)
+static inline void security_capset_set(const kernel_cap_t *effective,
+				       const kernel_cap_t *inheritable,
+				       const kernel_cap_t *permitted)
 {
 	cap_capset_set(effective, inheritable, permitted);
 }
diff --git a/security/commoncap.c b/security/commoncap.c
index 059a131..40e8b83 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -117,8 +117,9 @@ static inline int cap_limit_ptraced_target(void)
 
 #endif /* def CONFIG_SECURITY_FILE_CAPABILITIES */
 
-int cap_capset_check (kernel_cap_t *effective,
-		      kernel_cap_t *inheritable, kernel_cap_t *permitted)
+int cap_capset_check(const kernel_cap_t *effective,
+		     const kernel_cap_t *inheritable,
+		     const kernel_cap_t *permitted)
 {
 	if (cap_inh_is_capped()
 	    && !cap_issubset(*inheritable,
@@ -149,8 +150,9 @@ int cap_capset_check (kernel_cap_t *effective,
 	return 0;
 }
 
-void cap_capset_set (kernel_cap_t *effective,
-		     kernel_cap_t *inheritable, kernel_cap_t *permitted)
+void cap_capset_set(const kernel_cap_t *effective,
+		    const kernel_cap_t *inheritable,
+		    const kernel_cap_t *permitted)
 {
 	current->cap_effective = *effective;
 	current->cap_inheritable = *inheritable;
diff --git a/security/security.c b/security/security.c
index 78502ac..c2203f5 100644
--- a/security/security.c
+++ b/security/security.c
@@ -145,16 +145,16 @@ int security_capget(struct task_struct *target,
 	return security_ops->capget(target, effective, inheritable, permitted);
 }
 
-int security_capset_check(kernel_cap_t *effective,
-			  kernel_cap_t *inheritable,
-			  kernel_cap_t *permitted)
+int security_capset_check(const kernel_cap_t *effective,
+			  const kernel_cap_t *inheritable,
+			  const kernel_cap_t *permitted)
 {
 	return security_ops->capset_check(effective, inheritable, permitted);
 }
 
-void security_capset_set(kernel_cap_t *effective,
-			 kernel_cap_t *inheritable,
-			 kernel_cap_t *permitted)
+void security_capset_set(const kernel_cap_t *effective,
+			 const kernel_cap_t *inheritable,
+			 const kernel_cap_t *permitted)
 {
 	security_ops->capset_set(effective, inheritable, permitted);
 }
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index b040887..9cc59f6 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1781,8 +1781,9 @@ static int selinux_capget(struct task_struct *target, kernel_cap_t *effective,
 	return secondary_ops->capget(target, effective, inheritable, permitted);
 }
 
-static int selinux_capset_check(kernel_cap_t *effective,
-				kernel_cap_t *inheritable, kernel_cap_t *permitted)
+static int selinux_capset_check(const kernel_cap_t *effective,
+				const kernel_cap_t *inheritable,
+				const kernel_cap_t *permitted)
 {
 	int error;
 
@@ -1793,8 +1794,9 @@ static int selinux_capset_check(kernel_cap_t *effective,
 	return task_has_perm(current, current, PROCESS__SETCAP);
 }
 
-static void selinux_capset_set(kernel_cap_t *effective,
-			       kernel_cap_t *inheritable, kernel_cap_t *permitted)
+static void selinux_capset_set(const kernel_cap_t *effective,
+			       const kernel_cap_t *inheritable,
+			       const kernel_cap_t *permitted)
 {
 	secondary_ops->capset_set(effective, inheritable, permitted);
 }

