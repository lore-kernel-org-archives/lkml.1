Return-Path: <linux-kernel-owner+w=401wt.eu-S1759031AbZENWqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759031AbZENWqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 18:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756267AbZENWmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:42:10 -0400
Received: from kroah.org ([198.145.64.141]:51543 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756127AbZENWmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:42:04 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:35:22 2009
Message-Id: <20090514223522.162177437@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:32:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Bart Van Assche <bart.vanassche@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 12/51] Fix for enabling branch profiling makes sparse unusable
References: <20090514223235.348540705@mini.kroah.org>
Content-Disposition: inline; filename=fix-for-enabling-branch-profiling-makes-sparse-unusable.patch
In-Reply-To: <20090514223755.GA27019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bart Van Assche <bart.vanassche@gmail.com>

commit d9ad8bc0ca823705413f75b50c442a88cc518b35 upstream.

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

This patch is already included in 2.6.30-rc1 -- see also
http://lkml.org/lkml/2009/4/5/120.

Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <srostedt@redhat.com>
LKML-Reference: <200904051620.02311.bart.vanassche@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/compiler.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -75,7 +75,8 @@ struct ftrace_branch_data {
  * Note: DISABLE_BRANCH_PROFILING can be used by special lowlevel code
  * to disable branch tracing on a per file basis.
  */
-#if defined(CONFIG_TRACE_BRANCH_PROFILING) && !defined(DISABLE_BRANCH_PROFILING)
+#if defined(CONFIG_TRACE_BRANCH_PROFILING) \
+    && !defined(DISABLE_BRANCH_PROFILING) && !defined(__CHECKER__)
 void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 
 #define likely_notrace(x)	__builtin_expect(!!(x), 1)


