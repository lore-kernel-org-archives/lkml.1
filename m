Return-Path: <linux-kernel-owner+w=401wt.eu-S1755079AbYLUQil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbYLUQil (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 11:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbYLUQic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 11:38:32 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:45932 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116AbYLUQib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 11:38:31 -0500
Date: Sun, 21 Dec 2008 17:38:29 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 9/13] fs/xfs: Remove redundant test
In-Reply-To: <494E6846.8070800@sandeen.net>
Message-ID: <Pine.LNX.4.64.0812211737180.9555@pc-004.diku.dk>
References: <Pine.LNX.4.64.0812211640360.9555@pc-004.diku.dk>
 <494E6846.8070800@sandeen.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In fs/xfs/xfs_trans_buf.c, bp is tested for being NULL just a few lines
above.

A simplified version of the semantic patch that makes this change is as
follows: (http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
expression E;
position p1,p2;
@@

if (x@p1 == NULL || ...) { ... when forall
   return ...; }
... when != \(x=E\|x--\|x++\|--x\|++x\|x-=E\|x+=E\|x|=E\|x&=E\|&x\)
(
x@p2 == NULL
|
x@p2 != NULL
)

// another path to the test that is not through p1?
@s exists@
local idexpression r.x;
position r.p1,r.p2;
@@

... when != x@p1
(
x@p2 == NULL
|
x@p2 != NULL
)

@fix depends on !s@
position r.p1,r.p2;
expression x,E;
statement S1,S2;
@@

(
- if ((x@p2 != NULL) || ...)
  S1
|
- if ((x@p2 == NULL) && ...) S1
|
- BUG_ON(x@p2 == NULL);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 var/julia/linuxcopy/fs/xfs/xfs_trans_buf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/var/linuxes/linux-next/fs/xfs/xfs_trans_buf.c b/var/julia/linuxcopy/fs/xfs/xfs_trans_buf.c
index 8ee2f8c..218829e 100644
--- a/var/linuxes/linux-next/fs/xfs/xfs_trans_buf.c
+++ b/var/julia/linuxcopy/fs/xfs/xfs_trans_buf.c
@@ -307,7 +307,7 @@ xfs_trans_read_buf(
 			return (flags & XFS_BUF_TRYLOCK) ?
 					EAGAIN : XFS_ERROR(ENOMEM);
 
-		if ((bp != NULL) && (XFS_BUF_GETERROR(bp) != 0)) {
+		if (XFS_BUF_GETERROR(bp) != 0) {
 			xfs_ioerror_alert("xfs_trans_read_buf", mp,
 					  bp, blkno);
 			error = XFS_BUF_GETERROR(bp);
@@ -315,7 +315,7 @@ xfs_trans_read_buf(
 			return error;
 		}
 #ifdef DEBUG
-		if (xfs_do_error && (bp != NULL)) {
+		if (xfs_do_error) {
 			if (xfs_error_target == target) {
 				if (((xfs_req_num++) % xfs_error_mod) == 0) {
 					xfs_buf_relse(bp);
