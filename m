Return-Path: <linux-kernel-owner+w=401wt.eu-S1757019AbZHQHIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019AbZHQHIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 03:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756939AbZHQHII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 03:08:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35086 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756459AbZHQHIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 03:08:05 -0400
Date: Mon, 17 Aug 2009 03:07:58 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: esandeen@redhat.com, eteo@redhat.com, eparis@redhat.com,
       Amerigo Wang <amwang@redhat.com>, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, sds@tycho.nsa.gov,
       hirofumi@mail.parknet.co.jp, viro@zeniv.linux.org.uk
Message-Id: <20090817071022.5913.63840.sendpatchset@localhost.localdomain>
In-Reply-To: <20090817071001.5913.94767.sendpatchset@localhost.localdomain>
References: <20090817071001.5913.94767.sendpatchset@localhost.localdomain>
Subject: [Patch 2/2] vfs: allow file truncations when both suid and write permissions set
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With patch 1/2 applied, now we can just simply add ATTR_FORCE flag, to
remove suid on truncation.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Eric Sandeen <esandeen@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Eugene Teo <eteo@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

---
diff --git a/fs/open.c b/fs/open.c
index dd98e80..cea9abf 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -199,7 +199,7 @@ out:
 int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
 	struct file *filp)
 {
-	int err;
+	int ret;
 	struct iattr newattrs;
 
 	/* Not pretty: "inode->i_size" shouldn't really be signed. But it is. */
@@ -214,12 +214,15 @@ int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
 	}
 
 	/* Remove suid/sgid on truncate too */
-	newattrs.ia_valid |= should_remove_suid(dentry);
+	ret = should_remove_suid(dentry);
+	newattrs.ia_valid |= ret;
+	if (ret)
+		newattrs.ia_valid |= ATTR_FORCE;
 
 	mutex_lock(&dentry->d_inode->i_mutex);
-	err = notify_change(dentry, &newattrs);
+	ret = notify_change(dentry, &newattrs);
 	mutex_unlock(&dentry->d_inode->i_mutex);
-	return err;
+	return ret;
 }
 
 static long do_sys_truncate(const char __user *pathname, loff_t length)
