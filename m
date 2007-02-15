Return-Path: <linux-kernel-owner+w=401wt.eu-S966034AbXBOQQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966034AbXBOQQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 11:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966031AbXBOQQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 11:16:16 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50831 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966033AbXBOQQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 11:16:14 -0500
Date: Thu, 15 Feb 2007 08:09:54 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/11] syslets: core code
In-Reply-To: <20070215133550.GA29274@2ka.mipt.ru>
Message-ID: <Pine.LNX.4.64.0702150757520.20368@woody.linux-foundation.org>
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org>
 <20070215133550.GA29274@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Feb 2007, Evgeniy Polyakov wrote:
> > 
> > In other words, the "let user space sort out the complexity" is not a good 
> > answer. It just means that the interface is badly designed.
> 
> Well, if we can setup iocb structure, why we can not setup syslet one?

(I'm cutting wildly, to try to get to the part I wanted to answer)

I actually think aio_read/write() and friends are *horrible* interfaces.

Here's a quick question: how many people have actually ever seen them used 
in "normal code"? 

Yeah. Nobody uses them. They're not all that portable (even within unixes 
they aren't always there, much less in other places), they are fairly 
obscure, and they are just not really easy to use.

Guess what? The same is going to be true *in*spades* for any Linux- 
specific async system call thing.

This is why I think simplicity of use along with transparency, is so 
important. I think "aio_read()" is already a nasty enough interface, and 
it's sure more portable than any Linux-specific extension will be (only 
until the revolution comes, of course - at that point, everybody who 
doesn't use Linux will be up against the wall, so we can solve the problem 
that way).

So a Linux-specific extension needs to be *easier* to use or at least 
understand, and have *more* obvious upsides than "aio_read()" has. 
Otherwise, it's pointless - nobody is really going to use it.

This is why I think the main goals should be:

 - the *internal* kernel goal of trying to replace some very specific 
   aio_read() etc code with somethign more maintainable.

   This is really a maintainability argument, nothing more. Even if we 
   never do anything *but* aio_read() and friends, if we can avoid having 
   the VFS code have multiple code-paths and explicit checks for AIO, and 
   instead handle it more "automatically", I think it is already worth it.

 - add extensions that people *actually*can*use* in practice.

   And this is where "simple interfaces" comes in.

> So there is no point in 'complex setup and overhead', but there is
> a. limit of the AIO (although my point is not to have huge amount of
> 	working threads - they were created by people who can not
> 	program state machines (c) Alan Cox)
> b. possibility to implement a state machine (in current form likely will
> 	not be used except maybe some optional hints for IO tasks like
> 	fadvice)
> c. in all other ways it has all pros and cons of micro-thread design (it
> 	looks neat and simple, although is utterly broken in some usage
> 	cases).

I don't think the "atom" approach is bad per se. I think it could be fine 
to have some state information in user space. It's just that I think 
complex interfaces that people largely won't even use is a big mistake. We 
should concentrate on usability first, and some excessive cleverness 
really isn't a big advantage.

Being able to do a "open + stat" looks like a fine thing. But I doubt 
you'll see a lot of other combinations.

		Linus
