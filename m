Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbYDVMHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbYDVMHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 08:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbYDVMHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 08:07:03 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:51500 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbYDVMHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 08:07:02 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix unconditional write_super() call in file_fsync()
Date: Tue, 22 Apr 2008 21:06:56 +0900
Message-ID: <878wz6jdpb.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes file_fsync(). we need to check ->s_dirt before calling
write_super(). It became the cause of an unneeded write.

This bug was noticed by Sudhanshu Saxena.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/sync.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/sync.c~file_fsync-fix fs/sync.c
--- linux-2.6/fs/sync.c~file_fsync-fix	2008-04-22 15:14:50.000000000 +0900
+++ linux-2.6-hirofumi/fs/sync.c	2008-04-22 15:16:58.000000000 +0900
@@ -64,7 +64,7 @@ int file_fsync(struct file *filp, struct
 	/* sync the superblock to buffers */
 	sb = inode->i_sb;
 	lock_super(sb);
-	if (sb->s_op->write_super)
+	if (sb->s_dirt && sb->s_op->write_super)
 		sb->s_op->write_super(sb);
 	unlock_super(sb);
 
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
