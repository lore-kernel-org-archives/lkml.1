Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbYDZOwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbYDZOwS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 10:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbYDZOwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 10:52:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:6366 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbYDZOwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 10:52:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:message-id;
        b=JurhA4H3/QqpohKXDgoV01M/6oCjywC4vmtBS9eAU33DLc32RF/DTBLOYqW7eLwwbTyzvLvdH+9B/pwgYKQeo3+N5JS8xaCuUSpqWKFhU0yU/XL2Mfk0r2Se4NGCuDzEZN3qKNdEZntHd1L8OveBg/Epsv632IPSfmqAom4riqg=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: David Chinner <dgc@sgi.com>
Subject: [PATCH] xfs: reduce stack usage in xfs_bmap_btalloc()
Date: Sat, 26 Apr 2008 16:51:02 +0200
User-Agent: KMail/1.8.2
Cc: xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_WF0EIOQeTE8UKE+"
Message-Id: <200804261651.02078.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_WF0EIOQeTE8UKE+
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi David,

This patch reduces xfs_bmap_btalloc() stack usage by 50 bytes
by moving part of its body into a helper function.

This results in some variables not taking stack space in
xfs_bmap_btalloc() anymore.

The helper itself does not call anything stack-deep.
Stack-deep call to xfs_alloc_vextent() happen
in xfs_bmap_btalloc(), as before.

Compile tested only.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_WF0EIOQeTE8UKE+
Content-Type: text/x-diff;
  charset="us-ascii";
  name="stk1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="stk1.diff"

diff -urpN linux-2.6-xfs1/fs/xfs/xfs_bmap.c linux-2.6-xfs1.stk1/fs/xfs/xfs_bmap.c
--- linux-2.6-xfs1/fs/xfs/xfs_bmap.c	2008-04-22 04:16:25.000000000 +0200
+++ linux-2.6-xfs1.stk1/fs/xfs/xfs_bmap.c	2008-04-26 16:23:26.000000000 +0200
@@ -2648,26 +2648,18 @@ xfs_bmap_rtalloc(
 }
 
 STATIC int
-xfs_bmap_btalloc(
-	xfs_bmalloca_t	*ap)		/* bmap alloc argument struct */
+xfs_bmap_btalloc_helper(
+	xfs_bmalloca_t	*ap,		/* bmap alloc argument struct */
+	xfs_alloc_arg_t	*argsp,
+	xfs_extlen_t	*blenp)
 {
+#define args (*argsp)
+#define blen (*blenp)
 	xfs_mount_t	*mp;		/* mount point structure */
-	xfs_alloctype_t	atype = 0;	/* type for allocation routines */
 	xfs_extlen_t	align;		/* minimum allocation alignment */
 	xfs_agnumber_t	ag;
 	xfs_agnumber_t	fb_agno;	/* ag number of ap->firstblock */
-	xfs_agnumber_t	startag;
-	xfs_alloc_arg_t	args;
-	xfs_extlen_t	blen;
-	xfs_extlen_t	delta;
-	xfs_extlen_t	longest;
-	xfs_extlen_t	need;
-	xfs_extlen_t	nextminlen = 0;
-	xfs_perag_t	*pag;
 	int		nullfb;		/* true if ap->firstblock isn't set */
-	int		isaligned;
-	int		notinit;
-	int		tryagain;
 	int		error;
 
 	mp = ap->ip->i_mount;
@@ -2705,7 +2697,6 @@ xfs_bmap_btalloc(
 	/*
 	 * Normal allocation, done through xfs_alloc_vextent.
 	 */
-	tryagain = isaligned = 0;
 	args.tp = ap->tp;
 	args.mp = mp;
 	args.fsbno = ap->rval;
@@ -2713,6 +2704,9 @@ xfs_bmap_btalloc(
 	args.firstblock = ap->firstblock;
 	blen = 0;
 	if (nullfb) {
+		xfs_agnumber_t	startag;
+		int		notinit;
+
 		if (ap->userdata && xfs_inode_is_filestream(ap->ip))
 			args.type = XFS_ALLOCTYPE_NEAR_BNO;
 		else
@@ -2732,6 +2726,8 @@ xfs_bmap_btalloc(
 		notinit = 0;
 		down_read(&mp->m_peraglock);
 		while (blen < ap->alen) {
+			xfs_perag_t	*pag;
+
 			pag = &mp->m_perag[ag];
 			if (!pag->pagf_init &&
 			    (error = xfs_alloc_pagf_init(mp, args.tp,
@@ -2743,6 +2739,10 @@ xfs_bmap_btalloc(
 			 * See xfs_alloc_fix_freelist...
 			 */
 			if (pag->pagf_init) {
+				xfs_extlen_t	need;
+				xfs_extlen_t	delta;
+				xfs_extlen_t	longest;
+
 				need = XFS_MIN_FREELIST_PAG(pag, mp);
 				delta = need > pag->pagf_flcount ?
 					need - pag->pagf_flcount : 0;
@@ -2838,6 +2838,33 @@ xfs_bmap_btalloc(
 		if ((args.mod = (xfs_extlen_t)(do_mod(ap->off, args.prod))))
 			args.mod = (xfs_extlen_t)(args.prod - args.mod);
 	}
+
+	return 0; /* no error */
+#undef args
+#undef blen
+}
+
+STATIC int
+xfs_bmap_btalloc(
+	xfs_bmalloca_t	*ap)		/* bmap alloc argument struct */
+{
+	xfs_mount_t	*mp;		/* mount point structure */
+	xfs_alloctype_t	atype;		/* type for allocation routines */
+	xfs_alloc_arg_t	args;
+	xfs_extlen_t	blen;
+	xfs_extlen_t	nextminlen;
+	int		nullfb;		/* true if ap->firstblock isn't set */
+	int		isaligned;
+	int		tryagain;
+	int		error;
+
+	error = xfs_bmap_btalloc_helper(ap, &args, &blen);
+	if (error)
+		return error;
+
+	mp = ap->ip->i_mount;
+	nullfb = ap->firstblock == NULLFSBLOCK;
+
 	/*
 	 * If we are not low on available data blocks, and the
 	 * underlying logical volume manager is a stripe, and
@@ -2847,10 +2874,13 @@ xfs_bmap_btalloc(
 	 * is >= the stripe unit and the allocation offset is
 	 * at the end of file.
 	 */
+	atype = 0;
+	nextminlen = 0;
+	tryagain = isaligned = 0;
 	if (!ap->low && ap->aeof) {
+		atype = args.type;
 		if (!ap->off) {
 			args.alignment = mp->m_dalign;
-			atype = args.type;
 			isaligned = 1;
 			/*
 			 * Adjust for alignment
@@ -2864,7 +2894,6 @@ xfs_bmap_btalloc(
 			 * If it fails then do a near or start bno
 			 * allocation with alignment turned on.
 			 */
-			atype = args.type;
 			tryagain = 1;
 			args.type = XFS_ALLOCTYPE_THIS_BNO;
 			args.alignment = 1;

--Boundary-00=_WF0EIOQeTE8UKE+--
