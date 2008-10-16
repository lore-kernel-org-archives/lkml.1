Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbYJPW56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbYJPW56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 18:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755846AbYJPW5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 18:57:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754233AbYJPW5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 18:57:47 -0400
Date: Thu, 16 Oct 2008 15:57:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Becky Bruce <becky.bruce@freescale.com>
Subject: Re: [git pull] core kernel updates for v2.6.28
In-Reply-To: <c62985530810161543q23f9ae75jb08ff986a214da0@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0810161548520.3288@nehalem.linux-foundation.org>
References: <20081015125023.GA6702@elte.hu>  <alpine.LFD.2.00.0810161518320.3288@nehalem.linux-foundation.org> <c62985530810161543q23f9ae75jb08ff986a214da0@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 17 Oct 2008, Frédéric Weisbecker wrote:
>
> 2008/10/17 Linus Torvalds <torvalds@linux-foundation.org>:
> > The fact is, that second argument was a "ptrdiff_t", which is neither
> > "int" nor "long".  It should be "%td" I think. But the thing is, when you
> > fix a warning, you should damn well know what the hell you're doing, not
> > just shut it up.
> 
> Sorry, I made some falses assumptions about the printed type I guess...

Well, the thing is, on 32-bit x86, ptrdiff_t is "int". And on 64-bit, it's 
"long". And on some (most?) other architectures, it's "long" regardless of 
whether it's 32-bit or 64-bit.

So you fixed a warnign on x86-32, but you introduced it just about 
everywhere else.

And it so happens that the old use of "%ld" was better than "%d", because 
regardless of the exact type of ptrdiff_t, with gcc it is essentially 
always going to be at least the same _size_ as "long". IOW, even when it's 
"int", it will always print out correctly with "%ld", despite the format 
warning. IOW, the type may be "wrong" from a C standards standpoint, but 
it will work in practice.

In contrast, using "%d" can actually print it out wrong, because it will 
be literally the wrong physical size, not just a type issue on a C level. 
So depending on calling conventions, you might end up with the upper bits 
cleared, or even the wrong bits printed out.

Using "%td" is always right, assuming the underlying printing library is 
recent enough to know about it. And the kernel has known about %td for the 
last three years.

			Linus
