Return-Path: <linux-kernel-owner+w=401wt.eu-S1751446AbXB0SqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbXB0SqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 13:46:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbXB0SqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 13:46:05 -0500
Received: from brick.kernel.dk ([62.242.22.158]:23036 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbXB0SqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 13:46:02 -0500
Date: Tue, 27 Feb 2007 19:45:41 +0100
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
Message-ID: <20070227184541.GA3733@kernel.dk>
References: <20070223162508.GA16782@kernel.dk> <20070223171348.GA27838@in.ibm.com> <20070226135736.GF3822@kernel.dk> <20070226141315.GA15631@in.ibm.com> <20070226144548.GH3822@kernel.dk> <20070227043331.GA29942@in.ibm.com> <20070227094211.GR3822@kernel.dk> <20070227111258.GA19125@2ka.mipt.ru> <20070227112908.GB4271@kernel.dk> <20070227121958.GB31597@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227121958.GB31597@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27 2007, Evgeniy Polyakov wrote:
> On Tue, Feb 27, 2007 at 12:29:08PM +0100, Jens Axboe (jens.axboe@oracle.com) wrote:
> > On Tue, Feb 27 2007, Evgeniy Polyakov wrote:
> > > My two coins:
> > > # cat job
> > > [global]
> > > bs=8k
> > > size=1g
> > > direct=0
> > > ioengine=sync
> > > iodepth=32
> > > rw=read
> > > 
> > > [file]
> > > filename=/home/user/test
> > > 
> > > sync: 
> > > READ: io=1,024MiB, aggrb=39,329KiB/s, minb=39,329KiB/s,
> > > maxb=39,329KiB/s, mint=27301msec, maxt=27301msec
> > > 
> > > libaio:
> > > READ: io=1,024MiB, aggrb=39,435KiB/s, minb=39,435KiB/s,
> > > maxb=39,435KiB/s, mint=27228msec, maxt=27228msec
> > > 
> > > syslet-rw:
> > > READ: io=1,024MiB, aggrb=29,567KiB/s, minb=29,567KiB/s,
> > > maxb=29,567KiB/s, mint=36315msec, maxt=36315msec
> > > 
> > > During syslet-rw test about 9500 async schduledes happend.
> > > I use fio-git-20070226150114.tar.gz
> > 
> > That looks pretty pathetic :-). What IO scheduler did you use? syslets
> > will confuse CFQ currently, so you want to compare with using eg
> > deadline or as. That is one of the downsides of this approach.
> 
> Deadline shows this:
> 
> sync:
> READ: io=1,024MiB, aggrb=38,212KiB/s, minb=38,212KiB/s,
> maxb=38,212KiB/s, mint=28099msec, maxt=28099msec
> 
> libaio:
> READ: io=1,024MiB, aggrb=37,933KiB/s, minb=37,933KiB/s,
> maxb=37,933KiB/s, mint=28306msec, maxt=28306msec
> 
> syslet-rw:
> READ: io=1,024MiB, aggrb=34,759KiB/s, minb=34,759KiB/s,
> maxb=34,759KiB/s, mint=30891msec, maxt=30891msec
> 
> There were about 10k async schedulings.

I think the issue here is pretty simple - when fio gets a queue full
like condition (it reaches the depth you set, 32), it commits them and
starts queuing again. Since that'll likely block, it'll get issued by
another process. So you suddenly have a nice sequence of reads from one
process (pending, only one is actually committed since it's serialized),
and then a read further down the line that goes behind those you already
committed. Then result is seeky, where it should have been sequential.

Do you get expected results if you set iodepth_low=1? That'll make fio
drain the queue before building it up again, should get you a sequential
access pattern with syslets.

-- 
Jens Axboe

