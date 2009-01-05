Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbZAEX3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbZAEX3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 18:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbZAEX3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 18:29:20 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:40952 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbZAEX3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 18:29:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Rg6u7X92o3QJlRk4w9X0y5QI71qZVxmSMkKuFB3Tlqty3Wc3tZEZWWZVqJoNr/0zdM
         mtIGIaOLDAZL/4gli+lbVrVIOuaJnKz5JEVl86VoXJdlfPxJ/b1mA+14WtYVFkmgVepK
         x+kQyaF8o5gNnCtXGpGSwt70zmwUC+8svURkA=
Date: Tue, 6 Jan 2009 02:34:28 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: ebiederm@xmission.com, viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, containers@lists.osdl.org, sds@tycho.nsa.gov,
       jmorris@namei.org
Subject: [PATCH 5/6] proc: simplify network namespace lookup
Message-ID: <20090105233428.GE3924@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 497bf023f4e5fff34a8f50f2efc16310030a21b6 Mon Sep 17 00:00:00 2001
From: Eric W. Biederman <ebiederm@xmission.com>
Date: Wed, 19 Nov 2008 05:10:17 +0300
Subject: [PATCH 5/6] proc: simplify network namespace lookup

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
index 61d4152..03155ff 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -654,23 +654,6 @@ struct proc_dir_entry *proc_mkdir_mode(const char *name, mode_t mode,
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
index b026c87..baaddad 100644
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
@@ -304,8 +313,6 @@ static __net_init int proc_net_ns_init(struct net *net)
 	if (!netd)
 		goto out;
 
-	netd->data = net;
-
 	err = -EEXIST;
 	net_statd = proc_net_mkdir(net, "stat", netd);
 	if (!net_statd)
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 768e627..4f13811 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -304,11 +304,6 @@ static inline struct proc_dir_entry *PDE(const struct inode *inode)
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

