Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbZIOIhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbZIOIhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 04:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753577AbZIOIhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 04:37:38 -0400
Received: from mail.gmx.net ([213.165.64.20]:59536 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751641AbZIOIhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 04:37:36 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/5Lgo2JNf55mHlf3Ezi+IcRh/GLRhntdWHS6M7nG
	7W0o/jzYl76Mx2
Subject: Re: Phoronix CFS vs BFS bencharks
From: Mike Galbraith <efault@gmx.de>
To: Willy Tarreau <w@1wt.eu>
Cc: Marcin Letyns <mletyns@gmail.com>, Nikos Chantziaras <realnc@arcor.de>,
       Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20090914204905.GA28315@1wt.eu>
References: <20090906205952.GA6516@elte.hu> <4AAE10E6.2050403@arcor.de>
	 <1252928133.22740.37.camel@marge.simson.net>
	 <f42384a10909140727k463ff460q3859892dcb79bcc5@mail.gmail.com>
	 <1252942335.12986.58.camel@marge.simson.net>
	 <f42384a10909141214w1b3e7719j1a82363f7cb6fd3e@mail.gmail.com>
	 <20090914204905.GA28315@1wt.eu>
Content-Type: text/plain
Date: Tue, 15 Sep 2009 10:37:35 +0200
Message-Id: <1253003855.6628.63.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 22:49 +0200, Willy Tarreau wrote:
> On Mon, Sep 14, 2009 at 09:14:35PM +0200, Marcin Letyns wrote:
> > 2009/9/14 Mike Galbraith <efault@gmx.de>
> > >
> > > On Mon, 2009-09-14 at 16:27 +0200, Marcin Letyns wrote:
> > > > Hello,
> > > >
> > > > Disabling NEW_FAIR_SLEEPERS makes a lot of difference here in the
> > > > Apache benchmark:
> > > >
> > > > 2.6.30.6-bfs: 7311.05
> > > >
> > > > 2.6.30.6-cfs-fair_sl_disabled: 8249.17
> > > >
> > > > 2.6.30.6-cfs-fair_sl_enabled: 4894.99
> > >
> > > Wow.
> > >
> > > Some loads like wakeup preemption (mysql+oltp), and some hate it.  This
> > > load appears to REALLY hate it (as does volanomark, but that thing is
> > > extremely overloaded).  How many threads does that benchmark run
> > > concurrently?
> > 
> > >From the benchmark description:
> > 
> > This is a test of ab, which is the Apache Benchmark program. This test
> > profile measures how many requests per second a given system can
> > sustain when carrying out 500,000 requests with 100 requests being
> > carried out concurrently.
> 
> Be careful not to run ab on the same machine as you run apache, otherwise
> the numerous apache processes can limit ab's throughput. This is the same
> reason as why I educate people so that they don't run a single-process
> proxy in front of a multi-process/multi-thread web server. Apparently
> it's not obvious to everyone.

I turned on apache, and played with ab a bit, and yup, ab is a hog, so
any fairness hurts it a badly.  Ergo, running ab on the same box as
apache suffers with CFS when NEW_FAIR_SLEEPERS are turned on.  Issuing
ab bandwidth to match it's 1:N pig nature brings throughput right back.

(In all the comparison testing I've done, BFS favors hogs, and with
NEW_FAIR_SLEEPERS turned off, so does CFS, though not as much.)

Running apache on one core and ab on another (with shared cache tho),
something went south with BFS. I would have expected it to be much
closer (shrug).  

Some likely not very uninteresting numbers below.  I wasted a lot more
of my time generating them than anyone will downloading them :)

ab -n 500000 -c 100 http://localhost/openSUSE.org.html

2.6.31-bfs221-smp
Concurrency Level:      100
Time taken for tests:   43.556 seconds
Complete requests:      500000
Failed requests:        0
Write errors:           0
Total transferred:      7158558404 bytes
HTML transferred:       7027047358 bytes
Requests per second:    11479.50 [#/sec] (mean)
Time per request:       8.711 [ms] (mean)
Time per request:       0.087 [ms] (mean, across all concurrent requests)
Transfer rate:          160501.38 [Kbytes/sec] received

2.6.32-tip-smp NO_NEW_FAIR_SLEEPERS
Concurrency Level:      100
Time taken for tests:   42.834 seconds
Complete requests:      500000
Failed requests:        0
Write errors:           0
Total transferred:      7158429480 bytes
HTML transferred:       7026921590 bytes
Requests per second:    11672.84 [#/sec] (mean)
Time per request:       8.567 [ms] (mean)
Time per request:       0.086 [ms] (mean, across all concurrent requests)
Transfer rate:          163201.63 [Kbytes/sec] received

2.6.32-tip-smp NEW_FAIR_SLEEPERS
Concurrency Level:      100
Time taken for tests:   68.221 seconds
Complete requests:      500000
Failed requests:        0
Write errors:           0
Total transferred:      7158357900 bytes
HTML transferred:       7026851325 bytes
Requests per second:    7329.12 [#/sec] (mean)
Time per request:       13.644 [ms] (mean)
Time per request:       0.136 [ms] (mean, across all concurrent requests)
Transfer rate:          102469.65 [Kbytes/sec] received

2.6.32-tip-smp NEW_FAIR_SLEEPERS + ab at nice -15
Concurrency Level:      100
Time taken for tests:   42.824 seconds
Complete requests:      500000
Failed requests:        0
Write errors:           0
Total transferred:      7158451988 bytes
HTML transferred:       7026943572 bytes
Requests per second:    11675.68 [#/sec] (mean)
Time per request:       8.565 [ms] (mean)
Time per request:       0.086 [ms] (mean, across all concurrent requests)
Transfer rate:          163241.78 [Kbytes/sec] received

taskset -c 2 /etc/init.d/apache2 restart
taskset -c 3 ab -n 500000 -c 100 http://localhost/openSUSE.org.html

2.6.31-bfs221-smp
Concurrency Level:      100
Time taken for tests:   86.590 seconds
Complete requests:      500000
Failed requests:        0
Write errors:           0
Total transferred:      7158000000 bytes
HTML transferred:       7026500000 bytes
Requests per second:    5774.37 [#/sec] (mean)
Time per request:       17.318 [ms] (mean)
Time per request:       0.173 [ms] (mean, across all concurrent requests)
Transfer rate:          80728.41 [Kbytes/sec] received

2.6.32-tip-smp
Concurrency Level:      100
Time taken for tests:   48.640 seconds
Complete requests:      500000
Failed requests:        0
Write errors:           0
Total transferred:      7158000000 bytes
HTML transferred:       7026500000 bytes
Requests per second:    10279.71 [#/sec] (mean)
Time per request:       9.728 [ms] (mean)
Time per request:       0.097 [ms] (mean, across all concurrent requests)
Transfer rate:          143715.15 [Kbytes/sec] received

