Return-Path: <linux-kernel-owner+w=401wt.eu-S964878AbXBLQ0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964878AbXBLQ0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964884AbXBLQ0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:26:49 -0500
Received: from smtp.osdl.org ([65.172.181.24]:60609 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964878AbXBLQ0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:26:48 -0500
Date: Mon, 12 Feb 2007 08:26:26 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sergei Organov <osv@javad.com>
cc: =?ISO-8859-1?Q?J=2EA=2E_Magall=C3=C3=C2=B3n?= <jamagallon@ono.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
In-Reply-To: <874pprr5nn.fsf@javad.com>
Message-ID: <Pine.LNX.4.64.0702120804520.8424@woody.linux-foundation.org>
References: <45CB3B28.60102@garzik.org> <Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
 <20070208221317.5beedaeb@werewolf-wl> <Pine.LNX.4.64.0702081338010.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081351410.8424@woody.linux-foundation.org>
 <87abznsdyo.fsf@javad.com> <Pine.LNX.4.64.0702090753500.8424@woody.linux-foundation.org>
 <874pprr5nn.fsf@javad.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Feb 2007, Sergei Organov wrote:
> 
> Why strlen() should be allowed to be called with an incompatible pointer
> type? My point is that gcc should issue *different warning*, -- the same
> warning it issues here:

I agree that "strlen()" per se isn't different.

The issue is not that the warning isn't "technically correct". IT IS. 

Nobody should ever argue that the warning isn't "correct". I hope people 
didn't think I argued that.

I've argued that the warning is STUPID. That's a totally different thing.

I can say totally idiotic things in perfectly reasonable English grammar 
and spelling. Does that make the things I say "good"? No.

The same is true of this gcc warning. It's technically perfectly 
reasonable both in English grammar and spelling (well, as far as 
any compiler warning ever is) _and_ in "C grammar and spelling" too.

But being grammatically correct does not make it "smart". IT IS STILL 
STUPID.

Can people not see the difference between "grammatically correct" and 
"intelligent"? People on the internet seem to have often acquired the 
understanding that "bad grammar and spelling" => "stupid", and yes, there 
is definitely some kind of correlation there. But as any logician and 
matematician hopefully knows, "a => b" does NOT imply "!a => !b".

Some people think that "warnings are always good". HELL NO!

A warnign is only as good as
 (a) the thing it warns about
 (b) the thing you can do about it

And THAT is the fundamental problem with that *idiotic* warning. Yes, it's 
technically correct. Yes, it's "proper C grammar". But if you can't get 
over the hump of realizing that there is a difference between "grammar" 
and "intelligent speech", you shouldn't be doing compilers.

So the warning sucks because:

 - the thing it warns about (passing "unsigned char" to something that 
   doesn't specify a sign at all!) is not something that sounds wrong in 
   the first place. Yes, it's unsigned. But no, the thing it is passed to 
   didn't specify that it wanted a "signed" thing in the first place. The 
   "strlen()" function literally says

	"I want a char of indeterminate sign"!

   which implies that strlen really doesn't care about the sign. The same 
   is true of *any* function that takes a "char *". Such a function 
   doesn't care, and fundamentally CANNOT care about the sign, since it's 
   not even defined!

   So the warning fails the (a) criterion. The warning isn't valid, 
   because the thing it warns about isn't a valid problem!

 - it _also_ fails the (b) criterion, because quite often there is nothing 
   you can do about it. Yes, you can add a cast, but adding a cast 
   actually causes _worse_ code (but the warning is certainly gone). But 
   that makes the _other_ argument for the warning totally point-less: if 
   the reason for the warning was "bad code", then having the warning is 
   actively BAD, because the end result is actually "worse code".

See? The second point is why it's important to also realize that there is 
a lot of real and valid code that actually _does_ pass "strlen()" an 
unsigned string. There are tons of reasons for that to happen: the part of 
the program that _does_ care wants to use a "unsigned char" array, because 
it ends up doing things like "isspace(array[x])", and that is not 
well-defined if you use a "char *" array.

So there are lots of reasons to use "unsigned char" arrays for strings. 
Look it up. Look up any half-way reasonable man-page for the "isspace()" 
kind of functions, and if they don't actually explicitly say that you 
should use unsigned characters for it, those man-pages are crap. Because 
those functions really *are* defined in "int", but it's the same kind of 
namespace that "getchar()" works in (ie "unsigned char" + EOF, where EOF 
_usually_ is -1, although other values are certainly technically legal 
too).

So:

 - in practice, a lot of "good programming" uses "unsigned char" pointers 
   for doing strings. There are LOTS of reasons for that, but "isspace()" 
   and friends is the most obvious one.

 - if you can't call "strlen()" on your strings without the compiler 
   warning, there's two choices: the compiler warning is CRAP, or your 
   program is bad. But as I just showed you, "unsigned char *" is actually 
   often the *right* thing to use for string work, so it clearly wasn't 
   the program that was bad.

So *please* understand:

 - yes, the warning is "correct" from a C grammatical standpoint

 - the warnign is STILL CRAP, because grammar isn't the only thing about a 
   computer language. Sane usage is MUCH MORE important than any grammar. 

Thus ends the sacred teachings of Linus "always right" Torvalds. Go and 
ponder these words, and please send me all your money (certified checks 
only, please - sending small unmarked bills is against USPS rules) to show 
your support of the holy church of good taste.

		Linus
