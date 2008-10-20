Return-Path: <linux-kernel-owner+w=401wt.eu-S1755679AbYJTW1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbYJTW1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 18:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754810AbYJTW0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 18:26:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55634 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755163AbYJTW0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 18:26:23 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 3/4] AUDIT: audit when fcaps increase the permitted or
	inheritable capabilities
To: linux-kernel@vger.kernel.org, linux-audit@redhat.com
Cc: viro@zeniv.linux.org.ok, sgrubb@redhat.com, serue@us.ibm.com,
       morgan@kernel.org
Date: Mon, 20 Oct 2008 18:26:12 -0400
Message-ID: <20081020222612.3895.6710.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081020222538.3895.50175.stgit@paris.rdu.redhat.com>
References: <20081020222538.3895.50175.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any time fcaps are used to increase a processes pP or pE we will crate a new
audit record which contains the entire set of known information about the 
executable in question, fP, fI, fE, version and includes the parent processes
pE, pI, pP.  This record type will only be emitted from execve syscalls.

an example of making ping use fcaps instead of setuid:

setcap "cat_net_raw+pe" /bin/ping

type=SYSCALL msg=audit(1224539237.785:55): arch=c000003e syscall=59 success=yes exit=0 a0=1b511c0 a1=1b50aa0 a2=1b5f140 a3=3445170a70 items=2 ppid=2328 pid=2358 auid=0 uid=500 gid=500 euid=500 suid=500 fsuid=500 egid=500 sgid=500 fsgid=500 tty=pts0 ses=1 comm="ping" exe="/bin/ping" subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=(null)
type=EXECVE msg=audit(1224539237.785:55): argc=2 a0="ping" a1="127.0.0.1" 
type=UNKNOWN[1321] msg=audit(1224539237.785:55): cap_fVer=2 cap_fP=0000000000002000 cap_fI=0000000000000000 cap_fE=1 cap_pP=0000000000001000 cap_pI=0000000000000000 cap_pE=0000000000001000 cap_bprmEff=0000000000002000
type=CWD msg=audit(1224539237.785:55):  cwd="/home/test"
type=PATH msg=audit(1224539237.785:55): item=0 name="/bin/ping" inode=49227 dev=fd:00 mode=0100755 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:ping_exec_t:s0 cap_fP=0000000000002000 cap_fE=1 cap_fVer=2
type=PATH msg=audit(1224539237.785:55): item=1 name=(null) inode=507963 dev=fd:00 mode=0100755 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:ld_so_t:s0

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/audit.h |   12 ++++++++
 kernel/auditsc.c      |   71 +++++++++++++++++++++++++++++++++++++++++++++++++
 security/commoncap.c  |    3 ++
 3 files changed, 86 insertions(+), 0 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 6272a39..88a0f04 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -99,6 +99,7 @@
 #define AUDIT_OBJ_PID		1318	/* ptrace target */
 #define AUDIT_TTY		1319	/* Input on an administrative TTY */
 #define AUDIT_EOE		1320	/* End of multi-record event */
+#define AUDIT_BPRM_FCAPS	1321	/* Information about fcaps increasing perms */
 
 #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
 #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
