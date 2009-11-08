Return-Path: <linux-kernel-owner+w=401wt.eu-S1754459AbZKHQIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbZKHQIM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 11:08:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbZKHQIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 11:08:11 -0500
Received: from smtp5.welho.com ([213.243.153.39]:44746 "EHLO smtp5.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206AbZKHQIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 11:08:11 -0500
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Nov 2009 11:08:10 EST
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perf tools: Fix permission checks
Date: Sun,  8 Nov 2009 18:01:06 +0200
Message-Id: <1257696066-4046-1-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf_event_open() system call returns EACCES if the user is not root which
results in a very confusing error message:

  $ perf record -A -a -f

    Error: perfcounter syscall returned with -1 (Permission denied)

    Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?

It turns out that's because perf tools are checking only for EPERM. Fix that up
to get a much better error message:

  $ perf record -A -a -f
    Fatal: Permission error - are you root?

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
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
-- 
1.6.3.3

