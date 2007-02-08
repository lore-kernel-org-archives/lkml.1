Return-Path: <linux-kernel-owner+w=401wt.eu-S1422679AbXBHXh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422679AbXBHXh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 18:37:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422709AbXBHXhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 18:37:55 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45419 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422679AbXBHXhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 18:37:54 -0500
Date: Thu, 8 Feb 2007 15:37:38 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
In-Reply-To: <Pine.LNX.4.64.0702081432320.27603@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0702081528070.8424@woody.linux-foundation.org>
References: <45CB3B28.60102@garzik.org> <Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702082202180.24888@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081324090.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081432320.27603@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Feb 2007, David Rientjes wrote:
> 
> And a compiler that makes a_variable.flag unsigned would be brain-dead 
> because "int" is always signed.

No, making bitfields unsigned is actually usually a good idea. It allows 
you to often generate better code, and it actually tends to be what 
programmers _expect_. A lot of people seem to be surprised to hear that a 
one-bit bitfield actually often encodes -1/0, and not 0/1.

So unsigned bitfields are not only traditional K&R, they are also usually 
_faster_ (which is probably why they are traditional K&R - along with 
allowing "char" to be unsigned by default). Don't knock them.  It's much 
better to just remember that bitfields simply don't _have_ any standard 
sign unless you specify it explicitly, than saying "it should be signed 
because 'int' is signed".

I will actually argue that having signed bit-fields is almost always a 
bug, and that as a result you should _never_ use "int" at all. Especially 
as you might as well just write it as

	signed a:1;

if you really want a signed bitfield.

So I would reall yrecommend that you never use "int a:<bits>" AT ALL, 
because there really is never any good reason to do so. Do it as

	unsigned a:3;
	signed b:2;

but never 

	int c:4;

because the latter really isn't sensible.

"sparse" will actually complain about single-bit signed bitfields, and it 
found a number of cases where people used that "int x:1" kind of syntax. 

Just don't do it.

			Linus
