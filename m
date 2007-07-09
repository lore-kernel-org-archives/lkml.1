Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbXGINl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbXGINl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 09:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbXGINlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 09:41:19 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54652 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751315AbXGINlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 09:41:18 -0400
Date: Mon, 9 Jul 2007 14:47:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] generic_nvram: use inode lock not lock_kernel
Message-ID: <20070709144745.029094ae@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The locking is only done for lseek so this isn't a big change. All the
other operations are thrown at the arch specific lower layers for locking
handling without the file pointer being directly exposed.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc6-mm1/drivers/char/generic_nvram.c linux-2.6.22-rc6-mm1/drivers/char/generic_nvram.c
--- linux.vanilla-2.6.22-rc6-mm1/drivers/char/generic_nvram.c	2007-07-02 20:47:23.000000000 +0100
+++ linux-2.6.22-rc6-mm1/drivers/char/generic_nvram.c	2007-07-09 12:05:06.786669552 +0100
@@ -30,7 +30,7 @@
 
 static loff_t nvram_llseek(struct file *file, loff_t offset, int origin)
 {
-	lock_kernel();
+	mutex_lock(&file->f_path.dentry->d_inode->i_mutex);
 	switch (origin) {
 	case 1:
 		offset += file->f_pos;
@@ -44,7 +44,7 @@
 		return -EINVAL;
 	}
 	file->f_pos = offset;
-	unlock_kernel();
+	mutex_unlock(&file->f_path.dentry->d_inode->i_mutex);
 	return file->f_pos;
 }
 
