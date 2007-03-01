Return-Path: <linux-kernel-owner+w=401wt.eu-S965192AbXCAPyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965192AbXCAPyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 10:54:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965292AbXCAPyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 10:54:10 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:38062 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965192AbXCAPyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 10:54:07 -0500
Date: Thu, 1 Mar 2007 18:51:42 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Theodore Tso <tytso@mit.edu>,
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
Message-ID: <20070301155142.GD8217@2ka.mipt.ru>
References: <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org> <20070301152323.GA8217@2ka.mipt.ru> <200703011632.37756.dada1@cosmosbay.com> <200703011641.28064.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <200703011641.28064.dada1@cosmosbay.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Thu, 01 Mar 2007 18:52:08 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 04:41:27PM +0100, Eric Dumazet (dada1@cosmosbay.com) wrote:
> On Thursday 01 March 2007 16:32, Eric Dumazet wrote:
> > On Thursday 01 March 2007 16:23, Evgeniy Polyakov wrote:
> > > They are there, since ab runs only 50k requests.
> > > If I change it to something noticebly more than 50/80k, ab crashes:
> > > # ab -c8000 -t 600 -n800000000 http://192.168.0.48/
> > > This is ApacheBench, Version 2.0.40-dev <$Revision: 1.146 $> apache-2.0
> > > Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
> > > Copyright 2006 The Apache Software Foundation, http://www.apache.org/
> > >
> > > Benchmarking 192.168.0.48 (be patient)
> > > Segmentation fault
> > >
> > > Are there any other tool suitable for such loads?
> > > I only tested httperf (which is worse, since it uses poll/select) and
> > > 'ab'.
> > >
> > > Btw, host machine runs 100% too, so it is possible that client side is
> > > broken (too).
> >
> > I have similar problems here, ab test just doesnt complete...
> >
> > I am still investigating with strace and tcpdump.
> 
> OK... I found it.
> 
> I had to loop on accept() :
> 
>         for (i=0; i<num; ++i) {
>                 if (event[i].data.fd == main_server_s) {
>                         do {
>                                 err = evtest_callback_main(event[i].data.fd);
>                                 } while (err != -1);
>                         }
>                 else
>                         err = evtest_callback_client(event[i].data.fd);
>         }
> 
> Or else we can miss an event forever...

The same here - I would just enable a debug to find it.

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
Time taken for tests:   18.250921 seconds
Complete requests:      80000
Failed requests:        0
Write errors:           0
Total transferred:      315691904 bytes
HTML transferred:       287074172 bytes
Requests per second:    4383.34 [#/sec] (mean)
Time per request:       1825.092 [ms] (mean)
Time per request:       0.228 [ms] (mean, across all concurrent
requests)
Transfer rate:          16891.86 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:      137  884 481.1    920    3602
Processing:   567  888 163.6    985     997
Waiting:       47  455 238.2    439     921
Total:        765 1772 566.6   1911    4556

Percentage of the requests served within a certain time
(ms)
50%   1911
66%   1911
75%   1912
80%   1913
90%   1913
95%   1914
98%   4438
99%   4497
100%   4556 (longest request)
kano:~#


-- 
	Evgeniy Polyakov
