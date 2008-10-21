Return-Path: <linux-kernel-owner+w=401wt.eu-S1756331AbYJUW3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331AbYJUW3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 18:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbYJUW2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 18:28:55 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57879 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbYJUW2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 18:28:54 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 22 Oct 2008 00:28:36 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-sbp2: delay first login to avoid retries
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.f0278c2bdf9e5589@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -1147,7 +1147,7 @@ static int sbp2_probe(struct device *dev
 
 	/* Do the login in a workqueue so we can easily reschedule retries. */
 	list_for_each_entry(lu, &tgt->lu_list, link)
-		sbp2_queue_work(lu, 0);
+		sbp2_queue_work(lu, DIV_ROUND_UP(HZ, 5));
 	return 0;
 
  fail_tgt_put:

-- 
Stefan Richter
-=====-==--- =-=- =-==-
http://arcgraph.de/sr/

