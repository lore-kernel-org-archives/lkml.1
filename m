Return-Path: <linux-kernel-owner+w=401wt.eu-S1751167AbXAXLFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167AbXAXLFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 06:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbXAXLFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 06:05:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33387 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbXAXLFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 06:05:44 -0500
Date: Wed, 24 Jan 2007 12:04:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch 00/46] High resolution timer / dynamic tick update
Message-ID: <20070124110415.GA2339@elte.hu>
References: <20070123211159.178138000@localhost.localdomain> <1169604991.19471.95.camel@imap.mvista.com> <20070124070701.GA17654@elte.hu> <1169631016.19471.175.camel@imap.mvista.com> <20070124095157.GA21346@elte.hu> <1169634220.19471.197.camel@imap.mvista.com> <20070124102902.GA28025@elte.hu> <1169635984.19471.201.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1169635984.19471.201.camel@imap.mvista.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -3.7
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-3.7 required=5.9 tests=ALL_TRUSTED,BAYES_05 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-0.4 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0313]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> > > > > If stability is a question, -rt10 does currently compile for 
> > > > > my test config, due to this new HRT introduction. [...]
[...]

NOTE: the build problem you have is -rt specific. In any case it is not 
due to this new HRT introduction but due to another, -rt only feature or 
high-res timers: the ability to asynchronously wait on their completion 
without polling. But that does not matter to -mm kernels.

I have put your .config into the new -mm queue Thomas submitted and it 
compiled and booted just fine.

> > > No, the test config I was talking about is SMP i386 (which is what 
> > > I usually use). [...]
> > 
> > then please send me the .config.
> 
> Sure.

please check whether the patch below (ontop of -rt10) fixes this for 
you.

	Ingo

Index: linux/kernel/hrtimer.c
===================================================================
--- linux.orig/kernel/hrtimer.c
+++ linux/kernel/hrtimer.c
@@ -992,8 +994,6 @@ int hrtimer_get_res(const clockid_t whic
 }
 EXPORT_SYMBOL_GPL(hrtimer_get_res);
 
-#ifdef CONFIG_HIGH_RES_TIMERS
-
 #ifdef CONFIG_PREEMPT_SOFTIRQS
 # define wake_up_timer_waiters(b)	wake_up(&(b)->wait)
 
@@ -1020,6 +1020,8 @@ void hrtimer_wait_for_timer(const struct
 # define wake_up_timer_waiters(b)	do { } while (0)
 #endif
 
+#ifdef CONFIG_HIGH_RES_TIMERS
+
 /*
  * High resolution timer interrupt
  * Called with interrupts disabled
