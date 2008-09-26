Return-Path: <linux-kernel-owner+w=401wt.eu-S1753192AbYIZN1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbYIZN1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 09:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbYIZN1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 09:27:33 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:57568 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbYIZN1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 09:27:32 -0400
From: Julien Brunel <brunel@diku.dk>
To: haver@vnet.ibm.com, dedekind@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/mtd/ubi: Bad IS_ERR test
Date: Fri, 26 Sep 2008 15:27:25 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809261527.26007.brunel@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of error, the function add_volume returns an ERR pointer. The
result of IS_ERR, which is supposed to be used in a test as it is, is
here checked to be less than zero, which seems odd. We suggest to
replace this test by a simple IS_ERR test.

A simplified version of the semantic match that finds this problem is
as follows: 
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@def0@
expression x;
position p0;
@@
x@p0 = add_volume(...)

@protected@
expression def0.x,E;
position def0.p0;
position p;
statement S;
@@
x@p0
... when != x = E
if (!IS_ERR(x) && ...) {<... x@p ...>} else S

@unprotected@
expression def0.x,E;
identifier fld;
position def0.p0;
position p != protected.p;
@@
x@p0
... when != x = E
* x@p->fld
// </smpl>

Signed-off-by:  Julien Brunel <brunel@diku.dk>
Signed-off-by:  Julia Lawall <julia@diku.dk>

---
 drivers/mtd/ubi/scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -p -u a/drivers/mtd/ubi/scan.c b/drivers/mtd/ubi/scan.c
--- a/drivers/mtd/ubi/scan.c
+++ b/drivers/mtd/ubi/scan.c
@@ -387,7 +387,7 @@ int ubi_scan_add_used(struct ubi_device 
 		pnum, vol_id, lnum, ec, sqnum, bitflips);
 
 	sv = add_volume(si, vol_id, pnum, vid_hdr);
-	if (IS_ERR(sv) < 0)
+	if (IS_ERR(sv))
 		return PTR_ERR(sv);
 
 	if (si->max_sqnum < sqnum)
