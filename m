Return-Path: <linux-kernel-owner+w=401wt.eu-S932371AbXBWNwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371AbXBWNwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 08:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932374AbXBWNw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 08:52:29 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:55221 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371AbXBWNw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 08:52:28 -0500
Date: Fri, 23 Feb 2007 19:25:25 +0530
From: Suparna Bhattacharya <suparna@in.ibm.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: A quick fio test (was Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3)
Message-ID: <20070223135525.GA31569@in.ibm.com>
Reply-To: suparna@in.ibm.com
References: <20070221211355.GA7302@elte.hu> <20070223125247.GO5737@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070223125247.GO5737@kernel.dk>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 23, 2007 at 01:52:47PM +0100, Jens Axboe wrote:
> On Wed, Feb 21 2007, Ingo Molnar wrote:
> > this is the v3 release of the syslet/threadlet subsystem:
> > 
> >    http://redhat.com/~mingo/syslet-patches/
> 
> [snip]
> 
> Ingo, some testing of the experimental syslet queueing stuff, in the
> syslet-testing branch of fio.
> 
> Fio job file:
> 
> [global]
> bs=8k
> size=1g
> direct=0
> ioengine=syslet-rw
> iodepth=32
> rw=read
> 
> [file]
> filename=/ramfs/testfile
> 
> Only changes between runs was changing ioengine and iodepth as indicated
> in the table below.
> 
> Results:
> 
> Engine          Depth           Bw (MiB/sec)
> --------------------------------------------
> libaio            1             441
> syslet            1             574
> sync              1             589
> libaio           32             613
> syslet           32             681
> 
> Results are stable to within +/- 1MiB/sec. So you can see that syslet
> are still a bit slower than sync for depth 1, but beats the pants off
> libaio for equal depths. Note that this is buffered IO, I'll be out for
> the weekend, but I'll hack some direct IO testing up next week to
> compare "real" queuing.
> 
> Just a quick microbenchmark to gauge current overhead...

This is just ramfs, to gauge pure overheads, is that correct ? 

BTW, I'm not surprised at Ingo's initial results of syslet vs libaio
overheads, for aio-stress/fio type streaming io runs, because these cases
do not involve large numbers of outstanding ios. So the overhead of
thread creation with syslets is amortized across the entire run of io
submissions because of the reuse of already created async threads. While
in the libaio case there is a setup and teardown of kiocbs per request.

What I have been concerned about instead in the past when considering
thread based AIO implementations is the resource(memory) consumption impact
on overall system performance and adaptability to varying loads. It is nice
that we can avoid that for the cached cases, but for the general blocking
cases, it is still not clear to me whether we have addressed this well
enough yet. I used to think that even the kiocb was too heavyweight for its
purpose ... especially in terms of scaling to larger loads.

As a really crude (and not very realistic) example of the potential impact
of large numbers of outstanding IOs, I tried some quick direct IO comparisons
using fio:

[global]
ioengine=syslet-rw
buffered=0
rw=randread
bs=64k
size=1024m
iodepth=64

Engine		Depth		Bw (MiB/sec)

libaio		64		17.323
syslet		64		17.524
libaio		20000		15.226
syslet		20000		11.015


Regards
Suparna

-- 
Suparna Bhattacharya (suparna@in.ibm.com)
Linux Technology Center
IBM Software Lab, India

