Return-Path: <linux-kernel-owner+w=401wt.eu-S1761047AbYHFPm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761047AbYHFPm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759959AbYHFPjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:39:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758176AbYHFPjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:39:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 20/24] CRED: Use creds in file structs [ver #7]
To: jmorris@namei.org, akpm@linux-foundation.org, morgan@kernel.org
Cc: sfr@canb.auug.org.au, dhowells@redhat.com, viro@ftp.linux.org.uk,
       casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Wed, 06 Aug 2008 16:38:57 +0100
Message-ID: <20080806153857.14351.95784.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
References: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attach creds to file structs and discard f_uid/f_gid.

file_operations::open() methods (such as hppfs_open()) should use file->f_cred
rather than current_cred().  At the moment file->f_cred will be current_cred()
at this point.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
---

 arch/mips/kernel/vpe.c              |    4 ++--
 drivers/isdn/hysdn/hysdn_procconf.c |    6 ++++--
 fs/coda/file.c                      |    2 +-
 fs/file_table.c                     |    7 ++++---
 fs/hppfs/hppfs.c                    |    4 ++--
 include/linux/fs.h                  |    2 +-
 net/ipv4/netfilter/ipt_LOG.c        |    4 ++--
 net/ipv6/netfilter/ip6t_LOG.c       |    4 ++--
 net/netfilter/nfnetlink_log.c       |    5 +++--
 net/netfilter/xt_owner.c            |   16 ++++++++--------
 net/sched/cls_flow.c                |    4 ++--
 11 files changed, 31 insertions(+), 27 deletions(-)


diff --git a/arch/mips/kernel/vpe.c b/arch/mips/kernel/vpe.c
index 972b2d2..09786e4 100644
--- a/arch/mips/kernel/vpe.c
+++ b/arch/mips/kernel/vpe.c
@@ -1085,8 +1085,8 @@ static int vpe_open(struct inode *inode, struct file *filp)
 	v->load_addr = NULL;
 	v->len = 0;
 
-	v->uid = filp->f_uid;
-	v->gid = filp->f_gid;
+	v->uid = filp->f_cred->fsuid;
+	v->gid = filp->f_cred->fsgid;
 
 #ifdef CONFIG_MIPS_APSP_KSPD
 	/* get kspd to tell us when a syscall_exit happens */
diff --git a/drivers/isdn/hysdn/hysdn_procconf.c b/drivers/isdn/hysdn/hysdn_procconf.c
index 484299b..8f9f491 100644
--- a/drivers/isdn/hysdn/hysdn_procconf.c
+++ b/drivers/isdn/hysdn/hysdn_procconf.c
@@ -246,7 +246,8 @@ hysdn_conf_open(struct inode *ino, struct file *filep)
 	}
 	if (card->debug_flags & (LOG_PROC_OPEN | LOG_PROC_ALL))
 		hysdn_addlog(card, "config open for uid=%d gid=%d mode=0x%x",
-			     filep->f_uid, filep->f_gid, filep->f_mode);
+			     filep->f_cred->fsuid, filep->f_cred->fsgid,
+			     filep->f_mode);
 
 	if ((filep->f_mode & (FMODE_READ | FMODE_WRITE)) == FMODE_WRITE) {
 		/* write only access -> write boot file or conf line */
@@ -331,7 +332,8 @@ hysdn_conf_close(struct inode *ino, struct file *filep)
 	}
 	if (card->debug_flags & (LOG_PROC_OPEN | LOG_PROC_ALL))
 		hysdn_addlog(card, "config close for uid=%d gid=%d mode=0x%x",
-			     filep->f_uid, filep->f_gid, filep->f_mode);
+			     filep->f_cred->fsuid, filep->f_cred->fsgid,
+			     filep->f_mode);
 
 	if ((filep->f_mode & (FMODE_READ | FMODE_WRITE)) == FMODE_WRITE) {
 		/* write only access -> write boot file or conf line */
diff --git a/fs/coda/file.c b/fs/coda/file.c
index 29137ff..5a87699 100644
--- a/fs/coda/file.c
+++ b/fs/coda/file.c
@@ -174,7 +174,7 @@ int coda_release(struct inode *coda_inode, struct file *coda_file)
 	BUG_ON(!cfi || cfi->cfi_magic != CODA_MAGIC);
 
 	err = venus_close(coda_inode->i_sb, coda_i2f(coda_inode),
-			  coda_flags, coda_file->f_uid);
+			  coda_flags, coda_file->f_cred->fsuid);
 
 	host_inode = cfi->cfi_container->f_path.dentry->d_inode;
 	cii = ITOC(coda_inode);
