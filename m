Return-Path: <linux-kernel-owner+w=401wt.eu-S1756971AbYLPURS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971AbYLPURS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbYLPURG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:17:06 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:2755 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbYLPURF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:17:05 -0500
Date: Tue, 16 Dec 2008 14:17:03 -0600
From: scameron@beardog.cca.cpqcorp.net
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, akpm@linux-foundation.org,
       mikem@roadking.cca.cpqcorp.net
Subject: [patch] cciss: Fix problem that deleting multiple logical drives could cause a panic
Message-ID: <20081216201703.GL1126@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix problem that deleting multiple logical drives could cause a panic.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>
---

 drivers/block/cciss.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/block/cciss.c~fix_rebuild_lun_table_bug drivers/block/cciss.c
--- linux-2.6.28-rc8/drivers/block/cciss.c~fix_rebuild_lun_table_bug	2008-12-16 14:00:52.000000000 -0600
+++ linux-2.6.28-rc8-root/drivers/block/cciss.c	2008-12-16 14:00:52.000000000 -0600
@@ -1693,6 +1693,11 @@ static int rebuild_lun_table(ctlr_info_t
 	for (i = 0; i <= h->highest_lun; i++) {
 		int j;
 		drv_found = 0;
+
+		/* skip holes in the array from already deleted drives */
+		if (h->drv[i].raid_level == -1)
+			continue;
+
 		for (j = 0; j < num_luns; j++) {
 			memcpy(&lunid, &ld_buff->LUN[j][0], 4);
 			lunid = le32_to_cpu(lunid);
_
