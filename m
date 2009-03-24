Return-Path: <linux-kernel-owner+w=401wt.eu-S1758755AbZCXKBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755AbZCXKBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 06:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756605AbZCXKBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 06:01:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:58625 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755912AbZCXKBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 06:01:38 -0400
Date: Tue, 24 Mar 2009 10:00:30 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, arjan@linux.intel.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       arjan@linux.intel.com, efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <18888.29986.340328.540512@cargo.ozlabs.ibm.com>
References: <18888.29986.340328.540512@cargo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter tools: remove glib dependency and fix bugs in kerneltop.c, fix poll()
Message-ID: <tip-afc2a3523fc6664f3713b594daa1857f37ad87df@git.kernel.org>
Git-Commit-ID: afc2a3523fc6664f3713b594daa1857f37ad87df
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 10:00:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  afc2a3523fc6664f3713b594daa1857f37ad87df
Gitweb:     http://git.kernel.org/tip/afc2a3523fc6664f3713b594daa1857f37ad87df
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 24 Mar 2009 10:50:24 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Mar 2009 10:56:18 +0100

perf_counter tools: remove glib dependency and fix bugs in kerneltop.c, fix poll()

Paul Mackerras wrote:

> I noticed the poll stuff is bogus - we have a 2D array of struct
> pollfds (MAX_NR_CPUS x MAX_COUNTERS), we fill in a sub-array (with the
> rest being uninitialized, since the array is on the stack) and then
> pass the first nr_cpus elements to poll.  Not what we really meant, I
> suspect. :)  Not even if we only have one counter, since it's the
> counter dimension that varies fastest.

This should fix the most obvious poll fubar.. not enough to fix the
full problem though..

Reported-by: Paul Mackerras <paulus@samba.org>
Reported-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arjan van de Ven <arjan@linux.intel.com>
LKML-Reference: <18888.29986.340328.540512@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/kerneltop.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/perf_counter/kerneltop.c b/Documentation/perf_counter/kerneltop.c
index ea13e4e..7ebde7a 100644
--- a/Documentation/perf_counter/kerneltop.c
+++ b/Documentation/perf_counter/kerneltop.c
@@ -1157,10 +1157,10 @@ static void mmap_read(struct mmap_data *md)
 
 int main(int argc, char *argv[])
 {
-	struct pollfd event_array[MAX_NR_CPUS][MAX_COUNTERS];
+	struct pollfd event_array[MAX_NR_CPUS * MAX_COUNTERS];
 	struct mmap_data mmap_array[MAX_NR_CPUS][MAX_COUNTERS];
 	struct perf_counter_hw_event hw_event;
-	int i, counter, group_fd;
+	int i, counter, group_fd, nr_poll = 0;
 	unsigned int cpu;
 	int ret;
 
@@ -1214,8 +1214,9 @@ int main(int argc, char *argv[])
 			if (group && group_fd == -1)
 				group_fd = fd[i][counter];
 
-			event_array[i][counter].fd = fd[i][counter];
-			event_array[i][counter].events = POLLIN;
+			event_array[nr_poll].fd = fd[i][counter];
+			event_array[nr_poll].events = POLLIN;
+			nr_poll++;
 
 			mmap_array[i][counter].counter = counter;
 			mmap_array[i][counter].prev = 0;
@@ -1247,7 +1248,7 @@ int main(int argc, char *argv[])
 		}
 
 		if (hits == events)
-			ret = poll(event_array[0], nr_cpus, 1000);
+			ret = poll(event_array, nr_poll, 1000);
 		hits = events;
 	}
 
