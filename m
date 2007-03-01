Return-Path: <linux-kernel-owner+w=401wt.eu-S932207AbXCALBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207AbXCALBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 06:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932884AbXCALBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 06:01:39 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:47734 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207AbXCALBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 06:01:38 -0500
Date: Thu, 1 Mar 2007 13:59:28 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070301105928.GA15709@2ka.mipt.ru>
References: <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org> <20070226195416.GA11188@elte.hu> <20070227102832.GC23170@2ka.mipt.ru> <20070227115221.GJ8154@thunk.org> <20070227121116.GA31597@2ka.mipt.ru> <20070228161413.GA4319@ucw.cz> <20070301081808.GD7217@2ka.mipt.ru> <20070301092634.GB20171@elf.ucw.cz> <20070301094723.GJ7217@2ka.mipt.ru> <20070301095402.GA14603@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070301095402.GA14603@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Thu, 01 Mar 2007 14:00:26 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 10:54:02AM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> > I posted kevent/epoll benchmarks and related design issues too many 
> > times both with handmade applications (which might be broken as hell) 
> > and popular open-source servers to repeat them again.
> 
> numbers are crutial here - and given the epoll bugs in the evserver code 
> that we found, do you have updated evserver benchmark results that 
> compare epoll to kevent? I'm wondering why epoll has half the speed of 
> kevent in those measurements - i suspect some possible benchmarking bug. 
> The queueing model of epoll and kevent is roughly comparable, both do 
> only a constant number of steps to serve one particular request, 
> regardless of how many pending connections/requests there are. What is 
> the CPU utilization of the server system during an epoll test, and what 
> is the CPU utilization during a kevent test? 100% utilized in both 
> cases?

Yes, it is about 98-100% in both cases.
I've just re-run tests on my amd64 test machine without debug options:

epoll		4794.23
kevent		6468.95

here are full client 'ab' outputs for epoll and kevent servers (epoll 
does not contain EPOLLET as you requested, but it does not look like 
it change performance in my case).

epoll ab aoutput:
# ab -c8000 -n80000 http://192.168.0.48/
This is ApacheBench, Version 2.0.40-dev <$Revision: 1.146 $> apache-2.0
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Copyright 2006 The Apache Software Foundation, http://www.apache.org/

Benchmarking 192.168.0.48 (be patient)
Completed 8000 requests
Completed 16000 requests
Completed 24000 requests
Completed 32000 requests
Completed 40000 requests
Completed 48000 requests
Completed 56000 requests
Completed 64000 requests
Completed 72000 requests
Finished 80000 requests


Server Software:        Apache/1.3.27
Server Hostname:        192.168.0.48
Server Port:            80

Document Path:          /
Document Length:        3521 bytes

Concurrency Level:      8000
Time taken for tests:   16.686737 seconds
Complete requests:      80000
Failed requests:        0
Write errors:           0
Total transferred:      309760000 bytes
HTML transferred:       281680000 bytes
Requests per second:    4794.23 [#/sec] (mean)
Time per request:       1668.674 [ms] (mean)
Time per request:       0.209 [ms] (mean, across all concurrent
requests)
Transfer rate:          18128.17 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:      159  779 110.1    799     921
Processing:   468  866  77.4    869     988
Waiting:       63  426 212.3    425     921
Total:       1145 1646 115.6   1660    1873

Percentage of the requests served within a certain time (ms)
50%   1660
66%   1661
75%   1662
80%   1663
90%   1806
95%   1830
98%   1833
99%   1834
100%   1873 (longest request)

kevent ab output:
# ab -c8000 -n80000 http://192.168.0.48/
This is ApacheBench, Version 2.0.40-dev <$Revision: 1.146 $> apache-2.0
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Copyright 2006 The Apache Software Foundation, http://www.apache.org/

Benchmarking 192.168.0.48 (be patient)
Completed 8000 requests
Completed 16000 requests
Completed 24000 requests
Completed 32000 requests
Completed 40000 requests
Completed 48000 requests
Completed 56000 requests
Completed 64000 requests
Completed 72000 requests
Finished 80000 requests


Server Software:        Apache/1.3.27
Server Hostname:        192.168.0.48
Server Port:            80

Document Path:          /
Document Length:        3521 bytes

Concurrency Level:      8000
Time taken for tests:   12.366775 seconds
Complete requests:      80000
Failed requests:        0
Write errors:           0
Total transferred:      317047104 bytes
HTML transferred:       288306522 bytes
Requests per second:    6468.95 [#/sec] (mean)
Time per request:       1236.677 [ms] (mean)
Time per request:       0.155 [ms] (mean, across all concurrent
requests)
Transfer rate:          25036.12 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:      130  364 871.1    275    9347
Processing:   178  298  42.5    296     580
Waiting:       31  202  65.8    210     369
Total:        411  663 887.0    572    9722

Percentage of the requests served within a certain time (ms)
50%    572
66%    573
75%    618
80%    640
90%    684
95%    709
98%    721
99%   3455
100%   9722 (longest request)

Notice how percentage of the requests served within a certain time
differs for kevent and epoll. And this server does not include
ready-on-submission kevent optimization.

> 	Ingo

-- 
	Evgeniy Polyakov
