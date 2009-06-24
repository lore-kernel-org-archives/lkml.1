Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497AbZFXNOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbZFXNOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 09:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbZFXNOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 09:14:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44562 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbZFXNOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 09:14:01 -0400
Date: Wed, 24 Jun 2009 15:13:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Frysinger <vapier.adi@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: PREEMPT_ACTIVE too low error with all asm-generic headers for
	some arches
Message-ID: <20090624131357.GA6224@elte.hu>
References: <8bd0f97a0906231508s4c115d3dr2848626bc5a28c5e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0906231508s4c115d3dr2848626bc5a28c5e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Frysinger <vapier.adi@gmail.com> wrote:

> after pulling the latest mainline code, Blackfin started hitting a
> build failure like so:
>   CC      arch/blackfin/kernel/asm-offsets.s
> In file included from include/linux/interrupt.h:12,
>                  from include/linux/kernel_stat.h:8,
>                  from arch/blackfin/kernel/asm-offsets.c:32:
> include/linux/hardirq.h:66:2: error: #error PREEMPT_ACTIVE is too low!
> make[1]: *** [arch/blackfin/kernel/asm-offsets.s] Error 1
> 
> this is because we've converted to asm-generic for most of our headers
> (including hardirq.h).  originally we were defining HARDIRQ_BITS
> ourselves to 8, but then we dropped that in favor of the
> asm-generic/hardirq.h which setup a default of 8.  but then they
> dropped it in favor of the linux/hardirq.h default handling ... but it
> sets it to MAX_HARDIRQ_BITS by default which is 10.  which pushes
> Blackfin over the edge and into this build error.

hm, you wrote this mail to me but i havent touched asm-generic nor 
blackfin in this cycle. The breakage appears to have been caused by 
or at around this commit:

>From 804387a1af87f66a4b93eee230ba98f8b906b088 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Sun, 14 Jun 2009 22:38:11 +0200
Subject: [PATCH] asm-generic: drop HARDIRQ_BITS definition from hardirq.h

[...]

Reported-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>

So i've Cc:-ed those folks too.

> if we look at linux/hardirq.h, it makes this claim:
>  * - bit 28 is the PREEMPT_ACTIVE flag
> if that's true, then why are we letting any arch set this define ?  a
> quick survey shows that half the arches (11) are using 0x10000000 (bit
> 28) while the other half (10) are using 0x4000000 (bit 26).  and then
> there is the ia64 oddity which uses bit 30.  the exact value here
> shouldnt really matter across arches though should it ?

Correct - what matters is to have no collision between the fields.

> how about adding this to linux/thread_info.h:
> #ifndef PREEMPT_ACTIVE
> # ifndef PREEMPT_ACTIVE_BIT
> #  define PREEMPT_ACTIVE_BIT 28
> # endif
> # define PREEMPT_ACTIVE (1 << PREEMPT_ACTIVE_BIT)
> #endif

Makes sense i guess - but do we really need that level of
#ifdef nesting? PREEMPT_ACTIVE_BIT should be the main control - with
a default to 28 if it's not set. PREEMPT_ACTIVE is then derived off 
that, without any #ifdefs.

Anyway ... no objections from me in this area (and your build is 
broken so i suspect you want a fix quickly), just please make the 
override clean. Btw., why cannot blackfin use the defaults?

	Ingo
