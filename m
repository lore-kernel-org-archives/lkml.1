Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbYDUUZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbYDUUZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 16:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbYDUUZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 16:25:36 -0400
Received: from mail.windriver.com ([147.11.1.11]:61660 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbYDUUZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 16:25:35 -0400
Message-ID: <480CF842.8080405@windriver.com>
Date: Mon, 21 Apr 2008 15:25:38 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] kgdb: 1000 loops for the single step test
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Apr 2008 20:25:26.0712 (UTC) FILETIME=[D5A6E380:01C8A3ED]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo asked that the kgdb test suite's single step test be able to
execute more than one iteration of the test on boot to help track down
some timing issues.  The following patch was added to the kgdb queue
for the next pull request at:

http://git.kernel.org/?p=linux/kernel/git/jwessel/linux-2.6-kgdb.git;a=shortlog;h=for_linus

Thanks,
Jason.

---CLIP HERE---
From: Jason Wessel <jason.wessel@windriver.com>
Date: Mon, 21 Apr 2008 15:13:02 -0500
Subject: [PATCH] kgdb: 1000 loops for the single step test

The single step test is not terribly costly and it should be able to
pass at 1000 loops successfully in under 1 second.  A non-kgdb timing
regression was found using this test, but it did not occur frequently
because by default the test was only executed a single time.

This patch changes the default for the single step test to 1000
iterations and allows for individual configuration of the single step
test to further exercise the kgdb subsystem when needed.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/misc/kgdbts.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index b07e403..316e188 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -47,6 +47,7 @@
  *       to test the HW NMI watchdog
  * F## = Break at do_fork for ## iterations
  * S## = Break at sys_open for ## iterations
+ * I## = Run the single step test ## iterations
  *
  * NOTE: that the do_fork and sys_open tests are mutually exclusive.
  *
@@ -875,7 +876,9 @@ static void kgdbts_run_tests(void)
 	char *ptr;
 	int fork_test = 0;
 	int do_sys_open_test = 0;
+	int sstep_test = 1000;
 	int nmi_sleep = 0;
+	int i;
 
 	ptr = strstr(config, "F");
 	if (ptr)
@@ -886,6 +889,9 @@ static void kgdbts_run_tests(void)
 	ptr = strstr(config, "N");
 	if (ptr)
 		nmi_sleep = simple_strtol(ptr+1, NULL, 10);
+	ptr = strstr(config, "I");
+	if (ptr)
+		sstep_test = simple_strtol(ptr+1, NULL, 10);
 
 	/* required internal KGDB tests */
 	v1printk("kgdbts:RUN plant and detach test\n");
@@ -894,8 +900,13 @@ static void kgdbts_run_tests(void)
 	run_breakpoint_test(0);
 	v1printk("kgdbts:RUN bad memory access test\n");
 	run_bad_read_test();
-	v1printk("kgdbts:RUN singlestep breakpoint test\n");
-	run_singlestep_break_test();
+	v1printk("kgdbts:RUN singlestep test %i iterations\n", sstep_test);
+	for (i = 0; i < sstep_test; i++) {
+		run_singlestep_break_test();
+		if (i % 100 == 0)
+			v1printk("kgdbts:RUN singlestep [%i/%i]\n",
+				 i, sstep_test);
+	}
 
 	/* ===Optional tests=== */
 
-- 1.5.5.67.g9a49 
