Return-Path: <linux-kernel-owner+w=401wt.eu-S932732AbXBONUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732AbXBONUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 08:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932734AbXBONUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 08:20:40 -0500
Received: from javad.com ([216.122.176.236]:1739 "EHLO javad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932732AbXBONUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 08:20:39 -0500
From: Sergei Organov <osv@javad.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "J.A. =?utf-8?B?TWFnYWxsw4M=?= =?utf-8?B?w4PDg8OCwrNu?=" 
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
Date: Thu, 15 Feb 2007 16:20:04 +0300
Message-ID: <87hctnlfqz.fsf@javad.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
> On Tue, 13 Feb 2007, Sergei Organov wrote:
>> 
>> Sorry, what do you do with "variable 'xxx' might be used uninitialized"
>> warning when it's false? Turn it off? Annotate the source? Assign fake
>> initialization value? Change the compiler so that it does "the effort"
>> for you? Never encountered false positive from this warning?
>
> The thing is, that warning is at least easy to shut up. 
>
> You just add a fake initialization. There isn't any real downside.

Yes, there is. There are at least 2 drawbacks. Minor one is
initialization eating cycles. Major one is that if later I change the
code and there will appear a pass that by mistake uses those fake value,
I won't get the warning anymore. The latter drawback is somewhat similar
to the drawbacks of explicit type casts.

[I'd, personally, try to do code reorganization instead so that it
becomes obvious for the compiler that the variable can't be used
uninitialized. Quite often it makes the code better, at least it was my
experience so far.]

> In contrast, to shut up the idiotic pointer-sign warning, you have to add 
> a cast.

[Did I already say that I think it's wrong warning to be given in this
particular case, as the problem with the code is not in signedness?]

1. Don't try to hide the warning, at least not immediately, -- consider
   fixing the code first. Ah, sorry, you've already decided for yourself
   that the warning is idiotic, so there is no reason to try to...

2. If you add a cast, it's not in contrast, it's rather similar to fake
   initialization above as they have somewhat similar drawback.

> Now, some people seem to think that adding casts is a way of life, and 
> think that C programs always have a lot of casts.

Hopefully I'm not one of those.

[...]
> But if you have 
>
> 	unsigned char *mystring;
>
> 	len = strlen(mystring);
>
> then please tell me how to fix that warning without making the code 
> *worse* from a type-safety standpoint? You CANNOT. You'd have to cast it 
> explicitly (or assing it through a "void *" variable), both of which 
> actually MAKE THE TYPE-CHECKING PROBLEM WORSE!

Because instead of trying to fix the code, you insist on hiding the
warning. There are at least two actual fixes:

1. Do 'char *mystring' instead, as otherwise compiler can't figure out
   that you are going to use 'mystring' to point to zero-terminated
   array of characters.

2. Use "len = ustrlen(mystring)" if you indeed need something like C
   strings, but built from "unsigned char" elements. Similar to (1), this
   will explain your intent to those stupid compiler. Should I also
   mention that due to the definition of strlen(), the implementation of
   ustrlen() is a one-liner (thnx Andrew):

static inline size_t ustrlen(const unsigned char *s)
{
    return strlen((const char *)s);
}

Overall, describe your intent to the compiler more clearly, as reading
programmer's mind is not the kind of business where compilers are
strong.

> See? The warning made no sense to begin with, and it warns about something 
> where the alternatives are worse than what it warned about.
>
> Ergo. It's a crap warning.

No, I'm still not convinced. Well, I'll try to explain my point
differently. What would you think about the following line, should you
encounter it in real code:

  len = strlen(my_tiny_integers);

I'd think that as 'my_tiny_integers' is used as an argument to strlen(),
it might be zero-terminated array of characters. But why does it have
such a name then?!  Maybe it in fact holds an array of integers where 0
is not necessarily terminating, and the intent of this code is just to
find first occurrence of 0? It's confusing and I'd probably go check the
declaration. Declaration happens to be "unsigned char *my_tiny_integers"
that at least is rather consistent with the variable name, but doesn't
resolve my initial doubts. So I need to go check other usages of this
'my_tiny_integers' variable to figure out what's actually going on
here. Does it sound as a good programming practice? I don't think so.

Now, you probably realize that in the example you gave above you've
effectively declared "mystring" to be a pointer to
"tiny_unsigned_integer". As compiler (fortunately) doesn't guess intent
from variable names, it can't give us warning at the point of
declaration, but I still think we must be thankful that it gave us a
warning (even though gcc gives a wrong kind of warning) at the point of
dubious use.

-- Sergei.
