Return-Path: <linux-kernel-owner+w=401wt.eu-S966094AbXBOQi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966094AbXBOQi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 11:38:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966099AbXBOQi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 11:38:58 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:54397 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966094AbXBOQi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 11:38:57 -0500
Date: Thu, 15 Feb 2007 19:37:04 +0300
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
Message-ID: <20070215163704.GA32609@2ka.mipt.ru>
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org> <20070215133550.GA29274@2ka.mipt.ru> <Pine.LNX.4.64.0702150757520.20368@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702150757520.20368@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.7.5 (2ka.mipt.ru [0.0.0.0]); Thu, 15 Feb 2007 19:37:11 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 08:09:54AM -0800, Linus Torvalds (torvalds@linux-foundation.org) wrote:
> > > In other words, the "let user space sort out the complexity" is not a good 
> > > answer. It just means that the interface is badly designed.
> > 
> > Well, if we can setup iocb structure, why we can not setup syslet one?
> 
> (I'm cutting wildly, to try to get to the part I wanted to answer)
> 
> I actually think aio_read/write() and friends are *horrible* interfaces.
> 
> Here's a quick question: how many people have actually ever seen them used 
> in "normal code"? 

Agree, existing AIO interface is far from ideal IMO, but it is used. No
matter if it is normal or not, AIO itself is not normal interface -
there are no books about POSIX AIO, so no one knows about AIO at all.

> Yeah. Nobody uses them. They're not all that portable (even within unixes 
> they aren't always there, much less in other places), they are fairly 
> obscure, and they are just not really easy to use.
> 
> Guess what? The same is going to be true *in*spades* for any Linux- 
> specific async system call thing.
> 
> This is why I think simplicity of use along with transparency, is so 
> important. I think "aio_read()" is already a nasty enough interface, and 
> it's sure more portable than any Linux-specific extension will be (only 
> until the revolution comes, of course - at that point, everybody who 
> doesn't use Linux will be up against the wall, so we can solve the problem 
> that way).
> 
> So a Linux-specific extension needs to be *easier* to use or at least 
> understand, and have *more* obvious upsides than "aio_read()" has. 
> Otherwise, it's pointless - nobody is really going to use it.

Userspace_API_is_the_ever_possible_last_thing_to_ever_think_about. Period
. // <- wrapped one

If system is designed that with API changes it breaks - that system sucks 
wildly and should be thrown away. Syslets do not suffer from that.

We can have tons of interfaces any alien would be happy with (imho it is
not even kernel's task at all) - new table of syscalls the way usual ones 
are used for example. 
And we will have async_stat() exactly the same way people would use that.

It is not even a thing to discus. There are other technical issues with
syslets yet to resolve. If people do happy with design of the system, it
is time to think about how it will look from user's point of view.

syslet(__NR_stat) -> async_stat() - say it and Ingo and other developers
will think about how to implement that or start to discuss that it is
bad interface, and instead something else should be invented.

If interface sucks and _interface_ must be changed/extended/replaced.
If overall design sucks and it must be changed.

Solve problems one-by-one, not throwing something just because it uses
wild interface which can be changed in a minute.

> This is why I think the main goals should be:
> 
>  - the *internal* kernel goal of trying to replace some very specific 
>    aio_read() etc code with somethign more maintainable.
> 
>    This is really a maintainability argument, nothing more. Even if we 
>    never do anything *but* aio_read() and friends, if we can avoid having 
>    the VFS code have multiple code-paths and explicit checks for AIO, and 
>    instead handle it more "automatically", I think it is already worth it.
> 
>  - add extensions that people *actually*can*use* in practice.
> 
>    And this is where "simple interfaces" comes in.

There is absolutely _NO_ problem in having any interface people will use.
What one will you?
async_stat() instead of syslet(complex_struct_blah_sync)?
No problem - it is _really_ trivial to implement.
Ingo mentioned that it should be done, and it is really simple task for
glibc just like it is done for usual syscalls, which has completely nothing 
with overall system design at all.

> > So there is no point in 'complex setup and overhead', but there is
> > a. limit of the AIO (although my point is not to have huge amount of
> > 	working threads - they were created by people who can not
> > 	program state machines (c) Alan Cox)
> > b. possibility to implement a state machine (in current form likely will
> > 	not be used except maybe some optional hints for IO tasks like
> > 	fadvice)
> > c. in all other ways it has all pros and cons of micro-thread design (it
> > 	looks neat and simple, although is utterly broken in some usage
> > 	cases).
> 
> I don't think the "atom" approach is bad per se. I think it could be fine 
> to have some state information in user space. It's just that I think 
> complex interfaces that people largely won't even use is a big mistake. We 
> should concentrate on usability first, and some excessive cleverness 
> really isn't a big advantage.
> 
> Being able to do a "open + stat" looks like a fine thing. But I doubt 
> you'll see a lot of other combinations.

Then no problem. 

Interface does suck, especially since it does not allow to forbid some
syscalls from async execution, but it is just a brick which allows to
build really good system of it.

I personally vote for table of async syscalls transferred into 
human-readable aliases like async_stat() and the like.

> 		Linus

-- 
	Evgeniy Polyakov
