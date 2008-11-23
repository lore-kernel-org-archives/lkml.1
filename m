Return-Path: <linux-kernel-owner+w=401wt.eu-S1758230AbYKWJl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbYKWJl6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 04:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbYKWJlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 04:41:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53187 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbYKWJlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 04:41:49 -0500
Date: Sun, 23 Nov 2008 10:41:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Peter Teoh <htmldeveloper@gmail.com>, Steven Rostedt <srostedt@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: allow tracing of suspend/resume & hibernation
	code again
Message-ID: <20081123094124.GO30453@elte.hu>
References: <804dabb00811220047q6e0f24eap23e9a7c4c7bd71b6@mail.gmail.com> <200811221359.24808.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811221359.24808.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > Q2: how to ftrace s2ram and resume?  I attempted to do it, but the 
> > trace output is always filled with "resume" related functions when 
> > it started up, which is only logical.
> 
> The tracing is disabled during suspend/resume, so you can't.

i think we could lift this restriction now that dftrace is gone for 
good - which was causing most of the trouble.

  41108eb10142e0552f2de1e4c0675b108c5f018f
  f42ac38c59e0a03d6da0c24a63fb211393f484b0

Completely untested patch below. Peter, does it work for you?

	Ingo

------------------->
>From 3134c953216111a35d17f77b784e5d1fa2ba36d5 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 23 Nov 2008 10:37:12 +0100
Subject: [PATCH] tracing: allow tracing of suspend/resume & hibernation code again:

Now that the ftrace kernel thread is gone, we can allow tracing
during suspend/resume again.

So revert these two commits:

  f42ac38c5 "ftrace: disable tracing for suspend to ram"
  41108eb10 "ftrace: disable tracing for hibernation"

This should be tested very carefully, as it could interact with
altneratives instruction patching, etc.

Not-Yet-Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/power/disk.c |   13 +++----------
 kernel/power/main.c |    5 +----
 2 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/kernel/power/disk.c b/kernel/power/disk.c
index c9d7408..f77d381 100644
--- a/kernel/power/disk.c
+++ b/kernel/power/disk.c
@@ -22,7 +22,6 @@
 #include <linux/console.h>
 #include <linux/cpu.h>
 #include <linux/freezer.h>
-#include <linux/ftrace.h>
 
 #include "power.h"
 
@@ -257,7 +256,7 @@ static int create_image(int platform_mode)
 
 int hibernation_snapshot(int platform_mode)
 {
-	int error, ftrace_save;
+	int error;
 
 	/* Free memory before shutting down devices. */
 	error = swsusp_shrink_memory();
@@ -269,7 +268,6 @@ int hibernation_snapshot(int platform_mode)
 		goto Close;
 
 	suspend_console();
-	ftrace_save = __ftrace_enabled_save();
 	error = device_suspend(PMSG_FREEZE);
 	if (error)
 		goto Recover_platform;
@@ -299,7 +297,6 @@ int hibernation_snapshot(int platform_mode)
  Resume_devices:
 	device_resume(in_suspend ?
 		(error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE);
-	__ftrace_enabled_restore(ftrace_save);
 	resume_console();
  Close:
 	platform_end(platform_mode);
@@ -370,11 +367,10 @@ static int resume_target_kernel(void)
 
 int hibernation_restore(int platform_mode)
 {
-	int error, ftrace_save;
+	int error;
 
 	pm_prepare_console();
 	suspend_console();
-	ftrace_save = __ftrace_enabled_save();
 	error = device_suspend(PMSG_QUIESCE);
 	if (error)
 		goto Finish;
@@ -389,7 +385,6 @@ int hibernation_restore(int platform_mode)
 	platform_restore_cleanup(platform_mode);
 	device_resume(PMSG_RECOVER);
  Finish:
-	__ftrace_enabled_restore(ftrace_save);
 	resume_console();
 	pm_restore_console();
 	return error;
@@ -402,7 +397,7 @@ int hibernation_restore(int platform_mode)
 
 int hibernation_platform_enter(void)
 {
-	int error, ftrace_save;
+	int error;
 
 	if (!hibernation_ops)
 		return -ENOSYS;
@@ -417,7 +412,6 @@ int hibernation_platform_enter(void)
 		goto Close;
 
 	suspend_console();
-	ftrace_save = __ftrace_enabled_save();
 	error = device_suspend(PMSG_HIBERNATE);
 	if (error) {
 		if (hibernation_ops->recover)
@@ -452,7 +446,6 @@ int hibernation_platform_enter(void)
 	hibernation_ops->finish();
  Resume_devices:
 	device_resume(PMSG_RESTORE);
-	__ftrace_enabled_restore(ftrace_save);
 	resume_console();
  Close:
 	hibernation_ops->end();
diff --git a/kernel/power/main.c b/kernel/power/main.c
index eaa122b..142e005 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -22,7 +22,6 @@
 #include <linux/freezer.h>
 #include <linux/vmstat.h>
 #include <linux/syscalls.h>
-#include <linux/ftrace.h>
 
 #include "power.h"
 
@@ -321,7 +320,7 @@ static int suspend_enter(suspend_state_t state)
  */
 int suspend_devices_and_enter(suspend_state_t state)
 {
-	int error, ftrace_save;
+	int error;
 
 	if (!suspend_ops)
 		return -ENOSYS;
@@ -332,7 +331,6 @@ int suspend_devices_and_enter(suspend_state_t state)
 			goto Close;
 	}
 	suspend_console();
-	ftrace_save = __ftrace_enabled_save();
 	suspend_test_start();
 	error = device_suspend(PMSG_SUSPEND);
 	if (error) {
@@ -364,7 +362,6 @@ int suspend_devices_and_enter(suspend_state_t state)
 	suspend_test_start();
 	device_resume(PMSG_RESUME);
 	suspend_test_finish("resume devices");
-	__ftrace_enabled_restore(ftrace_save);
 	resume_console();
  Close:
 	if (suspend_ops->end)
