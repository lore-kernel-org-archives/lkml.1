Return-Path: <linux-kernel-owner+w=401wt.eu-S1754296AbYKDJn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbYKDJn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 04:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbYKDJnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 04:43:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54958 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbYKDJnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 04:43:50 -0500
Date: Tue, 4 Nov 2008 10:43:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: use raw spinlocks instead of spinlocks
Message-ID: <20081104094341.GO23790@elte.hu>
References: <490E3F73.1000405@gmail.com> <alpine.DEB.1.10.0811021940030.32371@gandalf.stny.rr.com> <20081103064647.GA4826@elte.hu> <c62985530811031803o6909518ax137d42189dcff0de@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530811031803o6909518ax137d42189dcff0de@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> 2008/11/3 Ingo Molnar <mingo@elte.hu>:
> > Frederic, do you have trouble finding the source of the deadlock? In
> > theory the NMI watchdog should be able to punch through it. (if not
> > then we need to improve things so that it can)
> 
> Ok...actually I still have a deadlock. Or it seems to. I launch the 
> return tracer and then...the system can block after several seconds, 
> typically after I try to write some characters on the terminal.
> 
> It happens more easily on SMP.
> 
> I enabled all I could for lock debugging, but I don't have any 
> errors printed... Lockdep uses an NMI wachdog?

lockdep works via a completely different principle: it instruments all 
the actual lock acquire/release calls and builds a graph of lock 
dependencies in the system, as it happens.

It also guarantees that all the observed locking rules are followed 
(i.e. it proves that as long as you dont get any messages from 
lockdep, all the locking patterns are mathematically safe).

So a lockdep message will most of the time occur much easier than a 
real lockup would occur - as lockdep only needs to observe 
inconsistent locking patterns to prove that a lockup _could_ occur.

The NMI watchdog just observes the system and complains if it sees 
hardirqs not progressing (i.e. a hard lockup). It will detect anything 
that causes a hard lockup. (assuming that the NMI watchdog itself is 
not locked up)

Regarding your lockup ... it's quite hard. Maybe you can get more 
output out of the system by using:

  earlyprintk=vga,keep

plus disablig regular tty output. (i.e. not passing any 'console=tty' 
line to the kernel bootup.)

this way you wont get any normal printk activities (which might lock 
up), you should only get the very simple early-printk output.

it is also probably useful to mark the early-printk code notrace in 
arch/x86/kernel/Makefile, via the patch below. (i've just applied to 
to tip/x86/debug and pushed it out into tip/master)

... but that's still not a guarantee that you'll be able to debug it 
this way :-/ Bootstrapping something this intrusive and wide is one of 
the hardest kernel development activities possible.

	Ingo

---------------->
>From 6cf87efbc7a3676e0ad7c9622ec6aec244a593bc Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 4 Nov 2008 10:42:23 +0100
Subject: [PATCH] x86 debug: mark early_printk.o as notrace

Impact: do not do function-tracing in the early-printk code

this is useful when earlyprintk=vga,keep is used to debug tracer
plugins.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index e489ff9..943fe60 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -12,6 +12,7 @@ CFLAGS_REMOVE_tsc.o = -pg
 CFLAGS_REMOVE_rtc.o = -pg
 CFLAGS_REMOVE_paravirt-spinlocks.o = -pg
 CFLAGS_REMOVE_ftrace.o = -pg
+CFLAGS_REMOVE_early_printk.o = -pg
 endif
 
 #
