Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbYK2N4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbYK2N4V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 08:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbYK2N4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 08:56:07 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:51279 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbYK2N4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 08:56:06 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 29 Nov 2008 14:55:47 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: sbp2: fix race condition in state change
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.b365b7fbc771f9d0@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An intermediate transition from _RUNNING to _IN_SHUTDOWN could have been
missed by the former code.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c
+++ linux/drivers/ieee1394/sbp2.c
@@ -895,12 +895,13 @@ static void sbp2_host_reset(struct hpsb_
 		return;
 
 	read_lock_irqsave(&sbp2_hi_logical_units_lock, flags);
+
 	list_for_each_entry(lu, &hi->logical_units, lu_list)
-		if (likely(atomic_read(&lu->state) !=
-			   SBP2LU_STATE_IN_SHUTDOWN)) {
-			atomic_set(&lu->state, SBP2LU_STATE_IN_RESET);
+		if (atomic_cmpxchg(&lu->state,
+				   SBP2LU_STATE_RUNNING, SBP2LU_STATE_IN_RESET)
+		    == SBP2LU_STATE_RUNNING)
 			scsi_block_requests(lu->shost);
-		}
+
 	read_unlock_irqrestore(&sbp2_hi_logical_units_lock, flags);
 }
 

-- 
Stefan Richter
-=====-==--- =-== ===-=
http://arcgraph.de/sr/

