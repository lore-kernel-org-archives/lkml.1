Return-Path: <linux-kernel-owner+w=401wt.eu-S937345AbXHGVZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937345AbXHGVZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761611AbXHGU4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:56:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59909 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964959AbXHGU4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:56:35 -0400
Date: Tue, 7 Aug 2007 13:49:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Milan Broz <mbroz@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.22.2 review 72/84] dm snapshot: permit invalid activation
Message-ID: <20070807204907.GV23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dm-snapshot-permit-invalid-activation.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Milan Broz <mbroz@redhat.com>

Allow invalid snapshots to be activated instead of failing.

This allows userspace to reinstate any given snapshot state - for
example after an unscheduled reboot - and clean up the invalid snapshot
at its leisure.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/md/dm-exception-store.c |   11 ++++++-----
 drivers/md/dm-snap.c            |    5 ++++-
 2 files changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -457,11 +457,6 @@ static int persistent_read_metadata(stru
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
@@ -469,6 +464,12 @@ static int persistent_read_metadata(stru
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
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -522,9 +522,12 @@ static int snapshot_ctr(struct dm_target
 
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
