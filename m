Return-Path: <linux-kernel-owner+w=401wt.eu-S1760706AbYC0S6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760706AbYC0S6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 14:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755308AbYC0S6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 14:58:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755440AbYC0S6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 14:58:09 -0400
Date: Thu, 27 Mar 2008 18:57:55 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com
Subject: [2.6.25-rc8] dm io: write error bits form long not int
Message-ID: <20080327185755.GL24157@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	linux-kernel@vger.kernel.org, dm-devel@redhat.com
References: <20080327185315.GA26288@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327185315.GA26288@agk.fab.redhat.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alasdair G Kergon <agk@redhat.com>

write_err is an unsigned long used with set_bit() so should not
be passed around as unsigned int.

http://bugzilla.kernel.org/show_bug.cgi?id=10271

Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-io.c    |    2 +-
 drivers/md/dm-raid1.c |    4 ++--
 drivers/md/dm-snap.c  |    2 +-
 drivers/md/kcopyd.c   |   10 +++++-----
 drivers/md/kcopyd.h   |    4 ++--
 5 files changed, 11 insertions(+), 11 deletions(-)

Index: linux-2.6.25-rc7/drivers/md/dm-io.c
===================================================================
--- linux-2.6.25-rc7.orig/drivers/md/dm-io.c	2008-03-27 17:51:22.000000000 +0000
+++ linux-2.6.25-rc7/drivers/md/dm-io.c	2008-03-27 17:51:30.000000000 +0000
@@ -114,7 +114,7 @@ static void dec_count(struct io *io, uns
 			wake_up_process(io->sleeper);
 
 		else {
-			int r = io->error;
+			unsigned long r = io->error;
 			io_notify_fn fn = io->callback;
 			void *context = io->context;
 
Index: linux-2.6.25-rc7/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.25-rc7.orig/drivers/md/dm-raid1.c	2008-03-27 17:51:22.000000000 +0000
+++ linux-2.6.25-rc7/drivers/md/dm-raid1.c	2008-03-27 17:51:30.000000000 +0000
@@ -753,7 +753,7 @@ out:
  * are in the no-sync state.  We have to recover these by
  * recopying from the default mirror to all the others.
  *---------------------------------------------------------------*/
-static void recovery_complete(int read_err, unsigned int write_err,
+static void recovery_complete(int read_err, unsigned long write_err,
 			      void *context)
 {
 	struct region *reg = (struct region *)context;
@@ -767,7 +767,7 @@ static void recovery_complete(int read_e
 	}
 
 	if (write_err) {
-		DMERR_LIMIT("Write error during recovery (error = 0x%x)",
+		DMERR_LIMIT("Write error during recovery (error = 0x%lx)",
 			    write_err);
 		/*
 		 * Bits correspond to devices (excluding default mirror).
Index: linux-2.6.25-rc7/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.25-rc7.orig/drivers/md/dm-snap.c	2008-03-27 17:51:22.000000000 +0000
+++ linux-2.6.25-rc7/drivers/md/dm-snap.c	2008-03-27 17:51:30.000000000 +0000
@@ -804,7 +804,7 @@ static void commit_callback(void *contex
  * Called when the copy I/O has finished.  kcopyd actually runs
  * this code so don't block.
  */
-static void copy_callback(int read_err, unsigned int write_err, void *context)
+static void copy_callback(int read_err, unsigned long write_err, void *context)
 {
 	struct dm_snap_pending_exception *pe = context;
 	struct dm_snapshot *s = pe->snap;
Index: linux-2.6.25-rc7/drivers/md/kcopyd.c
===================================================================
--- linux-2.6.25-rc7.orig/drivers/md/kcopyd.c	2008-03-27 17:51:22.000000000 +0000
+++ linux-2.6.25-rc7/drivers/md/kcopyd.c	2008-03-27 17:51:30.000000000 +0000
@@ -169,7 +169,7 @@ struct kcopyd_job {
 	 * Error state of the job.
 	 */
 	int read_err;
-	unsigned int write_err;
+	unsigned long write_err;
 
 	/*
 	 * Either READ or WRITE
@@ -293,7 +293,7 @@ static int run_complete_job(struct kcopy
 {
 	void *context = job->context;
 	int read_err = job->read_err;
-	unsigned int write_err = job->write_err;
+	unsigned long write_err = job->write_err;
 	kcopyd_notify_fn fn = job->fn;
 	struct kcopyd_client *kc = job->kc;
 
@@ -396,7 +396,7 @@ static int process_jobs(struct list_head
 		if (r < 0) {
 			/* error this rogue job */
 			if (job->rw == WRITE)
-				job->write_err = (unsigned int) -1;
+				job->write_err = (unsigned long) -1L;
 			else
 				job->read_err = 1;
 			push(&_complete_jobs, job);
@@ -448,8 +448,8 @@ static void dispatch_job(struct kcopyd_j
 }
 
 #define SUB_JOB_SIZE 128
-static void segment_complete(int read_err,
-			     unsigned int write_err, void *context)
+static void segment_complete(int read_err, unsigned long write_err,
+			     void *context)
 {
 	/* FIXME: tidy this function */
 	sector_t progress = 0;
Index: linux-2.6.25-rc7/drivers/md/kcopyd.h
===================================================================
--- linux-2.6.25-rc7.orig/drivers/md/kcopyd.h	2008-03-27 17:51:22.000000000 +0000
+++ linux-2.6.25-rc7/drivers/md/kcopyd.h	2008-03-27 17:51:30.000000000 +0000
@@ -32,8 +32,8 @@ void kcopyd_client_destroy(struct kcopyd
  * read_err is a boolean,
  * write_err is a bitset, with 1 bit for each destination region
  */
-typedef void (*kcopyd_notify_fn)(int read_err,
-				 unsigned int write_err, void *context);
+typedef void (*kcopyd_notify_fn)(int read_err, unsigned long write_err,
+				 void *context);
 
 int kcopyd_copy(struct kcopyd_client *kc, struct io_region *from,
 		unsigned int num_dests, struct io_region *dests,
