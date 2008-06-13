Return-Path: <linux-kernel-owner+w=401wt.eu-S1761616AbYFMIyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761616AbYFMIyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 04:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755049AbYFMIyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 04:54:10 -0400
Received: from hu-out-0506.google.com ([72.14.214.224]:51271 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009AbYFMIyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 04:54:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=Ucd2K7YKxV9gvRYo2pKLEKnXSUWLlEgHNIN0wWLc0lRSNljFiwu7nWKljtvQiDZNz8
         n9+4FocKYKk8P5t4WyG2gdutT0Ny9c287ZHDed7VSFSV1QPufYyLMGadt9QyXqlZlGUi
         Ww/dBOQfmNVv4+SRCwSTX8Fhvfwg+xeDHV+P0=
Date: Fri, 13 Jun 2008 10:54:01 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] stacktrace: add saved stack traces to backtrace self-test
Message-ID: <20080613085401.GA3139@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 13 Jun 2008 10:26:44 +0200
Subject: [PATCH] stacktrace: add saved stack traces to backtrace self-test

This patch adds saved stack-traces to the backtrace suite of self-tests.

Note that we don't unconditionally enable CONFIG_STACKTRACE because not
all architectures may have it.

Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 kernel/backtracetest.c |   30 +++++++++++++++++++++++++++++-
 lib/Kconfig.debug      |    3 +++
 2 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/kernel/backtracetest.c b/kernel/backtracetest.c
index d1a7605..50f7abd 100644
--- a/kernel/backtracetest.c
+++ b/kernel/backtracetest.c
@@ -10,9 +10,10 @@
  * of the License.
  */
 
+#include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/sched.h>
-#include <linux/delay.h>
+#include <linux/stacktrace.h>
 
 static struct timer_list backtrace_timer;
 
@@ -22,6 +23,31 @@ static void backtrace_test_timer(unsigned long data)
 	printk("The following trace is a kernel self test and not a bug!\n");
 	dump_stack();
 }
+
+#ifdef CONFIG_STACKTRACE
+static void backtrace_test_saved(void)
+{
+	struct stack_trace trace;
+	unsigned long entries[8];
+
+	printk("Testing a saved backtrace.\n");
+	printk("The following trace is a kernel self test and not a bug!\n");
+
+	trace.nr_entries = 0;
+	trace.max_entries = ARRAY_SIZE(entries);
+	trace.entries = entries;
+	trace.skip = 0;
+
+	save_stack_trace(&trace);
+	print_stack_trace(&trace, 0);
+}
+#else
+static void backtrace_test_saved(void)
+{
+	printk("Saved backtrace test skipped.\n");
+}
+#endif
+
 static int backtrace_regression_test(void)
 {
 	printk("====[ backtrace testing ]===========\n");
@@ -29,6 +55,8 @@ static int backtrace_regression_test(void)
 	printk("The following trace is a kernel self test and not a bug!\n");
 	dump_stack();
 
+	backtrace_test_saved();
+
 	init_timer(&backtrace_timer);
 	backtrace_timer.function = backtrace_test_timer;
 	mod_timer(&backtrace_timer, jiffies + 10);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index d2099f4..4dac3c7 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -563,6 +563,9 @@ config BACKTRACE_SELF_TEST
 	  for distributions or general kernels, but only for kernel
 	  developers working on architecture code.
 
+	  Note that if you want to also test saved backtraces, you will
+	  have to enable STACKTRACE as well.
+
 	  Say N if you are unsure.
 
 config LKDTM
-- 
1.5.4.1

