Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbYDVLVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbYDVLVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 07:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbYDVLVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 07:21:36 -0400
Received: from hu-out-0506.google.com ([72.14.214.234]:51575 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbYDVLVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 07:21:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:message-id;
        b=qnxw3k3Hbk/9g1qkTEYLmp6RSNXc7Zur8ifknbHQxV3XxSu+LbNhekccq62ee9ojSHyBv0ZN0Gyloo+osQmPo6vikvSYwqWYOPjgB7BsinF7WPLDgeXDhw3feF64MNlRdzF7LMO7YHg5ypsRdbWprmshDimXydlsXrz9KXzvcWA=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] xfs: #define out unused parameters of xfs_bmap_add_free and xfs_btree_read_bufl
Date: Tue, 22 Apr 2008 13:20:54 +0200
User-Agent: KMail/1.8.2
Cc: Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080419142329.GA5339@elte.hu> <200804221142.00914.vda.linux@googlemail.com> <200804221216.25905.vda.linux@googlemail.com>
In-Reply-To: <200804221216.25905.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_WocDI9o7ShYH5Qd"
Message-Id: <200804221320.54147.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_WocDI9o7ShYH5Qd
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi David,

xfs_bmap_add_free and xfs_btree_read_bufl functions
use some of their parameters only in some cases
(e.g. if DEBUG is defined, or on non-Linux OS :)

This patch removes these parameters using #define hack
which makes them "disappear" without the need of uglifying
every callsite with #ifdefs.

Code size difference on 32-bit x86:
 393457    2904    2952  399313   617d1 linux-2.6-xfs6-TEST/fs/xfs/xfs.o
 393441    2904    2952  399297   617c1 linux-2.6-xfs7-TEST/fs/xfs/xfs.o

Compile tested only.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_WocDI9o7ShYH5Qd
Content-Type: text/x-diff;
  charset="koi8-r";
  name="xfs5-xfs_bmap_add_free_xfs_btree_read_bufl-remove_unused_params.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="xfs5-xfs_bmap_add_free_xfs_btree_read_bufl-remove_unused_params.patch"

diff -urpN linux-2.6-xfs6/fs/xfs/xfs_bmap.h linux-2.6-xfs7/fs/xfs/xfs_bmap.h
--- linux-2.6-xfs6/fs/xfs/xfs_bmap.h	2008-04-22 04:06:43.000000000 +0200
+++ linux-2.6-xfs7/fs/xfs/xfs_bmap.h	2008-04-22 13:10:36.000000000 +0200
@@ -170,6 +170,10 @@ xfs_bmap_add_attrfork(
  * Add the extent to the list of extents to be free at transaction end.
  * The list is maintained sorted (by block number).
  */
+#ifndef DEBUG
+/* "mp" is used only for debugging */
+#define xfs_bmap_add_free(bno, len, flist, mp) xfs_bmap_add_free(bno, len, flist)
+#endif
 void
 xfs_bmap_add_free(
 	xfs_fsblock_t		bno,		/* fs block number of extent */
diff -urpN linux-2.6-xfs6/fs/xfs/xfs_btree.h linux-2.6-xfs7/fs/xfs/xfs_btree.h
--- linux-2.6-xfs6/fs/xfs/xfs_btree.h	2008-04-22 04:06:43.000000000 +0200
+++ linux-2.6-xfs7/fs/xfs/xfs_btree.h	2008-04-22 13:10:36.000000000 +0200
@@ -363,6 +363,9 @@ xfs_btree_offsets(
  * Get a buffer for the block, return it read in.
  * Long-form addressing.
  */
+/* In Linux, "refval" is not used */
+#define xfs_btree_read_bufl(mp, tp, fsbno, lock, bpp, refval) \
+	xfs_btree_read_bufl(mp, tp, fsbno, lock, bpp)
 int					/* error */
 xfs_btree_read_bufl(
 	struct xfs_mount	*mp,	/* file system mount point */

--Boundary-00=_WocDI9o7ShYH5Qd--
