Return-Path: <linux-kernel-owner+w=401wt.eu-S966202AbXBPI6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966202AbXBPI6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 03:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966229AbXBPI6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 03:58:31 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:57799 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966202AbXBPI6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 03:58:30 -0500
Date: Fri, 16 Feb 2007 11:57:07 +0300
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
Message-ID: <20070216085706.GA22868@2ka.mipt.ru>
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org> <20070215133550.GA29274@2ka.mipt.ru> <Pine.LNX.4.64.0702150757520.20368@woody.linux-foundation.org> <20070215163704.GA32609@2ka.mipt.ru> <Pine.LNX.4.64.0702150920130.20368@woody.linux-foundation.org> <20070215181059.GC20997@2ka.mipt.ru> <Pine.LNX.4.64.0702151019210.20368@woody.linux-foundation.org> <20070215190413.GA23953@2ka.mipt.ru> <Pine.LNX.4.64.0702151120260.20368@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702151120260.20368@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.7.5 (2ka.mipt.ru [0.0.0.0]); Fri, 16 Feb 2007 11:57:17 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 11:28:57AM -0800, Linus Torvalds (torvalds@linux-foundation.org) wrote:
> THAT was the point. Interfaces are really really subtle and important. 
> It's absolutely not a case of "we can just write wrappers to fix up any 
> library issues".

Interfaces can be created and destroyed - they do not affect overall
system design in anyway (well, if they do, something is broken).
So let's solve problems in order of their appearence - if interfaces
are more important for you than overall design - that is a problem I think.

> > So instead there will be 
> > s = atom_create_and_add(__NR_stat, path, stat, NULL, NULL, NULL, NULL);
> > atom then can be freed in the glibc_async_wait() wrapper just before
> > returning data to userspace.
> 
> So now you add some kind of allocation/dealloction thing. In user space or 
> in the kernel?

In userspace.
It was not added by me - it is just a wrapper.

> > There are millions of possible ways to do that, but what exactly one
> > should be used from your point of view? Describe _your_ vision of that path.
> 
> My vision is that we should be able to do the simple things *easily* and 
> without any extra overhead.
> 
> And doing wrappers in user space is almost entirely unacceptable, becasue 
> a lot of the wrapping needs to be done at release time (for example: 
> de-allocating memory), and that means that you no longer can do simple 
> system calls that don't even need release notification AT ALL.

syslets do work that way - they require some user memory - likely
long-standing (100% sure for multi atom setup, maybe it can be optimized
though) - if you do not want to allocate it explicitly - it is possible
to have a wrapper.

> > Currently generic example is following:
> > allocate mem
> > setup complex structure
> > submit syscall
> > wait syscall
> > free mem
> 
> And that "allocate mem" and "free mem" is a problem. It's not just a 
> performance problem, it is a _complexity_ problem. It means that people 
> have to track things that they are NOT AT ALL INTERESTED IN!

I proposed a way to hide allocation - it is simple, but you've cut it.
I can create another one without special per-thread thing - 
handle = async_init();
async_stat(handle, path, stat);
async_cleanup(); // not needed, since will be freed on exit automatically

Another one is to preallocate set of atoms in __attribute((contructor))
function.

There are really a lot of possible ways - _I_ can use the first one with
explicit operations, others likely can not - so I _ask_ about how should
it look like.

> > So, describe how exactly _you_ think it should be implemented with its
> > pros and cons, so that systemn could be adopted without trying to
> > mind-read of what is simple and good or complex and really bad.
> 
> So I think that a good implementation just does everything up-front, and 
> doesn't _need_ a user buffer that is live over longer periods, except for 
> the actual results. Exactly because the whole alloc/teardown is nasty.
> 
> And I think a good implementation doesn't need wrapping in user space to 
> be useful - at *least* not wrapping at completion time, which is the 
> really difficult one (since, by definition, in an async world completion 
> is separated from the initial submit() event, and with kernel-only threads 
> you actually want to *avoid* having to do user code after the operation 
> completed).

So where is a problem?
I proposed already three ways to do the thing - user will not even know
about something happend. You did not comment on anyone, instead you
handwaving with talks about how in theory something should be similar
to. What exactly do _you_ expect from interface?

> I suspect Ingo's thing can do that. But I also suspect (nay, _know_, from 
> this discussion), that you didn't even think of the problems.

That is another problem - you think you know something, but you fail to
prove that. 

I can work with explicit structure allocation/deallocation/setup - 
you do not want that - so I ask you about your opinion, and instead of 
getting an answer I receive theoretical word-fall about how perfect 
interface should look like.

You only need to have one function call without ever thinking bout
freeing? I proposed _two_ ways to that.
You can live with explicit init/cleanup (opt) code? There is another
one.

So please decribe your vision of interface with details, so that it
could be think about or/and implemented.

> 		Linus

-- 
	Evgeniy Polyakov
