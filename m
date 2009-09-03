Return-Path: <linux-kernel-owner+w=401wt.eu-S932311AbZICVHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311AbZICVHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 17:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932290AbZICVHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 17:07:51 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59188 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932258AbZICVHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 17:07:51 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 3 Sep 2009 23:07:35 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: sbp2: fix freeing of unallocated memory
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.9397e8b23fce40ec@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a target writes invalid status (typically status of a command that
already timed out, firewire-sbp2 attempts to put away an ORB that
doesn't exist.  https://bugzilla.redhat.com/show_bug.cgi?id=519772

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/sbp2.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux/drivers/firewire/sbp2.c
===================================================================
--- linux.orig/drivers/firewire/sbp2.c
+++ linux/drivers/firewire/sbp2.c
@@ -456,12 +456,12 @@ static void sbp2_status_write(struct fw_
 	}
 	spin_unlock_irqrestore(&card->lock, flags);
 
-	if (&orb->link != &lu->orb_list)
+	if (&orb->link != &lu->orb_list) {
 		orb->callback(orb, &status);
-	else
+		kref_put(&orb->kref, free_orb);
+	} else {
 		fw_error("status write for unknown orb\n");
-
-	kref_put(&orb->kref, free_orb);
+	}
 
 	fw_send_response(card, request, RCODE_COMPLETE);
 }

-- 
Stefan Richter
-=====-==--= =--= ---==
http://arcgraph.de/sr/

