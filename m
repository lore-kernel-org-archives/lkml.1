Return-Path: <linux-kernel-owner+w=401wt.eu-S1757869AbXENR00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869AbXENR00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 13:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755945AbXENR0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 13:26:17 -0400
Received: from smtp102.sbc.mail.mud.yahoo.com ([68.142.198.201]:25682 "HELO
	smtp102.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755862AbXENR0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 13:26:15 -0400
X-YMail-OSG: qlnCG0kVM1kK2Yw_yImUXUJjl6D3xmM.HHhFc6ISTgyP6FBs4kdSAqAV1cNn.FTej162ya1xQ_2tsoO2_AwDvM7R5F_flEiiJ6Cgm_HwHJFuiIkzCxU-
Date: Mon, 14 May 2007 12:26:05 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Suparna Bhattacharya <suparna@in.ibm.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, adilger@clusterfs.com,
       lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Andrew Morton <akpm@linux-foundation.org>, jeffschroeder@computer.org,
       Chris Wright <chrisw@sous-sol.org>,
       Karl MacMillan <kmacmillan@mentalrootkit.com>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>
Subject: Re: [PATCH 2/2] file capabilities: accomodate >32 bit capabilities
Message-ID: <20070514172605.GA19587@vino.hallyn.com>
References: <20070508191548.GA29913@sergelap.austin.ibm.com> <20070508191704.GC29913@sergelap.austin.ibm.com> <20070508205826.GH6375@schatzie.adilger.int> <20070508214914.GA27582@sergelap.austin.ibm.com> <20070510200127.GH6375@schatzie.adilger.int> <20070511060906.GA7050@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070511060906.GA7050@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Suparna Bhattacharya (suparna@in.ibm.com):
> On Thu, May 10, 2007 at 01:01:27PM -0700, Andreas Dilger wrote:
> > On May 08, 2007  16:49 -0500, Serge E. Hallyn wrote:
> > > Quoting Andreas Dilger (adilger@clusterfs.com):
> > > > One of the important use cases I can see today is the ability to
> > > > split the heavily-overloaded e.g. CAP_SYS_ADMIN into much more fine
> > > > grained attributes.
> > > 
> > > Sounds plausible, though it suffers from both making capabilities far
> > > more cumbersome (i.e. finding the right capability for what you wanted
> > > to do) and backward compatibility.  Perhaps at that point we should
> > > introduce security.capabilityv2 xattrs.  A binary can then carry
> > > security.capability=CAP_SYS_ADMIN=p, and
> > > security.capabilityv2=cap_may_clone_mntns=p.
> > 
> > Well, the overhead of each EA is non-trivial (16 bytes/EA) for storing
> > 12 bytes worth of data, so it is probably just better to keep extending
> > the original capability fields as was in the proposal.
> > 
> > > > What we definitely do NOT want to happen is an application that needs
> > > > priviledged access (e.g. e2fsck, mount) to stop running because the
> > > > new capabilities _would_ have been granted by the new kernel and are
> > > > not by the old kernel and STRICTXATTR is used.
> > > > 
> > > > To me it would seem that having extra capabilities on an old kernel
> > > > is relatively harmless if the old kernel doesn't know what they are.
> > > > It's like having a key to a door that you don't know where it is.
> > > 
> > > If we ditch the STRICTXATTR option do the semantics seem sane to you?
> > 
> > Seems reasonable.
> 
> It would simplify the code as well, which is good.
> 
> This does mean no sanity checking of fcaps, am not sure if that matters,
> I'm guessing it should be similar to the case for other security attributes.

which is to trust the xattr...

So here is a new consolidated patch without the STRICTXATTR config
option.

-serge

From: Serge E. Hallyn <serue@us.ibm.com>
Subject: [PATCH] Implement file posix capabilities

Implement file posix capabilities.  This allows programs to be given a
subset of root's powers regardless of who runs them, without having to use
setuid and giving the binary all of root's powers.

This version works with Kaigai Kohei's userspace tools, found at
http://www.kaigai.gr.jp/index.php.  For more information on how to use this
patch, Chris Friedhoff has posted a nice page at
http://www.friedhoff.org/fscaps.html.

Changelog:
	May 14:
	Remove STRICTXATTR support which could make newer binaries
	unusable on older kernels, and combine the two patches
	into one.

	[recent]:
	1. Enable the CONFIG_SECURITY_FS_CAPABILITIES option
	when CONFIG_SECURITY=n.
	2. Rename CONFIG_SECURITY_FS_CAPABILITIES to
	CONFIG_SECURITY_FILE_CAPABILITIES
	3. To accomodate 64-bit caps, specify that capabilities are
	stored as
		u32 version; u32 eff0; u32 perm0; u32 inh0;
		u32 eff1; u32 perm1; u32 inh1; (etc)

	Nov 27:
	Incorporate fixes from Andrew Morton
	(security-introduce-file-caps-tweaks and
	security-introduce-file-caps-warning-fix)
	Fix Kconfig dependency.
	Fix change signaling behavior when file caps are not compiled in.

	Nov 13:
	Integrate comments from Alexey: Remove CONFIG_ ifdef from
	capability.h, and use %zd for printing a size_t.

	Nov 13:
	Fix endianness warnings by sparse as suggested by Alexey
	Dobriyan.

	Nov 09:
	Address warnings of unused variables at cap_bprm_set_security
	when file capabilities are disabled, and simultaneously clean
	up the code a little, by pulling the new code into a helper
	function.

	Nov 08:
	For pointers to required userspace tools and how to use
	them, see http://www.friedhoff.org/fscaps.html.

	Nov 07:
	Fix the calculation of the highest bit checked in
	check_cap_sanity().

	Nov 07:
	Allow file caps to be enabled without CONFIG_SECURITY, since
	capabilities are the default.
	Hook cap_task_setscheduler when !CONFIG_SECURITY.
	Move capable(TASK_KILL) to end of cap_task_kill to reduce
	audit messages.

	Nov 05:
	Add secondary calls in selinux/hooks.c to task_setioprio and
	task_setscheduler so that selinux and capabilities with file
	cap support can be stacked.

	Sep 05:
	As Seth Arnold points out, uid checks are out of place
	for capability code.

	Sep 01:
	Define task_setscheduler, task_setioprio, cap_task_kill, and
	task_setnice to make sure a user cannot affect a process in which
	they called a program with some fscaps.

	One remaining question is the note under task_setscheduler: are we
	ok with CAP_SYS_NICE being sufficient to confine a process to a
	cpuset?

	It is a semantic change, as without fsccaps, attach_task doesn't
	allow CAP_SYS_NICE to override the uid equivalence check.  But since
	it uses security_task_setscheduler, which elsewhere is used where
	CAP_SYS_NICE can be used to override the uid equivalence check,
	fixing it might be tough.

	     task_setscheduler
		 note: this also controls cpuset:attach_task.  Are we ok with
		     CAP_SYS_NICE being used to confine to a cpuset?
	     task_setioprio
	     task_setnice
		 sys_setpriority uses this (through set_one_prio) for another
		 process.  Need same checks as setrlimit

	Aug 21:
	Updated secureexec implementation to reflect the fact that
	euid and uid might be the same and nonzero, but the process
	might still have elevated caps.

	Aug 15:
	Handle endianness of xattrs.
	Enforce capability version match between kernel and disk.
	Enforce that no bits beyond the known max capability are
	set, else return -EPERM.
	With this extra processing, it may be worth reconsidering
	doing all the work at bprm_set_security rather than
	d_instantiate.

	Aug 10:
	Always call getxattr at bprm_set_security, rather than
	caching it at d_instantiate.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>

---

 include/linux/capability.h |   37 ++++++++
 include/linux/security.h   |   12 ++-
 security/Kconfig           |   10 ++
 security/capability.c      |    4 +
 security/commoncap.c       |  192 ++++++++++++++++++++++++++++++++++++++++++--
 security/selinux/hooks.c   |   12 +++
 6 files changed, 256 insertions(+), 11 deletions(-)

833d9a6478d4f7fb915d76b25be1bb71e56b29f1
diff --git a/include/linux/capability.h b/include/linux/capability.h
index 6548b35..4dbfef3 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -40,11 +40,46 @@ typedef struct __user_cap_data_struct {
         __u32 inheritable;
 } __user *cap_user_data_t;
   
+
+
+#define XATTR_CAPS_SUFFIX "capability"
+#define XATTR_NAME_CAPS XATTR_SECURITY_PREFIX XATTR_CAPS_SUFFIX
+
+/* size of caps that we work with */
+#define XATTR_CAPS_SZ (4*sizeof(__le32))
+
+/*
+ * data[] is organized as:
+ *   effective[0]
+ *   permitted[0]
+ *   inheritable[0]
+ *   effective[1]
+ *   ...
+ * this way we can just read as much of the on-disk capability as
+ * we know should exist and know we'll get the data we'll need.
+ */
+struct vfs_cap_data_disk {
+	__le32 version;
+	__le32 data[];  /* eff[0], perm[0], inh[0], eff[1], ... */
+};
+
+struct vfs_cap_data_disk_v1 {
+	__le32 version;
+	__le32 data[3];  /* eff[0], perm[0], inh[0] */
+};
+
 #ifdef __KERNEL__
 
 #include <linux/spinlock.h>
 #include <asm/current.h>
 
+struct vfs_cap_data {
+	__u32 version;
+	__u32 effective;
+	__u32 permitted;
+	__u32 inheritable;
+};
+
 /* #define STRICT_CAP_T_TYPECHECKS */
 
 #ifdef STRICT_CAP_T_TYPECHECKS
@@ -288,6 +323,8 @@ typedef __u32 kernel_cap_t;
 
 #define CAP_AUDIT_CONTROL    30
 
+#define CAP_NUMCAPS	     31
+
 #ifdef __KERNEL__
 /* 
  * Bounding set
diff --git a/include/linux/security.h b/include/linux/security.h
index 9eb9e0f..1a362c8 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -53,6 +53,10 @@ extern int cap_inode_setxattr(struct den
 extern int cap_inode_removexattr(struct dentry *dentry, char *name);
 extern int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid, int flags);
 extern void cap_task_reparent_to_init (struct task_struct *p);
+extern int cap_task_kill(struct task_struct *p, struct siginfo *info, int sig, u32 secid);
+extern int cap_task_setscheduler (struct task_struct *p, int policy, struct sched_param *lp);
+extern int cap_task_setioprio (struct task_struct *p, int ioprio);
+extern int cap_task_setnice (struct task_struct *p, int nice);
 extern int cap_syslog (int type);
 extern int cap_vm_enough_memory (long pages);
 
@@ -2585,12 +2589,12 @@ static inline int security_task_setgroup
 
 static inline int security_task_setnice (struct task_struct *p, int nice)
 {
-	return 0;
+	return cap_task_setnice(p, nice);
 }
 
 static inline int security_task_setioprio (struct task_struct *p, int ioprio)
 {
-	return 0;
+	return cap_task_setioprio(p, ioprio);
 }
 
 static inline int security_task_getioprio (struct task_struct *p)
@@ -2608,7 +2612,7 @@ static inline int security_task_setsched
 					      int policy,
 					      struct sched_param *lp)
 {
-	return 0;
+	return cap_task_setscheduler(p, policy, lp);
 }
 
 static inline int security_task_getscheduler (struct task_struct *p)
@@ -2625,7 +2629,7 @@ static inline int security_task_kill (st
 				      struct siginfo *info, int sig,
 				      u32 secid)
 {
-	return 0;
+	return cap_task_kill(p, info, sig, secid);
 }
 
 static inline int security_task_wait (struct task_struct *p)
diff --git a/security/Kconfig b/security/Kconfig
index 460e5c9..7c941d9 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -80,6 +80,16 @@ config SECURITY_CAPABILITIES
 	  This enables the "default" Linux capabilities functionality.
 	  If you are unsure how to answer this question, answer Y.
 
+config SECURITY_FILE_CAPABILITIES
+	bool "File POSIX Capabilities"
+	depends on SECURITY=n || SECURITY_CAPABILITIES!=n
+	default n
+	help
+	  This enables filesystem capabilities, allowing you to give
+	  binaries a subset of root's powers without using setuid 0.
+
+	  If in doubt, answer N.
+
 config SECURITY_ROOTPLUG
 	tristate "Root Plug Support"
 	depends on USB && SECURITY
diff --git a/security/capability.c b/security/capability.c
index 38296a0..0db5fda 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -39,6 +39,10 @@ static struct security_operations capabi
 	.inode_setxattr =		cap_inode_setxattr,
 	.inode_removexattr =		cap_inode_removexattr,
 
+	.task_kill =			cap_task_kill,
+	.task_setscheduler =		cap_task_setscheduler,
+	.task_setioprio =		cap_task_setioprio,
+	.task_setnice =			cap_task_setnice,
 	.task_post_setuid =		cap_task_post_setuid,
 	.task_reparent_to_init =	cap_task_reparent_to_init,
 
diff --git a/security/commoncap.c b/security/commoncap.c
index 384379e..5c86fec 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -22,6 +22,7 @@
 #include <linux/ptrace.h>
 #include <linux/xattr.h>
 #include <linux/hugetlb.h>
+#include <linux/mount.h>
 
 int cap_netlink_send(struct sock *sk, struct sk_buff *skb)
 {
@@ -108,15 +109,106 @@ void cap_capset_set (struct task_struct 
 	target->cap_permitted = *permitted;
 }
 
+#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
+
+static inline int cap_from_disk(struct vfs_cap_data_disk *dcap,
+					struct linux_binprm *bprm, int size)
+{
+	int version;
+
+	version = le32_to_cpu(dcap->version);
+	if (version != _LINUX_CAPABILITY_VERSION)
+		return -EINVAL;
+
+	size /= sizeof(u32);
+	if ((size-1)%3) {
+		printk(KERN_WARNING "%s: size is an invalid size %d for %s\n",
+						__FUNCTION__, size, bprm->filename);
+		return -EINVAL;
+	}
+
+	bprm->cap_effective = le32_to_cpu(dcap->data[0]);
+	bprm->cap_permitted = le32_to_cpu(dcap->data[1]);
+	bprm->cap_inheritable = le32_to_cpu(dcap->data[2]);
+
+	return 0;
+}
+
+/* Locate any VFS capabilities: */
+static int set_file_caps(struct linux_binprm *bprm)
+{
+	struct dentry *dentry;
+	int rc;
+	struct vfs_cap_data_disk_v1 v1caps;
+	struct vfs_cap_data_disk *dcaps;
+	struct inode *inode;
+
+	dcaps = (struct vfs_cap_data_disk *)&v1caps;
+	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID)
+		return 0;
+
+	dentry = dget(bprm->file->f_dentry);
+	inode = dentry->d_inode;
+	rc = 0;
+	if (!inode->i_op || !inode->i_op->getxattr)
+		goto out;
+
+	rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, dcaps,
+							XATTR_CAPS_SZ);
+	if (rc == -ENODATA || rc == -EOPNOTSUPP) {
+		rc = 0;
+		goto out;
+	}
+	if (rc == -ERANGE) {
+		int size;
+		size = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, NULL, 0);
+		if (size <= 0) {  /* shouldn't ever happen */
+			rc = -EINVAL;
+			goto out;
+		}
+		dcaps = kmalloc(size, GFP_KERNEL);
+		if (!dcaps) {
+			rc = -ENOMEM;
+			goto out;
+		}
+		rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, dcaps,
+							size);
+	}
+	if (rc < 0)
+		goto out;
+	if (rc < sizeof(struct vfs_cap_data_disk_v1)) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	rc = cap_from_disk(dcaps, bprm, rc);
+
+out:
+	dput(dentry);
+	if ((void *)dcaps != (void *)&v1caps)
+		kfree(dcaps);
+	return rc;
+}
+
+#else
+static inline int set_file_caps(struct linux_binprm *bprm)
+{
+	return 0;
+}
+#endif
+
 int cap_bprm_set_security (struct linux_binprm *bprm)
 {
+	int ret;
+
 	/* Copied from fs/exec.c:prepare_binprm. */
 
-	/* We don't have VFS support for capabilities yet */
 	cap_clear (bprm->cap_inheritable);
 	cap_clear (bprm->cap_permitted);
 	cap_clear (bprm->cap_effective);
 
+	ret = set_file_caps(bprm);
+
 	/*  To support inheritance of root-permissions and suid-root
 	 *  executables under compatibility mode, we raise all three
 	 *  capability sets for the file.
@@ -133,7 +225,8 @@ int cap_bprm_set_security (struct linux_
 		if (bprm->e_uid == 0)
 			cap_set_full (bprm->cap_effective);
 	}
-	return 0;
+
+	return ret;
 }
 
 void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
@@ -181,11 +274,15 @@ void cap_bprm_apply_creds (struct linux_
 
 int cap_bprm_secureexec (struct linux_binprm *bprm)
 {
-	/* If/when this module is enhanced to incorporate capability
-	   bits on files, the test below should be extended to also perform a 
-	   test between the old and new capability sets.  For now,
-	   it simply preserves the legacy decision algorithm used by
-	   the old userland. */
+	if (current->uid != 0) {
+		if (!cap_isclear(bprm->cap_effective))
+			return 1;
+		if (!cap_isclear(bprm->cap_permitted))
+			return 1;
+		if (!cap_isclear(bprm->cap_inheritable))
+			return 1;
+	}
+
 	return (current->euid != current->uid ||
 		current->egid != current->gid);
 }
