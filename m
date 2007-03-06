Return-Path: <linux-kernel-owner+w=401wt.eu-S965936AbXCFQtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965936AbXCFQtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 11:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965920AbXCFQtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 11:49:49 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47028 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965309AbXCFQts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 11:49:48 -0500
Date: Tue, 6 Mar 2007 08:44:43 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Emil Karlson <jkarlson@cc.hut.fi>, Soeren Sonnenburg <kernel@nn7.de>,
       Len Brown <lenb@kernel.org>
Subject: Re: [5/6] 2.6.21-rc2: known regressions
In-Reply-To: <20070306113225.GA22561@elte.hu>
Message-ID: <Pine.LNX.4.64.0703060817060.5963@woody.linux-foundation.org>
References: <20070305015040.GJ3441@stusta.de> <1173138193.24738.236.camel@localhost.localdomain>
 <Pine.LNX.4.64.0703051542030.3998@woody.linux-foundation.org>
 <Pine.LNX.4.64.0703051626490.3998@woody.linux-foundation.org>
 <1173142948.24738.257.camel@localhost.localdomain>
 <Pine.LNX.4.64.0703051730230.3998@woody.linux-foundation.org>
 <Pine.LNX.4.64.0703051810030.3998@woody.linux-foundation.org>
 <20070306103315.GA4295@mellanox.co.il> <20070306103712.GA10942@elte.hu>
 <20070306104618.GA5792@mellanox.co.il> <20070306113225.GA22561@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is just a coding style thing, but I thought I should really point it 
out, because these kinds of things quite often result in nasty bugs simply 
because the source code is so hard to read properly:

On Tue, 6 Mar 2007, Ingo Molnar wrote:
>
> -static void hrtimer_switch_to_hres(void)
> +static int hrtimer_switch_to_hres(void)

Ok, so here's the quiz: does this function return "true on success, false 
on failure", or does it return "zero on success, negative on failure"?

>  	if (base->hres_active)
> -		return;
> +		return 1;

Ahh, it must be "true on success", right?

>  	local_irq_save(flags);
>  
>  	if (tick_init_highres()) {
>  		local_irq_restore(flags);
> -		return;
> +		return 0;

Ohh-oh! This is clearly a failure schenario! And indeed, 
"tick_init_highres()" will do the "negative on failure, zero on success" 
thing.

BUT! That means that you're testing the return value WRONG!

A function that returns a negative error value should be tested with

	if (tick_init_highres() < 0) {
		local_irq_restore(flags);
		return 0;
	}

because now you *see* that it's a failure.

So here's the coding style:

 - "true on success, false on failure" should be tested by just doing the 
   implicit test against zero (because that's how C booleans work!)

   Example:

	if (everything_is_done())
		return;

   Or:

	if (!something_worked_ok()) {
		printk("Aiee! Bug!\n");
		return;
	}

 - "negative error values" should preferably always be tested as such

	if (tick_init_highres() < 0) {
		printk("Aieee! Couldn't init!\n");
		return 0;
	}

   or, much better, actually use a temporary variable called "err" or 
   "error" or something, at which point "!error" is suddenly readable 
   again:

	err = tick_init_highres();
	if (!err)
		return;

I know this sounds stupid, but we've long since come to the point where 
source code readability on a *local* scale is damn important, simply 
because that's how people look at code: they may not always remember 
whether "zero is success" or "zero is false".

In general, I would suggest:

 - ALWAYS use "negative means error". If you had done that in this case, 
   then hrtimer_switch_to_hres() would have been a lot more readable, 
   *and* it could actually have returned the error code that it got to the 
   caller. In general, it's just more information when you see

	error = some_function();
	if (error)
		return error;

   because even if it may generate basically *exactly* same code as the 
   reversed "positive" version:

	if (!some_version_is_true())
		return 0;

   it simply has more semantic information for *humans*.

   And when you do this, *test it as such*. Either use an explicit "< 0" 
   so that you *see* that you're testing an error value, or use that 
   "retval/error = xyzzy()" pattern that is already showing "it's more 
   than just true/false"

 - use "true/false" only for things where it's *really* obvious that the 
   answer is never an error, and always a "was it true"?

Yeah, even so, the true/false kind of thing may be more common (especially 
with small helper functions that are literally *designed* to be used just 
as a conditional), but I think in this case, you really should have done 
it as a "returns error" function. Partly because now it was throwing away 
an error code, partly simply because in this case, it really wasn't about 
true/false as much as about "did something error out and keep it from 
succeeding?".

Maybe I'm just getting anal in my old age. I at one time tried to make 
sparse check for these things, but there was no really sane thing I could 
come up with (way way WAAY too much manual annotation).

I might have to break down and suggest people use

	bool somefunction(..)
	{
		if (... < 0)
			return false;
		...
		return true;
	}

just to (a) eventually have sparse check for these things but more 
importantly (b) have people see more at a glance whether a function is 
supposed to return "negative or success" or "true or false".

I've not generally been a huge fan of "boolean", especially in the 
traditional C kind of sense (capital screaming letters, and really just an 
"int" with lipstick). But with modern C, and "bool" defined as really 
holding just 0/1 (in practice - "unsigned char"), we could actually check 
these things (and verify with sparse that you never assign any integer 
except for 0/1 to a boolean, and otherwise always have to use a real 
boolean construct).

Thus endeth my overly long coding style rant.

		Linus
