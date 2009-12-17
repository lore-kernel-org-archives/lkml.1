Return-Path: <linux-kernel-owner+w=401wt.eu-S935697AbZLQEEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935697AbZLQEEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763978AbZLQEER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:04:17 -0500
Received: from kroah.org ([198.145.64.141]:55472 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761937AbZLQEEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:10 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:49 2009
Message-Id: <20091217035648.891078920@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [046/151] UBI: flush wl before clearing update marker
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

commit 6afaf8a484cbbfd2ccf58a4e5396d1f280469789 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/ubi/upd.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/drivers/mtd/ubi/upd.c
+++ b/drivers/mtd/ubi/upd.c
@@ -147,12 +147,14 @@ int ubi_start_update(struct ubi_device *
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
@@ -362,16 +364,16 @@ int ubi_more_update_data(struct ubi_devi
 
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


