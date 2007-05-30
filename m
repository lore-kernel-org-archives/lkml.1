Return-Path: <linux-kernel-owner+w=401wt.eu-S1755839AbXE3PTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbXE3PTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 11:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbXE3PTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 11:19:04 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753613AbXE3PTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 11:19:01 -0400
Date: Wed, 30 May 2007 08:16:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Ulrich Drepper <drepper@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       Zach Brown <zach.brown@oracle.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
In-Reply-To: <20070530084252.GA15708@elte.hu>
Message-ID: <alpine.LFD.0.98.0705300806400.26602@woody.linux-foundation.org>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org>
 <20070530072055.GA3077@elte.hu> <465D286E.2080807@redhat.com>
 <20070530084252.GA15708@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 May 2007, Ingo Molnar wrote:
>
> * Ulrich Drepper <drepper@redhat.com> wrote:
> > 
> > I'm not going to judge your tests but saying there are no significant 
> > advantages is too one-sided.  There is one huge advantage: the 
> > interface.  A memory-based interface is simply the best form.  File 
> > descriptors are a resource the runtime cannot transparently consume.
> 
> yeah - this is a fundamental design question for Linus i guess :-)

Well, quite frankly, to me, the most important part of syslets is that if 
they are done right, they introduce _no_ new interfaces at all that people 
actually use.

Over the years, we've done lots of nice "extended functionality" stuff. 
Nobody ever uses them. The only thing that gets used is the standard stuff 
that everybody else does too.

So when it comes to syslets, the most important interface will be the 
existing aio_read() etc interfaces _without_ any in-memory stuff at all, 
and everything done by the kernel to just make it look exactly like it 
used to look. And the biggest advantage is that it simplifies the internal 
kernel code, and makes us use the same code for aio and non-aio (and I 
think we have a good possibility of improving performance too, if only 
because we will get much more natural and fine-grained scheduling points!)

Any extended "direct syslets" use is technically _interesting_, but 
ultimately almost totally pointless. Which was why I was pushing really 
really hard for a simple interface and not being too clever or exposing 
internal designs too much. An in-memory thing tends to be the absolute 
_worst_ interface when it comes to abstraction layers and future changes.

> glibc (and other infrastructure libraries) have a fundamental problem: 
> they cannot (and do not) presently use persistent file descriptors to 
> make use of kernel functionality, due to ABI side-effects.

glibc has a more fundamental problem: the "fun" stuff is generally not 
worth it. 

For example, any AIO thing that requires glibc to be rewritten is almost 
totally uninteresting. It should work with _existing_ binaries, and 
_existing_ ABI's to be useful - since 99% of all AIO users are binary- 
only and won't recompile for some experimental library.

The whole epoll/kevent flame-wars have ignored a huge issue: almost nobody 
uses either. People still use poll and select, to such an _overwhelming_ 
degree that it almost doesn't even matter if you were to make the 
alternatives orders of magnitude faster - it wouldn't even be visible. 

> we should perhaps enable glibc to have its separate fd namespace (or 
> 'hidden' file descriptors at the upper end of the fd space) so that it 
> can transparently listen to netlink events (or do epoll), without 
> impacting the application fd namespace - instead of ducking to a memory 
> based API as a workaround.

Yeah, I don't think it would be at all wrong to have "private file 
descriptors". I'd prefer that over memory-based (for all the abstraction 
issues, and because a lot of things really *are* about file descriptors!). 

		Linus
