Return-Path: <linux-kernel-owner+w=401wt.eu-S1752038AbZIQWiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbZIQWiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 18:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750812AbZIQWiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 18:38:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741AbZIQWiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 18:38:20 -0400
Date: Thu, 17 Sep 2009 15:38:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: john stultz <johnstul@us.ibm.com>
Cc: rth@twiddle.net, ink@jurassic.park.msu.ru, linux-kernel@vger.kernel.org,
       linux-alpha@vger.kernel.org
Subject: Re: [RESEND] [PATCH] Convert alpha to use arch_gettimeoffset()
Message-Id: <20090917153801.894f4108.akpm@linux-foundation.org>
In-Reply-To: <1247789647.7398.5.camel@localhost.localdomain>
References: <1247789647.7398.5.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009 17:14:07 -0700
john stultz <johnstul@us.ibm.com> wrote:

> This patch converts alpha to use GENERIC_TIME via the arch_getoffset()
> infrastructure, reducing the amount of arch specific code we need to
> maintain.
> 
> I suspect the alpha arch could even be further improved to provide and
> rpcc() based clocksource, but not having the hardware, I don't feel
> comfortable attempting the more complicated conversion (but I'd be glad
> to help if anyone else is interested).
> 
> This patch applies on top of Linus' current -git tree (2.6.31-rc3).
> 
> I've taken my best swing at converting this, but I'm not 100% confident
> I got it right. My cross-compiler is now too old, so I couldn't check if
> it builds. So any assistance from arch maintainers or testers to get
> this merged would be great.
> 

It breaks the build:

cc1: warnings being treated as errors
arch/alpha/kernel/time.c: In function 'arch_gettimeoffset':
arch/alpha/kernel/time.c:413: warning: unused variable 'partial_tick'
arch/alpha/kernel/time.c:413: warning: unused variable 'delta_cycles'
make[1]: *** [arch/alpha/kernel/time.o] Error 1


u32 arch_gettimeoffset(void)
{
	unsigned long delta_cycles, delta_usec, partial_tick;

#ifdef CONFIG_SMP
	/* Until and unless we figure out how to get cpu cycle counters
	   in sync and keep them there, we can't use the rpcc tricks.  */
	delta_usec = 0;
#else
	delta_cycles = rpcc() - state.last_time;
	partial_tick = state.partial_tick;
	/*
	 * usec = cycles * ticks_per_cycle * 2**48 * 1e6 / (2**48 * ticks)
	 *	= cycles * (s_t_p_c) * 1e6 / (2**48 * ticks)
	 *	= cycles * (s_t_p_c) * 15625 / (2**42 * ticks)
	 *
	 * which, given a 600MHz cycle and a 1024Hz tick, has a
	 * dynamic range of about 1.7e17, which is less than the
	 * 1.8e19 in an unsigned long, so we are safe from overflow.
	 *
	 * Round, but with .5 up always, since .5 to even is harder
	 * with no clear gain.
	 */

	delta_usec = (delta_cycles * state.scaled_ticks_per_cycle 
		      + partial_tick) * 15625;
	delta_usec = ((delta_usec / ((1UL << (FIX_SHIFT-6-1)) * HZ)) + 1) / 2;
#endif

	return delta_usec * 1000;
}

I converted the CONFIG_SMP=y case into a plain old `return 0;'.  Which
means that we could turn the CONFIG_SMP=y case into a static inline,
really.

From: Andrew Morton <akpm@linux-foundation.org>

cc1: warnings being treated as errors
arch/alpha/kernel/time.c: In function 'arch_gettimeoffset':
arch/alpha/kernel/time.c:413: warning: unused variable 'partial_tick'
arch/alpha/kernel/time.c:413: warning: unused variable 'delta_cycles'
make[1]: *** [arch/alpha/kernel/time.o] Error 1

Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/time.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/arch/alpha/kernel/time.c~alpha-convert-to-use-arch_gettimeoffset-fix
+++ a/arch/alpha/kernel/time.c
@@ -410,13 +410,13 @@ time_init(void)
  */
 u32 arch_gettimeoffset(void)
 {
-	unsigned long delta_cycles, delta_usec, partial_tick;
-
 #ifdef CONFIG_SMP
 	/* Until and unless we figure out how to get cpu cycle counters
 	   in sync and keep them there, we can't use the rpcc tricks.  */
-	delta_usec = 0;
+	return 0;
 #else
+	unsigned long delta_cycles, delta_usec, partial_tick;
+
 	delta_cycles = rpcc() - state.last_time;
 	partial_tick = state.partial_tick;
 	/*
@@ -435,9 +435,8 @@ u32 arch_gettimeoffset(void)
 	delta_usec = (delta_cycles * state.scaled_ticks_per_cycle 
 		      + partial_tick) * 15625;
 	delta_usec = ((delta_usec / ((1UL << (FIX_SHIFT-6-1)) * HZ)) + 1) / 2;
-#endif
-
 	return delta_usec * 1000;
+#endif
 }
 
 /*
_

