Return-Path: <linux-kernel-owner+w=401wt.eu-S932188AbZBNBXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188AbZBNBXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:23:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762937AbZBNBIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:08:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40920 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762924AbZBNBIo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:08:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 9/9] PM: Fix suspend_console and resume_console to use only one semaphore
Date: Sat, 14 Feb 2009 02:07:24 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>
References: <200902140157.40869.rjw@sisk.pl>
In-Reply-To: <200902140157.40869.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902140207.25476.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

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
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

 kernel/printk.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

Index: linux-2.6/kernel/printk.c
===================================================================
--- linux-2.6.orig/kernel/printk.c
+++ linux-2.6/kernel/printk.c
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
 
