Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbYAQROz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbYAQROz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 12:14:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbYAQROn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 12:14:43 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbYAQROl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 12:14:41 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080115234724.22183.9603.stgit@warthog.procyon.org.uk>
References: <20080115234724.22183.9603.stgit@warthog.procyon.org.uk> <20080115234652.22183.24850.stgit@warthog.procyon.org.uk>
To: sds@tycho.nsa.gov, casey@schaufler-ca.com
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Subject: [PATCH 06a/26] Extra task_struct -> task_security separation
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 17 Jan 2008 17:14:35 +0000
Message-ID: <20821.1200590075@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Extra bits for separation of task_struct -> task_security to make allyesconfig
compile for i386 and x86_64.  This will be rolled into patch 06 of 12.

From: David Howells <dhowells@redhat.com>


---

 drivers/connector/cn_proc.c |    8 ++++----
 drivers/media/video/cpia.c  |    2 +-
 drivers/net/tun.c           |    4 ++--
 drivers/net/wan/sbni.c      |    8 ++++----
 drivers/usb/core/devio.c    |    8 ++++----
 fs/dquot.c                  |    3 ++-
 kernel/sched.c              |    2 +-
 kernel/tsacct.c             |    4 ++--
 mm/mempolicy.c              |    7 +++++--
 mm/migrate.c                |    7 +++++--
 net/ax25/af_ax25.c          |    2 +-
 net/ax25/ax25_route.c       |    2 +-
 net/ipv6/ip6_flowlabel.c    |    2 +-
 net/netrom/af_netrom.c      |    4 ++--
 net/rose/af_rose.c          |    4 ++--
 security/commoncap.c        |    7 ++++---
 security/selinux/xfrm.c     |    6 +++---
 17 files changed, 44 insertions(+), 36 deletions(-)


diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index 5c9f67f..a4a453e 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -116,11 +116,11 @@ void proc_id_connector(struct task_struct *task, int which_id)
 	ev->event_data.id.process_pid = task->pid;
 	ev->event_data.id.process_tgid = task->tgid;
 	if (which_id == PROC_EVENT_UID) {
-	 	ev->event_data.id.r.ruid = task->uid;
-	 	ev->event_data.id.e.euid = task->euid;
+	 	ev->event_data.id.r.ruid = task->act_as->uid;
+	 	ev->event_data.id.e.euid = task->act_as->euid;
 	} else if (which_id == PROC_EVENT_GID) {
-	   	ev->event_data.id.r.rgid = task->gid;
-	   	ev->event_data.id.e.egid = task->egid;
+	   	ev->event_data.id.r.rgid = task->act_as->gid;
+	   	ev->event_data.id.e.egid = task->act_as->egid;
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
index f8b8c71..66c63cf 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -474,9 +474,9 @@ static int tun_set_iff(struct file *file, struct ifreq *ifr)
 
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
index 2e8b5c2..4bd60e8 100644
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
index 1f4f6d0..bc32409 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -575,8 +575,8 @@ static int usbdev_open(struct inode *inode, struct file *file)
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
@@ -1082,8 +1082,8 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
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
diff --git a/fs/dquot.c b/fs/dquot.c
index eb4f9f1..e240e4c 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -955,7 +955,8 @@ static void send_warning(const struct dquot *dquot, const char warntype)
 		MINOR(dquot->dq_sb->s_dev));
 	if (ret)
 		goto attr_err_out;
-	ret = nla_put_u64(skb, QUOTA_NL_A_CAUSED_ID, current->user->uid);
+	ret = nla_put_u64(skb, QUOTA_NL_A_CAUSED_ID,
+			  current->act_as->user->uid);
 	if (ret)
 		goto attr_err_out;
 	genlmsg_end(skb, msg_head);
diff --git a/kernel/sched.c b/kernel/sched.c
index 0084245..f5df6f4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -204,7 +204,7 @@ static inline struct task_group *task_group(struct task_struct *p)
 	struct task_group *tg;
 
 #ifdef CONFIG_FAIR_USER_SCHED
