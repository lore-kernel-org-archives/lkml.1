Return-Path: <linux-kernel-owner+w=401wt.eu-S1751340AbXBMWV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340AbXBMWV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:21:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbXBMWV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:21:28 -0500
Received: from dspnet.fr.eu.org ([213.186.44.138]:2684 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbXBMWV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:21:27 -0500
Date: Tue, 13 Feb 2007 23:21:25 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Sergei Organov <osv@javad.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       =?iso-8859-1?B?Si5BLiBNYWdhbGzDw8Kzbg==?= <jamagallon@ono.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
Message-ID: <20070213222125.GB68966@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Sergei Organov <osv@javad.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	=?iso-8859-1?B?Si5BLiBNYWdhbGzDw8Kzbg==?= <jamagallon@ono.com>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Jeff Garzik <jeff@garzik.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr> <Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org> <20070208221317.5beedaeb@werewolf-wl> <Pine.LNX.4.64.0702081338010.8424@woody.linux-foundation.org> <Pine.LNX.4.64.0702081351410.8424@woody.linux-foundation.org> <87abznsdyo.fsf@javad.com> <Pine.LNX.4.64.0702090753500.8424@woody.linux-foundation.org> <874pprr5nn.fsf@javad.com> <Pine.LNX.4.64.0702120804520.8424@woody.linux-foundation.org> <87ps8end9b.fsf@javad.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ps8end9b.fsf@javad.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 09:06:24PM +0300, Sergei Organov wrote:
> I agree that making strxxx() family special is not a good idea. So what
> do we do for a random foo(char*) called with an 'unsigned char*'
> argument? Silence? Hmmm... It's not immediately obvious that it's indeed
> harmless. Yet another -Wxxx option to GCC to silence this particular
> case?

Silence would be good.  "char *" has a special status in C, it can be:
- pointer to a char/to an array of chars (standard interpretation)
- pointer to a string
- generic pointer to memory you can read(/write)

Check the aliasing rules if you don't believe be on the third one.
And it's *way* more often cases 2 and 3 than 1 for the simple reason
that the signedness of char is unpredictable.  As a result, a
signedness warning between char * and (un)signed char * is 99.99% of
the time stupid.


> May I suggest another definition for a warning being entirely sucks?
> "The warning is entirely sucks if and only if it never has true
> positives." In all other cases it's only more or less sucks, IMHO.

That means a warning that triggers on every line saying "there may be
a bug there" does not entirely suck?


> I'm afraid I don't follow. Do we have a way to say "I want an int of
> indeterminate sign" in C?

Almost completely.  The rules on aliasing say you can convert pointer
between signed and unsigned variants and the accesses will be
unsurprising.  The only problem is that the implicit conversion of
incompatible pointer parameters to a function looks impossible in the
draft I have.  Probably has been corrected in the final version.

In any case, having for instance unsigned int * in a prototype really
means in the language "I want a pointer to integers, and I'm probably
going to use it them as unsigned, so beware".  For the special case of
char, since the beware version would require a signed or unsigned tag,
it really means indeterminate.

C is sometimes called a high-level assembler for a reason :-)


> The same way there doesn't seem to be a way
> to say "I want a char of indeterminate sign". :( So no, strlen() doesn't
> actually say that, no matter if we like it or not. It actually says "I
> want a char with implementation-defined sign".

In this day and age it means "I want a 0-terminated string".
Everything else is explicitely signed char * or unsigned char *, often
through typedefs in the signed case.


> In fact it's implementation-defined, and this may make a difference
> here. strlen(), being part of C library, could be specifically
> implemented for given architecture, and as architecture is free to
> define the sign of "char", strlen() could in theory rely on particular
> sign of "char" as defined for given architecture. [Not that I think that
> any strlen() implementation actually depends on sign.]

That would require pointers tagged in a way or another, you can't
distinguish between pointers to differently-signed versions of the
same integer type otherwise (they're required to have same size and
alignment).  You don't have that on modern architectures.


> Can we assure that no function taking 'char*' ever cares about the sign?
> I'm not sure, and I'm not a language lawyer, but if it's indeed the
> case, I'd probably agree that it might be a good idea for GCC to extend
> the C language so that function argument declared "char*" means either
> of "char*", "signed char*", or "unsigned char*" even though there is no
> precedent in the language.

It's a warning you're talking about.  That means it is _legal_ in the
language (even if maybe implementation defined, but legal still).
Otherwise it would be an error.


> BTW, the next logical step would be for "int*" argument to stop meaning
> "signed int*" and become any of "int*", "signed int*" or "unsigned
> int*". Isn't it cool to be able to declare a function that won't produce
> warning no matter what int is passed to it? ;)

No, it wouldn't be logical, because char is *special*.


> Yes, indeed. So the real problem of the C language is inconsistency
> between strxxx() and isxxx() families of functions? If so, what is 
> wrong with actually fixing the problem, say, by using wrappers over
> isxxx()? Checking... The kernel already uses isxxx() that are macros
> that do conversion to "unsigned char" themselves, and a few invocations
> of isspace() I've checked pass "char" as argument. So that's not a real
> problem for the kernel, right?

Because a cast to silence a warning silences every possible warning
even if the then-pointer turns for instance into an integer through an
unrelated change.  Think for instance about an error_t going from
const char * (error string) to int (error code) through a patch, which
happened to be passed to an utf8_to_whatever conversion function that
takes an const unsigned char * as a parameter.  Casting would hide the
impact of changing the type.


> As the isxxx() family does not seem to be a real problem, at least in
> the context of the kernel source base, I'd like to learn other reasons
> to use "unsigned char" for doing strings either in general or
> specifically in the Linux kernel.

Everybody who has ever done text manipulation in languages other than
english knows for a fact that chars must be unsigned, always.  The
current utf8 support frenzy is driving that home even harder.


> OK, provided there are actually sound reasons to use "unsigned char*"
> for strings, isn't it safer to always use it, and re-define strxxx() for
> the kernel to take that one as argument? Or are there reasons to use
> "char*" (or "signed char*") for strings as well? I'm afraid that if two
> or three types are allowed to be used for strings, some inconsistencies
> here or there will remain no matter what.

"blahblahblah"'s type is const char *.


> Another option could be to always use "char*" for strings and always compile
> the kernel with -funsigned-char. At least it will be consistent with the
> C idea of strings being "char*".

The best option is to have gcc stop being stupid.  -Funsigned-char
creates an assumption which is actually invisible in the code itself,
making it a ticking bomb for reuse in other projects.

  OG.
