Return-Path: <linux-kernel-owner+w=401wt.eu-S1760050AbXEaJDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050AbXEaJDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 05:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbXEaJDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 05:03:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46884 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755089AbXEaJDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 05:03:45 -0400
Date: Thu, 31 May 2007 11:02:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Ulrich Drepper <drepper@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
Message-ID: <20070531090252.GA29817@elte.hu>
References: <20070530072055.GA3077@elte.hu> <465D286E.2080807@redhat.com> <20070530084252.GA15708@elte.hu> <Pine.LNX.4.64.0705301148150.6272@alien.or.mcafeemobile.com> <alpine.LFD.0.98.0705301254210.26602@woody.linux-foundation.org> <465DE992.6070803@redhat.com> <alpine.LFD.0.98.0705301422230.26602@woody.linux-foundation.org> <Pine.LNX.4.64.0705301443340.6272@alien.or.mcafeemobile.com> <alpine.LFD.0.98.0705301457350.26602@woody.linux-foundation.org> <20070531061303.GA4436@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531061303.GA4436@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> it's both a flexibility and a speedup thing as well:
> 
> flexibility: for libraries to be able to open files and keep them open 
> comes up regularly. For example currently glibc is quite wasteful in a 
> number of common networking related functions (Ulrich, please correct 
> me if i'm wrong), which could be optimized if glibc could just keep a 
> netlink channel fd open and could poll() it for changes and cache the 
> results if there are no changes (or something like that).
> 
> speedup: i suggested O_ANY 6 years ago as a speedup to Apache - 
> non-linear fds are cheaper to allocate/map:
> 
>   http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg23820.html
> 
> (i definitely remember having written code for that too, but i cannot 
> find that in the archives. hm.) In theory we could avoid _all_ 
> fd-bitmap overhead as well and use a per-process list/pool of struct 
> file buffers plus a maximum-fd field as the 'non-linear fd allocator' 
> (at the price of only deallocating them at process exit time).

to measure this i've written fd-scale-bench.c:

   http://redhat.com/~mingo/fd-scale-patches/fd-scale-bench.c

which tests the (cache-hot or cache-cold) cost of open()-ing of two fds 
while there are N other fds already open: one is from the 'middle' of 
the range, one is from the end of it.

Lets check our current 'extreme high end' performance with 1 million 
fds. (which is not realistic right now but there certainly are systems 
with over a hundred thousand open fds). Results from a fast CPU with 2MB 
of cache:

 cache-hot:

 # ./fd-scale-bench 1000000 0
 checking the cache-hot performance of open()-ing 1000000 fds.
 num_fds: 1, best cost: 1.40 us, worst cost: 2.00 us
 num_fds: 2, best cost: 1.40 us, worst cost: 1.40 us
 num_fds: 3, best cost: 1.40 us, worst cost: 2.00 us
 num_fds: 4, best cost: 1.40 us, worst cost: 1.40 us
 ...
 num_fds: 77117, best cost: 1.60 us, worst cost: 2.00 us
 num_fds: 96397, best cost: 2.00 us, worst cost: 2.20 us
 num_fds: 120497, best cost: 2.20 us, worst cost: 2.40 us
 num_fds: 150622, best cost: 2.20 us, worst cost: 3.00 us
 num_fds: 188278, best cost: 2.60 us, worst cost: 3.00 us
 num_fds: 235348, best cost: 2.80 us, worst cost: 3.80 us
 num_fds: 294186, best cost: 3.40 us, worst cost: 4.20 us
 num_fds: 367733, best cost: 4.00 us, worst cost: 5.00 us
 num_fds: 459667, best cost: 4.60 us, worst cost: 6.00 us
 num_fds: 574584, best cost: 5.60 us, worst cost: 8.20 us
 num_fds: 718231, best cost: 6.40 us, worst cost: 10.00 us
 num_fds: 897789, best cost: 7.60 us, worst cost: 11.80 us
 num_fds: 1000000, best cost: 8.20 us, worst cost: 9.60 us

 cache-cold:

 # ./fd-scale-bench 1000000 1
 checking the performance of open()-ing 1000000 fds.
 num_fds: 1, best cost: 4.60 us, worst cost: 7.00 us
 num_fds: 2, best cost: 5.00 us, worst cost: 6.60 us
 ...
 num_fds: 77117, best cost: 5.60 us, worst cost: 7.40 us
 num_fds: 96397, best cost: 5.60 us, worst cost: 7.40 us
 num_fds: 120497, best cost: 6.20 us, worst cost: 6.80 us
 num_fds: 150622, best cost: 6.40 us, worst cost: 7.60 us
 num_fds: 188278, best cost: 6.80 us, worst cost: 9.20 us
 num_fds: 235348, best cost: 7.20 us, worst cost: 8.80 us
 num_fds: 294186, best cost: 8.00 us, worst cost: 9.40 us
 num_fds: 367733, best cost: 8.80 us, worst cost: 11.60 us
 num_fds: 459667, best cost: 9.20 us, worst cost: 12.20 us
 num_fds: 574584, best cost: 10.00 us, worst cost: 12.40 us
 num_fds: 718231, best cost: 11.00 us, worst cost: 13.40 us
 num_fds: 897789, best cost: 12.80 us, worst cost: 15.80 us
 num_fds: 1000000, best cost: 13.60 us, worst cost: 15.40 us

we are pretty good at the moment: the open() cost starts to increase at 
around 100K open fds, both in the cache-cold and cache-hot case. (that 
roughly corresponds to the fd bitmap falling out of the 32K L1 cache) At 
1 million fds our fd bitmap has a size of 128K when there are 1 million 
fds open in a single process.

so while it's certainly not 'urgent' to improve this, private fds are an 
easier target for optimizations in this area, because they dont have the 
continuity requirement anymore, so the fd bitmap is not a 'forced' 
property of them.

	Ingo
