Return-Path: <linux-kernel-owner+w=401wt.eu-S1751854AbYJXEnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbYJXEnE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbYJXEjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:39:17 -0400
Received: from kroah.org ([198.145.64.141]:51726 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752182AbYJXEjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:39:13 -0400
Date: Thu, 23 Oct 2008 21:34:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Mikulas Patocka <mpatocka@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [patch 10/27] dm snapshot: fix primary_pe race
Message-ID: <20081024043413.GK30828@kroah.com>
References: <20081024042023.054190751@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dm-snapshot-fix-primary_pe-race.patch"
In-Reply-To: <20081024043303.GA30828@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Mikulas Patocka <mpatocka@redhat.com>

commit 7c5f78b9d7f21937e46c26db82976df4b459c95c upstream

Fix a race condition with primary_pe ref_count handling.

put_pending_exception runs under dm_snapshot->lock, it does atomic_dec_and_test
on primary_pe->ref_count, and later does atomic_read primary_pe->ref_count.

__origin_write does atomic_dec_and_test on primary_pe->ref_count without holding
dm_snapshot->lock.

This opens the following race condition:
Assume two CPUs, CPU1 is executing put_pending_exception (and holding
dm_snapshot->lock). CPU2 is executing __origin_write in parallel.
primary_pe->ref_count == 2.

CPU1:
if (primary_pe && atomic_dec_and_test(&primary_pe->ref_count))
	origin_bios = bio_list_get(&primary_pe->origin_bios);
.. decrements primary_pe->ref_count to 1. Doesn't load origin_bios

CPU2:
if (first && atomic_dec_and_test(&primary_pe->ref_count)) {
	flush_bios(bio_list_get(&primary_pe->origin_bios));
	free_pending_exception(primary_pe);
	/* If we got here, pe_queue is necessarily empty. */
	return r;
}
.. decrements primary_pe->ref_count to 0, submits pending bios, frees
primary_pe.

CPU1:
if (!primary_pe || primary_pe != pe)
	free_pending_exception(pe);
.. this has no effect.
if (primary_pe && !atomic_read(&primary_pe->ref_count))
	free_pending_exception(primary_pe);
.. sees ref_count == 0 (written by CPU 2), does double free !!

This bug can happen only if someone is simultaneously writing to both the
origin and the snapshot.

If someone is writing only to the origin, __origin_write will submit kcopyd
request after it decrements primary_pe->ref_count (so it can't happen that the
finished copy races with primary_pe->ref_count decrementation).

If someone is writing only to the snapshot, __origin_write isn't invoked at all
and the race can't happen.

The race happens when someone writes to the snapshot --- this creates
pending_exception with primary_pe == NULL and starts copying. Then, someone
writes to the same chunk in the snapshot, and __origin_write races with
termination of already submitted request in pending_complete (that calls
put_pending_exception).

This race may be reason for bugs:
  http://bugzilla.kernel.org/show_bug.cgi?id=11636
  https://bugzilla.redhat.com/show_bug.cgi?id=465825

The patch fixes the code to make sure that:
1. If atomic_dec_and_test(&primary_pe->ref_count) returns false, the process
must no longer dereference primary_pe (because someone else may free it under
us).
2. If atomic_dec_and_test(&primary_pe->ref_count) returns true, the process
is responsible for freeing primary_pe.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-snap.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -824,8 +824,10 @@ static struct bio *put_pending_exception
 	 * the bios for the original write to the origin.
 	 */
 	if (primary_pe &&
-	    atomic_dec_and_test(&primary_pe->ref_count))
+	    atomic_dec_and_test(&primary_pe->ref_count)) {
 		origin_bios = bio_list_get(&primary_pe->origin_bios);
+		free_pending_exception(primary_pe);
+	}
 
 	/*
 	 * Free the pe if it's not linked to an origin write or if
@@ -834,12 +836,6 @@ static struct bio *put_pending_exception
 	if (!primary_pe || primary_pe != pe)
 		free_pending_exception(pe);
 
-	/*
-	 * Free the primary pe if nothing references it.
-	 */
-	if (primary_pe && !atomic_read(&primary_pe->ref_count))
-		free_pending_exception(primary_pe);
-
 	return origin_bios;
 }
 

-- 
