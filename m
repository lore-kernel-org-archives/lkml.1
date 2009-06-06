Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbZFFVKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbZFFVKy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 17:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbZFFVKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 17:10:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:5106 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbZFFVKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 17:10:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=lZbxGkLLBy47Rvu/auJOc8gZhn7CvCZKNOYXQjI0JccN0s0AaFsGwtinaWNehGULgo
         PxzGq7qolgmdfmzafeogGnt2oDPFZCiFLHeYaBovBNPLALkJCeq43VXZzJunhJCyW3op
         pqtEW1r3Ieihm+oUTSrZeSGbe4OZmxDsHin10=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Frederic Weisbecker <fweisbeec@gmail.com>
Subject: [PATCH] perf-top: Wait for a minimal set of events before reading first snapshot
Date: Sat,  6 Jun 2009 23:10:43 +0200
Message-Id: <1244322643-6447-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first snapshot reading often occur before any events have been
read in the mapped perfcounter files.

Just wait until we have at least one event before starting the
snapshot, or the delay before the first set of entries to be
displayed may be long in case of low refresh rate.

Note: we could also use a semaphore to wait before "print_entries"
number of eveents is reached, but again this value is tunable
and we can't ensure we will even reach it. Also we could base
on a default mimimum set of entries for the first refresh, say 15,
but again, the minimal sample is tunable, and we could end up
displaying nothing until we have a minimal default set of events,
which can take some time in case of high samples filters.

Hence this simple solution which partially covers the default case.

[ Impact: display first events once they are available on perf top ]

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbeec@gmail.com>
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
-- 
1.6.2.3

