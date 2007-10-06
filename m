Return-Path: <linux-kernel-owner+w=401wt.eu-S1765184AbXJFSbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765184AbXJFSbi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 14:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764764AbXJFSa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 14:30:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:55226 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764950AbXJFSa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 14:30:57 -0400
Message-Id: <20071006182343.857595918@arndb.de>
References: <20071006181902.141862534@arndb.de>
User-Agent: quilt/0.46-1
Date: Sat, 06 Oct 2007 20:19:11 +0200
From: Arnd Bergmann <arnd@arndb.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, hch@lst.de,
       Al Viro <viro@ftp.linux.org.uk>
Subject: [patch 9/9] compat_ioctl: fix compat_fd_ioctl pointer access
Content-Disposition: inline; filename=compat-floppy-ioctl-pointer.diff
X-Provags-ID: V01U2FsdGVkX18W8U/KvUQVx+ODNwKCAYs9ma77vtLqP8YrCpP
 +VXBp6q46n4coxcS4MEabqpQNmorLy8DbGtKBRX8pRAS4vxiqx
 wQ2w3ISrn/wUKmOPXYd0A==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As found by sparse, a user space pointer is assigned to a kernel
data structure while calling other code with set_fs(KERNEL_DS),
which could lead to leaking kernel data if that pointer is
ever accessed.

I could not find any place in the floppy drivers that actually
uses that pointer, but assigning it to an empty string is
a safer choice and gets rid of the sparse warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Index: linux-2.6/block/compat_ioctl.c
===================================================================
--- linux-2.6.orig/block/compat_ioctl.c
+++ linux-2.6/block/compat_ioctl.c
@@ -349,7 +349,7 @@ static int compat_fd_ioctl(struct inode 
 		err |= __get_user(f->spec1, &uf->spec1);
 		err |= __get_user(f->fmt_gap, &uf->fmt_gap);
 		err |= __get_user(name, &uf->name);
-		f->name = compat_ptr(name);
+		f->name = "";
 		if (err) {
 			err = -EFAULT;
 			goto out;

-- 

