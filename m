Return-Path: <linux-kernel-owner+w=401wt.eu-S1755073AbYKFLFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbYKFLFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 06:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbYKFLFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 06:05:13 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:38846 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbYKFLFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 06:05:11 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>
References: <m1ej1p2l6u.fsf@frodo.ebiederm.org>
	<m1abcd2kqk.fsf@frodo.ebiederm.org>
	<m163n12ko9.fsf_-_@frodo.ebiederm.org>
	<m1y6zx15yj.fsf_-_@frodo.ebiederm.org>
	<m1skq515ti.fsf_-_@frodo.ebiederm.org>
Date: Thu, 06 Nov 2008 02:57:04 -0800
In-Reply-To: <m1skq515ti.fsf_-_@frodo.ebiederm.org> (Eric W. Biederman's
	message of "Thu, 06 Nov 2008 02:56:09 -0800")
Message-ID: <m1od0t15rz.fsf_-_@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, containers@lists.osdl.org, viro@ZenIV.linux.org.uk, adobriyan@gmail.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: [PATCH 6/7] proc_net: Simplify network namespace lookup.
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since the network namespace is recorded in the
superblock we don't need to remember it on
each directory under /proc/net.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/generic.c       |   17 -----------------
 fs/proc/proc_net.c      |   13 ++++++++++---
 include/linux/proc_fs.h |    5 -----
 3 files changed, 10 insertions(+), 25 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 8669cf6..6db30a8 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -658,23 +658,6 @@ struct proc_dir_entry *proc_mkdir_mode(const char *name, mode_t mode,
 	return ent;
 }
 
-struct proc_dir_entry *proc_net_mkdir(struct net *net, const char *name,
-		struct proc_dir_entry *parent)
-{
-	struct proc_dir_entry *ent;
-
-	ent = __proc_create(&parent, name, S_IFDIR | S_IRUGO | S_IXUGO, 2);
-	if (ent) {
-		ent->data = net;
-		if (proc_register(parent, ent) < 0) {
-			kfree(ent);
-			ent = NULL;
-		}
-	}
-	return ent;
-}
-EXPORT_SYMBOL_GPL(proc_net_mkdir);
-
 struct proc_dir_entry *proc_mkdir(const char *name,
 		struct proc_dir_entry *parent)
 {
diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index 4a7551a..baabb9c 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -31,7 +31,7 @@ static struct file_system_type proc_net_fs_type;
 
 static struct net *get_proc_net(const struct inode *inode)
 {
-	return maybe_get_net(PDE_NET(PDE(inode)));
+	return maybe_get_net(inode->i_sb->s_fs_info);
 }
 
 int seq_open_net(struct inode *ino, struct file *f,
@@ -214,6 +214,15 @@ struct proc_dir_entry *proc_net_fops_create(struct net *net,
 }
 EXPORT_SYMBOL_GPL(proc_net_fops_create);
 
+struct proc_dir_entry *proc_net_mkdir(struct net *net, const char *name,
+		struct proc_dir_entry *parent)
+{
+	if (!parent)
+		parent = net->proc_net;
+	return proc_mkdir(name, parent);
+}
+EXPORT_SYMBOL_GPL(proc_net_mkdir);
+
 void proc_net_remove(struct net *net, const char *name)
 {
 	remove_proc_entry(name, net->proc_net);
@@ -308,8 +317,6 @@ static __net_init int proc_net_ns_init(struct net *net)
 	if (!netd)
 		goto out;
 
-	netd->data = net;
-
 	err = -EEXIST;
 	net_statd = proc_net_mkdir(net, "stat", netd);
 	if (!net_statd)
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 3505a72..52cc6bd 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -300,11 +300,6 @@ static inline struct proc_dir_entry *PDE(const struct inode *inode)
 	return PROC_I(inode)->pde;
 }
 
-static inline struct net *PDE_NET(struct proc_dir_entry *pde)
-{
-	return pde->parent->data;
-}
-
 struct proc_maps_private {
 	struct pid *pid;
 	struct task_struct *task;
-- 
1.5.3.rc6.17.g1911

