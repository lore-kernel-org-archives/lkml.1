Return-Path: <linux-kernel-owner+w=401wt.eu-S932189AbXBWLyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbXBWLyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 06:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932226AbXBWLyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 06:54:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48499 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932189AbXBWLyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 06:54:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 2/7] Freezer: Fix memory ordering in refrigerator
Date: Fri, 23 Feb 2007 11:19:53 +0100
User-Agent: KMail/1.9.5
Cc: paulmck@linux.vnet.ibm.com, ego@in.ibm.com, akpm@osdl.org, mingo@elte.hu,
       vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       Pavel Machek <pavel@ucw.cz>, "Aneesh Kumar" <aneesh.kumar@gmail.com>
References: <200702231116.23607.rjw@sisk.pl>
In-Reply-To: <200702231116.23607.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702231119.55158.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@tv-sign.ru>

refrigerator() can miss a wakeup, "wait event" loop needs a proper memory
ordering.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/process.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6.20-mm2/kernel/power/process.c
===================================================================
--- linux-2.6.20-mm2.orig/kernel/power/process.c
+++ linux-2.6.20-mm2/kernel/power/process.c
@@ -47,8 +47,10 @@ void refrigerator(void)
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

