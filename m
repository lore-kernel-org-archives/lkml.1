Return-Path: <linux-kernel-owner+w=401wt.eu-S1751968AbXE2WvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbXE2WvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbXE2WvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:51:09 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:28102 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbXE2WvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:51:08 -0400
Date: Tue, 29 May 2007 15:49:16 -0700
From: Zach Brown <zach.brown@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
Message-ID: <20070529224916.GK7875@mami.zabbo.net>
References: <20070529212718.GH7875@mami.zabbo.net> <alpine.LFD.0.98.0705291447440.26602@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705291447440.26602@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> .. so don't keep us in suspense. Do you have any numbers for anything 
> (like Oracle, to pick a random thing out of thin air ;) that might 
> actually indicate whether this actually works or not?

I haven't gotten to running Oracle's database against it.  It is going
to be Very Cranky if O_DIRECT writes aren't concurrent, and that's going
to take a bit of work in fs/direct-io.c.

I've done initial micro-benchmarking runs for basic sanity testing with
fio.  They haven't wildly regressed, that's about as much as can be said
with confidence so far :).

Take a streaming O_DIRECT read.  1meg requests, 64 in flight.

str: (g=0): rw=read, bs=1M-1M/1M-1M, ioengine=libaio, iodepth=64

mainline:

	  read : io=3,405MiB, bw=97,996KiB/s, iops=93, runt= 36434msec

aio+syslets:

	  read : io=3,452MiB, bw=99,115KiB/s, iops=94, runt= 36520msec

That's on an old gigabit copper FC array with 10 drives behind a, no
seriously, qla2100.

The real test is the change in memory and cpu consumption, and I haven't
modified fio to take reasonably precise measurements of those yet.  Once
I get O_DIRECT writes concurrent that'll be the next step. 

I was pleased to see my motivation for the patches, to avoid having to
add specific support for operations to be called from fs/aio.c, work
out.  

Take the case of 4k random buffered reads from a block device with a
cold cache:

read: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=64

mainine:

  read : io=16,116KiB, bw=457KiB/s, iops=111, runt= 36047msec
    slat (msec): min=    4, max=  629, avg=563.17, stdev=71.92
    clat (msec): min=    0, max=    0, avg= 0.00, stdev= 0.00

aio+syslets:

  read : io=125MiB, bw=3,634KiB/s, iops=887, runt= 36147msec
    slat (msec): min=    0, max=    3, avg= 0.00, stdev= 0.08
    clat (msec): min=    2, max=  643, avg=71.59, stdev=74.25

aio+syslets w/o cfq

  read : io=208MiB, bw=6,057KiB/s, iops=1,478, runt= 36071msec
    slat (msec): min=    0, max=   15, avg= 0.00, stdev= 0.09
    clat (msec): min=    2, max=  758, avg=42.75, stdev=37.33

Everyone step back and thank Jens for writing a tool that gives us
interesting data without us always having to craft some stupid specific
test each and every time.  Thanks, Jens!

In the mainline number fio clearly shows the buffered read submissions
being handled synchronously.  The mainline buffered IO paths doesn't
know to identify and work with iocbs so requests are handled in series.

In the +syslet number we see the __async_schedule() catching
the blocking buffered read, letting the submission proceed
asynchronously.  We get async behaviour without having to touch any of
the buffered IO paths.

Then we turn off cfq and we actually start to saturate the (relatively
ancient) drives :).

I need to mail Jens about that cfq behaviour, but I'm guessing it's
expected behaviour of a sort -- each syslet thread gets its own
io_context instead of inheriting it from its parent.

- z