@@ -299,6 +396,83 @@ int cap_task_post_setuid (uid_t old_ruid
 	return 0;
 }
 
+#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
+/*
+ * Rationale: code calling task_setscheduler, task_setioprio, and
+ * task_setnice, assumes that
+ *   . if capable(cap_sys_nice), then those actions should be allowed
+ *   . if not capable(cap_sys_nice), but acting on your own processes,
+ *   	then those actions should be allowed
+ * This is insufficient now since you can call code without suid, but
+ * yet with increased caps.
+ * So we check for increased caps on the target process.
+ */
+static inline int cap_safe_nice(struct task_struct *p)
+{
+	if (!cap_issubset(p->cap_permitted, current->cap_permitted) &&
+	    !__capable(current, CAP_SYS_NICE))
+		return -EPERM;
+	return 0;
+}
+
+int cap_task_setscheduler (struct task_struct *p, int policy,
+			   struct sched_param *lp)
+{
+	return cap_safe_nice(p);
+}
+
+int cap_task_setioprio (struct task_struct *p, int ioprio)
+{
+	return cap_safe_nice(p);
+}
+
+int cap_task_setnice (struct task_struct *p, int nice)
+{
+	return cap_safe_nice(p);
+}
+
+int cap_task_kill(struct task_struct *p, struct siginfo *info,
+				int sig, u32 secid)
+{
+	if (info != SEND_SIG_NOINFO && (is_si_special(info) || SI_FROMKERNEL(info)))
+		return 0;
+
+	if (secid)
+		/*
+		 * Signal sent as a particular user.
+		 * Capabilities are ignored.  May be wrong, but it's the
+		 * only thing we can do at the moment.
+		 * Used only by usb drivers?
+		 */
+		return 0;
+	if (cap_issubset(p->cap_permitted, current->cap_permitted))
+		return 0;
+	if (capable(CAP_KILL))
+		return 0;
+
+	return -EPERM;
+}
+#else
+int cap_task_setscheduler (struct task_struct *p, int policy,
+			   struct sched_param *lp)
+{
+	return 0;
+}
+int cap_task_setioprio (struct task_struct *p, int ioprio)
+{
+	return 0;
+}
+int cap_task_setnice (struct task_struct *p, int nice)
+{
+	return 0;
+}
+int cap_task_kill(struct task_struct *p, struct siginfo *info,
+				int sig, u32 secid)
+{
+	return 0;
+}
+#endif
+
 void cap_task_reparent_to_init (struct task_struct *p)
 {
 	p->cap_effective = CAP_INIT_EFF_SET;
@@ -336,6 +510,10 @@ EXPORT_SYMBOL(cap_bprm_secureexec);
 EXPORT_SYMBOL(cap_inode_setxattr);
 EXPORT_SYMBOL(cap_inode_removexattr);
 EXPORT_SYMBOL(cap_task_post_setuid);
+EXPORT_SYMBOL(cap_task_kill);
+EXPORT_SYMBOL(cap_task_setscheduler);
+EXPORT_SYMBOL(cap_task_setioprio);
+EXPORT_SYMBOL(cap_task_setnice);
 EXPORT_SYMBOL(cap_task_reparent_to_init);
 EXPORT_SYMBOL(cap_syslog);
 EXPORT_SYMBOL(cap_vm_enough_memory);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index ad8dd4e..af42820 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2823,6 +2823,12 @@ static int selinux_task_setnice(struct t
 
 static int selinux_task_setioprio(struct task_struct *p, int ioprio)
 {
+	int rc;
+
+	rc = secondary_ops->task_setioprio(p, ioprio);
+	if (rc)
+		return rc;
+
 	return task_has_perm(current, p, PROCESS__SETSCHED);
 }
 
@@ -2852,6 +2858,12 @@ static int selinux_task_setrlimit(unsign
 
 static int selinux_task_setscheduler(struct task_struct *p, int policy, struct sched_param *lp)
 {
+	int rc;
+
+	rc = secondary_ops->task_setscheduler(p, policy, lp);
+	if (rc)
+		return rc;
+
 	return task_has_perm(current, p, PROCESS__SETSCHED);
 }
 
-- 
1.1.6