diff --git a/fs/file_table.c b/fs/file_table.c
index 4183190..d2ae1de 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -36,7 +36,9 @@ static struct percpu_counter nr_files __cacheline_aligned_in_smp;
 
 static inline void file_free_rcu(struct rcu_head *head)
 {
-	struct file *f =  container_of(head, struct file, f_u.fu_rcuhead);
+	struct file *f = container_of(head, struct file, f_u.fu_rcuhead);
+
+	put_cred(f->f_cred);
 	kmem_cache_free(filp_cachep, f);
 }
 
@@ -121,8 +123,7 @@ struct file *get_empty_filp(void)
 	INIT_LIST_HEAD(&f->f_u.fu_list);
 	atomic_long_set(&f->f_count, 1);
 	rwlock_init(&f->f_owner.lock);
-	f->f_uid = cred->fsuid;
-	f->f_gid = cred->fsgid;
+	f->f_cred = get_cred(cred);
 	eventpoll_init_file(f);
 	/* f->f_version: 0 */
 	return f;
diff --git a/fs/hppfs/hppfs.c b/fs/hppfs/hppfs.c
index 795e2c1..b278f7f 100644
--- a/fs/hppfs/hppfs.c
+++ b/fs/hppfs/hppfs.c
@@ -426,7 +426,7 @@ static int file_mode(int fmode)
 
 static int hppfs_open(struct inode *inode, struct file *file)
 {
-	const struct cred *cred = current_cred();
+	const struct cred *cred = file->f_cred;
 	struct hppfs_private *data;
 	struct vfsmount *proc_mnt;
 	struct dentry *proc_dentry;
@@ -490,7 +490,7 @@ static int hppfs_open(struct inode *inode, struct file *file)
 
 static int hppfs_dir_open(struct inode *inode, struct file *file)
 {
-	const struct cred *cred = current_cred();
+	const struct cred *cred = file->f_cred;
 	struct hppfs_private *data;
 	struct vfsmount *proc_mnt;
 	struct dentry *proc_dentry;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d4e0016..057317c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -824,7 +824,7 @@ struct file {
 	mode_t			f_mode;
 	loff_t			f_pos;
 	struct fown_struct	f_owner;
-	unsigned int		f_uid, f_gid;
+	const struct cred	*f_cred;
 	struct file_ra_state	f_ra;
 
 	u64			f_version;
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index 0af1413..dde984a 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -340,8 +340,8 @@ static void dump_packet(const struct nf_loginfo *info,
 		read_lock_bh(&skb->sk->sk_callback_lock);
 		if (skb->sk->sk_socket && skb->sk->sk_socket->file)
 			printk("UID=%u GID=%u ",
-				skb->sk->sk_socket->file->f_uid,
-				skb->sk->sk_socket->file->f_gid);
+				skb->sk->sk_socket->file->f_cred->fsuid,
+				skb->sk->sk_socket->file->f_cred->fsgid);
 		read_unlock_bh(&skb->sk->sk_callback_lock);
 	}
 
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index 3a23169..8d91b23 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -364,8 +364,8 @@ static void dump_packet(const struct nf_loginfo *info,
 		read_lock_bh(&skb->sk->sk_callback_lock);
 		if (skb->sk->sk_socket && skb->sk->sk_socket->file)
 			printk("UID=%u GID=%u ",
-				skb->sk->sk_socket->file->f_uid,
-				skb->sk->sk_socket->file->f_gid);
+				skb->sk->sk_socket->file->f_cred->fsuid,
+				skb->sk->sk_socket->file->f_cred->fsgid);
 		read_unlock_bh(&skb->sk->sk_callback_lock);
 	}
 
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 9a35b57..7659bcf 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -474,8 +474,9 @@ __build_packet_message(struct nfulnl_instance *inst,
 	if (skb->sk) {
 		read_lock_bh(&skb->sk->sk_callback_lock);
 		if (skb->sk->sk_socket && skb->sk->sk_socket->file) {
-			__be32 uid = htonl(skb->sk->sk_socket->file->f_uid);
-			__be32 gid = htonl(skb->sk->sk_socket->file->f_gid);
+			struct file *file = skb->sk->sk_socket->file;
+			__be32 uid = htonl(file->f_cred->fsuid);
+			__be32 gid = htonl(file->f_cred->fsgid);
 			/* need to unlock here since NLA_PUT may goto */
 			read_unlock_bh(&skb->sk->sk_callback_lock);
 			NLA_PUT_BE32(inst->skb, NFULA_UID, uid);
diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
index 9059c16..b8c53e8 100644
--- a/net/netfilter/xt_owner.c
+++ b/net/netfilter/xt_owner.c
@@ -37,12 +37,12 @@ owner_mt_v0(const struct sk_buff *skb, const struct net_device *in,
 		return false;
 
 	if (info->match & IPT_OWNER_UID)
-		if ((filp->f_uid != info->uid) ^
+		if ((filp->f_cred->fsuid != info->uid) ^
 		    !!(info->invert & IPT_OWNER_UID))
 			return false;
 
 	if (info->match & IPT_OWNER_GID)
-		if ((filp->f_gid != info->gid) ^
+		if ((filp->f_cred->fsgid != info->gid) ^
 		    !!(info->invert & IPT_OWNER_GID))
 			return false;
 
@@ -66,12 +66,12 @@ owner_mt6_v0(const struct sk_buff *skb, const struct net_device *in,
 		return false;
 
 	if (info->match & IP6T_OWNER_UID)
-		if ((filp->f_uid != info->uid) ^
+		if ((filp->f_cred->fsuid != info->uid) ^
 		    !!(info->invert & IP6T_OWNER_UID))
 			return false;
 
 	if (info->match & IP6T_OWNER_GID)
-		if ((filp->f_gid != info->gid) ^
+		if ((filp->f_cred->fsgid != info->gid) ^
 		    !!(info->invert & IP6T_OWNER_GID))
 			return false;
 
@@ -102,14 +102,14 @@ owner_mt(const struct sk_buff *skb, const struct net_device *in,
 		       (XT_OWNER_UID | XT_OWNER_GID)) == 0;
 
 	if (info->match & XT_OWNER_UID)
-		if ((filp->f_uid >= info->uid_min &&
-		    filp->f_uid <= info->uid_max) ^
+		if ((filp->f_cred->fsuid >= info->uid_min &&
+		    filp->f_cred->fsuid <= info->uid_max) ^
 		    !(info->invert & XT_OWNER_UID))
 			return false;
 
 	if (info->match & XT_OWNER_GID)
-		if ((filp->f_gid >= info->gid_min &&
-		    filp->f_gid <= info->gid_max) ^
+		if ((filp->f_cred->fsgid >= info->gid_min &&
+		    filp->f_cred->fsgid <= info->gid_max) ^
 		    !(info->invert & XT_OWNER_GID))
 			return false;
 
diff --git a/net/sched/cls_flow.c b/net/sched/cls_flow.c
index 8f63a1a..95a9b56 100644
--- a/net/sched/cls_flow.c
+++ b/net/sched/cls_flow.c
@@ -260,14 +260,14 @@ static u32 flow_get_rtclassid(const struct sk_buff *skb)
 static u32 flow_get_skuid(const struct sk_buff *skb)
 {
 	if (skb->sk && skb->sk->sk_socket && skb->sk->sk_socket->file)
-		return skb->sk->sk_socket->file->f_uid;
+		return skb->sk->sk_socket->file->f_cred->fsuid;
 	return 0;
 }
 
 static u32 flow_get_skgid(const struct sk_buff *skb)
 {
 	if (skb->sk && skb->sk->sk_socket && skb->sk->sk_socket->file)
-		return skb->sk->sk_socket->file->f_gid;
+		return skb->sk->sk_socket->file->f_cred->fsgid;
 	return 0;
 }
 

