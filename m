Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbYJ0W3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbYJ0W3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 18:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbYJ0W3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 18:29:13 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51192 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbYJ0W3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 18:29:12 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 27 Oct 2008 23:29:00 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 2.6.27.y 5/6] firewire: fw-sbp2: delay first login to avoid
 retries
To: stable@kernel.org
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.df6e0a4afb92ef6e@s5r6.in-berlin.de>
Message-ID: <tkrat.9bc21c3b6a97bebe@s5r6.in-berlin.de>
References: <tkrat.df6e0a4afb92ef6e@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Wed, 22 Oct 2008 00:28:36 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>

This optimizes firewire-sbp2's device probe for the case that the local
node and the SBP-2 node were discovered at the same time.  In this case,
fw-core's bus management work and fw-sbp2's login and SCSI probe work
are scheduled in parallel (in the globally shared workqueue and in
fw-sbp2's workqueue, respectively).  The bus reset from fw-core may then
disturb and extremely delay the login and SCSI probe because the latter
fails with several command timeouts and retries and has to be retried
from scratch.

We avoid this particular situation of sbp2_login() and fw_card_bm_work()
running in parallel by delaying the first sbp2_login() a little bit.

This is meant to be a short-term fix for
https://bugzilla.redhat.com/show_bug.cgi?id=466679.  In the long run,
the SCSI probe, i.e. fw-sbp2's call of __scsi_add_device(), should be
parallelized with sbp2_reconnect().

Problem reported and fix tested and confirmed by Alex Kanavin.

Same as commit 0dcfeb7e3c8695c5aa3677dda8efb9bef2e7e64d.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -1158,7 +1158,7 @@ static int sbp2_probe(struct device *dev
 
 	/* Do the login in a workqueue so we can easily reschedule retries. */
 	list_for_each_entry(lu, &tgt->lu_list, link)
-		sbp2_queue_work(lu, 0);
+		sbp2_queue_work(lu, DIV_ROUND_UP(HZ, 5));
 	return 0;
 
  fail_tgt_put:

-- 
Stefan Richter
-=====-==--- =-=- ==-==
http://arcgraph.de/sr/

