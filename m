Return-Path: <linux-kernel-owner+w=401wt.eu-S1759304AbXLOLjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304AbXLOLjF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 06:39:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755416AbXLOLix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 06:38:53 -0500
Received: from smtp.nokia.com ([192.100.105.134]:26272 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306AbXLOLiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 06:38:52 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Artem Bityutskiy <dedekind@infradead.org>
Date: Sat, 15 Dec 2007 13:38:33 +0200
Message-Id: <20071215113833.14062.2460.sendpatchset@localhost.localdomain>
Subject: [PATCH] UBI: bugfix: allocate mandatory EBs first
X-OriginalArrivalTime: 15 Dec 2007 11:38:33.0752 (UTC) FILETIME=[05FC0180:01C83F0F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please, apply the below UBI bugfix. The patch is quite trivial and fixes
an unpleasant UBI bug when it cannot attach an MTD device because it
first reserves the bad block handling pool (not mandatory), and then
tries to reserve a mandatory PEB. It should be vice versa.

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH] UBI: bugfix: allocate mandatory EBs first

First allocate the necessary eraseblocks, then the optional ones.
Otherwise it allocates all PEBs for bad EB handling, and fails
on then following EBA LEB allocation.

Reported-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 drivers/mtd/ubi/eba.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index 880fa36..85f50c8 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -1168,6 +1168,15 @@ int ubi_eba_init_scan(struct ubi_device *ubi, struct ubi_scan_info *si)
 		}
 	}
 
+	if (ubi->avail_pebs < EBA_RESERVED_PEBS) {
+		ubi_err("no enough physical eraseblocks (%d, need %d)",
+			ubi->avail_pebs, EBA_RESERVED_PEBS);
+		err = -ENOSPC;
+		goto out_free;
+	}
+	ubi->avail_pebs -= EBA_RESERVED_PEBS;
+	ubi->rsvd_pebs += EBA_RESERVED_PEBS;
+
 	if (ubi->bad_allowed) {
 		ubi_calculate_reserved(ubi);
 
@@ -1184,15 +1193,6 @@ int ubi_eba_init_scan(struct ubi_device *ubi, struct ubi_scan_info *si)
 		ubi->rsvd_pebs  += ubi->beb_rsvd_pebs;
 	}
 
-	if (ubi->avail_pebs < EBA_RESERVED_PEBS) {
-		ubi_err("no enough physical eraseblocks (%d, need %d)",
-			ubi->avail_pebs, EBA_RESERVED_PEBS);
-		err = -ENOSPC;
-		goto out_free;
-	}
-	ubi->avail_pebs -= EBA_RESERVED_PEBS;
-	ubi->rsvd_pebs += EBA_RESERVED_PEBS;
-
 	dbg_eba("EBA unit is initialized");
 	return 0;
 
-- 
1.5.2.4

