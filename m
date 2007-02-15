Return-Path: <linux-kernel-owner+w=401wt.eu-S1030541AbXBOSxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030541AbXBOSxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 13:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030542AbXBOSxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 13:53:38 -0500
Received: from javad.com ([216.122.176.236]:2419 "EHLO javad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030541AbXBOSxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 13:53:36 -0500
From: Sergei Organov <osv@javad.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "J.A. =?utf-8?B?TWFnYWxsw4M=?= =?utf-8?B?w4PDg8ODw4LCs24=?=" 
	<jamagallon@ono.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
References: <45CB3B28.60102@garzik.org>
	<Pine.LNX.4.64.0702081338010.8424@woody.linux-foundation.org>
	<Pine.LNX.4.64.0702081351410.8424@woody.linux-foundation.org>
	<87abznsdyo.fsf@javad.com>
	<Pine.LNX.4.64.0702090753500.8424@woody.linux-foundation.org>
	<874pprr5nn.fsf@javad.com>
	<Pine.LNX.4.64.0702120804520.8424@woody.linux-foundation.org>
	<87ps8end9b.fsf@javad.com>
	<84144f020702131026q2af1afd6vbcd2708d7b7b9907@mail.gmail.com>
	<87bqjxooog.fsf@javad.com>
	<84144f020702131143r767aa40blb97a39b40bee73b8@mail.gmail.com>
	<87fy99n6mf.fsf@javad.com>
	<Pine.LNX.4.64.0702131513050.3604@woody.linux-foundation.org>
	<87hctnlfqz.fsf@javad.com>
	<Pine.LNX.4.64.0702150736360.20368@woody.linux-foundation.org>
Date: Thu, 15 Feb 2007 21:53:04 +0300
In-Reply-To: <Pine.LNX.4.64.0702150736360.20368@woody.linux-foundation.org>
	(Linus Torvalds's message of "Thu, 15 Feb 2007 07:57:05 -0800 (PST)")
Message-ID: <87k5yjjlrj.fsf@javad.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
> On Thu, 15 Feb 2007, Sergei Organov wrote:

[...Skip things I agree with...]

>> > But if you have 
>> >
>> > 	unsigned char *mystring;
>> >
>> > 	len = strlen(mystring);
>> >
>> > then please tell me how to fix that warning without making the code 
>> > *worse* from a type-safety standpoint? You CANNOT. You'd have to cast it 
>> > explicitly (or assing it through a "void *" variable), both of which 
>> > actually MAKE THE TYPE-CHECKING PROBLEM WORSE!
>> 
>> Because instead of trying to fix the code, you insist on hiding the
>> warning.
>
> No. I'm saying that I have *reasons* that I need my string to be unsigned. 
> That makes your first "fix" totally bogus:

Somehow I still suppose that most of those warnings could be fixed by
using "char*" instead. Yes, I believe you, you have reasons. But still I
only heard about isxxx() that appeared to be not a reason in practice
(in the context of the kernel tree). As you didn't tell about other
reasons, my expectation is that they are not in fact very common. I'm
curious what are actual reasons besides the fact that quite a lot of
code is apparently written this way in the kernel. The latter is indeed
a very sound reason for the warning to be sucks for kernel developers,
but it might be not a reason for it to be sucks in general.

>> There are at least two actual fixes:
>> 
>> 1. Do 'char *mystring' instead, as otherwise compiler can't figure out
>>    that you are going to use 'mystring' to point to zero-terminated
>>    array of characters.
>
> And the second fix is a fix, but it is, again, worse than the warning:
>
>> 2. Use "len = ustrlen(mystring)" if you indeed need something like C
>>    strings
>
> Sure, I can do that, but the upside is what?

1. You make it explicit, in a type-safe manner, that you are sure it's
   safe to call "strlen()" with "unsigned char*" argument. We all agree
   about it. Let's write it down in the program. And we can already add
   "strcmp()" to the list. And, say, ustrdup() and ustrchr() returning
   "unsigned char *", would be more type-safe either.

2. You make it more explicit that you indeed mean to use your own
   representation of strings that is different than what C idiomatically
   uses for strings, along with explicitly defined allowed set of
   operations on this representation.

The actual divergence of opinion seems to be that you are sure it's safe
to call any foo(char*) with "unsigned char*" argument, and I'm not, due
to the reasons described below. If you are right, then there is indeed
little or no point in doing this work.

> Getting rid of a warning that was bogus to begin with?

I agree that if the warning has no true positives, it sucks. The problem
is that somehow I doubt it has none. And the reasons for the doubt are:

1. C standard does explicitly say that "char" is different type from
   either "signed char" or "unsigned char". There should be some reason
   for that, otherwise they'd simply write that "char" is a synonym for
   one of "signed char" or "unsigned char", depending on implementation.

2. If "char" in fact matches one of the other two types for given
   architecture, it is definitely different from another one, so
   substituting "char" for the different one might be unsafe. As a
   consequence, for a portable program it might be unsafe to substitute
   "char" for any of signed or unsigned, as "char" may happen to
   differ from any of them.

While the doubts aren't resolved, I prefer to at least be careful with
things that I don't entirely understand, so I wish compiler give me a
warning about subtle semantic differences (if any).

-- Sergei.
