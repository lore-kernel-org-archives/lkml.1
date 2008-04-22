Return-Path: <linux-kernel-owner+w=401wt.eu-S1760254AbYDVDEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760254AbYDVDEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 23:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757436AbYDVDD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 23:03:59 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:39029 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834AbYDVDD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 23:03:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:message-id;
        b=oF7skXJz5+TNHNA5JED9+2mSURj6wcD1yf8poY/rcbku4f+NkdhOmiWQM56yXC+z15aj2Y6+R/G/4hXLsMnKw1PlRa5YQv9Y+DoBsLyvUjnvjD7JpYQ8pt2jXZjHMp0BbFihseGx4ggMjs00UV6LhfBaslDu6vuIzVgTttr1Wfk=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: David Chinner <dgc@sgi.com>
Subject: [PATCH] xfs: do not pass unused params to xfs_flush_pages
Date: Tue, 22 Apr 2008 05:03:16 +0200
User-Agent: KMail/1.8.2
Cc: Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080419142329.GA5339@elte.hu> <20080422012819.GT108924158@sgi.com> <200804220433.04030.vda.linux@googlemail.com>
In-Reply-To: <200804220433.04030.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_0VVDICGzH/wSRv3"
Message-Id: <200804220503.16888.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_0VVDICGzH/wSRv3
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi David,

xfs_flush_pages() does not use some of its parameters, namely:
first, last and fiops.

This patch removes these parameters from all callsites.

Code size difference on 32-bit x86:

   text    data     bss     dec     hex filename
 390739    2748    1708  395195   607bb linux-2.6-xfs1-TEST/fs/xfs/xfs.o
 390567    2748    1708  395023   6070f linux-2.6-xfs2-TEST/fs/xfs/xfs.o

Compile-tested only.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_0VVDICGzH/wSRv3
Content-Type: text/x-diff;
  charset="koi8-r";
  name="xfs1-xfs_flush_pages-remove_unused_params.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="xfs1-xfs_flush_pages-remove_unused_params.patch"

--- linux-2.6-xfs1/fs/xfs/linux-2.6/xfs_aops.c	Tue Apr 22 04:06:46 2008
+++ linux-2.6-xfs2/fs/xfs/linux-2.6/xfs_aops.c	Tue Apr 22 04:46:49 2008
@@ -1533,7 +1532,7 @@
 
 	xfs_itrace_entry(XFS_I(inode));
 	xfs_rwlock(ip, VRWLOCK_READ);
-	xfs_flush_pages(ip, (xfs_off_t)0, -1, 0, FI_REMAPF);
+	xfs_flush_pages(ip, 0);
 	xfs_rwunlock(ip, VRWLOCK_READ);
 	return generic_block_bmap(mapping, block, xfs_get_blocks);
 }
--- linux-2.6-xfs1/fs/xfs/linux-2.6/xfs_fs_subr.c	Tue Apr 22 04:06:46 2008
+++ linux-2.6-xfs2/fs/xfs/linux-2.6/xfs_fs_subr.c	Tue Apr 22 04:46:33 2008
@@ -72,10 +72,7 @@
 int
 xfs_flush_pages(
 	xfs_inode_t	*ip,
-	xfs_off_t	first,
-	xfs_off_t	last,
-	uint64_t	flags,
-	int		fiopt)
+	uint64_t	flags)
 {
 	bhv_vnode_t	*vp = XFS_ITOV(ip);
 	struct inode	*inode = vn_to_inode(vp);
--- linux-2.6-xfs1/fs/xfs/xfs_bmap.c	Tue Apr 22 04:16:25 2008
+++ linux-2.6-xfs2/fs/xfs/xfs_bmap.c	Tue Apr 22 04:47:22 2008
@@ -5867,8 +5867,7 @@
 	if (whichfork == XFS_DATA_FORK &&
 		(ip->i_delayed_blks || ip->i_size > ip->i_d.di_size)) {
 		/* xfs_fsize_t last_byte = xfs_file_last_byte(ip); */
-		error = xfs_flush_pages(ip, (xfs_off_t)0,
-					       -1, 0, FI_REMAPF);
+		error = xfs_flush_pages(ip, 0);
 	}
 
 	ASSERT(whichfork == XFS_ATTR_FORK || ip->i_delayed_blks == 0);
--- linux-2.6-xfs1/fs/xfs/xfs_vfsops.c	Tue Apr 22 04:18:53 2008
+++ linux-2.6-xfs2/fs/xfs/xfs_vfsops.c	Tue Apr 22 04:47:36 2008
@@ -1121,8 +1121,7 @@
 					error = xfs_flushinval_pages(ip,
 							0, -1, FI_REMAPF);
 			} else if ((flags & SYNC_DELWRI) && VN_DIRTY(vp)) {
-				error = xfs_flush_pages(ip, 0,
-							-1, fflag, FI_NONE);
+				error = xfs_flush_pages(ip, fflag);
 			}
 
 			/*
--- linux-2.6-xfs1/fs/xfs/xfs_vnodeops.c	Tue Apr 22 04:06:44 2008
+++ linux-2.6-xfs2/fs/xfs/xfs_vnodeops.c	Tue Apr 22 04:47:13 2008
@@ -592,9 +592,7 @@
 		if (!code &&
 		    (ip->i_size != ip->i_d.di_size) &&
 		    (vap->va_size > ip->i_d.di_size)) {
-			code = xfs_flush_pages(ip,
-					ip->i_d.di_size, vap->va_size,
-					XFS_B_ASYNC, FI_NONE);
+			code = xfs_flush_pages(ip, XFS_B_ASYNC);
 		}
 
 		/* wait for all I/O to complete */
@@ -1517,7 +1515,7 @@
 		 */
 		truncated = xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED);
 		if (truncated && VN_DIRTY(vp) && ip->i_delayed_blks > 0)
-			xfs_flush_pages(ip, 0, -1, XFS_B_ASYNC, FI_NONE);
+			xfs_flush_pages(ip, XFS_B_ASYNC);
 	}
 
 #ifdef HAVE_REFCACHE
--- linux-2.6-xfs1/fs/xfs/xfs_vnodeops.h	Tue Apr 22 04:06:44 2008
+++ linux-2.6-xfs2/fs/xfs/xfs_vnodeops.h	Tue Apr 22 04:46:59 2008
@@ -78,7 +78,6 @@
 		xfs_off_t last, int fiopt);
 int xfs_flushinval_pages(struct xfs_inode *ip, xfs_off_t first,
 		xfs_off_t last, int fiopt);
-int xfs_flush_pages(struct xfs_inode *ip, xfs_off_t first,
-		xfs_off_t last, uint64_t flags, int fiopt);
+int xfs_flush_pages(struct xfs_inode *ip, uint64_t flags);
 
 #endif /* _XFS_VNODEOPS_H */

--Boundary-00=_0VVDICGzH/wSRv3--
