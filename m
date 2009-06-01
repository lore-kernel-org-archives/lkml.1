Return-Path: <linux-kernel-owner+w=401wt.eu-S1758095AbZFAVx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbZFAVx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 17:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756359AbZFAVvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 17:51:39 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43343 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbZFAVu6 (ORCPT
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
Date: Mon,  1 Jun 2009 14:50:32 -0700
Message-Id: <1243893048-17031-7-git-send-email-ebiederm@xmission.com>
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
	*  0.0 T_Symld_Words_02 T_Symld_Words_02
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 07/23] vfs: Teach sendfile,splice,tee,and vmsplice to use file_hotplug_lock
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@maxwell.arastra.com>

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/read_write.c |   28 +++++++++----
 fs/splice.c     |  111 +++++++++++++++++++++++++++++++++++++-----------------
 2 files changed, 95 insertions(+), 44 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 718baea..c473d74 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -861,21 +861,24 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
 		goto out;
 	if (!(in_file->f_mode & FMODE_READ))
 		goto fput_in;
+	retval = -EIO;
+	if (!file_hotplug_read_trylock(in_file))
+		goto fput_in;
 	retval = -EINVAL;
 	in_inode = in_file->f_path.dentry->d_inode;
 	if (!in_inode)
-		goto fput_in;
+		goto unlock_in;
 	if (!in_file->f_op || !in_file->f_op->splice_read)
-		goto fput_in;
+		goto unlock_in;
 	retval = -ESPIPE;
 	if (!ppos)
 		ppos = &in_file->f_pos;
 	else
 		if (!(in_file->f_mode & FMODE_PREAD))
-			goto fput_in;
+			goto unlock_in;
 	retval = rw_verify_area(READ, in_file, ppos, count);
 	if (retval < 0)
