Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797AbYIPJ2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbYIPJ2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 05:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbYIPJ2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 05:28:03 -0400
Received: from host254-130-static.190-82-b.business.telecomitalia.it ([82.190.130.254]:36703
	"EHLO nausicaa2.coritel.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753170AbYIPJ2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 05:28:01 -0400
Message-ID: <48CF7C85.1070309@coritel.it>
Date: Tue, 16 Sep 2008 11:29:41 +0200
From: Marco Stornelli <marco.stornelli@coritel.it>
Organization: CoRiTeL
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] vfs: added better file aio_read aio_write operations presence
 check
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

If a filesystem in the file operations specifies for read and write operations only do_sync_read and do_sync_write without 
init aio_read and aio_write, there will be a kernel oops, because the vfs code check the presence of (to read for example)
read OR aio_read method, then it calls read if it's pointer is not null. It's not sufficient because if the read function is 
actually a do_sync_read, it calls aio_read but without checking the presence. I think a BUG_ON check can be more useful.
Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---

--- linux-2.6.26.5/fs/read_write.c.orig	2008-08-20 20:11:37.000000000 +0200
+++ linux-2.6.26.5/fs/read_write.c	2008-09-16 11:01:13.000000000 +0200
@@ -240,6 +240,7 @@ ssize_t do_sync_read(struct file *filp,
 	kiocb.ki_pos = *ppos;
 	kiocb.ki_left = len;
 
+	BUG_ON(!filp->f_op->aio_read);
 	for (;;) {
 		ret = filp->f_op->aio_read(&kiocb, &iov, 1, kiocb.ki_pos);
 		if (ret != -EIOCBRETRY)
@@ -295,6 +296,7 @@ ssize_t do_sync_write(struct file *filp,
 	kiocb.ki_pos = *ppos;
 	kiocb.ki_left = len;
 
+	BUG_ON(!filp->f_op->aio_write);
 	for (;;) {
 		ret = filp->f_op->aio_write(&kiocb, &iov, 1, kiocb.ki_pos);
 		if (ret != -EIOCBRETRY)

