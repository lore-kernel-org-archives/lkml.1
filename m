Return-Path: <linux-kernel-owner+w=401wt.eu-S1030587AbXBOUGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030587AbXBOUGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 15:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030599AbXBOUGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 15:06:50 -0500
Received: from javad.com ([216.122.176.236]:1650 "EHLO javad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030587AbXBOUGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 15:06:49 -0500
From: Sergei Organov <osv@javad.com>
To: Olivier Galibert <galibert@pobox.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "J.A. =?utf-8?B?TWFn?= =?utf-8?B?YWxsw4PDg8OCwrNu?=" 
	<jamagallon@ono.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
References: <Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
	<Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
	<20070208221317.5beedaeb@werewolf-wl>
	<Pine.LNX.4.64.0702081338010.8424@woody.linux-foundation.org>
	<Pine.LNX.4.64.0702081351410.8424@woody.linux-foundation.org>
	<87abznsdyo.fsf@javad.com>
	<Pine.LNX.4.64.0702090753500.8424@woody.linux-foundation.org>
	<874pprr5nn.fsf@javad.com>
	<Pine.LNX.4.64.0702120804520.8424@woody.linux-foundation.org>
	<87ps8end9b.fsf@javad.com> <20070213222125.GB68966@dspnet.fr.eu.org>
Date: Thu, 15 Feb 2007 23:06:21 +0300
In-Reply-To: <20070213222125.GB68966@dspnet.fr.eu.org> (Olivier Galibert's
	message of "Tue, 13 Feb 2007 23:21:25 +0100")
Message-ID: <87d54bjide.fsf@javad.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olivier Galibert <galibert@pobox.com> writes:

> On Tue, Feb 13, 2007 at 09:06:24PM +0300, Sergei Organov wrote:
>> I agree that making strxxx() family special is not a good idea. So what
>> do we do for a random foo(char*) called with an 'unsigned char*'
>> argument? Silence? Hmmm... It's not immediately obvious that it's indeed
>> harmless. Yet another -Wxxx option to GCC to silence this particular
>> case?
>
> Silence would be good.  "char *" has a special status in C, it can be:
> - pointer to a char/to an array of chars (standard interpretation)
> - pointer to a string
> - generic pointer to memory you can read(/write)
>
> Check the aliasing rules if you don't believe be on the third one.

Generic pointer still reads 'void*' isn't it? If you don't believe me,
check memcpu() and friends. From the POV of aliasing rules, "char*",
"unsigned char*", and "signed char*" are all the same, as aliasing rules
mention "character type", that according to the standard, is defined
like this:

  "The three types char, signed char, and unsigned char are collectively
   called the character types."

> And it's *way* more often cases 2 and 3 than 1 for the simple reason
> that the signedness of char is unpredictable.

Are the first two different other than by 0-termination? If not, then
differentiate 1 and 2 by signedness doesn't make sense. If we throw
away signedness argument, then yes, 2 is more common than 1, due to
obvious reason that it's much more convenient to use 0-terminated arrays
of characters in C than plain arrays of characters.

For 3, I'd use "unsigned char*" (or, sometimes, maybe, "signed char*") to
do actual access (due to aliasing rules), but "void*" as an argument
type, as arbitrary pointer is spelled "void*" in C.

So, it's 2 that I'd consider the most common usage for "char*". Strings
of characters are idiomatically "char*" in C.

> As a result, a signedness warning between char * and (un)signed char *
> is 99.99% of the time stupid.

As a result of what? Of the fact that strings in C are "char*"? Of the
fact that one can use "char*" to access arbitrary memory? If the latter,
then "char*", "signed char*", and "unsigned char*" are all equal, and
you may well argue that there should be no warning between "signed
char*" and "unsigned char*" as well, as either of them could be used to
access memory.

Anyway, I've already stated that I don't think it's signedness that matters
here. Standard explicitly says "char", "signed char", and "unsigned
char" are all distinct types, so the warning should be about
incompatible pointer instead. Anyway, I even don't dispute those 99.99%
number, I just want somebody to explain me how dangerous those 0.001%
are, and isn't it exactly 0%?

[...]
>> I'm afraid I don't follow. Do we have a way to say "I want an int of
>> indeterminate sign" in C?
>
> Almost completely.  The rules on aliasing say you can convert pointer
> between signed and unsigned variants and the accesses will be
> unsurprising.

Only from the point of view of aliasing. Aliasing rules don't disallow
other surprises.

>
> The only problem is that the implicit conversion of incompatible
> pointer parameters to a function looks impossible in the draft I have.

Why do you think it's impossible according to the draft?

> Probably has been corrected in the final version.

I doubt it's impossible either in the draft or in the final version.

> In any case, having for instance unsigned int * in a prototype really
> means in the language "I want a pointer to integers, and I'm probably
> going to use it them as unsigned, so beware".

> For the special case of char, since the beware version would require a
> signed or unsigned tag, it really means indeterminate.

IMHO, it would read "I want a pointer to alphabetic characters, and I'm
probably going to use them as alphabetic characters, so beware". No
signedness involved.

For example, suppose we have 3 function that compare two
zero-terminated arrays:

int compare1(char *c1, char *c2);
int compare2(unsigned char *c1, unsigned char *c2);
int compare3(signed char *c1, signed char *c2);

the first one might compare arguments alphabetically, while the second
and the third compare them numerically. All of the 3 are different, so
passing wrong type of argument to either of them might be dangerous.

> C is sometimes called a high-level assembler for a reason :-)

