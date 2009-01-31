Return-Path: <linux-kernel-owner+w=401wt.eu-S1759698AbZAaD2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759698AbZAaD2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbZAaD1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 22:27:49 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:1402 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759484AbZAaD1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 22:27:48 -0500
From: =?utf-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: swetland@google.com, pavel@ucw.cz,
       =?utf-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: [PATCH 2/2] PM: Fix suspend_console/resume_console to use only one semaphore.
Date: Fri, 30 Jan 2009 19:27:39 -0800
Message-Id: <1233372459-6434-2-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1233372459-6434-1-git-send-email-arve@android.com>
References: <20090128193047.GA1222@ucw.cz>
 <1233372459-6434-1-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a race if another thread acquired the console
while it was suspended and released it after it was resumed
the secondary console semaphre would be left locked, and the
primary semaphore would be released twice. This in turn caused
the console switch on suspend or resume to hang forever.

Note that suspend_console does not actually lock the console
for clients that use acquire_console_sem, it only locks it for
clients that use try_acquire_console_sem. If we change
suspend_console to fully lock the console, then the kernel
may deadlock on suspend.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 kernel/printk.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 7015733..118ee77 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -73,7 +73,6 @@ EXPORT_SYMBOL(oops_in_progress);
  * driver system.
  */
 static DECLARE_MUTEX(console_sem);
-static DECLARE_MUTEX(secondary_console_sem);
 struct console *console_drivers;
 EXPORT_SYMBOL_GPL(console_drivers);
 
@@ -896,12 +895,14 @@ void suspend_console(void)
 	printk("Suspending console(s) (use no_console_suspend to debug)\n");
 	acquire_console_sem();
 	console_suspended = 1;
+	up(&console_sem);
 }
 
 void resume_console(void)
 {
 	if (!console_suspend_enabled)
 		return;
+	down(&console_sem);
 	console_suspended = 0;
 	release_console_sem();
 }
@@ -917,11 +918,9 @@ void resume_console(void)
 void acquire_console_sem(void)
 {
 	BUG_ON(in_interrupt());
-	if (console_suspended) {
-		down(&secondary_console_sem);
-		return;
-	}
 	down(&console_sem);
+	if (console_suspended)
+		return;
 	console_locked = 1;
 	console_may_schedule = 1;
 }
@@ -931,6 +930,10 @@ int try_acquire_console_sem(void)
 {
 	if (down_trylock(&console_sem))
 		return -1;
+	if (console_suspended) {
+		up(&console_sem);
+		return -1;
+	}
 	console_locked = 1;
 	console_may_schedule = 0;
 	return 0;
@@ -984,7 +987,7 @@ void release_console_sem(void)
 	unsigned wake_klogd = 0;
 
 	if (console_suspended) {
-		up(&secondary_console_sem);
+		up(&console_sem);
 		return;
 	}
 
-- 
1.6.1

