Return-Path: <linux-kernel-owner+w=401wt.eu-S1756375AbZDEOrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375AbZDEOrq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 10:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755557AbZDEOrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 10:47:31 -0400
Received: from jester.euphonynet.be ([212.87.96.13]:50474 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401AbZDEOra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 10:47:30 -0400
X-Greylist: delayed 1637 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Apr 2009 10:47:29 EDT
From: Bart Van Assche <bart.vanassche@gmail.com>
To: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: [2.6.29] Fix for enabling branch profiling makes sparse unusable
Date: Sun, 5 Apr 2009 16:20:02 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.28.9-default; KDE/4.1.3; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904051620.02311.bart.vanassche@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the changes between kernels 2.6.28 and 2.6.29 is that a branch profiler
has been added for if() statements. Unfortunately this patch makes the sparse
output unusable with CONFIG_TRACE_BRANCH_PROFILING=y: when branch profiling is
enabled, sparse prints so much false positives that the real issues are no
longer visible. This behavior can be reproduced as follows:
* enable CONFIG_TRACE_BRANCH_PROFILING, e.g. by running make allyesconfig or
  make allmodconfig.
* run make C=2

Result: a huge number of the following sparse warnings.
...
include/linux/cpumask.h:547:2: warning: symbol '______r' shadows an earlier one
include/linux/cpumask.h:547:2: originally declared here
...

The patch below fixes this by disabling branch profiling while analyzing the
kernel code with sparse.

See also:
* http://lkml.org/lkml/2008/11/21/18
* http://bugzilla.kernel.org/show_bug.cgi?id=12925

Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>

--- orig/linux-2.6.29/include/linux/compiler.h	2009-03-23 19:12:14.000000000 -0400
+++ linux-2.6.29/include/linux/compiler.h	2009-03-24 08:46:46.000000000 -0400
@@ -75,7 +75,8 @@ struct ftrace_branch_data {
  * Note: DISABLE_BRANCH_PROFILING can be used by special lowlevel code
  * to disable branch tracing on a per file basis.
  */
-#if defined(CONFIG_TRACE_BRANCH_PROFILING) && !defined(DISABLE_BRANCH_PROFILING)
+#if defined(CONFIG_TRACE_BRANCH_PROFILING) \
+    && !defined(DISABLE_BRANCH_PROFILING) && !defined(__CHECKER__)
 void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 
 #define likely_notrace(x)	__builtin_expect(!!(x), 1)
