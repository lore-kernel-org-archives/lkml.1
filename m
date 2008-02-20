Return-Path: <linux-kernel-owner+w=401wt.eu-S932534AbYBTQOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534AbYBTQOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764935AbYBTQJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:09:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759038AbYBTQIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:08:49 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 06/37] Security: Separate task security context from
	task_struct
To: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, casey@schaufler-ca.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 20 Feb 2008 16:06:30 +0000
Message-ID: <20080220160630.4715.28518.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
References: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate the task security context from task_struct.  At this point, the
security data is temporarily embedded in the task_struct with two pointers
pointing to it.

Alpha needs further alteration as it refers to UID & GID in entry.S via asm
offsets.

Sparc needs further alteration as it refers to UID & GID in sclow.S via asm
offsets.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/parisc/kernel/signal.c       |    2 
 arch/powerpc/mm/fault.c           |    2 
 arch/s390/hypfs/inode.c           |    4 -
 arch/s390/kernel/compat_linux.c   |   28 ++--
 arch/sparc64/kernel/sys_sparc32.c |   28 ++--
 drivers/block/loop.c              |    5 -
 drivers/char/drm/drm_fops.c       |    2 
 drivers/char/tty_audit.c          |    5 -
 drivers/connector/cn_proc.c       |    8 +
 drivers/media/video/cpia.c        |    2 
 drivers/net/tun.c                 |    4 -
 drivers/net/wan/sbni.c            |    8 +
 drivers/usb/core/devio.c          |    8 +
 fs/affs/super.c                   |    4 -
 fs/autofs/inode.c                 |    4 -
 fs/autofs4/inode.c                |    4 -
 fs/autofs4/waitq.c                |    4 -
 fs/binfmt_elf.c                   |   12 +-
 fs/binfmt_elf_fdpic.c             |   12 +-
 fs/cifs/connect.c                 |    5 -
 fs/cifs/ioctl.c                   |    2 
 fs/dquot.c                        |    3 
 fs/ecryptfs/messaging.c           |   15 +-
 fs/exec.c                         |   20 +--
 fs/fat/inode.c                    |    4 -
 fs/fcntl.c                        |    7 +
 fs/file_table.c                   |    4 -
 fs/fuse/dir.c                     |   12 +-
 fs/hfs/super.c                    |    4 -
 fs/hfsplus/options.c              |    4 -
 fs/hpfs/super.c                   |    4 -
 fs/hugetlbfs/inode.c              |    4 -
 fs/inotify_user.c                 |    2 
 fs/ioprio.c                       |   12 +-
 fs/namei.c                        |    6 +
 fs/ncpfs/ioctl.c                  |   32 ++--
 fs/nfsd/auth.c                    |   22 ++-
 fs/nfsd/nfs4recover.c             |   12 +-
 fs/open.c                         |   22 +--
 fs/proc/array.c                   |   16 +-
 fs/proc/base.c                    |   16 +-
 fs/proc/proc_sysctl.c             |    4 -
 fs/quota.c                        |    4 -
 fs/smbfs/dir.c                    |    4 -
 fs/smbfs/inode.c                  |    2 
 fs/smbfs/proc.c                   |    2 
 include/linux/init_task.h         |   25 ++-
 include/linux/sched.h             |   80 ++++++++---
 include/net/scm.h                 |    4 -
 ipc/mqueue.c                      |    4 -
 ipc/msg.c                         |    4 -
 ipc/sem.c                         |    4 -
 ipc/shm.c                         |   16 +-
 ipc/util.c                        |    7 +
 kernel/acct.c                     |    8 +
 kernel/auditsc.c                  |   46 +++---
 kernel/cgroup.c                   |    5 -
 kernel/exit.c                     |   10 +
 kernel/fork.c                     |   24 ++-
 kernel/futex.c                    |    8 +
 kernel/futex_compat.c             |    5 -
 kernel/ptrace.c                   |   14 +-
 kernel/sched.c                    |   11 +
 kernel/signal.c                   |   26 ++-
 kernel/sys.c                      |  278 +++++++++++++++++++++----------------
 kernel/sysctl.c                   |    2 
 kernel/timer.c                    |    8 +
 kernel/tsacct.c                   |    4 -
 kernel/uid16.c                    |   28 ++--
 kernel/user.c                     |    4 -
 kernel/user_namespace.c           |    2 
 mm/mempolicy.c                    |    7 +
 mm/migrate.c                      |    7 +
 mm/oom_kill.c                     |    2 
 net/ax25/af_ax25.c                |    2 
 net/ax25/ax25_route.c             |    2 
 net/core/dev.c                    |    2 
 net/core/scm.c                    |   10 +
 net/ipv6/ip6_flowlabel.c          |    2 
 net/netrom/af_netrom.c            |    4 -
 net/rose/af_rose.c                |    4 -
 net/sunrpc/auth.c                 |    4 -
 net/unix/af_unix.c                |   12 +-
 security/commoncap.c              |  133 ++++++++++--------
 security/dummy.c                  |   40 +++--
 security/keys/keyctl.c            |   25 ++-
 security/keys/permission.c        |   11 +
 security/keys/process_keys.c      |   76 +++++-----
 security/keys/request_key.c       |   13 +-
 security/keys/request_key_auth.c  |   12 +-
 security/selinux/exports.c        |    4 -
 security/selinux/hooks.c          |  111 +++++++--------
 security/selinux/selinuxfs.c      |    2 
 security/selinux/xfrm.c           |    6 -
 security/smack/smack_access.c     |    2 
 security/smack/smack_lsm.c        |   74 +++++-----
 security/smack/smackfs.c          |    4 -
 97 files changed, 872 insertions(+), 716 deletions(-)


diff --git a/arch/parisc/kernel/signal.c b/arch/parisc/kernel/signal.c
index 58fccc9..6639d9b 100644
--- a/arch/parisc/kernel/signal.c
+++ b/arch/parisc/kernel/signal.c
@@ -182,7 +182,7 @@ give_sigsegv:
 	si.si_errno = 0;
 	si.si_code = SI_KERNEL;
 	si.si_pid = task_pid_vnr(current);
-	si.si_uid = current->uid;
+	si.si_uid = current->act_as->uid;
 	si.si_addr = &frame->uc;
 	force_sig_info(SIGSEGV, &si, current);
 	return;
diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 7b25107..fea0e5a 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -363,7 +363,7 @@ bad_area_nosemaphore:
 	    && printk_ratelimit())
 		printk(KERN_CRIT "kernel tried to execute NX-protected"
 		       " page (%lx) - exploit attempt? (uid: %d)\n",
-		       address, current->uid);
+		       address, current->act_as->uid);
 
 	return SIGSEGV;
 
diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 4b010ff..56b7df6 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -289,8 +289,8 @@ static int hypfs_fill_super(struct super_block *sb, void *data, int silent)
 	if (!sbi)
 		return -ENOMEM;
 	mutex_init(&sbi->lock);
-	sbi->uid = current->uid;
-	sbi->gid = current->gid;
+	sbi->uid = current->act_as->uid;
+	sbi->gid = current->act_as->gid;
 	sb->s_fs_info = sbi;
 	sb->s_blocksize = PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
