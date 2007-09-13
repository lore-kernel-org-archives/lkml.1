Return-Path: <linux-kernel-owner+w=401wt.eu-S1765677AbXIMTCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765677AbXIMTCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 15:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbXIMTCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 15:02:25 -0400
Received: from mail.nagafix.co.uk ([194.145.196.85]:51459 "EHLO
	mail.nagafix.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbXIMTCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 15:02:24 -0400
Message-ID: <46E9893C.1060709@nagafix.co.uk>
Date: Thu, 13 Sep 2007 20:02:20 +0100
From: Antoine Martin <antoine@nagafix.co.uk>
User-Agent: Thunderbird 2.0.0.6 (X11/20070806)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: davids@webmaster.com,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: some bad numbers with Java/database threading
References: <MDEHLPKNGKAHNMBLJOLKOEDIGMAC.davids@webmaster.com> <200709130933.51278.nickpiggin@yahoo.com.au>
In-Reply-To: <200709130933.51278.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.2
OpenPGP: id=F18AD6BB;
	url=http://users.nagafix.co.uk/~antoine/antoine.asc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

I've tested a couple more kernels: 2.6.23-rc4-mm1 and 2.6.23-rc6 with
the "sched_yield_bug_workaround" patch from Ingo, results are here:
http://devloop.org.uk/documentation/database-performance/Linux-Kernels/Kernels-ManyThreads-CombinedTests3-10msYield.png
Same, with the load average (dotted lines):
http://devloop.org.uk/documentation/database-performance/Linux-Kernels/Kernels-ManyThreads-CombinedTests3-10msYield-withload.png
Still slows down after 800 threads...

> On Thursday 13 September 2007 17:18, David Schwartz wrote:
>>> I was working on some unit tests and thought I'd give CFS a whirl to see
>>> if it had any impact on my workloads (to see what the fuss was about),
>>> and I came up with some pretty disturbing numbers:
>>> http://devloop.org.uk/documentation/database-performance/Linux-Ker
>>> nels/Kernels-ManyThreads-CombinedTests-noload2.png
>>> As above but also showing the load average:
>>> http://devloop.org.uk/documentation/database-performance/Linux-Ker
>>> nels/Kernels-ManyThreads-CombinedTests2.png
>>> Looks like a regression to me...
>> I've tried reasonalby diligently to figure out what the hell you're doing
> 
> (cc's readded please reply to all when replying to lkml)
(...)
>> and gone through quite a bit of your documentation, and I just can't figure
>> it out.
Until I find enough time to update the docs, feel free to ask.

>> This could entirely be the result of your test's sensitivity to
>> execution order.
It very well might be, but this is still a visible regression.

>> For example, if you run ten threads that all insert, query, and delete from
>> the *same* table, then the exact interleaving pattern will determine the
>> size of the results. A slight change in the scheduling quantum could
>> multiply the size of the result data by a huge factor. There is a big
>> difference between:
>>
>> 1) Thread A inserts data.
>> 2) Thread A queries data.
>> 3) Thread A deletes data.
>> 4) Thread B inserts data.
>> ...
>>
>>
>> and
>> 1) Thread A inserts data.
>> 2) Thread B insers data.
>> ...
>> 101) Thread A queries data.
>> 102) Thread B queries data.
Thanks for the suggestion, I'll add this to the test series.

>> Now, even if they're using separate tables, your test is still very
>> sensitive to execution order. If thread A runs to completion and then
>> thread B does, the database data will fit better into cache. If thread A
>> runs partially, then thread B runs partially, when thread A runs again, its
>> database stuff will not be hot.
You are correct, it is very sensitive to the execution order and
caching. When I vary the thread pause, the total execution time varies
widely. 10ms just happens to be the sweet spot which provides the best
contrast in the results (for both kernels and rdbms)

>>> * java threads are created first and the data is prepared, then all the
>>> threads are started in a tight loop. Each thread runs multiple queries
>>> with a 10ms pause (to allow the other threads to get scheduled)
>> There are a number of ways you might be measuring nothing but how the
>> scheduler chooses to interleave your threads. Benchmarking threads that
>> yield suggests just this type of thing -- if a thread has useful work to do
>> and another thread is not going to help it, *why* *yield*?
As I said above, I have tried varying the pause and this is the sweet
spot. If you don't yield, the first hundred threads will be finished by
the time you start the 800th - which is not what you want.
I could try just yielding at the start, or only during the first
iteration, etc.. all suggestions are most welcome.

>> Are you worried the scheduler isn't going to schedule other threads?!
Yes!

>> Or is
>> there some sane reason to force suboptimal scheduling when you're trying to
>> benchmark a scheduler? Are you trying to see how it deals with pathological
>> patterns? ;)
I know it sounds sub-optimal, but this benchmark wasn't designed to test
the scheduler! It is meant to thrash just one database table. It isn't
meant to be anything like TPC either.
Previously it did uncover some very noticeable differences in JVM
performance when stress-tested with a large amount of threads.

>> The only documentation I can see about what you're actually *doing* says
>> things like "The schema and statements are almost identical to the
>> non-threaded tests." Do you see why that's not helpful?
I sure do! I'll try to improve on that when I get a chance. Here is a
start: the schema is configurable with simple text files. And the
database layer translates it into the SQL syntax (and types) supported
by the backend (MySQL in this case):
# cat ManyThreadedCombinedTest.properties
table=update
columns=i1:integer,i2:integer,s1:varchar,s2:varchar
I'll make a click&run tarball if anyone is interested in running the
tests themselves (it outputs csv data).

Thanks for the feedback.

Antoine
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFG6Yk8GK2zHPGK1rsRCtVaAKCAVyU4woztnl6q0NAZBNsM94I2JgCcD4M3
+MpR1gAom65Mn/tQX8ig1cI=
=Q3IY
-----END PGP SIGNATURE-----
