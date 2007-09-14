Return-Path: <linux-kernel-owner+w=401wt.eu-S1759970AbXINPZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759970AbXINPZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 11:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbXINPZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 11:25:27 -0400
Received: from mail.nagafix.co.uk ([194.145.196.85]:41854 "EHLO
	mail.nagafix.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbXINPZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 11:25:26 -0400
Message-ID: <46EAA7E4.8020700@nagafix.co.uk>
Date: Fri, 14 Sep 2007 16:25:24 +0100
From: Antoine Martin <antoine@nagafix.co.uk>
User-Agent: Thunderbird 2.0.0.6 (X11/20070806)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: CFS: some bad numbers with Java/database threading [FIXED]
References: <46E871FE.9010908@nagafix.co.uk> <20070913112427.GA20686@elte.hu>	 <20070914083246.GA20514@elte.hu> <a781481a0709140306k3faf3585haae26853fe81381c@mail.gmail.com>
In-Reply-To: <a781481a0709140306k3faf3585haae26853fe81381c@mail.gmail.com>
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
> Hi Antoine, Ingo,
> On 9/14/07, Ingo Molnar <mingo@elte.hu> wrote:
>> * Ingo Molnar <mingo@elte.hu> wrote:
>>
>>> hm, could you try the patch below ontop of 2.6.23-rc6 and do:
>>>
>>>  echo 1 > /proc/sys/kernel/sched_yield_bug_workaround
>>>
>>> does this improve the numbers?
> 
> Hmm, I know diddly about Java, and I don't want to preempt Antoine's next
> test, but I noticed that he uses Thread.sleep() in his testcode and not the
> Thread.yield() so it would be interesting if Antoine can test with this patch
> and report if something shows up ..
See below...
I'll add a new test using yield() and see what that does.

>> the patch i sent was against CFS-devel. Could you try the one below,
>> which is against vanilla -rc6, does it improve the numbers? (it should
>> have an impact) Keep CONFIG_SCHED_DEBUG=y to be able to twiddle the
>> sysctl.
It looks good now! Updated results here:
http://devloop.org.uk/documentation/database-performance/Linux-Kernels/Kernels-ManyThreads-CombinedTests5-10msYield-noload.png
http://devloop.org.uk/documentation/database-performance/Linux-Kernels/Kernels-ManyThreads-CombinedTests5-10msYield.png
Compared with more kernels here - a bit more cluttered:
http://devloop.org.uk/documentation/database-performance/Linux-Kernels/Kernels-ManyThreads-CombinedTests4-10msYield-noload.png

Thanks Ingo!
Does this mean that I'll have to keep doing:
echo 1 > /proc/sys/kernel/sched_yield_bug_workaround
Or are you planning on finding a more elegant solution?
# find /proc -name "*workaround*"
/proc/sys/kernel/sched_yield_bug_workaround
/proc/sys/net/ipv4/tcp_workaround_signed_windows

> On 9/13/07, Antoine Martin <antoine@nagafix.co.uk> wrote:
>> All the 2.6.23-rc kernels performed poorly (except -rc3!):
> 
> This is an interesting data point, IMHO ... considering these tests are long,
> I suspect you ran them only once each per kernel. So I wonder how reliable
> that -rc3 testpoint is. If this oddity is reproducible, it would be great if you
> could git-bisect:
Yeah, I thought that was quite suspicious.
- -rc2 is just like -rc1 (see above) so I'll re-test -rc3 first,
git-bisect could take a while with those tests... just wiping the disk
between tests takes about 30mins.

>> * java threads are created first and the data is prepared, then all the
>> threads are started in a tight loop. Each thread runs multiple queries
>> with a 10ms pause (to allow the other threads to get scheduled)
> 
> Don't know much about CFS either, but does that constant "10 ms" sleep
> somehow lead to evil synchronization issues between the test threads?
> Does randomizing that time (say from 2-20 ms) lead to different numbers?
I've tested before with varying timings, but I had not thought of using
a randomized delay.
Will add that too.

Many thanks to you all for the feedback!
Antoine
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFG6qfkGK2zHPGK1rsRCgeEAJ9HUUtHUNScvTVKo5z2sSmo+G+BVgCfdYmK
rcd1VYUuzQA2oFEmakjZxgM=
=jmI8
-----END PGP SIGNATURE-----
