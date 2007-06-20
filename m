Return-Path: <linux-kernel-owner+w=401wt.eu-S1761298AbXFTCQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761298AbXFTCQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 22:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758638AbXFTCPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 22:15:54 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3699 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758415AbXFTCPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 22:15:54 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 19 Jun 2007 19:15:50 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Oleg Nesterov <oleg@tv-sign.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fix signalfd interaction with thread-private signals
In-Reply-To: <1182302739.22337.9.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0706191908000.16740@alien.or.mcafeemobile.com>
References: <alpine.LFD.0.98.0706162013420.14121@woody.linux-foundation.org>
  <1182064500.2798.6.camel@entropy>  <Pine.LNX.4.64.0706170951580.20841@alien.or.mcafeemobile.com>
  <1182108399.3794.4.camel@entropy>  <Pine.LNX.4.64.0706171436260.20841@alien.or.mcafeemobile.com>
  <1182125303.3794.8.camel@entropy>  <Pine.LNX.4.64.0706171715320.5316@alien.or.mcafeemobile.com>
  <1182127391.26853.207.camel@localhost.localdomain> 
 <alpine.LFD.0.98.0706181011460.14121@woody.linux-foundation.org> 
 <20070619091452.GA94@tv-sign.ru>  <Pine.LNX.4.64.0706191643400.16740@alien.or.mcafeemobile.com>
 <1182302739.22337.9.camel@localhost.localdomain>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007, Benjamin Herrenschmidt wrote:

> On Tue, 2007-06-19 at 16:49 -0700, Davide Libenzi wrote:
> 
> > Actually, I think signalfd is fine as is, with Ben's patch applied. 
> > Signalfd should only fetch shared signals, not specific ones (in any 
> > case).
> 
> The only advantage of that additional patch is that it will allow any
> thread to fetch its own private signals via signalfd, regardless of what
> context is attached to the signalfd in the first place.
> 
> Without the patch (with what's currently in Linus tree), a thread will
> only get its own private signals if it's also the thread that created
> the signalfd (and thus is attached to the signalfd "context").
> 
> I don't mind either way, up to you guys to decide what semantics you
> want.

Ok, why instead don't we go for something like the attached patch?
We exclude sync signals from signalfd, but we don't limit signalfd to 
shared signals. Ie, we should be able to fetch a signal sent with 
sys_tkill() to threads different from "current", that otherwise we would 
not be able to fetch.
Ben, sorry but my memory sucks ... the "notifier" thing was fine in that 
case, no?




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
