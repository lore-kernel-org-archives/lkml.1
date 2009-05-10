Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbZEJURS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbZEJURS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 16:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbZEJURE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 16:17:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60288 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752711AbZEJURC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 16:17:02 -0400
Date: Sun, 10 May 2009 21:13:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, hannes@cmpxchg.org,
       linux-kernel@vger.kernel.org, tytso@mit.edu, linux-mm@kvack.org,
       elladan@eskimo.com, npiggin@suse.de, cl@linux-foundation.org,
       minchan.kim@gmail.com
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first
 class  citizen
Message-ID: <20090510211350.7aecc8de@lxorguk.ukuu.org.uk>
In-Reply-To: <4A06EA08.1030102@redhat.com>
References: <20090430181340.6f07421d.akpm@linux-foundation.org>
	<1241432635.7620.4732.camel@twins>
	<20090507121101.GB20934@localhost>
	<20090507151039.GA2413@cmpxchg.org>
	<20090507134410.0618b308.akpm@linux-foundation.org>
	<20090508081608.GA25117@localhost>
	<20090508125859.210a2a25.akpm@linux-foundation.org>
	<20090508230045.5346bd32@lxorguk.ukuu.org.uk>
	<2f11576a0905100159m32c36a9ep9fb7cc5604c60b2@mail.gmail.com>
	<1241946446.6317.42.camel@laptop>
	<2f11576a0905100236u15d45f7fm32d470776659cfec@mail.gmail.com>
	<20090510144533.167010a9@lxorguk.ukuu.org.uk>
	<4A06EA08.1030102@redhat.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Not only can it be abused but some systems such as java have large
> > PROT_EXEC mapped environments, as do many other JIT based languages.
> 
> On the file LRU side, or on the anon LRU side?

Generally anonymous so it would indeed be ok.

> > I still think the focus is on the wrong thing. We shouldn't be trying to
> > micro-optimise page replacement guesswork - we should be macro-optimising
> > the resulting I/O performance.
> 
> Any ideas on how to achieve that? :)

I know - vm is hard, and page out consists of making the best wrong
decision without having the facts.

Make your swap decisions depend upon I/O load on storage devices. Make
your paging decisions based upon writing and reading large contiguous
chunks (512K costs the same as 8K pretty much) - but you already know
that .

Historically BSD tackled some of this by actually swapping processes out
once pressure got very high - because even way back it actually became
cheaper at some point than spewing randomness at the disk drive. Plus it
also avoids the death by thrashing problem. Possibly however that means
the chunk size should relate to the paging rate ?

I get to watch what comes down the pipe from the vm, and it's not pretty,
especially when todays disk drive is more like swapping to a tape loop. I
can see how to fix anonymous page out (log structured swap) but I'm not
sure what that would do to anonymous page-in even with a cleaner.

At the block level it may be worth having a look what is going on in more
detail - the bigger queues and I/O sizes on modern disks (plus the
cache flushimng) also mean that the amount of time it can take a command
to the head and back to the OS has probably jumped a lot with newer SATA
devices - even if the block layer is getting them queued at the head of
the queue and promptly. I can give a disk 15 seconds of work quite easily
and possibly stuffing the disk stupid isn't the right algorithm when
paging is considered.

rpm -e gnome* and Arjan's ioprio hacks seem to fix my box but thats not a
general useful approach. I need to re-test the ioprio hacks with a
current kernel and see if the other I/O changes have helped.

Alan
