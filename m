Return-Path: <linux-kernel-owner+w=401wt.eu-S1762267AbXGPBKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762267AbXGPBKt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 21:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758572AbXGPBKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 21:10:41 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:58488 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407AbXGPBKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 21:10:40 -0400
X-Greylist: delayed 1932 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Jul 2007 21:10:40 EDT
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] splice: fix wrong __splice_from_pipe() usage
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Mon, 16 Jul 2007 09:38:22 +0900
Message-ID: <877ip1qj29.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've noticed the nfsd read corruption by recent change. And this patch
fixes the problem for me, is this right fix?
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>


__splice_from_pipe() is updating the sd->pos for the actor, but those
functions are passing the sd of reader side directory. So, splice
updates sd->pos twice.

This fixes usage of __splice_from_pipe().

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 drivers/block/loop.c |    5 +++--
 fs/nfsd/vfs.c        |    5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff -puN fs/nfsd/vfs.c~splice-fix-__splice_from_pipe-usage fs/nfsd/vfs.c
--- linux-2.6/fs/nfsd/vfs.c~splice-fix-__splice_from_pipe-usage	2007-07-16 09:30:10.000000000 +0900
+++ linux-2.6-hirofumi/fs/nfsd/vfs.c	2007-07-16 09:30:10.000000000 +0900
@@ -842,9 +842,10 @@ nfsd_splice_actor(struct pipe_inode_info
 }
 
 static int nfsd_direct_splice_actor(struct pipe_inode_info *pipe,
-				    struct splice_desc *sd)
+				    struct splice_desc *__sd)
 {
-	return __splice_from_pipe(pipe, sd, nfsd_splice_actor);
+	struct splice_desc sd = *__sd;
+	return __splice_from_pipe(pipe, &sd, nfsd_splice_actor);
 }
 
 static __be32
diff -puN drivers/block/loop.c~splice-fix-__splice_from_pipe-usage drivers/block/loop.c
--- linux-2.6/drivers/block/loop.c~splice-fix-__splice_from_pipe-usage	2007-07-16 09:30:10.000000000 +0900
+++ linux-2.6-hirofumi/drivers/block/loop.c	2007-07-16 09:30:10.000000000 +0900
@@ -437,9 +437,10 @@ lo_splice_actor(struct pipe_inode_info *
 }
 
 static int
-lo_direct_splice_actor(struct pipe_inode_info *pipe, struct splice_desc *sd)
+lo_direct_splice_actor(struct pipe_inode_info *pipe, struct splice_desc *__sd)
 {
-	return __splice_from_pipe(pipe, sd, lo_splice_actor);
+	struct splice_desc sd = *__sd;
+	return __splice_from_pipe(pipe, &sd, lo_splice_actor);
 }
 
 static int
_
