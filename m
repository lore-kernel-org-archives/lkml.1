Return-Path: <linux-kernel-owner+w=401wt.eu-S1751031AbXBMUYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751031AbXBMUYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 15:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751032AbXBMUY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 15:24:29 -0500
Received: from smtp.osdl.org ([65.172.181.24]:51761 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbXBMUY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 15:24:28 -0500
Date: Tue, 13 Feb 2007 12:24:09 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sergei Organov <osv@javad.com>
cc: =?ISO-8859-1?Q?J=2EA=2E_Magall=C3=C3=C3=C3=C2=B3n?= 
	<jamagallon@ono.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
In-Reply-To: <87odnxn80u.fsf@javad.com>
Message-ID: <Pine.LNX.4.64.0702131212120.3604@woody.linux-foundation.org>
References: <45CB3B28.60102@garzik.org> <Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
 <20070208221317.5beedaeb@werewolf-wl> <Pine.LNX.4.64.0702081338010.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081351410.8424@woody.linux-foundation.org>
 <87abznsdyo.fsf@javad.com> <Pine.LNX.4.64.0702090753500.8424@woody.linux-foundation.org>
 <874pprr5nn.fsf@javad.com> <Pine.LNX.4.64.0702120804520.8424@woody.linux-foundation.org>
 <87ps8end9b.fsf@javad.com> <Pine.LNX.4.64.0702131121590.3604@woody.linux-foundation.org>
 <87odnxn80u.fsf@javad.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Feb 2007, Sergei Organov wrote:

> > Exactly because "char" *by*definition* is "indeterminate sign" as far as 
> > something like "strlen()" is concerned.
> 
> Thanks, I now understand that you either don't see the difference
> between "indeterminate" and "implementation-defined" in this context or
> consider it non-essential, so I think I've got your point.

The thing is, "implementation-defined" does actually matter when you can 
_depend_ on it.

For example, there's a *huge* difference between "undefined" and 
"implementation-defined". A program can actually depend on something like

	char c = 0x80;

	if (c < 0)
		..

always having the *same* behaviour for a particular compiler (with a 
particular set of compile flags - some compilers have flags to change the 
sign behaviour).

So yes, there "implementation defined" actually has a real and worthwhile 
meaning. It is guaranteed to have _some_ semantics within the confines of 
that program, and they are defined to be consistent (again, within the 
confines of that particular program).

So I agree that "implementation defined" doesn't always mean 
"meaningless".

BUT (and this is a big but) within the discussion of "strlen()", that is 
no longer true. "strlen()" exists _outside_ of a single particular 
implementation. As such, "implementation-defined" is no longer something 
that "strlen()" can depend on.

As an example of this argument, try this:

	#include <string.h>
	#include <stdio.h>

	int main(int argc, char **argv)
	{
		char a1[] = { -1, 0 }, a2[] = { 1, 0 };

		printf("%d %d\n", a1[0] < a2[0], strcmp(a1, a2) < 0);
		return 0;
	}

and *before* you compile it, try to guess what the output is.

And when that confuses you, try to compile it using gcc with the 
"-funsigned-char" flag (or "-fsigned-char" if you started out on an 
architecture where char was unsigned by default)

And when you really *really* think about it afterwards, I think you'll go 
"Ahh.. Linus is right". It's more than "implementation-defined": it really 
is totally indeterminate for code like this.

(Yeah, the above isn't "strlen()", but it's an even subtler issue with 
EXACTLY THE SAME PROBLEM! And one where you can actually see the _effects_ 
of it)

			Linus
