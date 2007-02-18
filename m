Return-Path: <linux-kernel-owner+w=401wt.eu-S1752270AbXBRWUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbXBRWUR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 17:20:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbXBRWUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 17:20:17 -0500
Received: from mail.screens.ru ([213.234.233.54]:39691 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270AbXBRWUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 17:20:15 -0500
Date: Mon, 19 Feb 2007 01:17:37 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] fix refrigerator() vs thaw_process() race
Message-ID: <20070218221737.GA4880@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

refrigerator() can miss a wakeup, "wait event" loop needs a proper memory
ordering.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- WQ/kernel/power/process.c~WAKE	2007-02-18 22:56:49.000000000 +0300
+++ WQ/kernel/power/process.c	2007-02-19 01:04:26.000000000 +0300
@@ -46,8 +46,10 @@ void refrigerator(void)
 	recalc_sigpending(); /* We sent fake signal, clean it up */
 	spin_unlock_irq(&current->sighand->siglock);
 
-	while (frozen(current)) {
-		current->state = TASK_UNINTERRUPTIBLE;
+	for (;;) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		if (!frozen(current))
+			break;
 		schedule();
 	}
 	pr_debug("%s left refrigerator\n", current->comm);

