Return-Path: <linux-kernel-owner+w=401wt.eu-S1759592AbXFTTOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759592AbXFTTOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 15:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756093AbXFTTO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 15:14:27 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1174 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755852AbXFTTO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 15:14:26 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 20 Jun 2007 12:14:23 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [patch] exclude sync signals from signalfd sets
Message-ID: <Pine.LNX.4.64.0706201209570.6029@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch excludes synchronous signals from being dequeued
by a signalfd. It also re-enable signalfd from fetching signals (that
are not synchronous) sent with sys_tkill() and sys_tgkill(), to the
thread that created the signalfd.
The behaviour of a signalfd will hence be:

- Does not, in any case, fetch synchronous signals

- Does fetch shared signals of the thread group of the thread that
  created the signalfd

- Does fetch private signals sent using sys_tkill() or sys_tgkill(),
  to the thread that created the signalfd



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



---
 fs/signalfd.c   |   10 +++++++++-
 kernel/signal.c |    6 +-----
 2 files changed, 10 insertions(+), 6 deletions(-)

Index: linux-2.6.mod/fs/signalfd.c
===================================================================
--- linux-2.6.mod.orig/fs/signalfd.c	2007-06-19 18:58:15.000000000 -0700
+++ linux-2.6.mod/fs/signalfd.c	2007-06-19 19:02:57.000000000 -0700
@@ -26,6 +26,14 @@
 #include <linux/anon_inodes.h>
 #include <linux/signalfd.h>
 
+/*
+ * Signals that a signalfd should never fetch.
+ */
+#define SIGNALFD_EXCLUDE_MASK (sigmask(SIGILL) | sigmask(SIGKILL) | \
+				       sigmask(SIGSTOP) | sigmask(SIGTRAP) | \
+				       sigmask(SIGFPE) | sigmask(SIGSEGV) | \
+				       sigmask(SIGBUS))
+
 struct signalfd_ctx {
 	struct list_head lnk;
 	wait_queue_head_t wqh;
@@ -320,7 +328,7 @@
 	if (sizemask != sizeof(sigset_t) ||
 	    copy_from_user(&sigmask, user_mask, sizeof(sigmask)))
 		return error = -EINVAL;
-	sigdelsetmask(&sigmask, sigmask(SIGKILL) | sigmask(SIGSTOP));
+	sigdelsetmask(&sigmask, SIGNALFD_EXCLUDE_MASK);
 	signotset(&sigmask);
 
 	if (ufd == -1) {
Index: linux-2.6.mod/kernel/signal.c
===================================================================
--- linux-2.6.mod.orig/kernel/signal.c	2007-06-19 18:55:07.000000000 -0700
+++ linux-2.6.mod/kernel/signal.c	2007-06-19 18:58:43.000000000 -0700
@@ -365,11 +365,7 @@
 {
 	int signr = 0;
 
-	/* We only dequeue private signals from ourselves, we don't let
-	 * signalfd steal them
-	 */
-	if (tsk == current)
-		signr = __dequeue_signal(&tsk->pending, mask, info);
+	signr = __dequeue_signal(&tsk->pending, mask, info);
 	if (!signr) {
 		signr = __dequeue_signal(&tsk->signal->shared_pending,
 					 mask, info);
