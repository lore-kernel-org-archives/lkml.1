Return-Path: <linux-kernel-owner+w=401wt.eu-S1752640AbZLBGt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbZLBGt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 01:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbZLBGt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 01:49:57 -0500
Received: from smtp.nokia.com ([192.100.105.134]:21926 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbZLBGt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 01:49:56 -0500
From: Artem Bityutskiy <Artem.Bityutskiy@Nokia.com>
To: Greg KH <gregkh@suse.de>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] UBI: flush wl before clearing update marker
Date: Wed,  2 Dec 2009 08:48:43 +0200
Message-Id: <1259736523-13091-1-git-send-email-Artem.Bityutskiy@nokia.com>
X-Mailer: git-send-email 1.6.2.5
X-OriginalArrivalTime: 02 Dec 2009 06:48:50.0368 (UTC) FILETIME=[81469C00:01CA731B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

ubiupdatevol -t does the following:
- ubi_start_update()
  - set_update_marker()
  - for all LEBs ubi_eba_unmap_leb()
  - clear_update_marker()
  - ubi_wl_flush()

ubi_wl_flush() physically erases all PEB, once it returns all PEBs are
empty. clear_update_marker() has the update marker written after return.
If there is a power cut between the last two functions then the UBI
volume has no longer the "update" marker set and may have some valid
LEBs while some of them may be gone.
If that volume in question happens to be a UBIFS volume, then mount
will fail with

|UBIFS error (pid 1361): ubifs_read_node: bad node type (255 but expected 6)
|UBIFS error (pid 1361): ubifs_read_node: bad node at LEB 0:0
|Not a node, first 24 bytes:
|00000000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff

if there is at least one valid LEB and the wear-leveling worker managed
to clear LEB 0.

The patch waits for the wl worker to finish prior clearing the "update"
marker on flash. The two new LEB which are scheduled for erasing after
clear_update_marker() should not matter because they are only visible to
UBI.

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: stable@kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/mtd/ubi/upd.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/ubi/upd.c b/drivers/mtd/ubi/upd.c
index 74fdc40..c1d7b88 100644
--- a/drivers/mtd/ubi/upd.c
+++ b/drivers/mtd/ubi/upd.c
@@ -147,12 +147,14 @@ int ubi_start_update(struct ubi_device *ubi, struct ubi_volume *vol,
 	}
 
 	if (bytes == 0) {
+		err = ubi_wl_flush(ubi);
+		if (err)
+			return err;
+
 		err = clear_update_marker(ubi, vol, 0);
 		if (err)
 			return err;
-		err = ubi_wl_flush(ubi);
-		if (!err)
-			vol->updating = 0;
+		vol->updating = 0;
 	}
 
 	vol->upd_buf = vmalloc(ubi->leb_size);
@@ -362,16 +364,16 @@ int ubi_more_update_data(struct ubi_device *ubi, struct ubi_volume *vol,
 
 	ubi_assert(vol->upd_received <= vol->upd_bytes);
 	if (vol->upd_received == vol->upd_bytes) {
+		err = ubi_wl_flush(ubi);
+		if (err)
+			return err;
 		/* The update is finished, clear the update marker */
 		err = clear_update_marker(ubi, vol, vol->upd_bytes);
 		if (err)
 			return err;
-		err = ubi_wl_flush(ubi);
-		if (err == 0) {
-			vol->updating = 0;
-			err = to_write;
-			vfree(vol->upd_buf);
-		}
+		vol->updating = 0;
+		err = to_write;
+		vfree(vol->upd_buf);
 	}
 
 	return err;
-- 
1.6.2.5

