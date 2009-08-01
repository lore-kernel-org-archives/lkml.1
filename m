Return-Path: <linux-kernel-owner+w=401wt.eu-S1752204AbZHATuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbZHATuA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 15:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbZHATuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 15:50:00 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:52947 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093AbZHATt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 15:49:59 -0400
Date: Sat, 1 Aug 2009 21:49:55 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: garloff@suse.de, g.liakhovetski@gmx.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 3/5] drivers/scsi: Use DIV_ROUND_CLOSEST
Message-ID: <Pine.LNX.4.64.0908012149050.25693@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_CLOSEST performs the computation (x + d/2)/d
but is perhaps more readable.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression x,__divisor;
@@

- (((x) + ((__divisor) / 2)) / (__divisor))
+ DIV_ROUND_CLOSEST(x,__divisor)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/tmscsim.c              |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

Diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 9a42734..7322f30 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -1125,7 +1125,8 @@ dc390_MsgIn_set_sync (struct dc390_acb* pACB, struct dc390_srb* pSRB)
     {
       if (! (bval & FAST_SCSI)) wval1++;
       printk (KERN_INFO "DC390: Target %i: Sync transfer %i.%1i MHz, Offset %i\n", pDCB->TargetID, 
-	      40/wval1, ((40%wval1)*10+wval1/2)/wval1, pDCB->SyncOffset & 0x0f);
+		40/wval1, DIV_ROUND_CLOSEST((40 % wval1) * 10, wval1),
+		pDCB->SyncOffset & 0x0f);
     }
   
   dc390_reprog (pACB, pDCB);
