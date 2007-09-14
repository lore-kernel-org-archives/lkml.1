Return-Path: <linux-kernel-owner+w=401wt.eu-S1764206AbXINQBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764206AbXINQBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 12:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbXINQBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 12:01:31 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:43985 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbXINQBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 12:01:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nPWMk6qTfrEzLjLHTIyrCCLQT5xSg277poVs4bQsQiTYkblgEmzUNFzQJWmEqhwPeJFXowNBW1zaRDmPI/7zxfHzrBqs16M4d4gTKZdb81zo7PSHJ5inSI0PIz1Rx7ramRl01o75BZOEm8cI5Ea86nZ+fsg4h2jxHLH9jcNg1lQ=
Message-ID: <a781481a0709140901g5650a0dr35ae9348cb740814@mail.gmail.com>
Date: Fri, 14 Sep 2007 21:31:28 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Antoine Martin" <antoine@nagafix.co.uk>
Subject: Re: CFS: some bad numbers with Java/database threading
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Development" <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "David Schwartz" <davids@webmaster.com>
In-Reply-To: <a781481a0709140306k3faf3585haae26853fe81381c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46E871FE.9010908@nagafix.co.uk> <20070913112427.GA20686@elte.hu>
	 <20070914083246.GA20514@elte.hu>
	 <a781481a0709140306k3faf3585haae26853fe81381c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ Argh, just noticed this thread got broke and had been living a parallel
  life due to Subject: changes, dropped Cc:'s, and munged In-Reply-To:'s.
  Adding back all interested folk here. ]


> Hi Antoine, Ingo,
>
>
> On 9/14/07, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Ingo Molnar <mingo@elte.hu> wrote:
> >
> > > hm, could you try the patch below ontop of 2.6.23-rc6 and do:
> > >
> > >  echo 1 > /proc/sys/kernel/sched_yield_bug_workaround
> > >
> > > does this improve the numbers?
>
> Hmm, I know diddly about Java, and I don't want to preempt Antoine's next
> test, but I noticed that he uses Thread.sleep() in his testcode and not the
> Thread.yield() so it would be interesting if Antoine can test with this patch
> and report if something shows up ...

Ok, it appears Antoine tested with the patch and got:

http://devloop.org.uk/documentation/database-performance/Linux-Kernels/Kernels-ManyThreads-CombinedTests3-10msYield.png
http://devloop.org.uk/documentation/database-performance/Linux-Kernels/Kernels-ManyThreads-CombinedTests3-10msYield-withload.png

which leads me to believe this probably wasn't a yield problem after all, though
it would still be useful if someone with more knowledge of Java could give that
code a look over ...

Curiously, the -rc3 oddity is still plainly visible there -- how do we
explain that?
Ingo, does that oddity (and the commits that went in around -rc3 time) give some
clue as to the behaviour / characteristics of Antoine's workloads?


> > the patch i sent was against CFS-devel. Could you try the one below,
> > which is against vanilla -rc6, does it improve the numbers? (it should
> > have an impact) Keep CONFIG_SCHED_DEBUG=y to be able to twiddle the
> > sysctl.
>
>
> On 9/13/07, Antoine Martin <antoine@nagafix.co.uk> wrote:
> >
> > All the 2.6.23-rc kernels performed poorly (except -rc3!):
>
> This is an interesting data point, IMHO ... considering these tests are long,
> I suspect you ran them only once each per kernel. So I wonder how reliable
> that -rc3 testpoint is. If this oddity is reproducible,

Ok, it's reproducible, making our job easier. Which also means, Antoine,
please do try the following git-bisecting:


> 1. between 23-rc1 and 23-rc3, and find out which commit led to the
>   improvement in performance, and,
> 2. between 23-rc3 and 23-rc6, and find out which commit brought down
>   the numbers again.
>
> [ http://www.kernel.org/pub/software/scm/git/docs/git-bisect.html,
>   git-bisect is easy and amazingly helpful on certain occasions. ]

I don't have access to any real/meaningful SMP systems, so I wonder how much
sense it makes in practical terms for me to try and run these tests
locally on my
little boxen ... would be helpful if someone with 4/8 CPU systems could give
Antoine's testsuite a whirl :-)


> > Notes about the tests and setup:
> > * environment is:
> > Dual Opteron 252 with 3GB ram, scsi disk, etc..
> > Sun Java 1.6
> > MySQL 5.0.44
> > Junit + ant + my test code (devloop.org.uk)
> > * java threads are created first and the data is prepared, then all the
> > threads are started in a tight loop. Each thread runs multiple queries
> > with a 10ms pause (to allow the other threads to get scheduled)
>
> Don't know much about CFS either, but does that constant "10 ms" sleep
> somehow lead to evil synchronization issues between the test threads?
> Does randomizing that time (say from 2-20 ms) lead to different numbers?

Umm, you mention _changing_ this value earlier, but it still remains the same
for every thread during every loop for a given test run -- what I'm
suggesting is
making that code do something like: Thread.sleep(random(x, y)); where
x=2, y=20 and random(x, y) returns a random integer between x and y, so all
threads sleep for different durations in every loop, but still average
out to about
~10 ms over a period. Try to vary x and y (to vary the average) and post the
resulting graphs too? CONFIG_HZ (actually, full .config) and dmesg might be
useful for us as well.

Also, like David mentioned, counting the _number_ of times the test threads
managed to execute those SQL queries is probably a better benchmark than
measuring the time it takes for threads to finish execution itself -- uniformity
in that number across threads would bring out how "fair" CFS is compared to
previous kernels, for one ...

And finally I need a clarification from you: from the code that I
read, it appears
you have *different* threads for purely inserting/selecting/updating/deleting
records from the table, right? So I think David was barking up the wrong tree
in that other reply there, where he said the *same* thread needs to execute
multiple queries on the same data, and therefore your test code is susceptible
to cache hotness and thread execution order effects ... but I don't see any
such pathologies. I could be wrong, of course ...

Which brings us to another issue -- how well does the testsuite capture real
world workloads? Wouldn't multiple threads in the real world that arbitrarily
execute insert/update/select/delete queries on the same table also need to
implement some form of locking? How would that affect the numbers?


> > * load average is divided by the number of cpus (2)
> > * more general information (which also covers some irrelevant
> > information about some other tests I have published) is here:
> > http://devloop.org.uk/documentation/database-performance/Setup/
>
>
> Thanks,
>
> Satyam
>
