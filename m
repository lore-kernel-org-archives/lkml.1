Return-Path: <linux-kernel-owner+w=401wt.eu-S1030196AbXBZKwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030196AbXBZKwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 05:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030201AbXBZKwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 05:52:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59263 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030200AbXBZKwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 05:52:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 3/3] Freezer: Prevent ___call_usermodehelper from missing freezing requests
Date: Mon, 26 Feb 2007 11:52:17 +0100
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
Message-Id: <200702261152.18379.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

NOTE: Alternatively, we can just drop flush_signals() from there, but I'm not
sure that's the right thing to do.

---
From: Rafael J. Wysocki <rjw@sisk.pl>

Since ____call_usermodehelper() calls flush_signals(current), the task that
enters it may miss a freezing request.  However, if ____call_usermodehelper()
clears TIF_FREEZE for the current task after flush_signals(current) returns, the
freezer will generate one more freezing request for this task.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/kmod.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.20-mm2/kernel/kmod.c
===================================================================
--- linux-2.6.20-mm2.orig/kernel/kmod.c	2007-02-25 12:07:15.000000000 +0100
+++ linux-2.6.20-mm2/kernel/kmod.c	2007-02-25 12:49:16.000000000 +0100
@@ -34,6 +34,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/resource.h>
+#include <linux/freezer.h>
 #include <asm/uaccess.h>
 
 extern int delete_module(const char *name, unsigned int flags);
@@ -258,6 +259,7 @@ static int ____call_usermodehelper(void 
 	new_session = key_get(sub_info->ring);
 	flush_signals(current);
 	spin_lock_irq(&current->sighand->siglock);
+	do_not_freeze(current);
 	old_session = __install_session_keyring(current, new_session);
 	flush_signal_handlers(current, 1);
 	sigemptyset(&current->blocked);
