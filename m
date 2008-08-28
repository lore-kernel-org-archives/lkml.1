Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbYH1Mfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbYH1Mfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 08:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbYH1Mfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 08:35:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46744 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112AbYH1Mfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 08:35:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] ftrace: disable tracing for hibernation
Date: Thu, 28 Aug 2008 14:39:12 +0200
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Marcin Slusarz <marcin.slusarz@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <alpine.DEB.1.10.0808211139420.3947@gandalf.stny.rr.com> <alpine.DEB.1.10.0808270844500.7871@gandalf.stny.rr.com> <200808271526.46868.rjw@sisk.pl>
In-Reply-To: <200808271526.46868.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808281439.13959.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

ftrace: disable tracing for hibernation
    
In accordance with commit f42ac38c59e0a03d6da0c24a63fb211393f484b0
("ftrace: disable tracing for suspend to ram"), disable tracing
around the suspend code in hibernation code paths.
    
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/disk.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/power/disk.c
===================================================================
--- linux-2.6.orig/kernel/power/disk.c
+++ linux-2.6/kernel/power/disk.c
@@ -21,6 +21,7 @@
 #include <linux/console.h>
 #include <linux/cpu.h>
 #include <linux/freezer.h>
+#include <linux/ftrace.h>
 
 #include "power.h"
 
@@ -255,7 +256,7 @@ static int create_image(int platform_mod
 
 int hibernation_snapshot(int platform_mode)
 {
-	int error;
+	int error, ftrace_save;
 
 	/* Free memory before shutting down devices. */
 	error = swsusp_shrink_memory();
@@ -267,6 +268,7 @@ int hibernation_snapshot(int platform_mo
 		goto Close;
 
 	suspend_console();
+	ftrace_save = __ftrace_enabled_save();
 	error = device_suspend(PMSG_FREEZE);
 	if (error)
 		goto Recover_platform;
@@ -296,6 +298,7 @@ int hibernation_snapshot(int platform_mo
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
@@ -384,6 +388,7 @@ int hibernation_restore(int platform_mod
 	platform_restore_cleanup(platform_mode);
 	device_resume(PMSG_RECOVER);
  Finish:
+	__ftrace_enabled_restore(ftrace_save);
 	resume_console();
 	pm_restore_console();
 	return error;
@@ -396,7 +401,7 @@ int hibernation_restore(int platform_mod
 
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
