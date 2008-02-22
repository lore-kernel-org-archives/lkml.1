Return-Path: <linux-kernel-owner+w=401wt.eu-S1764264AbYBVB7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764264AbYBVB7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 20:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbYBVB7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 20:59:30 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:51088 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbYBVB71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 20:59:27 -0500
Message-ID: <47BE2C6F.9090504@kernel.org>
Date: Thu, 21 Feb 2008 17:59:11 -0800
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>, James Morris <jmorris@namei.org>
Subject: Re: [PATCH] capabilities: implement per-process securebits
References: <47BA3E21.2020303@kernel.org> <20080220174252.GA16304@sergelap.austin.ibm.com>
In-Reply-To: <20080220174252.GA16304@sergelap.austin.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Serge E. Hallyn wrote:
|> It all looks good to me.
|
|> Since we've confirmed that wireshark uses capabilities it must be using
|> prctl(PR_SET_KEEPCAPS), so running it might be a good way to verify that
|> your changes to that codepath (with CONFIG_SECURITY_FILE_CAPABILITIES=n)
|> are 100% correct, and might set minds at ease.  Is that something you're
|> set up to be able to do?

I guess I need someone to offer an existence proof that this particular
wireshark code ever worked? (ldd dumpcap|grep libcap). For reference,
I'm looking at:

wireshark-0.99.7/dumpcap.c:302

void
relinquish_privs_except_capture(void)
{
~    /* CAP_NET_ADMIN: Promiscuous mode and a truckload of other
~     *                stuff we don't need (and shouldn't have).
~     * CAP_NET_RAW:   Packet capture (raw sockets).
~     */
~    cap_value_t cap_list[2] = { CAP_NET_ADMIN, CAP_NET_RAW };
~    cap_t caps = cap_init();
~    int cl_len = sizeof(cap_list) / sizeof(cap_value_t);

~    if (started_with_special_privs()) {
~        print_caps("Pre drop, pre set");
~        if (prctl(PR_SET_KEEPCAPS, 1, 0, 0, 0) == -1) {
~            perror("prctl()");
~        }

~        cap_set_flag(caps, CAP_PERMITTED,   cl_len, cap_list, CAP_SET);
~        cap_set_flag(caps, CAP_INHERITABLE, cl_len, cap_list, CAP_SET);

[ XXX:AGM since (caps.pE > caps.pP) this next line should fail ]
~        if (cap_set_proc(caps)) {
~            perror("capset()");
~        }
~        print_caps("Pre drop, post set");
~    }

~    relinquish_special_privs_perm();

~    print_caps("Post drop, pre set");
~    cap_set_flag(caps, CAP_EFFECTIVE,   cl_len, cap_list, CAP_SET);
~    if (cap_set_proc(caps)) {
~        perror("capset()");
~    }
~    print_caps("Post drop, post set");
~    cap_free(caps);
}
#endif /* HAVE_LIBCAP */

My reading of the above code suggests that the application believes that
it can raise/retain effective capabilities that are not in its permitted
set.

Browsing back in my git tree all the way back to 'v2.6.12-rc2', the
following code (cap_capset_check) correctly requires:

~   96  /* verify the _new_Effective_ is a subset of the _new_Permitted_ */
~   97  if (!cap_issubset (*effective, *permitted)) {
~   98   return -EPERM;
~   99  }

so my question is, why should one expect this wireshark code to work? It
looks wrong to me.

Thanks

Andrew

|
|> -serge
|
| Thanks
|
| Andrew

