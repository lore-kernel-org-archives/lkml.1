Return-Path: <linux-kernel-owner+w=401wt.eu-S1762008AbYBFVHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762008AbYBFVHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 16:07:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760697AbYBFVHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 16:07:15 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:54925 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760174AbYBFVHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 16:07:13 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 6 Feb 2008 22:07:04 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 10/9] firewire: fw-sbp2: preemptively block sdev
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
Message-ID: <tkrat.3d2f6d8bded119b6@s5r6.in-berlin.de>
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since "fw-sbp2: fix I/O errors during reconnect", a Scsi_Host will be
blocked as soon as a command failed due to bus generation change.  Now
we also block it when fw-core signalled a bus reset via sbp2_update.
This will avoid some command failures and retries (but not all because
commands are injected from tasklet context while sbp2_update runs from
workqueue thread context).

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -1135,6 +1135,7 @@ static void sbp2_update(struct fw_unit *
 	 * Iteration over tgt->lu_list is therefore safe here.
 	 */
 	list_for_each_entry(lu, &tgt->lu_list, link) {
+		sbp2_conditionally_block(lu);
 		lu->retries = 0;
 		sbp2_queue_work(lu, 0);
 	}

-- 
Stefan Richter
-=====-==--- --=- --==-
http://arcgraph.de/sr/