@@ -452,6 +453,8 @@ extern int __audit_mq_timedsend(mqd_t mqdes, size_t msg_len, unsigned int msg_pr
 extern int __audit_mq_timedreceive(mqd_t mqdes, size_t msg_len, unsigned int __user *u_msg_prio, const struct timespec __user *u_abs_timeout);
 extern int __audit_mq_notify(mqd_t mqdes, const struct sigevent __user *u_notification);
 extern int __audit_mq_getsetattr(mqd_t mqdes, struct mq_attr *mqstat);
+extern int __audit_log_bprm_fcaps(struct linux_binprm *bprm, struct cpu_vfs_cap_data *caps);
+
 
 static inline int audit_ipc_obj(struct kern_ipc_perm *ipcp)
 {
@@ -501,6 +504,14 @@ static inline int audit_mq_getsetattr(mqd_t mqdes, struct mq_attr *mqstat)
 		return __audit_mq_getsetattr(mqdes, mqstat);
 	return 0;
 }
+
+static inline int audit_log_bprm_fcaps(struct linux_binprm *bprm, struct cpu_vfs_cap_data *caps)
+{
+	if (unlikely(!audit_dummy_context()))
+		return __audit_log_bprm_fcaps(bprm, caps);
+	return 0;
+}
+
 extern int audit_n_rules;
 extern int audit_signals;
 #else
@@ -532,6 +543,7 @@ extern int audit_signals;
 #define audit_mq_timedreceive(d,l,p,t) ({ 0; })
 #define audit_mq_notify(d,n) ({ 0; })
 #define audit_mq_getsetattr(d,s) ({ 0; })
+#define audit_log_bprm_fcaps(b, c) 0
 #define audit_ptrace(t) ((void)0)
 #define audit_n_rules 0
 #define audit_signals 0
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index bf1f11a..6d2487c 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -196,6 +196,14 @@ struct audit_aux_data_pids {
 	int			pid_count;
 };
 
+struct audit_aux_data_bprm_fcaps {
+	struct audit_aux_data	d;
+	struct audit_cap_data	fcap;
+	unsigned int		fcap_ver;
+	struct audit_cap_data	pcap;
+	kernel_cap_t		bprm_effective;
+};
+
 struct audit_tree_refs {
 	struct audit_tree_refs *next;
 	struct audit_chunk *c[31];
@@ -1375,6 +1383,18 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 			audit_log_format(ab, "fd0=%d fd1=%d", axs->fd[0], axs->fd[1]);
 			break; }
 
+		case AUDIT_BPRM_FCAPS: {
+			struct audit_aux_data_bprm_fcaps *axs = (void *)aux;
+			audit_log_format(ab, "cap_fVer=%x", axs->fcap_ver);
+			audit_log_cap(ab, "cap_fP", &axs->fcap.permitted);
+			audit_log_cap(ab, "cap_fI", &axs->fcap.inheritable);
+			audit_log_format(ab, " cap_fE=%d", axs->fcap.fE);
+			audit_log_cap(ab, "cap_pP", &axs->pcap.permitted);
+			audit_log_cap(ab, "cap_pI", &axs->pcap.inheritable);
+			audit_log_cap(ab, "cap_pE", &axs->pcap.effective);
+			audit_log_cap(ab, "cap_bprmEff", &axs->bprm_effective);
+			break; }
+
 		}
 		audit_log_end(ab);
 	}
@@ -2502,6 +2522,57 @@ int __audit_signal_info(int sig, struct task_struct *t)
 }
 
 /**
+ * __audit_log_bprm_fcaps - store information about a loading bprm and relevant fcaps
+ * @bprm pointer to the bprm being processed
+ * @caps the caps read from the disk
+ *
+ * Simply check if the proc already has the caps given by the file and if not
+ * store the priv escalation info for later auditing at the end of the syscall
+ */
+int __audit_log_bprm_fcaps(struct linux_binprm *bprm, struct cpu_vfs_cap_data *caps)
+{
+	struct audit_aux_data_bprm_fcaps *ax;
+	struct audit_context *context = current->audit_context;
+	struct task_struct *tsk = current;
+
+	if (likely(!audit_enabled || !context || context->dummy))
+		return 0;
+
+	/*
+	 * bprm is in pP interset pI &&
+	 * we will change pE &&
+	 * bprm is in pE intersect pI
+	 *
+	 * fcaps make no different so don't record this
+	 */
+	if (cap_issubset(bprm->cap_post_exec_permitted, cap_intersect(tsk->cap_permitted, tsk->cap_inheritable)) &&
+	    bprm->cap_effective &&
+	    cap_issubset(bprm->cap_post_exec_permitted, cap_intersect(tsk->cap_effective, tsk->cap_inheritable)))
+		return 0;
+
+	ax = kmalloc(sizeof(*ax), GFP_KERNEL);
+	if (!ax)
+		return -ENOMEM;
+
+	ax->d.type = AUDIT_BPRM_FCAPS;
+	ax->d.next = context->aux;
+	context->aux = (void *)ax;
+
+	ax->fcap.permitted = caps->permitted;
+	ax->fcap.inheritable = caps->inheritable;
+	ax->fcap.fE = !!(caps->magic_etc & VFS_CAP_FLAGS_EFFECTIVE);
+	ax->fcap_ver = (caps->magic_etc & VFS_CAP_REVISION_MASK) >> VFS_CAP_REVISION_SHIFT;
+
+	ax->pcap.permitted = tsk->cap_permitted;
+	ax->pcap.inheritable = tsk->cap_inheritable;
+	ax->pcap.effective = tsk->cap_effective;
+
+	ax->bprm_effective = bprm->cap_post_exec_permitted;
+
+	return 0;
+}
+
+/**
  * audit_core_dumps - record information about processes that end abnormally
  * @signr: signal value
  *
diff --git a/security/commoncap.c b/security/commoncap.c
index 888b292..9bb285d 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/capability.h>
+#include <linux/audit.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -320,6 +321,8 @@ static int get_file_caps(struct linux_binprm *bprm)
 
 	rc = bprm_caps_from_vfs_caps(&vcaps, bprm);
 
+	audit_log_bprm_fcaps(bprm, &vcaps);
+
 out:
 	dput(dentry);
 	if (rc)

