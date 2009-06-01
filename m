Return-Path: <linux-kernel-owner+w=401wt.eu-S1752592AbZFAV5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbZFAV5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 17:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757033AbZFAVwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 17:52:35 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35933 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbZFAVvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 17:51:01 -0400
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
       "Eric W. Biederman" <ebiederm@maxwell.aristanetworks.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Date: Mon,  1 Jun 2009 14:50:45 -0700
Message-Id: <1243893048-17031-20-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1oct739xu.fsf@fess.ebiederm.org>
References: <m1oct739xu.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hugh@veritas.com, tj@kernel.org, adobriyan@gmail.com, torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk, gregkh@suse.de, npiggin@suse.de, akpm@linux-foundation.org, hch@infradead.org, ebiederm@maxwell.aristanetworks.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 20/23] vfs: Teach aio to use file_hotplug_lock
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@maxwell.aristanetworks.com>

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/aio.c |   51 ++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 76da125..eceb215 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1362,13 +1362,20 @@ static void aio_advance_iovec(struct kiocb *iocb, ssize_t ret)
 static ssize_t aio_rw_vect_retry(struct kiocb *iocb)
 {
 	struct file *file = iocb->ki_filp;
-	struct address_space *mapping = file->f_mapping;
-	struct inode *inode = mapping->host;
+	struct address_space *mapping;
+	struct inode *inode;
 	ssize_t (*rw_op)(struct kiocb *, const struct iovec *,
 			 unsigned long, loff_t);
 	ssize_t ret = 0;
 	unsigned short opcode;
 
+	ret = -EIO;
+	if (!file_hotplug_read_trylock(file))
+		goto out;
+
+	mapping = file->f_mapping;
+	inode = mapping->host;
+
 	if ((iocb->ki_opcode == IOCB_CMD_PREADV) ||
 		(iocb->ki_opcode == IOCB_CMD_PREAD)) {
 		rw_op = file->f_op->aio_read;
@@ -1379,8 +1386,9 @@ static ssize_t aio_rw_vect_retry(struct kiocb *iocb)
 	}
 
 	/* This matches the pread()/pwrite() logic */
+	ret = -EINVAL;
 	if (iocb->ki_pos < 0)
-		return -EINVAL;
+		goto out_unlock;
 
 	do {
 		ret = rw_op(iocb, &iocb->ki_iovec[iocb->ki_cur_seg],
@@ -1407,26 +1415,37 @@ static ssize_t aio_rw_vect_retry(struct kiocb *iocb)
 	    && iocb->ki_nbytes - iocb->ki_left)
 		ret = iocb->ki_nbytes - iocb->ki_left;
 
+out_unlock:
+	file_hotplug_read_unlock(file);
+out:
 	return ret;
 }
 
 static ssize_t aio_fdsync(struct kiocb *iocb)
 {
 	struct file *file = iocb->ki_filp;
-	ssize_t ret = -EINVAL;
+	ssize_t ret = -EIO;
 
-	if (file->f_op->aio_fsync)
-		ret = file->f_op->aio_fsync(iocb, 1);
+	if (file_hotplug_read_trylock(file)) {
+		ret = -EINVAL;
+		if (file->f_op->aio_fsync)
+			ret = file->f_op->aio_fsync(iocb, 1);
+		file_hotplug_read_unlock(file);
+	}
 	return ret;
 }
 
 static ssize_t aio_fsync(struct kiocb *iocb)
 {
 	struct file *file = iocb->ki_filp;
-	ssize_t ret = -EINVAL;
+	ssize_t ret = -EIO;
 
-	if (file->f_op->aio_fsync)
-		ret = file->f_op->aio_fsync(iocb, 0);
+	if (file_hotplug_read_trylock(file)) {
+		ret = -EINVAL;
+		if (file->f_op->aio_fsync)
+			ret = file->f_op->aio_fsync(iocb, 0);
+		file_hotplug_read_unlock(file);
+	}
 	return ret;
 }
 
@@ -1469,7 +1488,11 @@ static ssize_t aio_setup_single_vector(struct kiocb *kiocb)
 static ssize_t aio_setup_iocb(struct kiocb *kiocb)
 {
 	struct file *file = kiocb->ki_filp;
-	ssize_t ret = 0;
+	ssize_t ret;
+
+	ret = -EIO;
+	if (!file_hotplug_read_trylock(file))
+		goto out;
 
 	switch (kiocb->ki_opcode) {
 	case IOCB_CMD_PREAD:
@@ -1551,10 +1574,12 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb)
 		ret = -EINVAL;
 	}
 
-	if (!kiocb->ki_retry)
-		return ret;
+	if (kiocb->ki_retry)
+		ret = 0;
 
-	return 0;
+	file_hotplug_read_unlock(file);
+out:
+	return ret;
 }
 
 /*
-- 
1.6.3.1.54.g99dd.dirty

