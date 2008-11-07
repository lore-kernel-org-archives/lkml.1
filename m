Return-Path: <linux-kernel-owner+w=401wt.eu-S1753049AbYKGPPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbYKGPPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 10:15:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbYKGPOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 10:14:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51051 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443AbYKGPOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 10:14:18 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v3 4/5] AUDIT: collect info when execve results in caps in pE
To: linux-kernel@vger.kernel.org, linux-audit@redhat.com
Cc: sgrubb@redhat.com, morgan@kernel.org, serue@us.ibm.com,
       viro@ZenIV.linux.org.uk
Date: Fri, 07 Nov 2008 10:14:11 -0500
Message-ID: <20081107151411.9977.24865.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081107151355.9977.47852.stgit@paris.rdu.redhat.com>
References: <20081107151355.9977.47852.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any time fcaps or a setuid app under SECURE_NOROOT is used to result in a
non-zero pE we will crate a new audit record which contains the entire set
of known information about the executable in question, fP, fI, fE, fversion
and includes the process's pE, pI, pP.  Before and after the bprm capability
are applied.  This record type will only be emitted from execve syscalls.

an example of making ping use fcaps instead of setuid:

setcap "cat_net_raw+pe" /bin/ping

type=SYSCALL msg=audit(1225742021.015:236): arch=c000003e syscall=59 success=yes exit=0 a0=1457f30 a1=14606b0 a2=1463940 a3=321b770a70 items=2 ppid=2929 pid=2963 auid=0 uid=500 gid=500 euid=500 suid=500 fsuid=500 egid=500 sgid=500 fsgid=500 tty=pts0 ses=3 comm="ping" exe="/bin/ping" subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=(null)
type=UNKNOWN[1321] msg=audit(1225742021.015:236): fver=2 fp=0000000000002000 fi=0000000000000000 fe=1 old_pp=0000000000000000 old_pi=0000000000000000 old_pe=0000000000000000 new_pp=0000000000002000 new_pi=0000000000000000 new_pe=0000000000002000
type=EXECVE msg=audit(1225742021.015:236): argc=2 a0="ping" a1="127.0.0.1"
type=CWD msg=audit(1225742021.015:236):  cwd="/home/test"
type=PATH msg=audit(1225742021.015:236): item=0 name="/bin/ping" inode=49256 dev=fd:00 mode=0100755 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:ping_exec_t:s0 cap_fp=0000000000002000 cap_fe=1 cap_fver=2
type=PATH msg=audit(1225742021.015:236): item=1 name=(null) inode=507915 dev=fd:00 mode=0100755 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:ld_so_t:s0

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/audit.h |   26 +++++++++++++++++++
 kernel/auditsc.c      |   68 +++++++++++++++++++++++++++++++++++++++++++++++++
 security/commoncap.c  |   23 ++++++++++++++++-
 3 files changed, 116 insertions(+), 1 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 6272a39..8cfb9fe 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -99,6 +99,7 @@
 #define AUDIT_OBJ_PID		1318	/* ptrace target */
 #define AUDIT_TTY		1319	/* Input on an administrative TTY */
 #define AUDIT_EOE		1320	/* End of multi-record event */
+#define AUDIT_BPRM_FCAPS	1321	/* Information about fcaps increasing perms */
 
 #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
 #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
@@ -452,6 +453,7 @@ extern int __audit_mq_timedsend(mqd_t mqdes, size_t msg_len, unsigned int msg_pr
 extern int __audit_mq_timedreceive(mqd_t mqdes, size_t msg_len, unsigned int __user *u_msg_prio, const struct timespec __user *u_abs_timeout);
 extern int __audit_mq_notify(mqd_t mqdes, const struct sigevent __user *u_notification);
 extern int __audit_mq_getsetattr(mqd_t mqdes, struct mq_attr *mqstat);
+extern void __audit_log_bprm_fcaps(struct linux_binprm *bprm, kernel_cap_t *pP, kernel_cap_t *pE);
 
 static inline int audit_ipc_obj(struct kern_ipc_perm *ipcp)
 {
@@ -501,6 +503,29 @@ static inline int audit_mq_getsetattr(mqd_t mqdes, struct mq_attr *mqstat)
 		return __audit_mq_getsetattr(mqdes, mqstat);
 	return 0;
 }
+
+/*
+ * ieieeeeee, an audit function without a return code!
+ *
+ * This function might fail!  I decided that it didn't matter.  We are too late
+ * to fail the syscall and the information isn't REQUIRED for any purpose.  It's
+ * just nice to have.  We should be able to look at past audit logs to figure
+ * out this process's current cap set along with the fcaps from the PATH record
+ * and use that to come up with the final set.  Yeah, its ugly, but all the info
+ * is still in the audit log.  So I'm not going to bother mentioning we failed
+ * if we couldn't allocate memory.
+ *
+ * If someone changes their mind they could create the aux record earlier and
+ * then search here and use that earlier allocation.  But I don't wanna.
+ *
+ * -Eric
+ */
+static inline void audit_log_bprm_fcaps(struct linux_binprm *bprm, kernel_cap_t *pP, kernel_cap_t *pE)
+{
+	if (unlikely(!audit_dummy_context()))
+		__audit_log_bprm_fcaps(bprm, pP, pE);
+}
+
 extern int audit_n_rules;
 extern int audit_signals;
 #else
@@ -532,6 +557,7 @@ extern int audit_signals;
 #define audit_mq_timedreceive(d,l,p,t) ({ 0; })
 #define audit_mq_notify(d,n) ({ 0; })
 #define audit_mq_getsetattr(d,s) ({ 0; })
+#define audit_log_bprm_fcaps(b, p, e) do { ; } while (0)
 #define audit_ptrace(t) ((void)0)
 #define audit_n_rules 0
 #define audit_signals 0
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index f87f31a..b8b5a2a 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -196,6 +196,14 @@ struct audit_aux_data_pids {
 	int			pid_count;
 };
 
+struct audit_aux_data_bprm_fcaps {
+	struct audit_aux_data	d;
+	struct audit_cap_data	fcap;
+	unsigned int		fcap_ver;
+	struct audit_cap_data	old_pcap;
+	struct audit_cap_data	new_pcap;
+};
+
 struct audit_tree_refs {
 	struct audit_tree_refs *next;
 	struct audit_chunk *c[31];
@@ -1375,6 +1383,20 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 			audit_log_format(ab, "fd0=%d fd1=%d", axs->fd[0], axs->fd[1]);
 			break; }
 
+		case AUDIT_BPRM_FCAPS: {
+			struct audit_aux_data_bprm_fcaps *axs = (void *)aux;
+			audit_log_format(ab, "fver=%x", axs->fcap_ver);
+			audit_log_cap(ab, "fp", &axs->fcap.permitted);
+			audit_log_cap(ab, "fi", &axs->fcap.inheritable);
+			audit_log_format(ab, " fe=%d", axs->fcap.fE);
+			audit_log_cap(ab, "old_pp", &axs->old_pcap.permitted);
+			audit_log_cap(ab, "old_pi", &axs->old_pcap.inheritable);
+			audit_log_cap(ab, "old_pe", &axs->old_pcap.effective);
+			audit_log_cap(ab, "new_pp", &axs->new_pcap.permitted);
+			audit_log_cap(ab, "new_pi", &axs->new_pcap.inheritable);
+			audit_log_cap(ab, "new_pe", &axs->new_pcap.effective);
+			break; }
+
 		}
 		audit_log_end(ab);
 	}
