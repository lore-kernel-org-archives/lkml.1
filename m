Return-Path: <linux-kernel-owner+w=401wt.eu-S1030427AbXBOSMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030427AbXBOSMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 13:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030435AbXBOSMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 13:12:34 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:55380 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030427AbXBOSMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 13:12:33 -0500
Date: Thu, 15 Feb 2007 21:11:00 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20070215181059.GC20997@2ka.mipt.ru>
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org> <20070215133550.GA29274@2ka.mipt.ru> <Pine.LNX.4.64.0702150757520.20368@woody.linux-foundation.org> <20070215163704.GA32609@2ka.mipt.ru> <Pine.LNX.4.64.0702150920130.20368@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702150920130.20368@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.7.5 (2ka.mipt.ru [0.0.0.0]); Thu, 15 Feb 2007 21:11:03 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 09:42:32AM -0800, Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Thu, 15 Feb 2007, Evgeniy Polyakov wrote:
> > 
> > Userspace_API_is_the_ever_possible_last_thing_to_ever_think_about. Period
> > . // <- wrapped one
> 
> No, I really think you're wrong.
> 
> In many ways, the interfaces and especially data structures are *more* 
> important than the code.
> 
> The code we can fix. The interfaces, on the other hand, we'll have to live 
> with forever.
> 
> So complex interfaces that expose lots of implementation detail are not a 
> good thing, and it's _not_ the last thing you want to think about. Complex 
> interfaces with a lot of semantic knowledge seriously limit how you can 
> fix things up later.
> 
> In contrast, simple interfaces that have clear and unambiguous semantics 
> and that can be explained at a conceptual level are things that you can 
> often implement in many different ways. So the interface isn't the bottle 
> neck: you may have to have a "backwards compatibility layer" for it 

That's exaclt the way we should discuss it - you do ont like that
interface, but Ingo proposed a way to change that via table of async
syscalls - people asks, people answers - so eventually interface and (if
any) other problems got resolved.

> > If system is designed that with API changes it breaks - that system sucks 
> > wildly and should be thrown away. Syslets do not suffer from that.
> 
> The syslet code itself looks fine. It's the user-visible part I'm not 
> convinced about.
> 
> I'm just saying: how would use use this for existing programs?
> 
> For something this machine-specific, you're not going to have any big 
> project written around the "async atom" code. So realistically, the kinds 
> of usage we'd see is likely some compile-time configuration option, where 
> people replace some specific sequence of code with another one. THAT is 
> what we should aim to make easy and flexible, I think. And that is where 
> interfaces really are as important as code.
> 
> We know one interface: the current aio_read() one. Nobody really _likes_ 
> it (even database people would apparently like to extend it), but it has 
> the huge advantage of "being there", and having real programs that really 
> care that use it today. 
> 
> Others? We don't know yet. And exposing complex interfaces that may not be 
> the right ones is much *worse* than exposing simple interfaces (that 
> _also_ may not be the right ones, of course - but simple and 
> straightforward interfaces with obvious and not-very-complex semantics are 
> a lot easier to write compatibility layers for if the internal code 
> changes radically)

So we just need to describe the way we want to see new interface -
that's it.

Here is a stub for async_stat() - probably broken example, but that does
not matter - this interface is really easy to change.

static void syslet_setup(struct syslet *s, int nr, void *arg1...)
{
	s->flags = ...
	s->arg[1] = arg1;
	....
}

long glibc_async_stat(const char *path, struct stat *buf)
{
	/* What about making syslet and/or set of atoms per thread and preallocate 
	 * them when working threads are allocated? */
	struct syslet s;
	syslet_setup(&s, __NR_stat, path, buf, NULL, NULL, NULL, NULL);
	return async_submit(&s);
}

> 		Linus

-- 
	Evgeniy Polyakov
