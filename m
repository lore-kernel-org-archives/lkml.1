Return-Path: <linux-kernel-owner+w=401wt.eu-S1759042AbZFAV4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042AbZFAV4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 17:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756673AbZFAVwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 17:52:13 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43424 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792AbZFAVvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 17:51:00 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
       <linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>,
       Hugh Dickins <hugh@veritas.com>, Tejun Heo <tj@kernel.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@maxwell.arastra.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Date: Mon,  1 Jun 2009 14:50:41 -0700
Message-Id: <1243893048-17031-16-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1oct739xu.fsf@fess.ebiederm.org>
References: <m1oct739xu.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hugh@veritas.com, tj@kernel.org, adobriyan@gmail.com, torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk, gregkh@suse.de, npiggin@suse.de, akpm@linux-foundation.org, hch@infradead.org, ebiederm@maxwell.arastra.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 16/23] vfs: Teach fstatfs, fstatfs64, ftruncate, fchdir, fchmod, fchown to use file_hotplug_lock
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@maxwell.arastra.com>

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/open.c |   47 +++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 83d6369..354646b 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -167,9 +167,14 @@ SYSCALL_DEFINE2(fstatfs, unsigned int, fd, struct statfs __user *, buf)
 	file = fget(fd);
 	if (!file)
 		goto out;
+	error = -EIO;
+	if (!file_hotplug_read_trylock(file))
+		goto out_putf;
 	error = vfs_statfs_native(file->f_path.dentry, &tmp);
 	if (!error && copy_to_user(buf, &tmp, sizeof(tmp)))
 		error = -EFAULT;
+	file_hotplug_read_unlock(file);
+out_putf:
 	fput(file);
 out:
 	return error;
@@ -188,9 +193,14 @@ SYSCALL_DEFINE3(fstatfs64, unsigned int, fd, size_t, sz, struct statfs64 __user
 	file = fget(fd);
 	if (!file)
 		goto out;
+	error = -EIO;
+	if (!file_hotplug_read_trylock(file))
+		goto out_putf;
 	error = vfs_statfs64(file->f_path.dentry, &tmp);
 	if (!error && copy_to_user(buf, &tmp, sizeof(tmp)))
 		error = -EFAULT;
+	file_hotplug_read_unlock(file);
+out_putf:
 	fput(file);
 out:
 	return error;
@@ -309,6 +319,10 @@ static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
 	if (!file)
 		goto out;
 
+	error = -EIO;
+	if (!file_hotplug_read_trylock(file))
+		goto out_putf;
+
 	/* explicitly opened as large or we are on 64-bit box */
 	if (file->f_flags & O_LARGEFILE)
 		small = 0;
@@ -317,16 +331,16 @@ static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
 	inode = dentry->d_inode;
 	error = -EINVAL;
 	if (!S_ISREG(inode->i_mode) || !(file->f_mode & FMODE_WRITE))
-		goto out_putf;
+		goto out_unlock;
 
 	error = -EINVAL;
 	/* Cannot ftruncate over 2^31 bytes without large file support */
 	if (small && length > MAX_NON_LFS)
-		goto out_putf;
+		goto out_unlock;
 
 	error = -EPERM;
 	if (IS_APPEND(inode))
-		goto out_putf;
+		goto out_unlock;
 
 	error = locks_verify_truncate(inode, file, length);
 	if (!error)
@@ -334,6 +348,9 @@ static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
 					       ATTR_MTIME|ATTR_CTIME);
 	if (!error)
 		error = do_truncate(dentry, length, ATTR_MTIME|ATTR_CTIME, file);
+
+out_unlock:
+	file_hotplug_read_unlock(file);
 out_putf:
 	fput(file);
 out:
@@ -560,15 +577,21 @@ SYSCALL_DEFINE1(fchdir, unsigned int, fd)
 	if (!file)
 		goto out;
 
+	error = -EIO;
+	if (!file_hotplug_read_trylock(file))
+		goto out_putf;
+
 	inode = file->f_path.dentry->d_inode;
 
 	error = -ENOTDIR;
 	if (!S_ISDIR(inode->i_mode))
-		goto out_putf;
+		goto out_unlock;
 
 	error = inode_permission(inode, MAY_EXEC | MAY_ACCESS);
 	if (!error)
 		set_fs_pwd(current->fs, &file->f_path);
+out_unlock:
+	file_hotplug_read_unlock(file);
 out_putf:
 	fput(file);
 out:
@@ -612,6 +635,10 @@ SYSCALL_DEFINE2(fchmod, unsigned int, fd, mode_t, mode)
 	if (!file)
 		goto out;
 
+	err = -EIO;
+	if (!file_hotplug_read_trylock(file))
+		goto out_putf;
+
 	dentry = file->f_path.dentry;
 	inode = dentry->d_inode;
 
@@ -619,7 +646,7 @@ SYSCALL_DEFINE2(fchmod, unsigned int, fd, mode_t, mode)
 
 	err = mnt_want_write_file(file);
 	if (err)
-		goto out_putf;
+		goto out_unlock;
 	mutex_lock(&inode->i_mutex);
 	if (mode == (mode_t) -1)
 		mode = inode->i_mode;
@@ -628,6 +655,8 @@ SYSCALL_DEFINE2(fchmod, unsigned int, fd, mode_t, mode)
 	err = notify_change(dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
 	mnt_drop_write(file->f_path.mnt);
+out_unlock:
+	file_hotplug_read_unlock(file);
 out_putf:
 	fput(file);
 out:
@@ -766,13 +795,19 @@ SYSCALL_DEFINE3(fchown, unsigned int, fd, uid_t, user, gid_t, group)
 	if (!file)
 		goto out;
 
+	error = -EIO;
+	if (!file_hotplug_read_trylock(file))
+		goto out_fput;
+
 	error = mnt_want_write_file(file);
 	if (error)
-		goto out_fput;
+		goto out_unlock;
 	dentry = file->f_path.dentry;
 	audit_inode(NULL, dentry);
 	error = chown_common(dentry, user, group);
 	mnt_drop_write(file->f_path.mnt);
+out_unlock:
+	file_hotplug_read_unlock(file);
 out_fput:
 	fput(file);
 out:
-- 
1.6.3.1.54.g99dd.dirty

