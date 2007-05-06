Return-Path: <linux-kernel-owner+w=401wt.eu-S932943AbXEFIwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943AbXEFIwi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 04:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933368AbXEFIwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 04:52:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37740 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932943AbXEFIwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 04:52:37 -0400
Date: Sun, 6 May 2007 10:52:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Esben Nielsen <nielsen.esben@googlemail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>, Mark Lord <lkml@rtr.ca>,
       Zach Carter <linux@zachcarter.com>, buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070506085201.GA5860@elte.hu>
References: <20070501212223.GA29867@elte.hu> <463854F3.3020403@linux.vnet.ibm.com> <20070502100545.GA6857@elte.hu> <46386F2B.9050307@linux.vnet.ibm.com> <20070502111742.GA18132@elte.hu> <Pine.LNX.4.64.0705051016420.12880@frodo.shire> <alpine.LFD.0.98.0705051040420.3819@woody.linux-foundation.org> <20070506082911.GA32644@elte.hu> <20070506083600.GA16043@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070506083600.GA16043@1wt.eu>
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


* Willy Tarreau <w@1wt.eu> wrote:

> Just a hint: while your code here is correct, it is a good practise to 
> check against < 0 instead, so that if for any reason you sometimes 
> forget to cast to signed, the compiler will emit a warning stating 
> that the condition is always false. This would simply become :
> 
> -		if (key < entry->fair_key) {
> +		if ((s64)(key - entry->fair_key) < 0) {

done :-) (Btw., the key is still s64 so the cast is technically 
unnecessary - but now the code would be correct with the key being u64 
too.)

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
+		if ((s64)(key - entry->fair_key) < 0) {
 			link = &parent->rb_left;
 		} else {
 			link = &parent->rb_right;
