Return-Path: <linux-kernel-owner+w=401wt.eu-S934176AbYDQLI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934176AbYDQLI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 07:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932330AbYDQLGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 07:06:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:41593 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760848AbYDQLGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 07:06:32 -0400
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
       "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH 02/12] SELinux: setup new inode/ipc getsecid hooks
Date: Thu, 17 Apr 2008 11:05:59 +0000
Message-Id: <ea4e30db3aee8ca02a7d46f2104f3718d8a4e2d0.1208428765.git.jmorris@namei.org>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208430369-23156-1-git-send-email-jmorris@namei.org>
References: <1208430369-23156-1-git-send-email-jmorris@namei.org>
In-Reply-To: <88d8811229b02f6b14ff1f0682dc5502a1f61b41.1208428765.git.jmorris@namei.org>
References: <88d8811229b02f6b14ff1f0682dc5502a1f61b41.1208428765.git.jmorris@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ahmed S. Darwish <darwish.07@gmail.com>

Setup the new inode_getsecid and ipc_getsecid() LSM hooks
for SELinux.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Acked-by: James Morris <jmorris@namei.org>
Reviewed-by: Paul Moore <paul.moore@hp.com>
---
 security/selinux/hooks.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index d39b59c..65bf7f7 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2743,6 +2743,12 @@ static int selinux_inode_killpriv(struct dentry *dentry)
 	return secondary_ops->inode_killpriv(dentry);
 }
 
+static void selinux_inode_getsecid(const struct inode *inode, u32 *secid)
+{
+	struct inode_security_struct *isec = inode->i_security;
+	*secid = isec->sid;
+}
+
 /* file security operations */
 
 static int selinux_revalidate_file_permission(struct file *file, int mask)
@@ -3139,7 +3145,8 @@ static int selinux_task_getsid(struct task_struct *p)
 
 static void selinux_task_getsecid(struct task_struct *p, u32 *secid)
 {
-	selinux_get_task_sid(p, secid);
+	struct task_security_struct *tsec = p->security;
+	*secid = tsec->sid;
 }
 
 static int selinux_task_setgroups(struct group_info *group_info)
@@ -4109,7 +4116,7 @@ static int selinux_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *
 		goto out;
 
 	if (sock && family == PF_UNIX)
-		selinux_get_inode_sid(SOCK_INODE(sock), &peer_secid);
+		selinux_inode_getsecid(SOCK_INODE(sock), &peer_secid);
 	else if (skb)
 		selinux_skb_peerlbl_sid(skb, family, &peer_secid);
 
@@ -4989,6 +4996,12 @@ static int selinux_ipc_permission(struct kern_ipc_perm *ipcp, short flag)
 	return ipc_has_perm(ipcp, av);
 }
 
+static void selinux_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid)
+{
+	struct ipc_security_struct *isec = ipcp->security;
+	*secid = isec->sid;
+}
+
 /* module stacking operations */
 static int selinux_register_security (const char *name, struct security_operations *ops)
 {
@@ -5299,6 +5312,7 @@ static struct security_operations selinux_ops = {
 	.inode_listsecurity =           selinux_inode_listsecurity,
 	.inode_need_killpriv =		selinux_inode_need_killpriv,
 	.inode_killpriv =		selinux_inode_killpriv,
+	.inode_getsecid =               selinux_inode_getsecid,
 
 	.file_permission =		selinux_file_permission,
 	.file_alloc_security =		selinux_file_alloc_security,
@@ -5339,6 +5353,7 @@ static struct security_operations selinux_ops = {
 	.task_to_inode =                selinux_task_to_inode,
 
 	.ipc_permission =		selinux_ipc_permission,
+	.ipc_getsecid =                 selinux_ipc_getsecid,
 
 	.msg_msg_alloc_security =	selinux_msg_msg_alloc_security,
 	.msg_msg_free_security =	selinux_msg_msg_free_security,
-- 
1.5.4.2

