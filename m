Return-Path: <linux-kernel-owner+w=401wt.eu-S1758757AbZDGTcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757AbZDGTcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 15:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757010AbZDGTcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 15:32:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:39446 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755890AbZDGTb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 15:31:59 -0400
Date: Tue, 7 Apr 2009 19:30:34 GMT
From: Bart Van Assche <bart.vanassche@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, srostedt@redhat.com, tglx@linutronix.de,
       bart.vanassche@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, srostedt@redhat.com, tglx@linutronix.de,
       bart.vanassche@gmail.com, mingo@elte.hu
In-Reply-To: <200904051620.02311.bart.vanassche@gmail.com>
References: <200904051620.02311.bart.vanassche@gmail.com>
Subject: [tip:tracing/urgent] branch tracer: Fix for enabling branch profiling makes sparse unusable
Message-ID: <tip-d9ad8bc0ca823705413f75b50c442a88cc518b35@git.kernel.org>
Git-Commit-ID: d9ad8bc0ca823705413f75b50c442a88cc518b35
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Apr 2009 19:30:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d9ad8bc0ca823705413f75b50c442a88cc518b35
Gitweb:     http://git.kernel.org/tip/d9ad8bc0ca823705413f75b50c442a88cc518b35
Author:     Bart Van Assche <bart.vanassche@gmail.com>
AuthorDate: Sun, 5 Apr 2009 16:20:02 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 17:07:40 +0200

branch tracer: Fix for enabling branch profiling makes sparse unusable

One of the changes between kernels 2.6.28 and 2.6.29 is that a branch profiler
has been added for if() statements. Unfortunately this patch makes the sparse
output unusable with CONFIG_TRACE_BRANCH_PROFILING=y: when branch profiling is
enabled, sparse prints so much false positives that the real issues are no
longer visible. This behavior can be reproduced as follows:
* enable CONFIG_TRACE_BRANCH_PROFILING, e.g. by running make allyesconfig or
  make allmodconfig.
* run make C=2

Result: a huge number of the following sparse warnings.
..
include/linux/cpumask.h:547:2: warning: symbol '______r' shadows an earlier one
include/linux/cpumask.h:547:2: originally declared here
..

The patch below fixes this by disabling branch profiling while analyzing the
kernel code with sparse.

See also:
* http://lkml.org/lkml/2008/11/21/18
* http://bugzilla.kernel.org/show_bug.cgi?id=12925

Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <srostedt@redhat.com>
LKML-Reference: <200904051620.02311.bart.vanassche@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/compiler.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 6faa7e5..8872ad6 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -76,7 +76,8 @@ struct ftrace_branch_data {
  * Note: DISABLE_BRANCH_PROFILING can be used by special lowlevel code
  * to disable branch tracing on a per file basis.
  */
-#if defined(CONFIG_TRACE_BRANCH_PROFILING) && !defined(DISABLE_BRANCH_PROFILING)
+#if defined(CONFIG_TRACE_BRANCH_PROFILING) \
+    && !defined(DISABLE_BRANCH_PROFILING) && !defined(__CHECKER__)
 void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 
 #define likely_notrace(x)	__builtin_expect(!!(x), 1)
