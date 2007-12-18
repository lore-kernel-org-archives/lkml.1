Return-Path: <linux-kernel-owner+w=401wt.eu-S1760835AbXLRRgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760835AbXLRRgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 12:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755485AbXLRRgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 12:36:45 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53245 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbXLRRgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 12:36:44 -0500
Date: Tue, 18 Dec 2007 17:36:42 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Bret Towe <magnade@gmail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: xfs mknod regression
Message-ID: <20071218173642.GA7338@infradead.org>
References: <dda83e780712172048n4d40cfcbw4a4d3106fc99f02e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dda83e780712172048n4d40cfcbw4a4d3106fc99f02e@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This was broken by my '[XFS] simplify xfs_create/mknod/symlink prototype',
which assigned the re-shuffled ondisk dev_t back to the rdev variable in
xfs_vn_mknod.  Because of that i_rdev is set to the ondisk dev_t instead
of the linux dev_t later down the function.

Fortunately the fix for it is trivial:  we can just remove the
assignment because xfs_revalidate_inode has done the proper job before
unlocking the inode.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2007-12-18 18:23:32.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2007-12-18 18:23:43.000000000 +0100
@@ -345,9 +345,7 @@ xfs_vn_mknod(
 		ASSERT(vp);
 		ip = vn_to_inode(vp);
 
-		if (S_ISCHR(mode) || S_ISBLK(mode))
-			ip->i_rdev = rdev;
-		else if (S_ISDIR(mode))
+		if (S_ISDIR(mode))
 			xfs_validate_fields(ip);
 		d_instantiate(dentry, ip);
 		xfs_validate_fields(dir);
