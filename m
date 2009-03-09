Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbZCIHnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbZCIHnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 03:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbZCIHnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 03:43:10 -0400
Received: from brick.kernel.dk ([93.163.65.50]:37926 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbZCIHnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 03:43:09 -0400
Date: Mon, 9 Mar 2009 08:43:06 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Shan Wei <shanwei@cn.fujitsu.com>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: CFQ is worse than other IO schedulers in some cases
Message-ID: <20090309074306.GF11787@kernel.dk>
References: <499BA413.2010705@cn.fujitsu.com> <1234944336.6141.8.camel@marge.simson.net> <49B4A81C.3070609@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B4A81C.3070609@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09 2009, Shan Wei wrote:
> Mike Galbraith said:
> > On Wed, 2009-02-18 at 14:00 +0800, Shan Wei wrote:
> > 
> >> In sysbench(version:sysbench-0.4.10), I confirmed followings.
> >>   - CFQ's performance is worse than other IO schedulers when only multiple
> >>     threads test.
> >>     (There is no difference under single thread test.)
> >>   - It is worse than other IO scheduler when
> >>     I used read mode. (No regression in write mode).
> >>   - There is no difference among other IO schedulers. (e.g noop deadline)
> >>
> >>
> >> The Test Result(sysbench):
> >>    UNIT:Mb/sec
> >>     __________________________________________________
> >>     |   IO       |      thread  number               |  
> >>     | scheduler  |-----------------------------------|
> >>     |            |  1   |  3    |  5   |   7  |   9  |
> >>     +------------|------|-------|------|------|------|
> >>     |cfq         | 77.8 |  32.4 | 43.3 | 55.8 | 58.5 | 
> >>     |noop        | 78.2 |  79.0 | 78.2 | 77.2 | 77.0 |
> >>     |anticipatory| 78.2 |  78.6 | 78.4 | 77.8 | 78.1 |
> >>     |deadline    | 76.9 |  78.4 | 77.0 | 78.4 | 77.9 |
> >>     +------------------------------------------------+
> > ???
> > My Q6600 box agrees that cfq produces less throughput doing this test,
> > but throughput here is ~flat. Disk is external SATA ST3500820AS.
> >     _________________________________________________
> >     |   IO       |     thread  number               |  
> >     | scheduler  |----------------------------------|
> >     |            |  1   |  3   |  5   |  7   |  9   |
> >     +------------|------|------|------|------|------|
> >     |cfq         | 84.4 | 89.1 | 91.3 | 88.8 | 88.8 |
> >     |noop        |102.9 | 99.3 | 99.4 | 99.7 | 98.7 | 
> >     |anticipatory|100.5 |100.1 | 99.8 | 99.7 | 99.6 | 
> >     |deadline    | 97.9 | 98.7 | 99.5 | 99.5 | 99.3 | 
> >     +-----------------------------------------------+
> > 
> 
> I have tested sysbench tool on the SATA disk under 2.6.29-rc6, 
> and don't set RAID.
> 
> [root@DaVid software]# lspci -nn
> ...snip...
> 00:02.5 IDE interface [0101]: Silicon Integrated Systems [SiS] 5513 [IDE] [1039:5513] (rev 01)
> 00:05.0 IDE interface [0101]: Silicon Integrated Systems [SiS] RAID bus controller 180 SATA/PATA  [SiS] [1039:0180] (rev 01)
> 
> The attached script(sysbench-threads.sh) execute sysbench 4 times for each I/O scheduler.
> And the average result is below:
>      ________________________________________
>      |   IO       |     thread  number       |  
>      | scheduler  |--------------------------|
>      |            |  1     |  3     |  5     |  
>      +------------|--------|--------|--------|
>      |cfq         | 60.324 | 33.982 | 37.309 |
>      |noop        | 57.391 | 60.406 | 57.355 | 
>      |anticipatory| 58.962 | 59.342 | 56.999 | 
>      |deadline    | 57.791 | 60.097 | 57.700 | 
>      +---------------------------------------+
> 
> I am wondering about the result vs Mike's.
> why is the regression under multi-thread not present on Mike's box?

I don't know that much about the IO workload that sysbench generates, so
it's hard to say. Since you both use SATA, I'm assuming you have write
caching enabled on that drive? What file system and mount options are
you using?

> Jens, multi threads interleave the same file, and there may be
> some requests that can merge but not merged on different thread queue,
> So the CFQ performs poorly, right?

You can test that theory by editing
block/cfq-iosched.c:cfq_allow_merge(), changing it to return 1 always.

I'll try and rerun this test here on various bits of storage and see
what it turns up!

-- 
Jens Axboe

