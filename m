Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbYHBPNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbYHBPNA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 11:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756253AbYHBPMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 11:12:50 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:37777 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931AbYHBPMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 11:12:48 -0400
Date: Sat, 2 Aug 2008 17:12:46 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/10] drivers/block: Use DIV_ROUND_UP
Message-ID: <Pine.LNX.4.64.0808021712240.20095@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_UP performs the computation (((n) + (d) - 1) /
(d)) but is perhaps more readable.

An extract of the semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression n,d;
@@

(
- (n + d - 1) / d
+ DIV_ROUND_UP(n,d)
|
- (n + (d - 1)) / d
+ DIV_ROUND_UP(n,d)
)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP((n),d)
+ DIV_ROUND_UP(n,d)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP(n,(d))
+ DIV_ROUND_UP(n,d)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/block/cciss.c    |    8 ++++----
 drivers/block/cpqarray.c |    2 +-
 drivers/block/floppy.c   |    8 ++++----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff -u -p a/drivers/block/cciss.c b/drivers/block/cciss.c
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3438,8 +3438,8 @@ static int __devinit cciss_init_one(stru
 	       hba[i]->intr[SIMPLE_MODE_INT], dac ? "" : " not");
 
 	hba[i]->cmd_pool_bits =
-	    kmalloc(((hba[i]->nr_cmds + BITS_PER_LONG -
-		      1) / BITS_PER_LONG) * sizeof(unsigned long), GFP_KERNEL);
+	    kmalloc(DIV_ROUND_UP(hba[i]->nr_cmds, BITS_PER_LONG)
+			* sizeof(unsigned long), GFP_KERNEL);
 	hba[i]->cmd_pool = (CommandList_struct *)
 	    pci_alloc_consistent(hba[i]->pdev,
 		    hba[i]->nr_cmds * sizeof(CommandList_struct),
@@ -3471,8 +3471,8 @@ static int __devinit cciss_init_one(stru
 	/* command and error info recs zeroed out before
 	   they are used */
 	memset(hba[i]->cmd_pool_bits, 0,
-	       ((hba[i]->nr_cmds + BITS_PER_LONG -
-		 1) / BITS_PER_LONG) * sizeof(unsigned long));
+	       DIV_ROUND_UP(hba[i]->nr_cmds, BITS_PER_LONG)
+			* sizeof(unsigned long));
 
 #ifdef CCISS_DEBUG
 	printk(KERN_DEBUG "Scanning for drives on controller cciss%d\n", i);
diff -u -p a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -424,7 +424,7 @@ static int __init cpqarray_register_ctlr
 		hba[i]->pci_dev, NR_CMDS * sizeof(cmdlist_t),
 		&(hba[i]->cmd_pool_dhandle));
 	hba[i]->cmd_pool_bits = kcalloc(
-		(NR_CMDS+BITS_PER_LONG-1)/BITS_PER_LONG, sizeof(unsigned long),
+		DIV_ROUND_UP(NR_CMDS, BITS_PER_LONG), sizeof(unsigned long),
 		GFP_KERNEL);
 
 	if (!hba[i]->cmd_pool_bits || !hba[i]->cmd_pool)
diff -u -p a/drivers/block/floppy.c b/drivers/block/floppy.c
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -1355,20 +1355,20 @@ static void fdc_specify(void)
 	}
 
 	/* Convert step rate from microseconds to milliseconds and 4 bits */
-	srt = 16 - (DP->srt * scale_dtr / 1000 + NOMINAL_DTR - 1) / NOMINAL_DTR;
+	srt = 16 - DIV_ROUND_UP(DP->srt * scale_dtr / 1000, NOMINAL_DTR);
 	if (slow_floppy) {
 		srt = srt / 4;
 	}
 	SUPBOUND(srt, 0xf);
 	INFBOUND(srt, 0);
 
-	hlt = (DP->hlt * scale_dtr / 2 + NOMINAL_DTR - 1) / NOMINAL_DTR;
+	hlt = DIV_ROUND_UP(DP->hlt * scale_dtr / 2, NOMINAL_DTR);
 	if (hlt < 0x01)
 		hlt = 0x01;
 	else if (hlt > 0x7f)
 		hlt = hlt_max_code;
 
-	hut = (DP->hut * scale_dtr / 16 + NOMINAL_DTR - 1) / NOMINAL_DTR;
+	hut = DIV_ROUND_UP(DP->hut * scale_dtr / 16, NOMINAL_DTR);
 	if (hut < 0x1)
 		hut = 0x1;
 	else if (hut > 0xf)
@@ -2385,7 +2385,7 @@ static void rw_interrupt(void)
 
 #ifdef FLOPPY_SANITY_CHECK
 	if (nr_sectors / ssize >
-	    (in_sector_offset + current_count_sectors + ssize - 1) / ssize) {
+	    DIV_ROUND_UP(in_sector_offset + current_count_sectors, ssize)) {
 		DPRINT("long rw: %x instead of %lx\n",
 		       nr_sectors, current_count_sectors);
 		printk("rs=%d s=%d\n", R_SECTOR, SECTOR);
