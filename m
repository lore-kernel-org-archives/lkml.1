Return-Path: <linux-kernel-owner+w=401wt.eu-S1759606AbZFAV6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606AbZFAV6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 17:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756857AbZFAVwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 17:52:41 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35889 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbZFAVvA (ORCPT
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
       "Eric W. Biederman" <ebiederm@aristanetworks.om>
Date: Mon,  1 Jun 2009 14:50:40 -0700
Message-Id: <1243893048-17031-15-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1oct739xu.fsf@fess.ebiederm.org>
References: <m1oct739xu.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hugh@veritas.com, tj@kernel.org, adobriyan@gmail.com, torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk, gregkh@suse.de, npiggin@suse.de, akpm@linux-foundation.org, hch@infradead.org, ebiederm@maxwell.arastra.com, ebiederm@aristanetworks.om
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 15/23] vfs: Teach fallocate, and filp_close to use file_hotplug_lock
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@maxwell.arastra.com>

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.om>
---
 fs/open.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index d0b2433..83d6369 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -398,19 +398,22 @@ SYSCALL_DEFINE(fallocate)(int fd, int mode, loff_t offset, loff_t len)
 		goto out;
 	if (!(file->f_mode & FMODE_WRITE))
 		goto out_fput;
+	ret = -EIO;
+	if (!file_hotplug_read_trylock(file))
+		goto out_fput;
 	/*
 	 * Revalidate the write permissions, in case security policy has
 	 * changed since the files were opened.
 	 */
 	ret = security_file_permission(file, MAY_WRITE);
 	if (ret)
-		goto out_fput;
+		goto out_unlock;
 
 	inode = file->f_path.dentry->d_inode;
 
 	ret = -ESPIPE;
 	if (S_ISFIFO(inode->i_mode))
-		goto out_fput;
+		goto out_unlock;
 
 	ret = -ENODEV;
 	/*
@@ -418,18 +421,20 @@ SYSCALL_DEFINE(fallocate)(int fd, int mode, loff_t offset, loff_t len)
 	 * for directories or not.
 	 */
 	if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
-		goto out_fput;
+		goto out_unlock;
 
 	ret = -EFBIG;
 	/* Check for wrap through zero too */
 	if (((offset + len) > inode->i_sb->s_maxbytes) || ((offset + len) < 0))
-		goto out_fput;
+		goto out_unlock;
 
 	if (inode->i_op->fallocate)
 		ret = inode->i_op->fallocate(inode, mode, offset, len);
 	else
 		ret = -EOPNOTSUPP;
 
+out_unlock:
+	file_hotplug_read_unlock(file);
 out_fput:
 	fput(file);
 out:
@@ -1101,18 +1106,25 @@ SYSCALL_DEFINE2(creat, const char __user *, pathname, int, mode)
  */
 int filp_close(struct file *filp, fl_owner_t id)
 {
-	int retval = 0;
+	int retval;
 
 	if (!file_count(filp)) {
 		printk(KERN_ERR "VFS: Close: file count is 0\n");
 		return 0;
 	}
 
+	retval = -EIO;
+	if (!file_hotplug_read_trylock(filp))
+		goto out_fput;
+
+	retval = 0;
 	if (filp->f_op && filp->f_op->flush)
 		retval = filp->f_op->flush(filp, id);
 
 	dnotify_flush(filp, id);
 	locks_remove_posix(filp, id);
+	file_hotplug_read_unlock(filp);
+out_fput:
 	fput(filp);
 	return retval;
 }
-- 
1.6.3.1.54.g99dd.dirty

