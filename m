Return-Path: <linux-kernel-owner+w=401wt.eu-S1758824AbXGDAMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824AbXGDAMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 20:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbXGDAMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 20:12:23 -0400
Received: from styx.suse.cz ([82.119.242.94]:37823 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753286AbXGDAMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 20:12:23 -0400
Date: Wed, 4 Jul 2007 02:16:03 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kernel/printk.c: document possible deadlock against scheduler
Message-ID: <Pine.LNX.4.64.0707040214440.11634@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

kernel/printk.c: document possible deadlock against scheduler

The printk's comment states that it can be called from every context,
which might lead to false illusion that it could be called from everywhere
without any restrictions.

This is however not true - a call to printk() could deadlock if called from
scheduler code (namely from schedule(), wake_up(), etc) on runqueue lock
when it tries to wake up klogd. Document this.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/kernel/printk.c b/kernel/printk.c
index 0bbdeac..a3a7d53 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -483,6 +483,9 @@ static int have_callable_console(void)
  * @fmt: format string
  *
  * This is printk().  It can be called from any context.  We want it to work.
+ * Be aware of the fact that if oops_in_progress is not set, we might try to
+ * wake klogd up which could deadlock on runqueue lock if printk() is called
+ * from scheduler code.
  *
  * We try to grab the console_sem.  If we succeed, it's easy - we log the output and
  * call the console drivers.  If we fail to get the semaphore we place the output