~From 006ddf6903983dd596e360ab1ab8e537b29fab46 Mon Sep 17 00:00:00 2001
From: Andrew G. Morgan <morgan@kernel.org>
Date: Mon, 18 Feb 2008 15:23:28 -0800
Subject: [PATCH] Implement per-process securebits
|>
[This patch represents a no-op unless CONFIG_SECURITY_FILE_CAPABILITIES
~ is enabled at configure time.]
|>
Filesystem capability support makes it possible to do away with
(set)uid-0 based privilege and use capabilities instead. That is, with
filesystem support for capabilities but without this present patch,
it is (conceptually) possible to manage a system with capabilities
alone and never need to obtain privilege via (set)uid-0.
|>
Of course, conceptually isn't quite the same as currently possible
since few user applications, certainly not enough to run a viable
system, are currently prepared to leverage capabilities to exercise
privilege. Further, many applications exist that may never get
upgraded in this way, and the kernel will continue to want to support
their setuid-0 base privilege needs.
|>
Where pure-capability applications evolve and replace setuid-0
binaries, it is desirable that there be a mechanisms by which they
can contain their privilege. In addition to leveraging the per-process
bounding and inheritable sets, this should include suppressing the
privilege of the uid-0 superuser from the process' tree of children.
|>
The feature added by this patch can be leveraged to suppress the
privilege associated with (set)uid-0. This suppression requires
CAP_SETPCAP to initiate, and only immediately affects the 'current'
process (it is inherited through fork()/exec()). This
reimplementation differs significantly from the historical support for
securebits which was system-wide, unwieldy and which has ultimately
withered to a dead relic in the source of the modern kernel.
|>
With this patch applied a process, that is capable(CAP_SETPCAP), can
now drop all legacy privilege (through uid=0) for itself and all
subsequently fork()'d/exec()'d children with:
|>
~  prctl(PR_SET_SECUREBITS, 0x2f);
|>
[2008/02/18: This version includes an int -> long argument fix from Serge.]
|>
Signed-off-by: Andrew G. Morgan <morgan@kernel.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Reviewed-by: James Morris <jmorris@namei.org>
- ---
~ include/linux/capability.h |    3 +-
~ include/linux/init_task.h  |    3 +-
~ include/linux/prctl.h      |    9 +++-
~ include/linux/sched.h      |    3 +-
~ include/linux/securebits.h |   25 ++++++++---
~ include/linux/security.h   |   14 +++---
~ kernel/sys.c               |   25 +----------
~ security/capability.c      |    1 +
~ security/commoncap.c       |  103
++++++++++++++++++++++++++++++++++++++++----
~ security/dummy.c           |    2 +-
~ security/security.c        |    4 +-
~ security/selinux/hooks.c   |    5 +-
~ 12 files changed, 139 insertions(+), 58 deletions(-)
|>
diff --git a/include/linux/capability.h b/include/linux/capability.h
index 7d50ff6..eaab759 100644
- --- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -155,6 +155,7 @@ typedef struct kernel_cap_struct {
~  *   Add any capability from current's capability bounding set
~  *       to the current process' inheritable set
~  *   Allow taking bits out of capability bounding set
+ *   Allow modification of the securebits for a process
~  */

~ #define CAP_SETPCAP          8
@@ -490,8 +491,6 @@ extern const kernel_cap_t __cap_init_eff_set;
~ int capable(int cap);
~ int __capable(struct task_struct *t, int cap);

- -extern long cap_prctl_drop(unsigned long cap);
- -
~ #endif /* __KERNEL__ */

~ #endif /* !_LINUX_CAPABILITY_H */
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 1f74e1d..e8a894a 100644
- --- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -9,6 +9,7 @@
~ #include <linux/ipc.h>
~ #include <linux/pid_namespace.h>
~ #include <linux/user_namespace.h>
+#include <linux/securebits.h>
~ #include <net/net_namespace.h>

~ #define INIT_FDTABLE \
@@ -169,7 +170,7 @@ extern struct group_info init_groups;
~ 	.cap_inheritable = CAP_INIT_INH_SET,				\
~ 	.cap_permitted	= CAP_FULL_SET,					\
~ 	.cap_bset 	= CAP_INIT_BSET,				\
- -	.keep_capabilities = 0,						\
+	.securebits     = SECUREBITS_DEFAULT,				\
~ 	.user		= INIT_USER,					\
~ 	.comm		= "swapper",					\
~ 	.thread		= INIT_THREAD,					\
diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index 3800639..b6c15cc 100644
- --- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -16,7 +16,8 @@
~ # define PR_UNALIGN_NOPRINT	1	/* silently fix up unaligned user
accesses */
~ # define PR_UNALIGN_SIGBUS	2	/* generate SIGBUS on unaligned user
access */

- -/* Get/set whether or not to drop capabilities on setuid() away from
uid 0 */
+/* Get/set whether or not to drop capabilities on setuid() away from
+ * uid 0 (as per security/commoncap.c) */
~ #define PR_GET_KEEPCAPS   7
~ #define PR_SET_KEEPCAPS   8

@@ -63,8 +64,12 @@
~ #define PR_GET_SECCOMP	21
~ #define PR_SET_SECCOMP	22

- -/* Get/set the capability bounding set */
+/* Get/set the capability bounding set (as per security/commoncap.c) */
~ #define PR_CAPBSET_READ 23
~ #define PR_CAPBSET_DROP 24

+/* Get/set securebits (as per security/commoncap.c) */
+#define PR_GET_SECUREBITS 25
+#define PR_SET_SECUREBITS 26
+
~ #endif /* _LINUX_PRCTL_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e217d18..7ea6903 100644
- --- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -69,7 +69,6 @@ struct sched_param {
~ #include <linux/smp.h>
~ #include <linux/sem.h>
~ #include <linux/signal.h>
- -#include <linux/securebits.h>
~ #include <linux/fs_struct.h>
~ #include <linux/compiler.h>
~ #include <linux/completion.h>
@@ -1100,7 +1099,7 @@ struct task_struct {
~ 	gid_t gid,egid,sgid,fsgid;
~ 	struct group_info *group_info;
~ 	kernel_cap_t   cap_effective, cap_inheritable, cap_permitted, cap_bset;
- -	unsigned keep_capabilities:1;
+	unsigned securebits;
~ 	struct user_struct *user;
~ #ifdef CONFIG_KEYS
~ 	struct key *request_key_auth;	/* assumed request_key authority */
diff --git a/include/linux/securebits.h b/include/linux/securebits.h
index 5b06178..c1f19db 100644
- --- a/include/linux/securebits.h
+++ b/include/linux/securebits.h
@@ -3,28 +3,39 @@

~ #define SECUREBITS_DEFAULT 0x00000000

- -extern unsigned securebits;
- -
~ /* When set UID 0 has no special privileges. When unset, we support
~    inheritance of root-permissions and suid-root executable under
~    compatibility mode. We raise the effective and inheritable bitmasks
~    *of the executable file* if the effective uid of the new process is
~    0. If the real uid is 0, we raise the inheritable bitmask of the
~    executable file. */
- -#define SECURE_NOROOT            0
+#define SECURE_NOROOT			0
+#define SECURE_NOROOT_LOCKED		1  /* make bit-0 immutable */

~ /* When set, setuid to/from uid 0 does not trigger capability-"fixes"
~    to be compatible with old programs relying on set*uid to loose
~    privileges. When unset, setuid doesn't change privileges. */
- -#define SECURE_NO_SETUID_FIXUP   2
+#define SECURE_NO_SETUID_FIXUP		2
+#define SECURE_NO_SETUID_FIXUP_LOCKED	3  /* make bit-2 immutable */
+
+/* When set, a process can retain its capabilities even after
+   transitioning to a non-root user (the set-uid fixup suppressed by
+   bit 2). Bit-4 is cleared when a process calls exec(); setting both
+   bit 4 and 5 will create a barrier through exec that no exec()'d
+   child can use this feature again. */
+#define SECURE_KEEP_CAPS		4
+#define SECURE_KEEP_CAPS_LOCKED		5  /* make bit-4 immutable */

~ /* Each securesetting is implemented using two bits. One bit specify
~    whether the setting is on or off. The other bit specify whether the
~    setting is fixed or not. A setting which is fixed cannot be changed
~    from user-level. */
+#define issecure_mask(X)	(1 << (X))
+#define issecure(X)		(issecure_mask(X) & current->securebits)

- -#define issecure(X) ( (1 << (X+1)) & SECUREBITS_DEFAULT ? 	\
- -		      (1 << (X)) & SECUREBITS_DEFAULT :		\
- -		      (1 << (X)) & securebits )
+#define SECURE_ALL_BITS		(issecure_mask(SECURE_NOROOT) | \
+				 issecure_mask(SECURE_NO_SETUID_FIXUP) | \
+				 issecure_mask(SECURE_KEEP_CAPS))
+#define SECURE_ALL_LOCKS	(SECURE_ALL_BITS << 1)

~ #endif /* !_LINUX_SECUREBITS_H */
diff --git a/include/linux/security.h b/include/linux/security.h
index fe52cde..320f2c3 100644
- --- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -40,8 +40,6 @@
~ #define ROOTCONTEXT_MNT		0x04
~ #define DEFCONTEXT_MNT		0x08

- -extern unsigned securebits;
- -
~ struct ctl_table;

~ /*
@@ -64,6 +62,8 @@ extern int cap_inode_killpriv(struct dentry *dentry);
~ extern int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t
old_suid, int flags);
~ extern void cap_task_reparent_to_init (struct task_struct *p);
~ extern int cap_task_kill(struct task_struct *p, struct siginfo *info,
int sig, u32 secid);
+extern int cap_task_prctl(int option, unsigned long arg2, unsigned long
arg3,
+			  unsigned long arg4, unsigned long arg5, long *rc_p);
~ extern int cap_task_setscheduler (struct task_struct *p, int policy,
struct sched_param *lp);
~ extern int cap_task_setioprio (struct task_struct *p, int ioprio);
~ extern int cap_task_setnice (struct task_struct *p, int nice);
@@ -684,7 +684,9 @@ struct request_sock;
~  *	@arg3 contains a argument.
~  *	@arg4 contains a argument.
~  *	@arg5 contains a argument.
- - *	Return 0 if permission is granted.
+ *      @rc_p contains a pointer to communicate back the forced return code
+ *	Return 0 if permission is granted, and non-zero if the security module
+ *      has taken responsibility (setting *rc_p) for the prctl call.
~  * @task_reparent_to_init:
~  * 	Set the security attributes in @p->security for a kernel thread that
~  * 	is being reparented to the init task.
@@ -1346,7 +1348,7 @@ struct security_operations {
~ 	int (*task_wait) (struct task_struct * p);
~ 	int (*task_prctl) (int option, unsigned long arg2,
~ 			   unsigned long arg3, unsigned long arg4,
- -			   unsigned long arg5);
+			   unsigned long arg5, long *rc_p);
~ 	void (*task_reparent_to_init) (struct task_struct * p);
~ 	void (*task_to_inode)(struct task_struct *p, struct inode *inode);

@@ -1600,7 +1602,7 @@ int security_task_kill(struct task_struct *p,
struct siginfo *info,
~ 			int sig, u32 secid);
~ int security_task_wait(struct task_struct *p);
~ int security_task_prctl(int option, unsigned long arg2, unsigned long
arg3,
- -			 unsigned long arg4, unsigned long arg5);
+			 unsigned long arg4, unsigned long arg5, long *rc_p);
~ void security_task_reparent_to_init(struct task_struct *p);
~ void security_task_to_inode(struct task_struct *p, struct inode *inode);
~ int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag);
@@ -2149,7 +2151,7 @@ static inline int security_task_wait (struct
task_struct *p)
~ static inline int security_task_prctl (int option, unsigned long arg2,
~ 				       unsigned long arg3,
~ 				       unsigned long arg4,
- -				       unsigned long arg5)
+				       unsigned long arg5, long *rc_p)
~ {
~ 	return 0;
~ }
diff --git a/kernel/sys.c b/kernel/sys.c
index a626116..bd37fbf 100644
- --- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1628,8 +1628,7 @@ asmlinkage long sys_prctl(int option, unsigned
long arg2, unsigned long arg3,
~ {
~ 	long error;

- -	error = security_task_prctl(option, arg2, arg3, arg4, arg5);
- -	if (error)
+	if (security_task_prctl(option, arg2, arg3, arg4, arg5, &error))
~ 		return error;

~ 	switch (option) {
@@ -1682,17 +1681,6 @@ asmlinkage long sys_prctl(int option, unsigned
long arg2, unsigned long arg3,
~ 				error = -EINVAL;
~ 			break;

- -		case PR_GET_KEEPCAPS:
- -			if (current->keep_capabilities)
- -				error = 1;
- -			break;
- -		case PR_SET_KEEPCAPS:
- -			if (arg2 != 0 && arg2 != 1) {
- -				error = -EINVAL;
- -				break;
- -			}
- -			current->keep_capabilities = arg2;
- -			break;
~ 		case PR_SET_NAME: {
~ 			struct task_struct *me = current;
~ 			unsigned char ncomm[sizeof(me->comm)];
@@ -1727,17 +1715,6 @@ asmlinkage long sys_prctl(int option, unsigned
long arg2, unsigned long arg3,
~ 			error = prctl_set_seccomp(arg2);
~ 			break;

- -		case PR_CAPBSET_READ:
- -			if (!cap_valid(arg2))
- -				return -EINVAL;
- -			return !!cap_raised(current->cap_bset, arg2);
- -		case PR_CAPBSET_DROP:
- -#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
- -			return cap_prctl_drop(arg2);
- -#else
- -			return -EINVAL;
- -#endif
- -
~ 		default:
~ 			error = -EINVAL;
~ 			break;
diff --git a/security/capability.c b/security/capability.c
index 9e99f36..8340655 100644
- --- a/security/capability.c
+++ b/security/capability.c
@@ -45,6 +45,7 @@ static struct security_operations capability_ops = {
~ 	.task_setioprio =		cap_task_setioprio,
~ 	.task_setnice =			cap_task_setnice,
~ 	.task_post_setuid =		cap_task_post_setuid,
+	.task_prctl =                   cap_task_prctl,
~ 	.task_reparent_to_init =	cap_task_reparent_to_init,

~ 	.syslog =                       cap_syslog,
diff --git a/security/commoncap.c b/security/commoncap.c
index 5aba826..858387a 100644
- --- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -24,11 +24,8 @@
~ #include <linux/hugetlb.h>
~ #include <linux/mount.h>
~ #include <linux/sched.h>
- -
- -/* Global security state */
- -
- -unsigned securebits = SECUREBITS_DEFAULT; /* systemwide security
settings */
- -EXPORT_SYMBOL(securebits);
+#include <linux/prctl.h>
+#include <linux/securebits.h>

~ int cap_netlink_send(struct sock *sk, struct sk_buff *skb)
~ {
@@ -368,7 +365,7 @@ void cap_bprm_apply_creds (struct linux_binprm
*bprm, int unsafe)

~ 	/* AUD: Audit candidate if current->cap_effective is set */

- -	current->keep_capabilities = 0;
+	current->securebits &= ~issecure_mask(SECURE_KEEP_CAPS);
~ }

~ int cap_bprm_secureexec (struct linux_binprm *bprm)
@@ -448,7 +445,7 @@ static inline void cap_emulate_setxuid (int
old_ruid, int old_euid,
~ {
~ 	if ((old_ruid == 0 || old_euid == 0 || old_suid == 0) &&
~ 	    (current->uid != 0 && current->euid != 0 && current->suid != 0) &&
- -	    !current->keep_capabilities) {
+	    !issecure(SECURE_KEEP_CAPS)) {
~ 		cap_clear (current->cap_permitted);
~ 		cap_clear (current->cap_effective);
~ 	}
@@ -582,7 +579,7 @@ int cap_task_kill(struct task_struct *p, struct
siginfo *info,
~  * this task could get inconsistent info.  There can be no
~  * racing writer bc a task can only change its own caps.
~  */
- -long cap_prctl_drop(unsigned long cap)
+static long cap_prctl_drop(unsigned long cap)
~ {
~ 	if (!capable(CAP_SETPCAP))
~ 		return -EPERM;
@@ -591,6 +588,7 @@ long cap_prctl_drop(unsigned long cap)
~ 	cap_lower(current->cap_bset, cap);
~ 	return 0;
~ }
+
~ #else
~ int cap_task_setscheduler (struct task_struct *p, int policy,
~ 			   struct sched_param *lp)
@@ -612,12 +610,99 @@ int cap_task_kill(struct task_struct *p, struct
siginfo *info,
~ }
~ #endif

+int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
+		   unsigned long arg4, unsigned long arg5, long *rc_p)
+{
+	long error = 0;
+
+	switch (option) {
+	case PR_CAPBSET_READ:
+		if (!cap_valid(arg2))
+			error = -EINVAL;
+		else
+			error = !!cap_raised(current->cap_bset, arg2);
+		break;
+#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
+	case PR_CAPBSET_DROP:
+		error = cap_prctl_drop(arg2);
+		break;
+
+	/*
+	 * The next four prctl's remain to assist with transitioning a
+	 * system from legacy UID=0 based privilege (when filesystem
+	 * capabilities are not in use) to a system using filesystem
+	 * capabilities only - as the POSIX.1e draft intended.
+	 *
+	 * Note:
+	 *
+	 *  PR_SET_SECUREBITS =
+	 *      issecure_mask(SECURE_KEEP_CAPS_LOCKED)
+	 *    | issecure_mask(SECURE_NOROOT)
+	 *    | issecure_mask(SECURE_NOROOT_LOCKED)
+	 *    | issecure_mask(SECURE_NO_SETUID_FIXUP)
+	 *    | issecure_mask(SECURE_NO_SETUID_FIXUP_LOCKED)
+	 *
+	 * will ensure that the current process and all of its
+	 * children will be locked into a pure
+	 * capability-based-privilege environment.
+	 */
+	case PR_SET_SECUREBITS:
+		if ((((current->securebits & SECURE_ALL_LOCKS) >> 1)
+		     & (current->securebits ^ arg2))                  /*[1]*/
+		    || ((current->securebits & SECURE_ALL_LOCKS
+			 & ~arg2))                                    /*[2]*/
+		    || (arg2 & ~(SECURE_ALL_LOCKS | SECURE_ALL_BITS)) /*[3]*/
+		    || (cap_capable(current, CAP_SETPCAP) != 0)) {    /*[4]*/
+			/*
+			 * [1] no changing of bits that are locked
+			 * [2] no unlocking of locks
+			 * [3] no setting of unsupported bits
+			 * [4] doing anything requires privilege (go read about
+			 *     the "sendmail capabilities bug")
+			 */
+			error = -EPERM;  /* cannot change a locked bit */
+		} else {
+			current->securebits = arg2;
+		}
+		break;
+	case PR_GET_SECUREBITS:
+		error = current->securebits;
+		break;
+
+#endif /* def CONFIG_SECURITY_FILE_CAPABILITIES */
+
+	case PR_GET_KEEPCAPS:
+		if (issecure(SECURE_KEEP_CAPS))
+			error = 1;
+		break;
+	case PR_SET_KEEPCAPS:
+		if (arg2 > 1) /* Note, we rely on arg2 being unsigned here */
+			error = -EINVAL;
+		else if (issecure(SECURE_KEEP_CAPS_LOCKED))
+			error = -EPERM;
+		else if (arg2)
+			current->securebits |= issecure_mask(SECURE_KEEP_CAPS);
+		else
+			current->securebits &=
+				~issecure_mask(SECURE_KEEP_CAPS);
+		break;
+
+	default:
+		/* No functionality available - continue with default */
+		return 0;
+	}
+
+	/* Functionality provided */
+	*rc_p = error;
+	return 1;
+}
+
~ void cap_task_reparent_to_init (struct task_struct *p)
~ {
~ 	cap_set_init_eff(p->cap_effective);
~ 	cap_clear(p->cap_inheritable);
~ 	cap_set_full(p->cap_permitted);
- -	p->keep_capabilities = 0;
+	p->securebits = SECUREBITS_DEFAULT;
~ 	return;
~ }

diff --git a/security/dummy.c b/security/dummy.c
index 649326b..e79f988 100644
- --- a/security/dummy.c
+++ b/security/dummy.c
@@ -595,7 +595,7 @@ static int dummy_task_kill (struct task_struct *p,
struct siginfo *info,
~ }

~ static int dummy_task_prctl (int option, unsigned long arg2, unsigned
long arg3,
- -			     unsigned long arg4, unsigned long arg5)
+			     unsigned long arg4, unsigned long arg5, long *rc_p)
~ {
~ 	return 0;
~ }
diff --git a/security/security.c b/security/security.c
index d15e56c..744ca33 100644
- --- a/security/security.c
+++ b/security/security.c
@@ -685,9 +685,9 @@ int security_task_wait(struct task_struct *p)
~ }

~ int security_task_prctl(int option, unsigned long arg2, unsigned long
arg3,
- -			 unsigned long arg4, unsigned long arg5)
+			 unsigned long arg4, unsigned long arg5, long *rc_p)
~ {
- -	return security_ops->task_prctl(option, arg2, arg3, arg4, arg5);
+	return security_ops->task_prctl(option, arg2, arg3, arg4, arg5, rc_p);
~ }

~ void security_task_reparent_to_init(struct task_struct *p)
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 75c2e99..5cc7542 100644
- --- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3226,12 +3226,13 @@ static int selinux_task_prctl(int option,
~ 			      unsigned long arg2,
~ 			      unsigned long arg3,
~ 			      unsigned long arg4,
- -			      unsigned long arg5)
+			      unsigned long arg5,
+			      long *rc_p)
~ {
~ 	/* The current prctl operations do not appear to require
~ 	   any SELinux controls since they merely observe or modify
~ 	   the state of the current process. */
- -	return 0;
+	return secondary_ops->task_prctl(option, arg2, arg3, arg4, arg5, rc_p);
~ }

~ static int selinux_task_wait(struct task_struct *p)
- --
1.5.3.7
|>

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFHvixu+bHCR3gb8jsRAuTIAJ0aWvUbEYlj450zm8/X7o9moi+OkgCg1Zzx
8J2D2lh7xWOdliYQARxwpSA=
=5LgO
-----END PGP SIGNATURE-----
