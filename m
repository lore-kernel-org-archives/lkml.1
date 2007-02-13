Return-Path: <linux-kernel-owner+w=401wt.eu-S1751411AbXBMSGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411AbXBMSGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 13:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbXBMSGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 13:06:55 -0500
Received: from javad.com ([216.122.176.236]:4050 "EHLO javad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbXBMSGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 13:06:54 -0500
From: Sergei Organov <osv@javad.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "J.A. =?utf-8?B?TWFnYWxsw4PDg8OCwrNu?=" <jamagallon@ono.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
References: <45CB3B28.60102@garzik.org>
	<Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
	<Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
	<Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
	<20070208221317.5beedaeb@werewolf-wl>
	<Pine.LNX.4.64.0702081338010.8424@woody.linux-foundation.org>
	<Pine.LNX.4.64.0702081351410.8424@woody.linux-foundation.org>
	<87abznsdyo.fsf@javad.com>
	<Pine.LNX.4.64.0702090753500.8424@woody.linux-foundation.org>
	<874pprr5nn.fsf@javad.com>
	<Pine.LNX.4.64.0702120804520.8424@woody.linux-foundation.org>
Date: Tue, 13 Feb 2007 21:06:24 +0300
Message-ID: <87ps8end9b.fsf@javad.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
> On Mon, 12 Feb 2007, Sergei Organov wrote:
>> 
>> Why strlen() should be allowed to be called with an incompatible pointer
>> type? My point is that gcc should issue *different warning*, -- the same
>> warning it issues here:
>
> I agree that "strlen()" per se isn't different.

I agree that making strxxx() family special is not a good idea. So what
do we do for a random foo(char*) called with an 'unsigned char*'
argument? Silence? Hmmm... It's not immediately obvious that it's indeed
harmless. Yet another -Wxxx option to GCC to silence this particular
case?

> A warnign is only as good as
>  (a) the thing it warns about
>  (b) the thing you can do about it
> 
> And THAT is the fundamental problem with that *idiotic* warning. Yes, it's 
> technically correct. Yes, it's "proper C grammar". But if you can't get 
> over the hump of realizing that there is a difference between "grammar" 
> and "intelligent speech", you shouldn't be doing compilers.
> 
> So the warning sucks because:

May I suggest another definition for a warning being entirely sucks?
"The warning is entirely sucks if and only if it never has true
positives." In all other cases it's only more or less sucks, IMHO.

>  - the thing it warns about (passing "unsigned char" to something that 
>    doesn't specify a sign at all!) is not something that sounds wrong in 
>    the first place. Yes, it's unsigned. But no, the thing it is passed to 
>    didn't specify that it wanted a "signed" thing in the first place. The 
>    "strlen()" function literally says
>
> 	"I want a char of indeterminate sign"!

I'm afraid I don't follow. Do we have a way to say "I want an int of
indeterminate sign" in C? The same way there doesn't seem to be a way
to say "I want a char of indeterminate sign". :( So no, strlen() doesn't
actually say that, no matter if we like it or not. It actually says "I
want a char with implementation-defined sign".

>    which implies that strlen really doesn't care about the sign. The same 
>    is true of *any* function that takes a "char *". Such a function 
>    doesn't care, and fundamentally CANNOT care about the sign, since it's 
>    not even defined!

In fact it's implementation-defined, and this may make a difference
here. strlen(), being part of C library, could be specifically
implemented for given architecture, and as architecture is free to
define the sign of "char", strlen() could in theory rely on particular
sign of "char" as defined for given architecture. [Not that I think that
any strlen() implementation actually depends on sign.]

>    So the warning fails the (a) criterion. The warning isn't valid, 
>    because the thing it warns about isn't a valid problem!

Can we assure that no function taking 'char*' ever cares about the sign?
I'm not sure, and I'm not a language lawyer, but if it's indeed the
case, I'd probably agree that it might be a good idea for GCC to extend
the C language so that function argument declared "char*" means either
of "char*", "signed char*", or "unsigned char*" even though there is no
precedent in the language.

BTW, the next logical step would be for "int*" argument to stop meaning
"signed int*" and become any of "int*", "signed int*" or "unsigned
int*". Isn't it cool to be able to declare a function that won't produce
warning no matter what int is passed to it? ;)

>  - it _also_ fails the (b) criterion, because quite often there is nothing 
>    you can do about it. Yes, you can add a cast, but adding a cast 
>    actually causes _worse_ code (but the warning is certainly gone). But 
>    that makes the _other_ argument for the warning totally point-less: if 
>    the reason for the warning was "bad code", then having the warning is 
>    actively BAD, because the end result is actually "worse code".
>
> See? The second point is why it's important to also realize that there is 
> a lot of real and valid code that actually _does_ pass "strlen()" an 
> unsigned string.

And here we finally get to the practice...

> There are tons of reasons for that to happen: the part of the program
> that _does_ care wants to use a "unsigned char" array, because it ends
> up doing things like "isspace(array[x])", and that is not well-defined
> if you use a "char *" array.

Yes, indeed. So the real problem of the C language is inconsistency
between strxxx() and isxxx() families of functions? If so, what is 
wrong with actually fixing the problem, say, by using wrappers over
isxxx()? Checking... The kernel already uses isxxx() that are macros
that do conversion to "unsigned char" themselves, and a few invocations
of isspace() I've checked pass "char" as argument. So that's not a real
problem for the kernel, right?

> So there are lots of reasons to use "unsigned char" arrays for strings. 
> Look it up. Look up any half-way reasonable man-page for the "isspace()" 
> kind of functions, and if they don't actually explicitly say that you 
> should use unsigned characters for it, those man-pages are crap.

Well, even C99 itself does say it. But the kernel already handles this
issue nicely without resorting to requirement to convert char to
unsigned char, isn't it?

> Because those functions really *are* defined in "int", but it's the
> same kind of namespace that "getchar()" works in (ie "unsigned char" +
> EOF, where EOF _usually_ is -1, although other values are certainly
> technically legal too).
>
> So:
>
>  - in practice, a lot of "good programming" uses "unsigned char" pointers 
>    for doing strings. There are LOTS of reasons for that, but "isspace()" 
>    and friends is the most obvious one.

As the isxxx() family does not seem to be a real problem, at least in
the context of the kernel source base, I'd like to learn other reasons
to use "unsigned char" for doing strings either in general or
specifically in the Linux kernel.

>  - if you can't call "strlen()" on your strings without the compiler 
>    warning, there's two choices: the compiler warning is CRAP, or your 
>    program is bad. But as I just showed you, "unsigned char *" is actually 
>    often the *right* thing to use for string work, so it clearly wasn't 
>    the program that was bad.

OK, provided there are actually sound reasons to use "unsigned char*"
for strings, isn't it safer to always use it, and re-define strxxx() for
the kernel to take that one as argument? Or are there reasons to use
"char*" (or "signed char*") for strings as well? I'm afraid that if two
or three types are allowed to be used for strings, some inconsistencies
here or there will remain no matter what.

Another option could be to always use "char*" for strings and always compile
the kernel with -funsigned-char. At least it will be consistent with the
C idea of strings being "char*".

-- Sergei.