@@ -2502,6 +2524,52 @@ int __audit_signal_info(int sig, struct task_struct *t)
 }
 
 /**
+ * __audit_log_bprm_fcaps - store information about a loading bprm and relevant fcaps
+ * @bprm pointer to the bprm being processed
+ * @caps the caps read from the disk
+ *
+ * Simply check if the proc already has the caps given by the file and if not
+ * store the priv escalation info for later auditing at the end of the syscall
+ *
+ * this can fail and we don't care.  See the note in audit.h for
+ * audit_log_bprm_fcaps() for my explaination....
+ *
+ * -Eric
+ */
+void __audit_log_bprm_fcaps(struct linux_binprm *bprm, kernel_cap_t *pP, kernel_cap_t *pE)
+{
+	struct audit_aux_data_bprm_fcaps *ax;
+	struct audit_context *context = current->audit_context;
+	struct cpu_vfs_cap_data vcaps;
+	struct dentry *dentry;
+
+	ax = kmalloc(sizeof(*ax), GFP_KERNEL);
+	if (!ax)
+		return;
+
+	ax->d.type = AUDIT_BPRM_FCAPS;
+	ax->d.next = context->aux;
+	context->aux = (void *)ax;
+
+	dentry = dget(bprm->file->f_dentry);
+	get_vfs_caps_from_disk(dentry, &vcaps);
+	dput(dentry);
+
+	ax->fcap.permitted = vcaps.permitted;
+	ax->fcap.inheritable = vcaps.inheritable;
+	ax->fcap.fE = !!(vcaps.magic_etc & VFS_CAP_FLAGS_EFFECTIVE);
+	ax->fcap_ver = (vcaps.magic_etc & VFS_CAP_REVISION_MASK) >> VFS_CAP_REVISION_SHIFT;
+
+	ax->old_pcap.permitted = *pP;
+	ax->old_pcap.inheritable = current->cap_inheritable;
+	ax->old_pcap.effective = *pE;
+
+	ax->new_pcap.permitted = current->cap_permitted;
+	ax->new_pcap.inheritable = current->cap_inheritable;
+	ax->new_pcap.effective = current->cap_effective;
+}
+
+/**
  * audit_core_dumps - record information about processes that end abnormally
  * @signr: signal value
  *
diff --git a/security/commoncap.c b/security/commoncap.c
index 8bb95ed..0b88160 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/capability.h>
+#include <linux/audit.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -373,6 +374,9 @@ int cap_bprm_set_security (struct linux_binprm *bprm)
 
 void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 {
+	kernel_cap_t pP = current->cap_permitted;
+	kernel_cap_t pE = current->cap_effective;
+
 	if (bprm->e_uid != current->uid || bprm->e_gid != current->gid ||
 	    !cap_issubset(bprm->cap_post_exec_permitted,
 			  current->cap_permitted)) {
@@ -406,7 +410,24 @@ void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 			cap_clear(current->cap_effective);
 	}
 
-	/* AUD: Audit candidate if current->cap_effective is set */
+	/*
+	 * Audit candidate if current->cap_effective is set
+	 *
+	 * We do not bother to audit if 3 things are true:
+	 *   1) cap_effective has all caps
+	 *   2) we are root
+	 *   3) root is supposed to have all caps (SECURE_NOROOT)
+	 * Since this is just a normal root execing a process.
+	 *
+	 * Number 1 above might fail if you don't have a full bset, but I think
+	 * that is interesting information to audit.
+	 */
+	if (!cap_isclear(current->cap_effective)) {
+		if (!cap_issubset(CAP_FULL_SET, current->cap_effective) ||
+		    (bprm->e_uid != 0) || (current->uid != 0) ||
+		    issecure(SECURE_NOROOT))
+			audit_log_bprm_fcaps(bprm, &pP, &pE);
+	}
 
 	current->securebits &= ~issecure_mask(SECURE_KEEP_CAPS);
 }

