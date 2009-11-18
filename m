Return-Path: <linux-kernel-owner+w=401wt.eu-S1757625AbZKRQHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625AbZKRQHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 11:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757592AbZKRQHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 11:07:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37024 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757606AbZKRQHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 11:07:36 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, Jan Blunck <jblunck@suse.de>,
       Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
       =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 1/2] BKL: Remove BKL from default_llseek()
Date: Wed, 18 Nov 2009 17:07:36 +0100
Message-Id: <1258560457-15129-1-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the BKL in llseek() does not protect the inode's i_size from
modification since the i_size is protected by a seqlock nowadays. Since
default_llseek() is already using the i_size_read() wrapper it is not the
BKL which is serializing the access here.
The access to file->f_pos is not protected by the BKL either since its
access in vfs_write()/vfs_read() is not protected by any lock. If the BKL
is not protecting anything here it can clearly get removed.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: John Kacur <jkacur@redhat.com>
---
 fs/read_write.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 3ac2898..0e491cc 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -107,7 +107,6 @@ loff_t default_llseek(struct file *file, loff_t offset, int origin)
 {
 	loff_t retval;
 
-	lock_kernel();
 	switch (origin) {
 		case SEEK_END:
 			offset += i_size_read(file->f_path.dentry->d_inode);
@@ -128,7 +127,6 @@ loff_t default_llseek(struct file *file, loff_t offset, int origin)
 		retval = offset;
 	}
 out:
-	unlock_kernel();
 	return retval;
 }
 EXPORT_SYMBOL(default_llseek);
-- 
1.6.4.2

