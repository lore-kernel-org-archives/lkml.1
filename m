Return-Path: <linux-kernel-owner+w=401wt.eu-S1758963AbXHVJCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963AbXHVJCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758700AbXHVIxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:53:32 -0400
Received: from 1wt.eu ([62.212.114.60]:2085 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758590AbXHVIx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:53:29 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084033.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:27 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 43/58] dm snapshot: permit invalid activation
Content-Disposition: inline; filename=0043-dm-snapshot-permit-invalid-activation.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Allow invalid snapshots to be activated instead of failing.

This allows userspace to reinstate any given snapshot state - for
example after an unscheduled reboot - and clean up the invalid snapshot
at its leisure.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/md/dm-exception-store.c |   11 ++++++-----
 drivers/md/dm-snap.c            |    5 ++++-
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-exception-store.c b/drivers/md/dm-exception-store.c
index 99cdffa..fc496fc 100644
--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -453,11 +453,6 @@ static int persistent_read_metadata(struct exception_store *store)
 		/*
 		 * Sanity checks.
 		 */
-		if (!ps->valid) {
-			DMWARN("snapshot is marked invalid");
-			return -EINVAL;
-		}
-
 		if (ps->version != SNAPSHOT_DISK_VERSION) {
 			DMWARN("unable to handle snapshot disk version %d",
 			       ps->version);
@@ -465,6 +460,12 @@ static int persistent_read_metadata(struct exception_store *store)
 		}
 
 		/*
+		 * Metadata are valid, but snapshot is invalidated
+		 */
+		if (!ps->valid)
+			return 1;
+
+		/*
 		 * Read the metadata.
 		 */
 		r = read_exceptions(ps);
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 0821a2b..9227ba4 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -522,9 +522,12 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	/* Metadata must only be loaded into one table at once */
 	r = s->store.read_metadata(&s->store);
-	if (r) {
+	if (r < 0) {
 		ti->error = "Failed to read snapshot metadata";
 		goto bad6;
+	} else if (r > 0) {
+		s->valid = 0;
+		DMWARN("Snapshot is marked invalid.");
 	}
 
 	bio_list_init(&s->queued_bios);
-- 
1.5.2.5

-- 