I'm afraid that those times when it actually was, are far in the past,
for better or worse.

>> The same way there doesn't seem to be a way to say "I want a char of
>> indeterminate sign". :( So no, strlen() doesn't actually say that, no
>> matter if we like it or not. It actually says "I want a char with
>> implementation-defined sign".
>
> In this day and age it means "I want a 0-terminated string".

IMHO, you've forgot to say "of alphabetic characters".

> Everything else is explicitely signed char * or unsigned char *, often
> through typedefs in the signed case.

Those are for signed and unsigned tiny integers, with confusing names,
that in turn are just historical baggage.

>> In fact it's implementation-defined, and this may make a difference
>> here. strlen(), being part of C library, could be specifically
>> implemented for given architecture, and as architecture is free to
>> define the sign of "char", strlen() could in theory rely on particular
>> sign of "char" as defined for given architecture. [Not that I think that
>> any strlen() implementation actually depends on sign.]
>
> That would require pointers tagged in a way or another, you can't
> distinguish between pointers to differently-signed versions of the
> same integer type otherwise (they're required to have same size and
> alignment).  You don't have that on modern architectures.

How is it relevant? According to this argument, e.g., foo(int*) can't
actually rely on the sign of its argument, so any warning about
signedness of pointer argument is crap.

>> Can we assure that no function taking 'char*' ever cares about the sign?
>> I'm not sure, and I'm not a language lawyer, but if it's indeed the
>> case, I'd probably agree that it might be a good idea for GCC to extend
>> the C language so that function argument declared "char*" means either
>> of "char*", "signed char*", or "unsigned char*" even though there is no
>> precedent in the language.
>
> It's a warning you're talking about.  That means it is _legal_ in the
> language (even if maybe implementation defined, but legal still).
> Otherwise it would be an error.

It's legal to pass "unsigned int*" to function requesting "int*", still
the warning on this is useful?

>> BTW, the next logical step would be for "int*" argument to stop meaning
>> "signed int*" and become any of "int*", "signed int*" or "unsigned
>> int*". Isn't it cool to be able to declare a function that won't produce
>> warning no matter what int is passed to it? ;)
>
> No, it wouldn't be logical, because char is *special*.

Yes, it's special, but in what manner? I fail to see in the standard
that "char" means either of "signed char" or "unsigned char".

>> Yes, indeed. So the real problem of the C language is inconsistency
>> between strxxx() and isxxx() families of functions? If so, what is 
>> wrong with actually fixing the problem, say, by using wrappers over
>> isxxx()? Checking... The kernel already uses isxxx() that are macros
>> that do conversion to "unsigned char" themselves, and a few invocations
>> of isspace() I've checked pass "char" as argument. So that's not a real
>> problem for the kernel, right?
>
> Because a cast to silence a warning silences every possible warning
> even if the then-pointer turns for instance into an integer through an
> unrelated change.

The isxxx() family doesn't have pointer arguments, so this is
irrelevant. The isxxx() family, as implemented in the kernel, casts its
argument to "unsigned char", that is the right thing to do.

>> As the isxxx() family does not seem to be a real problem, at least in
>> the context of the kernel source base, I'd like to learn other reasons
>> to use "unsigned char" for doing strings either in general or
>> specifically in the Linux kernel.
>
> Everybody who has ever done text manipulation in languages other than
> english knows for a fact that chars must be unsigned, always.  The
> current utf8 support frenzy is driving that home even harder.

Well, maybe, but it won't be C anymore. Strings in C are "char*", and
sign of "char" is implementation-defined. Though you can get what you
are asking for even now by using -funsigned-char.

>> OK, provided there are actually sound reasons to use "unsigned char*"
>> for strings, isn't it safer to always use it, and re-define strxxx() for
>> the kernel to take that one as argument? Or are there reasons to use
>> "char*" (or "signed char*") for strings as well? I'm afraid that if two
>> or three types are allowed to be used for strings, some inconsistencies
>> here or there will remain no matter what.
>
> "blahblahblah"'s type is const char *.

Yes, how did I forgot about it? So be it, strings in C are "char*".

>> Another option could be to always use "char*" for strings and always compile
>> the kernel with -funsigned-char. At least it will be consistent with the
>> C idea of strings being "char*".
>
> The best option is to have gcc stop being stupid.

Any compiler is stupid. AI didn't mature enough yet ;)

> -funsigned-char creates an assumption which is actually invisible in
> the code itself, making it a ticking bomb for reuse in other projects.

Well, on one hand you are asking for char to always be unsigned, but on
the other hand you deny the gcc option that provides exactly that. The
only option that remains is to argue char should always be unsigned to
the C committee, I'm afraid.

-- Sergei.
