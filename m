Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbZFGPwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbZFGPwT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 11:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbZFGPwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 11:52:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:41662 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012AbZFGPwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 11:52:05 -0400
Date: Sun, 7 Jun 2009 15:51:32 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Handle kernels with !CONFIG_PERF_COUNTER
Message-ID: <tip-30c806a094493beb7691bc7957dfa02dee96230a@git.kernel.org>
Git-Commit-ID: 30c806a094493beb7691bc7957dfa02dee96230a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 07 Jun 2009 15:51:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  30c806a094493beb7691bc7957dfa02dee96230a
Gitweb:     http://git.kernel.org/tip/30c806a094493beb7691bc7957dfa02dee96230a
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 7 Jun 2009 17:46:24 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 7 Jun 2009 17:46:24 +0200

perf_counter tools: Handle kernels with !CONFIG_PERF_COUNTER

If perf is run on a !CONFIG_PERF_COUNTER kernel right now it
bails out with no messages or with confusing messages.

Standardize this case some more and explain the situation.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-record.c |    7 ++++---
 tools/perf/builtin-top.c    |    8 ++++----
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 8786629..deaee42 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -356,9 +356,6 @@ try_again:
 	if (fd[nr_cpu][counter] < 0) {
 		int err = errno;
 
-		if (verbose)
-			error("sys_perf_counter_open() syscall returned with %d (%s)\n",
-				fd[nr_cpu][counter], strerror(err));
 		if (err == EPERM)
 			die("Permission error - are you root?\n");
 
@@ -376,6 +373,10 @@ try_again:
 			attr->config = PERF_COUNT_CPU_CLOCK;
 			goto try_again;
 		}
+		printf("\n");
+		error("perfcounter syscall returned with %d (%s)\n",
+			fd[nr_cpu][counter], strerror(err));
+		die("No CONFIG_PERF_COUNTERS=y kernel support configured?\n");
 		exit(-1);
 	}
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 1f8c97d..be1698f 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -551,10 +551,6 @@ try_again:
 	if (fd[i][counter] < 0) {
 		int err = errno;
 
-		if (verbose)
-			error("sys_perf_counter_open() syscall returned with %d (%s)\n",
-				fd[i][counter], strerror(err));
-
 		if (err == EPERM)
 			die("No permission - are you root?\n");
 		/*
@@ -572,6 +568,10 @@ try_again:
 			attr->config = PERF_COUNT_CPU_CLOCK;
 			goto try_again;
 		}
+		printf("\n");
+		error("perfcounter syscall returned with %d (%s)\n",
+			fd[i][counter], strerror(err));
+		die("No CONFIG_PERF_COUNTERS=y kernel support configured?\n");
 		exit(-1);
 	}
 	assert(fd[i][counter] >= 0);
