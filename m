Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbYF0QH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbYF0QH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 12:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760383AbYF0QHC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 12:07:02 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:42624 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759608AbYF0QHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 12:07:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=YHSCBnOyyEztY59nR6yf/VXQCQ0MJj2fyiochKOo393AUGro+jt8W1OzhHt/bm3i8o
         CJKF5+aR95kFChbJ/W8ELBj00FhpamvnPxHjEfHYNiufTKF2pmjNv4DSQu+twox/jxhl
         L4uXxpHUaj8nTAjEjvinDXQ8bghSkd3SP54GI=
Date: Fri, 27 Jun 2008 18:06:54 +0200
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] backtrace: replace timer with tasklet + completions
Message-ID: <20080627160654.GC8852@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Thu, 26 Jun 2008 14:06:54 +0200
Subject: [PATCH] backtrace: replace timer with tasklet + completions

On qemu, the backtrace would show up _after_ the "end of backtrace
testing" message.

This patch changes it to use completions instead, which will guarantee
that no such race exists.

Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 kernel/backtracetest.c |   37 ++++++++++++++++++++++++++-----------
 1 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/kernel/backtracetest.c b/kernel/backtracetest.c
index 50f7abd..a5e026b 100644
--- a/kernel/backtracetest.c
+++ b/kernel/backtracetest.c
@@ -10,18 +10,39 @@
  * of the License.
  */
 
+#include <linux/completion.h>
 #include <linux/delay.h>
+#include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/stacktrace.h>
 
-static struct timer_list backtrace_timer;
+static void backtrace_test_normal(void)
+{
+	printk("Testing a backtrace from process context.\n");
+	printk("The following trace is a kernel self test and not a bug!\n");
+
+	dump_stack();
+}
+
+static DECLARE_COMPLETION(backtrace_work);
+
+static void backtrace_test_irq_callback(unsigned long data)
+{
+	dump_stack();
+	complete(&backtrace_work);
+}
+
+static DECLARE_TASKLET(backtrace_tasklet, &backtrace_test_irq_callback, 0);
 
-static void backtrace_test_timer(unsigned long data)
+static void backtrace_test_irq(void)
 {
 	printk("Testing a backtrace from irq context.\n");
 	printk("The following trace is a kernel self test and not a bug!\n");
-	dump_stack();
+
+	init_completion(&backtrace_work);
+	tasklet_schedule(&backtrace_tasklet);
+	wait_for_completion(&backtrace_work);
 }
 
 #ifdef CONFIG_STACKTRACE
@@ -51,17 +72,11 @@ static void backtrace_test_saved(void)
 static int backtrace_regression_test(void)
 {
 	printk("====[ backtrace testing ]===========\n");
-	printk("Testing a backtrace from process context.\n");
-	printk("The following trace is a kernel self test and not a bug!\n");
-	dump_stack();
 
+	backtrace_test_normal();
+	backtrace_test_irq();
 	backtrace_test_saved();
 
-	init_timer(&backtrace_timer);
-	backtrace_timer.function = backtrace_test_timer;
-	mod_timer(&backtrace_timer, jiffies + 10);
-
-	msleep(10);
 	printk("====[ end of backtrace testing ]====\n");
 	return 0;
 }
-- 
1.5.4.1

