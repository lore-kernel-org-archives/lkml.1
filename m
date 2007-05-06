Return-Path: <linux-kernel-owner+w=401wt.eu-S1753656AbXEFIaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbXEFIaF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 04:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbXEFIaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 04:30:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35773 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656AbXEFIaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 04:30:01 -0400
Date: Sun, 6 May 2007 10:29:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Esben Nielsen <nielsen.esben@googlemail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070506082911.GA32644@elte.hu>
References: <20070501212223.GA29867@elte.hu> <463854F3.3020403@linux.vnet.ibm.com> <20070502100545.GA6857@elte.hu> <46386F2B.9050307@linux.vnet.ibm.com> <20070502111742.GA18132@elte.hu> <Pine.LNX.4.64.0705051016420.12880@frodo.shire> <alpine.LFD.0.98.0705051040420.3819@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705051040420.3819@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So the _only_ valid way to handle timers is to
>  - either not allow wrapping at all (in which case "unsigned" is better, 
>    since it is bigger)
>  - or use wrapping explicitly, and use unsigned arithmetic (which is 
>    well-defined in C) and do something like "(long)(a-b) > 0".

hm, there is a corner-case in CFS where a fix like this is necessary.

CFS uses 64-bit values for almost everything, and the majority of values 
are of 'relative' nature with no danger of overflow. (They are signed 
because they are relative values that center around zero and can be 
negative or positive.)

there is one value that is of 'absolute' nature though: the 'fair clock' 
(which is the same as the normal system clock when load is 1.0, and it 
slows down in a load-proportional way as load increases), which has 
units of nanoseconds - and the 'keys' in the rbtree are derived from 
such clock values. That particular clock could produce an s64 overflow 
at around 292 years after bootup (a bit later if the system is also used 
for something in that timeframe). While i dont think that's realistic to 
worry about, the fix below should solve that theoretical problem too.

	Ingo

Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -60,7 +60,7 @@ static inline void __enqueue_task_fair(s
 		 * We dont care about collisions. Nodes with
 		 * the same key stay together.
 		 */
-		if (key < entry->fair_key) {
+		if ((s64)(entry->fair_key - key) > 0) {
 			link = &parent->rb_left;
 		} else {
 			link = &parent->rb_right;
