Return-Path: <linux-kernel-owner+w=401wt.eu-S939772AbXFHH4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939772AbXFHH4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938418AbXFHHZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:25:26 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55363 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938393AbXFHHZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:25:21 -0400
Message-Id: <20070608072211.586067000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:21:54 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bjorn Steinbrink <B.Steinbrink@gmx.de>, Ian Kumlien <pomac@vapor.com>,
       Ingo Molnar <mingo@elte.hu>, Eric Dumazet <dada1@cosmosbay.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 27/54] timer statistics: fix race
Content-Disposition: inline; filename=timer-statistics-fix-race.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Bjorn Steinbrink <B.Steinbrink@gmx.de>

Fix two races in the timer stats lookup code.  One by ensuring that the
initialization of a new entry is finished upon insertion of that entry.
The other by cleaning up the hash table when the entries array is cleared,
so that we don't have any "pre-inserted" entries.

Thanks to Eric Dumazet for reminding me of the memory barriers.

Signed-off-by: Bjorn Steinbrink <B.Steinbrink@gmx.de>
Signed-off-by: Ian Kumlien <pomac@vapor.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/time/timer_stats.c |   37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

--- linux-2.6.21.4.orig/kernel/time/timer_stats.c
+++ linux-2.6.21.4/kernel/time/timer_stats.c
@@ -117,21 +117,6 @@ static struct entry entries[MAX_ENTRIES]
 
 static atomic_t overflow_count;
 
-static void reset_entries(void)
-{
-	nr_entries = 0;
-	memset(entries, 0, sizeof(entries));
-	atomic_set(&overflow_count, 0);
-}
-
-static struct entry *alloc_entry(void)
-{
-	if (nr_entries >= MAX_ENTRIES)
-		return NULL;
-
-	return entries + nr_entries++;
-}
-
 /*
  * The entries are in a hash-table, for fast lookup:
  */
@@ -149,6 +134,22 @@ static struct entry *alloc_entry(void)
 
 static struct entry *tstat_hash_table[TSTAT_HASH_SIZE] __read_mostly;
 
+static void reset_entries(void)
+{
+	nr_entries = 0;
+	memset(entries, 0, sizeof(entries));
+	memset(tstat_hash_table, 0, sizeof(tstat_hash_table));
+	atomic_set(&overflow_count, 0);
+}
+
+static struct entry *alloc_entry(void)
+{
+	if (nr_entries >= MAX_ENTRIES)
+		return NULL;
+
+	return entries + nr_entries++;
+}
+
 static int match_entries(struct entry *entry1, struct entry *entry2)
 {
 	return entry1->timer       == entry2->timer	  &&
@@ -202,12 +203,15 @@ static struct entry *tstat_lookup(struct
 	if (curr) {
 		*curr = *entry;
 		curr->count = 0;
+		curr->next = NULL;
 		memcpy(curr->comm, comm, TASK_COMM_LEN);
+
+		smp_mb(); /* Ensure that curr is initialized before insert */
+
 		if (prev)
 			prev->next = curr;
 		else
 			*head = curr;
-		curr->next = NULL;
 	}
  out_unlock:
 	spin_unlock(&table_lock);
@@ -364,6 +368,7 @@ static ssize_t tstats_write(struct file 
 		if (!active) {
 			reset_entries();
 			time_start = ktime_get();
+			smp_mb();
 			active = 1;
 		}
 		break;

-- 
