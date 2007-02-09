Return-Path: <linux-kernel-owner+w=401wt.eu-S1423085AbXBIAYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423085AbXBIAYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 19:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423078AbXBIAYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 19:24:22 -0500
Received: from smtp-out.google.com ([216.239.45.13]:20768 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423085AbXBIAYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 19:24:20 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=kqG7KiqPau2hSk8Cq+ELh8tnr7mRfJ4petR+47+LD2EO/FCRKHLc0A2XK2QrWtFtH
	FG/IK77msKdOk4Uqgaz8A==
Date: Thu, 8 Feb 2007 16:24:00 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
In-Reply-To: <Pine.LNX.4.64.0702081528070.8424@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702081554380.29559@chino.kir.corp.google.com>
References: <45CB3B28.60102@garzik.org> <Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702082202180.24888@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081324090.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081432320.27603@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0702081528070.8424@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007, Linus Torvalds wrote:

> No, making bitfields unsigned is actually usually a good idea. It allows 
> you to often generate better code, and it actually tends to be what 
> programmers _expect_. A lot of people seem to be surprised to hear that a 
> one-bit bitfield actually often encodes -1/0, and not 0/1.
> 

Your struct:

	struct dummy {
		int flag:1;
	} a_variable;

should expect a_varible.flag to be signed, that's what the int says.  
There is no special case here with regard to type.  It's traditional K&R 
that writing signed flag:1 here is redundant (K&R pg. 211).  Now whether 
that's what you wanted or not is irrelevant.  As typical with C, it gives 
you exactly what you asked for.

You're arguing for inconsistency in how bitfields are qualified based on 
their size.  If you declare a bitfield as int byte:8, then you're going 
to expect this to behave exactly like a signed char, which it does.

	struct {
		int byte:8;
	} __attribute__((packed)) b_variable;

b_variable.byte is identical to a signed char.

Just because a_variable.flag happens to be one bit, you cannot say that 
programmers _expect_ it to be unsigned, or you would also expect 
b_variable.byte to act as an unsigned char.  signed is the default 
behavior for all types besides char, so the behavior is appropriate based 
on what most programmers would expect.

> So unsigned bitfields are not only traditional K&R, they are also usually 
> _faster_ (which is probably why they are traditional K&R - along with 
> allowing "char" to be unsigned by default). Don't knock them.  It's much 
> better to just remember that bitfields simply don't _have_ any standard 
> sign unless you specify it explicitly, than saying "it should be signed 
> because 'int' is signed".
> 

Of course they're faster, it doesn't require the sign extension.  But 
you're adding additional semantics to the language by your interpretation 
of what is expected by the programmer in the bitfield case as opposed to a 
normal variable definition.

> I will actually argue that having signed bit-fields is almost always a 
> bug, and that as a result you should _never_ use "int" at all. Especially 
> as you might as well just write it as
> 
> 	signed a:1;
> 
> if you really want a signed bitfield.
> 

How can signed bitfields almost always be a bug?  I'm the programmer and I 
want to store my data in a variable that I define, so I must follow the 
twos-complement rule and allot a sign bit if I declare it as a signed 
value.  In C, you do this with "int"; otherwise, you use "unsigned".

> So I would reall yrecommend that you never use "int a:<bits>" AT ALL, 
> because there really is never any good reason to do so. Do it as
> 
> 	unsigned a:3;
> 	signed b:2;
> 
> but never 
> 
> 	int c:4;
> 
> because the latter really isn't sensible.
> 

That _is_ sensible because anything you declare "int" is going to be 
signed as far as gcc is concerned.  "c" just happens to be 4-bits wide 
instead of 32.  But for everything else, it's the same as an int.  I know 
exactly what I'm getting by writing "int c:4", as would most programmers 
who use bitfields to begin with.

		David
