Return-Path: <linux-kernel-owner+w=401wt.eu-S1760154AbYF0QFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154AbYF0QFM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 12:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755918AbYF0QFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 12:05:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:39005 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbYF0QE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 12:04:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=ICaLMzV4DlaNhnhdgAMJqqeeN8VdiYS8OvXyw4rVwS2ltoQmhLw60IBpfRHWrj7J/z
         cqJxWoXcNJ08VaEcse7g3igOkYfkKDMYj3F8KsBu8zDWuahEHQt9IO2rdqAE2cfreVSu
         hgCTXiAHxUyKe0oLvu1s0nxLqBYLCLTe2QcuE=
Date: Fri, 27 Jun 2008 18:04:48 +0200
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: [RESEND][PATCH 1/2] stacktrace: add saved stack traces to
	backtrace self-test
Message-ID: <20080627160448.GB8852@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm not really sure to whom this goes. It seems that the original code
came through the x86 tree, although the code itself seems to be
entirely generic.

(The last time I sent it, it was to Andrew only, though he seemed to
be on holidays at the time. Now I have a patch #2 as well!)

Arjan, are there any objections to this?

(This is not intended for 2.6.26. In case that wasn't obvious, heh.)


Vegard


From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Thu, 26 Jun 2008 13:27:35 +0200
Subject: [PATCH] stacktrace: add saved stack traces to backtrace self-test

This patch adds saved stack-traces to the backtrace suite of self-tests.

Note that we don't depend on or unconditionally enable CONFIG_STACKTRACE
because not all architectures may have it (and we still want to enable the
other tests for those architectures).

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

