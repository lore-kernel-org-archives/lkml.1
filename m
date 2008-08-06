Return-Path: <linux-kernel-owner+w=401wt.eu-S964851AbYHFPvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964851AbYHFPvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759781AbYHFPih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:38:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759485AbYHFPiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:38:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 07/24] CRED: Wrap most current->e?[ug]id and some
	task->e?[ug]id [ver #7]
To: jmorris@namei.org, akpm@linux-foundation.org, morgan@kernel.org
Cc: sfr@canb.auug.org.au, dhowells@redhat.com, viro@ftp.linux.org.uk,
       casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Wed, 06 Aug 2008 16:37:50 +0100
Message-ID: <20080806153750.14351.38971.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
References: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change most current->e?[ug]id to current_e?[ug]id().

Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
sense to use RCU directly rather than a convenient wrapper; these are addressed
by a later patch (see the patch entitled "CRED: Use RCU to access another
task's creds and to release a task's own creds").

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---

 arch/ia64/kernel/mca_drv.c       |    2 -
 arch/ia64/kernel/perfmon.c       |   19 +++++---
 arch/ia64/kernel/signal.c        |    4 +-
 arch/mips/kernel/mips-mt-fpaff.c |    5 +-
 arch/parisc/kernel/signal.c      |    2 -
 arch/powerpc/mm/fault.c          |    2 -
 arch/s390/hypfs/inode.c          |    4 +-
 arch/x86/mm/fault.c              |    2 -
 drivers/block/loop.c             |    6 ++-
 drivers/char/tty_audit.c         |    6 ++-
 drivers/gpu/drm/drm_fops.c       |    2 -
 drivers/media/video/cpia.c       |    2 -
 drivers/net/tun.c                |    4 +-
 drivers/net/wan/sbni.c           |    9 ++--
 drivers/usb/core/devio.c         |    8 ++-
 fs/affs/super.c                  |    4 +-
 fs/autofs/inode.c                |    4 +-
 fs/autofs4/inode.c               |    4 +-
 fs/autofs4/waitq.c               |    4 +-
 fs/binfmt_elf_fdpic.c            |    8 ++-
 fs/cifs/cifs_fs_sb.h             |    2 -
 fs/cifs/connect.c                |    4 +-
 fs/cifs/ioctl.c                  |    2 -
 fs/dquot.c                       |    2 -
 fs/ecryptfs/messaging.c          |   18 ++++----
 fs/ecryptfs/miscdev.c            |   20 +++++---
 fs/exec.c                        |   14 +++---
 fs/fat/inode.c                   |    4 +-
 fs/fcntl.c                       |    2 -
 fs/hfs/super.c                   |    4 +-
 fs/hfsplus/options.c             |    4 +-
 fs/hpfs/super.c                  |    4 +-
 fs/inotify_user.c                |    2 -
 fs/ioprio.c                      |    4 +-
 fs/namespace.c                   |    2 -
 fs/ncpfs/ioctl.c                 |   91 ++++++++++++++++++--------------------
 fs/omfs/inode.c                  |    4 +-
 fs/quota.c                       |    4 +-
 fs/smbfs/dir.c                   |    4 +-
 fs/smbfs/inode.c                 |    2 -
 fs/smbfs/proc.c                  |    2 -
 fs/xfs/linux-2.6/xfs_cred.h      |    2 -
 include/linux/cred.h             |   25 ++++++++++
 include/net/scm.h                |    4 +-
 ipc/mqueue.c                     |    2 -
 ipc/shm.c                        |    5 +-
 ipc/util.c                       |   18 +++++---
 kernel/acct.c                    |    7 +--
 kernel/auditsc.c                 |    6 ++-
 kernel/cgroup.c                  |    5 +-
 kernel/futex.c                   |    8 ++-
 kernel/futex_compat.c            |    3 +
 kernel/ptrace.c                  |   15 ++++--
 kernel/sched.c                   |   11 +++--
 kernel/signal.c                  |   15 ++++--
 kernel/sys.c                     |   16 +++----
 kernel/sysctl.c                  |    2 -
 kernel/timer.c                   |    8 ++-
 kernel/user_namespace.c          |    2 -
 mm/mempolicy.c                   |    7 ++-
 mm/migrate.c                     |    7 ++-
 net/ax25/af_ax25.c               |    2 -
 net/ax25/ax25_route.c            |    2 -
 net/core/dev.c                   |    8 +++
 net/core/scm.c                   |    8 ++-
 net/ipv6/ip6_flowlabel.c         |    2 -
 net/netrom/af_netrom.c           |    4 +-
 net/rose/af_rose.c               |    4 +-
 net/unix/af_unix.c               |   11 ++---
 security/commoncap.c             |   27 +++++++----
 70 files changed, 304 insertions(+), 228 deletions(-)


diff --git a/arch/ia64/kernel/mca_drv.c b/arch/ia64/kernel/mca_drv.c
index fab1d21..f94aaa8 100644
--- a/arch/ia64/kernel/mca_drv.c
+++ b/arch/ia64/kernel/mca_drv.c
@@ -158,7 +158,7 @@ mca_handler_bh(unsigned long paddr, void *iip, unsigned long ipsr)
 	ia64_mlogbuf_dump();
 	printk(KERN_ERR "OS_MCA: process [cpu %d, pid: %d, uid: %d, "
 		"iip: %p, psr: 0x%lx,paddr: 0x%lx](%s) encounters MCA.\n",
-		raw_smp_processor_id(), current->pid, current->uid,
+	       raw_smp_processor_id(), current->pid, current_uid(),
 		iip, ipsr, paddr, current->comm);
 
 	spin_lock(&mca_bh_lock);
diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index 0cd24b2..ffe6de0 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -2403,22 +2403,25 @@ error_kmem:
 static int
 pfm_bad_permissions(struct task_struct *task)
 {
+	uid_t uid = current_uid();
+	gid_t gid = current_gid();
+
 	/* inspired by ptrace_attach() */
 	DPRINT(("cur: uid=%d gid=%d task: euid=%d suid=%d uid=%d egid=%d sgid=%d\n",
-		current->uid,
-		current->gid,
+		uid,
+		gid,
 		task->euid,
 		task->suid,
 		task->uid,
 		task->egid,
 		task->sgid));
 
-	return ((current->uid != task->euid)
-	    || (current->uid != task->suid)
-	    || (current->uid != task->uid)
-	    || (current->gid != task->egid)
-	    || (current->gid != task->sgid)
-	    || (current->gid != task->gid)) && !capable(CAP_SYS_PTRACE);
+	return (uid != task->euid)
+	    || (uid != task->suid)
+	    || (uid != task->uid)
+	    || (gid != task->egid)
+	    || (gid != task->sgid)
+	    || (gid != task->gid)) && !capable(CAP_SYS_PTRACE);
 }
 
 static int
diff --git a/arch/ia64/kernel/signal.c b/arch/ia64/kernel/signal.c
index 19c5a78..434e93e 100644
--- a/arch/ia64/kernel/signal.c
+++ b/arch/ia64/kernel/signal.c
@@ -228,7 +228,7 @@ ia64_rt_sigreturn (struct sigscratch *scr)
 	si.si_errno = 0;
 	si.si_code = SI_KERNEL;
 	si.si_pid = task_pid_vnr(current);
-	si.si_uid = current->uid;
+	si.si_uid = current_uid();
 	si.si_addr = sc;
 	force_sig_info(SIGSEGV, &si, current);
 	return retval;
@@ -325,7 +325,7 @@ force_sigsegv_info (int sig, void __user *addr)
 	si.si_errno = 0;
 	si.si_code = SI_KERNEL;
 	si.si_pid = task_pid_vnr(current);
-	si.si_uid = current->uid;
+	si.si_uid = current_uid();
 	si.si_addr = addr;
 	force_sig_info(SIGSEGV, &si, current);
 	return 0;
diff --git a/arch/mips/kernel/mips-mt-fpaff.c b/arch/mips/kernel/mips-mt-fpaff.c
index df4d3f2..928c72b 100644
--- a/arch/mips/kernel/mips-mt-fpaff.c
+++ b/arch/mips/kernel/mips-mt-fpaff.c
@@ -51,6 +51,7 @@ asmlinkage long mipsmt_sys_sched_setaffinity(pid_t pid, unsigned int len,
 	int retval;
 	struct task_struct *p;
 	struct thread_info *ti;
+	uid_t euid;
 
 	if (len < sizeof(new_mask))
 		return -EINVAL;
@@ -76,9 +77,9 @@ asmlinkage long mipsmt_sys_sched_setaffinity(pid_t pid, unsigned int len,
 	 */
 	get_task_struct(p);
 
+	euid = current_euid();
 	retval = -EPERM;
-	if ((current->euid != p->euid) && (current->euid != p->uid) &&
-			!capable(CAP_SYS_NICE)) {
+	if (euid != p->euid && euid != p->uid && !capable(CAP_SYS_NICE)) {
 		read_unlock(&tasklist_lock);
 		goto out_unlock;
 	}
diff --git a/arch/parisc/kernel/signal.c b/arch/parisc/kernel/signal.c
index 06213d1..f825442 100644
--- a/arch/parisc/kernel/signal.c
+++ b/arch/parisc/kernel/signal.c
@@ -182,7 +182,7 @@ give_sigsegv:
 	si.si_errno = 0;
 	si.si_code = SI_KERNEL;
 	si.si_pid = task_pid_vnr(current);
-	si.si_uid = current->uid;
+	si.si_uid = current_uid();
 	si.si_addr = &frame->uc;
 	force_sig_info(SIGSEGV, &si, current);
 	return;
diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 565b7a2..8660986 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -339,7 +339,7 @@ bad_area_nosemaphore:
 	    && printk_ratelimit())
 		printk(KERN_CRIT "kernel tried to execute NX-protected"
 		       " page (%lx) - exploit attempt? (uid: %d)\n",
-		       address, current->uid);
+		       address, current_uid());
 
 	return SIGSEGV;
 
diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 7383781..5a11c77 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -280,8 +280,8 @@ static int hypfs_fill_super(struct super_block *sb, void *data, int silent)
 	if (!sbi)
 		return -ENOMEM;
 	mutex_init(&sbi->lock);
-	sbi->uid = current->uid;
-	sbi->gid = current->gid;
+	sbi->uid = current_uid();
+	sbi->gid = current_gid();
 	sb->s_fs_info = sbi;
 	sb->s_blocksize = PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 455f3fe..5fc291c 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -394,7 +394,7 @@ static void show_fault_oops(struct pt_regs *regs, unsigned long error_code,
 		if (pte && pte_present(*pte) && !pte_exec(*pte))
 			printk(KERN_CRIT "kernel tried to execute "
 				"NX-protected page - exploit attempt? "
-				"(uid: %d)\n", current->uid);
+				"(uid: %d)\n", current_uid());
 	}
 #endif
 
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index d3a25b0..e96bc38 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -936,8 +936,10 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 {
 	int err;
 	struct loop_func_table *xfer;
+	uid_t uid = current_uid();
 
-	if (lo->lo_encrypt_key_size && lo->lo_key_owner != current->uid &&
+	if (lo->lo_encrypt_key_size &&
+	    lo->lo_key_owner != uid &&
 	    !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	if (lo->lo_state != Lo_bound)
@@ -992,7 +994,7 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 	if (info->lo_encrypt_key_size) {
 		memcpy(lo->lo_encrypt_key, info->lo_encrypt_key,
 		       info->lo_encrypt_key_size);
-		lo->lo_key_owner = current->uid;
+		lo->lo_key_owner = uid;
 	}	
 
 	return 0;
diff --git a/drivers/char/tty_audit.c b/drivers/char/tty_audit.c
index 3582f43..570d337 100644
--- a/drivers/char/tty_audit.c
+++ b/drivers/char/tty_audit.c
@@ -86,10 +86,12 @@ static void tty_audit_buf_push(struct task_struct *tsk, uid_t loginuid,
 	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_TTY);
 	if (ab) {
 		char name[sizeof(tsk->comm)];
+		uid_t uid = task_uid(tsk);
 
 		audit_log_format(ab, "tty pid=%u uid=%u auid=%u ses=%u "
-				 "major=%d minor=%d comm=", tsk->pid, tsk->uid,
-				 loginuid, sessionid, buf->major, buf->minor);
+				 "major=%d minor=%d comm=",
+				 tsk->pid, uid, loginuid, sessionid,
+				 buf->major, buf->minor);
 		get_task_comm(name, tsk);
 		audit_log_untrustedstring(ab, name);
 		audit_log_format(ab, " data=");
diff --git a/drivers/gpu/drm/drm_fops.c b/drivers/gpu/drm/drm_fops.c
index 851a53f..dcf8b4d 100644
--- a/drivers/gpu/drm/drm_fops.c
+++ b/drivers/gpu/drm/drm_fops.c
@@ -246,7 +246,7 @@ static int drm_open_helper(struct inode *inode, struct file *filp,
 	memset(priv, 0, sizeof(*priv));
 	filp->private_data = priv;
 	priv->filp = filp;
-	priv->uid = current->euid;
+	priv->uid = current_euid();
 	priv->pid = task_pid_nr(current);
 	priv->minor = idr_find(&drm_minors_idr, minor_id);
 	priv->ioctl_count = 0;
diff --git a/drivers/media/video/cpia.c b/drivers/media/video/cpia.c
index dc8cc61..824cb99 100644
--- a/drivers/media/video/cpia.c
+++ b/drivers/media/video/cpia.c
@@ -3202,7 +3202,7 @@ static int cpia_open(struct inode *inode, struct file *file)
 
 	/* Set ownership of /proc/cpia/videoX to current user */
 	if(cam->proc_entry)
-		cam->proc_entry->uid = current->uid;
+		cam->proc_entry->uid = current_uid();
 
 	/* set mark for loading first frame uncompressed */
 	cam->first_frame = 1;
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index e6bbc63..4174855 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -654,9 +654,9 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 
 		/* Check permissions */
 		if (((tun->owner != -1 &&
-		      current->euid != tun->owner) ||
+		      current_euid() != tun->owner) ||
 		     (tun->group != -1 &&
-		      current->egid != tun->group)) &&
+		      current_egid() != tun->group)) &&
 		     !capable(CAP_NET_ADMIN))
 			return -EPERM;
 	}
diff --git a/drivers/net/wan/sbni.c b/drivers/net/wan/sbni.c
index e59255a..1ae5bae 100644
--- a/drivers/net/wan/sbni.c
+++ b/drivers/net/wan/sbni.c
@@ -1302,6 +1302,7 @@ sbni_ioctl( struct net_device  *dev,  struct ifreq  *ifr,  int  cmd )
 {
 	struct net_local  *nl = (struct net_local *) dev->priv; 
 	struct sbni_flags  flags;
+	uid_t euid = current_euid();
 	int  error = 0;
 
 #ifdef CONFIG_SBNI_MULTILINE
@@ -1317,7 +1318,7 @@ sbni_ioctl( struct net_device  *dev,  struct ifreq  *ifr,  int  cmd )
 		break;
 
 	case  SIOCDEVRESINSTATS :
-		if( current->euid != 0 )	/* root only */
+		if (euid != 0)	/* root only */
 			return  -EPERM;
 		memset( &nl->in_stats, 0, sizeof(struct sbni_in_stats) );
 		break;
@@ -1334,7 +1335,7 @@ sbni_ioctl( struct net_device  *dev,  struct ifreq  *ifr,  int  cmd )
 		break;
 
 	case  SIOCDEVSHWSTATE :
-		if( current->euid != 0 )	/* root only */
+		if (euid != 0)	/* root only */
 			return  -EPERM;
 
 		spin_lock( &nl->lock );
@@ -1355,7 +1356,7 @@ sbni_ioctl( struct net_device  *dev,  struct ifreq  *ifr,  int  cmd )
 #ifdef CONFIG_SBNI_MULTILINE
 
 	case  SIOCDEVENSLAVE :
-		if( current->euid != 0 )	/* root only */
+		if (euid != 0)	/* root only */
 			return  -EPERM;
 
 		if (copy_from_user( slave_name, ifr->ifr_data, sizeof slave_name ))
@@ -1370,7 +1371,7 @@ sbni_ioctl( struct net_device  *dev,  struct ifreq  *ifr,  int  cmd )
 		return  enslave( dev, slave_dev );
 
 	case  SIOCDEVEMANSIPATE :
-		if( current->euid != 0 )	/* root only */
+		if (euid != 0)	/* root only */
 			return  -EPERM;
 
 		return  emancipate( dev );
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 20290c5..6c7c115 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -616,8 +616,8 @@ static int usbdev_open(struct inode *inode, struct file *file)
 	init_waitqueue_head(&ps->wait);
 	ps->discsignr = 0;
 	ps->disc_pid = get_pid(task_pid(current));
-	ps->disc_uid = current->uid;
-	ps->disc_euid = current->euid;
+	ps->disc_uid = current_uid();
+	ps->disc_euid = current_euid();
 	ps->disccontext = NULL;
 	ps->ifclaimed = 0;
 	security_task_getsecid(current, &ps->secid);
@@ -1171,8 +1171,8 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 	as->signr = uurb->signr;
 	as->ifnum = ifnum;
 	as->pid = get_pid(task_pid(current));
-	as->uid = current->uid;
-	as->euid = current->euid;
+	as->uid = current_uid();
+	as->euid = current_euid();
 	security_task_getsecid(current, &as->secid);
 	if (!is_in) {
 		if (copy_from_user(as->urb->transfer_buffer, uurb->buffer,
diff --git a/fs/affs/super.c b/fs/affs/super.c
index 3a89094..d5d9b10 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -163,8 +163,8 @@ parse_options(char *options, uid_t *uid, gid_t *gid, int *mode, int *reserved, s
 
 	/* Fill in defaults */
 
-	*uid        = current->uid;
-	*gid        = current->gid;
+	*uid        = current_uid();
+	*gid        = current_gid();
 	*reserved   = 2;
 	*root       = -1;
 	*blocksize  = -1;
diff --git a/fs/autofs/inode.c b/fs/autofs/inode.c
index dda510d..61429c5 100644
--- a/fs/autofs/inode.c
+++ b/fs/autofs/inode.c
@@ -76,8 +76,8 @@ static int parse_options(char *options, int *pipefd, uid_t *uid, gid_t *gid,
 	substring_t args[MAX_OPT_ARGS];
 	int option;
 
-	*uid = current->uid;
-	*gid = current->gid;
+	*uid = current_uid();
+	*gid = current_gid();
 	*pgrp = task_pgrp_nr(current);
 
 	*minproto = *maxproto = AUTOFS_PROTO_VERSION;
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index 7bb3e5b..8c9cf24 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -233,8 +233,8 @@ static int parse_options(char *options, int *pipefd, uid_t *uid, gid_t *gid,
 	substring_t args[MAX_OPT_ARGS];
 	int option;
 
-	*uid = current->uid;
-	*gid = current->gid;
+	*uid = current_uid();
+	*gid = current_gid();
 	*pgrp = task_pgrp_nr(current);
 
 	*minproto = AUTOFS_MIN_PROTO_VERSION;
diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index 35216d1..dc1fa39 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -391,8 +391,8 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 		memcpy(&wq->name, &qstr, sizeof(struct qstr));
 		wq->dev = autofs4_get_dev(sbi);
 		wq->ino = autofs4_get_ino(sbi);
-		wq->uid = current->uid;
-		wq->gid = current->gid;
+		wq->uid = current_uid();
+		wq->gid = current_gid();
 		wq->pid = current->pid;
 		wq->tgid = current->tgid;
 		wq->status = -EINTR; /* Status return if interrupted */
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 80c1f95..cee7ed4 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -586,10 +586,10 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 	NEW_AUX_ENT(AT_BASE,	interp_params->elfhdr_addr);
 	NEW_AUX_ENT(AT_FLAGS,	0);
 	NEW_AUX_ENT(AT_ENTRY,	exec_params->entry_addr);
-	NEW_AUX_ENT(AT_UID,	(elf_addr_t) current->uid);
-	NEW_AUX_ENT(AT_EUID,	(elf_addr_t) current->euid);
-	NEW_AUX_ENT(AT_GID,	(elf_addr_t) current->gid);
-	NEW_AUX_ENT(AT_EGID,	(elf_addr_t) current->egid);
+	NEW_AUX_ENT(AT_UID,	(elf_addr_t) current_uid());
+	NEW_AUX_ENT(AT_EUID,	(elf_addr_t) current_euid());
+	NEW_AUX_ENT(AT_GID,	(elf_addr_t) current_gid());
+	NEW_AUX_ENT(AT_EGID,	(elf_addr_t) current_egid());
 
 #ifdef ARCH_DLINFO
 	nr = 0;
diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 877c854..1e7b874 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -19,7 +19,7 @@
 #define _CIFS_FS_SB_H
 
 #define CIFS_MOUNT_NO_PERM      1 /* do not do client vfs_perm check */
-#define CIFS_MOUNT_SET_UID      2 /* set current->euid in create etc. */
+#define CIFS_MOUNT_SET_UID      2 /* set current's euid in create etc. */
 #define CIFS_MOUNT_SERVER_INUM  4 /* inode numbers from uniqueid from server */
 #define CIFS_MOUNT_DIRECT_IO    8 /* do not write nor read through page cache */
 #define CIFS_MOUNT_NO_XATTR     0x10  /* if set - disable xattr support       */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index b51d577..ec56417 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -827,8 +827,8 @@ cifs_parse_mount_options(char *options, const char *devname,
 	/* null target name indicates to use *SMBSERVR default called name
 	   if we end up sending RFC1001 session initialize */
 	vol->target_rfc1001_name[0] = 0;
-	vol->linux_uid = current->uid;	/* current->euid instead? */
-	vol->linux_gid = current->gid;
+	vol->linux_uid = current_uid();  /* use current_euid() instead? */
+	vol->linux_gid = current_gid();
 	vol->dir_mode = S_IRWXUGO;
 	/* 2767 perms indicate mandatory locking support */
 	vol->file_mode = (S_IRWXUGO | S_ISGID) & (~S_IXGRP);
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 0088a5b..f946506 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -65,7 +65,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 	switch (command) {
 		case CIFS_IOC_CHECKUMOUNT:
 			cFYI(1, ("User unmount attempted"));
-			if (cifs_sb->mnt_uid == current->uid)
+			if (cifs_sb->mnt_uid == current_uid())
 				rc = 0;
 			else {
 				rc = -EACCES;
diff --git a/fs/dquot.c b/fs/dquot.c
index 7307324..991d995 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -985,7 +985,7 @@ static void send_warning(const struct dquot *dquot, const char warntype)
 		MINOR(dquot->dq_sb->s_dev));
 	if (ret)
 		goto attr_err_out;
-	ret = nla_put_u64(skb, QUOTA_NL_A_CAUSED_ID, current->user->uid);
+	ret = nla_put_u64(skb, QUOTA_NL_A_CAUSED_ID, current_uid());
 	if (ret)
 		goto attr_err_out;
 	genlmsg_end(skb, msg_head);
diff --git a/fs/ecryptfs/messaging.c b/fs/ecryptfs/messaging.c
index 1b5c200..92bf606 100644
--- a/fs/ecryptfs/messaging.c
+++ b/fs/ecryptfs/messaging.c
@@ -377,6 +377,7 @@ int ecryptfs_process_response(struct ecryptfs_message *msg, uid_t euid,
 	size_t msg_size;
 	struct nsproxy *nsproxy;
 	struct user_namespace *current_user_ns;
+	uid_t ctx_euid;
 	int rc;
 
 	if (msg->index >= ecryptfs_message_buf_len) {
@@ -401,8 +402,8 @@ int ecryptfs_process_response(struct ecryptfs_message *msg, uid_t euid,
 		goto wake_up;
 	}
 	current_user_ns = nsproxy->user_ns;
-	rc = ecryptfs_find_daemon_by_euid(&daemon, msg_ctx->task->euid,
-					  current_user_ns);
+	ctx_euid = task_euid(msg_ctx->task);
+	rc = ecryptfs_find_daemon_by_euid(&daemon, ctx_euid, current_user_ns);
 	rcu_read_unlock();
 	mutex_unlock(&ecryptfs_daemon_hash_mux);
 	if (rc) {
@@ -410,14 +411,14 @@ int ecryptfs_process_response(struct ecryptfs_message *msg, uid_t euid,
 		printk(KERN_WARNING "%s: User [%d] received a "
 		       "message response from process [0x%p] but does "
 		       "not have a registered daemon\n", __func__,
-		       msg_ctx->task->euid, pid);
+		       ctx_euid, pid);
 		goto wake_up;
 	}
-	if (msg_ctx->task->euid != euid) {
+	if (ctx_euid != euid) {
 		rc = -EBADMSG;
 		printk(KERN_WARNING "%s: Received message from user "
 		       "[%d]; expected message from user [%d]\n", __func__,
-		       euid, msg_ctx->task->euid);
+		       euid, ctx_euid);
 		goto unlock;
 	}
 	if (current_user_ns != user_ns) {
@@ -431,7 +432,7 @@ int ecryptfs_process_response(struct ecryptfs_message *msg, uid_t euid,
 		rc = -EBADMSG;
 		printk(KERN_ERR "%s: User [%d] sent a message response "
 		       "from an unrecognized process [0x%p]\n",
-		       __func__, msg_ctx->task->euid, pid);
+		       __func__, ctx_euid, pid);
 		goto unlock;
 	}
 	if (msg_ctx->state != ECRYPTFS_MSG_CTX_STATE_PENDING) {
@@ -482,14 +483,15 @@ ecryptfs_send_message_locked(unsigned int transport, char *data, int data_len,
 			     u8 msg_type, struct ecryptfs_msg_ctx **msg_ctx)
 {
 	struct ecryptfs_daemon *daemon;
+	uid_t euid = current_euid();
 	int rc;
 
-	rc = ecryptfs_find_daemon_by_euid(&daemon, current->euid,
+	rc = ecryptfs_find_daemon_by_euid(&daemon, euid,
 					  current->nsproxy->user_ns);
 	if (rc || !daemon) {
 		rc = -ENOTCONN;
 		printk(KERN_ERR "%s: User [%d] does not have a daemon "
-		       "registered\n", __func__, current->euid);
+		       "registered\n", __func__, euid);
 		goto out;
 	}
 	mutex_lock(&ecryptfs_msg_ctx_lists_mux);
diff --git a/fs/ecryptfs/miscdev.c b/fs/ecryptfs/miscdev.c
index b484792..047ac60 100644
--- a/fs/ecryptfs/miscdev.c
+++ b/fs/ecryptfs/miscdev.c
@@ -42,11 +42,12 @@ ecryptfs_miscdev_poll(struct file *file, poll_table *pt)
 {
 	struct ecryptfs_daemon *daemon;
 	unsigned int mask = 0;
+	uid_t euid = current_euid();
 	int rc;
 
 	mutex_lock(&ecryptfs_daemon_hash_mux);
 	/* TODO: Just use file->private_data? */
-	rc = ecryptfs_find_daemon_by_euid(&daemon, current->euid,
+	rc = ecryptfs_find_daemon_by_euid(&daemon, euid,
 					  current->nsproxy->user_ns);
 	BUG_ON(rc || !daemon);
 	mutex_lock(&daemon->mux);
@@ -83,6 +84,7 @@ static int
 ecryptfs_miscdev_open(struct inode *inode, struct file *file)
 {
 	struct ecryptfs_daemon *daemon = NULL;
+	uid_t euid = current_euid();
 	int rc;
 
 	mutex_lock(&ecryptfs_daemon_hash_mux);
@@ -93,10 +95,10 @@ ecryptfs_miscdev_open(struct inode *inode, struct file *file)
 		       "count; rc = [%d]\n", __func__, rc);
 		goto out_unlock_daemon_list;
 	}
-	rc = ecryptfs_find_daemon_by_euid(&daemon, current->euid,
+	rc = ecryptfs_find_daemon_by_euid(&daemon, euid,
 					  current->nsproxy->user_ns);
 	if (rc || !daemon) {
-		rc = ecryptfs_spawn_daemon(&daemon, current->euid,
+		rc = ecryptfs_spawn_daemon(&daemon, euid,
 					   current->nsproxy->user_ns,
 					   task_pid(current));
 		if (rc) {
@@ -147,10 +149,11 @@ static int
 ecryptfs_miscdev_release(struct inode *inode, struct file *file)
 {
 	struct ecryptfs_daemon *daemon = NULL;
+	uid_t euid = current_euid();
 	int rc;
 
 	mutex_lock(&ecryptfs_daemon_hash_mux);
-	rc = ecryptfs_find_daemon_by_euid(&daemon, current->euid,
+	rc = ecryptfs_find_daemon_by_euid(&daemon, euid,
 					  current->nsproxy->user_ns);
 	BUG_ON(rc || !daemon);
 	mutex_lock(&daemon->mux);
@@ -246,11 +249,12 @@ ecryptfs_miscdev_read(struct file *file, char __user *buf, size_t count,
 	char packet_length[3];
 	size_t i;
 	size_t total_length;
+	uid_t euid = current_euid();
 	int rc;
 
 	mutex_lock(&ecryptfs_daemon_hash_mux);
 	/* TODO: Just use file->private_data? */
-	rc = ecryptfs_find_daemon_by_euid(&daemon, current->euid,
+	rc = ecryptfs_find_daemon_by_euid(&daemon, euid,
 					  current->nsproxy->user_ns);
 	BUG_ON(rc || !daemon);
 	mutex_lock(&daemon->mux);
@@ -290,7 +294,7 @@ check_list:
 		 * message from the queue; try again */
 		goto check_list;
 	}
-	BUG_ON(current->euid != daemon->euid);
+	BUG_ON(euid != daemon->euid);
 	BUG_ON(current->nsproxy->user_ns != daemon->user_ns);
 	BUG_ON(task_pid(current) != daemon->pid);
 	msg_ctx = list_first_entry(&daemon->msg_ctx_out_queue,
@@ -414,6 +418,7 @@ ecryptfs_miscdev_write(struct file *file, const char __user *buf,
 	size_t packet_size, packet_size_length, i;
 	ssize_t sz = 0;
 	char *data;
+	uid_t euid = current_euid();
 	int rc;
 
 	if (count == 0)
@@ -463,8 +468,7 @@ ecryptfs_miscdev_write(struct file *file, const char __user *buf,
 			goto out_free;
 		}
 		rc = ecryptfs_miscdev_response(&data[i], packet_size,
-					       current->euid,
-					       current->nsproxy->user_ns,
+					       euid, current->nsproxy->user_ns,
 					       task_pid(current), seq);
 		if (rc)
 			printk(KERN_WARNING "%s: Failed to deliver miscdev "
diff --git a/fs/exec.c b/fs/exec.c
index 3b3231b..08c884c 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -985,7 +985,7 @@ int flush_old_exec(struct linux_binprm * bprm)
 	/* This is the point of no return */
 	current->sas_ss_sp = current->sas_ss_size = 0;
 
-	if (current->euid == current->uid && current->egid == current->gid)
+	if (current_euid() == current_uid() && current_egid() == current_gid())
 		set_dumpable(current->mm, 1);
 	else
 		set_dumpable(current->mm, suid_dumpable);
@@ -1012,7 +1012,7 @@ int flush_old_exec(struct linux_binprm * bprm)
 	 */
 	current->mm->task_size = TASK_SIZE;
 
-	if (bprm->e_uid != current->euid || bprm->e_gid != current->egid) {
+	if (bprm->e_uid != current_euid() || bprm->e_gid != current_egid()) {
 		suid_keys(current);
 		set_dumpable(current->mm, suid_dumpable);
 		current->pdeath_signal = 0;
@@ -1052,8 +1052,8 @@ int prepare_binprm(struct linux_binprm *bprm)
 	if (bprm->file->f_op == NULL)
 		return -EACCES;
 
-	bprm->e_uid = current->euid;
-	bprm->e_gid = current->egid;
+	bprm->e_uid = current_euid();
+	bprm->e_gid = current_egid();
 
 	if(!(bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)) {
 		/* Set-uid? */
@@ -1101,7 +1101,7 @@ void compute_creds(struct linux_binprm *bprm)
 {
 	int unsafe;
 
-	if (bprm->e_uid != current->uid) {
+	if (bprm->e_uid != current_uid()) {
 		suid_keys(current);
 		current->pdeath_signal = 0;
 	}
@@ -1429,7 +1429,7 @@ static int format_corename(char *corename, int nr_threads, long signr)
 			/* uid */
 			case 'u':
 				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%d", current->uid);
+					      "%d", current_uid());
 				if (rc > out_end - out_ptr)
 					goto out;
 				out_ptr += rc;
@@ -1437,7 +1437,7 @@ static int format_corename(char *corename, int nr_threads, long signr)
 			/* gid */
 			case 'g':
 				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%d", current->gid);
+					      "%d", current_gid());
 				if (rc > out_end - out_ptr)
 					goto out;
 				out_ptr += rc;
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 6d266d7..52925a8 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -941,8 +941,8 @@ static int parse_options(char *options, int is_vfat, int silent, int *debug,
 
 	opts->isvfat = is_vfat;
 
-	opts->fs_uid = current->uid;
-	opts->fs_gid = current->gid;
+	opts->fs_uid = current_uid();
+	opts->fs_gid = current_gid();
 	opts->fs_fmask = opts->fs_dmask = current->fs->umask;
 	opts->allow_utime = -1;
 	opts->codepage = fat_default_codepage;
diff --git a/fs/fcntl.c b/fs/fcntl.c
index ac4f7db..bf049a8 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -211,7 +211,7 @@ int __f_setown(struct file *filp, struct pid *pid, enum pid_type type,
 	if (err)
 		return err;
 
-	f_modown(filp, pid, type, current->uid, current->euid, force);
+	f_modown(filp, pid, type, current_uid(), current_euid(), force);
 	return 0;
 }
 EXPORT_SYMBOL(__f_setown);
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index 4abb104..2d5df7d 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -210,8 +210,8 @@ static int parse_options(char *options, struct hfs_sb_info *hsb)
 	int tmp, token;
 
 	/* initialize the sb with defaults */
-	hsb->s_uid = current->uid;
-	hsb->s_gid = current->gid;
+	hsb->s_uid = current_uid();
+	hsb->s_gid = current_gid();
 	hsb->s_file_umask = 0133;
 	hsb->s_dir_umask = 0022;
 	hsb->s_type = hsb->s_creator = cpu_to_be32(0x3f3f3f3f);	/* == '????' */
diff --git a/fs/hfsplus/options.c b/fs/hfsplus/options.c
index 9997cbf..4cfe720 100644
--- a/fs/hfsplus/options.c
+++ b/fs/hfsplus/options.c
@@ -49,8 +49,8 @@ void hfsplus_fill_defaults(struct hfsplus_sb_info *opts)
 	opts->creator = HFSPLUS_DEF_CR_TYPE;
 	opts->type = HFSPLUS_DEF_CR_TYPE;
 	opts->umask = current->fs->umask;
-	opts->uid = current->uid;
-	opts->gid = current->gid;
+	opts->uid = current_uid();
+	opts->gid = current_gid();
 	opts->part = -1;
 	opts->session = -1;
 }
diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index b8ae9c9..5e109f9 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -475,8 +475,8 @@ static int hpfs_fill_super(struct super_block *s, void *options, int silent)
 
 	init_MUTEX(&sbi->hpfs_creation_de);
 
-	uid = current->uid;
-	gid = current->gid;
+	uid = current_uid();
+	gid = current_gid();
 	umask = current->fs->umask;
 	lowercase = 0;
 	conv = CONV_BINARY;
diff --git a/fs/inotify_user.c b/fs/inotify_user.c
index 6024942..90eed91 100644
--- a/fs/inotify_user.c
+++ b/fs/inotify_user.c
@@ -591,7 +591,7 @@ asmlinkage long sys_inotify_init1(int flags)
 		goto out_put_fd;
 	}
 
-	user = get_uid(current->user);
+	user = get_current_user();
 	if (unlikely(atomic_read(&user->inotify_devs) >=
 			inotify_max_user_instances)) {
 		ret = -EMFILE;
diff --git a/fs/ioprio.c b/fs/ioprio.c
index c4a1c3c..b1214b9 100644
--- a/fs/ioprio.c
+++ b/fs/ioprio.c
@@ -32,8 +32,8 @@ static int set_task_ioprio(struct task_struct *task, int ioprio)
 	int err;
 	struct io_context *ioc;
 
-	if (task->uid != current->euid &&
-	    task->uid != current->uid && !capable(CAP_SYS_NICE))
+	if (task->uid != current_euid() &&
+	    task->uid != current_uid() && !capable(CAP_SYS_NICE))
 		return -EPERM;
 
 	err = security_task_setioprio(task, ioprio);
diff --git a/fs/namespace.c b/fs/namespace.c
index 6e283c9..2c11cf3 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1176,7 +1176,7 @@ static int mount_is_safe(struct nameidata *nd)
 	if (S_ISLNK(nd->path.dentry->d_inode->i_mode))
 		return -EPERM;
 	if (nd->path.dentry->d_inode->i_mode & S_ISVTX) {
-		if (current->uid != nd->path.dentry->d_inode->i_uid)
+		if (current_uid() != nd->path.dentry->d_inode->i_uid)
 			return -EPERM;
 	}
 	if (vfs_permission(nd, MAY_WRITE))
diff --git a/fs/ncpfs/ioctl.c b/fs/ncpfs/ioctl.c
index 3a97c95..6d04e05 100644
--- a/fs/ncpfs/ioctl.c
+++ b/fs/ncpfs/ioctl.c
@@ -40,10 +40,10 @@ ncp_get_fs_info(struct ncp_server * server, struct file *file,
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct ncp_fs_info info;
 
-	if ((file_permission(file, MAY_WRITE) != 0)
-	    && (current->uid != server->m.mounted_uid)) {
+	if (file_permission(file, MAY_WRITE) != 0
+	    && current_uid() != server->m.mounted_uid)
 		return -EACCES;
-	}
+
 	if (copy_from_user(&info, arg, sizeof(info)))
 		return -EFAULT;
 
@@ -70,10 +70,10 @@ ncp_get_fs_info_v2(struct ncp_server * server, struct file *file,
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct ncp_fs_info_v2 info2;
 
-	if ((file_permission(file, MAY_WRITE) != 0)
-	    && (current->uid != server->m.mounted_uid)) {
+	if (file_permission(file, MAY_WRITE) != 0
+	    && current_uid() != server->m.mounted_uid)
 		return -EACCES;
-	}
+
 	if (copy_from_user(&info2, arg, sizeof(info2)))
 		return -EFAULT;
 
@@ -141,10 +141,10 @@ ncp_get_compat_fs_info_v2(struct ncp_server * server, struct file *file,
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct compat_ncp_fs_info_v2 info2;
 
-	if ((file_permission(file, MAY_WRITE) != 0)
-	    && (current->uid != server->m.mounted_uid)) {
+	if (file_permission(file, MAY_WRITE) != 0
+	    && current_uid() != server->m.mounted_uid)
 		return -EACCES;
-	}
+
 	if (copy_from_user(&info2, arg, sizeof(info2)))
 		return -EFAULT;
 
@@ -270,16 +270,17 @@ static int __ncp_ioctl(struct inode *inode, struct file *filp,
 	struct ncp_ioctl_request request;
 	char* bouncebuffer;
 	void __user *argp = (void __user *)arg;
+	uid_t uid = current_uid();
 
 	switch (cmd) {
 #ifdef CONFIG_COMPAT
 	case NCP_IOC_NCPREQUEST_32:
 #endif
 	case NCP_IOC_NCPREQUEST:
-		if ((file_permission(filp, MAY_WRITE) != 0)
-		    && (current->uid != server->m.mounted_uid)) {
+		if (file_permission(filp, MAY_WRITE) != 0
+		    && uid != server->m.mounted_uid)
 			return -EACCES;
-		}
+
 #ifdef CONFIG_COMPAT
 		if (cmd == NCP_IOC_NCPREQUEST_32) {
 			struct compat_ncp_ioctl_request request32;
@@ -356,10 +357,10 @@ static int __ncp_ioctl(struct inode *inode, struct file *filp,
 	case NCP_IOC_GETMOUNTUID16:
 	case NCP_IOC_GETMOUNTUID32:
 	case NCP_IOC_GETMOUNTUID64:
-		if ((file_permission(filp, MAY_READ) != 0)
-			&& (current->uid != server->m.mounted_uid)) {
+		if (file_permission(filp, MAY_READ) != 0
+			&& uid != server->m.mounted_uid)
 			return -EACCES;
-		}
+
 		if (cmd == NCP_IOC_GETMOUNTUID16) {
 			u16 uid;
 			SET_UID(uid, server->m.mounted_uid);
@@ -380,11 +381,10 @@ static int __ncp_ioctl(struct inode *inode, struct file *filp,
 		{
 			struct ncp_setroot_ioctl sr;
 
-			if ((file_permission(filp, MAY_READ) != 0)
-			    && (current->uid != server->m.mounted_uid))
-			{
+			if (file_permission(filp, MAY_READ) != 0
+			    && uid != server->m.mounted_uid)
 				return -EACCES;
-			}
+
 			if (server->m.mounted_vol[0]) {
 				struct dentry* dentry = inode->i_sb->s_root;
 
@@ -408,6 +408,7 @@ static int __ncp_ioctl(struct inode *inode, struct file *filp,
 				return -EFAULT;
 			return 0;
 		}
+
 	case NCP_IOC_SETROOT:
 		{
 			struct ncp_setroot_ioctl sr;
@@ -455,11 +456,10 @@ static int __ncp_ioctl(struct inode *inode, struct file *filp,
 
 #ifdef CONFIG_NCPFS_PACKET_SIGNING	
 	case NCP_IOC_SIGN_INIT:
-		if ((file_permission(filp, MAY_WRITE) != 0)
-		    && (current->uid != server->m.mounted_uid))
-		{
+		if (file_permission(filp, MAY_WRITE) != 0
+		    && uid != server->m.mounted_uid)
 			return -EACCES;
-		}
+
 		if (argp) {
 			if (server->sign_wanted)
 			{
@@ -478,24 +478,22 @@ static int __ncp_ioctl(struct inode *inode, struct file *filp,
 		return 0;		
 		
         case NCP_IOC_SIGN_WANTED:
-		if ((file_permission(filp, MAY_READ) != 0)
-		    && (current->uid != server->m.mounted_uid))
-		{
+		if (file_permission(filp, MAY_READ) != 0
+		    && uid != server->m.mounted_uid)
 			return -EACCES;
-		}
 		
                 if (put_user(server->sign_wanted, (int __user *)argp))
 			return -EFAULT;
                 return 0;
+
 	case NCP_IOC_SET_SIGN_WANTED:
 		{
 			int newstate;
 
-			if ((file_permission(filp, MAY_WRITE) != 0)
-			    && (current->uid != server->m.mounted_uid))
-			{
+			if (file_permission(filp, MAY_WRITE) != 0
+			    && uid != server->m.mounted_uid)
 				return -EACCES;
-			}
+
 			/* get only low 8 bits... */
 			if (get_user(newstate, (unsigned char __user *)argp))
 				return -EFAULT;
@@ -512,11 +510,10 @@ static int __ncp_ioctl(struct inode *inode, struct file *filp,
 
 #ifdef CONFIG_NCPFS_IOCTL_LOCKING
 	case NCP_IOC_LOCKUNLOCK:
-		if ((file_permission(filp, MAY_WRITE) != 0)
-		    && (current->uid != server->m.mounted_uid))
-		{
+		if (file_permission(filp, MAY_WRITE) != 0
+		    && uid != server->m.mounted_uid)
 			return -EACCES;
-		}
+
 		{
 			struct ncp_lock_ioctl	 rqdata;
 
@@ -585,9 +582,8 @@ outrel:
 
 #ifdef CONFIG_COMPAT
 	case NCP_IOC_GETOBJECTNAME_32:
-		if (current->uid != server->m.mounted_uid) {
+		if (uid != server->m.mounted_uid)
 			return -EACCES;
-		}
 		{
 			struct compat_ncp_objectname_ioctl user;
 			size_t outl;
@@ -609,10 +605,10 @@ outrel:
 			return 0;
 		}
 #endif
+
 	case NCP_IOC_GETOBJECTNAME:
-		if (current->uid != server->m.mounted_uid) {
+		if (uid != server->m.mounted_uid)
 			return -EACCES;
-		}
 		{
 			struct ncp_objectname_ioctl user;
 			size_t outl;
@@ -633,13 +629,13 @@ outrel:
 				return -EFAULT;
 			return 0;
 		}
+
 #ifdef CONFIG_COMPAT
 	case NCP_IOC_SETOBJECTNAME_32:
 #endif
 	case NCP_IOC_SETOBJECTNAME:
-		if (current->uid != server->m.mounted_uid) {
+		if (uid != server->m.mounted_uid)
 			return -EACCES;
-		}
 		{
 			struct ncp_objectname_ioctl user;
 			void* newname;
@@ -691,13 +687,13 @@ outrel:
 			kfree(oldname);
 			return 0;
 		}
+
 #ifdef CONFIG_COMPAT
 	case NCP_IOC_GETPRIVATEDATA_32:
 #endif
 	case NCP_IOC_GETPRIVATEDATA:
-		if (current->uid != server->m.mounted_uid) {
+		if (uid != server->m.mounted_uid)
 			return -EACCES;
-		}
 		{
 			struct ncp_privatedata_ioctl user;
 			size_t outl;
@@ -736,13 +732,13 @@ outrel:
 
 			return 0;
 		}
+
 #ifdef CONFIG_COMPAT
 	case NCP_IOC_SETPRIVATEDATA_32:
 #endif
 	case NCP_IOC_SETPRIVATEDATA:
-		if (current->uid != server->m.mounted_uid) {
+		if (uid != server->m.mounted_uid)
 			return -EACCES;
-		}
 		{
 			struct ncp_privatedata_ioctl user;
 			void* new;
@@ -794,9 +790,10 @@ outrel:
 #endif /* CONFIG_NCPFS_NLS */
 
 	case NCP_IOC_SETDENTRYTTL:
-		if ((file_permission(filp, MAY_WRITE) != 0) &&
-				 (current->uid != server->m.mounted_uid))
+		if (file_permission(filp, MAY_WRITE) != 0 &&
+		    uid != server->m.mounted_uid)
 			return -EACCES;
+
 		{
 			u_int32_t user;
 
diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index 903f70f..9fc94de 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -421,8 +421,8 @@ static int omfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	sb->s_fs_info = sbi;
 
-	sbi->s_uid = current->uid;
-	sbi->s_gid = current->gid;
+	sbi->s_uid = current_uid();
+	sbi->s_gid = current_gid();
 	sbi->s_dmask = sbi->s_fmask = current->fs->umask;
 
 	if (!parse_options((char *) data, sbi))
diff --git a/fs/quota.c b/fs/quota.c
index 7f4386e..b7fe44e 100644
--- a/fs/quota.c
+++ b/fs/quota.c
@@ -79,7 +79,7 @@ static int generic_quotactl_valid(struct super_block *sb, int type, int cmd, qid
 
 	/* Check privileges */
 	if (cmd == Q_GETQUOTA) {
-		if (((type == USRQUOTA && current->euid != id) ||
+		if (((type == USRQUOTA && current_euid() != id) ||
 		     (type == GRPQUOTA && !in_egroup_p(id))) &&
 		    !capable(CAP_SYS_ADMIN))
 			return -EPERM;
@@ -130,7 +130,7 @@ static int xqm_quotactl_valid(struct super_block *sb, int type, int cmd, qid_t i
 
 	/* Check privileges */
 	if (cmd == Q_XGETQUOTA) {
-		if (((type == XQM_USRQUOTA && current->euid != id) ||
+		if (((type == XQM_USRQUOTA && current_euid() != id) ||
 		     (type == XQM_GRPQUOTA && !in_egroup_p(id))) &&
 		     !capable(CAP_SYS_ADMIN))
 			return -EPERM;
diff --git a/fs/smbfs/dir.c b/fs/smbfs/dir.c
index 48da4fa..9e9bb0d 100644
--- a/fs/smbfs/dir.c
+++ b/fs/smbfs/dir.c
@@ -667,8 +667,8 @@ smb_make_node(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
 
 	attr.ia_valid = ATTR_MODE | ATTR_UID | ATTR_GID;
 	attr.ia_mode = mode;
-	attr.ia_uid = current->euid;
-	attr.ia_gid = current->egid;
+	attr.ia_uid = current_euid();
+	attr.ia_gid = current_egid();
 
 	if (!new_valid_dev(dev))
 		return -EINVAL;
diff --git a/fs/smbfs/inode.c b/fs/smbfs/inode.c
index 3528f40..fc27fbf 100644
--- a/fs/smbfs/inode.c
+++ b/fs/smbfs/inode.c
@@ -586,7 +586,7 @@ static int smb_fill_super(struct super_block *sb, void *raw_data, int silent)
 		if (parse_options(mnt, raw_data))
 			goto out_bad_option;
 	}
-	mnt->mounted_uid = current->uid;
+	mnt->mounted_uid = current_uid();
 	smb_setcodepage(server, &mnt->codepage);
 
 	/*
diff --git a/fs/smbfs/proc.c b/fs/smbfs/proc.c
index ee536e8..9468168 100644
--- a/fs/smbfs/proc.c
+++ b/fs/smbfs/proc.c
@@ -864,7 +864,7 @@ smb_newconn(struct smb_sb_info *server, struct smb_conn_opt *opt)
 		goto out;
 
 	error = -EACCES;
-	if (current->uid != server->mnt->mounted_uid && 
+	if (current_uid() != server->mnt->mounted_uid &&
 	    !capable(CAP_SYS_ADMIN))
 		goto out;
 
diff --git a/fs/xfs/linux-2.6/xfs_cred.h b/fs/xfs/linux-2.6/xfs_cred.h
index 652721c..293043a 100644
--- a/fs/xfs/linux-2.6/xfs_cred.h
+++ b/fs/xfs/linux-2.6/xfs_cred.h
@@ -24,7 +24,7 @@
  * Credentials
  */
 typedef struct cred {
-	/* EMPTY */
+       /* EMPTY */
 } cred_t;
 
 extern struct cred *sys_cred;
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 9d56fbd..b69222c 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -12,10 +12,35 @@
 #ifndef _LINUX_CRED_H
 #define _LINUX_CRED_H
 
+#define get_current_user()	(get_uid(current->user))
+
+#define task_uid(task)		((task)->uid)
+#define task_gid(task)		((task)->gid)
+#define task_euid(task)		((task)->euid)
+#define task_egid(task)		((task)->egid)
+
+#define current_uid()		(current->uid)
+#define current_gid()		(current->gid)
+#define current_euid()		(current->euid)
+#define current_egid()		(current->egid)
+#define current_suid()		(current->suid)
+#define current_sgid()		(current->sgid)
 #define current_fsuid()		(current->fsuid)
 #define current_fsgid()		(current->fsgid)
 #define current_cap()		(current->cap_effective)
 
+#define current_uid_gid(_uid, _gid)		\
+do {						\
+	*(_uid) = current->uid;			\
+	*(_gid) = current->gid;			\
+} while(0)
+
+#define current_euid_egid(_uid, _gid)		\
+do {						\
+	*(_uid) = current->euid;		\
+	*(_gid) = current->egid;		\
+} while(0)
+
 #define current_fsuid_fsgid(_uid, _gid)		\
 do {						\
 	*(_uid) = current->fsuid;		\
diff --git a/include/net/scm.h b/include/net/scm.h
index 06df126..f160116 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -54,8 +54,8 @@ static __inline__ int scm_send(struct socket *sock, struct msghdr *msg,
 			       struct scm_cookie *scm)
 {
 	struct task_struct *p = current;
-	scm->creds.uid = p->uid;
-	scm->creds.gid = p->gid;
+	scm->creds.uid = current_uid();
+	scm->creds.gid = current_gid();
 	scm->creds.pid = task_tgid_vnr(p);
 	scm->fp = NULL;
 	scm->seq = 0;
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index c652c21..51d9588 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -499,7 +499,7 @@ static void __do_notify(struct mqueue_inode_info *info)
 			sig_i.si_code = SI_MESGQ;
 			sig_i.si_value = info->notify.sigev_value;
 			sig_i.si_pid = task_tgid_vnr(current);
-			sig_i.si_uid = current->uid;
+			sig_i.si_uid = current_uid();
 
 			kill_pid_info(info->notify.sigev_signo,
 				      &sig_i, info->notify_owner);
diff --git a/ipc/shm.c b/ipc/shm.c
index e77ec69..c46a7e6 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -748,9 +748,10 @@ asmlinkage long sys_shmctl(int shmid, int cmd, struct shmid_ds __user *buf)
 			goto out_unlock;
 
 		if (!capable(CAP_IPC_LOCK)) {
+			uid_t euid = current_euid();
 			err = -EPERM;
-			if (current->euid != shp->shm_perm.uid &&
-			    current->euid != shp->shm_perm.cuid)
+			if (euid != shp->shm_perm.uid &&
+			    euid != shp->shm_perm.cuid)
 				goto out_unlock;
 			if (cmd == SHM_LOCK &&
 			    !current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur)
diff --git a/ipc/util.c b/ipc/util.c
index 49b3ea6..c8a7670 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -258,6 +258,8 @@ int ipc_get_maxid(struct ipc_ids *ids)
  
 int ipc_addid(struct ipc_ids* ids, struct kern_ipc_perm* new, int size)
 {
+	uid_t euid;
+	gid_t egid;
 	int id, err;
 
 	if (size > IPCMNI)
@@ -272,8 +274,9 @@ int ipc_addid(struct ipc_ids* ids, struct kern_ipc_perm* new, int size)
 
 	ids->in_use++;
 
-	new->cuid = new->uid = current->euid;
-	new->gid = new->cgid = current->egid;
+	current_euid_egid(&euid, &egid);
+	new->cuid = new->uid = euid;
+	new->gid = new->cgid = egid;
 
 	new->seq = ids->seq++;
 	if(ids->seq > ids->seq_max)
@@ -616,13 +619,15 @@ void ipc_rcu_putref(void *ptr)
  
 int ipcperms (struct kern_ipc_perm *ipcp, short flag)
 {	/* flag will most probably be 0 or S_...UGO from <linux/stat.h> */
+	uid_t euid = current_euid();
 	int requested_mode, granted_mode, err;
 
 	if (unlikely((err = audit_ipc_obj(ipcp))))
 		return err;
 	requested_mode = (flag >> 6) | (flag >> 3) | flag;
 	granted_mode = ipcp->mode;
-	if (current->euid == ipcp->cuid || current->euid == ipcp->uid)
+	if (euid == ipcp->cuid ||
+	    euid == ipcp->uid)
 		granted_mode >>= 6;
 	else if (in_group_p(ipcp->cgid) || in_group_p(ipcp->gid))
 		granted_mode >>= 3;
@@ -784,6 +789,7 @@ struct kern_ipc_perm *ipcctl_pre_down(struct ipc_ids *ids, int id, int cmd,
 				      struct ipc64_perm *perm, int extra_perm)
 {
 	struct kern_ipc_perm *ipcp;
+	uid_t euid;
 	int err;
 
 	down_write(&ids->rw_mutex);
@@ -803,8 +809,10 @@ struct kern_ipc_perm *ipcctl_pre_down(struct ipc_ids *ids, int id, int cmd,
 		if (err)
 			goto out_unlock;
 	}
-	if (current->euid == ipcp->cuid ||
-	    current->euid == ipcp->uid || capable(CAP_SYS_ADMIN))
+
+	euid = current_euid();
+	if (euid == ipcp->cuid ||
+	    euid == ipcp->uid  || capable(CAP_SYS_ADMIN))
 		return ipcp;
 
 	err = -EPERM;
diff --git a/kernel/acct.c b/kernel/acct.c
index dd68b90..f7f06ce 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -530,15 +530,14 @@ static void do_acct_process(struct bsd_acct_struct *acct,
 	do_div(elapsed, AHZ);
 	ac.ac_btime = get_seconds() - elapsed;
 	/* we really need to bite the bullet and change layout */
-	ac.ac_uid = current->uid;
-	ac.ac_gid = current->gid;
+	current_uid_gid(&ac.ac_uid, &ac.ac_gid);
 #if ACCT_VERSION==2
 	ac.ac_ahz = AHZ;
 #endif
 #if ACCT_VERSION==1 || ACCT_VERSION==2
 	/* backward-compatible 16 bit fields */
-	ac.ac_uid16 = current->uid;
-	ac.ac_gid16 = current->gid;
+	ac.ac_uid16 = ac.ac_uid;
+	ac.ac_gid16 = ac.ac_gid;
 #endif
 #if ACCT_VERSION==3
 	ac.ac_pid = task_tgid_nr_ns(current, ns);
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 496c3dd..af446be 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2433,7 +2433,8 @@ void audit_core_dumps(long signr)
 {
 	struct audit_buffer *ab;
 	u32 sid;
-	uid_t auid = audit_get_loginuid(current);
+	uid_t auid = audit_get_loginuid(current), uid;
+	gid_t gid;
 	unsigned int sessionid = audit_get_sessionid(current);
 
 	if (!audit_enabled)
@@ -2443,8 +2444,9 @@ void audit_core_dumps(long signr)
 		return;
 
 	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_ANOM_ABEND);
+	current_uid_gid(&uid, &gid);
 	audit_log_format(ab, "auid=%u uid=%u gid=%u ses=%u",
-			auid, current->uid, current->gid, sessionid);
+			 auid, uid, gid, sessionid);
 	security_task_getsecid(current, &sid);
 	if (sid) {
 		char *ctx = NULL;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f483904..9f5a62a 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1276,6 +1276,7 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 static int attach_task_by_pid(struct cgroup *cgrp, u64 pid)
 {
 	struct task_struct *tsk;
+	uid_t euid;
 	int ret;
 
 	if (pid) {
@@ -1288,8 +1289,8 @@ static int attach_task_by_pid(struct cgroup *cgrp, u64 pid)
 		get_task_struct(tsk);
 		rcu_read_unlock();
 
-		if ((current->euid) && (current->euid != tsk->uid)
-		    && (current->euid != tsk->suid)) {
+		euid = current_euid();
+		if (euid && euid != tsk->uid && euid != tsk->suid) {
 			put_task_struct(tsk);
 			return -EACCES;
 		}
diff --git a/kernel/futex.c b/kernel/futex.c
index 7d1136e..a28b82b 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -439,10 +439,11 @@ static void free_pi_state(struct futex_pi_state *pi_state)
 static struct task_struct * futex_find_get_task(pid_t pid)
 {
 	struct task_struct *p;
+	uid_t euid = current_euid();
 
 	rcu_read_lock();
 	p = find_task_by_vpid(pid);
-	if (!p || ((current->euid != p->euid) && (current->euid != p->uid)))
+	if (!p || (euid != p->euid && euid != p->uid))
 		p = ERR_PTR(-ESRCH);
 	else
 		get_task_struct(p);
@@ -1826,6 +1827,7 @@ sys_get_robust_list(int pid, struct robust_list_head __user * __user *head_ptr,
 {
 	struct robust_list_head __user *head;
 	unsigned long ret;
+	uid_t euid = current_euid();
 
 	if (!futex_cmpxchg_enabled)
 		return -ENOSYS;
@@ -1841,8 +1843,8 @@ sys_get_robust_list(int pid, struct robust_list_head __user * __user *head_ptr,
 		if (!p)
 			goto err_unlock;
 		ret = -EPERM;
-		if ((current->euid != p->euid) && (current->euid != p->uid) &&
-				!capable(CAP_SYS_PTRACE))
+		if (euid != p->euid && euid != p->uid &&
+		    !capable(CAP_SYS_PTRACE))
 			goto err_unlock;
 		head = p->robust_list;
 		rcu_read_unlock();
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index 04ac3a9..3254d4e 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -135,6 +135,7 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 {
 	struct compat_robust_list_head __user *head;
 	unsigned long ret;
+	uid_t euid = current_euid();
 
 	if (!futex_cmpxchg_enabled)
 		return -ENOSYS;
@@ -150,7 +151,7 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 		if (!p)
 			goto err_unlock;
 		ret = -EPERM;
-		if ((current->euid != p->euid) && (current->euid != p->uid) &&
+		if (euid != p->euid && euid != p->uid &&
 				!capable(CAP_SYS_PTRACE))
 			goto err_unlock;
 		head = p->compat_robust_list;
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 356699a..0dafab1 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -123,16 +123,19 @@ int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 	 * because setting up the necessary parent/child relationship
 	 * or halting the specified task is impossible.
 	 */
+	uid_t uid;
+	gid_t gid;
 	int dumpable = 0;
 	/* Don't let security modules deny introspection */
 	if (task == current)
 		return 0;
-	if (((current->uid != task->euid) ||
-	     (current->uid != task->suid) ||
-	     (current->uid != task->uid) ||
-	     (current->gid != task->egid) ||
-	     (current->gid != task->sgid) ||
-	     (current->gid != task->gid)) && !capable(CAP_SYS_PTRACE))
+	current_uid_gid(&uid, &gid);
+	if ((uid != task->euid ||
+	     uid != task->suid ||
+	     uid != task->uid  ||
+	     gid != task->egid ||
+	     gid != task->sgid ||
+	     gid != task->gid) && !capable(CAP_SYS_PTRACE))
 		return -EPERM;
 	smp_rmb();
 	if (task->mm)
diff --git a/kernel/sched.c b/kernel/sched.c
index 21f7da9..4a97b29 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4947,6 +4947,7 @@ static int __sched_setscheduler(struct task_struct *p, int policy,
 	unsigned long flags;
 	const struct sched_class *prev_class = p->sched_class;
 	struct rq *rq;
+	uid_t euid;
 
 	/* may grab non-irq protected spin_locks */
 	BUG_ON(in_interrupt());
@@ -4999,8 +5000,9 @@ recheck:
 			return -EPERM;
 
 		/* can't change other user's priorities */
-		if ((current->euid != p->euid) &&
-		    (current->euid != p->uid))
+		euid = current_euid();
+		if (euid != p->euid &&
+		    euid != p->uid)
 			return -EPERM;
 	}
 
@@ -5208,6 +5210,7 @@ long sched_setaffinity(pid_t pid, const cpumask_t *in_mask)
 	cpumask_t cpus_allowed;
 	cpumask_t new_mask = *in_mask;
 	struct task_struct *p;
+	uid_t euid;
 	int retval;
 
 	get_online_cpus();
@@ -5228,9 +5231,9 @@ long sched_setaffinity(pid_t pid, const cpumask_t *in_mask)
 	get_task_struct(p);
 	read_unlock(&tasklist_lock);
 
+	euid = current_euid();
 	retval = -EPERM;
-	if ((current->euid != p->euid) && (current->euid != p->uid) &&
-			!capable(CAP_SYS_NICE))
+	if (euid != p->euid && euid != p->uid && !capable(CAP_SYS_NICE))
 		goto out_unlock;
 
 	retval = security_task_setscheduler(p, 0, NULL);
diff --git a/kernel/signal.c b/kernel/signal.c
index 954f77d..9ad5b74 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -566,6 +566,7 @@ static int check_kill_permission(int sig, struct siginfo *info,
 				 struct task_struct *t)
 {
 	struct pid *sid;
+	uid_t uid, euid;
 	int error;
 
 	if (!valid_signal(sig))
@@ -578,8 +579,10 @@ static int check_kill_permission(int sig, struct siginfo *info,
 	if (error)
 		return error;
 
-	if ((current->euid ^ t->suid) && (current->euid ^ t->uid) &&
-	    (current->uid  ^ t->suid) && (current->uid  ^ t->uid) &&
+	uid = current_uid();
+	euid = current_euid();
+	if ((euid ^ t->suid) && (euid ^ t->uid) &&
+	    (uid  ^ t->suid) && (uid  ^ t->uid) &&
 	    !capable(CAP_KILL)) {
 		switch (sig) {
 		case SIGCONT:
@@ -841,7 +844,7 @@ static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			q->info.si_errno = 0;
 			q->info.si_code = SI_USER;
 			q->info.si_pid = task_pid_vnr(current);
-			q->info.si_uid = current->uid;
+			q->info.si_uid = current_uid();
 			break;
 		case (unsigned long) SEND_SIG_PRIV:
 			q->info.si_signo = sig;
@@ -1592,7 +1595,7 @@ void ptrace_notify(int exit_code)
 	info.si_signo = SIGTRAP;
 	info.si_code = exit_code;
 	info.si_pid = task_pid_vnr(current);
-	info.si_uid = current->uid;
+	info.si_uid = current_uid();
 
 	/* Let the debugger run.  */
 	spin_lock_irq(&current->sighand->siglock);
@@ -2205,7 +2208,7 @@ sys_kill(pid_t pid, int sig)
 	info.si_errno = 0;
 	info.si_code = SI_USER;
 	info.si_pid = task_tgid_vnr(current);
-	info.si_uid = current->uid;
+	info.si_uid = current_uid();
 
 	return kill_something_info(sig, &info, pid);
 }
@@ -2222,7 +2225,7 @@ static int do_tkill(pid_t tgid, pid_t pid, int sig)
 	info.si_errno = 0;
 	info.si_code = SI_TKILL;
 	info.si_pid = task_tgid_vnr(current);
-	info.si_uid = current->uid;
+	info.si_uid = current_uid();
 
 	rcu_read_lock();
 	p = find_task_by_vpid(pid);
diff --git a/kernel/sys.c b/kernel/sys.c
index c018580..f498f30 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -114,10 +114,10 @@ void (*pm_power_off_prepare)(void);
 
 static int set_one_prio(struct task_struct *p, int niceval, int error)
 {
+	uid_t euid = current_euid();
 	int no_nice;
 
-	if (p->uid != current->euid &&
-		p->euid != current->euid && !capable(CAP_SYS_NICE)) {
+	if (p->uid != euid && p->euid != euid && !capable(CAP_SYS_NICE)) {
 		error = -EPERM;
 		goto out;
 	}
@@ -176,16 +176,16 @@ asmlinkage long sys_setpriority(int which, int who, int niceval)
 		case PRIO_USER:
 			user = current->user;
 			if (!who)
-				who = current->uid;
+				who = current_uid();
 			else
-				if ((who != current->uid) && !(user = find_user(who)))
+				if (who != current_uid() && !(user = find_user(who)))
 					goto out_unlock;	/* No processes for this user */
 
 			do_each_thread(g, p)
 				if (p->uid == who)
 					error = set_one_prio(p, niceval, error);
 			while_each_thread(g, p);
-			if (who != current->uid)
+			if (who != current_uid())
 				free_uid(user);		/* For find_user() */
 			break;
 	}
@@ -238,9 +238,9 @@ asmlinkage long sys_getpriority(int which, int who)
 		case PRIO_USER:
 			user = current->user;
 			if (!who)
-				who = current->uid;
+				who = current_uid();
 			else
-				if ((who != current->uid) && !(user = find_user(who)))
+				if (who != current_uid() && !(user = find_user(who)))
 					goto out_unlock;	/* No processes for this user */
 
 			do_each_thread(g, p)
@@ -250,7 +250,7 @@ asmlinkage long sys_getpriority(int which, int who)
 						retval = niceval;
 				}
 			while_each_thread(g, p);
-			if (who != current->uid)
+			if (who != current_uid())
 				free_uid(user);		/* for find_user() */
 			break;
 	}
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index fe47133..df3bea1 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1631,7 +1631,7 @@ out:
 
 static int test_perm(int mode, int op)
 {
-	if (!current->euid)
+	if (!current_euid())
 		mode >>= 6;
 	else if (in_egroup_p(0))
 		mode >>= 3;
diff --git a/kernel/timer.c b/kernel/timer.c
index 03bc7f1..c6119bd 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1122,25 +1122,25 @@ asmlinkage long sys_getppid(void)
 asmlinkage long sys_getuid(void)
 {
 	/* Only we change this so SMP safe */
-	return current->uid;
+	return current_uid();
 }
 
 asmlinkage long sys_geteuid(void)
 {
 	/* Only we change this so SMP safe */
-	return current->euid;
+	return current_euid();
 }
 
 asmlinkage long sys_getgid(void)
 {
 	/* Only we change this so SMP safe */
-	return current->gid;
+	return current_gid();
 }
 
 asmlinkage long sys_getegid(void)
 {
 	/* Only we change this so SMP safe */
-	return  current->egid;
+	return  current_egid();
 }
 
 #endif
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index a9ab059..edbe9f1 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -39,7 +39,7 @@ static struct user_namespace *clone_user_ns(struct user_namespace *old_ns)
 	}
 
 	/* Reset current->user with a new one */
-	new_user = alloc_uid(ns, current->uid);
+	new_user = alloc_uid(ns, current_uid());
 	if (!new_user) {
 		free_uid(ns->root_user);
 		kfree(ns);
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index e550bec..6419497 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1111,6 +1111,7 @@ asmlinkage long sys_migrate_pages(pid_t pid, unsigned long maxnode,
 	nodemask_t old;
 	nodemask_t new;
 	nodemask_t task_nodes;
+	uid_t uid, euid;
 	int err;
 
 	err = get_nodes(&old, old_nodes, maxnode);
@@ -1140,8 +1141,10 @@ asmlinkage long sys_migrate_pages(pid_t pid, unsigned long maxnode,
 	 * capabilities, superuser privileges or the same
 	 * userid as the target process.
 	 */
-	if ((current->euid != task->suid) && (current->euid != task->uid) &&
-	    (current->uid != task->suid) && (current->uid != task->uid) &&
+	uid = current_uid();
+	euid = current_euid();
+	if (euid != task->suid && euid != task->uid &&
+	    uid  != task->suid && uid  != task->uid &&
 	    !capable(CAP_SYS_NICE)) {
 		err = -EPERM;
 		goto out;
diff --git a/mm/migrate.c b/mm/migrate.c
index 153572f..efc200b 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -990,6 +990,7 @@ asmlinkage long sys_move_pages(pid_t pid, unsigned long nr_pages,
 	nodemask_t task_nodes;
 	struct mm_struct *mm;
 	struct page_to_node *pm = NULL;
+	uid_t uid, euid;
 
 	/* Check flags */
 	if (flags & ~(MPOL_MF_MOVE|MPOL_MF_MOVE_ALL))
@@ -1017,8 +1018,10 @@ asmlinkage long sys_move_pages(pid_t pid, unsigned long nr_pages,
 	 * capabilities, superuser privileges or the same
 	 * userid as the target process.
 	 */
-	if ((current->euid != task->suid) && (current->euid != task->uid) &&
-	    (current->uid != task->suid) && (current->uid != task->uid) &&
+	uid = current_uid();
+	euid = current_euid();
+	if (euid != task->suid && euid != task->uid &&
+	    uid  != task->suid && uid  != task->uid &&
 	    !capable(CAP_SYS_NICE)) {
 		err = -EPERM;
 		goto out2;
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 01c83e2..f3e5217 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1042,7 +1042,7 @@ static int ax25_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	if (addr->fsa_ax25.sax25_family != AF_AX25)
 		return -EINVAL;
 
-	user = ax25_findbyuid(current->euid);
+	user = ax25_findbyuid(current_euid());
 	if (user) {
 		call = user->call;
 		ax25_uid_put(user);
diff --git a/net/ax25/ax25_route.c b/net/ax25/ax25_route.c
index 8672cd8..c833ba4 100644
--- a/net/ax25/ax25_route.c
+++ b/net/ax25/ax25_route.c
@@ -421,7 +421,7 @@ int ax25_rt_autobind(ax25_cb *ax25, ax25_address *addr)
 		goto put;
 	}
 
-	user = ax25_findbyuid(current->euid);
+	user = ax25_findbyuid(current_euid());
 	if (user) {
 		ax25->source_addr = user->call;
 		ax25_uid_put(user);
diff --git a/net/core/dev.c b/net/core/dev.c
index 69320a5..5a32f11 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2906,6 +2906,8 @@ int netdev_set_master(struct net_device *slave, struct net_device *master)
 static int __dev_set_promiscuity(struct net_device *dev, int inc)
 {
 	unsigned short old_flags = dev->flags;
+	uid_t uid;
+	gid_t gid;
 
 	ASSERT_RTNL();
 
@@ -2930,15 +2932,17 @@ static int __dev_set_promiscuity(struct net_device *dev, int inc)
 		printk(KERN_INFO "device %s %s promiscuous mode\n",
 		       dev->name, (dev->flags & IFF_PROMISC) ? "entered" :
 							       "left");
-		if (audit_enabled)
+		if (audit_enabled) {
+			current_uid_gid(&uid, &gid);
 			audit_log(current->audit_context, GFP_ATOMIC,
 				AUDIT_ANOM_PROMISCUOUS,
 				"dev=%s prom=%d old_prom=%d auid=%u uid=%u gid=%u ses=%u",
 				dev->name, (dev->flags & IFF_PROMISC),
 				(old_flags & IFF_PROMISC),
 				audit_get_loginuid(current),
-				current->uid, current->gid,
+				uid, gid,
 				audit_get_sessionid(current));
+		}
 
 		if (dev->change_rx_flags)
 			dev->change_rx_flags(dev, IFF_PROMISC);
diff --git a/net/core/scm.c b/net/core/scm.c
index 10f5c65..4681d8f 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -45,10 +45,10 @@
 static __inline__ int scm_check_creds(struct ucred *creds)
 {
 	if ((creds->pid == task_tgid_vnr(current) || capable(CAP_SYS_ADMIN)) &&
-	    ((creds->uid == current->uid || creds->uid == current->euid ||
-	      creds->uid == current->suid) || capable(CAP_SETUID)) &&
-	    ((creds->gid == current->gid || creds->gid == current->egid ||
-	      creds->gid == current->sgid) || capable(CAP_SETGID))) {
+	    ((creds->uid == current_uid()   || creds->uid == current_euid() ||
+	      creds->uid == current_suid()) || capable(CAP_SETUID)) &&
+	    ((creds->gid == current_gid()   || creds->gid == current_egid() ||
+	      creds->gid == current_sgid()) || capable(CAP_SETGID))) {
 	       return 0;
 	}
 	return -EPERM;
diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
index 37a4e77..bd3c7b9 100644
--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -388,7 +388,7 @@ fl_create(struct net *net, struct in6_flowlabel_req *freq, char __user *optval,
 		fl->owner = current->pid;
 		break;
 	case IPV6_FL_S_USER:
-		fl->owner = current->euid;
+		fl->owner = current_euid();
 		break;
 	default:
 		err = -EINVAL;
diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 532e4fa..a75e072 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -609,7 +609,7 @@ static int nr_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	} else {
 		source = &addr->fsa_ax25.sax25_call;
 
-		user = ax25_findbyuid(current->euid);
+		user = ax25_findbyuid(current_euid());
 		if (user) {
 			nr->user_addr   = user->call;
 			ax25_uid_put(user);
@@ -683,7 +683,7 @@ static int nr_connect(struct socket *sock, struct sockaddr *uaddr,
 		}
 		source = (ax25_address *)dev->dev_addr;
 
-		user = ax25_findbyuid(current->euid);
+		user = ax25_findbyuid(current_euid());
 		if (user) {
 			nr->user_addr   = user->call;
 			ax25_uid_put(user);
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index a7f1ce1..d902e2d 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -690,7 +690,7 @@ static int rose_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 
 	source = &addr->srose_call;
 
-	user = ax25_findbyuid(current->euid);
+	user = ax25_findbyuid(current_euid());
 	if (user) {
 		rose->source_call = user->call;
 		ax25_uid_put(user);
@@ -791,7 +791,7 @@ static int rose_connect(struct socket *sock, struct sockaddr *uaddr, int addr_le
 			goto out_release;
 		}
 
-		user = ax25_findbyuid(current->euid);
+		user = ax25_findbyuid(current_euid());
 		if (!user) {
 			err = -EINVAL;
 			goto out_release;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 015606b..6322122 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -467,8 +467,7 @@ static int unix_listen(struct socket *sock, int backlog)
 	sk->sk_state		= TCP_LISTEN;
 	/* set credentials so connect can copy them */
 	sk->sk_peercred.pid	= task_tgid_vnr(current);
-	sk->sk_peercred.uid	= current->euid;
-	sk->sk_peercred.gid	= current->egid;
+	current_euid_egid(&sk->sk_peercred.uid, &sk->sk_peercred.gid);
 	err = 0;
 
 out_unlock:
@@ -1124,8 +1123,7 @@ restart:
 	newsk->sk_state		= TCP_ESTABLISHED;
 	newsk->sk_type		= sk->sk_type;
 	newsk->sk_peercred.pid	= task_tgid_vnr(current);
-	newsk->sk_peercred.uid	= current->euid;
-	newsk->sk_peercred.gid	= current->egid;
+	current_euid_egid(&newsk->sk_peercred.uid, &newsk->sk_peercred.gid);
 	newu = unix_sk(newsk);
 	newsk->sk_sleep		= &newu->peer_wait;
 	otheru = unix_sk(other);
@@ -1185,8 +1183,9 @@ static int unix_socketpair(struct socket *socka, struct socket *sockb)
 	unix_peer(ska)=skb;
 	unix_peer(skb)=ska;
 	ska->sk_peercred.pid = skb->sk_peercred.pid = task_tgid_vnr(current);
-	ska->sk_peercred.uid = skb->sk_peercred.uid = current->euid;
-	ska->sk_peercred.gid = skb->sk_peercred.gid = current->egid;
+	current_euid_egid(&skb->sk_peercred.uid, &skb->sk_peercred.gid);
+	ska->sk_peercred.uid = skb->sk_peercred.uid;
+	ska->sk_peercred.gid = skb->sk_peercred.gid;
 
 	if (ska->sk_type != SOCK_DGRAM) {
 		ska->sk_state = TCP_ESTABLISHED;
diff --git a/security/commoncap.c b/security/commoncap.c
index 708aa05..570fd75 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -334,7 +334,7 @@ int cap_bprm_set_security (struct linux_binprm *bprm)
 		 * If only the real uid is 0, we do not set the effective
 		 * bit.
 		 */
-		if (bprm->e_uid == 0 || current->uid == 0) {
+		if (bprm->e_uid == 0 || current_uid() == 0) {
 			/* pP' = (cap_bset & ~0) | (pI & ~0) */
 			bprm->cap_post_exec_permitted = cap_combine(
 				current->cap_bset, current->cap_inheritable
@@ -349,7 +349,12 @@ int cap_bprm_set_security (struct linux_binprm *bprm)
 
 void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 {
-	if (bprm->e_uid != current->uid || bprm->e_gid != current->gid ||
+	uid_t uid;
+	gid_t gid;
+
+	current_uid_gid(&uid, &gid);
+
+	if (bprm->e_uid != uid || bprm->e_gid != gid ||
 	    !cap_issubset(bprm->cap_post_exec_permitted,
 			  current->cap_permitted)) {
 		set_dumpable(current->mm, suid_dumpable);
@@ -357,8 +362,8 @@ void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 
 		if (unsafe & ~LSM_UNSAFE_PTRACE_CAP) {
 			if (!capable(CAP_SETUID)) {
-				bprm->e_uid = current->uid;
-				bprm->e_gid = current->gid;
+				bprm->e_uid = uid;
+				bprm->e_gid = gid;
 			}
 			if (cap_limit_ptraced_target()) {
 				bprm->cap_post_exec_permitted = cap_intersect(
@@ -389,15 +394,15 @@ void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 
 int cap_bprm_secureexec (struct linux_binprm *bprm)
 {
-	if (current->uid != 0) {
+	if (current_uid() != 0) {
 		if (bprm->cap_effective)
 			return 1;
 		if (!cap_isclear(bprm->cap_post_exec_permitted))
 			return 1;
 	}
 
-	return (current->euid != current->uid ||
-		current->egid != current->gid);
+	return (current_euid() != current_uid() ||
+		current_egid() != current_gid());
 }
 
 int cap_inode_setxattr(struct dentry *dentry, const char *name,
@@ -460,16 +465,18 @@ int cap_inode_removexattr(struct dentry *dentry, const char *name)
 static inline void cap_emulate_setxuid (int old_ruid, int old_euid,
 					int old_suid)
 {
+	uid_t euid = current_euid();
+
 	if ((old_ruid == 0 || old_euid == 0 || old_suid == 0) &&
-	    (current->uid != 0 && current->euid != 0 && current->suid != 0) &&
+	    (current_uid()  != 0 && euid != 0 && current_suid() != 0) &&
 	    !issecure(SECURE_KEEP_CAPS)) {
 		cap_clear (current->cap_permitted);
 		cap_clear (current->cap_effective);
 	}
-	if (old_euid == 0 && current->euid != 0) {
+	if (old_euid == 0 && euid != 0) {
 		cap_clear (current->cap_effective);
 	}
-	if (old_euid != 0 && current->euid == 0) {
+	if (old_euid != 0 && euid == 0) {
 		current->cap_effective = current->cap_permitted;
 	}
 }

