Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935362Ab0CMA6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:58:48 -0500
Received: from kroah.org ([198.145.64.141]:46774 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935384Ab0CMAbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:08 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:08 2010
Message-Id: <20100313002708.130290411@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [033/145] Switch proc/self to nd_set_link()
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Al Viro <viro@zeniv.linux.org.uk>

commit 7fee4868be91e71a3ee8e57289ebf5e10a12297e upstream.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/base.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2304,16 +2304,30 @@ static void *proc_self_follow_link(struc
 {
 	struct pid_namespace *ns = dentry->d_sb->s_fs_info;
 	pid_t tgid = task_tgid_nr_ns(current, ns);
-	char tmp[PROC_NUMBUF];
-	if (!tgid)
-		return ERR_PTR(-ENOENT);
-	sprintf(tmp, "%d", task_tgid_nr_ns(current, ns));
-	return ERR_PTR(vfs_follow_link(nd,tmp));
+	char *name = ERR_PTR(-ENOENT);
+	if (tgid) {
+		name = __getname();
+		if (!name)
+			name = ERR_PTR(-ENOMEM);
+		else
+			sprintf(name, "%d", tgid);
+	}
+	nd_set_link(nd, name);
+	return NULL;
+}
+
+static void proc_self_put_link(struct dentry *dentry, struct nameidata *nd,
+				void *cookie)
+{
+	char *s = nd_get_link(nd);
+	if (!IS_ERR(s))
+		__putname(s);
 }
 
 static const struct inode_operations proc_self_inode_operations = {
 	.readlink	= proc_self_readlink,
 	.follow_link	= proc_self_follow_link,
+	.put_link	= proc_self_put_link,
 };
 
 /*


