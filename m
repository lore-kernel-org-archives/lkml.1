Return-Path: <linux-kernel-owner+w=401wt.eu-S965028AbXCAMCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965028AbXCAMCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 07:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964964AbXCAMCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 07:02:47 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:51937 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965028AbXCAMCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 07:02:47 -0500
Date: Thu, 1 Mar 2007 15:01:16 +0300
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
Message-ID: <20070301120114.GB20773@2ka.mipt.ru>
References: <20070227121116.GA31597@2ka.mipt.ru> <20070228161413.GA4319@ucw.cz> <20070301081808.GD7217@2ka.mipt.ru> <20070301092634.GB20171@elf.ucw.cz> <20070301094723.GJ7217@2ka.mipt.ru> <20070301095402.GA14603@elte.hu> <20070301105928.GA15709@2ka.mipt.ru> <20070301110022.GA28260@elte.hu> <20070301111629.GA27381@2ka.mipt.ru> <20070301114137.GB897@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070301114137.GB897@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Thu, 01 Mar 2007 15:01:53 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 12:41:37PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> > I also changed client socket to nonblocking mode with the same result 
> > in epoll server. If you will find it broken, please send me corrected 
> > to test too.
> 
> this line in evserver_kevent.c looks a bit fishy:
> 
>         err = recv(s, buf, 100, 0);
> 
> because on the evserver_epoll.c side the following is done:
> 
>         err = recv(s, buf, 4096, 0);
> 
> now, for 'ab', the request size is 76 bytes, so it should fit fine 
> functionality-wise. But, the TCP stack might decide differently of 
> whether to return with a partial packet depending on how much data is 
> requested. I dont know whether it actually makes a difference in the TCP 
> flow decisions, and whether it makes a performance difference in your 
> test, but safest would be to use 4096 in both cases.

Well, that would be quite strange - as far as I known linux network
stack (for which kevent was originally created to support network AIO),
there should not be any difference.

Anyway, I've reran the test with the same values:

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
Time taken for tests:   18.398381 seconds
Complete requests:      80000
Failed requests:        0
Write errors:           0
Total transferred:      338738048 bytes
HTML transferred:       308031164 bytes
Requests per second:    4348.21 [#/sec] (mean)
Time per request:       1839.838 [ms] (mean)
Time per request:       0.230 [ms] (mean, across all concurrent
requests)
Transfer rate:          17979.73 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:      148  795 196.9    808    3599
Processing:   824  882  39.7    878     986
Waiting:       59  426 212.6    423     914
Total:       1073 1678 200.8   1673    4579

Percentage of the requests served within a certain time (ms)
50%   1673
66%   1674
75%   1678
80%   1686
90%   1852
95%   1861
98%   1864
99%   1865
100%   4579 (longest request)

Essentially the same result (in limits of some inaccuracy).

> in general, please make sure the exact same system calls are done in the 
> client function. (except of course for the event queueing syscalls 
> themselves)

Yes, that should be done of course.
I even have a plan to create the same binary for both, but have also in
plans to turn some kevent optimization (mainly readiness-on-submit, when
requested event (secv/send/anything) is ready immediately - kevent
supports to return that event in the submission syscall without
additional overhead by reading it from ring or queue).

> 	Ingo

-- 
	Evgeniy Polyakov
