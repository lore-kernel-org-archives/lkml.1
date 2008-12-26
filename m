Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbYLZH2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbYLZH2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 02:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbYLZH2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 02:28:18 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:55472 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604AbYLZH2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 02:28:14 -0500
Date: Fri, 26 Dec 2008 08:28:10 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: mike@i-Connect.Net, linux-eata@i-Connect.Net, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 4/7] drivers/scsi: Move a dereference below a NULL test
Message-ID: <Pine.LNX.4.64.0812260827490.25450@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If the NULL test is necessary, then the dereference should be moved below
the NULL test.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/).

// <smpl>
@disable is_null@
identifier f;
expression E;
identifier fld;
statement S;
@@

+ if (E == NULL) S
  f(...,E->fld,...);
- if (E == NULL) S

@@
identifier f;
expression E;
identifier fld;
statement S;
@@

+ if (!E) S
  f(...,E->fld,...);
- if (!E) S
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/eata_pio.c             |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/eata_pio.c b/drivers/scsi/eata_pio.c
index 952505c..7fec87d 100644
--- a/drivers/scsi/eata_pio.c
+++ b/drivers/scsi/eata_pio.c
@@ -500,10 +500,11 @@ static int eata_pio_host_reset(struct scsi_cmnd *cmd)
 
 		sp = HD(cmd)->ccb[x].cmd;
 		HD(cmd)->ccb[x].status = RESET;
-		printk(KERN_WARNING "eata_pio_reset: slot %d in reset, pid %ld.\n", x, sp->serial_number);
-
 		if (sp == NULL)
 			panic("eata_pio_reset: slot %d, sp==NULL.\n", x);
+		printk(KERN_WARNING
+			"eata_pio_reset: slot %d in reset, pid %ld.\n",
+			x, sp->serial_number);
 	}
 
 	/* hard reset the HBA  */
