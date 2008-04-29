Return-Path: <linux-kernel-owner+w=401wt.eu-S1762068AbYD2LNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762068AbYD2LNv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 07:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755668AbYD2LNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 07:13:23 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:32817 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754373AbYD2LNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 07:13:22 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 12/12] netns: assign PDE->data before gluing entry into /proc tree
Date: Tue, 29 Apr 2008 15:13:22 +0400
Message-Id: <1209467602-20001-12-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1209467538.29647.11.camel@iris.sw.ru>
References: <1209467538.29647.11.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this unfortunate case, proc_mkdir_mode wrapper can't be used anymore and
this is no way to reuse proc_create_data due to nlinks assignment. So,
copy the code from proc_mkdir and assign PDE->data at the appropriate
moment.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/generic.c  |   17 +++++++++++++++++
 fs/proc/proc_net.c |   11 -----------
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 9d53b39..43e54e8 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -641,6 +641,23 @@ struct proc_dir_entry *proc_mkdir_mode(const char *name, mode_t mode,
 	return ent;
 }
 
+struct proc_dir_entry *proc_net_mkdir(struct net *net, const char *name,
+		struct proc_dir_entry *parent)
+{
+	struct proc_dir_entry *ent;
+
+	ent = __proc_create(&parent, name, S_IFDIR | S_IRUGO | S_IXUGO, 2);
+	if (ent) {
+		ent->data = net;
+		if (proc_register(parent, ent) < 0) {
+			kfree(ent);
+			ent = NULL;
+		}
+	}
+	return ent;
+}
+EXPORT_SYMBOL_GPL(proc_net_mkdir);
+
 struct proc_dir_entry *proc_mkdir(const char *name,
 		struct proc_dir_entry *parent)
 {
diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index 13cd783..83f357b 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -159,17 +159,6 @@ struct net *get_proc_net(const struct inode *inode)
 }
 EXPORT_SYMBOL_GPL(get_proc_net);
 
-struct proc_dir_entry *proc_net_mkdir(struct net *net, const char *name,
-		struct proc_dir_entry *parent)
-{
-	struct proc_dir_entry *pde;
-	pde = proc_mkdir_mode(name, S_IRUGO | S_IXUGO, parent);
-	if (pde != NULL)
-		pde->data = net;
-	return pde;
-}
-EXPORT_SYMBOL_GPL(proc_net_mkdir);
-
 static __net_init int proc_net_ns_init(struct net *net)
 {
 	struct proc_dir_entry *netd, *net_statd;
-- 
1.5.3.rc5

