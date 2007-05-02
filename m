Return-Path: <linux-kernel-owner+w=401wt.eu-S2992891AbXEBIDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992891AbXEBIDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 04:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992893AbXEBIDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 04:03:44 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:42116 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992891AbXEBIDj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 04:03:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=LmDIlzDjse07b5Gnfk7rhQHBZA8RbUnrFaCNpKqs/czyva4vy8JNGG7r1n3HLEXMKTtJKngToeggK9xpva1lDqZxtfJILB5kMfbbuNpMoVnfv2Ry3TCt4De2Ym6wIDVxqDzPf+UsUM1uXHXHuKM2zdIzlXzFvOrjh9GZKQWO6Xc=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Mike Galbraith <efault@gmx.de>
Subject: Re: [patch] CFS scheduler, -v8
Date: Wed, 2 May 2007 04:03:35 -0400
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Mark Lord <lkml@rtr.ca>,
       Zach Carter <linux@zachcarter.com>, buddabrod <buddabrod@gmail.com>,
       Balbir Singh <balbir@in.ibm.com>
References: <20070501212223.GA29867@elte.hu> <1178087834.8640.7.camel@Homer.simpson.net>
In-Reply-To: <1178087834.8640.7.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-7"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705020403.35385.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 May 2007, Mike Galbraith wrote:
>On Tue, 2007-05-01 at 23:22 +0200, Ingo Molnar wrote:
>> i'm pleased to announce release -v8 of the CFS scheduler patchset. (The
>> main goal of CFS is to implement "desktop scheduling" with as high
>> quality as technically possible.)
>
>...
>
>> As usual, any sort of feedback, bugreport, fix and suggestion is more
>> than welcome,
>
>Greetings,
>
>I noticed a (harmless) bounds warning triggered by the reduction in size
>of array->bitmap.  Patchlet below.
>
>	-Mike

I just checked my logs, and it appears my workload didn't trigger this one 
Mike.  And so far, v8 is working great here.  And that great is in my 
best "Tony the Tiger" voice, stolen shamelessly from the breakfast cereal tv  
commercial of 30+ years ago. :)

Ingo asked for a 0-100 rating, where 0 is mainline as I recall it, and 100 is 
the best of the breed.  I'll give this one a 100 till something better shows 
up.

>  CC      kernel/sched.o
>kernel/sched_rt.c: In function ¡load_balance_start_rt¢:
>include/asm-generic/bitops/sched.h:30: warning: array subscript is above
> array bounds kernel/sched_rt.c: In function ¡pick_next_task_rt¢:
>include/asm-generic/bitops/sched.h:30: warning: array subscript is above
> array bounds
>
>--- linux-2.6.21-cfs.v8/include/asm-generic/bitops/sched.h.org	2007-05-02
> 07:16:47.000000000 +0200 +++
> linux-2.6.21-cfs.v8/include/asm-generic/bitops/sched.h	2007-05-02
> 07:20:45.000000000 +0200 @@ -6,28 +6,23 @@
>
> /*
>  * Every architecture must define this function. It's the fastest
>- * way of searching a 140-bit bitmap where the first 100 bits are
>- * unlikely to be set. It's guaranteed that at least one of the 140
>- * bits is cleared.
>+ * way of searching a 100-bit bitmap.  It's guaranteed that at least
>+ * one of the 100 bits is cleared.
>  */
> static inline int sched_find_first_bit(const unsigned long *b)
> {
> #if BITS_PER_LONG == 64
>-	if (unlikely(b[0]))
>+	if (b[0])
> 		return __ffs(b[0]);
>-	if (likely(b[1]))
>-		return __ffs(b[1]) + 64;
>-	return __ffs(b[2]) + 128;
>+	return __ffs(b[1]) + 64;
> #elif BITS_PER_LONG == 32
>-	if (unlikely(b[0]))
>+	if (b[0])
> 		return __ffs(b[0]);
>-	if (unlikely(b[1]))
>+	if (b[1])
> 		return __ffs(b[1]) + 32;
>-	if (unlikely(b[2]))
>+	if (b[2])
> 		return __ffs(b[2]) + 64;
>-	if (b[3])
>-		return __ffs(b[3]) + 96;
>-	return __ffs(b[4]) + 128;
>+	return __ffs(b[3]) + 96;
> #else
> #error BITS_PER_LONG not defined
> #endif



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
I met my latest girl friend in a department store.  She was looking at
clothes, and I was putting Slinkys on the escalators.
		-- Steven Wright
