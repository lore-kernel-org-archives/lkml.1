Return-Path: <linux-kernel-owner+w=401wt.eu-S1760437AbYDVDPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760437AbYDVDPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 23:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756740AbYDVDPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 23:15:30 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:51211 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097AbYDVDP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 23:15:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:message-id;
        b=la+2VHOE5e64ObqDuIjJjm5zTekmEsLby61kEq69G4UCfX7MzFdcQdbNiLU/YsOuaD+4am/PFzfE+Hr/9MiuTgTnR3D23xzLbXRCPKD9AM88Cj6wzCOk30TcvUi7AbRuLKAust1wouOfmnhEUcfslwBhBYOkJRRbFM+6e7chKVI=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: David Chinner <dgc@sgi.com>
Subject: [PATCH] xfs: use smaller int param in call to xfs_flush_pages
Date: Tue, 22 Apr 2008 05:14:45 +0200
User-Agent: KMail/1.8.2
Cc: Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080419142329.GA5339@elte.hu> <200804220433.04030.vda.linux@googlemail.com> <200804220503.16888.vda.linux@googlemail.com>
In-Reply-To: <200804220503.16888.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_lgVDISElYA/CRkJ"
Message-Id: <200804220514.45191.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_lgVDISElYA/CRkJ
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi David,

xfs_flush_pages() flags parameter is declared as uint64_t, but
code never pass values which do not fit into 32 bits.
All callsites sans one pass zero, and the last one passes
XFS_B_DELWRI, XFS_B_ASYNC or zero.
These values are defined in enum xfs_buf_flags_t and they
all fit in 32 bits.

This patch changes type of the parameter and one variable
which used to pass it to unsigned int.

Code size difference on 32-bit x86:

# size */fs/xfs/xfs.o
   text    data     bss     dec     hex filename
 390567    2748    1708  395023   6070f linux-2.6-xfs2-TEST/fs/xfs/xfs.o
 390507    2748    1708  394963   606d3 linux-2.6-xfs3-TEST/fs/xfs/xfs.o

Compile-tested only.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_lgVDISElYA/CRkJ
Content-Type: text/x-diff;
  charset="koi8-r";
  name="xfs2-xfs_flush_pages-use_smaller_int_param.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="xfs2-xfs_flush_pages-use_smaller_int_param.patch"

--- linux-2.6-xfs2/fs/xfs/linux-2.6/xfs_fs_subr.c	Tue Apr 22 04:46:33 2008
+++ linux-2.6-xfs3/fs/xfs/linux-2.6/xfs_fs_subr.c	Tue Apr 22 05:05:47 2008
@@ -72,7 +72,7 @@
 int
 xfs_flush_pages(
 	xfs_inode_t	*ip,
-	uint64_t	flags)
+	unsigned int	flags)
 {
 	bhv_vnode_t	*vp = XFS_ITOV(ip);
 	struct inode	*inode = vn_to_inode(vp);
--- linux-2.6-xfs2/fs/xfs/xfs_vfsops.c	Tue Apr 22 04:47:36 2008
+++ linux-2.6-xfs3/fs/xfs/xfs_vfsops.c	Tue Apr 22 05:05:17 2008
@@ -897,7 +897,7 @@
 	bhv_vnode_t	*vp = NULL;
 	int		error;
 	int		last_error;
-	uint64_t	fflag;
+	unsigned int	fflag;
 	uint		lock_flags;
 	uint		base_lock_flags;
 	boolean_t	mount_locked;
--- linux-2.6-xfs2/fs/xfs/xfs_vnodeops.h	Tue Apr 22 04:46:59 2008
+++ linux-2.6-xfs3/fs/xfs/xfs_vnodeops.h	Tue Apr 22 05:04:52 2008
@@ -78,6 +78,6 @@
 		xfs_off_t last, int fiopt);
 int xfs_flushinval_pages(struct xfs_inode *ip, xfs_off_t first,
 		xfs_off_t last, int fiopt);
-int xfs_flush_pages(struct xfs_inode *ip, uint64_t flags);
+int xfs_flush_pages(struct xfs_inode *ip, unsigned int flags);
 
 #endif /* _XFS_VNODEOPS_H */

--Boundary-00=_lgVDISElYA/CRkJ--
