Return-Path: <linux-kernel-owner+w=401wt.eu-S1751438AbXBMXVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbXBMXVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 18:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbXBMXVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 18:21:30 -0500
Received: from smtp.osdl.org ([65.172.181.24]:60191 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbXBMXV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 18:21:29 -0500
Date: Tue, 13 Feb 2007 15:21:04 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sergei Organov <osv@javad.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       =?ISO-8859-1?Q?J=2EA=2E_Magall=C3=C3=C3=C2=B3n?= 
	<jamagallon@ono.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
In-Reply-To: <87fy99n6mf.fsf@javad.com>
Message-ID: <Pine.LNX.4.64.0702131513050.3604@woody.linux-foundation.org>
References: <45CB3B28.60102@garzik.org> <Pine.LNX.4.64.0702081338010.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081351410.8424@woody.linux-foundation.org>
 <87abznsdyo.fsf@javad.com> <Pine.LNX.4.64.0702090753500.8424@woody.linux-foundation.org>
 <874pprr5nn.fsf@javad.com> <Pine.LNX.4.64.0702120804520.8424@woody.linux-foundation.org>
 <87ps8end9b.fsf@javad.com> <84144f020702131026q2af1afd6vbcd2708d7b7b9907@mail.gmail.com>
 <87bqjxooog.fsf@javad.com> <84144f020702131143r767aa40blb97a39b40bee73b8@mail.gmail.com>
 <87fy99n6mf.fsf@javad.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Feb 2007, Sergei Organov wrote:
> 
> Sorry, what do you do with "variable 'xxx' might be used uninitialized"
> warning when it's false? Turn it off? Annotate the source? Assign fake
> initialization value? Change the compiler so that it does "the effort"
> for you? Never encountered false positive from this warning?

The thing is, that warning is at least easy to shut up. 

You just add a fake initialization. There isn't any real downside.

In contrast, to shut up the idiotic pointer-sign warning, you have to add 
a cast.

Now, some people seem to think that adding casts is a way of life, and 
think that C programs always have a lot of casts. That's NOT TRUE. It's 
actually possible to avoid casts, and good C practice will do that to 
quite a high degree, because casts in C are *dangerous*. 

A language that doesn't allow arbitrary type-casting is a horrible 
language (because it doesn't allow you to "get out" of the language type 
system), and typecasts in C are really important. But they are an 
important feature that should be used with caution, and as little as 
possible, because they (by design, of course) break the type rules.

Now, since the _only_ reason for the -Wpointer-sign warning in the first 
place is to warn about breaking type rules, if the way to shut it up is to 
break them EVEN MORE, then the warnign is obviously totally broken. IT 
CAUSES PEOPLE TO WRITE WORSE CODE! Which was against the whole point of 
having the warning in the first place.

This is why certain warnings are fine. For example, the warning about

	if (a=b)
		..

is obviously warning about totally valid C code, but it's _still_ a fine 
warning, because it's actually very easy to make that warning go away AND 
IMPROVE THE CODE at the same time. Even if you actually meant to write the 
assignment, you can write it as

	if ((a = b) != 0)
		..

or 

	a = b;
	if (a)
		..

both of which are actually more readable.

But if you have 

	unsigned char *mystring;

	len = strlen(mystring);

then please tell me how to fix that warning without making the code 
*worse* from a type-safety standpoint? You CANNOT. You'd have to cast it 
explicitly (or assing it through a "void *" variable), both of which 
actually MAKE THE TYPE-CHECKING PROBLEM WORSE!

See? The warning made no sense to begin with, and it warns about something 
where the alternatives are worse than what it warned about.

Ergo. It's a crap warning.

		Linus
