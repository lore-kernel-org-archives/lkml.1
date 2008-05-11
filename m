Return-Path: <linux-kernel-owner+w=401wt.eu-S1757130AbYEKNy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbYEKNy5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 09:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbYEKNyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 09:54:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46445 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843AbYEKNyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 09:54:37 -0400
Date: Sun, 11 May 2008 15:54:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Sven Wegener <sven.wegener@stealer.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] scheduler fixes
Message-ID: <20080511135414.GA2328@elte.hu>
References: <alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org> <20080508120130.GA2860@elte.hu> <20080508122802.GA4880@elte.hu> <20080508144316.GA9869@elte.hu> <20080508151028.GA12109@elte.hu> <20080511110306.GP19219@parisc-linux.org> <20080511114803.GA8289@parisc-linux.org> <20080511125049.GA22513@elte.hu> <20080511125216.GA25040@elte.hu> <20080511130226.GR19219@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511130226.GR19219@parisc-linux.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Wilcox <matthew@wil.cx> wrote:

> > +	/*
> > +	 * Rotate sleepers - to make sure all of them get woken in case
> > +	 * of parallel up()s:
> > +	 */
> > +	list_move_tail(&waiter->list, &sem->wait_list);
> 
> Seems like extra cache line dirtying for no real gain over my 
> solution.

the gain is rather obvious: two parallel up()s (or just up()s which come 
close enough after each other) will wake up two tasks in parallel. With 
your patch, the first guy wakes up and then it wakes up the second guy. 
I.e. your patch serializes the wakeup chain, mine keeps it parallel.

the cache line dirtying is rather secondary to any solution - the first 
goal for any locking primitive is to get scheduling precise: to not wake 
up more tasks than optimal and to not wake up less tasks than optimal.

i.e. can you see any conceptual hole in the patch below?

	Ingo

---
 kernel/semaphore.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux/kernel/semaphore.c
===================================================================
--- linux.orig/kernel/semaphore.c
+++ linux/kernel/semaphore.c
@@ -258,5 +258,11 @@ static noinline void __sched __up(struct
 {
 	struct semaphore_waiter *waiter = list_first_entry(&sem->wait_list,
 						struct semaphore_waiter, list);
+	/*
+	 * Rotate sleepers - to make sure all of them get woken in case
+	 * of parallel up()s:
+	 */
+	list_move_tail(&waiter->list, &sem->wait_list);
+
 	wake_up_process(waiter->task);
 }
