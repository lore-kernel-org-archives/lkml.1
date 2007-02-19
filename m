Return-Path: <linux-kernel-owner+w=401wt.eu-S932250AbXBSN7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250AbXBSN7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 08:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932255AbXBSN7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 08:59:23 -0500
Received: from javad.com ([216.122.176.236]:4556 "EHLO javad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932250AbXBSN7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 08:59:22 -0500
From: Sergei Organov <osv@javad.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "J.A. =?utf-8?B?TWFnYWxsw4M=?= =?utf-8?B?w4PDg8ODw4PDgsKzbg==?=" 
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
	<87k5yjjlrj.fsf@javad.com>
	<Pine.LNX.4.64.0702151059090.20368@woody.linux-foundation.org>
Date: Mon, 19 Feb 2007 16:58:52 +0300
In-Reply-To: <Pine.LNX.4.64.0702151059090.20368@woody.linux-foundation.org>
	(Linus Torvalds's message of "Thu, 15 Feb 2007 11:02:32 -0800 (PST)")
Message-ID: <871wkmgsf7.fsf@javad.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
> On Thu, 15 Feb 2007, Sergei Organov wrote:
>> 
>> I agree that if the warning has no true positives, it sucks. The problem
>> is that somehow I doubt it has none. And the reasons for the doubt are:
>
> Why do you harp on "no true positives"?

Because if somebody is capable to proof a warning has no true positives,
I immediately agree it's useless. I just wanted to check if it's indeed
the case. It seems it is not.

> That's a pointless thing. You can make *any* warning have "true 
> positives". My personal favorite is the unconditional warning:
>
> 	warning: user is an idiot
>
> and I _guarantee_ you that it has a lot of true positives.

Yes, but there is obviously 0 correlation between the warning and the
user being an idiot (except that non-idiot will probably find a way to
either turn this warning off, or filter it out).

I already agreed that a warning may have true positives and still be
bad; and a warning having "no false negatives" is obviously a pretty
one, though unfortunately not that common in practice; and a warning
that has no true positives is useless. What we are arguing about are
intermediate cases that are most common in practice.

As programmers, we in fact are interested in correlation between a
warning and actual problem in the software, but for the kind of warnings
we are discussing (sign-correctness and type-safety in general), the
correlation depends on the style the program is written is, making it
difficult to use as a criteria in the discussion.

> It's the "no false negatives" angle you should look at.

I'd like to, but then I'll need to classify most of (all?) the GCC
warnings as bad, I'm afraid.

> THAT is what matters. The reason we don't see a lot of warnings about 
> idiot users is not that people don't do stupid things, but that 
> *sometimes* they actually don't do something stupid.
>
> Yeah, I know, it's far-fetched, but still.
>
> In other words, you're barking up *exactly* the wrong tree. You're looking 
> at it the wrong way around.
>
> Think of it this way: in science, a theory is proven to be bad by a single 
> undeniable fact just showing that it's wrong.
>
> The same is largely true of a warning. If the warning sometimes happens 
> for code that is perfectly fine, the warning is bad.

Consider:

int find_first_zero(const int *a)
{
	int index = 0;
	while(*a++ != 0)
		index++;
	return index;
}

unsigned int array[] = { 1, 2, 3, 0, 25, 14 };
int index = find_first_zero(array);  *WARNING*

So, by your logic, -Wpointer-sign warning is bad in general? If not,
then how will you "fix" the code above? And the upside of the fix is
what?

IMHO, the "problem" is that this warning is about violation of type
safety. Type safety by itself doesn't guarantee the code is perfectly
fine. Violation of type safety doesn't necessarily mean the code is
broken. A warning that warns about violation of type safety has the same
properties.  Now, it's up to you to decide if you want warnings on type
safety or not.

What you are saying, on the other hand, for me reads like this: "I do
want warnings on violations of type safety in general, except for
"signed char" or "unsigned char" being used instead of "char"". I think
I do understand your reasons, -- I just don't agree with them.

-- Sergei.
