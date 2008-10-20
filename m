Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbYJTW2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbYJTW2B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 18:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbYJTW02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 18:26:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55636 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179AbYJTW00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 18:26:26 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 4/4] AUDIT: emit new record type showing all capset information
To: linux-kernel@vger.kernel.org, linux-audit@redhat.com
Cc: viro@zeniv.linux.org.ok, sgrubb@redhat.com, serue@us.ibm.com,
       morgan@kernel.org
Date: Mon, 20 Oct 2008 18:26:18 -0400
Message-ID: <20081020222617.3895.46178.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081020222538.3895.50175.stgit@paris.rdu.redhat.com>
References: <20081020222538.3895.50175.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the capset syscall is used it is not possible for audit to record the
actual capbilities being added/removed.  This patch adds a new record type
which emits the target pid and the eff, inh, and perm cap sets.

example output if you audit capset syscalls would be:

type=SYSCALL msg=audit(1224539227.691:49): arch=c000003e syscall=126 success=yes exit=0 a0=11e8014 a1=11e801c a2=80000000 a3=7fffe3dc90d0 items=0 ppid=2262 pid=2323 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=1 comm="setcap" exe="/usr/sbin/setcap" subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=(null)
type=UNKNOWN[1322] msg=audit(1224539227.691:49): pid=0 CapEff=ffffffffffffffff CapInh=ffffffffffffffff CapPrm=ffffffffffffffff

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/audit.h |   10 ++++++++++
 kernel/auditsc.c      |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/capability.c   |    3 +++
 3 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 88a0f04..b5c7c3f 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -100,6 +100,7 @@
 #define AUDIT_TTY		1319	/* Input on an administrative TTY */
 #define AUDIT_EOE		1320	/* End of multi-record event */
 #define AUDIT_BPRM_FCAPS	1321	/* Information about fcaps increasing perms */
+#define AUDIT_CAPSET		1322	/* Record showing argument to sys_capset */
 
 #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
 #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
@@ -454,6 +455,7 @@ extern int __audit_mq_timedreceive(mqd_t mqdes, size_t msg_len, unsigned int __u
 extern int __audit_mq_notify(mqd_t mqdes, const struct sigevent __user *u_notification);
 extern int __audit_mq_getsetattr(mqd_t mqdes, struct mq_attr *mqstat);
 extern int __audit_log_bprm_fcaps(struct linux_binprm *bprm, struct cpu_vfs_cap_data *caps);
+extern int __audit_log_capset(pid_t pid, kernel_cap_t *eff, kernel_cap_t *inh, kernel_cap_t *perm);
 
 
 static inline int audit_ipc_obj(struct kern_ipc_perm *ipcp)
@@ -512,6 +514,13 @@ static inline int audit_log_bprm_fcaps(struct linux_binprm *bprm, struct cpu_vfs
 	return 0;
 }
 
+static inline int audit_log_capset(pid_t pid, kernel_cap_t *eff, kernel_cap_t *inh, kernel_cap_t *perm)
+{
+	if (unlikely(!audit_dummy_context()))
+		return __audit_log_capset(pid, eff, inh, perm);
+	return 0;
+}
+
 extern int audit_n_rules;
 extern int audit_signals;
 #else
@@ -544,6 +553,7 @@ extern int audit_signals;
 #define audit_mq_notify(d,n) ({ 0; })
 #define audit_mq_getsetattr(d,s) ({ 0; })
 #define audit_log_bprm_fcaps(b, c) 0
+#define audit_log_capset(pid, e, i, p) do { ; } while (0)
 #define audit_ptrace(t) ((void)0)
 #define audit_n_rules 0
 #define audit_signals 0
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 6d2487c..0db824f 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -204,6 +204,12 @@ struct audit_aux_data_bprm_fcaps {
 	kernel_cap_t		bprm_effective;
 };
 
+struct audit_aux_data_capset {
+	struct audit_aux_data	d;
+	pid_t			pid;
+	struct audit_cap_data	cap;
+};
+
 struct audit_tree_refs {
 	struct audit_tree_refs *next;
 	struct audit_chunk *c[31];
@@ -1395,6 +1401,14 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 			audit_log_cap(ab, "cap_bprmEff", &axs->bprm_effective);
 			break; }
 
+		case AUDIT_CAPSET: {
+			struct audit_aux_data_capset *axs = (void *)aux;
+			audit_log_format(ab, "pid=%d", axs->pid);
+			audit_log_cap(ab, "CapEff", &axs->cap.effective);
+			audit_log_cap(ab, "CapInh", &axs->cap.inheritable);
+			audit_log_cap(ab, "CapPrm", &axs->cap.permitted);
+			break; }
+
 		}
 		audit_log_end(ab);
 	}
@@ -2573,6 +2587,40 @@ int __audit_log_bprm_fcaps(struct linux_binprm *bprm, struct cpu_vfs_cap_data *c
 }
 
 /**
+ * __audit_log_capset - store information about the arguments to the capset syscall
+ * @pid target pid of the capset call
+ * @eff effective cap set
+ * @inh inheritible cap set
+ * @perm permited cap set
+ *
+ * Record the aguments userspace sent to sys_capset for later printing by the
+ * audit system if applicable
+ */
+int __audit_log_capset(pid_t pid, kernel_cap_t *eff, kernel_cap_t *inh, kernel_cap_t *perm)
+{
+	struct audit_aux_data_capset *ax;
+	struct audit_context *context = current->audit_context;
+
+	if (likely(!audit_enabled || !context || context->dummy))
+		return 0;
+
+	ax = kmalloc(sizeof(*ax), GFP_KERNEL);
+	if (!ax)
+		return -ENOMEM;
+
+	ax->d.type = AUDIT_CAPSET;
+	ax->d.next = context->aux;
+	context->aux = (void *)ax;
+
+	ax->pid = pid;
+	ax->cap.effective = *eff;
+	ax->cap.inheritable = *eff;
+	ax->cap.permitted = *perm;
+
+	return 0;
+}
+
+/**
  * audit_core_dumps - record information about processes that end abnormally
  * @signr: signal value
  *
diff --git a/kernel/capability.c b/kernel/capability.c
index 33e51e7..3d7fc70 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -7,6 +7,7 @@
  * 30 May 2002:	Cleanup, Robert M. Love <rml@tech9.net>
  */
 
+#include <linux/audit.h>
 #include <linux/capability.h>
 #include <linux/mm.h>
 #include <linux/module.h>
@@ -457,6 +458,8 @@ asmlinkage long sys_capset(cap_user_header_t header, const cap_user_data_t data)
 		i++;
 	}
 
+	audit_log_capset(pid, &effective, &inheritable, &permitted);
+
 	if (pid && (pid != task_pid_vnr(current)))
 		ret = do_sys_capset_other_tasks(pid, &effective, &inheritable,
 						&permitted);

