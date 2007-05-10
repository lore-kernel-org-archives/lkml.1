Return-Path: <linux-kernel-owner+w=401wt.eu-S1758932AbXEJJlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932AbXEJJlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 05:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755700AbXEJJlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 05:41:25 -0400
Received: from koto.vergenet.net ([210.128.90.7]:44161 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577AbXEJJlZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 05:41:25 -0400
Date: Thu, 10 May 2007 18:41:20 +0900
From: Simon Horman <horms@verge.net.au>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Andi Kleen <ak@suse.de>,
       Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Allow compat_ioctl.c to compile without CONFIG_NET
Message-ID: <20070510094110.GA16051@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A small regression appears to have been introduced in the recent patch
"cleanup compat ioctl handling", which was included in Linus' tree after
2.6.20.

siocdevprivate_ioctl() is no longer defined if CONFIG_NET is undefined,
whereas previously it was a dummy function in this case.

This causes compilation with CONFIG_COMPAT but without CONFIG_NET to fail.

fs/compat_ioctl.c: In function `compat_sys_ioctl':
fs/compat_ioctl.c:3571: warning: implicit declaration of function `siocdevprivate_ioctl'

Cc: Christoph Hellwig <hch@lst.de>
From: Simon Horman <horms@verge.net.au>

Index: linux-2.6/fs/compat_ioctl.c
===================================================================
--- linux-2.6.orig/fs/compat_ioctl.c	2007-05-10 18:40:19.000000000 +0900
+++ linux-2.6/fs/compat_ioctl.c	2007-05-10 18:40:23.000000000 +0900
@@ -3566,10 +3566,13 @@ asmlinkage long compat_sys_ioctl(unsigne
 			goto found_handler;
 	}
 
+#ifdef CONFIG_NET
 	if (S_ISSOCK(filp->f_path.dentry->d_inode->i_mode) &&
 	    cmd >= SIOCDEVPRIVATE && cmd <= (SIOCDEVPRIVATE + 15)) {
 		error = siocdevprivate_ioctl(fd, cmd, arg);
-	} else {
+	} else
+#endif
+	{
 		static int count;
 
 		if (++count <= 50)
