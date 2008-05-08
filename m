Return-Path: <linux-kernel-owner+w=401wt.eu-S1765653AbYEHVAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765653AbYEHVAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 17:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbYEHVAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 17:00:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:42054 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897AbYEHVAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 17:00:17 -0400
In-Reply-To: <48231959.4050406@goop.org>
References: <fa.QTbvQYXhEm5VNP5dvkl5JG7NHYQ@ifi.uio.no> <481DF3D8.3010108@shaw.ca> <a6dd201e0149f8dbdf10a7a194673833@kernel.crashing.org> <48217674.8080903@goop.org> <48231959.4050406@goop.org>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <e2d8bb81dc41cc3965a6ccba143f7cfa@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Christian Kujau <lists@nerdbynature.de>,
       Robert Hancock <hancockr@shaw.ca>, john stultz <johnstul@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH] common implementation of iterative div/mod
Date: Thu, 8 May 2008 22:52:12 +0200
To: Jeremy Fitzhardinge <jeremy@goop.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We have a few instances of the open-coded iterative div/mod loop, used
> when we don't expcet the dividend to be much bigger than the divisor.
> Unfortunately modern gcc's have the tendency to strength "reduce" this
> into a full mod operation, which isn't necessarily any faster, and
> even if it were, doesn't exist if gcc implements it in libgcc.
>
> The workaround is to put a dummy asm statement in the loop to prevent
> gcc from performing the transformation.

It's not a "dummy" asm, it actually does something: it tells the
compiler that it has to iterate the loop exactly as written, and
not do something else.  I.e., exactly the behaviour we want here.

> +	ticks = iter_div_u64_rem(blocked, NS_PER_TICK, &blocked);

What a terrible function name.

> static inline void timespec_add_ns(struct timespec *a, u64 ns)
> {
> -	ns += a->tv_nsec;
> -	while(unlikely(ns >= NSEC_PER_SEC)) {
> -		/* The following asm() prevents the compiler from
> -		 * optimising this loop into a modulo operation.  */
> -		asm("" : "+r"(ns));
> -
> -		ns -= NSEC_PER_SEC;
> -		a->tv_sec++;
> -	}
> +	a->tv_sec += iter_div_u64_rem(a->tv_nsec + ns, NSEC_PER_SEC, &ns);
> 	a->tv_nsec = ns;
> }

...and now the "meat" of this function isn't inline anymore.  If we
cared about not doing a divide here, you'll have to explain why
taking this trivial loop out of line is a good idea.

> +unsigned iter_div_u64_rem(u64 dividend, u32 divisor, u64 *remainder)
> +{
> +	unsigned ret = 0;
> +
> +	while(dividend >= divisor) {

You removed the unlikely() here.  Why?

> +		/* The following asm() prevents the compiler from
> +		   optimising this loop into a modulo operation.  */
> +		asm("" : "+rm"(dividend));

You changed "+r" to "+rm" here.  Why?  Also, "rm" is an x86-ism,
and this is generic code (it does work here, but why is it better
than "r"?)

> +EXPORT_SYMBOL(iter_div_u64_rem);

Does this need to be exported?


Can I suggest an alternative approach?  Define a macro (with a
good, descriptive name!) for just the asm("" : "+r"(x)), and use
that.  Much smaller patch, much clearer code, and doesn't result
in different (and worse) code generation, so it's a much safer
change.


Segher

