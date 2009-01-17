Return-Path: <linux-kernel-owner+w=401wt.eu-S1759269AbZAQHvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759269AbZAQHvv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 02:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755313AbZAQHvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 02:51:43 -0500
Received: from smtp-out.google.com ([216.239.33.17]:39414 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360AbZAQHvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 02:51:42 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:mime-version:content-type;
	b=Eo0r2c0Te5pIVx5jIDgRDOvPMLWqQtkZpjP9G2+gCP8JgHZx56iKpjXqAtUmidOTp
	Ntw8RAWCaLzcQm2NNfRSA==
Date: Fri, 16 Jan 2009 23:51:35 -0800 (PST)
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
cc: adobriyan@gmail.com
Subject: Migration of kernel interfaces to seq_files breaks pread() consumers
Message-ID: <Pine.LNX.4.64.0901162229420.12858@kitami.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Specifically) Several interfaces under /proc have been migrated to use 
seq_files.  This was previously observed to be a problem with VMware's 
reading of /proc/uptime.  We're now running into the same problem on  
/proc/<pid>/stat; we have many consumers performing preads on this 
interface which break under new kernels.

Reverting these migrations presents other problems and doesn't scale with 
everyones' pet dependencies over an abi that's been
broken :(

Part of the problem in implementing pread in seq_files is that we don't  
know know whether the read was issued by pread(2) or read(2).  It's not 
nice to shoehorn this information down the stack.  I've attached a 
skeleton patch which shows one way we could push it up (although something 
like a second f_pos would be necessary to make it maintain pread 
semantics against reads).

One advantage of this style of approach is that it doesn't break on 
partial record reads.  But it's a little gross at the same time.

Comments?  Ideas? 

Thanks,

- Paul

--
 fs/read_write.c    |   10 ++++++++++
 fs/seq_file.c      |    2 ++
 include/linux/fs.h |    2 ++
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 2fc2980..744094a 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -407,6 +407,16 @@ asmlinkage ssize_t sys_pread64(unsigned int fd, char __user *buf,
 		ret = -ESPIPE;
 		if (file->f_mode & FMODE_PREAD)
 			ret = vfs_read(file, buf, count, &pos);
+		else if (file->f_mode & FMODE_SEQ_FILE) {
+			/*
+			 * We break the pread semantic and actually make it
+			 * seek, this prevents inconsistent record reads across
+			 * boundaries.
+			 */
+			vfs_llseek(file, pos, SEEK_SET);
+			ret = vfs_read(file, buf, count, &pos);
+			file_pos_write(file, pos);
+		}
 		fput_light(file, fput_needed);
 	}
 
diff --git a/fs/seq_file.c b/fs/seq_file.c
index 3f54dbd..f8c5379 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -50,6 +50,8 @@ int seq_open(struct file *file, const struct seq_operations *op)
 
 	/* SEQ files support lseek, but not pread/pwrite */
 	file->f_mode &= ~(FMODE_PREAD | FMODE_PWRITE);
+	file->f_mode |= FMODE_SEQ_FILE;
+
 	return 0;
 }
 EXPORT_SYMBOL(seq_open);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5f7b912..c3b5916 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -76,6 +76,8 @@ extern int dir_notify_enable;
    behavior for cross-node execution/opening_for_writing of files */
 #define FMODE_EXEC	16
 
+#define FMODE_SEQ_FILE_PREAD	32
+
 #define RW_MASK		1
 #define RWA_MASK	2
 #define READ 0
