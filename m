Return-Path: <linux-kernel-owner+w=401wt.eu-S1760788AbZCNAdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760788AbZCNAdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbZCNATN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:19:13 -0400
Received: from kroah.org ([198.145.64.141]:47089 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753502AbZCNATF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:19:05 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:45 2009
Message-Id: <20090314000745.758914878@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:05:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>
Subject: [patch 45/96] md: avoid races when stopping resync.
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=md-avoid-races-when-stopping-resync.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit 73d5c38a9536142e062c35997b044e89166e063b upstream.

There has been a race in raid10 and raid1 for a long time
which has only recently started showing up due to a scheduler changed.

When a sync_read request finishes, as soon as reschedule_retry
is called, another thread can mark the resync request as having
completed, so md_do_sync can finish, ->stop can be called, and
->conf can be freed.  So using conf after reschedule_retry is not
safe.

Similarly, when finishing a sync_write, calling md_done_sync must be
the last thing we do, as it allows a chain of events which will free
conf and other data structures.

The first of these requires action in raid10.c
The second requires action in raid1.c and raid10.c

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid1.c  |    3 ++-
 drivers/md/raid10.c |    7 ++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1231,6 +1231,7 @@ static void end_sync_read(struct bio *bi
 	/* for reconstruct, we always reschedule after a read.
 	 * for resync, only after all reads
 	 */
+	rdev_dec_pending(conf->mirrors[d].rdev, conf->mddev);
 	if (test_bit(R10BIO_IsRecover, &r10_bio->state) ||
 	    atomic_dec_and_test(&r10_bio->remaining)) {
 		/* we have read all the blocks,
@@ -1238,7 +1239,6 @@ static void end_sync_read(struct bio *bi
 		 */
 		reschedule_retry(r10_bio);
 	}
-	rdev_dec_pending(conf->mirrors[d].rdev, conf->mddev);
 }
 
 static void end_sync_write(struct bio *bio, int error)
@@ -1259,11 +1259,13 @@ static void end_sync_write(struct bio *b
 
 	update_head_pos(i, r10_bio);
 
+	rdev_dec_pending(conf->mirrors[d].rdev, mddev);
 	while (atomic_dec_and_test(&r10_bio->remaining)) {
 		if (r10_bio->master_bio == NULL) {
 			/* the primary of several recovery bios */
-			md_done_sync(mddev, r10_bio->sectors, 1);
+			sector_t s = r10_bio->sectors;
 			put_buf(r10_bio);
+			md_done_sync(mddev, s, 1);
 			break;
 		} else {
 			r10bio_t *r10_bio2 = (r10bio_t *)r10_bio->master_bio;
@@ -1271,7 +1273,6 @@ static void end_sync_write(struct bio *b
 			r10_bio = r10_bio2;
 		}
 	}
-	rdev_dec_pending(conf->mirrors[d].rdev, mddev);
 }
 
 /*
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1229,8 +1229,9 @@ static void end_sync_write(struct bio *b
 	update_head_pos(mirror, r1_bio);
 
 	if (atomic_dec_and_test(&r1_bio->remaining)) {
-		md_done_sync(mddev, r1_bio->sectors, uptodate);
+		sector_t s = r1_bio->sectors;
 		put_buf(r1_bio);
+		md_done_sync(mddev, s, uptodate);
 	}
 }
 


