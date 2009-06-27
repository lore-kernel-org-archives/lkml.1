Return-Path: <linux-kernel-owner+w=401wt.eu-S1754963AbZF0Lke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963AbZF0Lke (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 07:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbZF0Lk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 07:40:27 -0400
Received: from relay3.sgi.com ([192.48.156.57]:34549 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751216AbZF0Lk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 07:40:26 -0400
Date: Sat, 27 Jun 2009 06:40:29 -0500
From: Robin Holt <holt@sgi.com>
To: linux-kernel@vger.kernel.org
Subject: [Patch v2] stop_machine stalls for a considerable period on large
	cpu count machines.
Message-ID: <20090627114029.GC6894@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot again on the repost.

Sorry for the noise,
Robin

----- Forwarded message from Robin Holt <holt@sgi.com> -----

Date: Sat, 27 Jun 2009 06:34:10 -0500
From: Robin Holt <holt@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Travis <travis@sgi.com>, Rusty Russell <rusty@rustcorp.com.au>,
	Stable Kernel Maintainers <stable@kernel.org>
Subject: [Patch v2] stop_machine stalls for a considerable period on large
	cpu count machines.

Mike Travis noted that a 2048 cpu machine booting would take hours
to get through its modprobes.  We would get numerous back traces from
stop_cpu indicating they had not serviced interrupts.

A quick code review indicated we have a situation of heavy cacheline
contention due to the 'state' (read-mostly) and 'thread_ack'
(write-mostly) variables being located in the same cacheline.


Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Stable Kernel Maintainers <stable@kernel.org>
---

My first attempt missed a 'quilt refresh' and did not work.

 kernel/stop_machine.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)


Index: stop_machine_false_sharing/kernel/stop_machine.c
===================================================================
--- stop_machine_false_sharing.orig/kernel/stop_machine.c	2009-06-27 06:30:24.196637521 -0500
+++ stop_machine_false_sharing/kernel/stop_machine.c	2009-06-27 06:30:28.401164425 -0500
@@ -13,6 +13,13 @@
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
 
+/*
+ * It is important to keep 'thread_ack' and 'state' in a seperate
+ * cachelines to prevent cacheline sharing between threads updating
+ * thread_ack and other threads spinning on state.
+ */
+static atomic_t thread_ack	____cacheline_aligned;
+
 /* This controls the threads on each CPU. */
 enum stopmachine_state {
 	/* Dummy starting state for thread. */
@@ -26,7 +33,7 @@ enum stopmachine_state {
 	/* Exit */
 	STOPMACHINE_EXIT,
 };
-static enum stopmachine_state state;
+static enum stopmachine_state state ____cacheline_aligned;
 
 struct stop_machine_data {
 	int (*fn)(void *);
@@ -36,7 +43,6 @@ struct stop_machine_data {
 
 /* Like num_online_cpus(), but hotplug cpu uses us, so we need this. */
 static unsigned int num_threads;
-static atomic_t thread_ack;
 static DEFINE_MUTEX(lock);
 /* setup_lock protects refcount, stop_machine_wq and stop_machine_work. */
 static DEFINE_MUTEX(setup_lock);

----- End forwarded message -----