-	tg = p->user->tg;
+	tg = p->sec->user->tg;
 #elif defined(CONFIG_FAIR_CGROUP_SCHED)
 	tg = container_of(task_subsys_state(p, cpu_cgroup_subsys_id),
 				struct task_group, css);
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
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 83c69f8..f7a3078 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -941,6 +941,7 @@ asmlinkage long sys_migrate_pages(pid_t pid, unsigned long maxnode,
 		const unsigned long __user *old_nodes,
 		const unsigned long __user *new_nodes)
 {
+	struct task_security *act_as, *obj;
 	struct mm_struct *mm;
 	struct task_struct *task;
 	nodemask_t old;
@@ -975,8 +976,10 @@ asmlinkage long sys_migrate_pages(pid_t pid, unsigned long maxnode,
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
index ebaf557..0778cce 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -909,6 +909,7 @@ asmlinkage long sys_move_pages(pid_t pid, unsigned long nr_pages,
 			const int __user *nodes,
 			int __user *status, int flags)
 {
+	struct task_security *act_as, *obj;
 	int err = 0;
 	int i;
 	struct task_struct *task;
@@ -942,8 +943,10 @@ asmlinkage long sys_move_pages(pid_t pid, unsigned long nr_pages,
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
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index b4725ff..0181b89 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1052,7 +1052,7 @@ static int ax25_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	if (addr->fsa_ax25.sax25_family != AF_AX25)
 		return -EINVAL;
 
-	user = ax25_findbyuid(current->euid);
+	user = ax25_findbyuid(current->act_as->euid);
 	if (user) {
 		call = user->call;
 		ax25_uid_put(user);
diff --git a/net/ax25/ax25_route.c b/net/ax25/ax25_route.c
index 9ecf6f1..25978fb 100644
--- a/net/ax25/ax25_route.c
+++ b/net/ax25/ax25_route.c
@@ -419,7 +419,7 @@ int ax25_rt_autobind(ax25_cb *ax25, ax25_address *addr)
 		goto put;
 	}
 
-	user = ax25_findbyuid(current->euid);
+	user = ax25_findbyuid(current->act_as->euid);
 	if (user) {
 		ax25->source_addr = user->call;
 		ax25_uid_put(user);
diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
index b12cc22..e3a7d66 100644
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
index ed2d65c..e394077 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -670,7 +670,7 @@ static int rose_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 
 	source = &addr->srose_call;
 
-	user = ax25_findbyuid(current->euid);
+	user = ax25_findbyuid(current->act_as->euid);
 	if (user) {
 		rose->source_call = user->call;
 		ax25_uid_put(user);
@@ -769,7 +769,7 @@ static int rose_connect(struct socket *sock, struct sockaddr *uaddr, int addr_le
 			goto out_release;
 		}
 
-		user = ax25_findbyuid(current->euid);
+		user = ax25_findbyuid(current->act_as->euid);
 		if (!user) {
 			err = -EINVAL;
 			goto out_release;
diff --git a/security/commoncap.c b/security/commoncap.c
index 13c21c7..2c2ecd0 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -513,7 +513,8 @@ int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid,
  */
 static inline int cap_safe_nice(struct task_struct *p)
 {
-	if (!cap_issubset(p->cap_permitted, current->cap_permitted) &&
+	if (!cap_issubset(p->sec->cap_permitted,
+			  current->act_as->cap_permitted) &&
 	    !__capable(current, CAP_SYS_NICE))
 		return -EPERM;
 	return 0;
@@ -547,7 +548,7 @@ int cap_task_kill(struct task_struct *p, struct siginfo *info,
 	 * allowed.
 	 * We must preserve legacy signal behavior in this case.
 	 */
-	if (p->euid == 0 && p->uid == current->uid)
+	if (p->sec->euid == 0 && p->sec->uid == current->act_as->uid)
 		return 0;
 
 	/* sigcont is permitted within same session */
@@ -562,7 +563,7 @@ int cap_task_kill(struct task_struct *p, struct siginfo *info,
 		 * Used only by usb drivers?
 		 */
 		return 0;
-	if (cap_issubset(p->cap_permitted, current->cap_permitted))
+	if (cap_issubset(p->sec->cap_permitted, current->act_as->cap_permitted))
 		return 0;
 	if (capable(CAP_KILL))
 		return 0;
diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
index e076039..5291919 100644
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -198,7 +198,7 @@ static int selinux_xfrm_sec_ctx_alloc(struct xfrm_sec_ctx **ctxp,
 	struct xfrm_user_sec_ctx *uctx, u32 sid)
 {
 	int rc = 0;
-	struct task_security_struct *tsec = current->security;
+	struct task_security_struct *tsec = current->act_as->security;
 	struct xfrm_sec_ctx *ctx = NULL;
 	char *ctx_str = NULL;
 	u32 str_len;
@@ -336,7 +336,7 @@ void selinux_xfrm_policy_free(struct xfrm_policy *xp)
  */
 int selinux_xfrm_policy_delete(struct xfrm_policy *xp)
 {
-	struct task_security_struct *tsec = current->security;
+	struct task_security_struct *tsec = current->act_as->security;
 	struct xfrm_sec_ctx *ctx = xp->security;
 	int rc = 0;
 
@@ -378,7 +378,7 @@ void selinux_xfrm_state_free(struct xfrm_state *x)
   */
 int selinux_xfrm_state_delete(struct xfrm_state *x)
 {
-	struct task_security_struct *tsec = current->security;
+	struct task_security_struct *tsec = current->act_as->security;
 	struct xfrm_sec_ctx *ctx = x->security;
 	int rc = 0;
 
