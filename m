Return-Path: <linux-kernel-owner+w=401wt.eu-S937882AbXFHFah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937882AbXFHFah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 01:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755902AbXFHFaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 01:30:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:51594 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754778AbXFHFa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 01:30:29 -0400
Subject: Re: [BUG] ptraced process waiting on syscall may return kernel
	internal errnos
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <alpine.LFD.0.98.0706072015520.4205@woody.linux-foundation.org>
References: <20070606105900.DE5E94D0592@magilla.localdomain>
	 <alpine.LFD.0.98.0706060811470.4205@woody.linux-foundation.org>
	 <87sl949eyx.wl%takeuchi_satoru@jp.fujitsu.com>
	 <alpine.LFD.0.98.0706070852390.4205@woody.linux-foundation.org>
	 <1181255068.14818.77.camel@localhost.localdomain>
	 <alpine.LFD.0.98.0706072015520.4205@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 15:30:02 +1000
Message-Id: <1181280602.14818.112.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-07 at 20:18 -0700, Linus Torvalds wrote:
> 
> > Oh and Roland patch doesn't prevent signalfd() from stealing synchronous
> > signals such as SIGSEGV etc... which I think would result in random
> > behaviour.... do you want a patch for that or we just consider it broken
> > API usage and let it as it is ?
> 
> I think Davide ack'ed your patch, but I also think that one clashes with 
> the one I actually ended up applying. If you were to send me the signalfd 
> part (tested, preferably), I'd apply it, considering that it seems to be 
> the right thign to do, and it already got acked by Davide. 

Well, it's less urgent imho now that the real problems are fixed but
here it is, totally untested patch :-)
---

Don't let signalfd dequeue private signals off other threads

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Index: linux-work/kernel/signal.c
===================================================================
--- linux-work.orig/kernel/signal.c	2007-06-08 15:28:00.000000000 +1000
+++ linux-work/kernel/signal.c	2007-06-08 15:28:44.000000000 +1000
@@ -363,7 +363,13 @@ static int __dequeue_signal(struct sigpe
  */
 int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 {
-	int signr = __dequeue_signal(&tsk->pending, mask, info);
+	int signr = 0;
+
+	/* We only dequeue private signals from ourselves, we don't let
+	 * signalfd steal them
+	 */
+	if (tsk == current)
+		signr = __dequeue_signal(&tsk->pending, mask, info);
 	if (!signr) {
 		signr = __dequeue_signal(&tsk->signal->shared_pending,
 					 mask, info);


