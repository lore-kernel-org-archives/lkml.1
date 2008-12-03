Return-Path: <linux-kernel-owner+w=401wt.eu-S1754458AbYLCMzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbYLCMzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 07:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbYLCMzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 07:55:37 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47038 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbYLCMzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 07:55:36 -0500
Date: Wed, 3 Dec 2008 07:55:34 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: next-20081203 build failure, when building xfs_file.o
Message-ID: <20081203125534.GA8007@infradead.org>
References: <20081203183602.c06f8c39.sfr@canb.auug.org.au> <20081203124104.GA5400@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203124104.GA5400@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 06:11:04PM +0530, Kamalesh Babulal wrote:
> Hi Stephen,
> 
> 	next-20081203 kernel build fails on x86 with build failure
> 
> In file included from fs/xfs/linux-2.6/xfs_file.c:39:

This is the fix I submitted for it yesterday:

-- 

fix compile on 32 bit systems

The recent compat patches make xfs_file.c include xfs_ioctl32.h unconditional,
which breaks the build on 32 bit systems which don't have the various compat
defintions.

Remove the include and move the defintion of xfs_file_compat_ioctl to
xfs_ioctl.h so that we can avoid including all the compat defintions in
xfs_file.c


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-master/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- xfs-master.orig/fs/xfs/linux-2.6/xfs_file.c	2008-12-02 11:43:38.000000000 +0100
+++ xfs-master/fs/xfs/linux-2.6/xfs_file.c	2008-12-02 11:44:06.000000000 +0100
@@ -36,9 +36,9 @@
 #include "xfs_inode.h"
 #include "xfs_error.h"
 #include "xfs_rw.h"
-#include "xfs_ioctl32.h"
 #include "xfs_vnodeops.h"
 #include "xfs_da_btree.h"
+#include "xfs_ioctl.h"
 
 #include <linux/dcache.h>
 #include <linux/smp_lock.h>
Index: xfs-master/fs/xfs/linux-2.6/xfs_ioctl.h
===================================================================
--- xfs-master.orig/fs/xfs/linux-2.6/xfs_ioctl.h	2008-12-02 11:44:10.000000000 +0100
+++ xfs-master/fs/xfs/linux-2.6/xfs_ioctl.h	2008-12-02 11:44:52.000000000 +0100
@@ -67,4 +67,16 @@ xfs_attrmulti_attr_remove(
 	char			*name,
 	__uint32_t		flags);
 
+extern long
+xfs_file_compat_ioctl(
+	struct file		*file,
+	unsigned int		cmd,
+	unsigned long		arg);
+
+extern long
+xfs_file_compat_ioctl_invis(
+	struct file		*file,
+	unsigned int		cmd,
+	unsigned long		arg);
+
 #endif
Index: xfs-master/fs/xfs/linux-2.6/xfs_ioctl32.h
===================================================================
--- xfs-master.orig/fs/xfs/linux-2.6/xfs_ioctl32.h	2008-12-02 11:44:10.000000000 +0100
+++ xfs-master/fs/xfs/linux-2.6/xfs_ioctl32.h	2008-12-02 11:44:18.000000000 +0100
@@ -20,9 +20,6 @@
 
 #include <linux/compat.h>
 
-extern long xfs_file_compat_ioctl(struct file *, unsigned, unsigned long);
-extern long xfs_file_compat_invis_ioctl(struct file *, unsigned, unsigned long);
-
 /*
  * on 32-bit arches, ioctl argument structures may have different sizes
  * and/or alignment.  We define compat structures which match the
