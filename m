Return-Path: <linux-kernel-owner+w=401wt.eu-S1755121AbYEIKlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbYEIKlj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 06:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbYEIKla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 06:41:30 -0400
Received: from verein.lst.de ([213.95.11.210]:36464 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbYEIKl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 06:41:29 -0400
Date: Fri, 9 May 2008 12:41:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: starvik@axis.com, jesper.nilsson@axis.com, torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] cris: kill sys_pipe implementation
Message-ID: <20080509104116.GA7883@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cris implementation of sys_pipe only differs from the generic one
by taking the BKL before calling do_pipe which isn't not nessecary.

Just kill the cris implementation and use the generic one.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/cris/kernel/sys_cris.c
===================================================================
--- linux-2.6.orig/arch/cris/kernel/sys_cris.c	2008-05-09 12:39:34.000000000 +0200
+++ linux-2.6/arch/cris/kernel/sys_cris.c	2008-05-09 12:39:44.000000000 +0200
@@ -27,28 +27,6 @@
 #include <asm/uaccess.h>
 #include <asm/segment.h>
 
-/*
- * sys_pipe() is the normal C calling standard for creating
- * a pipe. It's not the way Unix traditionally does this, though.
- */
-asmlinkage int sys_pipe(unsigned long __user * fildes)
-{
-        int fd[2];
-        int error;
-
-        lock_kernel();
-        error = do_pipe(fd);
-        unlock_kernel();
-        if (!error) {
-                if (copy_to_user(fildes, fd, 2*sizeof(int))) {
-			sys_close(fd[0]);
-			sys_close(fd[1]);
-                        error = -EFAULT;
-		}
-        }
-        return error;
-}
-
 /* common code for old and new mmaps */
 static inline long
 do_mmap2(unsigned long addr, unsigned long len, unsigned long prot,
