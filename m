Return-Path: <linux-kernel-owner+w=401wt.eu-S1755694AbYLUPmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694AbYLUPmV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 10:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbYLUPmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 10:42:01 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:51660 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755936AbYLUPmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 10:42:00 -0500
Date: Sun, 21 Dec 2008 16:41:57 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: sfrench@samba.org, linux-cifs-client@lists.samba.org,
       samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 12/13] fs/cifs: Remove redundant test
Message-ID: <Pine.LNX.4.64.0812211641370.9555@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In fs/cifs/cifssmb.c, pLockData is tested for being NULL at the beginning
of the function, and not reassigned subsequently.

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
 fs/cifs/cifssmb.c                   |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 824df14..552642a 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1871,10 +1871,6 @@ CIFSSMBPosixLock(const int xid, struct cifsTconInfo *tcon,
 			rc = -EIO;      /* bad smb */
 			goto plk_err_exit;
 		}
-		if (pLockData == NULL) {
-			rc = -EINVAL;
-			goto plk_err_exit;
-		}
 		data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
 		data_count  = le16_to_cpu(pSMBr->t2.DataCount);
 		if (data_count < sizeof(struct cifs_posix_lock)) {
