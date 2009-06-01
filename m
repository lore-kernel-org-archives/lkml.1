Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbZFAVwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbZFAVwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 17:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755921AbZFAVvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 17:51:13 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43333 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbZFAVu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 17:50:58 -0400
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
Date: Mon,  1 Jun 2009 14:50:31 -0700
Message-Id: <1243893048-17031-6-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1oct739xu.fsf@fess.ebiederm.org>
References: <m1oct739xu.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hugh@veritas.com, tj@kernel.org, adobriyan@gmail.com, torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk, gregkh@suse.de, npiggin@suse.de, akpm@linux-foundation.org, hch@infradead.org, ebiederm@maxwell.arastra.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 06/23] vfs: Teach read/write to use file_hotplug_read_lock
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@maxwell.arastra.com>

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/compat.c     |   16 +++++++++++-
 fs/read_write.c |   70 +++++++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 72 insertions(+), 14 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 25be41c..dad9957 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1196,12 +1196,18 @@ static size_t compat_readv(struct file *file,
 	if (!(file->f_mode & FMODE_READ))
 		goto out;
 
+	ret = -EIO;
+	if (!file_hotplug_read_trylock(file))
+		goto out;
+
 	ret = -EINVAL;
 	if (!file->f_op || (!file->f_op->aio_read && !file->f_op->read))
-		goto out;
+		goto out_unlock;
 
 	ret = compat_do_readv_writev(READ, file, vec, vlen, pos);
 
+out_unlock:
+	file_hotplug_read_unlock(file);
 out:
 	if (ret > 0)
 		add_rchar(current, ret);
@@ -1253,12 +1259,18 @@ static size_t compat_writev(struct file *file,
 	if (!(file->f_mode & FMODE_WRITE))
 		goto out;
 
+	ret = -EIO;
+	if (!file_hotplug_read_trylock(file))
+		goto out;
+
 	ret = -EINVAL;
 	if (!file->f_op || (!file->f_op->aio_write && !file->f_op->write))
-		goto out;
+		goto out_unlock;
 
 	ret = compat_do_readv_writev(WRITE, file, vec, vlen, pos);
 
+out_unlock:
+	file_hotplug_read_unlock(file);
 out:
 	if (ret > 0)
 		add_wchar(current, ret);
diff --git a/fs/read_write.c b/fs/read_write.c
index c9511ce..718baea 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -288,12 +288,18 @@ ssize_t vfs_read(struct file *file, char __user *buf, size_t count, loff_t *pos)
 {
 	ssize_t ret;
 
+	ret = -EBADF;
 	if (!(file->f_mode & FMODE_READ))
-		return -EBADF;
+		goto out;
+	ret = -EIO;
+	if (!file_hotplug_read_trylock(file))
+		goto out;
+	ret = -EINVAL;
 	if (!file->f_op || (!file->f_op->read && !file->f_op->aio_read))
-		return -EINVAL;
+		goto out_unlock;
+	ret = -EFAULT;
 	if (unlikely(!access_ok(VERIFY_WRITE, buf, count)))
-		return -EFAULT;
+		goto out_unlock;
 
 	ret = rw_verify_area(READ, file, pos, count);
 	if (ret >= 0) {
@@ -309,6 +315,9 @@ ssize_t vfs_read(struct file *file, char __user *buf, size_t count, loff_t *pos)
 		inc_syscr(current);
 	}
 
+out_unlock:
+	file_hotplug_read_unlock(file);
+out:
 	return ret;
 }
 
@@ -343,12 +352,18 @@ ssize_t vfs_write(struct file *file, const char __user *buf, size_t count, loff_
 {
 	ssize_t ret;
 
+	ret = -EBADF;
 	if (!(file->f_mode & FMODE_WRITE))
-		return -EBADF;
+		goto out;
+	ret = -EIO;
+	if (!file_hotplug_read_trylock(file))
+		goto out;
+	ret = -EINVAL;
 	if (!file->f_op || (!file->f_op->write && !file->f_op->aio_write))
-		return -EINVAL;
+		goto out_unlock;
+	ret = -EFAULT;
 	if (unlikely(!access_ok(VERIFY_READ, buf, count)))
-		return -EFAULT;
+		goto out_unlock;
 
 	ret = rw_verify_area(WRITE, file, pos, count);
 	if (ret >= 0) {
@@ -364,6 +379,9 @@ ssize_t vfs_write(struct file *file, const char __user *buf, size_t count, loff_
 		inc_syscw(current);
 	}
 
+out_unlock:
+	file_hotplug_read_unlock(file);
+out:
 	return ret;
 }
 
@@ -676,12 +694,26 @@ out:
 ssize_t vfs_readv(struct file *file, const struct iovec __user *vec,
 		  unsigned long vlen, loff_t *pos)
 {
+	ssize_t ret;
+
+	ret = -EBADF;
 	if (!(file->f_mode & FMODE_READ))
-		return -EBADF;
+		goto out;
+
+	ret = -EIO;
+	if (!file_hotplug_read_trylock(file))
+		goto out;
+
+	ret = -EINVAL;
 	if (!file->f_op || (!file->f_op->aio_read && !file->f_op->read))
-		return -EINVAL;
+		goto out_unlock;
+
+	ret = do_readv_writev(READ, file, vec, vlen, pos);
 
-	return do_readv_writev(READ, file, vec, vlen, pos);
+out_unlock:
+	file_hotplug_read_unlock(file);
+out:
+	return ret;
 }
 
 EXPORT_SYMBOL(vfs_readv);
@@ -689,12 +721,26 @@ EXPORT_SYMBOL(vfs_readv);
 ssize_t vfs_writev(struct file *file, const struct iovec __user *vec,
 		   unsigned long vlen, loff_t *pos)
 {
+	ssize_t ret;
+
+	ret = -EBADF;
 	if (!(file->f_mode & FMODE_WRITE))
-		return -EBADF;
+		goto out;
+
+	ret = -EIO;
+	if (!file_hotplug_read_trylock(file))
+		goto out;
+
+	ret = -EINVAL;
 	if (!file->f_op || (!file->f_op->aio_write && !file->f_op->write))
-		return -EINVAL;
+		goto out_unlock;
 
-	return do_readv_writev(WRITE, file, vec, vlen, pos);
+	ret = do_readv_writev(WRITE, file, vec, vlen, pos);
+
+out_unlock:
+	file_hotplug_read_unlock(file);
+out:
+	return ret;
 }
 
 EXPORT_SYMBOL(vfs_writev);
-- 
1.6.3.1.54.g99dd.dirty

