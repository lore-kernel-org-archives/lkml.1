Return-Path: <linux-kernel-owner+w=401wt.eu-S932809AbXBOP5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809AbXBOP5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 10:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932368AbXBOP5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 10:57:31 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50403 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932369AbXBOP5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 10:57:30 -0500
Date: Thu, 15 Feb 2007 07:57:05 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sergei Organov <osv@javad.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       =?ISO-8859-1?Q?J=2EA=2E_Magall=C3=C3=C3=C3=C2=B3n?= 
	<jamagallon@ono.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
In-Reply-To: <87hctnlfqz.fsf@javad.com>
Message-ID: <Pine.LNX.4.64.0702150736360.20368@woody.linux-foundation.org>
References: <45CB3B28.60102@garzik.org> <Pine.LNX.4.64.0702081338010.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081351410.8424@woody.linux-foundation.org>
 <87abznsdyo.fsf@javad.com> <Pine.LNX.4.64.0702090753500.8424@woody.linux-foundation.org>
 <874pprr5nn.fsf@javad.com> <Pine.LNX.4.64.0702120804520.8424@woody.linux-foundation.org>
 <87ps8end9b.fsf@javad.com> <84144f020702131026q2af1afd6vbcd2708d7b7b9907@mail.gmail.com>
 <87bqjxooog.fsf@javad.com> <84144f020702131143r767aa40blb97a39b40bee73b8@mail.gmail.com>
 <87fy99n6mf.fsf@javad.com> <Pine.LNX.4.64.0702131513050.3604@woody.linux-foundation.org>
 <87hctnlfqz.fsf@javad.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Feb 2007, Sergei Organov wrote:
> 
> Yes, there is. There are at least 2 drawbacks. Minor one is
> initialization eating cycles. Major one is that if later I change the
> code and there will appear a pass that by mistake uses those fake value,
> I won't get the warning anymore. The latter drawback is somewhat similar
> to the drawbacks of explicit type casts.

I actually agree - it would clearly be *nicer* if gcc was accurate with 
the warning. I'm just saying that usually the patch to shut gcc up is 
quite benign.

But yes, it basically disabled the warning, and just *maybe* the warning 
was valid, and it disabled it by initializing something to the wrong 
value. 

That's why warnings with false positives are often much worse than not 
having the warning at all: you start dismissing them, and not even 
bothering to fix them "properly". That's especially true if there _isn't_ 
a proper fix.

I personally much prefer a compiler that doesn't warn a lot, but *when* it 
warns, it's 100% on the money. I think that compilers that warn about 
things that "may" be broken are bogus. It needs to be iron-clad, with no 
question about whether the warning is appropriate!

Which is, of course, why we then shut up some gcc warnings, and which gets 
us back to the start of the discussion.. ;)

> [I'd, personally, try to do code reorganization instead so that it
> becomes obvious for the compiler that the variable can't be used
> uninitialized. Quite often it makes the code better, at least it was my
> experience so far.]

It's true that it sometimes works that way. Not always, though.

The gcc "uninitialized variable" thing is *usually* a good sign that the 
code wasn't straightforward for the compiler to follow, and if the 
compiler cannot follow it, then probably neither can most programmers. So 
together with the fact that it's not at least _syntactically_ ugly to shut 
up, it's not a warning I personally object to most of the time (unlike, 
say, the pointer-sign one ;)

> [Did I already say that I think it's wrong warning to be given in this
> particular case, as the problem with the code is not in signedness?]
> 
> 1. Don't try to hide the warning, at least not immediately, -- consider
>    fixing the code first. Ah, sorry, you've already decided for yourself
>    that the warning is idiotic, so there is no reason to try to...

This is actually something we've tried. 

The problem with that approach is that once you have tons of warnings that 
are "expected", suddenly *all* warnings just become noise. Not just the 
bogus one. It really *is* a matter of: warnings should either be 100% 
solid, or they should not be there at all.

And this is not just about compiler warnings. We've added some warnings of 
our own (well, with compiler help, of course): things like the 
"deprecated" warnings etc. I have often ended up shutting them up, and one 
reason for that is that yes, I have literally added bugs to the kernel 
that the compiler really *did* warn about, but because there were so many 
other pointless warnings, I didn't notice!

I didn't make that up. I forget what the bug was, but it literally wasn't 
more than a couple of months ago that I passed in the wrong type to a 
function, and the compiler warned about it in big letters. It was just 
totally hidden by all the other warning crap.

> 2. If you add a cast, it's not in contrast, it's rather similar to fake
>    initialization above as they have somewhat similar drawback.

I agree that it's "unnecessary code", and in many ways exactly the same 
thing. I just happen to believe that casts tend to be a lot more dangerous 
than extraneous initializations. Casts have this nasty tendency of hiding 
*other* problems too (ie you later change the thing you cast completely, 
and now the compiler doesn't warn about a *real* bug, because the cast 
will just silently force it to a wrong type).

And yeah, that may well be a personal hangup of mine. A lot of people 
think casts in C are normal. Me, I actually consider C to be a type-safe 
language (!) but it's only type-safe if you are careful, and avoiding 
casts is one of the rules.

Others claim that C isn't type-safe at all, and I think it comes from 
them having been involved in projects where people didn't have the same 
"casts are good, but only when you use them really really carefully".

> > But if you have 
> >
> > 	unsigned char *mystring;
> >
> > 	len = strlen(mystring);
> >
> > then please tell me how to fix that warning without making the code 
> > *worse* from a type-safety standpoint? You CANNOT. You'd have to cast it 
> > explicitly (or assing it through a "void *" variable), both of which 
> > actually MAKE THE TYPE-CHECKING PROBLEM WORSE!
> 
> Because instead of trying to fix the code, you insist on hiding the
> warning.

No. I'm saying that I have *reasons* that I need my string to be unsigned. 
That makes your first "fix" totally bogus:

> There are at least two actual fixes:
> 
> 1. Do 'char *mystring' instead, as otherwise compiler can't figure out
>    that you are going to use 'mystring' to point to zero-terminated
>    array of characters.

And the second fix is a fix, but it is, again, worse than the warning:

> 2. Use "len = ustrlen(mystring)" if you indeed need something like C
>    strings

Sure, I can do that, but the upside is what?

Getting rid of a warning that was bogus to begin with?

		Linus
