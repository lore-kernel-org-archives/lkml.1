Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbYH1Nbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbYH1Nbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 09:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbYH1Nbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 09:31:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35769 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbYH1Nbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 09:31:37 -0400
Date: Thu, 28 Aug 2008 15:31:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] tracing fixes
Message-ID: <20080828133120.GA31952@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

Thanks,

	Ingo

------------------>
Rafael J. Wysocki (1):
      ftrace: disable tracing for hibernation


 kernel/power/disk.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/kernel/power/disk.c b/kernel/power/disk.c
index f011e08..bbd85c6 100644
--- a/kernel/power/disk.c
+++ b/kernel/power/disk.c
@@ -21,6 +21,7 @@
 #include <linux/console.h>
 #include <linux/cpu.h>
 #include <linux/freezer.h>
+#include <linux/ftrace.h>
 
 #include "power.h"
 
@@ -255,7 +256,7 @@ static int create_image(int platform_mode)
 
 int hibernation_snapshot(int platform_mode)
 {
-	int error;
+	int error, ftrace_save;
 
 	/* Free memory before shutting down devices. */
 	error = swsusp_shrink_memory();
@@ -267,6 +268,7 @@ int hibernation_snapshot(int platform_mode)
 		goto Close;
 
 	suspend_console();
+	ftrace_save = __ftrace_enabled_save();
 	error = device_suspend(PMSG_FREEZE);
 	if (error)
 		goto Recover_platform;
@@ -296,6 +298,7 @@ int hibernation_snapshot(int platform_mode)
  Resume_devices:
 	device_resume(in_suspend ?
 		(error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE);
+	__ftrace_enabled_restore(ftrace_save);
 	resume_console();
  Close:
 	platform_end(platform_mode);
@@ -366,10 +369,11 @@ static int resume_target_kernel(void)
 
 int hibernation_restore(int platform_mode)
 {
-	int error;
+	int error, ftrace_save;
 
 	pm_prepare_console();
 	suspend_console();
+	ftrace_save = __ftrace_enabled_save();
 	error = device_suspend(PMSG_QUIESCE);
 	if (error)
 		goto Finish;
@@ -384,6 +388,7 @@ int hibernation_restore(int platform_mode)
 	platform_restore_cleanup(platform_mode);
 	device_resume(PMSG_RECOVER);
  Finish:
+	__ftrace_enabled_restore(ftrace_save);
 	resume_console();
 	pm_restore_console();
 	return error;
@@ -396,7 +401,7 @@ int hibernation_restore(int platform_mode)
 
 int hibernation_platform_enter(void)
 {
-	int error;
+	int error, ftrace_save;
 
 	if (!hibernation_ops)
 		return -ENOSYS;
@@ -411,6 +416,7 @@ int hibernation_platform_enter(void)
 		goto Close;
 
 	suspend_console();
+	ftrace_save = __ftrace_enabled_save();
 	error = device_suspend(PMSG_HIBERNATE);
 	if (error) {
 		if (hibernation_ops->recover)
@@ -445,6 +451,7 @@ int hibernation_platform_enter(void)
 	hibernation_ops->finish();
  Resume_devices:
 	device_resume(PMSG_RESTORE);
+	__ftrace_enabled_restore(ftrace_save);
 	resume_console();
  Close:
 	hibernation_ops->end();
