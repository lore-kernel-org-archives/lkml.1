Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbZBCCEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbZBCCEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 21:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbZBCCEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 21:04:00 -0500
Received: from rv-out-0506.google.com ([209.85.198.238]:30884 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbZBCCD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 21:03:59 -0500
From: =?utf-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: swetland@google.com, mm-commits@vger.kernel.org,
       =?utf-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: [PATCH] PM: Fix suspend_console/resume_console to use only one semaphore.
Date: Mon,  2 Feb 2009 18:03:44 -0800
Message-Id: <1233626624-28569-1-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1233372459-6434-2-git-send-email-arve@android.com>
References: <1233372459-6434-2-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a race where a thread acquires the console while the
console is suspended, and the console is resumed before this
thread releases it. In this case, the secondary console
semaphore would be left locked, and the primary semaphore would
be released twice. This in turn would cause the console switch
on suspend or resume to hang forever.

Note that suspend_console does not actually lock the console
for clients that use acquire_console_sem, it only locks it for
clients that use try_acquire_console_sem. If we change
suspend_console to fully lock the console, then the kernel
may deadlock on suspend. One client of try_acquire_console_sem
is acquire_console_semaphore_for_printk, which uses it to
prevent printk from using the console while it is suspended.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 kernel/printk.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 69188f2..e3602d0 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -73,7 +73,6 @@ EXPORT_SYMBOL(oops_in_progress);
  * driver system.
  */
 static DECLARE_MUTEX(console_sem);
-static DECLARE_MUTEX(secondary_console_sem);
 struct console *console_drivers;
 EXPORT_SYMBOL_GPL(console_drivers);
 
@@ -891,12 +890,14 @@ void suspend_console(void)
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
@@ -912,11 +913,9 @@ void resume_console(void)
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
@@ -926,6 +925,10 @@ int try_acquire_console_sem(void)
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
@@ -979,7 +982,7 @@ void release_console_sem(void)
 	unsigned wake_klogd = 0;
 
 	if (console_suspended) {
-		up(&secondary_console_sem);
+		up(&console_sem);
 		return;
 	}
 
-- 
1.6.1

