Return-Path: <linux-kernel-owner+w=401wt.eu-S1752643AbZIGJtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbZIGJtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 05:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbZIGJtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 05:49:52 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60397 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbZIGJtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 05:49:51 -0400
Date: Mon, 7 Sep 2009 11:49:54 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090907094953.GP18599@kernel.dk>
References: <20090906205952.GA6516@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090906205952.GA6516@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 06 2009, Ingo Molnar wrote:
> So ... to get to the numbers - i've tested both BFS and the tip of 
> the latest upstream scheduler tree on a testbox of mine. I 
> intentionally didnt test BFS on any really large box - because you 
> described its upper limit like this in the announcement:

I ran a simple test as well, since I was curious to see how it performed
wrt interactiveness. One of my pet peeves with the current scheduler is
that I have to nice compile jobs, or my X experience is just awful while
the compile is running.

Now, this test case is something that attempts to see what
interactiveness would be like. It'll run a given command line while at
the same time logging delays. The delays are measured as follows:

- The app creates a pipe, and forks a child that blocks on reading from
  that pipe.
- The app sleeps for a random period of time, anywhere between 100ms
  and 2s. When it wakes up, it gets the current time and writes that to
  the pipe.
- The child then gets woken, checks the time on its own, and logs the
  difference between the two.

The idea here being that the delay between writing to the pipe and the
child reading the data and comparing should (in some way) be indicative
of how responsive the system would seem to a user.

The test app was quickly hacked up, so don't put too much into it. The
test run is a simple kernel compile, using -jX where X is the number of
threads in the system. The files are cache hot, so little IO is done.
The -x2 run is using the double number of processes as we have threads,
eg -j128 on a 64 thread box.

And I have to apologize for using a large system to test this on, I
realize it's out of the scope of BFS, but it's just easier to fire one
of these beasts up than it is to sacrifice my notebook or desktop
machine... So it's a 64 thread box. CFS -jX runtime is the baseline at
100, lower number means faster and vice versa. The latency numbers are
in msecs.


Scheduler       Runtime         Max lat     Avg lat     Std dev
----------------------------------------------------------------
CFS             100             951         462         267
CFS-x2          100             983         484         308
BFS
BFS-x2

And unfortunately this is where it ends for now, since BFS doesn't boot
on the two boxes I tried. It hard hangs right after disk detection. But
the latency numbers look pretty appalling for CFQ, so it's a bit of a
shame that I did not get to compare. I'll try again later with a newer
revision, when available.

-- 
Jens Axboe