diff --git a/arch/s390/kernel/compat_linux.c b/arch/s390/kernel/compat_linux.c
index 50b85d0..d939699 100644
--- a/arch/s390/kernel/compat_linux.c
+++ b/arch/s390/kernel/compat_linux.c
@@ -149,9 +149,9 @@ asmlinkage long sys32_getresuid16(u16 __user *ruid, u16 __user *euid, u16 __user
 {
 	int retval;
 
-	if (!(retval = put_user(high2lowuid(current->uid), ruid)) &&
-	    !(retval = put_user(high2lowuid(current->euid), euid)))
-		retval = put_user(high2lowuid(current->suid), suid);
+	if (!(retval = put_user(high2lowuid(current->sec->uid), ruid)) &&
+	    !(retval = put_user(high2lowuid(current->sec->euid), euid)))
+		retval = put_user(high2lowuid(current->sec->suid), suid);
 
 	return retval;
 }
@@ -166,9 +166,9 @@ asmlinkage long sys32_getresgid16(u16 __user *rgid, u16 __user *egid, u16 __user
 {
 	int retval;
 
-	if (!(retval = put_user(high2lowgid(current->gid), rgid)) &&
-	    !(retval = put_user(high2lowgid(current->egid), egid)))
-		retval = put_user(high2lowgid(current->sgid), sgid);
+	if (!(retval = put_user(high2lowgid(current->sec->gid), rgid)) &&
+	    !(retval = put_user(high2lowgid(current->sec->egid), egid)))
+		retval = put_user(high2lowgid(current->sec->sgid), sgid);
 
 	return retval;
 }
@@ -218,20 +218,20 @@ asmlinkage long sys32_getgroups16(int gidsetsize, u16 __user *grouplist)
 	if (gidsetsize < 0)
 		return -EINVAL;
 
-	get_group_info(current->group_info);
-	i = current->group_info->ngroups;
+	get_group_info(current->sec->group_info);
+	i = current->sec->group_info->ngroups;
 	if (gidsetsize) {
 		if (i > gidsetsize) {
 			i = -EINVAL;
 			goto out;
 		}
-		if (groups16_to_user(grouplist, current->group_info)) {
+		if (groups16_to_user(grouplist, current->sec->group_info)) {
 			i = -EFAULT;
 			goto out;
 		}
 	}
 out:
-	put_group_info(current->group_info);
+	put_group_info(current->sec->group_info);
 	return i;
 }
 
@@ -262,22 +262,22 @@ asmlinkage long sys32_setgroups16(int gidsetsize, u16 __user *grouplist)
 
 asmlinkage long sys32_getuid16(void)
 {
-	return high2lowuid(current->uid);
+	return high2lowuid(current->sec->uid);
 }
 
 asmlinkage long sys32_geteuid16(void)
 {
-	return high2lowuid(current->euid);
+	return high2lowuid(current->sec->euid);
 }
 
 asmlinkage long sys32_getgid16(void)
 {
-	return high2lowgid(current->gid);
+	return high2lowgid(current->sec->gid);
 }
 
 asmlinkage long sys32_getegid16(void)
 {
-	return high2lowgid(current->egid);
+	return high2lowgid(current->sec->egid);
 }
 
 /* 32-bit timeval and related flotsam.  */
diff --git a/arch/sparc64/kernel/sys_sparc32.c b/arch/sparc64/kernel/sys_sparc32.c
index deaba2b..59297aa 100644
--- a/arch/sparc64/kernel/sys_sparc32.c
+++ b/arch/sparc64/kernel/sys_sparc32.c
@@ -104,9 +104,9 @@ asmlinkage long sys32_getresuid16(u16 __user *ruid, u16 __user *euid, u16 __user
 {
 	int retval;
 
-	if (!(retval = put_user(high2lowuid(current->uid), ruid)) &&
-	    !(retval = put_user(high2lowuid(current->euid), euid)))
-		retval = put_user(high2lowuid(current->suid), suid);
+	if (!(retval = put_user(high2lowuid(current->sec->uid), ruid)) &&
+	    !(retval = put_user(high2lowuid(current->sec->euid), euid)))
+		retval = put_user(high2lowuid(current->sec->suid), suid);
 
 	return retval;
 }
@@ -121,9 +121,9 @@ asmlinkage long sys32_getresgid16(u16 __user *rgid, u16 __user *egid, u16 __user
 {
 	int retval;
 
-	if (!(retval = put_user(high2lowgid(current->gid), rgid)) &&
-	    !(retval = put_user(high2lowgid(current->egid), egid)))
-		retval = put_user(high2lowgid(current->sgid), sgid);
+	if (!(retval = put_user(high2lowgid(current->sec->gid), rgid)) &&
+	    !(retval = put_user(high2lowgid(current->sec->egid), egid)))
+		retval = put_user(high2lowgid(current->sec->sgid), sgid);
 
 	return retval;
 }
@@ -173,20 +173,20 @@ asmlinkage long sys32_getgroups16(int gidsetsize, u16 __user *grouplist)
 	if (gidsetsize < 0)
 		return -EINVAL;
 
-	get_group_info(current->group_info);
-	i = current->group_info->ngroups;
+	get_group_info(current->sec->group_info);
+	i = current->sec->group_info->ngroups;
 	if (gidsetsize) {
 		if (i > gidsetsize) {
 			i = -EINVAL;
 			goto out;
 		}
-		if (groups16_to_user(grouplist, current->group_info)) {
+		if (groups16_to_user(grouplist, current->sec->group_info)) {
 			i = -EFAULT;
 			goto out;
 		}
 	}
 out:
-	put_group_info(current->group_info);
+	put_group_info(current->sec->group_info);
 	return i;
 }
 
@@ -217,22 +217,22 @@ asmlinkage long sys32_setgroups16(int gidsetsize, u16 __user *grouplist)
 
 asmlinkage long sys32_getuid16(void)
 {
-	return high2lowuid(current->uid);
+	return high2lowuid(current->sec->uid);
 }
 
 asmlinkage long sys32_geteuid16(void)
 {
-	return high2lowuid(current->euid);
+	return high2lowuid(current->sec->euid);
 }
 
 asmlinkage long sys32_getgid16(void)
 {
-	return high2lowgid(current->gid);
+	return high2lowgid(current->sec->gid);
 }
 
 asmlinkage long sys32_getegid16(void)
 {
-	return high2lowgid(current->egid);
+	return high2lowgid(current->sec->egid);
 }
 
 /* 32-bit timeval and related flotsam.  */
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 91ebb00..fc5caaf 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -928,7 +928,8 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 	int err;
 	struct loop_func_table *xfer;
 
-	if (lo->lo_encrypt_key_size && lo->lo_key_owner != current->uid &&
+	if (lo->lo_encrypt_key_size &&
+	    lo->lo_key_owner != current->act_as->uid &&
 	    !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	if (lo->lo_state != Lo_bound)
@@ -983,7 +984,7 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 	if (info->lo_encrypt_key_size) {
 		memcpy(lo->lo_encrypt_key, info->lo_encrypt_key,
 		       info->lo_encrypt_key_size);
-		lo->lo_key_owner = current->uid;
+		lo->lo_key_owner = current->act_as->uid;
 	}	
 
 	return 0;
diff --git a/drivers/char/drm/drm_fops.c b/drivers/char/drm/drm_fops.c
index 3992f73..1f8d0a7 100644
--- a/drivers/char/drm/drm_fops.c
+++ b/drivers/char/drm/drm_fops.c
@@ -243,7 +243,7 @@ static int drm_open_helper(struct inode *inode, struct file *filp,
 	memset(priv, 0, sizeof(*priv));
 	filp->private_data = priv;
 	priv->filp = filp;
-	priv->uid = current->euid;
+	priv->uid = current->act_as->euid;
 	priv->pid = task_pid_nr(current);
 	priv->minor = minor;
 	priv->head = drm_heads[minor];
diff --git a/drivers/char/tty_audit.c b/drivers/char/tty_audit.c
index 7722466..8a9f847 100644
--- a/drivers/char/tty_audit.c
+++ b/drivers/char/tty_audit.c
@@ -87,8 +87,9 @@ static void tty_audit_buf_push(struct task_struct *tsk, uid_t loginuid,
 		char name[sizeof(tsk->comm)];
 
 		audit_log_format(ab, "tty pid=%u uid=%u auid=%u ses=%u "
-				 "major=%d minor=%d comm=", tsk->pid, tsk->uid,
-				 loginuid, sessionid, buf->major, buf->minor);
+				 "major=%d minor=%d comm=",
+				 tsk->pid, tsk->sec->uid, loginuid, sessionid,
+				 buf->major, buf->minor);
 		get_task_comm(name, tsk);
 		audit_log_untrustedstring(ab, name);
 		audit_log_format(ab, " data=");
diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index 5c9f67f..5a004dd 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -116,11 +116,11 @@ void proc_id_connector(struct task_struct *task, int which_id)
 	ev->event_data.id.process_pid = task->pid;
 	ev->event_data.id.process_tgid = task->tgid;
 	if (which_id == PROC_EVENT_UID) {
-	 	ev->event_data.id.r.ruid = task->uid;
-	 	ev->event_data.id.e.euid = task->euid;
+		ev->event_data.id.r.ruid = task->act_as->uid;
+		ev->event_data.id.e.euid = task->act_as->euid;
 	} else if (which_id == PROC_EVENT_GID) {
-	   	ev->event_data.id.r.rgid = task->gid;
-	   	ev->event_data.id.e.egid = task->egid;
+		ev->event_data.id.r.rgid = task->act_as->gid;
+		ev->event_data.id.e.egid = task->act_as->egid;
 	} else
 	     	return;
 	get_seq(&msg->seq, &ev->cpu);
diff --git a/drivers/media/video/cpia.c b/drivers/media/video/cpia.c
index 7c630f5..5b178ab 100644
--- a/drivers/media/video/cpia.c
+++ b/drivers/media/video/cpia.c
@@ -3202,7 +3202,7 @@ static int cpia_open(struct inode *inode, struct file *file)
 
 	/* Set ownership of /proc/cpia/videoX to current user */
 	if(cam->proc_entry)
-		cam->proc_entry->uid = current->uid;
+		cam->proc_entry->uid = current->act_as->uid;
 
 	/* set mark for loading first frame uncompressed */
 	cam->first_frame = 1;
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 038c1ef..2b63957 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -463,9 +463,9 @@ static int tun_set_iff(struct file *file, struct ifreq *ifr)
 
 		/* Check permissions */
 		if (((tun->owner != -1 &&
-		      current->euid != tun->owner) ||
+		      current->act_as->euid != tun->owner) ||
 		     (tun->group != -1 &&
-		      current->egid != tun->group)) &&
+		      current->act_as->egid != tun->group)) &&
 		     !capable(CAP_NET_ADMIN))
 			return -EPERM;
 	}
diff --git a/drivers/net/wan/sbni.c b/drivers/net/wan/sbni.c
index 15d5c58..1b054c5 100644
--- a/drivers/net/wan/sbni.c
+++ b/drivers/net/wan/sbni.c
@@ -1317,7 +1317,7 @@ sbni_ioctl( struct net_device  *dev,  struct ifreq  *ifr,  int  cmd )
 		break;
 
 	case  SIOCDEVRESINSTATS :
-		if( current->euid != 0 )	/* root only */
+		if (current->act_as->euid != 0)	/* root only */
 			return  -EPERM;
 		memset( &nl->in_stats, 0, sizeof(struct sbni_in_stats) );
 		break;
@@ -1334,7 +1334,7 @@ sbni_ioctl( struct net_device  *dev,  struct ifreq  *ifr,  int  cmd )
 		break;
 
 	case  SIOCDEVSHWSTATE :
-		if( current->euid != 0 )	/* root only */
+		if (current->act_as->euid != 0)	/* root only */
 			return  -EPERM;
 
 		spin_lock( &nl->lock );
@@ -1355,7 +1355,7 @@ sbni_ioctl( struct net_device  *dev,  struct ifreq  *ifr,  int  cmd )
 #ifdef CONFIG_SBNI_MULTILINE
 
 	case  SIOCDEVENSLAVE :
-		if( current->euid != 0 )	/* root only */
+		if (current->act_as->euid != 0)	/* root only */
 			return  -EPERM;
 
 		if (copy_from_user( slave_name, ifr->ifr_data, sizeof slave_name ))
@@ -1370,7 +1370,7 @@ sbni_ioctl( struct net_device  *dev,  struct ifreq  *ifr,  int  cmd )
 		return  enslave( dev, slave_dev );
 
 	case  SIOCDEVEMANSIPATE :
-		if( current->euid != 0 )	/* root only */
+		if (current->act_as->euid != 0)	/* root only */
 			return  -EPERM;
 
 		return  emancipate( dev );
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index ae94176..1b0f54a 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -599,8 +599,8 @@ static int usbdev_open(struct inode *inode, struct file *file)
 	init_waitqueue_head(&ps->wait);
 	ps->discsignr = 0;
 	ps->disc_pid = get_pid(task_pid(current));
-	ps->disc_uid = current->uid;
-	ps->disc_euid = current->euid;
+	ps->disc_uid = current->sec->uid;
+	ps->disc_euid = current->sec->euid;
 	ps->disccontext = NULL;
 	ps->ifclaimed = 0;
 	security_task_getsecid(current, &ps->secid);
@@ -1130,8 +1130,8 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 	as->signr = uurb->signr;
 	as->ifnum = ifnum;
 	as->pid = get_pid(task_pid(current));
-	as->uid = current->uid;
-	as->euid = current->euid;
+	as->uid = current->sec->uid;
+	as->euid = current->sec->euid;
 	security_task_getsecid(current, &as->secid);
 	if (!is_in) {
 		if (copy_from_user(as->urb->transfer_buffer, uurb->buffer,
diff --git a/fs/affs/super.c b/fs/affs/super.c
index d2dc047..25ccece 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -159,8 +159,8 @@ parse_options(char *options, uid_t *uid, gid_t *gid, int *mode, int *reserved, s
 
 	/* Fill in defaults */
 
-	*uid        = current->uid;
-	*gid        = current->gid;
+	*uid        = current->sec->uid;
+	*gid        = current->sec->gid;
 	*reserved   = 2;
 	*root       = -1;
 	*blocksize  = -1;
diff --git a/fs/autofs/inode.c b/fs/autofs/inode.c
index dda510d..5603109 100644
--- a/fs/autofs/inode.c
+++ b/fs/autofs/inode.c
@@ -76,8 +76,8 @@ static int parse_options(char *options, int *pipefd, uid_t *uid, gid_t *gid,
 	substring_t args[MAX_OPT_ARGS];
 	int option;
 
-	*uid = current->uid;
-	*gid = current->gid;
+	*uid = current->sec->uid;
+	*gid = current->sec->gid;
 	*pgrp = task_pgrp_nr(current);
 
 	*minproto = *maxproto = AUTOFS_PROTO_VERSION;
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index 2fdcf5e..c4f8978 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -229,8 +229,8 @@ static int parse_options(char *options, int *pipefd, uid_t *uid, gid_t *gid,
 	substring_t args[MAX_OPT_ARGS];
 	int option;
 
-	*uid = current->uid;
-	*gid = current->gid;
+	*uid = current->sec->uid;
+	*gid = current->sec->gid;
 	*pgrp = task_pgrp_nr(current);
 
 	*minproto = AUTOFS_MIN_PROTO_VERSION;
diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index 1fe28e4..f41f5b7 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -294,8 +294,8 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 		wq->len = len;
 		wq->dev = autofs4_get_dev(sbi);
 		wq->ino = autofs4_get_ino(sbi);
-		wq->uid = current->uid;
-		wq->gid = current->gid;
+		wq->uid = current->sec->uid;
+		wq->gid = current->sec->gid;
 		wq->pid = current->pid;
 		wq->tgid = current->tgid;
 		wq->status = -EINTR; /* Status return if interrupted */
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 41a958a..e37c612 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -200,10 +200,10 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	NEW_AUX_ENT(AT_BASE, interp_load_addr);
 	NEW_AUX_ENT(AT_FLAGS, 0);
 	NEW_AUX_ENT(AT_ENTRY, exec->e_entry);
-	NEW_AUX_ENT(AT_UID, tsk->uid);
-	NEW_AUX_ENT(AT_EUID, tsk->euid);
-	NEW_AUX_ENT(AT_GID, tsk->gid);
-	NEW_AUX_ENT(AT_EGID, tsk->egid);
+	NEW_AUX_ENT(AT_UID, tsk->sec->uid);
+	NEW_AUX_ENT(AT_EUID, tsk->sec->euid);
+	NEW_AUX_ENT(AT_GID, tsk->sec->gid);
+	NEW_AUX_ENT(AT_EGID, tsk->sec->egid);
  	NEW_AUX_ENT(AT_SECURE, security_bprm_secureexec(bprm));
 	if (k_platform) {
 		NEW_AUX_ENT(AT_PLATFORM,
@@ -1389,8 +1389,8 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
 	psinfo->pr_zomb = psinfo->pr_sname == 'Z';
 	psinfo->pr_nice = task_nice(p);
 	psinfo->pr_flag = p->flags;
-	SET_UID(psinfo->pr_uid, p->uid);
-	SET_GID(psinfo->pr_gid, p->gid);
+	SET_UID(psinfo->pr_uid, p->sec->uid);
+	SET_GID(psinfo->pr_gid, p->sec->gid);
 	strncpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
 	
 	return 0;
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 32649f2..0ebb7eb 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -585,10 +585,10 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 	NEW_AUX_ENT( 6,	AT_BASE,	interp_params->elfhdr_addr);
 	NEW_AUX_ENT( 7, AT_FLAGS,	0);
 	NEW_AUX_ENT( 8, AT_ENTRY,	exec_params->entry_addr);
-	NEW_AUX_ENT( 9, AT_UID,		(elf_addr_t) current->uid);
-	NEW_AUX_ENT(10, AT_EUID,	(elf_addr_t) current->euid);
-	NEW_AUX_ENT(11, AT_GID,		(elf_addr_t) current->gid);
-	NEW_AUX_ENT(12, AT_EGID,	(elf_addr_t) current->egid);
+	NEW_AUX_ENT( 9, AT_UID,		(elf_addr_t) current->sec->uid);
+	NEW_AUX_ENT(10, AT_EUID,	(elf_addr_t) current->sec->euid);
+	NEW_AUX_ENT(11, AT_GID,		(elf_addr_t) current->sec->gid);
+	NEW_AUX_ENT(12, AT_EGID,	(elf_addr_t) current->sec->egid);
 
 #ifdef ARCH_DLINFO
 	/* ARCH_DLINFO must come last so platform specific code can enforce
@@ -1402,8 +1402,8 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
 	psinfo->pr_zomb = psinfo->pr_sname == 'Z';
 	psinfo->pr_nice = task_nice(p);
 	psinfo->pr_flag = p->flags;
-	SET_UID(psinfo->pr_uid, p->uid);
-	SET_GID(psinfo->pr_gid, p->gid);
+	SET_UID(psinfo->pr_uid, p->sec->uid);
+	SET_GID(psinfo->pr_gid, p->sec->gid);
 	strncpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
 
 	return 0;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 65d0ba7..5fcd5e0 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -818,8 +818,9 @@ cifs_parse_mount_options(char *options, const char *devname,
 	/* null target name indicates to use *SMBSERVR default called name
 	   if we end up sending RFC1001 session initialize */
 	vol->target_rfc1001_name[0] = 0;
-	vol->linux_uid = current->uid;	/* current->euid instead? */
-	vol->linux_gid = current->gid;
+	vol->linux_uid = current->sec->uid;  /* use current->act_as->euid
+					      * instead? */
+	vol->linux_gid = current->sec->gid;
 	vol->dir_mode = S_IRWXUGO;
 	/* 2767 perms indicate mandatory locking support */
 	vol->file_mode = (S_IRWXUGO | S_ISGID) & (~S_IXGRP);
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index d24fe68..bf61a78 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -65,7 +65,7 @@ int cifs_ioctl (struct inode *inode, struct file *filep,
 	switch (command) {
 		case CIFS_IOC_CHECKUMOUNT:
 			cFYI(1, ("User unmount attempted"));
-			if (cifs_sb->mnt_uid == current->uid)
+			if (cifs_sb->mnt_uid == current->sec->uid)
 				rc = 0;
 			else {
 				rc = -EACCES;
diff --git a/fs/dquot.c b/fs/dquot.c
index 5f5e942..5a4de89 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -960,7 +960,8 @@ static void send_warning(const struct dquot *dquot, const char warntype)
 		MINOR(dquot->dq_sb->s_dev));
 	if (ret)
 		goto attr_err_out;
-	ret = nla_put_u64(skb, QUOTA_NL_A_CAUSED_ID, current->user->uid);
+	ret = nla_put_u64(skb, QUOTA_NL_A_CAUSED_ID,
+			  current->act_as->user->uid);
 	if (ret)
 		goto attr_err_out;
 	genlmsg_end(skb, msg_head);
diff --git a/fs/ecryptfs/messaging.c b/fs/ecryptfs/messaging.c
index 9cc2aec..d035a5f 100644
--- a/fs/ecryptfs/messaging.c
+++ b/fs/ecryptfs/messaging.c
@@ -264,26 +264,27 @@ int ecryptfs_process_response(struct ecryptfs_message *msg, uid_t uid,
 	}
 	msg_ctx = &ecryptfs_msg_ctx_arr[msg->index];
 	mutex_lock(&msg_ctx->mux);
-	if (ecryptfs_find_daemon_id(msg_ctx->task->euid, &id)) {
+	if (ecryptfs_find_daemon_id(msg_ctx->task->sec->euid, &id)) {
 		rc = -EBADMSG;
 		ecryptfs_printk(KERN_WARNING, "User [%d] received a "
 				"message response from process [%d] but does "
 				"not have a registered daemon\n",
-				msg_ctx->task->euid, pid);
+				msg_ctx->task->sec->euid, pid);
 		goto wake_up;
 	}
-	if (msg_ctx->task->euid != uid) {
+	if (msg_ctx->task->sec->euid != uid) {
 		rc = -EBADMSG;
 		ecryptfs_printk(KERN_WARNING, "Received message from user "
 				"[%d]; expected message from user [%d]\n",
-				uid, msg_ctx->task->euid);
+				uid, msg_ctx->task->sec->euid);
 		goto unlock;
 	}
 	if (id->pid != pid) {
 		rc = -EBADMSG;
 		ecryptfs_printk(KERN_ERR, "User [%d] received a "
 				"message response from an unrecognized "
-				"process [%d]\n", msg_ctx->task->euid, pid);
+				"process [%d]\n",
+				msg_ctx->task->sec->euid, pid);
 		goto unlock;
 	}
 	if (msg_ctx->state != ECRYPTFS_MSG_CTX_STATE_PENDING) {
@@ -331,11 +332,11 @@ int ecryptfs_send_message(unsigned int transport, char *data, int data_len,
 	int rc;
 
 	mutex_lock(&ecryptfs_daemon_id_hash_mux);
-	if (ecryptfs_find_daemon_id(current->euid, &id)) {
+	if (ecryptfs_find_daemon_id(current->act_as->euid, &id)) {
 		mutex_unlock(&ecryptfs_daemon_id_hash_mux);
 		rc = -ENOTCONN;
 		ecryptfs_printk(KERN_ERR, "User [%d] does not have a daemon "
-				"registered\n", current->euid);
+				"registered\n", current->sec->euid);
 		goto out;
 	}
 	mutex_unlock(&ecryptfs_daemon_id_hash_mux);
diff --git a/fs/exec.c b/fs/exec.c
index 273fcde..3463f81 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -979,7 +979,8 @@ int flush_old_exec(struct linux_binprm * bprm)
 
 	current->sas_ss_sp = current->sas_ss_size = 0;
 
-	if (current->euid == current->uid && current->egid == current->gid)
+	if (current->sec->euid == current->sec->uid &&
+	    current->sec->egid == current->sec->gid)
 		set_dumpable(current->mm, 1);
 	else
 		set_dumpable(current->mm, suid_dumpable);
@@ -1006,7 +1007,8 @@ int flush_old_exec(struct linux_binprm * bprm)
 	 */
 	current->mm->task_size = TASK_SIZE;
 
-	if (bprm->e_uid != current->euid || bprm->e_gid != current->egid) {
+	if (bprm->e_uid != current->sec->euid ||
+	    bprm->e_gid != current->sec->egid) {
 		suid_keys(current);
 		set_dumpable(current->mm, suid_dumpable);
 		current->pdeath_signal = 0;
@@ -1048,8 +1050,8 @@ int prepare_binprm(struct linux_binprm *bprm)
 	if (bprm->file->f_op == NULL)
 		return -EACCES;
 
-	bprm->e_uid = current->euid;
-	bprm->e_gid = current->egid;
+	bprm->e_uid = current->sec->euid;
+	bprm->e_gid = current->sec->egid;
 
 	if(!(bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)) {
 		/* Set-uid? */
@@ -1102,7 +1104,7 @@ void compute_creds(struct linux_binprm *bprm)
 {
 	int unsafe;
 
-	if (bprm->e_uid != current->uid) {
+	if (bprm->e_uid != current->sec->uid) {
 		suid_keys(current);
 		current->pdeath_signal = 0;
 	}
@@ -1420,7 +1422,7 @@ static int format_corename(char *corename, const char *pattern, long signr)
 			/* uid */
 			case 'u':
 				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%d", current->uid);
+					      "%d", current->sec->uid);
 				if (rc > out_end - out_ptr)
 					goto out;
 				out_ptr += rc;
@@ -1428,7 +1430,7 @@ static int format_corename(char *corename, const char *pattern, long signr)
 			/* gid */
 			case 'g':
 				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%d", current->gid);
+					      "%d", current->sec->gid);
 				if (rc > out_end - out_ptr)
 					goto out;
 				out_ptr += rc;
@@ -1686,7 +1688,7 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	 */
 	if (get_dumpable(mm) == 2) {	/* Setuid core dump mode */
 		flag = O_EXCL;		/* Stop rewrite attacks */
-		current->fsuid = 0;	/* Dump root private */
+		current->act_as->fsuid = 0;	/* Dump root private */
 	}
 
 	retval = coredump_wait(exit_code);
@@ -1782,7 +1784,7 @@ fail_unlock:
 	if (helper_argv)
 		argv_free(helper_argv);
 
-	current->fsuid = fsuid;
+	current->act_as->fsuid = fsuid;
 	complete_all(&mm->core_done);
 fail:
 	return retval;
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 53f3cf6..ff98351 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -934,8 +934,8 @@ static int parse_options(char *options, int is_vfat, int silent, int *debug,
 
 	opts->isvfat = is_vfat;
 
-	opts->fs_uid = current->uid;
-	opts->fs_gid = current->gid;
+	opts->fs_uid = current->sec->uid;
+	opts->fs_gid = current->sec->gid;
 	opts->fs_fmask = opts->fs_dmask = current->fs->umask;
 	opts->codepage = fat_default_codepage;
 	opts->iocharset = fat_default_iocharset;
diff --git a/fs/fcntl.c b/fs/fcntl.c
index e632da7..770d589 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -276,7 +276,8 @@ int __f_setown(struct file *filp, struct pid *pid, enum pid_type type,
 	if (err)
 		return err;
 
-	f_modown(filp, pid, type, current->uid, current->euid, force);
+	f_modown(filp, pid, type, current->sec->uid, current->act_as->euid,
+		 force);
 	return 0;
 }
 EXPORT_SYMBOL(__f_setown);
@@ -461,8 +462,8 @@ static inline int sigio_perm(struct task_struct *p,
                              struct fown_struct *fown, int sig)
 {
 	return (((fown->euid == 0) ||
-		 (fown->euid == p->suid) || (fown->euid == p->uid) ||
-		 (fown->uid == p->suid) || (fown->uid == p->uid)) &&
+		 (fown->euid == p->sec->suid) || (fown->euid == p->sec->uid) ||
+		 (fown->uid == p->sec->suid) || (fown->uid == p->sec->uid)) &&
 		!security_file_send_sigiotask(p, fown, sig));
 }
 
diff --git a/fs/file_table.c b/fs/file_table.c
index 6d27bef..2bce448 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -114,8 +114,8 @@ struct file *get_empty_filp(void)
 	INIT_LIST_HEAD(&f->f_u.fu_list);
 	atomic_set(&f->f_count, 1);
 	rwlock_init(&f->f_owner.lock);
-	f->f_uid = tsk->fsuid;
-	f->f_gid = tsk->fsgid;
+	f->f_uid = tsk->act_as->fsuid;
+	f->f_gid = tsk->act_as->fsgid;
 	eventpoll_init_file(f);
 	/* f->f_version: 0 */
 	return f;
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 7fb514b..565bfa9 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -831,12 +831,12 @@ int fuse_allow_task(struct fuse_conn *fc, struct task_struct *task)
 	if (fc->flags & FUSE_ALLOW_OTHER)
 		return 1;
 
-	if (task->euid == fc->user_id &&
-	    task->suid == fc->user_id &&
-	    task->uid == fc->user_id &&
-	    task->egid == fc->group_id &&
-	    task->sgid == fc->group_id &&
-	    task->gid == fc->group_id)
+	if (task->sec->euid == fc->user_id &&
+	    task->sec->suid == fc->user_id &&
+	    task->sec->uid == fc->user_id &&
+	    task->sec->egid == fc->group_id &&
+	    task->sec->sgid == fc->group_id &&
+	    task->sec->gid == fc->group_id)
 		return 1;
 
 	return 0;
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index 32de44e..4c2f0c1 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -210,8 +210,8 @@ static int parse_options(char *options, struct hfs_sb_info *hsb)
 	int tmp, token;
 
 	/* initialize the sb with defaults */
-	hsb->s_uid = current->uid;
-	hsb->s_gid = current->gid;
+	hsb->s_uid = current->sec->uid;
+	hsb->s_gid = current->sec->gid;
 	hsb->s_file_umask = 0133;
 	hsb->s_dir_umask = 0022;
 	hsb->s_type = hsb->s_creator = cpu_to_be32(0x3f3f3f3f);	/* == '????' */
diff --git a/fs/hfsplus/options.c b/fs/hfsplus/options.c
index dc64fac..fa5e015 100644
--- a/fs/hfsplus/options.c
+++ b/fs/hfsplus/options.c
@@ -49,8 +49,8 @@ void hfsplus_fill_defaults(struct hfsplus_sb_info *opts)
 	opts->creator = HFSPLUS_DEF_CR_TYPE;
 	opts->type = HFSPLUS_DEF_CR_TYPE;
 	opts->umask = current->fs->umask;
-	opts->uid = current->uid;
-	opts->gid = current->gid;
+	opts->uid = current->sec->uid;
+	opts->gid = current->sec->gid;
 	opts->part = -1;
 	opts->session = -1;
 }
diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index f63a699..a403518 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -475,8 +475,8 @@ static int hpfs_fill_super(struct super_block *s, void *options, int silent)
 
 	init_MUTEX(&sbi->hpfs_creation_de);
 
-	uid = current->uid;
-	gid = current->gid;
+	uid = current->sec->uid;
+	gid = current->sec->gid;
 	umask = current->fs->umask;
 	lowercase = 0;
 	conv = CONV_BINARY;
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 7db315f..978eca1 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -924,7 +924,7 @@ struct file *hugetlb_file_setup(const char *name, size_t size)
 	if (!can_do_hugetlb_shm())
 		return ERR_PTR(-EPERM);
 
-	if (!user_shm_lock(size, current->user))
+	if (!user_shm_lock(size, current->sec->user))
 		return ERR_PTR(-ENOMEM);
 
 	root = hugetlbfs_vfsmount->mnt_root;
@@ -963,7 +963,7 @@ out_inode:
 out_dentry:
 	dput(dentry);
 out_shm_unlock:
-	user_shm_unlock(size, current->user);
+	user_shm_unlock(size, current->sec->user);
 	return ERR_PTR(error);
 }
 
diff --git a/fs/inotify_user.c b/fs/inotify_user.c
index 7b94a1e..36e719d 100644
--- a/fs/inotify_user.c
+++ b/fs/inotify_user.c
@@ -584,7 +584,7 @@ asmlinkage long sys_inotify_init(void)
 		goto out_put_fd;
 	}
 
-	user = get_uid(current->user);
+	user = get_uid(current->sec->user);
 	if (unlikely(atomic_read(&user->inotify_devs) >=
 			inotify_max_user_instances)) {
 		ret = -EMFILE;
diff --git a/fs/ioprio.c b/fs/ioprio.c
index c4a1c3c..befcda5 100644
--- a/fs/ioprio.c
+++ b/fs/ioprio.c
@@ -32,8 +32,8 @@ static int set_task_ioprio(struct task_struct *task, int ioprio)
 	int err;
 	struct io_context *ioc;
 
-	if (task->uid != current->euid &&
-	    task->uid != current->uid && !capable(CAP_SYS_NICE))
+	if (task->sec->uid != current->act_as->euid &&
+	    task->sec->uid != current->act_as->uid && !capable(CAP_SYS_NICE))
 		return -EPERM;
 
 	err = security_task_setioprio(task, ioprio);
@@ -123,7 +123,7 @@ asmlinkage long sys_ioprio_set(int which, int who, int ioprio)
 			break;
 		case IOPRIO_WHO_USER:
 			if (!who)
-				user = current->user;
+				user = current->sec->user;
 			else
 				user = find_user(who);
 
@@ -131,7 +131,7 @@ asmlinkage long sys_ioprio_set(int which, int who, int ioprio)
 				break;
 
 			do_each_thread(g, p) {
-				if (p->uid != who)
+				if (p->sec->uid != who)
 					continue;
 				ret = set_task_ioprio(p, ioprio);
 				if (ret)
@@ -216,7 +216,7 @@ asmlinkage long sys_ioprio_get(int which, int who)
 			break;
 		case IOPRIO_WHO_USER:
 			if (!who)
-				user = current->user;
+				user = current->sec->user;
 			else
 				user = find_user(who);
 
@@ -224,7 +224,7 @@ asmlinkage long sys_ioprio_get(int which, int who)
 				break;
 
 			do_each_thread(g, p) {
-				if (p->uid != user->uid)
+				if (p->sec->uid != user->uid)
 					continue;
 				tmpio = get_task_ioprio(p);
 				if (tmpio < 0)
diff --git a/fs/namei.c b/fs/namei.c
index e232134..495c759 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1435,11 +1435,13 @@ int __user_walk(const char __user *name, unsigned flags, struct nameidata *nd)
  */
 static inline int check_sticky(struct inode *dir, struct inode *inode)
 {
+	uid_t fsuid = current->act_as->fsuid;
+
 	if (!(dir->i_mode & S_ISVTX))
 		return 0;
-	if (inode->i_uid == current_fsuid())
+	if (inode->i_uid == fsuid)
 		return 0;
-	if (dir->i_uid == current_fsuid())
+	if (dir->i_uid == fsuid)
 		return 0;
 	return !capable(CAP_FOWNER);
 }
diff --git a/fs/ncpfs/ioctl.c b/fs/ncpfs/ioctl.c
index c67b4bd..5f1adaf 100644
--- a/fs/ncpfs/ioctl.c
+++ b/fs/ncpfs/ioctl.c
@@ -40,7 +40,7 @@ ncp_get_fs_info(struct ncp_server * server, struct file *file,
 	struct ncp_fs_info info;
 
 	if ((file_permission(file, MAY_WRITE) != 0)
-	    && (current->uid != server->m.mounted_uid)) {
+	    && (current->act_as->uid != server->m.mounted_uid)) {
 		return -EACCES;
 	}
 	if (copy_from_user(&info, arg, sizeof(info)))
@@ -70,7 +70,7 @@ ncp_get_fs_info_v2(struct ncp_server * server, struct file *file,
 	struct ncp_fs_info_v2 info2;
 
 	if ((file_permission(file, MAY_WRITE) != 0)
-	    && (current->uid != server->m.mounted_uid)) {
+	    && (current->act_as->uid != server->m.mounted_uid)) {
 		return -EACCES;
 	}
 	if (copy_from_user(&info2, arg, sizeof(info2)))
@@ -141,7 +141,7 @@ ncp_get_compat_fs_info_v2(struct ncp_server * server, struct file *file,
 	struct compat_ncp_fs_info_v2 info2;
 
 	if ((file_permission(file, MAY_WRITE) != 0)
-	    && (current->uid != server->m.mounted_uid)) {
+	    && (current->act_as->uid != server->m.mounted_uid)) {
 		return -EACCES;
 	}
 	if (copy_from_user(&info2, arg, sizeof(info2)))
@@ -276,7 +276,7 @@ int ncp_ioctl(struct inode *inode, struct file *filp,
 #endif
 	case NCP_IOC_NCPREQUEST:
 		if ((file_permission(filp, MAY_WRITE) != 0)
-		    && (current->uid != server->m.mounted_uid)) {
+		    && (current->act_as->uid != server->m.mounted_uid)) {
 			return -EACCES;
 		}
 #ifdef CONFIG_COMPAT
@@ -356,7 +356,7 @@ int ncp_ioctl(struct inode *inode, struct file *filp,
 	case NCP_IOC_GETMOUNTUID32:
 	case NCP_IOC_GETMOUNTUID64:
 		if ((file_permission(filp, MAY_READ) != 0)
-			&& (current->uid != server->m.mounted_uid)) {
+			&& (current->act_as->uid != server->m.mounted_uid)) {
 			return -EACCES;
 		}
 		if (cmd == NCP_IOC_GETMOUNTUID16) {
@@ -380,7 +380,7 @@ int ncp_ioctl(struct inode *inode, struct file *filp,
 			struct ncp_setroot_ioctl sr;
 
 			if ((file_permission(filp, MAY_READ) != 0)
-			    && (current->uid != server->m.mounted_uid))
+			    && (current->act_as->uid != server->m.mounted_uid))
 			{
 				return -EACCES;
 			}
@@ -455,7 +455,7 @@ int ncp_ioctl(struct inode *inode, struct file *filp,
 #ifdef CONFIG_NCPFS_PACKET_SIGNING	
 	case NCP_IOC_SIGN_INIT:
 		if ((file_permission(filp, MAY_WRITE) != 0)
-		    && (current->uid != server->m.mounted_uid))
+		    && (current->act_as->uid != server->m.mounted_uid))
 		{
 			return -EACCES;
 		}
@@ -478,7 +478,7 @@ int ncp_ioctl(struct inode *inode, struct file *filp,
 		
         case NCP_IOC_SIGN_WANTED:
 		if ((file_permission(filp, MAY_READ) != 0)
-		    && (current->uid != server->m.mounted_uid))
+		    && (current->act_as->uid != server->m.mounted_uid))
 		{
 			return -EACCES;
 		}
@@ -491,7 +491,7 @@ int ncp_ioctl(struct inode *inode, struct file *filp,
 			int newstate;
 
 			if ((file_permission(filp, MAY_WRITE) != 0)
-			    && (current->uid != server->m.mounted_uid))
+			    && (current->act_as->uid != server->m.mounted_uid))
 			{
 				return -EACCES;
 			}
@@ -512,7 +512,7 @@ int ncp_ioctl(struct inode *inode, struct file *filp,
 #ifdef CONFIG_NCPFS_IOCTL_LOCKING
 	case NCP_IOC_LOCKUNLOCK:
 		if ((file_permission(filp, MAY_WRITE) != 0)
-		    && (current->uid != server->m.mounted_uid))
+		    && (current->act_as->uid != server->m.mounted_uid))
 		{
 			return -EACCES;
 		}
@@ -585,7 +585,7 @@ outrel:
 
 #ifdef CONFIG_COMPAT
 	case NCP_IOC_GETOBJECTNAME_32:
-		if (current->uid != server->m.mounted_uid) {
+		if (current->act_as->uid != server->m.mounted_uid) {
 			return -EACCES;
 		}
 		{
@@ -610,7 +610,7 @@ outrel:
 		}
 #endif
 	case NCP_IOC_GETOBJECTNAME:
-		if (current->uid != server->m.mounted_uid) {
+		if (current->act_as->uid != server->m.mounted_uid) {
 			return -EACCES;
 		}
 		{
@@ -637,7 +637,7 @@ outrel:
 	case NCP_IOC_SETOBJECTNAME_32:
 #endif
 	case NCP_IOC_SETOBJECTNAME:
-		if (current->uid != server->m.mounted_uid) {
+		if (current->act_as->uid != server->m.mounted_uid) {
 			return -EACCES;
 		}
 		{
@@ -695,7 +695,7 @@ outrel:
 	case NCP_IOC_GETPRIVATEDATA_32:
 #endif
 	case NCP_IOC_GETPRIVATEDATA:
-		if (current->uid != server->m.mounted_uid) {
+		if (current->act_as->uid != server->m.mounted_uid) {
 			return -EACCES;
 		}
 		{
@@ -740,7 +740,7 @@ outrel:
 	case NCP_IOC_SETPRIVATEDATA_32:
 #endif
 	case NCP_IOC_SETPRIVATEDATA:
-		if (current->uid != server->m.mounted_uid) {
+		if (current->act_as->uid != server->m.mounted_uid) {
 			return -EACCES;
 		}
 		{
@@ -795,7 +795,7 @@ outrel:
 
 	case NCP_IOC_SETDENTRYTTL:
 		if ((file_permission(filp, MAY_WRITE) != 0) &&
-				 (current->uid != server->m.mounted_uid))
+		    current->act_as->uid != server->m.mounted_uid)
 			return -EACCES;
 		{
 			u_int32_t user;
diff --git a/fs/nfsd/auth.c b/fs/nfsd/auth.c
index d13403e..5586157 100644
--- a/fs/nfsd/auth.c
+++ b/fs/nfsd/auth.c
@@ -26,6 +26,7 @@ int nfsexp_flags(struct svc_rqst *rqstp, struct svc_export *exp)
 
 int nfsd_setuser(struct svc_rqst *rqstp, struct svc_export *exp)
 {
+	struct task_security *act_as = current->act_as;
 	struct svc_cred	cred = rqstp->rq_cred;
 	int i;
 	int flags = nfsexp_flags(rqstp, exp);
@@ -54,25 +55,26 @@ int nfsd_setuser(struct svc_rqst *rqstp, struct svc_export *exp)
 		get_group_info(cred.cr_group_info);
 
 	if (cred.cr_uid != (uid_t) -1)
-		current->fsuid = cred.cr_uid;
+		act_as->fsuid = cred.cr_uid;
 	else
-		current->fsuid = exp->ex_anon_uid;
+		act_as->fsuid = exp->ex_anon_uid;
 	if (cred.cr_gid != (gid_t) -1)
-		current->fsgid = cred.cr_gid;
+		act_as->fsgid = cred.cr_gid;
 	else
-		current->fsgid = exp->ex_anon_gid;
+		act_as->fsgid = exp->ex_anon_gid;
 
 	if (!cred.cr_group_info)
 		return -ENOMEM;
-	ret = set_current_groups(cred.cr_group_info);
+	ret = set_groups(act_as, cred.cr_group_info);
 	put_group_info(cred.cr_group_info);
 	if ((cred.cr_uid)) {
-		current->cap_effective =
-			cap_drop_nfsd_set(current->cap_effective);
+		act_as->cap_effective =
+			cap_drop_nfsd_set(act_as->cap_effective);
 	} else {
-		current->cap_effective =
-			cap_raise_nfsd_set(current->cap_effective,
-					   current->cap_permitted);
+		act_as->cap_effective =
+			cap_raise_nfsd_set(act_as->cap_effective,
+					   act_as->cap_permitted);
 	}
 	return ret;
 }
+
diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 1ff9062..afddc9b 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -56,17 +56,17 @@ static int rec_dir_init = 0;
 static void
 nfs4_save_user(uid_t *saveuid, gid_t *savegid)
 {
-	*saveuid = current->fsuid;
-	*savegid = current->fsgid;
-	current->fsuid = 0;
-	current->fsgid = 0;
+	*saveuid = current->act_as->fsuid;
+	*savegid = current->act_as->fsgid;
+	current->act_as->fsuid = 0;
+	current->act_as->fsgid = 0;
 }
 
 static void
 nfs4_reset_user(uid_t saveuid, gid_t savegid)
 {
-	current->fsuid = saveuid;
-	current->fsgid = savegid;
+	current->act_as->fsuid = saveuid;
+	current->act_as->fsgid = savegid;
 }
 
 static void
diff --git a/fs/open.c b/fs/open.c
index 5419853..2f93f85 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -428,12 +428,12 @@ asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
 	if (mode & ~S_IRWXO)	/* where's F_OK, X_OK, W_OK, R_OK? */
 		return -EINVAL;
 
-	old_fsuid = current->fsuid;
-	old_fsgid = current->fsgid;
-	old_cap = current->cap_effective;
+	old_fsuid = current->act_as->fsuid;
+	old_fsgid = current->act_as->fsgid;
+	old_cap = current->act_as->cap_effective;
 
-	current->fsuid = current->uid;
-	current->fsgid = current->gid;
+	current->act_as->fsuid = current->act_as->uid;
+	current->act_as->fsgid = current->act_as->gid;
 
 	/*
 	 * Clear the capabilities if we switch to a non-root user
@@ -443,10 +443,10 @@ asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
 	 * value below.  We should hold task_capabilities_lock,
 	 * but we cannot because user_path_walk can sleep.
 	 */
-	if (current->uid)
-		cap_clear(current->cap_effective);
+	if (current->act_as->uid)
+		cap_clear(current->act_as->cap_effective);
 	else
-		current->cap_effective = current->cap_permitted;
+		current->act_as->cap_effective = current->act_as->cap_permitted;
 
 	res = __user_walk_fd(dfd, filename, LOOKUP_FOLLOW|LOOKUP_ACCESS, &nd);
 	if (res)
@@ -464,9 +464,9 @@ asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
 out_path_release:
 	path_put(&nd.path);
 out:
-	current->fsuid = old_fsuid;
-	current->fsgid = old_fsgid;
-	current->cap_effective = old_cap;
+	current->act_as->fsuid = old_fsuid;
+	current->act_as->fsgid = old_fsgid;
+	current->act_as->cap_effective = old_cap;
 
 	return res;
 }
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 07d6c48..cf28291 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -181,8 +181,8 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 		task_tgid_nr_ns(p, ns),
 		pid_nr_ns(pid, ns),
 		ppid, tpid,
-		p->uid, p->euid, p->suid, p->fsuid,
-		p->gid, p->egid, p->sgid, p->fsgid);
+		p->sec->uid, p->sec->euid, p->sec->suid, p->sec->fsuid,
+		p->sec->gid, p->sec->egid, p->sec->sgid, p->sec->fsgid);
 
 	task_lock(p);
 	if (p->files)
@@ -193,7 +193,7 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 		fdt ? fdt->max_fds : 0);
 	rcu_read_unlock();
 
-	group_info = p->group_info;
+	group_info = p->sec->group_info;
 	get_group_info(group_info);
 	task_unlock(p);
 
@@ -262,7 +262,7 @@ static inline void task_sig(struct seq_file *m, struct task_struct *p)
 		blocked = p->blocked;
 		collect_sigign_sigcatch(p, &ignored, &caught);
 		num_threads = atomic_read(&p->signal->count);
-		qsize = atomic_read(&p->user->sigpending);
+		qsize = atomic_read(&p->sec->user->sigpending);
 		qlim = p->signal->rlim[RLIMIT_SIGPENDING].rlim_cur;
 		unlock_task_sighand(p, &flags);
 	}
@@ -294,9 +294,11 @@ static void render_cap_t(struct seq_file *m, const char *header,
 
 static inline void task_cap(struct seq_file *m, struct task_struct *p)
 {
-	render_cap_t(m, "CapInh:\t", &p->cap_inheritable);
-	render_cap_t(m, "CapPrm:\t", &p->cap_permitted);
-	render_cap_t(m, "CapEff:\t", &p->cap_effective);
+	struct task_security *sec = p->sec;
+
+	render_cap_t(m, "CapInh:\t", &sec->cap_inheritable);
+	render_cap_t(m, "CapPrm:\t", &sec->cap_permitted);
+	render_cap_t(m, "CapEff:\t", &sec->cap_effective);
 }
 
 static inline void task_context_switch_counts(struct seq_file *m,
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 88f8edf..245e855 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1271,8 +1271,8 @@ static struct inode *proc_pid_make_inode(struct super_block * sb, struct task_st
 	inode->i_uid = 0;
 	inode->i_gid = 0;
 	if (task_dumpable(task)) {
-		inode->i_uid = task->euid;
-		inode->i_gid = task->egid;
+		inode->i_uid = task->sec->euid;
+		inode->i_gid = task->sec->egid;
 	}
 	security_task_to_inode(task, inode);
 
@@ -1297,8 +1297,8 @@ static int pid_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat
 	if (task) {
 		if ((inode->i_mode == (S_IFDIR|S_IRUGO|S_IXUGO)) ||
 		    task_dumpable(task)) {
-			stat->uid = task->euid;
-			stat->gid = task->egid;
+			stat->uid = task->sec->euid;
+			stat->gid = task->sec->egid;
 		}
 	}
 	rcu_read_unlock();
@@ -1329,8 +1329,8 @@ static int pid_revalidate(struct dentry *dentry, struct nameidata *nd)
 	if (task) {
 		if ((inode->i_mode == (S_IFDIR|S_IRUGO|S_IXUGO)) ||
 		    task_dumpable(task)) {
-			inode->i_uid = task->euid;
-			inode->i_gid = task->egid;
+			inode->i_uid = task->sec->euid;
+			inode->i_gid = task->sec->egid;
 		} else {
 			inode->i_uid = 0;
 			inode->i_gid = 0;
@@ -1501,8 +1501,8 @@ static int tid_fd_revalidate(struct dentry *dentry, struct nameidata *nd)
 				rcu_read_unlock();
 				put_files_struct(files);
 				if (task_dumpable(task)) {
-					inode->i_uid = task->euid;
-					inode->i_gid = task->egid;
+					inode->i_uid = task->sec->euid;
+					inode->i_gid = task->sec->egid;
 				} else {
 					inode->i_uid = 0;
 					inode->i_gid = 0;
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 614c34b..73608c8 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -393,9 +393,9 @@ static int proc_sys_permission(struct inode *inode, int mask, struct nameidata *
 	error = -EACCES;
 	mode = inode->i_mode;
 
-	if (current->euid == 0)
+	if (current->act_as->euid == 0)
 		mode >>= 6;
-	else if (in_group_p(0))
+	else if (in_egroup_p(0))
 		mode >>= 3;
 
 	if ((mode & mask & (MAY_READ|MAY_WRITE|MAY_EXEC)) == mask)
diff --git a/fs/quota.c b/fs/quota.c
index 84f28dd..afde3cb 100644
--- a/fs/quota.c
+++ b/fs/quota.c
@@ -80,7 +80,7 @@ static int generic_quotactl_valid(struct super_block *sb, int type, int cmd, qid
 
 	/* Check privileges */
 	if (cmd == Q_GETQUOTA) {
-		if (((type == USRQUOTA && current->euid != id) ||
+		if (((type == USRQUOTA && current->act_as->euid != id) ||
 		     (type == GRPQUOTA && !in_egroup_p(id))) &&
 		    !capable(CAP_SYS_ADMIN))
 			return -EPERM;
@@ -131,7 +131,7 @@ static int xqm_quotactl_valid(struct super_block *sb, int type, int cmd, qid_t i
 
 	/* Check privileges */
 	if (cmd == Q_XGETQUOTA) {
-		if (((type == XQM_USRQUOTA && current->euid != id) ||
+		if (((type == XQM_USRQUOTA && current->act_as->euid != id) ||
 		     (type == XQM_GRPQUOTA && !in_egroup_p(id))) &&
 		     !capable(CAP_SYS_ADMIN))
 			return -EPERM;
diff --git a/fs/smbfs/dir.c b/fs/smbfs/dir.c
index 48da4fa..53e03a3 100644
--- a/fs/smbfs/dir.c
+++ b/fs/smbfs/dir.c
@@ -667,8 +667,8 @@ smb_make_node(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
 
 	attr.ia_valid = ATTR_MODE | ATTR_UID | ATTR_GID;
 	attr.ia_mode = mode;
-	attr.ia_uid = current->euid;
-	attr.ia_gid = current->egid;
+	attr.ia_uid = current->act_as->euid;
+	attr.ia_gid = current->act_as->egid;
 
 	if (!new_valid_dev(dev))
 		return -EINVAL;
diff --git a/fs/smbfs/inode.c b/fs/smbfs/inode.c
index 376ef3e..d61b88f 100644
--- a/fs/smbfs/inode.c
+++ b/fs/smbfs/inode.c
@@ -586,7 +586,7 @@ static int smb_fill_super(struct super_block *sb, void *raw_data, int silent)
 		if (parse_options(mnt, raw_data))
 			goto out_bad_option;
 	}
-	mnt->mounted_uid = current->uid;
+	mnt->mounted_uid = current->act_as->uid;
 	smb_setcodepage(server, &mnt->codepage);
 
 	/*
diff --git a/fs/smbfs/proc.c b/fs/smbfs/proc.c
index d517a27..a55d9cd 100644
--- a/fs/smbfs/proc.c
+++ b/fs/smbfs/proc.c
@@ -865,7 +865,7 @@ smb_newconn(struct smb_sb_info *server, struct smb_conn_opt *opt)
 		goto out;
 
 	error = -EACCES;
-	if (current->uid != server->mnt->mounted_uid && 
+	if (current->act_as->uid != server->mnt->mounted_uid &&
 	    !capable(CAP_SYS_ADMIN))
 		goto out;
 
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 1f74e1d..a26c30e 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -133,6 +133,21 @@ extern struct group_info init_groups;
 # define CAP_INIT_BSET  CAP_INIT_EFF_SET
 #endif
 
+extern struct task_security init_task_security;
+
+#define INIT_TASK_SECURITY(p)					\
+{								\
+	.usage			= ATOMIC_INIT(3),		\
+	.keep_capabilities	= 0,				\
+	.cap_inheritable	= CAP_INIT_INH_SET,		\
+	.cap_permitted		= CAP_FULL_SET,			\
+	.cap_effective		= CAP_INIT_EFF_SET,		\
+	.cap_bset		= CAP_INIT_BSET,		\
+	.user			= INIT_USER,			\
+	.group_info		= &init_groups,			\
+	.lock			= __SPIN_LOCK_UNLOCKED(p.lock),	\
+}
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -164,13 +179,9 @@ extern struct group_info init_groups;
 	.children	= LIST_HEAD_INIT(tsk.children),			\
 	.sibling	= LIST_HEAD_INIT(tsk.sibling),			\
 	.group_leader	= &tsk,						\
-	.group_info	= &init_groups,					\
-	.cap_effective	= CAP_INIT_EFF_SET,				\
-	.cap_inheritable = CAP_INIT_INH_SET,				\
-	.cap_permitted	= CAP_FULL_SET,					\
-	.cap_bset 	= CAP_INIT_BSET,				\
-	.keep_capabilities = 0,						\
-	.user		= INIT_USER,					\
+	.__temp_sec	= INIT_TASK_SECURITY(tsk.__temp_sec),		\
+	.sec		= &tsk.__temp_sec,				\
+	.act_as		= &tsk.__temp_sec,				\
 	.comm		= "swapper",					\
 	.thread		= INIT_THREAD,					\
 	.fs		= &init_fs,					\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 585471d..546ebec 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -606,6 +606,64 @@ extern struct user_struct *find_user(uid_t);
 extern struct user_struct root_user;
 #define INIT_USER (&root_user)
 
+
+/*
+ * The security context of a task
+ *
+ * The parts of the context break down into two categories:
+ *
+ *  (1) The objective context of a task.  These parts are used when some other
+ *	task is attempting to affect this one.
+ *
+ *  (2) The subjective context.  These details are used when the task is acting
+ *	upon another object, be that a file, a task, a key or whatever.
+ *
+ * Note that some members of this structure belong to both categories - the
+ * LSM security pointer for instance.
+ *
+ * A task has two security pointers.  task->sec points to the objective context
+ * that defines that task's actual details.  The objective part of this context
+ * is used whenever that task is acted upon.
+ *
+ * task->act_as points to the subjective context that defines the details of
+ * how that task is going to act upon another object.  This may be overridden
+ * temporarily to point to another security context, but normally points to the
+ * same context as task->sec.
+ */
+struct task_security {
+	atomic_t	usage;
+	uid_t		uid;		/* real UID of the task */
+	gid_t		gid;		/* real GID of the task */
+	uid_t		suid;		/* saved UID of the task */
+	gid_t		sgid;		/* saved GID of the task */
+	uid_t		euid;		/* effective UID of the task */
+	gid_t		egid;		/* effective GID of the task */
+	uid_t		fsuid;		/* UID for VFS ops */
+	gid_t		fsgid;		/* GID for VFS ops */
+	unsigned	keep_capabilities:1;
+	kernel_cap_t	cap_inheritable; /* caps our children can inherit */
+	kernel_cap_t	cap_permitted;	/* caps we're permitted */
+	kernel_cap_t	cap_effective;	/* caps we can actually use */
+	kernel_cap_t	cap_bset;	/* ? */
+#ifdef CONFIG_KEYS
+	unsigned char	jit_keyring;	/* default keyring to attach requested
+					 * keys to */
+	struct key	*thread_keyring; /* keyring private to this thread */
+	struct key	*request_key_auth; /* assumed request_key authority */
+#endif
+#ifdef CONFIG_SECURITY
+	void		*security;	/* subjective LSM security */
+#endif
+	struct user_struct *user;	/* real user ID subscription */
+	struct group_info *group_info;	/* supplementary groups for euid/fsgid */
+	spinlock_t	lock;		/* lock for pointer changes */
+};
+
+#define current_fsuid() (current->act_as->fsuid)
+#define current_fsgid() (current->act_as->fsgid)
+#define current_cap()	(current->act_as->cap_effective)
+
+
 struct backing_dev_info;
 struct reclaim_state;
 
@@ -838,6 +896,7 @@ struct group_info {
 extern struct group_info *groups_alloc(int gidsetsize);
 extern void groups_free(struct group_info *group_info);
 extern int set_current_groups(struct group_info *group_info);
+extern int set_groups(struct task_security *sec, struct group_info *group_info);
 extern int groups_search(struct group_info *group_info, gid_t grp);
 /* access the groups "array" with this macro */
 #define GROUP_AT(gi, i) \
@@ -1096,17 +1155,10 @@ struct task_struct {
 	struct list_head cpu_timers[3];
 
 /* process credentials */
-	uid_t uid,euid,suid,fsuid;
-	gid_t gid,egid,sgid,fsgid;
-	struct group_info *group_info;
-	kernel_cap_t   cap_effective, cap_inheritable, cap_permitted, cap_bset;
-	unsigned keep_capabilities:1;
-	struct user_struct *user;
-#ifdef CONFIG_KEYS
-	struct key *request_key_auth;	/* assumed request_key authority */
-	struct key *thread_keyring;	/* keyring private to this thread */
-	unsigned char jit_keyring;	/* default keyring to attach requested keys to */
-#endif
+	struct task_security __temp_sec __deprecated; /* temporary security to be removed */
+	struct task_security *sec;	/* actual/objective task security */
+	struct task_security *act_as;	/* effective/subjective task security */
+
 	char comm[TASK_COMM_LEN]; /* executable name excluding path
 				     - access with [gs]et_task_comm (which lock
 				       it with task_lock())
@@ -1143,9 +1195,6 @@ struct task_struct {
 	int (*notifier)(void *priv);
 	void *notifier_data;
 	sigset_t *notifier_mask;
-#ifdef CONFIG_SECURITY
-	void *security;
-#endif
 	struct audit_context *audit_context;
 #ifdef CONFIG_AUDITSYSCALL
 	uid_t loginuid;
@@ -1264,9 +1313,6 @@ struct task_struct {
 #endif
 };
 
-#define current_fsuid() (current->fsuid)
-#define current_fsgid() (current->fsgid)
-
 /*
  * Priority of a process goes from 0..MAX_PRIO-1, valid RT
  * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
diff --git a/include/net/scm.h b/include/net/scm.h
index 06df126..b133114 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -54,8 +54,8 @@ static __inline__ int scm_send(struct socket *sock, struct msghdr *msg,
 			       struct scm_cookie *scm)
 {
 	struct task_struct *p = current;
-	scm->creds.uid = p->uid;
-	scm->creds.gid = p->gid;
+	scm->creds.uid = p->sec->uid;
+	scm->creds.gid = p->sec->gid;
 	scm->creds.pid = task_tgid_vnr(p);
 	scm->fp = NULL;
 	scm->seq = 0;
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 0db0750..671c5bb 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -118,7 +118,7 @@ static struct inode *mqueue_get_inode(struct super_block *sb, int mode,
 		if (S_ISREG(mode)) {
 			struct mqueue_inode_info *info;
 			struct task_struct *p = current;
-			struct user_struct *u = p->user;
+			struct user_struct *u = p->sec->user;
 			unsigned long mq_bytes, mq_msg_tblsz;
 
 			inode->i_fop = &mqueue_file_operations;
@@ -510,7 +510,7 @@ static void __do_notify(struct mqueue_inode_info *info)
 			sig_i.si_code = SI_MESGQ;
 			sig_i.si_value = info->notify.sigev_value;
 			sig_i.si_pid = task_tgid_vnr(current);
-			sig_i.si_uid = current->uid;
+			sig_i.si_uid = current->act_as->uid;
 
 			kill_pid_info(info->notify.sigev_signo,
 				      &sig_i, info->notify_owner);
diff --git a/ipc/msg.c b/ipc/msg.c
index 46585a0..3ac3c31 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -529,8 +529,8 @@ asmlinkage long sys_msgctl(int msqid, int cmd, struct msqid_ds __user *buf)
 	}
 
 	err = -EPERM;
-	if (current->euid != ipcp->cuid &&
-	    current->euid != ipcp->uid && !capable(CAP_SYS_ADMIN))
+	if (current->act_as->euid != ipcp->cuid &&
+	    current->act_as->euid != ipcp->uid && !capable(CAP_SYS_ADMIN))
 		/* We _could_ check for CAP_CHOWN above, but we don't */
 		goto out_unlock_up;
 
diff --git a/ipc/sem.c b/ipc/sem.c
index 0b45a4d..b7865e8 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -897,8 +897,8 @@ static int semctl_down(struct ipc_namespace *ns, int semid, int semnum,
 		if (err)
 			goto out_unlock;
 	}
-	if (current->euid != ipcp->cuid && 
-	    current->euid != ipcp->uid && !capable(CAP_SYS_ADMIN)) {
+	if (current->act_as->euid != ipcp->cuid &&
+	    current->act_as->euid != ipcp->uid && !capable(CAP_SYS_ADMIN)) {
 	    	err=-EPERM;
 		goto out_unlock;
 	}
diff --git a/ipc/shm.c b/ipc/shm.c
index c47e872..80dcb27 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -401,7 +401,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 	if (shmflg & SHM_HUGETLB) {
 		/* hugetlb_file_setup takes care of mlock user accounting */
 		file = hugetlb_file_setup(name, size);
-		shp->mlock_user = current->user;
+		shp->mlock_user = current->sec->user;
 	} else {
 		int acctflag = VM_ACCOUNT;
 		/*
@@ -754,8 +754,8 @@ asmlinkage long sys_shmctl (int shmid, int cmd, struct shmid_ds __user *buf)
 
 		if (!capable(CAP_IPC_LOCK)) {
 			err = -EPERM;
-			if (current->euid != shp->shm_perm.uid &&
-			    current->euid != shp->shm_perm.cuid)
+			if (current->act_as->euid != shp->shm_perm.uid &&
+			    current->act_as->euid != shp->shm_perm.cuid)
 				goto out_unlock;
 			if (cmd == SHM_LOCK &&
 			    !current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur)
@@ -767,7 +767,7 @@ asmlinkage long sys_shmctl (int shmid, int cmd, struct shmid_ds __user *buf)
 			goto out_unlock;
 		
 		if(cmd==SHM_LOCK) {
-			struct user_struct * user = current->user;
+			struct user_struct *user = current->act_as->user;
 			if (!is_file_hugepages(shp->shm_file)) {
 				err = shmem_lock(shp->shm_file, 1, user);
 				if (!err && !(shp->shm_perm.mode & SHM_LOCKED)){
@@ -806,8 +806,8 @@ asmlinkage long sys_shmctl (int shmid, int cmd, struct shmid_ds __user *buf)
 		if (err)
 			goto out_unlock_up;
 
-		if (current->euid != shp->shm_perm.uid &&
-		    current->euid != shp->shm_perm.cuid && 
+		if (current->act_as->euid != shp->shm_perm.uid &&
+		    current->act_as->euid != shp->shm_perm.cuid &&
 		    !capable(CAP_SYS_ADMIN)) {
 			err=-EPERM;
 			goto out_unlock_up;
@@ -846,8 +846,8 @@ asmlinkage long sys_shmctl (int shmid, int cmd, struct shmid_ds __user *buf)
 		if (err)
 			goto out_unlock_up;
 		err=-EPERM;
-		if (current->euid != shp->shm_perm.uid &&
-		    current->euid != shp->shm_perm.cuid && 
+		if (current->act_as->euid != shp->shm_perm.uid &&
+		    current->act_as->euid != shp->shm_perm.cuid &&
 		    !capable(CAP_SYS_ADMIN)) {
 			goto out_unlock_up;
 		}
diff --git a/ipc/util.c b/ipc/util.c
index fd1b50d..529f2c7 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -224,8 +224,8 @@ int ipc_addid(struct ipc_ids* ids, struct kern_ipc_perm* new, int size)
 
 	ids->in_use++;
 
-	new->cuid = new->uid = current->euid;
-	new->gid = new->cgid = current->egid;
+	new->cuid = new->uid = current->act_as->euid;
+	new->gid = new->cgid = current->act_as->egid;
 
 	new->seq = ids->seq++;
 	if(ids->seq > ids->seq_max)
@@ -573,7 +573,8 @@ int ipcperms (struct kern_ipc_perm *ipcp, short flag)
 		return err;
 	requested_mode = (flag >> 6) | (flag >> 3) | flag;
 	granted_mode = ipcp->mode;
-	if (current->euid == ipcp->cuid || current->euid == ipcp->uid)
+	if (current->act_as->euid == ipcp->cuid ||
+	    current->act_as->euid == ipcp->uid)
 		granted_mode >>= 6;
 	else if (in_group_p(ipcp->cgid) || in_group_p(ipcp->gid))
 		granted_mode >>= 3;
diff --git a/kernel/acct.c b/kernel/acct.c
index 521dfa5..f2d1783 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -470,15 +470,15 @@ static void do_acct_process(struct file *file)
 	do_div(elapsed, AHZ);
 	ac.ac_btime = get_seconds() - elapsed;
 	/* we really need to bite the bullet and change layout */
-	ac.ac_uid = current->uid;
-	ac.ac_gid = current->gid;
+	ac.ac_uid = current->sec->uid;
+	ac.ac_gid = current->sec->gid;
 #if ACCT_VERSION==2
 	ac.ac_ahz = AHZ;
 #endif
 #if ACCT_VERSION==1 || ACCT_VERSION==2
 	/* backward-compatible 16 bit fields */
-	ac.ac_uid16 = current->uid;
-	ac.ac_gid16 = current->gid;
+	ac.ac_uid16 = current->sec->uid;
+	ac.ac_gid16 = current->sec->gid;
 #endif
 #if ACCT_VERSION==3
 	ac.ac_pid = current->tgid;
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 2087d6d..85157bf 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -404,6 +404,7 @@ static int audit_filter_rules(struct task_struct *tsk,
 			      struct audit_names *name,
 			      enum audit_state *state)
 {
+	struct task_security *sec = tsk->sec;
 	int i, j, need_sid = 1;
 	u32 sid;
 
@@ -423,28 +424,28 @@ static int audit_filter_rules(struct task_struct *tsk,
 			}
 			break;
 		case AUDIT_UID:
-			result = audit_comparator(tsk->uid, f->op, f->val);
+			result = audit_comparator(sec->uid, f->op, f->val);
 			break;
 		case AUDIT_EUID:
-			result = audit_comparator(tsk->euid, f->op, f->val);
+			result = audit_comparator(sec->euid, f->op, f->val);
 			break;
 		case AUDIT_SUID:
-			result = audit_comparator(tsk->suid, f->op, f->val);
+			result = audit_comparator(sec->suid, f->op, f->val);
 			break;
 		case AUDIT_FSUID:
-			result = audit_comparator(tsk->fsuid, f->op, f->val);
+			result = audit_comparator(sec->fsuid, f->op, f->val);
 			break;
 		case AUDIT_GID:
-			result = audit_comparator(tsk->gid, f->op, f->val);
+			result = audit_comparator(sec->gid, f->op, f->val);
 			break;
 		case AUDIT_EGID:
-			result = audit_comparator(tsk->egid, f->op, f->val);
+			result = audit_comparator(sec->egid, f->op, f->val);
 			break;
 		case AUDIT_SGID:
-			result = audit_comparator(tsk->sgid, f->op, f->val);
+			result = audit_comparator(sec->sgid, f->op, f->val);
 			break;
 		case AUDIT_FSGID:
-			result = audit_comparator(tsk->fsgid, f->op, f->val);
+			result = audit_comparator(sec->fsgid, f->op, f->val);
 			break;
 		case AUDIT_PERS:
 			result = audit_comparator(tsk->personality, f->op, f->val);
@@ -1152,6 +1153,7 @@ static void audit_log_execve_info(struct audit_context *context,
 
 static void audit_log_exit(struct audit_context *context, struct task_struct *tsk)
 {
+	struct task_security *sec = tsk->sec;
 	int i, call_panic = 0;
 	struct audit_buffer *ab;
 	struct audit_aux_data *aux;
@@ -1161,14 +1163,14 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 	context->pid = tsk->pid;
 	if (!context->ppid)
 		context->ppid = sys_getppid();
-	context->uid = tsk->uid;
-	context->gid = tsk->gid;
-	context->euid = tsk->euid;
-	context->suid = tsk->suid;
-	context->fsuid = tsk->fsuid;
-	context->egid = tsk->egid;
-	context->sgid = tsk->sgid;
-	context->fsgid = tsk->fsgid;
+	context->uid = sec->uid;
+	context->gid = sec->gid;
+	context->euid = sec->euid;
+	context->suid = sec->suid;
+	context->fsuid = sec->fsuid;
+	context->egid = sec->egid;
+	context->sgid = sec->sgid;
+	context->fsgid = sec->fsgid;
 	context->personality = tsk->personality;
 
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_SYSCALL);
@@ -1957,7 +1959,7 @@ int audit_set_loginuid(struct task_struct *task, uid_t loginuid)
 			audit_log_format(ab, "login pid=%d uid=%u "
 				"old auid=%u new auid=%u"
 				" old ses=%u new ses=%u",
-				task->pid, task->uid,
+				task->pid, task->sec->uid,
 				task->loginuid, loginuid,
 				task->sessionid, sessionid);
 			audit_log_end(ab);
@@ -2341,7 +2343,7 @@ void __audit_ptrace(struct task_struct *t)
 
 	context->target_pid = t->pid;
 	context->target_auid = audit_get_loginuid(t);
-	context->target_uid = t->uid;
+	context->target_uid = t->sec->uid;
 	context->target_sessionid = audit_get_sessionid(t);
 	selinux_get_task_sid(t, &context->target_sid);
 	memcpy(context->target_comm, t->comm, TASK_COMM_LEN);
@@ -2370,7 +2372,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
 			if (tsk->loginuid != -1)
 				audit_sig_uid = tsk->loginuid;
 			else
-				audit_sig_uid = tsk->uid;
+				audit_sig_uid = tsk->sec->uid;
 			selinux_get_task_sid(tsk, &audit_sig_sid);
 		}
 		if (!audit_signals || audit_dummy_context())
@@ -2382,7 +2384,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
 	if (!ctx->target_pid) {
 		ctx->target_pid = t->tgid;
 		ctx->target_auid = audit_get_loginuid(t);
-		ctx->target_uid = t->uid;
+		ctx->target_uid = t->sec->uid;
 		ctx->target_sessionid = audit_get_sessionid(t);
 		selinux_get_task_sid(t, &ctx->target_sid);
 		memcpy(ctx->target_comm, t->comm, TASK_COMM_LEN);
@@ -2403,7 +2405,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
 
 	axp->target_pid[axp->pid_count] = t->tgid;
 	axp->target_auid[axp->pid_count] = audit_get_loginuid(t);
-	axp->target_uid[axp->pid_count] = t->uid;
+	axp->target_uid[axp->pid_count] = t->sec->uid;
 	axp->target_sessionid[axp->pid_count] = audit_get_sessionid(t);
 	selinux_get_task_sid(t, &axp->target_sid[axp->pid_count]);
 	memcpy(axp->target_comm[axp->pid_count], t->comm, TASK_COMM_LEN);
@@ -2434,7 +2436,7 @@ void audit_core_dumps(long signr)
 
 	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_ANOM_ABEND);
 	audit_log_format(ab, "auid=%u uid=%u gid=%u ses=%u",
-			auid, current->uid, current->gid, sessionid);
+			auid, current->sec->uid, current->sec->gid, sessionid);
 	selinux_get_task_sid(current, &sid);
 	if (sid) {
 		char *ctx = NULL;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 87c5f1e..681de68 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1277,8 +1277,9 @@ static int attach_task_by_pid(struct cgroup *cgrp, char *pidbuf)
 		get_task_struct(tsk);
 		rcu_read_unlock();
 
-		if ((current->euid) && (current->euid != tsk->uid)
-		    && (current->euid != tsk->suid)) {
+		if (current->act_as->euid &&
+		    current->act_as->euid != tsk->sec->uid &&
+		    current->act_as->euid != tsk->sec->suid) {
 			put_task_struct(tsk);
 			return -EACCES;
 		}
diff --git a/kernel/exit.c b/kernel/exit.c
index 506a957..121a759 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -145,7 +145,7 @@ void release_task(struct task_struct * p)
 	struct task_struct *leader;
 	int zap_leader;
 repeat:
-	atomic_dec(&p->user->processes);
+	atomic_dec(&p->sec->user->processes);
 	proc_flush_task(p);
 	write_lock_irq(&tasklist_lock);
 	ptrace_unlink(p);
@@ -1173,7 +1173,7 @@ static int wait_task_zombie(struct task_struct *p, int noreap,
 	pid_t pid = task_pid_vnr(p);
 
 	if (unlikely(noreap)) {
-		uid_t uid = p->uid;
+		uid_t uid = p->sec->uid;
 		int exit_code = p->exit_code;
 		int why, status;
 
@@ -1289,7 +1289,7 @@ static int wait_task_zombie(struct task_struct *p, int noreap,
 	if (!retval && infop)
 		retval = put_user(pid, &infop->si_pid);
 	if (!retval && infop)
-		retval = put_user(p->uid, &infop->si_uid);
+		retval = put_user(p->sec->uid, &infop->si_uid);
 	if (!retval)
 		retval = pid;
 
@@ -1351,7 +1351,7 @@ static int wait_task_stopped(struct task_struct *p,
 	if (!noreap)
 		p->exit_code = 0;
 
-	uid = p->uid;
+	uid = p->sec->uid;
 unlock_sig:
 	spin_unlock_irq(&p->sighand->siglock);
 	if (!exit_code)
@@ -1425,7 +1425,7 @@ static int wait_task_continued(struct task_struct *p, int noreap,
 	spin_unlock_irq(&p->sighand->siglock);
 
 	pid = task_pid_vnr(p);
-	uid = p->uid;
+	uid = p->sec->uid;
 	get_task_struct(p);
 	read_unlock(&tasklist_lock);
 
diff --git a/kernel/fork.c b/kernel/fork.c
index dd249c3..2125868 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -124,8 +124,8 @@ void __put_task_struct(struct task_struct *tsk)
 	WARN_ON(tsk == current);
 
 	security_task_free(tsk);
-	free_uid(tsk->user);
-	put_group_info(tsk->group_info);
+	free_uid(tsk->__temp_sec.user);
+	put_group_info(tsk->__temp_sec.group_info);
 	delayacct_tsk_free(tsk);
 
 	if (!profile_handoff_task(tsk))
@@ -1045,17 +1045,18 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled);
 	DEBUG_LOCKS_WARN_ON(!p->softirqs_enabled);
 #endif
+	p->act_as = p->sec = &p->__temp_sec;
 	retval = -EAGAIN;
-	if (atomic_read(&p->user->processes) >=
+	if (atomic_read(&p->sec->user->processes) >=
 			p->signal->rlim[RLIMIT_NPROC].rlim_cur) {
 		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RESOURCE) &&
-		    p->user != current->nsproxy->user_ns->root_user)
+		    p->sec->user != current->nsproxy->user_ns->root_user)
 			goto bad_fork_free;
 	}
 
-	atomic_inc(&p->user->__count);
-	atomic_inc(&p->user->processes);
-	get_group_info(p->group_info);
+	atomic_inc(&p->sec->user->__count);
+	atomic_inc(&p->sec->user->processes);
+	get_group_info(p->sec->group_info);
 
 	/*
 	 * If multiple threads are within copy_process(), then this check
@@ -1120,9 +1121,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->real_start_time = p->start_time;
 	monotonic_to_bootbased(&p->real_start_time);
 #ifdef CONFIG_SECURITY
-	p->security = NULL;
+	p->sec->security = NULL;
 #endif
-	p->cap_bset = current->cap_bset;
 	p->io_context = NULL;
 	p->audit_context = NULL;
 	cgroup_fork(p);
@@ -1395,9 +1395,9 @@ bad_fork_cleanup_cgroup:
 bad_fork_cleanup_put_domain:
 	module_put(task_thread_info(p)->exec_domain->module);
 bad_fork_cleanup_count:
-	put_group_info(p->group_info);
-	atomic_dec(&p->user->processes);
-	free_uid(p->user);
+	put_group_info(p->sec->group_info);
+	atomic_dec(&p->sec->user->processes);
+	free_uid(p->sec->user);
 bad_fork_free:
 	free_task(p);
 fork_out:
diff --git a/kernel/futex.c b/kernel/futex.c
index 221f212..98c271f 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -447,7 +447,8 @@ static struct task_struct * futex_find_get_task(pid_t pid)
 
 	rcu_read_lock();
 	p = find_task_by_vpid(pid);
-	if (!p || ((current->euid != p->euid) && (current->euid != p->uid)))
+	if (!p || (current->act_as->euid != p->sec->euid &&
+		   current->act_as->euid != p->sec->uid))
 		p = ERR_PTR(-ESRCH);
 	else
 		get_task_struct(p);
@@ -1905,8 +1906,9 @@ sys_get_robust_list(int pid, struct robust_list_head __user * __user *head_ptr,
 		if (!p)
 			goto err_unlock;
 		ret = -EPERM;
-		if ((current->euid != p->euid) && (current->euid != p->uid) &&
-				!capable(CAP_SYS_PTRACE))
+		if (current->act_as->euid != p->sec->euid &&
+		    current->act_as->euid != p->sec->uid &&
+		    !capable(CAP_SYS_PTRACE))
 			goto err_unlock;
 		head = p->robust_list;
 		rcu_read_unlock();
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index 7d5e4b0..53cb98e 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -141,8 +141,9 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 		if (!p)
 			goto err_unlock;
 		ret = -EPERM;
-		if ((current->euid != p->euid) && (current->euid != p->uid) &&
-				!capable(CAP_SYS_PTRACE))
+		if (current->act_as->euid != p->sec->euid &&
+		    current->act_as->euid != p->sec->uid &&
+		    !capable(CAP_SYS_PTRACE))
 			goto err_unlock;
 		head = p->compat_robust_list;
 		read_unlock(&tasklist_lock);
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index fdb34e8..28035ec 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -123,6 +123,8 @@ int ptrace_check_attach(struct task_struct *child, int kill)
 
 int __ptrace_may_attach(struct task_struct *task)
 {
+	struct task_security *sec = current->act_as, *tsec = task->sec;
+
 	/* May we inspect the given task?
 	 * This check is used both for attaching with ptrace
 	 * and for allowing access to sensitive information in /proc.
@@ -135,12 +137,12 @@ int __ptrace_may_attach(struct task_struct *task)
 	/* Don't let security modules deny introspection */
 	if (task == current)
 		return 0;
-	if (((current->uid != task->euid) ||
-	     (current->uid != task->suid) ||
-	     (current->uid != task->uid) ||
-	     (current->gid != task->egid) ||
-	     (current->gid != task->sgid) ||
-	     (current->gid != task->gid)) && !capable(CAP_SYS_PTRACE))
+	if (((sec->uid != tsec->euid) ||
+	     (sec->uid != tsec->suid) ||
+	     (sec->uid != tsec->uid) ||
+	     (sec->gid != tsec->egid) ||
+	     (sec->gid != tsec->sgid) ||
+	     (sec->gid != tsec->gid)) && !capable(CAP_SYS_PTRACE))
 		return -EPERM;
 	smp_rmb();
 	if (task->mm)
diff --git a/kernel/sched.c b/kernel/sched.c
index f28f19e..4e3c417 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -290,7 +290,7 @@ static inline struct task_group *task_group(struct task_struct *p)
 	struct task_group *tg;
 
 #ifdef CONFIG_USER_SCHED
-	tg = p->user->tg;
+	tg = p->sec->user->tg;
 #elif defined(CONFIG_CGROUP_SCHED)
 	tg = container_of(task_subsys_state(p, cpu_cgroup_subsys_id),
 				struct task_group, css);
@@ -4579,8 +4579,8 @@ recheck:
 			return -EPERM;
 
 		/* can't change other user's priorities */
-		if ((current->euid != p->euid) &&
-		    (current->euid != p->uid))
+		if ((current->act_as->euid != p->sec->euid) &&
+		    (current->act_as->euid != p->sec->uid))
 			return -EPERM;
 	}
 
@@ -4778,8 +4778,9 @@ long sched_setaffinity(pid_t pid, cpumask_t new_mask)
 	read_unlock(&tasklist_lock);
 
 	retval = -EPERM;
-	if ((current->euid != p->euid) && (current->euid != p->uid) &&
-			!capable(CAP_SYS_NICE))
+	if ((current->act_as->euid != p->sec->euid) &&
+	    (current->act_as->euid != p->sec->uid) &&
+	    !capable(CAP_SYS_NICE))
 		goto out_unlock;
 
 	retval = security_task_setscheduler(p, 0, NULL);
diff --git a/kernel/signal.c b/kernel/signal.c
index 84917fe..e30ad25 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -174,7 +174,7 @@ static struct sigqueue *__sigqueue_alloc(struct task_struct *t, gfp_t flags,
 	 * In order to avoid problems with "switch_user()", we want to make
 	 * sure that the compiler doesn't re-load "t->user"
 	 */
-	user = t->user;
+	user = t->sec->user;
 	barrier();
 	atomic_inc(&user->sigpending);
 	if (override_rlimit ||
@@ -537,8 +537,10 @@ static int check_kill_permission(int sig, struct siginfo *info,
 		error = -EPERM;
 		if (((sig != SIGCONT) ||
 			(task_session_nr(current) != task_session_nr(t)))
-		    && (current->euid ^ t->suid) && (current->euid ^ t->uid)
-		    && (current->uid ^ t->suid) && (current->uid ^ t->uid)
+		    && (current->act_as->euid ^ t->sec->suid)
+		    && (current->act_as->euid ^ t->sec->uid)
+		    && (current->act_as->uid ^ t->sec->suid)
+		    && (current->act_as->uid ^ t->sec->uid)
 		    && !capable(CAP_KILL))
 		return error;
 	}
@@ -695,7 +697,7 @@ static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			q->info.si_errno = 0;
 			q->info.si_code = SI_USER;
 			q->info.si_pid = task_pid_vnr(current);
-			q->info.si_uid = current->uid;
+			q->info.si_uid = current->act_as->uid;
 			break;
 		case (unsigned long) SEND_SIG_PRIV:
 			q->info.si_signo = sig;
@@ -1093,8 +1095,8 @@ int kill_pid_info_as_uid(int sig, struct siginfo *info, struct pid *pid,
 		goto out_unlock;
 	}
 	if ((info == SEND_SIG_NOINFO || (!is_si_special(info) && SI_FROMUSER(info)))
-	    && (euid != p->suid) && (euid != p->uid)
-	    && (uid != p->suid) && (uid != p->uid)) {
+	    && (euid != p->sec->suid) && (euid != p->sec->uid)
+	    && (uid != p->sec->suid) && (uid != p->sec->uid)) {
 		ret = -EPERM;
 		goto out_unlock;
 	}
@@ -1442,7 +1444,7 @@ void do_notify_parent(struct task_struct *tsk, int sig)
 	info.si_pid = task_pid_nr_ns(tsk, tsk->parent->nsproxy->pid_ns);
 	rcu_read_unlock();
 
-	info.si_uid = tsk->uid;
+	info.si_uid = tsk->sec->uid;
 
 	/* FIXME: find out whether or not this is supposed to be c*time. */
 	info.si_utime = cputime_to_jiffies(cputime_add(tsk->utime,
@@ -1513,7 +1515,7 @@ static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
 	info.si_pid = task_pid_nr_ns(tsk, tsk->parent->nsproxy->pid_ns);
 	rcu_read_unlock();
 
-	info.si_uid = tsk->uid;
+	info.si_uid = tsk->sec->uid;
 
 	/* FIXME: find out whether or not this is supposed to be c*time. */
 	info.si_utime = cputime_to_jiffies(tsk->utime);
@@ -1666,7 +1668,7 @@ void ptrace_notify(int exit_code)
 	info.si_signo = SIGTRAP;
 	info.si_code = exit_code;
 	info.si_pid = task_pid_vnr(current);
-	info.si_uid = current->uid;
+	info.si_uid = current->sec->uid;
 
 	/* Let the debugger run.  */
 	spin_lock_irq(&current->sighand->siglock);
@@ -1795,7 +1797,7 @@ relock:
 				info->si_errno = 0;
 				info->si_code = SI_USER;
 				info->si_pid = task_pid_vnr(current->parent);
-				info->si_uid = current->parent->uid;
+				info->si_uid = current->parent->sec->uid;
 			}
 
 			/* If the (new) signal is now blocked, requeue it.  */
@@ -2224,7 +2226,7 @@ sys_kill(int pid, int sig)
 	info.si_errno = 0;
 	info.si_code = SI_USER;
 	info.si_pid = task_tgid_vnr(current);
-	info.si_uid = current->uid;
+	info.si_uid = current->act_as->uid;
 
 	return kill_something_info(sig, &info, pid);
 }
@@ -2240,7 +2242,7 @@ static int do_tkill(int tgid, int pid, int sig)
 	info.si_errno = 0;
 	info.si_code = SI_TKILL;
 	info.si_pid = task_tgid_vnr(current);
-	info.si_uid = current->uid;
+	info.si_uid = current->act_as->uid;
 
 	read_lock(&tasklist_lock);
 	p = find_task_by_vpid(pid);
diff --git a/kernel/sys.c b/kernel/sys.c
index a626116..e8383ee 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -110,8 +110,8 @@ static int set_one_prio(struct task_struct *p, int niceval, int error)
 {
 	int no_nice;
 
-	if (p->uid != current->euid &&
-		p->euid != current->euid && !capable(CAP_SYS_NICE)) {
+	if (p->sec->uid != current->act_as->euid &&
+	    p->sec->euid != current->act_as->euid && !capable(CAP_SYS_NICE)) {
 		error = -EPERM;
 		goto out;
 	}
@@ -168,18 +168,19 @@ asmlinkage long sys_setpriority(int which, int who, int niceval)
 			} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
 			break;
 		case PRIO_USER:
-			user = current->user;
+			user = current->sec->user;
 			if (!who)
-				who = current->uid;
+				who = current->sec->uid;
 			else
-				if ((who != current->uid) && !(user = find_user(who)))
+				if ((who != current->sec->uid) &&
+				    !(user = find_user(who)))
 					goto out_unlock;	/* No processes for this user */
 
 			do_each_thread(g, p)
-				if (p->uid == who)
+				if (p->sec->uid == who)
 					error = set_one_prio(p, niceval, error);
 			while_each_thread(g, p);
-			if (who != current->uid)
+			if (who != current->sec->uid)
 				free_uid(user);		/* For find_user() */
 			break;
 	}
@@ -230,21 +231,22 @@ asmlinkage long sys_getpriority(int which, int who)
 			} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
 			break;
 		case PRIO_USER:
-			user = current->user;
+			user = current->sec->user;
 			if (!who)
-				who = current->uid;
+				who = current->sec->uid;
 			else
-				if ((who != current->uid) && !(user = find_user(who)))
+				if ((who != current->sec->uid) &&
+				    !(user = find_user(who)))
 					goto out_unlock;	/* No processes for this user */
 
 			do_each_thread(g, p)
-				if (p->uid == who) {
+				if (p->sec->uid == who) {
 					niceval = 20 - task_nice(p);
 					if (niceval > retval)
 						retval = niceval;
 				}
 			while_each_thread(g, p);
-			if (who != current->uid)
+			if (who != current->sec->uid)
 				free_uid(user);		/* for find_user() */
 			break;
 	}
@@ -481,8 +483,9 @@ void ctrl_alt_del(void)
  */
 asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
 {
-	int old_rgid = current->gid;
-	int old_egid = current->egid;
+	struct task_security *sec = current->sec;
+	int old_rgid = sec->gid;
+	int old_egid = sec->egid;
 	int new_rgid = old_rgid;
 	int new_egid = old_egid;
 	int retval;
@@ -493,7 +496,7 @@ asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
 
 	if (rgid != (gid_t) -1) {
 		if ((old_rgid == rgid) ||
-		    (current->egid==rgid) ||
+		    (sec->egid == rgid) ||
 		    capable(CAP_SETGID))
 			new_rgid = rgid;
 		else
@@ -501,8 +504,8 @@ asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
 	}
 	if (egid != (gid_t) -1) {
 		if ((old_rgid == egid) ||
-		    (current->egid == egid) ||
-		    (current->sgid == egid) ||
+		    (sec->egid == egid) ||
+		    (sec->sgid == egid) ||
 		    capable(CAP_SETGID))
 			new_egid = egid;
 		else
@@ -514,10 +517,10 @@ asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
 	}
 	if (rgid != (gid_t) -1 ||
 	    (egid != (gid_t) -1 && egid != old_rgid))
-		current->sgid = new_egid;
-	current->fsgid = new_egid;
-	current->egid = new_egid;
-	current->gid = new_rgid;
+		sec->sgid = new_egid;
+	sec->fsgid = new_egid;
+	sec->egid = new_egid;
+	sec->gid = new_rgid;
 	key_fsgid_changed(current);
 	proc_id_connector(current, PROC_EVENT_GID);
 	return 0;
@@ -530,7 +533,8 @@ asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
  */
 asmlinkage long sys_setgid(gid_t gid)
 {
-	int old_egid = current->egid;
+	struct task_security *sec = current->sec;
+	int old_egid = sec->egid;
 	int retval;
 
 	retval = security_task_setgid(gid, (gid_t)-1, (gid_t)-1, LSM_SETID_ID);
@@ -542,13 +546,13 @@ asmlinkage long sys_setgid(gid_t gid)
 			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
-		current->gid = current->egid = current->sgid = current->fsgid = gid;
-	} else if ((gid == current->gid) || (gid == current->sgid)) {
+		sec->gid = sec->egid = sec->sgid = sec->fsgid = gid;
+	} else if ((gid == sec->gid) || (gid == sec->sgid)) {
 		if (old_egid != gid) {
 			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
-		current->egid = current->fsgid = gid;
+		sec->egid = sec->fsgid = gid;
 	}
 	else
 		return -EPERM;
@@ -579,7 +583,7 @@ static int set_user(uid_t new_ruid, int dumpclear)
 		set_dumpable(current->mm, suid_dumpable);
 		smp_wmb();
 	}
-	current->uid = new_ruid;
+	current->sec->uid = new_ruid;
 	return 0;
 }
 
@@ -600,6 +604,7 @@ static int set_user(uid_t new_ruid, int dumpclear)
  */
 asmlinkage long sys_setreuid(uid_t ruid, uid_t euid)
 {
+	struct task_security *sec = current->sec;
 	int old_ruid, old_euid, old_suid, new_ruid, new_euid;
 	int retval;
 
@@ -607,14 +612,14 @@ asmlinkage long sys_setreuid(uid_t ruid, uid_t euid)
 	if (retval)
 		return retval;
 
-	new_ruid = old_ruid = current->uid;
-	new_euid = old_euid = current->euid;
-	old_suid = current->suid;
+	new_ruid = old_ruid = sec->uid;
+	new_euid = old_euid = sec->euid;
+	old_suid = sec->suid;
 
 	if (ruid != (uid_t) -1) {
 		new_ruid = ruid;
 		if ((old_ruid != ruid) &&
-		    (current->euid != ruid) &&
+		    (sec->euid != ruid) &&
 		    !capable(CAP_SETUID))
 			return -EPERM;
 	}
@@ -622,8 +627,8 @@ asmlinkage long sys_setreuid(uid_t ruid, uid_t euid)
 	if (euid != (uid_t) -1) {
 		new_euid = euid;
 		if ((old_ruid != euid) &&
-		    (current->euid != euid) &&
-		    (current->suid != euid) &&
+		    (sec->euid != euid) &&
+		    (sec->suid != euid) &&
 		    !capable(CAP_SETUID))
 			return -EPERM;
 	}
@@ -635,11 +640,11 @@ asmlinkage long sys_setreuid(uid_t ruid, uid_t euid)
 		set_dumpable(current->mm, suid_dumpable);
 		smp_wmb();
 	}
-	current->fsuid = current->euid = new_euid;
+	sec->fsuid = sec->euid = new_euid;
 	if (ruid != (uid_t) -1 ||
 	    (euid != (uid_t) -1 && euid != old_ruid))
-		current->suid = current->euid;
-	current->fsuid = current->euid;
+		sec->suid = sec->euid;
+	sec->fsuid = sec->euid;
 
 	key_fsuid_changed(current);
 	proc_id_connector(current, PROC_EVENT_UID);
@@ -662,7 +667,8 @@ asmlinkage long sys_setreuid(uid_t ruid, uid_t euid)
  */
 asmlinkage long sys_setuid(uid_t uid)
 {
-	int old_euid = current->euid;
+	struct task_security *sec = current->sec;
+	int old_euid = sec->euid;
 	int old_ruid, old_suid, new_suid;
 	int retval;
 
@@ -670,23 +676,23 @@ asmlinkage long sys_setuid(uid_t uid)
 	if (retval)
 		return retval;
 
-	old_ruid = current->uid;
-	old_suid = current->suid;
+	old_ruid = sec->uid;
+	old_suid = sec->suid;
 	new_suid = old_suid;
 	
 	if (capable(CAP_SETUID)) {
 		if (uid != old_ruid && set_user(uid, old_euid != uid) < 0)
 			return -EAGAIN;
 		new_suid = uid;
-	} else if ((uid != current->uid) && (uid != new_suid))
+	} else if ((uid != sec->uid) && (uid != new_suid))
 		return -EPERM;
 
 	if (old_euid != uid) {
 		set_dumpable(current->mm, suid_dumpable);
 		smp_wmb();
 	}
-	current->fsuid = current->euid = uid;
-	current->suid = new_suid;
+	sec->fsuid = sec->euid = uid;
+	sec->suid = new_suid;
 
 	key_fsuid_changed(current);
 	proc_id_connector(current, PROC_EVENT_UID);
@@ -701,9 +707,10 @@ asmlinkage long sys_setuid(uid_t uid)
  */
 asmlinkage long sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 {
-	int old_ruid = current->uid;
-	int old_euid = current->euid;
-	int old_suid = current->suid;
+	struct task_security *sec = current->sec;
+	int old_ruid = sec->uid;
+	int old_euid = sec->euid;
+	int old_suid = sec->suid;
 	int retval;
 
 	retval = security_task_setuid(ruid, euid, suid, LSM_SETID_RES);
@@ -711,30 +718,31 @@ asmlinkage long sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 		return retval;
 
 	if (!capable(CAP_SETUID)) {
-		if ((ruid != (uid_t) -1) && (ruid != current->uid) &&
-		    (ruid != current->euid) && (ruid != current->suid))
+		if ((ruid != (uid_t) -1) && (ruid != sec->uid) &&
+		    (ruid != sec->euid) && (ruid != sec->suid))
 			return -EPERM;
-		if ((euid != (uid_t) -1) && (euid != current->uid) &&
-		    (euid != current->euid) && (euid != current->suid))
+		if ((euid != (uid_t) -1) && (euid != sec->uid) &&
+		    (euid != sec->euid) && (euid != sec->suid))
 			return -EPERM;
-		if ((suid != (uid_t) -1) && (suid != current->uid) &&
-		    (suid != current->euid) && (suid != current->suid))
+		if ((suid != (uid_t) -1) && (suid != sec->uid) &&
+		    (suid != sec->euid) && (suid != sec->suid))
 			return -EPERM;
 	}
 	if (ruid != (uid_t) -1) {
-		if (ruid != current->uid && set_user(ruid, euid != current->euid) < 0)
+		if (ruid != sec->uid &&
+		    set_user(ruid, euid != sec->euid) < 0)
 			return -EAGAIN;
 	}
 	if (euid != (uid_t) -1) {
-		if (euid != current->euid) {
+		if (euid != sec->euid) {
 			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
-		current->euid = euid;
+		sec->euid = euid;
 	}
-	current->fsuid = current->euid;
+	sec->fsuid = sec->euid;
 	if (suid != (uid_t) -1)
-		current->suid = suid;
+		sec->suid = suid;
 
 	key_fsuid_changed(current);
 	proc_id_connector(current, PROC_EVENT_UID);
@@ -744,11 +752,12 @@ asmlinkage long sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 
 asmlinkage long sys_getresuid(uid_t __user *ruid, uid_t __user *euid, uid_t __user *suid)
 {
+	struct task_security *sec = current->sec;
 	int retval;
 
-	if (!(retval = put_user(current->uid, ruid)) &&
-	    !(retval = put_user(current->euid, euid)))
-		retval = put_user(current->suid, suid);
+	if (!(retval = put_user(sec->uid, ruid)) &&
+	    !(retval = put_user(sec->euid, euid)))
+		retval = put_user(sec->suid, suid);
 
 	return retval;
 }
@@ -758,6 +767,7 @@ asmlinkage long sys_getresuid(uid_t __user *ruid, uid_t __user *euid, uid_t __us
  */
 asmlinkage long sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 {
+	struct task_security *sec = current->sec;
 	int retval;
 
 	retval = security_task_setgid(rgid, egid, sgid, LSM_SETID_RES);
@@ -765,28 +775,28 @@ asmlinkage long sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 		return retval;
 
 	if (!capable(CAP_SETGID)) {
-		if ((rgid != (gid_t) -1) && (rgid != current->gid) &&
-		    (rgid != current->egid) && (rgid != current->sgid))
+		if ((rgid != (gid_t) -1) && (rgid != sec->gid) &&
+		    (rgid != sec->egid) && (rgid != sec->sgid))
 			return -EPERM;
-		if ((egid != (gid_t) -1) && (egid != current->gid) &&
-		    (egid != current->egid) && (egid != current->sgid))
+		if ((egid != (gid_t) -1) && (egid != sec->gid) &&
+		    (egid != sec->egid) && (egid != sec->sgid))
 			return -EPERM;
-		if ((sgid != (gid_t) -1) && (sgid != current->gid) &&
-		    (sgid != current->egid) && (sgid != current->sgid))
+		if ((sgid != (gid_t) -1) && (sgid != sec->gid) &&
+		    (sgid != sec->egid) && (sgid != sec->sgid))
 			return -EPERM;
 	}
 	if (egid != (gid_t) -1) {
-		if (egid != current->egid) {
+		if (egid != sec->egid) {
 			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
-		current->egid = egid;
+		sec->egid = egid;
 	}
-	current->fsgid = current->egid;
+	sec->fsgid = sec->egid;
 	if (rgid != (gid_t) -1)
-		current->gid = rgid;
+		sec->gid = rgid;
 	if (sgid != (gid_t) -1)
-		current->sgid = sgid;
+		sec->sgid = sgid;
 
 	key_fsgid_changed(current);
 	proc_id_connector(current, PROC_EVENT_GID);
@@ -795,11 +805,12 @@ asmlinkage long sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 
 asmlinkage long sys_getresgid(gid_t __user *rgid, gid_t __user *egid, gid_t __user *sgid)
 {
+	struct task_security *sec = current->sec;
 	int retval;
 
-	if (!(retval = put_user(current->gid, rgid)) &&
-	    !(retval = put_user(current->egid, egid)))
-		retval = put_user(current->sgid, sgid);
+	if (!(retval = put_user(sec->gid, rgid)) &&
+	    !(retval = put_user(sec->egid, egid)))
+		retval = put_user(sec->sgid, sgid);
 
 	return retval;
 }
@@ -813,20 +824,21 @@ asmlinkage long sys_getresgid(gid_t __user *rgid, gid_t __user *egid, gid_t __us
  */
 asmlinkage long sys_setfsuid(uid_t uid)
 {
+	struct task_security *sec = current->sec;
 	int old_fsuid;
 
-	old_fsuid = current->fsuid;
+	old_fsuid = sec->fsuid;
 	if (security_task_setuid(uid, (uid_t)-1, (uid_t)-1, LSM_SETID_FS))
 		return old_fsuid;
 
-	if (uid == current->uid || uid == current->euid ||
-	    uid == current->suid || uid == current->fsuid || 
+	if (uid == sec->uid || uid == sec->euid ||
+	    uid == sec->suid || uid == sec->fsuid ||
 	    capable(CAP_SETUID)) {
 		if (uid != old_fsuid) {
 			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
-		current->fsuid = uid;
+		sec->fsuid = uid;
 	}
 
 	key_fsuid_changed(current);
@@ -842,20 +854,21 @@ asmlinkage long sys_setfsuid(uid_t uid)
  */
 asmlinkage long sys_setfsgid(gid_t gid)
 {
+	struct task_security *sec = current->sec;
 	int old_fsgid;
 
-	old_fsgid = current->fsgid;
+	old_fsgid = sec->fsgid;
 	if (security_task_setgid(gid, (gid_t)-1, (gid_t)-1, LSM_SETID_FS))
 		return old_fsgid;
 
-	if (gid == current->gid || gid == current->egid ||
-	    gid == current->sgid || gid == current->fsgid || 
+	if (gid == sec->gid || gid == sec->egid ||
+	    gid == sec->sgid || gid == sec->fsgid ||
 	    capable(CAP_SETGID)) {
 		if (gid != old_fsgid) {
 			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
-		current->fsgid = gid;
+		sec->fsgid = gid;
 		key_fsgid_changed(current);
 		proc_id_connector(current, PROC_EVENT_GID);
 	}
@@ -1217,8 +1230,15 @@ int groups_search(struct group_info *group_info, gid_t grp)
 	return 0;
 }
 
-/* validate and set current->group_info */
-int set_current_groups(struct group_info *group_info)
+/**
+ * set_groups - Change a group subscription in a security record
+ * @sec: The security record to alter
+ * @group_info: The group list to impose
+ *
+ * Validate a group subscription and, if valid, impose it upon a task security
+ * record.
+ */
+int set_groups(struct task_security *sec, struct group_info *group_info)
 {
 	int retval;
 	struct group_info *old_info;
@@ -1230,20 +1250,34 @@ int set_current_groups(struct group_info *group_info)
 	groups_sort(group_info);
 	get_group_info(group_info);
 
-	task_lock(current);
-	old_info = current->group_info;
-	current->group_info = group_info;
-	task_unlock(current);
+	spin_lock(&sec->lock);
+	old_info = sec->group_info;
+	sec->group_info = group_info;
+	spin_unlock(&sec->lock);
 
 	put_group_info(old_info);
-
 	return 0;
 }
 
+EXPORT_SYMBOL(set_groups);
+
+/**
+ * set_current_groups - Change current's group subscription
+ * @group_info: The group list to impose
+ *
+ * Validate a group subscription and, if valid, impose it upon current's task
+ * security record.
+ */
+int set_current_groups(struct group_info *group_info)
+{
+	return set_groups(current->sec, group_info);
+}
+
 EXPORT_SYMBOL(set_current_groups);
 
 asmlinkage long sys_getgroups(int gidsetsize, gid_t __user *grouplist)
 {
+	struct task_security *sec = current->sec;
 	int i = 0;
 
 	/*
@@ -1255,13 +1289,13 @@ asmlinkage long sys_getgroups(int gidsetsize, gid_t __user *grouplist)
 		return -EINVAL;
 
 	/* no need to grab task_lock here; it cannot change */
-	i = current->group_info->ngroups;
+	i = sec->group_info->ngroups;
 	if (gidsetsize) {
 		if (i > gidsetsize) {
 			i = -EINVAL;
 			goto out;
 		}
-		if (groups_to_user(grouplist, current->group_info)) {
+		if (groups_to_user(grouplist, sec->group_info)) {
 			i = -EFAULT;
 			goto out;
 		}
@@ -1305,9 +1339,10 @@ asmlinkage long sys_setgroups(int gidsetsize, gid_t __user *grouplist)
  */
 int in_group_p(gid_t grp)
 {
+	struct task_security *act_as = current->act_as;
 	int retval = 1;
-	if (grp != current->fsgid)
-		retval = groups_search(current->group_info, grp);
+	if (grp != act_as->fsgid)
+		retval = groups_search(act_as->group_info, grp);
 	return retval;
 }
 
@@ -1315,9 +1350,10 @@ EXPORT_SYMBOL(in_group_p);
 
 int in_egroup_p(gid_t grp)
 {
+	struct task_security *act_as = current->act_as;
 	int retval = 1;
-	if (grp != current->egid)
-		retval = groups_search(current->group_info, grp);
+	if (grp != act_as->egid)
+		retval = groups_search(act_as->group_info, grp);
 	return retval;
 }
 
@@ -1626,6 +1662,9 @@ asmlinkage long sys_umask(int mask)
 asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
 			  unsigned long arg4, unsigned long arg5)
 {
+	struct task_struct *me = current;
+	struct task_security *sec = me->sec;
+	unsigned char comm[sizeof(me->comm)];
 	long error;
 
 	error = security_task_prctl(option, arg2, arg3, arg4, arg5);
@@ -1638,39 +1677,39 @@ asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
 				error = -EINVAL;
 				break;
 			}
-			current->pdeath_signal = arg2;
+			me->pdeath_signal = arg2;
 			break;
 		case PR_GET_PDEATHSIG:
-			error = put_user(current->pdeath_signal, (int __user *)arg2);
+			error = put_user(me->pdeath_signal, (int __user *)arg2);
 			break;
 		case PR_GET_DUMPABLE:
-			error = get_dumpable(current->mm);
+			error = get_dumpable(me->mm);
 			break;
 		case PR_SET_DUMPABLE:
 			if (arg2 < 0 || arg2 > 1) {
 				error = -EINVAL;
 				break;
 			}
-			set_dumpable(current->mm, arg2);
+			set_dumpable(me->mm, arg2);
 			break;
 
 		case PR_SET_UNALIGN:
-			error = SET_UNALIGN_CTL(current, arg2);
+			error = SET_UNALIGN_CTL(me, arg2);
 			break;
 		case PR_GET_UNALIGN:
-			error = GET_UNALIGN_CTL(current, arg2);
+			error = GET_UNALIGN_CTL(me, arg2);
 			break;
 		case PR_SET_FPEMU:
-			error = SET_FPEMU_CTL(current, arg2);
+			error = SET_FPEMU_CTL(me, arg2);
 			break;
 		case PR_GET_FPEMU:
-			error = GET_FPEMU_CTL(current, arg2);
+			error = GET_FPEMU_CTL(me, arg2);
 			break;
 		case PR_SET_FPEXC:
-			error = SET_FPEXC_CTL(current, arg2);
+			error = SET_FPEXC_CTL(me, arg2);
 			break;
 		case PR_GET_FPEXC:
-			error = GET_FPEXC_CTL(current, arg2);
+			error = GET_FPEXC_CTL(me, arg2);
 			break;
 		case PR_GET_TIMING:
 			error = PR_TIMING_STATISTICAL;
@@ -1683,7 +1722,7 @@ asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
 			break;
 
 		case PR_GET_KEEPCAPS:
-			if (current->keep_capabilities)
+			if (sec->keep_capabilities)
 				error = 1;
 			break;
 		case PR_SET_KEEPCAPS:
@@ -1691,33 +1730,26 @@ asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
 				error = -EINVAL;
 				break;
 			}
-			current->keep_capabilities = arg2;
+			sec->keep_capabilities = arg2;
 			break;
-		case PR_SET_NAME: {
-			struct task_struct *me = current;
-			unsigned char ncomm[sizeof(me->comm)];
-
-			ncomm[sizeof(me->comm)-1] = 0;
-			if (strncpy_from_user(ncomm, (char __user *)arg2,
+		case PR_SET_NAME:
+			comm[sizeof(me->comm)-1] = 0;
+			if (strncpy_from_user(comm, (char __user *)arg2,
 						sizeof(me->comm)-1) < 0)
 				return -EFAULT;
-			set_task_comm(me, ncomm);
+			set_task_comm(me, comm);
 			return 0;
-		}
-		case PR_GET_NAME: {
-			struct task_struct *me = current;
-			unsigned char tcomm[sizeof(me->comm)];
-
-			get_task_comm(tcomm, me);
-			if (copy_to_user((char __user *)arg2, tcomm, sizeof(tcomm)))
+		case PR_GET_NAME:
+			get_task_comm(comm, me);
+			if (copy_to_user((char __user *)arg2, comm,
+					 sizeof(comm)))
 				return -EFAULT;
 			return 0;
-		}
 		case PR_GET_ENDIAN:
-			error = GET_ENDIAN(current, arg2);
+			error = GET_ENDIAN(me, arg2);
 			break;
 		case PR_SET_ENDIAN:
-			error = SET_ENDIAN(current, arg2);
+			error = SET_ENDIAN(me, arg2);
 			break;
 
 		case PR_GET_SECCOMP:
@@ -1730,7 +1762,7 @@ asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
 		case PR_CAPBSET_READ:
 			if (!cap_valid(arg2))
 				return -EINVAL;
-			return !!cap_raised(current->cap_bset, arg2);
+			return !!cap_raised(sec->cap_bset, arg2);
 		case PR_CAPBSET_DROP:
 #ifdef CONFIG_SECURITY_FILE_CAPABILITIES
 			return cap_prctl_drop(arg2);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 8b7e954..6e0c922 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1513,7 +1513,7 @@ out:
 
 static int test_perm(int mode, int op)
 {
-	if (!current->euid)
+	if (!current->act_as->euid)
 		mode >>= 6;
 	else if (in_egroup_p(0))
 		mode >>= 3;
diff --git a/kernel/timer.c b/kernel/timer.c
index 99b00a2..9d28a7c 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -988,25 +988,25 @@ asmlinkage long sys_getppid(void)
 asmlinkage long sys_getuid(void)
 {
 	/* Only we change this so SMP safe */
-	return current->uid;
+	return current->sec->uid;
 }
 
 asmlinkage long sys_geteuid(void)
 {
 	/* Only we change this so SMP safe */
-	return current->euid;
+	return current->sec->euid;
 }
 
 asmlinkage long sys_getgid(void)
 {
 	/* Only we change this so SMP safe */
-	return current->gid;
+	return current->sec->gid;
 }
 
 asmlinkage long sys_getegid(void)
 {
 	/* Only we change this so SMP safe */
-	return  current->egid;
+	return  current->sec->egid;
 }
 
 #endif
diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index 4ab1b58..84c98ee 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -53,8 +53,8 @@ void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
 		stats->ac_flag |= AXSIG;
 	stats->ac_nice	 = task_nice(tsk);
 	stats->ac_sched	 = tsk->policy;
-	stats->ac_uid	 = tsk->uid;
-	stats->ac_gid	 = tsk->gid;
+	stats->ac_uid	 = tsk->sec->uid;
+	stats->ac_gid	 = tsk->sec->gid;
 	stats->ac_pid	 = tsk->pid;
 	rcu_read_lock();
 	stats->ac_ppid	 = pid_alive(tsk) ?
diff --git a/kernel/uid16.c b/kernel/uid16.c
index dd308ba..c56f6fe 100644
--- a/kernel/uid16.c
+++ b/kernel/uid16.c
@@ -86,9 +86,9 @@ asmlinkage long sys_getresuid16(old_uid_t __user *ruid, old_uid_t __user *euid,
 {
 	int retval;
 
-	if (!(retval = put_user(high2lowuid(current->uid), ruid)) &&
-	    !(retval = put_user(high2lowuid(current->euid), euid)))
-		retval = put_user(high2lowuid(current->suid), suid);
+	if (!(retval = put_user(high2lowuid(current->sec->uid), ruid)) &&
+	    !(retval = put_user(high2lowuid(current->sec->euid), euid)))
+		retval = put_user(high2lowuid(current->sec->suid), suid);
 
 	return retval;
 }
@@ -106,9 +106,9 @@ asmlinkage long sys_getresgid16(old_gid_t __user *rgid, old_gid_t __user *egid,
 {
 	int retval;
 
-	if (!(retval = put_user(high2lowgid(current->gid), rgid)) &&
-	    !(retval = put_user(high2lowgid(current->egid), egid)))
-		retval = put_user(high2lowgid(current->sgid), sgid);
+	if (!(retval = put_user(high2lowgid(current->sec->gid), rgid)) &&
+	    !(retval = put_user(high2lowgid(current->sec->egid), egid)))
+		retval = put_user(high2lowgid(current->sec->sgid), sgid);
 
 	return retval;
 }
@@ -166,20 +166,20 @@ asmlinkage long sys_getgroups16(int gidsetsize, old_gid_t __user *grouplist)
 	if (gidsetsize < 0)
 		return -EINVAL;
 
-	get_group_info(current->group_info);
-	i = current->group_info->ngroups;
+	get_group_info(current->sec->group_info);
+	i = current->sec->group_info->ngroups;
 	if (gidsetsize) {
 		if (i > gidsetsize) {
 			i = -EINVAL;
 			goto out;
 		}
-		if (groups16_to_user(grouplist, current->group_info)) {
+		if (groups16_to_user(grouplist, current->sec->group_info)) {
 			i = -EFAULT;
 			goto out;
 		}
 	}
 out:
-	put_group_info(current->group_info);
+	put_group_info(current->sec->group_info);
 	return i;
 }
 
@@ -210,20 +210,20 @@ asmlinkage long sys_setgroups16(int gidsetsize, old_gid_t __user *grouplist)
 
 asmlinkage long sys_getuid16(void)
 {
-	return high2lowuid(current->uid);
+	return high2lowuid(current->sec->uid);
 }
 
 asmlinkage long sys_geteuid16(void)
 {
-	return high2lowuid(current->euid);
+	return high2lowuid(current->sec->euid);
 }
 
 asmlinkage long sys_getgid16(void)
 {
-	return high2lowgid(current->gid);
+	return high2lowgid(current->sec->gid);
 }
 
 asmlinkage long sys_getegid16(void)
 {
-	return high2lowgid(current->egid);
+	return high2lowgid(current->sec->egid);
 }
diff --git a/kernel/user.c b/kernel/user.c
index 7132022..e85be3b 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -450,11 +450,11 @@ void switch_uid(struct user_struct *new_user)
 	 * cheaply with the new uid cache, so if it matters
 	 * we should be checking for it.  -DaveM
 	 */
-	old_user = current->user;
+	old_user = current->sec->user;
 	atomic_inc(&new_user->processes);
 	atomic_dec(&old_user->processes);
 	switch_uid_keyring(new_user);
-	current->user = new_user;
+	current->sec->user = new_user;
 	sched_switch_user(current);
 
 	/*
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 4c90062..dd3c378 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -38,7 +38,7 @@ static struct user_namespace *clone_user_ns(struct user_namespace *old_ns)
 	}
 
 	/* Reset current->user with a new one */
-	new_user = alloc_uid(ns, current->uid);
+	new_user = alloc_uid(ns, current->sec->uid);
 	if (!new_user) {
 		free_uid(ns->root_user);
 		kfree(ns);
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 6c7ba1a..0fda363 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -952,6 +952,7 @@ asmlinkage long sys_migrate_pages(pid_t pid, unsigned long maxnode,
 		const unsigned long __user *old_nodes,
 		const unsigned long __user *new_nodes)
 {
+	struct task_security *act_as, *obj;
 	struct mm_struct *mm;
 	struct task_struct *task;
 	nodemask_t old;
@@ -986,8 +987,10 @@ asmlinkage long sys_migrate_pages(pid_t pid, unsigned long maxnode,
 	 * capabilities, superuser privileges or the same
 	 * userid as the target process.
 	 */
-	if ((current->euid != task->suid) && (current->euid != task->uid) &&
-	    (current->uid != task->suid) && (current->uid != task->uid) &&
+	act_as = current->act_as;
+	obj = task->sec;
+	if ((act_as->euid != obj->suid) && (act_as->euid != obj->uid) &&
+	    (act_as->uid != obj->suid) && (act_as->uid != obj->uid) &&
 	    !capable(CAP_SYS_NICE)) {
 		err = -EPERM;
 		goto out;
diff --git a/mm/migrate.c b/mm/migrate.c
index a73504f..75ae1fb 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -935,6 +935,7 @@ asmlinkage long sys_move_pages(pid_t pid, unsigned long nr_pages,
 			const int __user *nodes,
 			int __user *status, int flags)
 {
+	struct task_security *act_as, *obj;
 	int err = 0;
 	int i;
 	struct task_struct *task;
@@ -968,8 +969,10 @@ asmlinkage long sys_move_pages(pid_t pid, unsigned long nr_pages,
 	 * capabilities, superuser privileges or the same
 	 * userid as the target process.
 	 */
-	if ((current->euid != task->suid) && (current->euid != task->uid) &&
-	    (current->uid != task->suid) && (current->uid != task->uid) &&
+	act_as = current->act_as;
+	obj = task->sec;
+	if ((act_as->euid != obj->suid) && (act_as->euid != obj->uid) &&
+	    (act_as->uid != obj->suid) && (act_as->uid != obj->uid) &&
 	    !capable(CAP_SYS_NICE)) {
 		err = -EPERM;
 		goto out2;
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 4194b9d..82a6710 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -291,7 +291,7 @@ static void dump_tasks(const struct mem_cgroup *mem)
 
 		task_lock(p);
 		printk(KERN_INFO "[%5d] %5d %5d %8lu %8lu %3d     %3d %s\n",
-		       p->pid, p->uid, p->tgid, p->mm->total_vm,
+		       p->pid, p->sec->uid, p->tgid, p->mm->total_vm,
 		       get_mm_rss(p->mm), (int)task_cpu(p), p->oomkilladj,
 		       p->comm);
 		task_unlock(p);
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 48bfcc7..f3e4894 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1044,7 +1044,7 @@ static int ax25_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	if (addr->fsa_ax25.sax25_family != AF_AX25)
 		return -EINVAL;
 
-	user = ax25_findbyuid(current->euid);
+	user = ax25_findbyuid(current->act_as->euid);
 	if (user) {
 		call = user->call;
 		ax25_uid_put(user);
diff --git a/net/ax25/ax25_route.c b/net/ax25/ax25_route.c
index 8672cd8..03a1a9a 100644
--- a/net/ax25/ax25_route.c
+++ b/net/ax25/ax25_route.c
@@ -421,7 +421,7 @@ int ax25_rt_autobind(ax25_cb *ax25, ax25_address *addr)
 		goto put;
 	}
 
-	user = ax25_findbyuid(current->euid);
+	user = ax25_findbyuid(current->act_as->euid);
 	if (user) {
 		ax25->source_addr = user->call;
 		ax25_uid_put(user);
diff --git a/net/core/dev.c b/net/core/dev.c
index 908f07c..70c5776 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2759,7 +2759,7 @@ static void __dev_set_promiscuity(struct net_device *dev, int inc)
 				dev->name, (dev->flags & IFF_PROMISC),
 				(old_flags & IFF_PROMISC),
 				audit_get_loginuid(current),
-				current->uid, current->gid,
+				current->act_as->uid, current->act_as->gid,
 				audit_get_sessionid(current));
 
 		if (dev->change_rx_flags)
diff --git a/net/core/scm.c b/net/core/scm.c
index 10f5c65..703b174 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -44,11 +44,13 @@
 
 static __inline__ int scm_check_creds(struct ucred *creds)
 {
+	struct task_security *sec = current->act_as;
+
 	if ((creds->pid == task_tgid_vnr(current) || capable(CAP_SYS_ADMIN)) &&
-	    ((creds->uid == current->uid || creds->uid == current->euid ||
-	      creds->uid == current->suid) || capable(CAP_SETUID)) &&
-	    ((creds->gid == current->gid || creds->gid == current->egid ||
-	      creds->gid == current->sgid) || capable(CAP_SETGID))) {
+	    ((creds->uid == sec->uid || creds->uid == sec->euid ||
+	      creds->uid == sec->suid) || capable(CAP_SETUID)) &&
+	    ((creds->gid == sec->gid || creds->gid == sec->egid ||
+	      creds->gid == sec->sgid) || capable(CAP_SETGID))) {
 	       return 0;
 	}
 	return -EPERM;
diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
index 2b7d9ee..bda7783 100644
--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -364,7 +364,7 @@ fl_create(struct in6_flowlabel_req *freq, char __user *optval, int optlen, int *
 		fl->owner = current->pid;
 		break;
 	case IPV6_FL_S_USER:
-		fl->owner = current->euid;
+		fl->owner = current->act_as->euid;
 		break;
 	default:
 		err = -EINVAL;
diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 972250c..2471ff9 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -599,7 +599,7 @@ static int nr_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	} else {
 		source = &addr->fsa_ax25.sax25_call;
 
-		user = ax25_findbyuid(current->euid);
+		user = ax25_findbyuid(current->act_as->euid);
 		if (user) {
 			nr->user_addr   = user->call;
 			ax25_uid_put(user);
@@ -673,7 +673,7 @@ static int nr_connect(struct socket *sock, struct sockaddr *uaddr,
 		}
 		source = (ax25_address *)dev->dev_addr;
 
-		user = ax25_findbyuid(current->euid);
+		user = ax25_findbyuid(current->act_as->euid);
 		if (user) {
 			nr->user_addr   = user->call;
 			ax25_uid_put(user);
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 4a31a81..53ff9ce 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -669,7 +669,7 @@ static int rose_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 
 	source = &addr->srose_call;
 
-	user = ax25_findbyuid(current->euid);
+	user = ax25_findbyuid(current->act_as->euid);
 	if (user) {
 		rose->source_call = user->call;
 		ax25_uid_put(user);
@@ -768,7 +768,7 @@ static int rose_connect(struct socket *sock, struct sockaddr *uaddr, int addr_le
 			goto out_release;
 		}
 
-		user = ax25_findbyuid(current->euid);
+		user = ax25_findbyuid(current->act_as->euid);
 		if (!user) {
 			err = -EINVAL;
 			goto out_release;
diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
index 83e60f8..01e25a2 100644
--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -345,7 +345,7 @@ rpcauth_lookupcred(struct rpc_auth *auth, int flags)
 	struct auth_cred acred = {
 		.uid = current_fsuid(),
 		.gid = current_fsgid(),
-		.group_info = current->group_info,
+		.group_info = current->act_as->group_info,
 	};
 	struct rpc_cred *ret;
 
@@ -382,7 +382,7 @@ rpcauth_bindcred(struct rpc_task *task)
 	struct auth_cred acred = {
 		.uid = current_fsuid(),
 		.gid = current_fsgid(),
-		.group_info = current->group_info,
+		.group_info = current->act_as->group_info,
 	};
 	struct rpc_cred *ret;
 	int flags = 0;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index b8788fd..6d762ff 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -464,8 +464,8 @@ static int unix_listen(struct socket *sock, int backlog)
 	sk->sk_state		= TCP_LISTEN;
 	/* set credentials so connect can copy them */
 	sk->sk_peercred.pid	= task_tgid_vnr(current);
-	sk->sk_peercred.uid	= current->euid;
-	sk->sk_peercred.gid	= current->egid;
+	sk->sk_peercred.uid	= current->act_as->euid;
+	sk->sk_peercred.gid	= current->act_as->egid;
 	err = 0;
 
 out_unlock:
@@ -1117,8 +1117,8 @@ restart:
 	newsk->sk_state		= TCP_ESTABLISHED;
 	newsk->sk_type		= sk->sk_type;
 	newsk->sk_peercred.pid	= task_tgid_vnr(current);
-	newsk->sk_peercred.uid	= current->euid;
-	newsk->sk_peercred.gid	= current->egid;
+	newsk->sk_peercred.uid	= current->act_as->euid;
+	newsk->sk_peercred.gid	= current->act_as->egid;
 	newu = unix_sk(newsk);
 	newsk->sk_sleep		= &newu->peer_wait;
 	otheru = unix_sk(other);
@@ -1178,8 +1178,8 @@ static int unix_socketpair(struct socket *socka, struct socket *sockb)
 	unix_peer(ska)=skb;
 	unix_peer(skb)=ska;
 	ska->sk_peercred.pid = skb->sk_peercred.pid = task_tgid_vnr(current);
-	ska->sk_peercred.uid = skb->sk_peercred.uid = current->euid;
-	ska->sk_peercred.gid = skb->sk_peercred.gid = current->egid;
+	ska->sk_peercred.uid = skb->sk_peercred.uid = current->act_as->euid;
+	ska->sk_peercred.gid = skb->sk_peercred.gid = current->act_as->egid;
 
 	if (ska->sk_type != SOCK_DGRAM) {
 		ska->sk_state = TCP_ESTABLISHED;
diff --git a/security/commoncap.c b/security/commoncap.c
index c340f53..16e098d 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -32,7 +32,7 @@ EXPORT_SYMBOL(securebits);
 
 int cap_netlink_send(struct sock *sk, struct sk_buff *skb)
 {
-	NETLINK_CB(skb).eff_cap = current->cap_effective;
+	NETLINK_CB(skb).eff_cap = current_cap();
 	return 0;
 }
 
@@ -54,7 +54,7 @@ EXPORT_SYMBOL(cap_netlink_recv);
 int cap_capable (struct task_struct *tsk, int cap)
 {
 	/* Derived from include/linux/sched.h:capable. */
-	if (cap_raised(tsk->cap_effective, cap))
+	if (cap_raised(tsk->act_as->cap_effective, cap))
 		return 0;
 	return -EPERM;
 }
@@ -69,7 +69,8 @@ int cap_settime(struct timespec *ts, struct timezone *tz)
 int cap_ptrace (struct task_struct *parent, struct task_struct *child)
 {
 	/* Derived from arch/i386/kernel/ptrace.c:sys_ptrace. */
-	if (!cap_issubset(child->cap_permitted, parent->cap_permitted) &&
+	if (!cap_issubset(child->sec->cap_permitted,
+			  parent->act_as->cap_permitted) &&
 	    !__capable(parent, CAP_SYS_PTRACE))
 		return -EPERM;
 	return 0;
@@ -78,10 +79,12 @@ int cap_ptrace (struct task_struct *parent, struct task_struct *child)
 int cap_capget (struct task_struct *target, kernel_cap_t *effective,
 		kernel_cap_t *inheritable, kernel_cap_t *permitted)
 {
+	struct task_security *sec = target->sec;
+
 	/* Derived from kernel/capability.c:sys_capget. */
-	*effective = target->cap_effective;
-	*inheritable = target->cap_inheritable;
-	*permitted = target->cap_permitted;
+	*effective = sec->cap_effective;
+	*inheritable = sec->cap_inheritable;
+	*permitted = sec->cap_permitted;
 	return 0;
 }
 
@@ -116,27 +119,30 @@ static inline int cap_inh_is_capped(void) { return 1; }
 int cap_capset_check (struct task_struct *target, kernel_cap_t *effective,
 		      kernel_cap_t *inheritable, kernel_cap_t *permitted)
 {
+	struct task_security *act_as = current->act_as;
+	struct task_security *sec = target->sec;
+
 	if (cap_block_setpcap(target)) {
 		return -EPERM;
 	}
 	if (cap_inh_is_capped()
 	    && !cap_issubset(*inheritable,
-			     cap_combine(target->cap_inheritable,
-					 current->cap_permitted))) {
+			     cap_combine(sec->cap_inheritable,
+					 act_as->cap_permitted))) {
 		/* incapable of using this inheritable set */
 		return -EPERM;
 	}
 	if (!cap_issubset(*inheritable,
-			   cap_combine(target->cap_inheritable,
-				       current->cap_bset))) {
+			   cap_combine(sec->cap_inheritable,
+				       act_as->cap_bset))) {
 		/* no new pI capabilities outside bounding set */
 		return -EPERM;
 	}
 
 	/* verify restrictions on target's new Permitted set */
 	if (!cap_issubset (*permitted,
-			   cap_combine (target->cap_permitted,
-					current->cap_permitted))) {
+			   cap_combine (sec->cap_permitted,
+					act_as->cap_permitted))) {
 		return -EPERM;
 	}
 
@@ -151,9 +157,11 @@ int cap_capset_check (struct task_struct *target, kernel_cap_t *effective,
 void cap_capset_set (struct task_struct *target, kernel_cap_t *effective,
 		     kernel_cap_t *inheritable, kernel_cap_t *permitted)
 {
-	target->cap_effective = *effective;
-	target->cap_inheritable = *inheritable;
-	target->cap_permitted = *permitted;
+	struct task_security *sec = target->sec;
+
+	sec->cap_effective = *effective;
+	sec->cap_inheritable = *inheritable;
+	sec->cap_permitted = *permitted;
 }
 
 static inline void bprm_clear_caps(struct linux_binprm *bprm)
@@ -313,7 +321,7 @@ int cap_bprm_set_security (struct linux_binprm *bprm)
 	 */
 
 	if (!issecure (SECURE_NOROOT)) {
-		if (bprm->e_uid == 0 || current->uid == 0) {
+		if (bprm->e_uid == 0 || current->sec->uid == 0) {
 			cap_set_full (bprm->cap_inheritable);
 			cap_set_full (bprm->cap_permitted);
 		}
@@ -326,54 +334,55 @@ int cap_bprm_set_security (struct linux_binprm *bprm)
 
 void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 {
+	struct task_security *sec = current->sec;
 	/* Derived from fs/exec.c:compute_creds. */
 	kernel_cap_t new_permitted, working;
 
-	new_permitted = cap_intersect(bprm->cap_permitted,
-				 current->cap_bset);
-	working = cap_intersect(bprm->cap_inheritable,
-				 current->cap_inheritable);
+	new_permitted = cap_intersect(bprm->cap_permitted, sec->cap_bset);
+	working = cap_intersect(bprm->cap_inheritable, sec->cap_inheritable);
 	new_permitted = cap_combine(new_permitted, working);
 
-	if (bprm->e_uid != current->uid || bprm->e_gid != current->gid ||
-	    !cap_issubset (new_permitted, current->cap_permitted)) {
+	if (bprm->e_uid != sec->uid || bprm->e_gid != sec->gid ||
+	    !cap_issubset (new_permitted, sec->cap_permitted)) {
 		set_dumpable(current->mm, suid_dumpable);
 		current->pdeath_signal = 0;
 
 		if (unsafe & ~LSM_UNSAFE_PTRACE_CAP) {
 			if (!capable(CAP_SETUID)) {
-				bprm->e_uid = current->uid;
-				bprm->e_gid = current->gid;
+				bprm->e_uid = sec->uid;
+				bprm->e_gid = sec->gid;
 			}
 			if (!capable (CAP_SETPCAP)) {
 				new_permitted = cap_intersect (new_permitted,
-							current->cap_permitted);
+							sec->cap_permitted);
 			}
 		}
 	}
 
-	current->suid = current->euid = current->fsuid = bprm->e_uid;
-	current->sgid = current->egid = current->fsgid = bprm->e_gid;
+	sec->suid = sec->euid = sec->fsuid = bprm->e_uid;
+	sec->sgid = sec->egid = sec->fsgid = bprm->e_gid;
 
 	/* For init, we want to retain the capabilities set
 	 * in the init_task struct. Thus we skip the usual
 	 * capability rules */
 	if (!is_global_init(current)) {
-		current->cap_permitted = new_permitted;
+		sec->cap_permitted = new_permitted;
 		if (bprm->cap_effective)
-			current->cap_effective = new_permitted;
+			sec->cap_effective = new_permitted;
 		else
-			cap_clear(current->cap_effective);
+			cap_clear(sec->cap_effective);
 	}
 
-	/* AUD: Audit candidate if current->cap_effective is set */
+	/* AUD: Audit candidate if sec->cap_effective is set */
 
-	current->keep_capabilities = 0;
+	sec->keep_capabilities = 0;
 }
 
 int cap_bprm_secureexec (struct linux_binprm *bprm)
 {
-	if (current->uid != 0) {
+	struct task_security *sec = current->sec;
+
+	if (sec->uid != 0) {
 		if (bprm->cap_effective)
 			return 1;
 		if (!cap_isclear(bprm->cap_permitted))
@@ -382,8 +391,8 @@ int cap_bprm_secureexec (struct linux_binprm *bprm)
 			return 1;
 	}
 
-	return (current->euid != current->uid ||
-		current->egid != current->gid);
+	return (sec->euid != sec->uid ||
+		sec->egid != sec->gid);
 }
 
 int cap_inode_setxattr(struct dentry *dentry, char *name, void *value,
@@ -446,23 +455,27 @@ int cap_inode_removexattr(struct dentry *dentry, char *name)
 static inline void cap_emulate_setxuid (int old_ruid, int old_euid,
 					int old_suid)
 {
+	struct task_security *sec = current->sec;
+
 	if ((old_ruid == 0 || old_euid == 0 || old_suid == 0) &&
-	    (current->uid != 0 && current->euid != 0 && current->suid != 0) &&
-	    !current->keep_capabilities) {
-		cap_clear (current->cap_permitted);
-		cap_clear (current->cap_effective);
+	    (sec->uid != 0 && sec->euid != 0 && sec->suid != 0) &&
+	    !sec->keep_capabilities) {
+		cap_clear (sec->cap_permitted);
+		cap_clear (sec->cap_effective);
 	}
-	if (old_euid == 0 && current->euid != 0) {
-		cap_clear (current->cap_effective);
+	if (old_euid == 0 && sec->euid != 0) {
+		cap_clear (sec->cap_effective);
 	}
-	if (old_euid != 0 && current->euid == 0) {
-		current->cap_effective = current->cap_permitted;
+	if (old_euid != 0 && sec->euid == 0) {
+		sec->cap_effective = sec->cap_permitted;
 	}
 }
 
 int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid,
 			  int flags)
 {
+	struct task_security *sec = current->sec;
+
 	switch (flags) {
 	case LSM_SETID_RE:
 	case LSM_SETID_ID:
@@ -484,16 +497,16 @@ int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid,
 			 */
 
 			if (!issecure (SECURE_NO_SETUID_FIXUP)) {
-				if (old_fsuid == 0 && current_fsuid() != 0) {
-					current->cap_effective =
+				if (old_fsuid == 0 && sec->fsuid != 0) {
+					sec->cap_effective =
 						cap_drop_fs_set(
-						    current->cap_effective);
+							sec->cap_effective);
 				}
-				if (old_fsuid != 0 && current_fsuid() == 0) {
-					current->cap_effective =
+				if (old_fsuid != 0 && sec->fsuid == 0) {
+					sec->cap_effective =
 						cap_raise_fs_set(
-						    current->cap_effective,
-						    current->cap_permitted);
+						    sec->cap_effective,
+						    sec->cap_permitted);
 				}
 			}
 			break;
@@ -518,7 +531,8 @@ int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid,
  */
 static inline int cap_safe_nice(struct task_struct *p)
 {
-	if (!cap_issubset(p->cap_permitted, current->cap_permitted) &&
+	if (!cap_issubset(p->sec->cap_permitted,
+			  current->act_as->cap_permitted) &&
 	    !__capable(current, CAP_SYS_NICE))
 		return -EPERM;
 	return 0;
@@ -552,7 +566,7 @@ int cap_task_kill(struct task_struct *p, struct siginfo *info,
 	 * allowed.
 	 * We must preserve legacy signal behavior in this case.
 	 */
-	if (p->euid == 0 && p->uid == current->uid)
+	if (p->sec->euid == 0 && p->sec->uid == current->act_as->uid)
 		return 0;
 
 	/* sigcont is permitted within same session */
@@ -567,7 +581,7 @@ int cap_task_kill(struct task_struct *p, struct siginfo *info,
 		 * Used only by usb drivers?
 		 */
 		return 0;
-	if (cap_issubset(p->cap_permitted, current->cap_permitted))
+	if (cap_issubset(p->sec->cap_permitted, current->act_as->cap_permitted))
 		return 0;
 	if (capable(CAP_KILL))
 		return 0;
@@ -588,7 +602,7 @@ long cap_prctl_drop(unsigned long cap)
 		return -EPERM;
 	if (!cap_valid(cap))
 		return -EINVAL;
-	cap_lower(current->cap_bset, cap);
+	cap_lower(current->sec->cap_bset, cap);
 	return 0;
 }
 #else
@@ -614,11 +628,12 @@ int cap_task_kill(struct task_struct *p, struct siginfo *info,
 
 void cap_task_reparent_to_init (struct task_struct *p)
 {
-	cap_set_init_eff(p->cap_effective);
-	cap_clear(p->cap_inheritable);
-	cap_set_full(p->cap_permitted);
-	p->keep_capabilities = 0;
-	return;
+	struct task_security *sec = p->sec;
+
+	cap_set_init_eff(sec->cap_effective);
+	cap_clear(sec->cap_inheritable);
+	cap_set_full(sec->cap_permitted);
+	sec->keep_capabilities = 0;
 }
 
 int cap_syslog (int type)
diff --git a/security/dummy.c b/security/dummy.c
index 6a0056b..28413ae 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -36,7 +36,7 @@ static int dummy_ptrace (struct task_struct *parent, struct task_struct *child)
 static int dummy_capget (struct task_struct *target, kernel_cap_t * effective,
 			 kernel_cap_t * inheritable, kernel_cap_t * permitted)
 {
-	if (target->euid == 0) {
+	if (target->sec->euid == 0) {
 		cap_set_full(*permitted);
 		cap_set_init_eff(*effective);
 	} else {
@@ -46,7 +46,7 @@ static int dummy_capget (struct task_struct *target, kernel_cap_t * effective,
 
 	cap_clear(*inheritable);
 
-	if (target->fsuid != 0) {
+	if (target->sec->fsuid != 0) {
 		*permitted = cap_drop_fs_set(*permitted);
 		*effective = cap_drop_fs_set(*effective);
 	}
@@ -76,7 +76,7 @@ static int dummy_acct (struct file *file)
 
 static int dummy_capable (struct task_struct *tsk, int cap)
 {
-	if (cap_raised (tsk->cap_effective, cap))
+	if (cap_raised(tsk->act_as->cap_effective, cap))
 		return 0;
 	return -EPERM;
 }
@@ -98,7 +98,7 @@ static int dummy_quota_on (struct dentry *dentry)
 
 static int dummy_syslog (int type)
 {
-	if ((type != 3 && type != 10) && current->euid)
+	if ((type != 3 && type != 10) && current->act_as->euid)
 		return -EPERM;
 	return 0;
 }
@@ -131,19 +131,24 @@ static void dummy_bprm_free_security (struct linux_binprm *bprm)
 
 static void dummy_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 {
-	if (bprm->e_uid != current->uid || bprm->e_gid != current->gid) {
+	struct task_security *sec = current->sec;
+
+	if (bprm->e_uid != sec->uid || bprm->e_gid != sec->gid) {
 		set_dumpable(current->mm, suid_dumpable);
 
 		if ((unsafe & ~LSM_UNSAFE_PTRACE_CAP) && !capable(CAP_SETUID)) {
-			bprm->e_uid = current->uid;
-			bprm->e_gid = current->gid;
+			bprm->e_uid = sec->uid;
+			bprm->e_gid = sec->gid;
 		}
 	}
 
-	current->suid = current->euid = current->fsuid = bprm->e_uid;
-	current->sgid = current->egid = current->fsgid = bprm->e_gid;
+	sec->suid = sec->euid = sec->fsuid = bprm->e_uid;
+	sec->sgid = sec->egid = sec->fsgid = bprm->e_gid;
 
-	dummy_capget(current, &current->cap_effective, &current->cap_inheritable, &current->cap_permitted);
+	dummy_capget(current,
+		     &sec->cap_effective,
+		     &sec->cap_inheritable,
+		     &sec->cap_permitted);
 }
 
 static void dummy_bprm_post_apply_creds (struct linux_binprm *bprm)
@@ -167,8 +172,8 @@ static int dummy_bprm_secureexec (struct linux_binprm *bprm)
 	   in the AT_SECURE field to decide whether secure mode
 	   is required.  Hence, this logic is required to preserve
 	   the legacy decision algorithm used by the old userland. */
-	return (current->euid != current->uid ||
-		current->egid != current->gid);
+	return (current->sec->euid != current->sec->uid ||
+		current->sec->egid != current->sec->gid);
 }
 
 static int dummy_sb_alloc_security (struct super_block *sb)
@@ -515,7 +520,12 @@ static int dummy_task_setuid (uid_t id0, uid_t id1, uid_t id2, int flags)
 
 static int dummy_task_post_setuid (uid_t id0, uid_t id1, uid_t id2, int flags)
 {
-	dummy_capget(current, &current->cap_effective, &current->cap_inheritable, &current->cap_permitted);
+	struct task_security *sec = current->sec;
+
+	dummy_capget(current,
+		     &sec->cap_effective,
+		     &sec->cap_inheritable,
+		     &sec->cap_permitted);
 	return 0;
 }
 
@@ -602,7 +612,7 @@ static int dummy_task_prctl (int option, unsigned long arg2, unsigned long arg3,
 
 static void dummy_task_reparent_to_init (struct task_struct *p)
 {
-	p->euid = p->fsuid = 0;
+	p->sec->euid = p->sec->fsuid = 0;
 	return;
 }
 
@@ -712,7 +722,7 @@ static int dummy_sem_semop (struct sem_array *sma,
 
 static int dummy_netlink_send (struct sock *sk, struct sk_buff *skb)
 {
-	NETLINK_CB(skb).eff_cap = current->cap_effective;
+	NETLINK_CB(skb).eff_cap = current->act_as->cap_effective;
 	return 0;
 }
 
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index b3a63dd..4051948 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -846,7 +846,7 @@ long keyctl_instantiate_key(key_serial_t id,
 	/* the appropriate instantiation authorisation key must have been
 	 * assumed before calling this */
 	ret = -EPERM;
-	instkey = current->request_key_auth;
+	instkey = current->sec->request_key_auth;
 	if (!instkey)
 		goto error;
 
@@ -895,8 +895,8 @@ long keyctl_instantiate_key(key_serial_t id,
 	/* discard the assumed authority if it's just been disabled by
 	 * instantiation of the key */
 	if (ret == 0) {
-		key_put(current->request_key_auth);
-		current->request_key_auth = NULL;
+		key_put(current->sec->request_key_auth);
+		current->sec->request_key_auth = NULL;
 	}
 
 error2:
@@ -924,7 +924,7 @@ long keyctl_negate_key(key_serial_t id, unsigned timeout, key_serial_t ringid)
 	/* the appropriate instantiation authorisation key must have been
 	 * assumed before calling this */
 	ret = -EPERM;
-	instkey = current->request_key_auth;
+	instkey = current->sec->request_key_auth;
 	if (!instkey)
 		goto error;
 
@@ -952,8 +952,8 @@ long keyctl_negate_key(key_serial_t id, unsigned timeout, key_serial_t ringid)
 	/* discard the assumed authority if it's just been disabled by
 	 * instantiation of the key */
 	if (ret == 0) {
-		key_put(current->request_key_auth);
-		current->request_key_auth = NULL;
+		key_put(current->sec->request_key_auth);
+		current->sec->request_key_auth = NULL;
 	}
 
 error:
@@ -968,6 +968,7 @@ error:
  */
 long keyctl_set_reqkey_keyring(int reqkey_defl)
 {
+	struct task_security *sec = current->sec;
 	int ret;
 
 	switch (reqkey_defl) {
@@ -987,10 +988,10 @@ long keyctl_set_reqkey_keyring(int reqkey_defl)
 	case KEY_REQKEY_DEFL_USER_KEYRING:
 	case KEY_REQKEY_DEFL_USER_SESSION_KEYRING:
 	set:
-		current->jit_keyring = reqkey_defl;
+		sec->jit_keyring = reqkey_defl;
 
 	case KEY_REQKEY_DEFL_NO_CHANGE:
-		return current->jit_keyring;
+		return sec->jit_keyring;
 
 	case KEY_REQKEY_DEFL_GROUP_KEYRING:
 	default:
@@ -1055,8 +1056,8 @@ long keyctl_assume_authority(key_serial_t id)
 
 	/* we divest ourselves of authority if given an ID of 0 */
 	if (id == 0) {
-		key_put(current->request_key_auth);
-		current->request_key_auth = NULL;
+		key_put(current->sec->request_key_auth);
+		current->sec->request_key_auth = NULL;
 		ret = 0;
 		goto error;
 	}
@@ -1072,8 +1073,8 @@ long keyctl_assume_authority(key_serial_t id)
 		goto error;
 	}
 
-	key_put(current->request_key_auth);
-	current->request_key_auth = authkey;
+	key_put(current->sec->request_key_auth);
+	current->sec->request_key_auth = authkey;
 	ret = authkey->serial;
 
 error:
diff --git a/security/keys/permission.c b/security/keys/permission.c
index 3b41f9b..07898bd 100644
--- a/security/keys/permission.c
+++ b/security/keys/permission.c
@@ -22,6 +22,7 @@ int key_task_permission(const key_ref_t key_ref,
 			struct task_struct *context,
 			key_perm_t perm)
 {
+	struct task_security *sec = context->act_as;
 	struct key *key;
 	key_perm_t kperm;
 	int ret;
@@ -29,7 +30,7 @@ int key_task_permission(const key_ref_t key_ref,
 	key = key_ref_to_ptr(key_ref);
 
 	/* use the second 8-bits of permissions for keys the caller owns */
-	if (key->uid == context->fsuid) {
+	if (key->uid == sec->fsuid) {
 		kperm = key->perm >> 16;
 		goto use_these_perms;
 	}
@@ -37,14 +38,14 @@ int key_task_permission(const key_ref_t key_ref,
 	/* use the third 8-bits of permissions for keys the caller has a group
 	 * membership in common with */
 	if (key->gid != -1 && key->perm & KEY_GRP_ALL) {
-		if (key->gid == context->fsgid) {
+		if (key->gid == sec->fsgid) {
 			kperm = key->perm >> 8;
 			goto use_these_perms;
 		}
 
-		task_lock(context);
-		ret = groups_search(context->group_info, key->gid);
-		task_unlock(context);
+		spin_lock(&sec->lock);
+		ret = groups_search(sec->group_info, key->gid);
+		spin_unlock(&sec->lock);
 
 		if (ret) {
 			kperm = key->perm >> 8;
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index c886a2b..a016e9b 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -145,7 +145,7 @@ int install_thread_keyring(struct task_struct *tsk)
 
 	sprintf(buf, "_tid.%u", tsk->pid);
 
-	keyring = keyring_alloc(buf, tsk->uid, tsk->gid, tsk,
+	keyring = keyring_alloc(buf, tsk->sec->uid, tsk->sec->gid, tsk,
 				KEY_ALLOC_QUOTA_OVERRUN, NULL);
 	if (IS_ERR(keyring)) {
 		ret = PTR_ERR(keyring);
@@ -153,8 +153,8 @@ int install_thread_keyring(struct task_struct *tsk)
 	}
 
 	task_lock(tsk);
-	old = tsk->thread_keyring;
-	tsk->thread_keyring = keyring;
+	old = tsk->sec->thread_keyring;
+	tsk->sec->thread_keyring = keyring;
 	task_unlock(tsk);
 
 	ret = 0;
@@ -180,7 +180,7 @@ int install_process_keyring(struct task_struct *tsk)
 	if (!tsk->signal->process_keyring) {
 		sprintf(buf, "_pid.%u", tsk->tgid);
 
-		keyring = keyring_alloc(buf, tsk->uid, tsk->gid, tsk,
+		keyring = keyring_alloc(buf, tsk->sec->uid, tsk->sec->gid, tsk,
 					KEY_ALLOC_QUOTA_OVERRUN, NULL);
 		if (IS_ERR(keyring)) {
 			ret = PTR_ERR(keyring);
@@ -226,7 +226,7 @@ static int install_session_keyring(struct task_struct *tsk,
 		if (tsk->signal->session_keyring)
 			flags = KEY_ALLOC_IN_QUOTA;
 
-		keyring = keyring_alloc(buf, tsk->uid, tsk->gid, tsk,
+		keyring = keyring_alloc(buf, tsk->sec->uid, tsk->sec->gid, tsk,
 					flags, NULL);
 		if (IS_ERR(keyring))
 			return PTR_ERR(keyring);
@@ -280,14 +280,14 @@ int copy_thread_group_keys(struct task_struct *tsk)
  */
 int copy_keys(unsigned long clone_flags, struct task_struct *tsk)
 {
-	key_check(tsk->thread_keyring);
-	key_check(tsk->request_key_auth);
+	key_check(tsk->sec->thread_keyring);
+	key_check(tsk->sec->request_key_auth);
 
 	/* no thread keyring yet */
-	tsk->thread_keyring = NULL;
+	tsk->sec->thread_keyring = NULL;
 
 	/* copy the request_key() authorisation for this thread */
-	key_get(tsk->request_key_auth);
+	key_get(tsk->sec->request_key_auth);
 
 	return 0;
 
@@ -310,8 +310,8 @@ void exit_thread_group_keys(struct signal_struct *tg)
  */
 void exit_keys(struct task_struct *tsk)
 {
-	key_put(tsk->thread_keyring);
-	key_put(tsk->request_key_auth);
+	key_put(tsk->sec->thread_keyring);
+	key_put(tsk->sec->request_key_auth);
 
 } /* end exit_keys() */
 
@@ -325,8 +325,8 @@ int exec_keys(struct task_struct *tsk)
 
 	/* newly exec'd tasks don't get a thread keyring */
 	task_lock(tsk);
-	old = tsk->thread_keyring;
-	tsk->thread_keyring = NULL;
+	old = tsk->sec->thread_keyring;
+	tsk->sec->thread_keyring = NULL;
 	task_unlock(tsk);
 
 	key_put(old);
@@ -361,10 +361,11 @@ int suid_keys(struct task_struct *tsk)
 void key_fsuid_changed(struct task_struct *tsk)
 {
 	/* update the ownership of the thread keyring */
-	if (tsk->thread_keyring) {
-		down_write(&tsk->thread_keyring->sem);
-		tsk->thread_keyring->uid = tsk->fsuid;
-		up_write(&tsk->thread_keyring->sem);
+	BUG_ON(!tsk->sec);
+	if (tsk->sec->thread_keyring) {
+		down_write(&tsk->sec->thread_keyring->sem);
+		tsk->sec->thread_keyring->uid = tsk->sec->fsuid;
+		up_write(&tsk->sec->thread_keyring->sem);
 	}
 
 } /* end key_fsuid_changed() */
@@ -376,10 +377,11 @@ void key_fsuid_changed(struct task_struct *tsk)
 void key_fsgid_changed(struct task_struct *tsk)
 {
 	/* update the ownership of the thread keyring */
-	if (tsk->thread_keyring) {
-		down_write(&tsk->thread_keyring->sem);
-		tsk->thread_keyring->gid = tsk->fsgid;
-		up_write(&tsk->thread_keyring->sem);
+	BUG_ON(!tsk->sec);
+	if (tsk->sec->thread_keyring) {
+		down_write(&tsk->sec->thread_keyring->sem);
+		tsk->sec->thread_keyring->gid = tsk->sec->fsgid;
+		up_write(&tsk->sec->thread_keyring->sem);
 	}
 
 } /* end key_fsgid_changed() */
@@ -414,9 +416,9 @@ key_ref_t search_process_keyrings(struct key_type *type,
 	err = ERR_PTR(-EAGAIN);
 
 	/* search the thread keyring first */
-	if (context->thread_keyring) {
+	if (context->sec->thread_keyring) {
 		key_ref = keyring_search_aux(
-			make_key_ref(context->thread_keyring, 1),
+			make_key_ref(context->sec->thread_keyring, 1),
 			context, type, description, match);
 		if (!IS_ERR(key_ref))
 			goto found;
@@ -483,7 +485,7 @@ key_ref_t search_process_keyrings(struct key_type *type,
 	/* or search the user-session keyring */
 	else {
 		key_ref = keyring_search_aux(
-			make_key_ref(context->user->session_keyring, 1),
+			make_key_ref(context->sec->user->session_keyring, 1),
 			context, type, description, match);
 		if (!IS_ERR(key_ref))
 			goto found;
@@ -505,20 +507,20 @@ key_ref_t search_process_keyrings(struct key_type *type,
 	 * search the keyrings of the process mentioned there
 	 * - we don't permit access to request_key auth keys via this method
 	 */
-	if (context->request_key_auth &&
+	if (context->sec->request_key_auth &&
 	    context == current &&
 	    type != &key_type_request_key_auth
 	    ) {
 		/* defend against the auth key being revoked */
-		down_read(&context->request_key_auth->sem);
+		down_read(&context->sec->request_key_auth->sem);
 
-		if (key_validate(context->request_key_auth) == 0) {
-			rka = context->request_key_auth->payload.data;
+		if (key_validate(context->sec->request_key_auth) == 0) {
+			rka = context->sec->request_key_auth->payload.data;
 
 			key_ref = search_process_keyrings(type, description,
 							  match, rka->context);
 
-			up_read(&context->request_key_auth->sem);
+			up_read(&context->sec->request_key_auth->sem);
 
 			if (!IS_ERR(key_ref))
 				goto found;
@@ -535,7 +537,7 @@ key_ref_t search_process_keyrings(struct key_type *type,
 				break;
 			}
 		} else {
-			up_read(&context->request_key_auth->sem);
+			up_read(&context->sec->request_key_auth->sem);
 		}
 	}
 
@@ -577,7 +579,7 @@ key_ref_t lookup_user_key(struct task_struct *context, key_serial_t id,
 
 	switch (id) {
 	case KEY_SPEC_THREAD_KEYRING:
-		if (!context->thread_keyring) {
+		if (!context->sec->thread_keyring) {
 			if (!create)
 				goto error;
 
@@ -588,7 +590,7 @@ key_ref_t lookup_user_key(struct task_struct *context, key_serial_t id,
 			}
 		}
 
-		key = context->thread_keyring;
+		key = context->sec->thread_keyring;
 		atomic_inc(&key->usage);
 		key_ref = make_key_ref(key, 1);
 		break;
@@ -615,7 +617,7 @@ key_ref_t lookup_user_key(struct task_struct *context, key_serial_t id,
 			/* always install a session keyring upon access if one
 			 * doesn't exist yet */
 			ret = install_session_keyring(
-				context, context->user->session_keyring);
+				context, context->sec->user->session_keyring);
 			if (ret < 0)
 				goto error;
 		}
@@ -628,13 +630,13 @@ key_ref_t lookup_user_key(struct task_struct *context, key_serial_t id,
 		break;
 
 	case KEY_SPEC_USER_KEYRING:
-		key = context->user->uid_keyring;
+		key = context->sec->user->uid_keyring;
 		atomic_inc(&key->usage);
 		key_ref = make_key_ref(key, 1);
 		break;
 
 	case KEY_SPEC_USER_SESSION_KEYRING:
-		key = context->user->session_keyring;
+		key = context->sec->user->session_keyring;
 		atomic_inc(&key->usage);
 		key_ref = make_key_ref(key, 1);
 		break;
@@ -645,7 +647,7 @@ key_ref_t lookup_user_key(struct task_struct *context, key_serial_t id,
 		goto error;
 
 	case KEY_SPEC_REQKEY_AUTH_KEY:
-		key = context->request_key_auth;
+		key = context->sec->request_key_auth;
 		if (!key)
 			goto error;
 
@@ -747,7 +749,7 @@ long join_session_keyring(const char *name)
 	keyring = find_keyring_by_name(name, 0);
 	if (PTR_ERR(keyring) == -ENOKEY) {
 		/* not found - try and create a new one */
-		keyring = keyring_alloc(name, tsk->uid, tsk->gid, tsk,
+		keyring = keyring_alloc(name, tsk->sec->uid, tsk->sec->gid, tsk,
 					KEY_ALLOC_IN_QUOTA, NULL);
 		if (IS_ERR(keyring)) {
 			ret = PTR_ERR(keyring);
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 21efac2..5b5ad42 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -97,7 +97,8 @@ static int call_sbin_request_key(struct key_construction *cons,
 
 	/* we specify the process's default keyrings */
 	sprintf(keyring_str[0], "%d",
-		tsk->thread_keyring ? tsk->thread_keyring->serial : 0);
+		tsk->act_as->thread_keyring ?
+		tsk->act_as->thread_keyring->serial : 0);
 
 	prkey = 0;
 	if (tsk->signal->process_keyring)
@@ -110,7 +111,7 @@ static int call_sbin_request_key(struct key_construction *cons,
 		sskey = rcu_dereference(tsk->signal->session_keyring)->serial;
 		rcu_read_unlock();
 	} else {
-		sskey = tsk->user->session_keyring->serial;
+		sskey = tsk->act_as->user->session_keyring->serial;
 	}
 
 	sprintf(keyring_str[2], "%d", sskey);
@@ -216,10 +217,10 @@ static void construct_key_make_link(struct key *key, struct key *dest_keyring)
 
 	/* find the appropriate keyring */
 	if (!dest_keyring) {
-		switch (tsk->jit_keyring) {
+		switch (tsk->act_as->jit_keyring) {
 		case KEY_REQKEY_DEFL_DEFAULT:
 		case KEY_REQKEY_DEFL_THREAD_KEYRING:
-			dest_keyring = tsk->thread_keyring;
+			dest_keyring = tsk->act_as->thread_keyring;
 			if (dest_keyring)
 				break;
 
@@ -239,11 +240,11 @@ static void construct_key_make_link(struct key *key, struct key *dest_keyring)
 				break;
 
 		case KEY_REQKEY_DEFL_USER_SESSION_KEYRING:
-			dest_keyring = tsk->user->session_keyring;
+			dest_keyring = tsk->act_as->user->session_keyring;
 			break;
 
 		case KEY_REQKEY_DEFL_USER_KEYRING:
-			dest_keyring = tsk->user->uid_keyring;
+			dest_keyring = tsk->act_as->user->uid_keyring;
 			break;
 
 		case KEY_REQKEY_DEFL_GROUP_KEYRING:
diff --git a/security/keys/request_key_auth.c b/security/keys/request_key_auth.c
index 980d8cb..d306412 100644
--- a/security/keys/request_key_auth.c
+++ b/security/keys/request_key_auth.c
@@ -162,22 +162,22 @@ struct key *request_key_auth_new(struct key *target, const void *callout_info,
 
 	/* see if the calling process is already servicing the key request of
 	 * another process */
-	if (current->request_key_auth) {
+	if (current->act_as->request_key_auth) {
 		/* it is - use that instantiation context here too */
-		down_read(&current->request_key_auth->sem);
+		down_read(&current->act_as->request_key_auth->sem);
 
 		/* if the auth key has been revoked, then the key we're
 		 * servicing is already instantiated */
 		if (test_bit(KEY_FLAG_REVOKED,
-			     &current->request_key_auth->flags))
+			     &current->act_as->request_key_auth->flags))
 			goto auth_key_revoked;
 
-		irka = current->request_key_auth->payload.data;
+		irka = current->act_as->request_key_auth->payload.data;
 		rka->context = irka->context;
 		rka->pid = irka->pid;
 		get_task_struct(rka->context);
 
-		up_read(&current->request_key_auth->sem);
+		up_read(&current->act_as->request_key_auth->sem);
 	}
 	else {
 		/* it isn't - use this process as the context */
@@ -211,7 +211,7 @@ struct key *request_key_auth_new(struct key *target, const void *callout_info,
 	return authkey;
 
 auth_key_revoked:
-	up_read(&current->request_key_auth->sem);
+	up_read(&current->act_as->request_key_auth->sem);
 	kfree(rka->callout_info);
 	kfree(rka);
 	kleave("= -EKEYREVOKED");
diff --git a/security/selinux/exports.c b/security/selinux/exports.c
index 87d2bb3..5a0daa5 100644
--- a/security/selinux/exports.c
+++ b/security/selinux/exports.c
@@ -60,7 +60,7 @@ void selinux_get_ipc_sid(const struct kern_ipc_perm *ipcp, u32 *sid)
 void selinux_get_task_sid(struct task_struct *tsk, u32 *sid)
 {
 	if (selinux_enabled) {
-		struct task_security_struct *tsec = tsk->security;
+		struct task_security_struct *tsec = tsk->sec->security;
 		*sid = tsec->sid;
 		return;
 	}
@@ -81,7 +81,7 @@ EXPORT_SYMBOL_GPL(selinux_string_to_sid);
 int selinux_secmark_relabel_packet_permission(u32 sid)
 {
 	if (selinux_enabled) {
-		struct task_security_struct *tsec = current->security;
+		struct task_security_struct *tsec = current->act_as->security;
 
 		return avc_has_perm(tsec->sid, sid, SECCLASS_PACKET,
 				    PACKET__RELABELTO, NULL);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index f42ebfc..793cd4e 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -163,21 +163,21 @@ static int task_alloc_security(struct task_struct *task)
 
 	tsec->task = task;
 	tsec->osid = tsec->sid = tsec->ptrace_sid = SECINITSID_UNLABELED;
-	task->security = tsec;
+	task->sec->security = tsec;
 
 	return 0;
 }
 
 static void task_free_security(struct task_struct *task)
 {
-	struct task_security_struct *tsec = task->security;
-	task->security = NULL;
+	struct task_security_struct *tsec = task->sec->security;
+	task->sec->security = NULL;
 	kfree(tsec);
 }
 
 static int inode_alloc_security(struct inode *inode)
 {
-	struct task_security_struct *tsec = current->security;
+	struct task_security_struct *tsec = current->act_as->security;
 	struct inode_security_struct *isec;
 
 	isec = kmem_cache_zalloc(sel_inode_cache, GFP_KERNEL);
@@ -211,7 +211,7 @@ static void inode_free_security(struct inode *inode)
 
 static int file_alloc_security(struct file *file)
 {
-	struct task_security_struct *tsec = current->security;
+	struct task_security_struct *tsec = current->act_as->security;
 	struct file_security_struct *fsec;
 
 	fsec = kzalloc(sizeof(struct file_security_struct), GFP_KERNEL);
@@ -561,7 +561,7 @@ static int selinux_set_mnt_opts(struct super_block *sb, char **mount_options,
 				int *flags, int num_opts)
 {
 	int rc = 0, i;
-	struct task_security_struct *tsec = current->security;
+	struct task_security_struct *tsec = current->act_as->security;
 	struct superblock_security_struct *sbsec = sb->s_security;
 	const char *name = sb->s_type->name;
 	struct inode *inode = sbsec->sb->s_root->d_inode;
@@ -1266,8 +1266,8 @@ static int task_has_perm(struct task_struct *tsk1,
 {
 	struct task_security_struct *tsec1, *tsec2;
 
-	tsec1 = tsk1->security;
-	tsec2 = tsk2->security;
+	tsec1 = tsk1->act_as->security;
+	tsec2 = tsk2->sec->security;
 	return avc_has_perm(tsec1->sid, tsec2->sid,
 			    SECCLASS_PROCESS, perms, NULL);
 }
@@ -1285,7 +1285,7 @@ static int task_has_capability(struct task_struct *tsk,
 	u16 sclass;
 	u32 av = CAP_TO_MASK(cap);
 
-	tsec = tsk->security;
+	tsec = tsk->sec->security;
 
 	AVC_AUDIT_DATA_INIT(&ad,CAP);
 	ad.tsk = tsk;
@@ -1312,7 +1312,7 @@ static int task_has_system(struct task_struct *tsk,
 {
 	struct task_security_struct *tsec;
 
-	tsec = tsk->security;
+	tsec = tsk->sec->security;
 
 	return avc_has_perm(tsec->sid, SECINITSID_KERNEL,
 			    SECCLASS_SYSTEM, perms, NULL);
@@ -1333,7 +1333,7 @@ static int inode_has_perm(struct task_struct *tsk,
 	if (unlikely (IS_PRIVATE (inode)))
 		return 0;
 
-	tsec = tsk->security;
+	tsec = tsk->sec->security;
 	isec = inode->i_security;
 
 	if (!adp) {
@@ -1373,7 +1373,7 @@ static int file_has_perm(struct task_struct *tsk,
 				struct file *file,
 				u32 av)
 {
-	struct task_security_struct *tsec = tsk->security;
+	struct task_security_struct *tsec = tsk->sec->security;
 	struct file_security_struct *fsec = file->f_security;
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct avc_audit_data ad;
@@ -1410,7 +1410,7 @@ static int may_create(struct inode *dir,
 	struct avc_audit_data ad;
 	int rc;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 	dsec = dir->i_security;
 	sbsec = dir->i_sb->s_security;
 
@@ -1447,7 +1447,7 @@ static int may_create_key(u32 ksid,
 {
 	struct task_security_struct *tsec;
 
-	tsec = ctx->security;
+	tsec = ctx->sec->security;
 
 	return avc_has_perm(tsec->sid, ksid, SECCLASS_KEY, KEY__CREATE, NULL);
 }
@@ -1468,7 +1468,7 @@ static int may_link(struct inode *dir,
 	u32 av;
 	int rc;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 	dsec = dir->i_security;
 	isec = dentry->d_inode->i_security;
 
@@ -1512,7 +1512,7 @@ static inline int may_rename(struct inode *old_dir,
 	int old_is_dir, new_is_dir;
 	int rc;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 	old_dsec = old_dir->i_security;
 	old_isec = old_dentry->d_inode->i_security;
 	old_is_dir = S_ISDIR(old_dentry->d_inode->i_mode);
@@ -1565,7 +1565,7 @@ static int superblock_has_perm(struct task_struct *tsk,
 	struct task_security_struct *tsec;
 	struct superblock_security_struct *sbsec;
 
-	tsec = tsk->security;
+	tsec = tsk->act_as->security;
 	sbsec = sb->s_security;
 	return avc_has_perm(tsec->sid, sbsec->sid, SECCLASS_FILESYSTEM,
 			    perms, ad);
@@ -1620,8 +1620,8 @@ static inline u32 file_to_av(struct file *file)
 
 static int selinux_ptrace(struct task_struct *parent, struct task_struct *child)
 {
-	struct task_security_struct *psec = parent->security;
-	struct task_security_struct *csec = child->security;
+	struct task_security_struct *psec = parent->act_as->security;
+	struct task_security_struct *csec = child->sec->security;
 	int rc;
 
 	rc = secondary_ops->ptrace(parent,child);
@@ -1729,7 +1729,7 @@ static int selinux_sysctl(ctl_table *table, int op)
 	if (rc)
 		return rc;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 
 	rc = selinux_sysctl_get_sid(table, (op == 0001) ?
 				    SECCLASS_DIR : SECCLASS_FILE, &tsid);
@@ -1838,7 +1838,7 @@ static int selinux_syslog(int type)
 static int selinux_vm_enough_memory(struct mm_struct *mm, long pages)
 {
 	int rc, cap_sys_admin = 0;
-	struct task_security_struct *tsec = current->security;
+	struct task_security_struct *tsec = current->act_as->security;
 
 	rc = secondary_ops->capable(current, CAP_SYS_ADMIN);
 	if (rc == 0)
@@ -1891,7 +1891,7 @@ static int selinux_bprm_set_security(struct linux_binprm *bprm)
 	if (bsec->set)
 		return 0;
 
-	tsec = current->security;
+	tsec = current->sec->security;
 	isec = inode->i_security;
 
 	/* Default to the current task SID. */
@@ -1956,7 +1956,7 @@ static int selinux_bprm_check_security (struct linux_binprm *bprm)
 
 static int selinux_bprm_secureexec (struct linux_binprm *bprm)
 {
-	struct task_security_struct *tsec = current->security;
+	struct task_security_struct *tsec = current->sec->security;
 	int atsecure = 0;
 
 	if (tsec->osid != tsec->sid) {
@@ -2079,7 +2079,7 @@ static void selinux_bprm_apply_creds(struct linux_binprm *bprm, int unsafe)
 
 	secondary_ops->bprm_apply_creds(bprm, unsafe);
 
-	tsec = current->security;
+	tsec = current->sec->security;
 
 	bsec = bprm->security;
 	sid = bsec->sid;
@@ -2124,7 +2124,7 @@ static void selinux_bprm_post_apply_creds(struct linux_binprm *bprm)
 	struct bprm_security_struct *bsec;
 	int rc, i;
 
-	tsec = current->security;
+	tsec = current->sec->security;
 	bsec = bprm->security;
 
 	if (bsec->unsafe) {
@@ -2379,7 +2379,7 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
 	int rc;
 	char *namep = NULL, *context;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 	dsec = dir->i_security;
 	sbsec = dir->i_sb->s_security;
 
@@ -2564,7 +2564,7 @@ static int selinux_inode_setotherxattr(struct dentry *dentry, char *name)
 
 static int selinux_inode_setxattr(struct dentry *dentry, char *name, void *value, size_t size, int flags)
 {
-	struct task_security_struct *tsec = current->security;
+	struct task_security_struct *tsec = current->act_as->security;
 	struct inode *inode = dentry->d_inode;
 	struct inode_security_struct *isec = inode->i_security;
 	struct superblock_security_struct *sbsec;
@@ -2751,7 +2751,7 @@ static int selinux_revalidate_file_permission(struct file *file, int mask)
 static int selinux_file_permission(struct file *file, int mask)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
-	struct task_security_struct *tsec = current->security;
+	struct task_security_struct *tsec = current->act_as->security;
 	struct file_security_struct *fsec = file->f_security;
 	struct inode_security_struct *isec = inode->i_security;
 
@@ -2859,7 +2859,8 @@ static int selinux_file_mmap(struct file *file, unsigned long reqprot,
 			     unsigned long addr, unsigned long addr_only)
 {
 	int rc = 0;
-	u32 sid = ((struct task_security_struct*)(current->security))->sid;
+	u32 sid = ((struct task_security_struct *)
+		   (current->act_as->security))->sid;
 
 	if (addr < mmap_min_addr)
 		rc = avc_has_perm(sid, sid, SECCLASS_MEMPROTECT,
@@ -2971,7 +2972,7 @@ static int selinux_file_set_fowner(struct file *file)
 	struct task_security_struct *tsec;
 	struct file_security_struct *fsec;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 	fsec = file->f_security;
 	fsec->fown_sid = tsec->sid;
 
@@ -2989,7 +2990,7 @@ static int selinux_file_send_sigiotask(struct task_struct *tsk,
 	/* struct fown_struct is never outside the context of a struct file */
         file = container_of(fown, struct file, f_owner);
 
-	tsec = tsk->security;
+	tsec = tsk->sec->security;
 	fsec = file->f_security;
 
 	if (!signum)
@@ -3052,12 +3053,12 @@ static int selinux_task_alloc_security(struct task_struct *tsk)
 	struct task_security_struct *tsec1, *tsec2;
 	int rc;
 
-	tsec1 = current->security;
+	tsec1 = current->act_as->security;
 
 	rc = task_alloc_security(tsk);
 	if (rc)
 		return rc;
-	tsec2 = tsk->security;
+	tsec2 = tsk->sec->security;
 
 	tsec2->osid = tsec1->osid;
 	tsec2->sid = tsec1->sid;
@@ -3214,7 +3215,7 @@ static int selinux_task_kill(struct task_struct *p, struct siginfo *info,
 		perm = PROCESS__SIGNULL; /* null signal; existence test */
 	else
 		perm = signal_to_av(sig);
-	tsec = p->security;
+	tsec = p->sec->security;
 	if (secid)
 		rc = avc_has_perm(secid, tsec->sid, SECCLASS_PROCESS, perm, NULL);
 	else
@@ -3245,7 +3246,7 @@ static void selinux_task_reparent_to_init(struct task_struct *p)
 
 	secondary_ops->task_reparent_to_init(p);
 
-	tsec = p->security;
+	tsec = p->sec->security;
 	tsec->osid = tsec->sid;
 	tsec->sid = SECINITSID_KERNEL;
 	return;
@@ -3254,7 +3255,7 @@ static void selinux_task_reparent_to_init(struct task_struct *p)
 static void selinux_task_to_inode(struct task_struct *p,
 				  struct inode *inode)
 {
-	struct task_security_struct *tsec = p->security;
+	struct task_security_struct *tsec = p->sec->security;
 	struct inode_security_struct *isec = inode->i_security;
 
 	isec->sid = tsec->sid;
@@ -3496,7 +3497,7 @@ static int socket_has_perm(struct task_struct *task, struct socket *sock,
 	struct avc_audit_data ad;
 	int err = 0;
 
-	tsec = task->security;
+	tsec = task->act_as->security;
 	isec = SOCK_INODE(sock)->i_security;
 
 	if (isec->sid == SECINITSID_KERNEL)
@@ -3520,7 +3521,7 @@ static int selinux_socket_create(int family, int type,
 	if (kern)
 		goto out;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 	newsid = tsec->sockcreate_sid ? : tsec->sid;
 	err = avc_has_perm(tsec->sid, newsid,
 			   socket_type_to_security_class(family, type,
@@ -3541,7 +3542,7 @@ static int selinux_socket_post_create(struct socket *sock, int family,
 
 	isec = SOCK_INODE(sock)->i_security;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 	newsid = tsec->sockcreate_sid ? : tsec->sid;
 	isec->sclass = socket_type_to_security_class(family, type, protocol);
 	isec->sid = kern ? SECINITSID_KERNEL : newsid;
@@ -3587,7 +3588,7 @@ static int selinux_socket_bind(struct socket *sock, struct sockaddr *address, in
 		struct sock *sk = sock->sk;
 		u32 sid, node_perm, addrlen;
 
-		tsec = current->security;
+		tsec = current->act_as->security;
 		isec = SOCK_INODE(sock)->i_security;
 
 		if (family == PF_INET) {
@@ -4534,7 +4535,7 @@ static int ipc_alloc_security(struct task_struct *task,
 			      struct kern_ipc_perm *perm,
 			      u16 sclass)
 {
-	struct task_security_struct *tsec = task->security;
+	struct task_security_struct *tsec = task->act_as->security;
 	struct ipc_security_struct *isec;
 
 	isec = kzalloc(sizeof(struct ipc_security_struct), GFP_KERNEL);
@@ -4586,7 +4587,7 @@ static int ipc_has_perm(struct kern_ipc_perm *ipc_perms,
 	struct ipc_security_struct *isec;
 	struct avc_audit_data ad;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 	isec = ipc_perms->security;
 
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
@@ -4617,7 +4618,7 @@ static int selinux_msg_queue_alloc_security(struct msg_queue *msq)
 	if (rc)
 		return rc;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 	isec = msq->q_perm.security;
 
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
@@ -4643,7 +4644,7 @@ static int selinux_msg_queue_associate(struct msg_queue *msq, int msqflg)
 	struct ipc_security_struct *isec;
 	struct avc_audit_data ad;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 	isec = msq->q_perm.security;
 
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
@@ -4689,7 +4690,7 @@ static int selinux_msg_queue_msgsnd(struct msg_queue *msq, struct msg_msg *msg,
 	struct avc_audit_data ad;
 	int rc;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 	isec = msq->q_perm.security;
 	msec = msg->security;
 
@@ -4737,7 +4738,7 @@ static int selinux_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
 	struct avc_audit_data ad;
 	int rc;
 
-	tsec = target->security;
+	tsec = target->act_as->security;
 	isec = msq->q_perm.security;
 	msec = msg->security;
 
@@ -4764,7 +4765,7 @@ static int selinux_shm_alloc_security(struct shmid_kernel *shp)
 	if (rc)
 		return rc;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 	isec = shp->shm_perm.security;
 
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
@@ -4790,7 +4791,7 @@ static int selinux_shm_associate(struct shmid_kernel *shp, int shmflg)
 	struct ipc_security_struct *isec;
 	struct avc_audit_data ad;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 	isec = shp->shm_perm.security;
 
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
@@ -4863,7 +4864,7 @@ static int selinux_sem_alloc_security(struct sem_array *sma)
 	if (rc)
 		return rc;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 	isec = sma->sem_perm.security;
 
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
@@ -4889,7 +4890,7 @@ static int selinux_sem_associate(struct sem_array *sma, int semflg)
 	struct ipc_security_struct *isec;
 	struct avc_audit_data ad;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 	isec = sma->sem_perm.security;
 
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
@@ -5008,7 +5009,7 @@ static int selinux_getprocattr(struct task_struct *p,
 			return error;
 	}
 
-	tsec = p->security;
+	tsec = p->sec->security;
 
 	if (!strcmp(name, "current"))
 		sid = tsec->sid;
@@ -5085,7 +5086,7 @@ static int selinux_setprocattr(struct task_struct *p,
 	   operation.  See selinux_bprm_set_security for the execve
 	   checks and may_create for the file creation checks. The
 	   operation will then fail if the context is not permitted. */
-	tsec = p->security;
+	tsec = p->sec->security;
 	if (!strcmp(name, "exec"))
 		tsec->exec_sid = sid;
 	else if (!strcmp(name, "fscreate"))
@@ -5168,7 +5169,7 @@ static void selinux_release_secctx(char *secdata, u32 seclen)
 static int selinux_key_alloc(struct key *k, struct task_struct *tsk,
 			     unsigned long flags)
 {
-	struct task_security_struct *tsec = tsk->security;
+	struct task_security_struct *tsec = tsk->sec->security;
 	struct key_security_struct *ksec;
 
 	ksec = kzalloc(sizeof(struct key_security_struct), GFP_KERNEL);
@@ -5203,7 +5204,7 @@ static int selinux_key_permission(key_ref_t key_ref,
 
 	key = key_ref_to_ptr(key_ref);
 
-	tsec = ctx->security;
+	tsec = ctx->sec->security;
 	ksec = key->security;
 
 	/* if no specific permissions are requested, we skip the
@@ -5430,7 +5431,7 @@ static __init int selinux_init(void)
 	/* Set the security state for the initial task. */
 	if (task_alloc_security(current))
 		panic("SELinux:  Failed to initialize initial task.\n");
-	tsec = current->security;
+	tsec = current->sec->security;
 	tsec->osid = tsec->sid = SECINITSID_KERNEL;
 
 	sel_inode_cache = kmem_cache_create("selinux_inode_security",
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 0341567..c245a14 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -93,7 +93,7 @@ static int task_has_security(struct task_struct *tsk,
 {
 	struct task_security_struct *tsec;
 
-	tsec = tsk->security;
+	tsec = tsk->act_as->security;
 	if (!tsec)
 		return -EACCES;
 
diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
index 7e15820..562f790 100644
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -201,7 +201,7 @@ static int selinux_xfrm_sec_ctx_alloc(struct xfrm_sec_ctx **ctxp,
 	struct xfrm_user_sec_ctx *uctx, u32 sid)
 {
 	int rc = 0;
-	struct task_security_struct *tsec = current->security;
+	struct task_security_struct *tsec = current->act_as->security;
 	struct xfrm_sec_ctx *ctx = NULL;
 	char *ctx_str = NULL;
 	u32 str_len;
@@ -342,7 +342,7 @@ void selinux_xfrm_policy_free(struct xfrm_policy *xp)
  */
 int selinux_xfrm_policy_delete(struct xfrm_policy *xp)
 {
-	struct task_security_struct *tsec = current->security;
+	struct task_security_struct *tsec = current->act_as->security;
 	struct xfrm_sec_ctx *ctx = xp->security;
 	int rc = 0;
 
@@ -389,7 +389,7 @@ void selinux_xfrm_state_free(struct xfrm_state *x)
   */
 int selinux_xfrm_state_delete(struct xfrm_state *x)
 {
-	struct task_security_struct *tsec = current->security;
+	struct task_security_struct *tsec = current->act_as->security;
 	struct xfrm_sec_ctx *ctx = x->security;
 	int rc = 0;
 
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index f6b5f6e..722752f 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -164,7 +164,7 @@ int smk_curacc(char *obj_label, u32 mode)
 {
 	int rc;
 
-	rc = smk_access(current->security, obj_label, mode);
+	rc = smk_access(current->act_as->security, obj_label, mode);
 	if (rc == 0)
 		return 0;
 
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 25cbfa3..a49d94f 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -102,7 +102,8 @@ static int smack_ptrace(struct task_struct *ptp, struct task_struct *ctp)
 	if (rc != 0)
 		return rc;
 
-	rc = smk_access(ptp->security, ctp->security, MAY_READWRITE);
+	rc = smk_access(ptp->act_as->security, ctp->sec->security,
+			MAY_READWRITE);
 	if (rc != 0 && __capable(ptp, CAP_MAC_OVERRIDE))
 		return 0;
 
@@ -120,7 +121,7 @@ static int smack_ptrace(struct task_struct *ptp, struct task_struct *ctp)
 static int smack_syslog(int type)
 {
 	int rc;
-	char *sp = current->security;
+	char *sp = current->act_as->security;
 
 	rc = cap_syslog(type);
 	if (rc != 0)
@@ -359,7 +360,7 @@ static int smack_sb_umount(struct vfsmount *mnt, int flags)
  */
 static int smack_inode_alloc_security(struct inode *inode)
 {
-	inode->i_security = new_inode_smack(current->security);
+	inode->i_security = new_inode_smack(current->act_as->security);
 	if (inode->i_security == NULL)
 		return -ENOMEM;
 	return 0;
@@ -777,7 +778,7 @@ static int smack_file_permission(struct file *file, int mask)
  */
 static int smack_file_alloc_security(struct file *file)
 {
-	file->f_security = current->security;
+	file->f_security = current->act_as->security;
 	return 0;
 }
 
@@ -875,7 +876,7 @@ static int smack_file_fcntl(struct file *file, unsigned int cmd,
  */
 static int smack_file_set_fowner(struct file *file)
 {
-	file->f_security = current->security;
+	file->f_security = current->act_as->security;
 	return 0;
 }
 
@@ -900,7 +901,7 @@ static int smack_file_send_sigiotask(struct task_struct *tsk,
 	 * struct fown_struct is never outside the context of a struct file
 	 */
 	file = container_of(fown, struct file, f_owner);
-	rc = smk_access(file->f_security, tsk->security, MAY_WRITE);
+	rc = smk_access(file->f_security, tsk->sec->security, MAY_WRITE);
 	if (rc != 0 && __capable(tsk, CAP_MAC_OVERRIDE))
 		return 0;
 	return rc;
@@ -943,7 +944,7 @@ static int smack_file_receive(struct file *file)
  */
 static int smack_task_alloc_security(struct task_struct *tsk)
 {
-	tsk->security = current->security;
+	tsk->sec->security = current->act_as->security;
 
 	return 0;
 }
@@ -958,7 +959,7 @@ static int smack_task_alloc_security(struct task_struct *tsk)
  */
 static void smack_task_free_security(struct task_struct *task)
 {
-	task->security = NULL;
+	task->sec->security = NULL;
 }
 
 /**
@@ -970,7 +971,7 @@ static void smack_task_free_security(struct task_struct *task)
  */
 static int smack_task_setpgid(struct task_struct *p, pid_t pgid)
 {
-	return smk_curacc(p->security, MAY_WRITE);
+	return smk_curacc(p->sec->security, MAY_WRITE);
 }
 
 /**
@@ -981,7 +982,7 @@ static int smack_task_setpgid(struct task_struct *p, pid_t pgid)
  */
 static int smack_task_getpgid(struct task_struct *p)
 {
-	return smk_curacc(p->security, MAY_READ);
+	return smk_curacc(p->sec->security, MAY_READ);
 }
 
 /**
@@ -992,7 +993,7 @@ static int smack_task_getpgid(struct task_struct *p)
  */
 static int smack_task_getsid(struct task_struct *p)
 {
-	return smk_curacc(p->security, MAY_READ);
+	return smk_curacc(p->sec->security, MAY_READ);
 }
 
 /**
@@ -1004,7 +1005,7 @@ static int smack_task_getsid(struct task_struct *p)
  */
 static void smack_task_getsecid(struct task_struct *p, u32 *secid)
 {
-	*secid = smack_to_secid(p->security);
+	*secid = smack_to_secid(p->sec->security);
 }
 
 /**
@@ -1016,7 +1017,7 @@ static void smack_task_getsecid(struct task_struct *p, u32 *secid)
  */
 static int smack_task_setnice(struct task_struct *p, int nice)
 {
-	return smk_curacc(p->security, MAY_WRITE);
+	return smk_curacc(p->sec->security, MAY_WRITE);
 }
 
 /**
@@ -1028,7 +1029,7 @@ static int smack_task_setnice(struct task_struct *p, int nice)
  */
 static int smack_task_setioprio(struct task_struct *p, int ioprio)
 {
-	return smk_curacc(p->security, MAY_WRITE);
+	return smk_curacc(p->sec->security, MAY_WRITE);
 }
 
 /**
@@ -1039,7 +1040,7 @@ static int smack_task_setioprio(struct task_struct *p, int ioprio)
  */
 static int smack_task_getioprio(struct task_struct *p)
 {
-	return smk_curacc(p->security, MAY_READ);
+	return smk_curacc(p->sec->security, MAY_READ);
 }
 
 /**
@@ -1053,7 +1054,7 @@ static int smack_task_getioprio(struct task_struct *p)
 static int smack_task_setscheduler(struct task_struct *p, int policy,
 				   struct sched_param *lp)
 {
-	return smk_curacc(p->security, MAY_WRITE);
+	return smk_curacc(p->sec->security, MAY_WRITE);
 }
 
 /**
@@ -1064,7 +1065,7 @@ static int smack_task_setscheduler(struct task_struct *p, int policy,
  */
 static int smack_task_getscheduler(struct task_struct *p)
 {
-	return smk_curacc(p->security, MAY_READ);
+	return smk_curacc(p->sec->security, MAY_READ);
 }
 
 /**
@@ -1075,7 +1076,7 @@ static int smack_task_getscheduler(struct task_struct *p)
  */
 static int smack_task_movememory(struct task_struct *p)
 {
-	return smk_curacc(p->security, MAY_WRITE);
+	return smk_curacc(p->act_as->security, MAY_WRITE);
 }
 
 /**
@@ -1107,13 +1108,13 @@ static int smack_task_kill(struct task_struct *p, struct siginfo *info,
 	 * can write the receiver.
 	 */
 	if (secid == 0)
-		return smk_curacc(p->security, MAY_WRITE);
+		return smk_curacc(p->sec->security, MAY_WRITE);
 	/*
 	 * If the secid isn't 0 we're dealing with some USB IO
 	 * specific behavior. This is not clean. For one thing
 	 * we can't take privilege into account.
 	 */
-	return smk_access(smack_from_secid(secid), p->security, MAY_WRITE);
+	return smk_access(smack_from_secid(secid), p->sec->security, MAY_WRITE);
 }
 
 /**
@@ -1126,7 +1127,7 @@ static int smack_task_wait(struct task_struct *p)
 {
 	int rc;
 
-	rc = smk_access(current->security, p->security, MAY_WRITE);
+	rc = smk_access(current->act_as->security, p->sec->security, MAY_WRITE);
 	if (rc == 0)
 		return 0;
 
@@ -1157,7 +1158,7 @@ static int smack_task_wait(struct task_struct *p)
 static void smack_task_to_inode(struct task_struct *p, struct inode *inode)
 {
 	struct inode_smack *isp = inode->i_security;
-	isp->smk_inode = p->security;
+	isp->smk_inode = p->act_as->security;
 }
 
 /*
@@ -1176,7 +1177,7 @@ static void smack_task_to_inode(struct task_struct *p, struct inode *inode)
  */
 static int smack_sk_alloc_security(struct sock *sk, int family, gfp_t gfp_flags)
 {
-	char *csp = current->security;
+	char *csp = current->act_as->security;
 	struct socket_smack *ssp;
 
 	ssp = kzalloc(sizeof(struct socket_smack), gfp_flags);
@@ -1401,7 +1402,7 @@ static int smack_flags_to_may(int flags)
  */
 static int smack_msg_msg_alloc_security(struct msg_msg *msg)
 {
-	msg->security = current->security;
+	msg->security = current->act_as->security;
 	return 0;
 }
 
@@ -1437,7 +1438,7 @@ static int smack_shm_alloc_security(struct shmid_kernel *shp)
 {
 	struct kern_ipc_perm *isp = &shp->shm_perm;
 
-	isp->security = current->security;
+	isp->security = current->act_as->security;
 	return 0;
 }
 
@@ -1545,7 +1546,7 @@ static int smack_sem_alloc_security(struct sem_array *sma)
 {
 	struct kern_ipc_perm *isp = &sma->sem_perm;
 
-	isp->security = current->security;
+	isp->security = current->act_as->security;
 	return 0;
 }
 
@@ -1648,7 +1649,7 @@ static int smack_msg_queue_alloc_security(struct msg_queue *msq)
 {
 	struct kern_ipc_perm *kisp = &msq->q_perm;
 
-	kisp->security = current->security;
+	kisp->security = current->act_as->security;
 	return 0;
 }
 
@@ -1790,7 +1791,7 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
 	struct super_block *sbp;
 	struct superblock_smack *sbsp;
 	struct inode_smack *isp;
-	char *csp = current->security;
+	char *csp = current->act_as->security;
 	char *fetched;
 	char *final;
 	struct dentry *dp;
@@ -1935,7 +1936,7 @@ static int smack_getprocattr(struct task_struct *p, char *name, char **value)
 	if (strcmp(name, "current") != 0)
 		return -EINVAL;
 
-	cp = kstrdup(p->security, GFP_KERNEL);
+	cp = kstrdup(p->sec->security, GFP_KERNEL);
 	if (cp == NULL)
 		return -ENOMEM;
 
@@ -1981,7 +1982,7 @@ static int smack_setprocattr(struct task_struct *p, char *name,
 	if (newsmack == NULL)
 		return -EINVAL;
 
-	p->security = newsmack;
+	p->sec->security = newsmack;
 	return size;
 }
 
@@ -2211,8 +2212,8 @@ static void smack_sock_graft(struct sock *sk, struct socket *parent)
 		return;
 
 	ssp = sk->sk_security;
-	ssp->smk_in = current->security;
-	ssp->smk_out = current->security;
+	ssp->smk_in = current->act_as->security;
+	ssp->smk_out = current->act_as->security;
 	ssp->smk_packet[0] = '\0';
 
 	rc = smack_netlabel(sk);
@@ -2285,7 +2286,7 @@ static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 static int smack_key_alloc(struct key *key, struct task_struct *tsk,
 			   unsigned long flags)
 {
-	key->security = tsk->security;
+	key->security = tsk->act_as->security;
 	return 0;
 }
 
@@ -2326,10 +2327,11 @@ static int smack_key_permission(key_ref_t key_ref,
 	/*
 	 * This should not occur
 	 */
-	if (context->security == NULL)
+	if (context->act_as->security == NULL)
 		return -EACCES;
 
-	return smk_access(context->security, keyp->security, MAY_READWRITE);
+	return smk_access(context->act_as->security, keyp->security,
+			  MAY_READWRITE);
 }
 #endif /* CONFIG_KEYS */
 
@@ -2510,7 +2512,7 @@ static __init int smack_init(void)
 	/*
 	 * Set the security state for the initial task.
 	 */
-	current->security = &smack_known_floor.smk_known;
+	current->sec->security = &smack_known_floor.smk_known;
 
 	/*
 	 * Initialize locks
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 358c92c..2cb3a5e 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -345,7 +345,7 @@ void smk_cipso_doi(void)
 	struct netlbl_audit audit_info;
 
 	audit_info.loginuid = audit_get_loginuid(current);
-	audit_info.secid = smack_to_secid(current->security);
+	audit_info.secid = smack_to_secid(current->sec->security);
 
 	rc = netlbl_cfg_map_del(NULL, &audit_info);
 	if (rc != 0)
@@ -377,7 +377,7 @@ void smk_unlbl_ambient(char *oldambient)
 	struct netlbl_audit audit_info;
 
 	audit_info.loginuid = audit_get_loginuid(current);
-	audit_info.secid = smack_to_secid(current->security);
+	audit_info.secid = smack_to_secid(current->sec->security);
 
 	if (oldambient != NULL) {
 		rc = netlbl_cfg_map_del(oldambient, &audit_info);

