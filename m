Return-Path: <linux-kernel-owner+w=401wt.eu-S1757806AbYBSOcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806AbYBSOcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 09:32:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbYBSOcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 09:32:36 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:7389 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbYBSOcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 09:32:35 -0500
Date: Tue, 19 Feb 2008 15:32:32 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jonathan Brassow <jbrassow@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: [PATCH] dm raid1: bitops bug.
Message-ID: <20080219143232.GA10994@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Commit 8f0205b798f926e2745de5fdebf0a8605c621de6
"dm raid1: handle recovery failures" introduces a test_bit on an
integer. test_bit is only defined to do something useful on arrays
of long. Remove the test_bit code and use hand coded test bit
instead.

Cc: Jonathan Brassow <jbrassow@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

Completely untested, but should hopefully do what was intended.

 drivers/md/dm-raid1.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid1.c
+++ linux-2.6/drivers/md/dm-raid1.c
@@ -758,7 +758,8 @@ static void recovery_complete(int read_e
 {
 	struct region *reg = (struct region *)context;
 	struct mirror_set *ms = reg->rh->ms;
-	int m, bit = 0;
+	unsigned int mask = 1;
+	int m;
 
 	if (read_err) {
 		/* Read error means the failure of default mirror. */
@@ -776,10 +777,10 @@ static void recovery_complete(int read_e
 		for (m = 0; m < ms->nr_mirrors; m++) {
 			if (&ms->mirror[m] == get_default_mirror(ms))
 				continue;
-			if (test_bit(bit, &write_err))
+			if (write_err & mask)
 				fail_mirror(ms->mirror + m,
 					    DM_RAID1_SYNC_ERROR);
-			bit++;
+			mask <<= 1;
 		}
 	}
 