-		goto fput_in;
+		goto unlock_in;
 	count = retval;
 
 	/*
@@ -884,16 +887,19 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
 	retval = -EBADF;
 	out_file = fget_light(out_fd, &fput_needed_out);
 	if (!out_file)
-		goto fput_in;
+		goto unlock_in;
 	if (!(out_file->f_mode & FMODE_WRITE))
 		goto fput_out;
+	retval = -EIO;
+	if (!file_hotplug_read_trylock(out_file))
+		goto fput_out;
 	retval = -EINVAL;
 	if (!out_file->f_op || !out_file->f_op->sendpage)
-		goto fput_out;
+		goto unlock_out;
 	out_inode = out_file->f_path.dentry->d_inode;
 	retval = rw_verify_area(WRITE, out_file, &out_file->f_pos, count);
 	if (retval < 0)
-		goto fput_out;
+		goto unlock_out;
 	count = retval;
 
 	if (!max)
@@ -902,11 +908,11 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
 	pos = *ppos;
 	retval = -EINVAL;
 	if (unlikely(pos < 0))
-		goto fput_out;
+		goto unlock_out;
 	if (unlikely(pos + count > max)) {
 		retval = -EOVERFLOW;
 		if (pos >= max)
-			goto fput_out;
+			goto unlock_out;
 		count = max - pos;
 	}
 
@@ -933,8 +939,12 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
 	if (*ppos > max)
 		retval = -EOVERFLOW;
 
+unlock_out:
+	file_hotplug_read_unlock(out_file);
 fput_out:
 	fput_light(out_file, fput_needed_out);
+unlock_in:
+	file_hotplug_read_unlock(in_file);
 fput_in:
 	fput_light(in_file, fput_needed_in);
 out:
diff --git a/fs/splice.c b/fs/splice.c
index 666953d..fc6b3a5 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1464,15 +1464,21 @@ SYSCALL_DEFINE4(vmsplice, int, fd, const struct iovec __user *, iov,
 
 	error = -EBADF;
 	file = fget_light(fd, &fput);
-	if (file) {
-		if (file->f_mode & FMODE_WRITE)
-			error = vmsplice_to_pipe(file, iov, nr_segs, flags);
-		else if (file->f_mode & FMODE_READ)
-			error = vmsplice_to_user(file, iov, nr_segs, flags);
+	if (!file)
+		goto out;
 
-		fput_light(file, fput);
-	}
+	if (!file_hotplug_read_trylock(file))
+		goto fput_file;
 
+	if (file->f_mode & FMODE_WRITE)
+		error = vmsplice_to_pipe(file, iov, nr_segs, flags);
+	else if (file->f_mode & FMODE_READ)
+		error = vmsplice_to_user(file, iov, nr_segs, flags);
+
+	file_hotplug_read_unlock(file);
+fput_file:
+	fput_light(file, fput);
+out:
 	return error;
 }
 
@@ -1489,21 +1495,39 @@ SYSCALL_DEFINE6(splice, int, fd_in, loff_t __user *, off_in,
 
 	error = -EBADF;
 	in = fget_light(fd_in, &fput_in);
-	if (in) {
-		if (in->f_mode & FMODE_READ) {
-			out = fget_light(fd_out, &fput_out);
-			if (out) {
-				if (out->f_mode & FMODE_WRITE)
-					error = do_splice(in, off_in,
-							  out, off_out,
-							  len, flags);
-				fput_light(out, fput_out);
-			}
-		}
+	if (!in)
+		goto out;
 
-		fput_light(in, fput_in);
-	}
+	if (!(in->f_mode & FMODE_READ))
+		goto fput_in;
+
+	error = -EIO;
+	if (!file_hotplug_read_trylock(in))
+		goto fput_in;
+
+	error = -EBADF;
+	out = fget_light(fd_out, &fput_out);
+	if (!out)
+		goto unlock_in;
+
+	if (!(out->f_mode & FMODE_WRITE))
+		goto fput_out;
+
+	error = -EIO;
+	if (!file_hotplug_read_trylock(out))
+		goto fput_out;
+
+	error = do_splice(in, off_in, out, off_out, len, flags);
 
+	file_hotplug_read_unlock(out);
+fput_out:
+	fput_light(out, fput_out);
+unlock_in:
+	file_hotplug_read_unlock(in);
+fput_in:
+	fput_light(in, fput_in);
+
+out:
 	return error;
 }
 
@@ -1703,27 +1727,44 @@ static long do_tee(struct file *in, struct file *out, size_t len,
 
 SYSCALL_DEFINE4(tee, int, fdin, int, fdout, size_t, len, unsigned int, flags)
 {
-	struct file *in;
-	int error, fput_in;
+	struct file *in, *out;
+	int error, fput_in, fput_out;
 
 	if (unlikely(!len))
 		return 0;
 
 	error = -EBADF;
 	in = fget_light(fdin, &fput_in);
-	if (in) {
-		if (in->f_mode & FMODE_READ) {
-			int fput_out;
-			struct file *out = fget_light(fdout, &fput_out);
-
-			if (out) {
-				if (out->f_mode & FMODE_WRITE)
-					error = do_tee(in, out, len, flags);
-				fput_light(out, fput_out);
-			}
-		}
- 		fput_light(in, fput_in);
- 	}
+	if (!in)
+		goto out;
+
+	if (!(in->f_mode & FMODE_READ))
+		goto unlock_in;
 
+	error = -EIO;
+	if (!file_hotplug_read_trylock(in))
+		goto fput_in;
+
+	error = -EBADF;
+	out = fget_light(fdout, &fput_out);
+	if (!out)
+		goto unlock_in;
+
+	if (!(out->f_mode & FMODE_WRITE))
+		goto fput_out;
+
+	if (!file_hotplug_read_trylock(out))
+		goto fput_out;
+
+	error = do_tee(in, out, len, flags);
+
+	file_hotplug_read_unlock(out);
+fput_out:
+	fput_light(out, fput_out);
+unlock_in:
+	file_hotplug_read_unlock(in);
+fput_in:
+	fput_light(in, fput_in);
+out:
 	return error;
 }
-- 
1.6.3.1.54.g99dd.dirty

