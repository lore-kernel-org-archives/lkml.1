Return-Path: <linux-kernel-owner+w=401wt.eu-S1763204AbXFBWL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763204AbXFBWL1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 18:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759659AbXFBWLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 18:11:21 -0400
Received: from mail.tmr.com ([64.65.253.246]:37639 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757767AbXFBWLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 18:11:20 -0400
Message-ID: <4661EB33.8010002@tmr.com>
Date: Sat, 02 Jun 2007 18:12:03 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: davids@webmaster.com
CC: david@lang.hm, linux-kernel@vger.kernel.org
Subject: Re: scheduling oddity on 2.6.20.3 stock
References: <MDEHLPKNGKAHNMBLJOLKCEIIDNAC.davids@webmaster.com> <MDEHLPKNGKAHNMBLJOLKMEIIDNAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKMEIIDNAC.davids@webmaster.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Schwartz wrote:
>>>>> bunzip2 -c $file.bz2 |gzip -9 >$file.gz
> 
> So here are some actual results from a dual P3-1Ghz machine (2.6.21.1,
> CFSv9). First lets time each operation individually:
> 
> $ time bunzip2 -k linux-2.6.21.tar.bz2
> 
> real    1m5.626s
> user    1m2.240s
> sys     0m3.144s
> 
> 
> $ time gzip -9 linux-2.6.21.tar
> 
> real    1m17.652s
> user    1m15.609s
> sys     0m1.912s
> 
> The compress was the most complex (no surprise there) but they are close
> enough that efficient overlap will definitely affect the total wall time. If
> we can both decompress and compress in 1:17, we are optimal. First, let's
> try the normal way:
> 
> $ time (bunzip2 -c linux-2.6.21.tar.bz2 | gzip -9 > test1)
> 
> real    1m45.051s
> user    2m16.945s
> sys     0m2.752s
> 
> 1:45, or 1/3 over optimal. Now, with a 32MB non-blocking cache between the
> two processes ('accel' creates a 32MB cache and uses 'select' to fill from
> stdin and empty to stdout without blocking either direction):
> 
> $ time (bunzip2 -c linux-2.6.21.tar.bz2 | ./accel | gzip -9 > test2)
> 
> real    1m18.361s
> user    2m19.589s
> sys     0m6.356s
> 
> Within testing accuracy of optimal.
> 
> So it's not the scheduler. It's the fact that bunzip2/gzip have inadequate
> input/output buffering. I don't think it's unreasonable to consider this a
> defect in those programs.
> 
They are hardly designed to optimize this operation...

For a tunable buffer program allowing the buffer size and buffers in the 
pool to be set, see www.tmr.com/~public/source program ptbuf. I wrote it 
as a proof of concept for a pthreads presentation I was giving, and it 
happened to be useful.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
