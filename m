Return-Path: <linux-kernel-owner+w=401wt.eu-S936542AbXGQUs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936542AbXGQUs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936355AbXGQUo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:44:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57401 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936220AbXGQUo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:44:58 -0400
Date: Tue, 17 Jul 2007 22:43:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Markus <lists4me@web.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch] CFS scheduler, -v19
Message-ID: <20070717204358.GA12037@elte.hu>
References: <20070706173319.GA2356@elte.hu> <200707171506.37886.lists4me@web.de> <20070717170628.GA6002@elte.hu> <200707172142.42008.lists4me@web.de> <20070717200929.GA2426@elte.hu> <alpine.LFD.0.999.0707171329370.27353@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707171329370.27353@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> But why does that happen? And why would the scheduler have *anything* 
> to do with this? No idea. Maybe timing. Maybe the time.c changes. 
> Dunno.

hm, Markus indicated that he tried the v2.6.21.6-cfsv19 patch, and that 
does not include the time.c change. Markus - does your kernel include 
the code below? (if yes, please revert it via patch -p1 -R )

	Ingo

Index: linux/kernel/time.c
===================================================================
--- linux.orig/kernel/time.c
+++ linux/kernel/time.c
@@ -57,14 +57,17 @@ EXPORT_SYMBOL(sys_tz);
  */
 asmlinkage long sys_time(time_t __user * tloc)
 {
-	time_t i;
-	struct timeval tv;
+	/*
+	 * We read xtime.tv_sec atomically - it's updated
+	 * atomically by update_wall_time(), so no need to
+	 * even read-lock the xtime seqlock:
+	 */
+	time_t i = xtime.tv_sec;
 
-	do_gettimeofday(&tv);
-	i = tv.tv_sec;
+	smp_rmb(); /* sys_time() results are coherent */
 
 	if (tloc) {
-		if (put_user(i,tloc))
+		if (put_user(i, tloc))
 			i = -EFAULT;
 	}
 	return i;
@@ -373,6 +376,20 @@ void do_gettimeofday (struct timeval *tv
 
 	tv->tv_sec = sec;
 	tv->tv_usec = usec;
+
+	/*
+	 * Make sure xtime.tv_sec [returned by sys_time()] always
+	 * follows the gettimeofday() result precisely. This
+	 * condition is extremely unlikely, it can hit at most
+	 * once per second:
+	 */
+	if (unlikely(xtime.tv_sec != tv->tv_sec)) {
+		unsigned long flags;
+
+		write_seqlock_irqsave(&xtime_lock);
+		update_wall_time();
+		write_seqlock_irqrestore(&xtime_lock);
+	}
 }
 
 EXPORT_SYMBOL(do_gettimeofday);
