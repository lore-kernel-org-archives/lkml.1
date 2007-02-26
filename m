Return-Path: <linux-kernel-owner+w=401wt.eu-S1030201AbXBZKwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030201AbXBZKwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 05:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030205AbXBZKwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 05:52:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59258 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030199AbXBZKwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 05:52:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 2/3] Freezer: Take kernel_execve into consideration
Date: Mon, 26 Feb 2007 11:49:09 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Machek <pavel@ucw.cz>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
References: <200702261139.59130.rjw@sisk.pl>
In-Reply-To: <200702261139.59130.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702261149.10579.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Kernel threads can become userland processes by calling kernel_execve().  In
particular, this may happen right after try_to_freeze_tasks(FREEZER_USER_SPACE)
has returned, so try_to_freeze_tasks() needs to take userspace processes
into consideration even if it is called with FREEZER_KERNEL_THREADS.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/process.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.20-mm2/kernel/power/process.c
===================================================================
--- linux-2.6.20-mm2.orig/kernel/power/process.c	2007-02-26 08:41:18.000000000 +0100
+++ linux-2.6.20-mm2/kernel/power/process.c	2007-02-26 08:41:57.000000000 +0100
@@ -117,7 +117,7 @@ static unsigned int try_to_freeze_tasks(
 				cancel_freezing(p);
 				continue;
 			}
-			if (is_user_space(p) == !freeze_user_space)
+			if (freeze_user_space && !is_user_space(p))
 				continue;
 
 			freeze_process(p);
@@ -144,7 +144,7 @@ static unsigned int try_to_freeze_tasks(
 				TIMEOUT / HZ, todo);
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
-			if (is_user_space(p) == !freeze_user_space)
+			if (freeze_user_space && !is_user_space(p))
 				continue;
 
 			task_lock(p);

