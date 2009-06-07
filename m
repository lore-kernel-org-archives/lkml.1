Return-Path: <linux-kernel-owner+w=401wt.eu-S1755113AbZFGHht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbZFGHht (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 03:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbZFGHhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 03:37:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:52470 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082AbZFGHhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 03:37:39 -0400
Date: Sun, 7 Jun 2009 07:36:57 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbeec@gmail.com, fweisbec@gmail.com, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbeec@gmail.com, fweisbec@gmail.com, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1244322643-6447-1-git-send-email-fweisbec@gmail.com>
References: <1244322643-6447-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/core] perf top: Wait for a minimal set of events before reading first snapshot
Message-ID: <tip-2f01190aa62fe9dd0a98205927b9f09fd191c017@git.kernel.org>
Git-Commit-ID: 2f01190aa62fe9dd0a98205927b9f09fd191c017
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 07 Jun 2009 07:37:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2f01190aa62fe9dd0a98205927b9f09fd191c017
Gitweb:     http://git.kernel.org/tip/2f01190aa62fe9dd0a98205927b9f09fd191c017
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sat, 6 Jun 2009 23:10:43 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 7 Jun 2009 09:32:44 +0200

perf top: Wait for a minimal set of events before reading first snapshot

The first snapshot reading often occur before any events have
been read in the mapped perfcounter files.

Just wait until we have at least one event before starting the
snapshot, or the delay before the first set of entries to be
displayed may be long in case of low refresh rate.

Note: we could also use a semaphore to wait before
"print_entries" number of eveents is reached, but again this
value is tunable and we can't ensure we will even reach it.
Also we could base on a default mimimum set of entries for the
first refresh, say 15, but again, the minimal sample is
tunable, and we could end up displaying nothing until we have a
minimal default set of events, which can take some time in case
of high samples filters.

Hence this simple solution which partially covers the default
case.

[ Impact: fix display artifacts in perf top ]

Signed-off-by: Frederic Weisbecker <fweisbeec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1244322643-6447-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-top.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index f2e7312..fdc1d58 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -420,7 +420,7 @@ static unsigned int mmap_read_head(struct mmap_data *md)
 
 struct timeval last_read, this_read;
 
-static void mmap_read(struct mmap_data *md)
+static void mmap_read_counter(struct mmap_data *md)
 {
 	unsigned int head = mmap_read_head(md);
 	unsigned int old = md->prev;
@@ -517,6 +517,16 @@ static void mmap_read(struct mmap_data *md)
 static struct pollfd event_array[MAX_NR_CPUS * MAX_COUNTERS];
 static struct mmap_data mmap_array[MAX_NR_CPUS][MAX_COUNTERS];
 
+static void mmap_read(void)
+{
+	int i, counter;
+
+	for (i = 0; i < nr_cpus; i++) {
+		for (counter = 0; counter < nr_counters; counter++)
+			mmap_read_counter(&mmap_array[i][counter]);
+	}
+}
+
 static int __cmd_top(void)
 {
 	struct perf_counter_attr *attr;
@@ -571,6 +581,11 @@ static int __cmd_top(void)
 		}
 	}
 
+	/* Wait for a minimal set of events before starting the snapshot */
+	poll(event_array, nr_poll, 100);
+
+	mmap_read();
+
 	if (pthread_create(&thread, NULL, display_thread, NULL)) {
 		printf("Could not create display thread.\n");
 		exit(-1);
@@ -589,10 +604,7 @@ static int __cmd_top(void)
 	while (1) {
 		int hits = samples;
 
-		for (i = 0; i < nr_cpus; i++) {
-			for (counter = 0; counter < nr_counters; counter++)
-				mmap_read(&mmap_array[i][counter]);
-		}
+		mmap_read();
 
 		if (hits == samples)
 			ret = poll(event_array, nr_poll, 100);
