Return-Path: <linux-kernel-owner+w=401wt.eu-S933914AbXGKVBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933914AbXGKVBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762307AbXGKVAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 17:00:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763756AbXGKVAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 17:00:19 -0400
Date: Wed, 11 Jul 2007 21:59:35 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Milan Broz <mbroz@redhat.com>
Subject: [2.6.23 PATCH 09/18] dm snapshot: permit invalid activation
Message-ID: <20070711205935.GA24114@agk.fab.redhat.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Milan Broz <mbroz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Milan Broz <mbroz@redhat.com>

Allow invalid snapshots to be activated instead of failing.

This allows userspace to reinstate any given snapshot state - for
example after an unscheduled reboot - and clean up the invalid snapshot
at its leisure.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-exception-store.c |   11 ++++++-----
 drivers/md/dm-snap.c            |    5 ++++-
 2 files changed, 10 insertions(+), 6 deletions(-)

Index: linux/drivers/md/dm-exception-store.c
===================================================================
--- linux.orig/drivers/md/dm-exception-store.c	2007-07-11 21:37:44.000000000 +0100
+++ linux/drivers/md/dm-exception-store.c	2007-07-11 21:37:45.000000000 +0100
@@ -489,11 +489,6 @@ static int persistent_read_metadata(stru
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
@@ -501,6 +496,12 @@ static int persistent_read_metadata(stru
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
Index: linux/drivers/md/dm-snap.c
===================================================================
--- linux.orig/drivers/md/dm-snap.c	2007-07-11 21:37:38.000000000 +0100
+++ linux/drivers/md/dm-snap.c	2007-07-11 21:37:45.000000000 +0100
@@ -523,9 +523,12 @@ static int snapshot_ctr(struct dm_target
 
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
