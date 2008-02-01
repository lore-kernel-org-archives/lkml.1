Return-Path: <linux-kernel-owner+w=401wt.eu-S1760447AbYBAWtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760447AbYBAWtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 17:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbYBAWtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 17:49:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46974 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757576AbYBAWtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 17:49:31 -0500
Date: Fri, 1 Feb 2008 23:48:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Steven Rostedt <srostedt@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Regression] 2.6.24-git3: Major annoyance during
	suspend/hibernation on x86-64 (bisected)
Message-ID: <20080201224852.GA16700@elte.hu>
References: <200801272229.48955.rjw@sisk.pl> <200801280226.22013.rjw@sisk.pl> <1201795128.32654.22.camel@lappy> <200801312154.33754.rjw@sisk.pl> <1201867497.32654.49.camel@lappy> <b647ffbd0802010711q744f5023mdbfccd9540556b70@mail.gmail.com> <20080201171022.GC2159@elte.hu> <b647ffbd0802011354ra2b9494ub59475abad4466aa@mail.gmail.com> <b647ffbd0802011444n366c1537m7fb44acf0b848941@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0802011444n366c1537m7fb44acf0b848941@mail.gmail.com>
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


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> > I've observed delays from ~3 s. up to ~8 s. (out of ~20 tests) so 
> > the 10s. delay of msleep_interruptible() might be related but I'm 
> > still looking for the reason why this fix helps (and what goes wrong 
> > with the current code).
> 
> heh... it's pretty obvious indeed. What's msleep_interruptible() is 
> all about? :-)
> 
> "sleep waiting for signals"
> 
> so the 'watchdog' thread gets woken up
> 
> [ as a result of cpu_callback(action = CPU_DEAD) --> kthread_stop() ]
> 
> just to be immediately scheduled out again for as long as the
> remaining timeout > 0.
> 
> So it should work if we substitute msleep_interruptible() with 
> schedule_timeout_interruptible().

Doh. Could someone with ths problem please test the patch below, does it 
do the trick?

	Ingo

---
 kernel/softlockup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/kernel/softlockup.c
===================================================================
--- linux.orig/kernel/softlockup.c
+++ linux/kernel/softlockup.c
@@ -228,7 +228,7 @@ static int watchdog(void *__bind_cpu)
 	 */
 	while (!kthread_should_stop()) {
 		touch_softlockup_watchdog();
-		msleep_interruptible(10000);
+		schedule_timeout_interruptible(10*HZ);
 
 		if (this_cpu != check_cpu)
 			continue;
