Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab0CJJ3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 04:29:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab0CJJ3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 04:29:22 -0500
From: Xiaotian Feng <dfeng@redhat.com>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       David Rientjes <rientjes@google.com>
Subject: [PATCH] freezer: only show the state of tasks refusing to freeze
Date: Wed, 10 Mar 2010 17:28:42 +0800
Message-Id: <1268213322-5094-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

show_state will dump all tasks state, so if freezer failed to freeze
any task, kernel will dump all tasks state and flood the dmesg log.
This patch makes freezer only show state of tasks refusing to freeze.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Len Brown <len.brown@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Rientjes <rientjes@google.com>
---
 kernel/power/process.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/power/process.c b/kernel/power/process.c
index 5ade1bd..a0480cd 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -88,12 +88,11 @@ static int try_to_freeze_tasks(bool sig_only)
 		printk(KERN_ERR "Freezing of tasks failed after %d.%02d seconds "
 				"(%d tasks refusing to freeze):\n",
 				elapsed_csecs / 100, elapsed_csecs % 100, todo);
-		show_state();
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
 			task_lock(p);
 			if (freezing(p) && !freezer_should_skip(p))
-				printk(KERN_ERR " %s\n", p->comm);
+				sched_show_task(p);
 			cancel_freezing(p);
 			task_unlock(p);
 		} while_each_thread(g, p);
-- 
1.6.6.1

