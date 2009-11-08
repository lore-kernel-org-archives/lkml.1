Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbZKHQKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbZKHQKP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 11:10:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754500AbZKHQKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 11:10:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:33598 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660AbZKHQKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 11:10:07 -0500
Date: Sun, 8 Nov 2009 16:09:42 GMT
From: tip-bot for Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, penberg@cs.helsinki.fi,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       penberg@cs.helsinki.fi, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1257696066-4046-1-git-send-email-penberg@cs.helsinki.fi>
References: <1257696066-4046-1-git-send-email-penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Fix permission checks
Message-ID: <tip-c10edee2e1716f8cf217cf52ed01ae4742fcdf3c@git.kernel.org>
Git-Commit-ID: c10edee2e1716f8cf217cf52ed01ae4742fcdf3c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c10edee2e1716f8cf217cf52ed01ae4742fcdf3c
Gitweb:     http://git.kernel.org/tip/c10edee2e1716f8cf217cf52ed01ae4742fcdf3c
Author:     Pekka Enberg <penberg@cs.helsinki.fi>
AuthorDate: Sun, 8 Nov 2009 18:01:06 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Nov 2009 17:04:54 +0100

perf tools: Fix permission checks

The perf_event_open() system call returns EACCES if the user is
not root which results in a very confusing error message:

  $ perf record -A -a -f

    Error: perfcounter syscall returned with -1 (Permission denied)

    Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?

It turns out that's because perf tools are checking only for
EPERM. Fix that up to get a much better error message:

  $ perf record -A -a -f
    Fatal: Permission error - are you root?

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1257696066-4046-1-git-send-email-penberg@cs.helsinki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-record.c |    2 +-
 tools/perf/builtin-top.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 3eeef33..a4be453 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -426,7 +426,7 @@ try_again:
 	if (fd[nr_cpu][counter] < 0) {
 		int err = errno;
 
-		if (err == EPERM)
+		if (err == EPERM || err == EACCES)
 			die("Permission error - are you root?\n");
 		else if (err ==  ENODEV && profile_cpu != -1)
 			die("No such device - did you specify an out-of-range profile CPU?\n");
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index a1b1d10..e23bc74 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1027,7 +1027,7 @@ try_again:
 	if (fd[i][counter] < 0) {
 		int err = errno;
 
-		if (err == EPERM)
+		if (err == EPERM || err == EACCES)
 			die("No permission - are you root?\n");
 		/*
 		 * If it's cycles then fall back to hrtimer
