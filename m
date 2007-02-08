Return-Path: <linux-kernel-owner+w=401wt.eu-S1423446AbXBHViH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423446AbXBHViH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 16:38:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423444AbXBHViG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 16:38:06 -0500
Received: from smtp.osdl.org ([65.172.181.24]:40826 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423446AbXBHViE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 16:38:04 -0500
Date: Thu, 8 Feb 2007 13:37:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
In-Reply-To: <Pine.LNX.4.61.0702082202180.24888@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.64.0702081324090.8424@woody.linux-foundation.org>
References: <45CB3B28.60102@garzik.org> <Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702082202180.24888@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Feb 2007, Jan Engelhardt wrote:
> 
> Thank you for this insight, I don't usually read standards, only RFCs :)
> Uh, does that also apply to the longer types, int, long etc.? I hope not.

No. An "int" or "long" is always signed.

But bitfields, enums or "char" can - and do - have signedness that depends 
on the architecture and/or compiler writers whims.

So if you do

	enum my_enum {
		orange = 1,
		blue = 2,
		green = 3
	};

you don't know if "enum my_enum" is signed or not. The compiler could 
decide to use "int". Or it could decide to use "unsigned char" for it. You 
simply don't know.

Same goes for

	struct dummy {
		int flag:1;
	} a_variable;

which could make "a_variable.d" be either signed or unsigned. In the 
absense of an explicit "signed" or "unsigned" by the programmer, you 
really won't even _know_ whether "flag" can contain the values {0,1} or 
{-1,0}.

Normally you wouldn't ever even care. A one-bit bitfield would only ever 
really be tested against 0, but it really is possible that when you assign 
"1" to that value, and read it back, it will read back -1. Try it. 

Those are the three only types I can think of, but the point is, they 
really don't have any standard-defined sign. It's up to the compiler. 

Now, passing a "pointer to bitfield" is impossible, and if you pass a 
pointer to an enum you'd better *always* use the same enum anyway (because 
not only is the signedness implementation-defined, the _size_ of the enum 
is also implementation-defined), so in those two cases, -Wpointer-sign 
doesn't hurt.

But in the case of "char", it really is insane. It's doubly insane exactly 
because the C standard defines a lot of standard functions that take "char 
*", and that make tons of sense with unsigned chars too, and you may have 
100% good reasons to use "unsigned char" for many of them.

> >It really is that simple. gcc is broken. The C language isn't, it's purely 
> >a broken compiler issue.
> 
> Maybe you could send in a patch to gcc that fixes the issue?

I've butted heads with too many broken gcc decisions. I've occasionally 
used to try to discuss these kinds of things on the gcc mailing lists, but 
I got too fed up with language lawyers that said "the standard _allows_ us 
to be total *ssholes, so stop complaining". It seemed to be an almost 
universal defense.

(And yes, the standard allows any warnings at all. So technically, gcc can 
warn about whatever hell it wants. It doesn't make it a good idea).

			Linus
