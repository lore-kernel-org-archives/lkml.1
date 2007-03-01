Return-Path: <linux-kernel-owner+w=401wt.eu-S965510AbXCATGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965510AbXCATGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 14:06:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965512AbXCATGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 14:06:08 -0500
Received: from warden-p.diginsite.com ([208.29.163.248]:42838 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S965510AbXCATGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 14:06:07 -0500
Date: Thu, 1 Mar 2007 10:41:40 -0800 (PST)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
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
In-Reply-To: <20070301175643.GA20219@2ka.mipt.ru>
Message-ID: <Pine.LNX.4.63.0703011008060.23701@qynat.qvtvafvgr.pbz>
References: <20070227102832.GC23170@2ka.mipt.ru>  <20070227115221.GJ8154@thunk.org>
 <20070227121116.GA31597@2ka.mipt.ru>  <20070228161413.GA4319@ucw.cz>
 <20070301081808.GD7217@2ka.mipt.ru>  <20070301092634.GB20171@elf.ucw.cz>
 <20070301094723.GJ7217@2ka.mipt.ru>  <20070301095402.GA14603@elte.hu>
 <20070301105928.GA15709@2ka.mipt.ru>  <Pine.LNX.4.63.0703010822560.23701@qynat.qvtvafvgr.pbz>
 <20070301175643.GA20219@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2007, Evgeniy Polyakov wrote:

> On Thu, Mar 01, 2007 at 08:56:28AM -0800, David Lang (david.lang@digitalinsight.com) wrote:
>> the ab numbers below do not seem that impressive to me, especially for such
>> stripped down server processes.
> ...
>> client and server are dual opteron 252 with 8G of ram, running debian in 64
>> bit mode
>
> Decrease your hardware setup in 2-4 times, leave only one apache process
> and try to get the same - we are not talking about how to create a
> perfect web server, instead we try to focus possible problems in
> epoll/kevent event driven logic.

for apache I agree that the target box was maxed out, so if you only had a 
single core on your AMD64 box that would be about half, however the thttpd is 
only useing ~1 of the CPU's (OS overhead is useing just a smidge of the second, 
but overall the box is 45-48% idle

if the amount of ram is an issue then you are swapping in your tests (or at 
least throwing out cache that you need) and so would not be testing what you 
think you are.

> Vanilla (epoll) lighttpd shows 4000-5000 requests per second in my setup (no logs).
> Default mpm-apache2 with bunch of threads - about 8k req/s.
> Default thttpd (disabled logging) - about 2k req/s
>
> Btw, all your tests are network bound, try to decrease
> html page size to get actual event processing speed out of that machines.

same test retreiving a ~128b file the server never gets below 51% idle (so it's 
only useing one CPU)

Server Software:        thttpd/2.23beta1
Server Hostname:        208.2.188.5
Server Port:            81

Document Path:          /128b
Document Length:        136 bytes

Concurrency Level:      8000
Time taken for tests:   9.372902 seconds
Complete requests:      80000
Failed requests:        0
Write errors:           0
Total transferred:      30762842 bytes
HTML transferred:       10952216 bytes
Requests per second:    8535.24 [#/sec] (mean)
Time per request:       937.290 [ms] (mean)
Time per request:       0.117 [ms] (mean, across all concurrent requests)
Transfer rate:          3205.09 [Kbytes/sec] received

Connection Times (ms)
               min  mean[+/-sd] median   max
Connect:       36  287 1125.6     73    9109
Processing:    49   89  19.8     87     339
Waiting:       17   62  16.4     62     292
Total:         92  376 1137.4    159    9262

Percentage of the requests served within a certain time (ms)
   50%    159
   66%    164
   75%    165
   80%    165
   90%    203
   95%    260
   98%   3233
   99%   9201
  100%   9262 (longest request)

note that this is showing the slowdown from the large concurrancy level, if I 
reduce the concurrancy level to 500 I get

Document Path:          /128b
Document Length:        136 bytes

Concurrency Level:      500
Time taken for tests:   4.215025 seconds
Complete requests:      80000
Failed requests:        0
Write errors:           0
Total transferred:      30565348 bytes
HTML transferred:       10881904 bytes
Requests per second:    18979.72 [#/sec] (mean)
Time per request:       26.344 [ms] (mean)
Time per request:       0.053 [ms] (mean, across all concurrent requests)
Transfer rate:          7081.33 [Kbytes/sec] received

Connection Times (ms)
               min  mean[+/-sd] median   max
Connect:        0   15 206.3      1    3006
Processing:     2    7   6.4      6     224
Waiting:        1    6   6.4      5     224
Total:          3   22 208.4      6    3229

Percentage of the requests served within a certain time (ms)
   50%      6
   66%      8
   75%     10
   80%     12
   90%     16
   95%     17
   98%     21
   99%     24
  100%   3229 (longest request)
loadtest2:/proc/sys#

again with >50% idle on the server box

also, ab appears to only use a single cpu so the fact that there are two on the 
client box should not make a difference.

I will reboot these boxes into a UP kernel if you think that this is still a 
significant difference. based on what I'm seeing I don't think it will make much 
of a difference (except for the apache test)

David Lang
