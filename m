Return-Path: <linux-kernel-owner+w=401wt.eu-S1757828AbZC3Ws3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828AbZC3Ws3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 18:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbZC3Wr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 18:47:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:9406 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757644AbZC3Wr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 18:47:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=rljuulLARsQSIauFCYcK4LIIPdwJSGgsr1UvZ/4hjjlw6QTNuiSR6BEyW8qfKr6CSB
         xr0rCQncPWh389JhG+yGNONGRLhTf7/j588BEqfM7BKGW9Ghl+C+t4NYijCASzlsCTfN
         FjYLQyLADJMTRvZLOpqLVzHBPGdKnwq7eXtXk=
Date: Tue, 31 Mar 2009 02:55:27 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: viro@ZenIV.linux.org.uk
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org
Subject: [PATCH 10/11] proc 5/6: simplify network namespace lookup
Message-ID: <20090330225527.GF19892@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 55479bec2d997de7352a26902170857c81c007b0 Mon Sep 17 00:00:00 2001
From: Eric W. Biederman <ebiederm@xmission.com>
Date: Wed, 19 Nov 2008 05:10:17 +0300
Subject: [PATCH 10/11] proc 5/6: simplify network namespace lookup

Since the network namespace is recorded in the
superblock we don't need to remember it on
each directory under /proc/net.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/generic.c       |   17 -----------------
 fs/proc/proc_net.c      |   13 ++++++++++---
 include/linux/proc_fs.h |    5 -----
 3 files changed, 10 insertions(+), 25 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index c740cf5..e351b1b 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -697,23 +697,6 @@ struct proc_dir_entry *proc_mkdir_mode(const char *name, mode_t mode,
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
index e4c7a20..1e31e5d 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -30,7 +30,7 @@ static struct file_system_type proc_net_fs_type;
 
 static struct net *get_proc_net(const struct inode *inode)
 {
-	return maybe_get_net(PDE_NET(PDE(inode)));
+	return maybe_get_net(inode->i_sb->s_fs_info);
 }
 
 int seq_open_net(struct inode *ino, struct file *f,
@@ -211,6 +211,15 @@ struct proc_dir_entry *proc_net_fops_create(struct net *net,
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
@@ -305,8 +314,6 @@ static __net_init int proc_net_ns_init(struct net *net)
 	if (!netd)
 		goto out;
 
-	netd->data = net;
-
 	err = -EEXIST;
 	net_statd = proc_net_mkdir(net, "stat", netd);
 	if (!net_statd)
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index da2b53c..d7c76e8 100644
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
1.5.6.5

