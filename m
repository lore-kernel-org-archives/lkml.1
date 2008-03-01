Return-Path: <linux-kernel-owner+w=401wt.eu-S1760377AbYCATzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760377AbYCATzs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 14:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756802AbYCATzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 14:55:39 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:4938 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756309AbYCATzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 14:55:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=P86kS0yZH24Dlticlk7M3naR9jCkUKBcVWiVXdkHwT4bKgKY8k9PfNHrn69oyPeKq2pGGS2ipYhCKpYYB7/V1/4/eUttcuQYpLmdtI4UMLE/8LOoLSi8TYqpxvVEbK1oD7HylD1ccGjTWztwGee694OVfjjhjA30qtGimKFswuk=
Date: Sat, 1 Mar 2008 21:52:30 +0200
To: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       David Woodhouse <dwmw2@infradead.org>, Paul Moore <paul.moore@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Audit-ML <linux-audit@redhat.com>,
       LSM-ML <linux-security-module@vger.kernel.org>
Subject: [PATCH 2/9] SELinux: setup new inode/ipc getsecid hooks
Message-ID: <20080301195230.GC19636@ubuntu>
References: <20080301194752.GA19636@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080301194752.GA19636@ubuntu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setup the new inode_getsecid and ipc_getsecid() LSM hooks
for SELinux.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

 hooks.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index f42ebfc..06597d7 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2724,6 +2724,12 @@ static int selinux_inode_killpriv(struct dentry *dentry)
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
@@ -3120,7 +3126,8 @@ static int selinux_task_getsid(struct task_struct *p)
 
 static void selinux_task_getsecid(struct task_struct *p, u32 *secid)
 {
-	selinux_get_task_sid(p, secid);
+	struct task_security_struct *tsec = p->security;
+	*secid = tsec->sid;
 }
 
 static int selinux_task_setgroups(struct group_info *group_info)
@@ -4090,7 +4097,7 @@ static int selinux_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *
 		goto out;
 
 	if (sock && family == PF_UNIX)
-		selinux_get_inode_sid(SOCK_INODE(sock), &peer_secid);
+		selinux_inode_getsecid(SOCK_INODE(sock), &peer_secid);
 	else if (skb)
 		selinux_skb_peerlbl_sid(skb, family, &peer_secid);
 
@@ -4970,6 +4977,12 @@ static int selinux_ipc_permission(struct kern_ipc_perm *ipcp, short flag)
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
@@ -5292,6 +5305,7 @@ static struct security_operations selinux_ops = {
 	.inode_listsecurity =           selinux_inode_listsecurity,
 	.inode_need_killpriv =		selinux_inode_need_killpriv,
 	.inode_killpriv =		selinux_inode_killpriv,
+	.inode_getsecid =               selinux_inode_getsecid,
 
 	.file_permission =		selinux_file_permission,
 	.file_alloc_security =		selinux_file_alloc_security,
@@ -5332,6 +5346,7 @@ static struct security_operations selinux_ops = {
 	.task_to_inode =                selinux_task_to_inode,
 
 	.ipc_permission =		selinux_ipc_permission,
+	.ipc_getsecid =                 selinux_ipc_getsecid,
 
 	.msg_msg_alloc_security =	selinux_msg_msg_alloc_security,
 	.msg_msg_free_security =	selinux_msg_msg_free_security,

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

