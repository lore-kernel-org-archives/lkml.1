Return-Path: <linux-kernel-owner+w=401wt.eu-S1754787AbZGSP1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbZGSP1a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 11:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbZGSP10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 11:27:26 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:47159 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596AbZGSP1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 11:27:23 -0400
Date: Sun, 19 Jul 2009 17:27:20 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 6/10] drivers/scsi: Move a dereference below a NULL test
Message-ID: <Pine.LNX.4.64.0907191726590.16542@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If the NULL test is necessary, then the dereference should be moved below
the NULL test.  I have additionally added a return if the NULL tests
succeeds, because it is not clear that the rest of the function, which is
for debugging only, makes sense in this case.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
expression E,E1;
identifier i,fld;
statement S;
@@

- T i = E->fld;
+ T i;
  ... when != E=E1
      when != i
  if (E == NULL||...) S
+ i = E->fld;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/fd_mcs.c               |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fd_mcs.c b/drivers/scsi/fd_mcs.c
index 85bd54c..eff35cf 100644
--- a/drivers/scsi/fd_mcs.c
+++ b/drivers/scsi/fd_mcs.c
@@ -1127,11 +1127,13 @@ static void fd_mcs_print_info(Scsi_Cmnd * SCpnt)
 	unsigned int imr;
 	unsigned int irr;
 	unsigned int isr;
-	struct Scsi_Host *shpnt = SCpnt->host;
+	struct Scsi_Host *shpnt;
 
 	if (!SCpnt || !SCpnt->host) {
 		printk("fd_mcs: cannot provide detailed information\n");
+		return;
 	}
+	shpnt = SCpnt->host;
 
 	printk("%s\n", fd_mcs_info(SCpnt->host));
 	print_banner(SCpnt->host);
