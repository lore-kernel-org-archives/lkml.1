Return-Path: <linux-kernel-owner+w=401wt.eu-S965210AbXCAPSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965210AbXCAPSE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 10:18:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965238AbXCAPRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 10:17:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48047 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965227AbXCAPRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 10:17:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@osdl.org>
Subject: [PATCH -mm 4/7] Freezer: Remove PF_NOFREEZE from bluetooth threads
Date: Thu, 1 Mar 2007 16:10:58 +0100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Aneesh Kumar <aneesh.kumar@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
References: <200702260800.49603.rjw@sisk.pl> <200703011605.46692.rjw@sisk.pl>
In-Reply-To: <200703011605.46692.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703011610.59238.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Remove PF_NOFREEZE from the bluetooth threads, adding try_to_freeze() calls as
required.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 net/bluetooth/bnep/core.c   |    4 +++-
 net/bluetooth/cmtp/core.c   |    4 +++-
 net/bluetooth/hidp/core.c   |    4 +++-
 net/bluetooth/rfcomm/core.c |    4 +++-
 4 files changed, 12 insertions(+), 4 deletions(-)

Index: linux-2.6.20-mm2/net/bluetooth/bnep/core.c
===================================================================
--- linux-2.6.20-mm2.orig/net/bluetooth/bnep/core.c	2007-02-25 12:07:15.000000000 +0100
+++ linux-2.6.20-mm2/net/bluetooth/bnep/core.c	2007-02-25 12:49:27.000000000 +0100
@@ -39,6 +39,7 @@
 #include <linux/errno.h>
 #include <linux/smp_lock.h>
 #include <linux/net.h>
+#include <linux/freezer.h>
 #include <net/sock.h>
 
 #include <linux/socket.h>
@@ -473,11 +474,12 @@ static int bnep_session(void *arg)
 
 	daemonize("kbnepd %s", dev->name);
 	set_user_nice(current, -15);
-	current->flags |= PF_NOFREEZE;
 
 	init_waitqueue_entry(&wait, current);
 	add_wait_queue(sk->sk_sleep, &wait);
 	while (!atomic_read(&s->killed)) {
+		try_to_freeze();
+
 		set_current_state(TASK_INTERRUPTIBLE);
 
 		// RX
Index: linux-2.6.20-mm2/net/bluetooth/cmtp/core.c
===================================================================
--- linux-2.6.20-mm2.orig/net/bluetooth/cmtp/core.c	2007-02-25 12:07:15.000000000 +0100
+++ linux-2.6.20-mm2/net/bluetooth/cmtp/core.c	2007-02-25 12:49:27.000000000 +0100
@@ -34,6 +34,7 @@
 #include <linux/ioctl.h>
 #include <linux/file.h>
 #include <linux/init.h>
+#include <linux/freezer.h>
 #include <net/sock.h>
 
 #include <linux/isdn/capilli.h>
@@ -287,11 +288,12 @@ static int cmtp_session(void *arg)
 
 	daemonize("kcmtpd_ctr_%d", session->num);
 	set_user_nice(current, -15);
-	current->flags |= PF_NOFREEZE;
 
 	init_waitqueue_entry(&wait, current);
 	add_wait_queue(sk->sk_sleep, &wait);
 	while (!atomic_read(&session->terminate)) {
+		try_to_freeze();
+
 		set_current_state(TASK_INTERRUPTIBLE);
 
 		if (sk->sk_state != BT_CONNECTED)
Index: linux-2.6.20-mm2/net/bluetooth/hidp/core.c
===================================================================
--- linux-2.6.20-mm2.orig/net/bluetooth/hidp/core.c	2007-02-25 12:07:15.000000000 +0100
+++ linux-2.6.20-mm2/net/bluetooth/hidp/core.c	2007-02-25 12:49:27.000000000 +0100
@@ -35,6 +35,7 @@
 #include <linux/file.h>
 #include <linux/init.h>
 #include <linux/wait.h>
+#include <linux/freezer.h>
 #include <net/sock.h>
 
 #include <linux/input.h>
@@ -547,13 +548,14 @@ static int hidp_session(void *arg)
 
 	daemonize("khidpd_%04x%04x", vendor, product);
 	set_user_nice(current, -15);
-	current->flags |= PF_NOFREEZE;
 
 	init_waitqueue_entry(&ctrl_wait, current);
 	init_waitqueue_entry(&intr_wait, current);
 	add_wait_queue(ctrl_sk->sk_sleep, &ctrl_wait);
 	add_wait_queue(intr_sk->sk_sleep, &intr_wait);
 	while (!atomic_read(&session->terminate)) {
+		try_to_freeze();
+
 		set_current_state(TASK_INTERRUPTIBLE);
 
 		if (ctrl_sk->sk_state != BT_CONNECTED || intr_sk->sk_state != BT_CONNECTED)
Index: linux-2.6.20-mm2/net/bluetooth/rfcomm/core.c
===================================================================
--- linux-2.6.20-mm2.orig/net/bluetooth/rfcomm/core.c	2007-02-25 12:07:15.000000000 +0100
+++ linux-2.6.20-mm2/net/bluetooth/rfcomm/core.c	2007-02-25 12:49:27.000000000 +0100
@@ -37,6 +37,7 @@
 #include <linux/device.h>
 #include <linux/net.h>
 #include <linux/mutex.h>
+#include <linux/freezer.h>
 
 #include <net/sock.h>
 #include <asm/uaccess.h>
@@ -1851,6 +1852,8 @@ static void rfcomm_worker(void)
 	BT_DBG("");
 
 	while (!atomic_read(&terminate)) {
+		try_to_freeze();
+
 		if (!test_bit(RFCOMM_SCHED_WAKEUP, &rfcomm_event)) {
 			/* No pending events. Let's sleep.
 			 * Incoming connections and data will wake us up. */
@@ -1937,7 +1940,6 @@ static int rfcomm_run(void *unused)
 
 	daemonize("krfcommd");
 	set_user_nice(current, -10);
-	current->flags |= PF_NOFREEZE;
 
 	BT_DBG("");
 

