Return-Path: <linux-kernel-owner+w=401wt.eu-S1762217AbXEKJJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762217AbXEKJJB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 05:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758340AbXEKJHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 05:07:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58484 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756272AbXEKJGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 05:06:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/7] Freezer: Take kernel_execve into consideration
Date: Fri, 11 May 2007 00:39:03 +0200
User-Agent: KMail/1.9.5
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200705110035.32229.rjw@sisk.pl>
In-Reply-To: <200705110035.32229.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705110039.04898.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Kernel threads can become userland processes by calling kernel_execve().  In
particular, this may happen right after
try_to_freeze_tasks(FREEZER_USER_SPACE) has returned, so try_to_freeze_tasks()
needs to take userspace processes into consideration even if it is called with
FREEZER_KERNEL_THREADS.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 kernel/power/process.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/power/process.c
===================================================================
--- linux-2.6.orig/kernel/power/process.c	2007-05-10 21:44:36.000000000 +0200
+++ linux-2.6/kernel/power/process.c	2007-05-10 21:44:40.000000000 +0200
@@ -126,7 +126,7 @@ static unsigned int try_to_freeze_tasks(
 				cancel_freezing(p);
 				continue;
 			}
-			if (is_user_space(p) == !freeze_user_space)
+			if (freeze_user_space && !is_user_space(p))
 				continue;
 
 			freeze_process(p);
@@ -153,7 +153,7 @@ static unsigned int try_to_freeze_tasks(
 				TIMEOUT / HZ, todo);
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
-			if (is_user_space(p) == !freeze_user_space)
+			if (freeze_user_space && !is_user_space(p))
 				continue;
 
 			task_lock(p);

