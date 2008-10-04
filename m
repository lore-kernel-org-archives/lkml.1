Return-Path: <linux-kernel-owner+w=401wt.eu-S1755077AbYJDUGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbYJDUGA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 16:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYJDUFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 16:05:51 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:58308 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556AbYJDUFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 16:05:49 -0400
Date: Sat, 4 Oct 2008 22:05:47 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, linux390@de.ibm.com,
       linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] drivers/s390/cio/chsc_sch.c: Correct use of ! and &
Message-ID: <Pine.LNX.4.64.0810042205090.19286@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In commit e6bafba5b4765a5a252f1b8d31cbf6d2459da337, a bug was fixed that
involved converting !x & y to !(x & y).  The code below shows the same
pattern, and thus should perhaps be fixed in the same way.  In particular,
the result of !scsw_stctl(&request->irb.scsw) & SCSW_STCTL_STATUS_PEND is
always just !scsw_stctl(&request->irb.scsw).

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@ expression E; constant C; @@
(
  !E & !C
|
- !E & C
+ !(E & C)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/s390/cio/chsc_sch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/s390/cio/chsc_sch.c b/drivers/s390/cio/chsc_sch.c
--- a/drivers/s390/cio/chsc_sch.c
+++ b/drivers/s390/cio/chsc_sch.c
@@ -261,7 +261,7 @@ static int chsc_examine_irb(struct chsc_
 {
 	int backed_up;
 
-	if (!scsw_stctl(&request->irb.scsw) & SCSW_STCTL_STATUS_PEND)
+	if (!(scsw_stctl(&request->irb.scsw) & SCSW_STCTL_STATUS_PEND))
 		return -EIO;
 	backed_up = scsw_cstat(&request->irb.scsw) & SCHN_STAT_CHAIN_CHECK;
 	request->irb.scsw.cmd.cstat &= ~SCHN_STAT_CHAIN_CHECK;
