Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbYGQGqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbYGQGqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 02:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756475AbYGQGqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 02:46:04 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36123 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756361AbYGQGqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 02:46:01 -0400
Subject: [PATCH] update kvm's anon_inodes.c for r/o bind mounts
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm@vger.kernel.org>,
       "Anthony N. Liguori [imap]" <aliguori@us.ibm.com>
In-Reply-To: <487EDE26.8040201@qumranet.com>
References: <1206479576.7562.21.camel@nimitz.home.sr71.net>
	 <47EA1C63.8010202@qumranet.com>
	 <1206550329.7883.5.camel@nimitz.home.sr71.net>
	 <47EA80AC.4070204@qumranet.com>
	 <1206551794.7883.7.camel@nimitz.home.sr71.net>
	 <47EB6AAC.3040607@qumranet.com>  <47EB7281.6070300@qumranet.com>
	 <1206629709.7883.30.camel@nimitz.home.sr71.net>
	 <47EBB63E.2060306@qumranet.com>
	 <1212445810.8211.9.camel@nimitz.home.sr71.net>
	 <48469BDA.3050206@qumranet.com> <1212738105.7837.3.camel@nimitz>
	 <48512028.3070104@qumranet.com>  <1216148242.25942.6.camel@nimitz>
	 <1216244660.8711.6.camel@nimitz> <1216248527.11664.9.camel@nimitz>
	 <487EDE26.8040201@qumranet.com>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 23:45:56 -0700
Message-Id: <1216277156.11664.21.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That also reminds me.  kvm somehow has an outdated copy of
anon_inodes.c.  It needs to be updated for the r/o bind mount patches to
add a proper mnt_want/drop_write().  Otherwise, you'll run into warnings
about imbalanced mount writer counts.  Something like this will do, but
it would be best to just stay up to date with mainline for this kind of
stuff.

diff --git a/kernel/anon_inodes.c b/kernel/anon_inodes.c
index 74630ea..a47bc55 100644
--- a/kernel/anon_inodes.c
+++ b/kernel/anon_inodes.c
@@ -90,9 +90,6 @@ int anon_inode_getfd(const char *name, const struct file_operations *fops,
 
 	if (IS_ERR(anon_inode_inode))
 		return -ENODEV;
-	file = get_empty_filp();
-	if (!file)
-		return -ENFILE;
 
 	inode = igrab(anon_inode_inode);
 	if (IS_ERR(inode)) {
@@ -121,14 +118,15 @@ int anon_inode_getfd(const char *name, const struct file_operations *fops,
 	dentry->d_flags &= ~DCACHE_UNHASHED;
 	d_instantiate(dentry, inode);
 
-	file->f_vfsmnt = mntget(anon_inode_mnt);
-	file->f_dentry = dentry;
-	file->f_mapping = inode->i_mapping;
+	file = alloc_file(anon_inode_mnt, dentry, FMODE_READ | FMODE_WRITE,
+			(struct file_operations *)fops);
+	if (!file) {
+		error = -ENFILE;
+		goto err_dput;
+	}
 
 	file->f_pos = 0;
 	file->f_flags = O_RDWR;
-	file->f_op = (struct file_operations *)fops;
-	file->f_mode = FMODE_READ | FMODE_WRITE;
 	file->f_version = 0;
 	file->private_data = priv;
 
@@ -136,12 +134,13 @@ int anon_inode_getfd(const char *name, const struct file_operations *fops,
 
 	return fd;
 
+err_dput:
+	dput(dentry);
 err_put_unused_fd:
 	put_unused_fd(fd);
 err_iput:
 	iput(inode);
 err_put_filp:
-	fput(file);
 	return error;
 }
 


-- Dave

