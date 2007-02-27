Return-Path: <linux-kernel-owner+w=401wt.eu-S1751752AbXB0T0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752AbXB0T0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 14:26:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbXB0T0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 14:26:08 -0500
Received: from brick.kernel.dk ([62.242.22.158]:9159 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbXB0T0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 14:26:06 -0500
Date: Tue, 27 Feb 2007 20:25:45 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: A quick fio test (was Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3)
Message-ID: <20070227192545.GD3733@kernel.dk>
References: <20070226135736.GF3822@kernel.dk> <20070226141315.GA15631@in.ibm.com> <20070226144548.GH3822@kernel.dk> <20070227043331.GA29942@in.ibm.com> <20070227094211.GR3822@kernel.dk> <20070227111258.GA19125@2ka.mipt.ru> <20070227112908.GB4271@kernel.dk> <20070227121958.GB31597@2ka.mipt.ru> <20070227184541.GA3733@kernel.dk> <20070227190831.GA29173@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227190831.GA29173@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27 2007, Evgeniy Polyakov wrote:
> On Tue, Feb 27, 2007 at 07:45:41PM +0100, Jens Axboe (jens.axboe@oracle.com) wrote:
> > > Deadline shows this:
> > > 
> > > sync:
> > > READ: io=1,024MiB, aggrb=38,212KiB/s, minb=38,212KiB/s,
> > > maxb=38,212KiB/s, mint=28099msec, maxt=28099msec
> > > 
> > > libaio:
> > > READ: io=1,024MiB, aggrb=37,933KiB/s, minb=37,933KiB/s,
> > > maxb=37,933KiB/s, mint=28306msec, maxt=28306msec
> > > 
> > > syslet-rw:
> > > READ: io=1,024MiB, aggrb=34,759KiB/s, minb=34,759KiB/s,
> > > maxb=34,759KiB/s, mint=30891msec, maxt=30891msec
> > > 
> > > There were about 10k async schedulings.
> > 
> > I think the issue here is pretty simple - when fio gets a queue full
> > like condition (it reaches the depth you set, 32), it commits them and
> > starts queuing again. Since that'll likely block, it'll get issued by
> > another process. So you suddenly have a nice sequence of reads from one
> > process (pending, only one is actually committed since it's serialized),
> > and then a read further down the line that goes behind those you already
> > committed. Then result is seeky, where it should have been sequential.
> > 
> > Do you get expected results if you set iodepth_low=1? That'll make fio
> > drain the queue before building it up again, should get you a sequential
> > access pattern with syslets.
> 
> With such a change results should be better - not only because seek is
> removed with sequential read, but also number of working threads
> decreases with time - until queue is filled again.

Yep, although it probably doesn't matter for such a low bandwidth test
anyway.

> So, syslet-rw has increased to 37mb/sec out of 39/sync and 38/libaio,
> the latter two did not changed.

I wonder why all three aren't doing 39mb/sec flat here, it's a pretty
trivial case...

> With iodepth of 10k, I get the same performance for
> libaio and syslets - about 36mb/sec, it does not depend on iodepth_low
> being set to 1 or default (full).

Yep, the larger the iodepth, the less costly a seek on new queue buildup
gets. So that is as expected.

> So syslets have small problems with small number of iodepth - its
> performance is about 34mb/sec and then increases to 36 with iodepth
> grow. While libaio decreases from 38 down to 36 mb/sec.

Using your job file and fio HEAD (forces iodepth_low=1 for syslet if
iodepth_low isn't specified), I get:

Engine          Depth   Bw (kb/sec)
-----------------------------------
syslet              1      37163
syslet             32      37197
syslet          10000      36577
libaio              1      37144
libaio             32      37159
libaio          10000      36463
sync                1      37154

Results are highly stable. Note that this test case isn't totally fair,
since libaio isn't really async when you do buffered file IO.

-- 
Jens Axboe

