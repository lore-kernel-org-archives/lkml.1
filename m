Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbXIQMRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbXIQMRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 08:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbXIQMRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 08:17:10 -0400
Received: from mail.nagafix.co.uk ([194.145.196.85]:59600 "EHLO
	mail.nagafix.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbXIQMRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 08:17:09 -0400
Message-ID: <46EE7043.9090909@nagafix.co.uk>
Date: Mon, 17 Sep 2007 13:17:07 +0100
From: Antoine Martin <antoine@nagafix.co.uk>
User-Agent: Thunderbird 2.0.0.6 (X11/20070806)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       David Schwartz <davids@webmaster.com>
Subject: Re: CFS: some bad numbers with Java/database threading
References: <46E871FE.9010908@nagafix.co.uk> <20070913112427.GA20686@elte.hu>	 <20070914083246.GA20514@elte.hu>	 <a781481a0709140306k3faf3585haae26853fe81381c@mail.gmail.com> <a781481a0709140901g5650a0dr35ae9348cb740814@mail.gmail.com>
In-Reply-To: <a781481a0709140901g5650a0dr35ae9348cb740814@mail.gmail.com>
X-Enigmail-Version: 0.95.2
OpenPGP: id=F18AD6BB;
	url=http://users.nagafix.co.uk/~antoine/antoine.asc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Satyam Sharma wrote:
> I don't have access to any real/meaningful SMP systems, so I wonder
> how much sense it makes in practical terms for me to try and run these
> tests locally on my little boxen ... would be helpful if someone with
> 4/8 CPU systems could give Antoine's testsuite a whirl :-)
It should still work... if you're patient.

[snip] covered in separate mail
> CONFIG_HZ (actually, full .config) and dmesg might be
> useful for us as well.
http://devloop.org.uk/documentation/database-performance/dmesg-dualopteron.gz
CONFIG_HZ=1000

> Also, like David mentioned, counting the _number_ of times the test
> threads managed to execute those SQL queries is probably a better
> benchmark than measuring the time it takes for threads to finish
> execution itself -- uniformity in that number across threads would
> bring out how "fair" CFS is compared to previous kernels, for one ...
Good idea, I've added code to capture more fairness oriented attributes:
* time until the first thread finishes - this should actually be higher
when the scheduler is fairer.
* total number of loop iterations executed when the first thread
finishes (higher is better)
etc.

> And finally I need a clarification from you: from the code that I
> read, it appears you have *different* threads for purely
> inserting/selecting/updating/deleting records from the table, right?
Correct.

> So I think David was barking up the wrong tree
> in that other reply there, where he said the *same* thread needs to
> execute multiple queries on the same data, and therefore your test
> code is susceptible to cache hotness and thread execution order
> effects ... but I don't see any such pathologies. I could be wrong, of
> course ...
I think he does have a valid point:
maybe, the locality of the java threads is important, but there are so
many of them and so many layers below it (jdbc pool, backend database
threads, filesystem, device) that the various caches get thrashed quite
often anyway, no matter what the interleaving factor is.
Which means that being fairer in this case also means switching threads
more often and hitting the caches' capacity limits earlier.
In which case the granularity and CONFIG_HZ should have a noticeable
impact. Ingo did suggest tweaking
/proc/sys/kernel/sched_yield_granularity_ns, which I did but this
particular test timed out when It ran over the weekend... will run it
again now. (results in a couple of days)

Maybe the granularity should auto-adjust to prevent such cases?
(probably not)
Granularity (and therefore fairness) become less important as the number
of threads becomes very large, as fairness starts to adversely affects
throughput?

I have changed my mind and now think that this is not a regression, or
at least not one we should worry too much about. As David said, this
workload is "pathological".

And CFS, does show some noticeable improvements with the new
measurements (now using a shorter thread yield of 5ms and a higher
number of loop iterations per thread: 25):
It does not adversely affect throughput as much (will test with more
threads later):
http://devloop.org.uk/documentation/database-performance/Linux-Kernels/Kernels-ManyThreads-CombinedTests8-5msYield.png
The number of threads that exit before we reach half the total number of
loop iterations is lower and more predictable (meaning a more even
distribution between all the threads):
http://devloop.org.uk/documentation/database-performance/Linux-Kernels/Kernels-ManyThreads-CombinedTests8-5msYield-ThreadsFinished.png
And the time it takes to reach this half way point is also more consistent:
http://devloop.org.uk/documentation/database-performance/Linux-Kernels/Kernels-ManyThreads-CombinedTests8-5msYield-TimeToHalfWay.png

"2.6.23-rc6-yield2" is the yield patch meant for 2.6.23,
"2.6.23-rc6-yield3" is the one that is not meant to be merged.
Both include:
echo 1 > /proc/sys/kernel/sched_yield_bug_workaround

The high latency case (coming soon) includes HZ250, no preempt, and
doubles the /proc/sys/kernel/sched_yield_granularity_ns

> Which brings us to another issue -- how well does the testsuite
> capture real world workloads?
Not well... This particular test is not meant to represent any real-life
scenario - it is very very hard not to have a bias,
(that is why there are so many variations of TPC: TPC-W, TPC-H,..)
It is just meant to try to measure the impact of changing individual
components (anything from kernels, databases, threads, coding
techniques, ...) one at a time, running a variety of scenarios and
spotting any anomalies. More often than not, the anomalies will tell you
about which combinations to avoid, and not about unexpected improvements.

> Wouldn't multiple threads in the real world that arbitrarily
> execute insert/update/select/delete queries on the same table also
> need to implement some form of locking?
Generally yes, but not always - I have a personal preference for
lock-less algorithms (like variations on optimistic locking) because
they're a lot easier to get right (and understand), but they're not
always suitable. (mostly because of ordering/timing/QoS issues)
And I digress.

> How would that affect the numbers?
Hmmm. Not entirely sure, if the locking is implemented using database
transactions, the threads would spend a bit longer in wait state whilst
the database does its stuff (even more so for the databases that do not
use row-level locking), switching tasks less, so it might actually help
improve throughput in some cases (as long as the workload is cpu-bound
rather than I/O bound) ?
We'll know more when I get the results for the high latency case.

Antoine
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFG7nBCGK2zHPGK1rsRCrs3AJ9e5Ye1KVgydd06aD6akoLe5Z2RYQCfQey2
PpQYOdsvdo5bLE68ro/KFbE=
=c21f
-----END PGP SIGNATURE-----
