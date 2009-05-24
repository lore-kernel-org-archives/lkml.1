Return-Path: <linux-kernel-owner+w=401wt.eu-S1757603AbZEXHDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603AbZEXHDy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 03:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754792AbZEXHDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 03:03:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:35752 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755855AbZEXHDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 03:03:10 -0400
Date: Sun, 24 May 2009 07:02:29 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf top: fix segfault
Message-ID: <tip-c2990a2a582d73562d4dcf2502c39892a19a691d@git.kernel.org>
Git-Commit-ID: c2990a2a582d73562d4dcf2502c39892a19a691d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 24 May 2009 07:02:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c2990a2a582d73562d4dcf2502c39892a19a691d
Gitweb:     http://git.kernel.org/tip/c2990a2a582d73562d4dcf2502c39892a19a691d
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Sun, 24 May 2009 08:35:49 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 24 May 2009 08:57:08 +0200

perf top: fix segfault

c6eb13 increased stack usage such that perf-top now croaks on startup.

Take event_array and mmap_array off the stack to prevent segfault on boxen
with smallish ulimit -s setting.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-top.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
index a3216a6..74021ac 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
@@ -1035,10 +1035,11 @@ static void mmap_read(struct mmap_data *md)
 	md->prev = old;
 }
 
+static struct pollfd event_array[MAX_NR_CPUS * MAX_COUNTERS];
+static struct mmap_data mmap_array[MAX_NR_CPUS][MAX_COUNTERS];
+
 int cmd_top(int argc, char **argv, const char *prefix)
 {
-	struct pollfd event_array[MAX_NR_CPUS * MAX_COUNTERS];
-	struct mmap_data mmap_array[MAX_NR_CPUS][MAX_COUNTERS];
 	struct perf_counter_hw_event hw_event;
 	pthread_t thread;
 	int i, counter, group_fd, nr_poll = 0;
