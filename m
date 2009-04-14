Return-Path: <linux-kernel-owner+w=401wt.eu-S1755690AbZDNN5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbZDNN5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 09:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756310AbZDNNyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 09:54:03 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:51909 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756234AbZDNNxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 09:53:51 -0400
Message-Id: <20090414135348.606209328@de.ibm.com>
References: <20090414135327.576111185@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 14 Apr 2009 15:53:36 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Stefan Weinhuber <wein@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 09/14] dasd: fix idaw boundary checking for track based ccw
Content-Disposition: inline; filename=009-dasd-idaw-checking.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Weinhuber <wein@de.ibm.com>

A ccw command that reads or writes several records at once will
usually transfer more data then fits into one page and needs to
address memory areas using a list of indirect data address words
(idaw). All but the first of these areas must start on a 4KB or 2KB
block boundary (depending on the idaw format).
A check for this restriction was missing and has been added with
this patch.

Signed-off-by: Stefan Weinhuber <wein@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/block/dasd_eckd.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

Index: quilt-2.6/drivers/s390/block/dasd_eckd.c
===================================================================
--- quilt-2.6.orig/drivers/s390/block/dasd_eckd.c
+++ quilt-2.6/drivers/s390/block/dasd_eckd.c
@@ -2019,15 +2019,23 @@ static struct dasd_ccw_req *dasd_eckd_bu
 				ccw++;
 				recid += count;
 				new_track = 0;
+				/* first idaw for a ccw may start anywhere */
+				if (!idaw_dst)
+					idaw_dst = dst;
 			}
-			/* If we start a new idaw, everything is fine and the
-			 * start of the new idaw is the start of this segment.
+			/* If we start a new idaw, we must make sure that it
+			 * starts on an IDA_BLOCK_SIZE boundary.
 			 * If we continue an idaw, we must make sure that the
 			 * current segment begins where the so far accumulated
 			 * idaw ends
 			 */
-			if (!idaw_dst)
-				idaw_dst = dst;
+			if (!idaw_dst) {
+				if (__pa(dst) & (IDA_BLOCK_SIZE-1)) {
+					dasd_sfree_request(cqr, startdev);
+					return ERR_PTR(-ERANGE);
+				} else
+					idaw_dst = dst;
+			}
 			if ((idaw_dst + idaw_len) != dst) {
 				dasd_sfree_request(cqr, startdev);
 				return ERR_PTR(-ERANGE);

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

