Return-Path: <linux-kernel-owner+w=401wt.eu-S965138AbXBQKWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965138AbXBQKWX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 05:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965139AbXBQKWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 05:22:23 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:33178 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965138AbXBQKWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 05:22:22 -0500
Date: Sat, 17 Feb 2007 13:15:07 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20070217101502.GB15971@2ka.mipt.ru>
References: <20070215181059.GC20997@2ka.mipt.ru> <Pine.LNX.4.64.0702151019210.20368@woody.linux-foundation.org> <20070215190413.GA23953@2ka.mipt.ru> <Pine.LNX.4.64.0702151120260.20368@woody.linux-foundation.org> <20070216085706.GA22868@2ka.mipt.ru> <Pine.LNX.4.64.0702160753120.20368@woody.linux-foundation.org> <20070216160525.GA21160@2ka.mipt.ru> <2c0942db0702160853s18f650ccsa7270c047d94a41b@mail.gmail.com> <20070216165854.GA18522@2ka.mipt.ru> <45D68A73.90707@madrabbit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <45D68A73.90707@madrabbit.org>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Sat, 17 Feb 2007 13:15:49 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 08:54:11PM -0800, Ray Lee (ray-lk@madrabbit.org) wrote:
> (This is probably why, by the way, most people are staying silent on
> your excellent kevent work. The kernel side is, in some ways, the easy
> part. It's getting an interface that will handle all users [ users ==
> producers and consumers of kevents ], that is the hard bit.)

Kevent interface was completely changed 4 (!) times for the last year 
after kernel developers request without any damage to its kernel part.

> Or, let me put it yet another way: How do you prove to the rest of us
> that you, or Ingo, or whomever, are not building another dnotify? (Maybe
> you're smart enough in this problem space that you know you're not --
> that's actually the most likely possibility. But you still have to prove
> it to the rest of us. Sucks, I know.)

I only want to say that when system is designed correctly there is no
problem to change interface (yes, I again said 'to change' just because
I hope everyone understand that I'm talking about time when system is
not yet committed to the tree).

Btw, dnotify had problems in its design highlighted at inotify statrt -
mainly that watchers were not attached to inode.

It is right now the time to ask users what interface they expect from
AIO - so I asked Linus and proposed three different ones, two of them
were designed in a way that user would not even know that some
allocation/freeing was done - and as a result I got 'you suck' response
exactly the same as was returned on the first syslet release - just
_anly_ fscking _just_ because it had ugly interface.

> > Situations when system is designed from interface down to system ends up
> > with one thread per IO and huge limitations on how system is going to be
> > used at all.
> 
> The other side is you start from the goal in mind and get Ingo's state
> machines with loops and conditionals and marmalade in syslets which
> appear a bit baroque and overkill for the majority of us userspace folk.

Well, I designed kevent AIO in the similar way, but it has even more
complex one which is built on top of internal page population functions.

It is complex a bit, but it works fast. And it works with any type (if I
would not be lazy and implement bindings) of AIO.

Interface of syslets is not perfect, but it can be changed (I said it
again? I think we all understand what I mean by that already) trivially
right now (before it is included) - it is not the way to throw thing
just because it has bad interface which can be extended in a moment.

> (No offense intended to Ingo, he's obviously quite a bit more conversant
> on the needs of high speed interfaces than I am. However, I suspect I
> have a bit more clarity on what us normal folk would actually use, and
> kernel driven FSMs ain't it. Userspace often makes a lot of contextual
> decisions that I would absolutely *hate* to write and debug as a state
> machine that gets handed off to the kernel. I'll happily take a 10% hit
> in efficiency that Moore's law will get me back in a few months, instead
> of spending a bunch of time debugging difficult heisenbugs due to the
> syslet FSM reading a userspace variable at a slightly different time
> once in a blue moon. OTOH, I'm also not Oracle, so what do I know?)
> 
> The truth of this lies somewhere in the middle. It isn't kernel driven,
> or userspace interface driven, but a tradeoff between the two.
> 
> So:
> 
> > Userspace_API_is_the_ever_possible_last_thing_to_ever_think_about.
> > Period
> 
> Please listen to those of us who are saying that this might not be the
> case. Maybe we're idiots, but then again maybe we're not, okay?
> Sometimes the API really *DOES* change the underlying implementation.

It is exactly the time to say what interface sould be good.
System is almost ready - it is time to make it looks cool for users.

> Ray

-- 
	Evgeniy Polyakov
