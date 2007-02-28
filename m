Return-Path: <linux-kernel-owner+w=401wt.eu-S1751735AbXB1Iha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbXB1Iha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 03:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbXB1Iha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 03:37:30 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:55003 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbXB1Ih3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 03:37:29 -0500
Date: Wed, 28 Feb 2007 09:31:00 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Suparna Bhattacharya <suparna@in.ibm.com>
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
Message-ID: <20070228083100.GM3733@kernel.dk>
References: <20070223145826.GA32465@elte.hu> <20070223151515.GA12960@in.ibm.com> <20070223162508.GA16782@kernel.dk> <20070223171348.GA27838@in.ibm.com> <20070226135736.GF3822@kernel.dk> <20070226141315.GA15631@in.ibm.com> <20070226144548.GH3822@kernel.dk> <20070227043331.GA29942@in.ibm.com> <20070227094211.GR3822@kernel.dk> <20070227123932.GA8720@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227123932.GA8720@in.ibm.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27 2007, Suparna Bhattacharya wrote:
> > It's not bad for such a high depth/batch setting, but I still wonder why
> > are results are so different. I'll look around for an x86 box with some
> > TCQ/NCQ enabled storage attached for testing. Can you pass me your
> > command line or job file (whatever you use) so we are on the same page?
> 
> Sure - I used variations of the following job file (e.g. engine=syslet-rw,
> iodepth=20000).
> 
> Also the io scheduler on my system is set to Anticipatory by default.
> FWIW it is a 4 way SMP (PIII, 700MHz)
> 
> ; aio-stress -l -O -o3 <1GB file>
> [global]
> ioengine=libaio
> buffered=0
> rw=randread
> bs=64k
> size=1024m
> directory=/kdump/suparna
> 
> [testfile2]
> iodepth=64
> iodepth_batch=8

Ok, now that I can run this on more than x86, I gave it a spin on a box
with a little more potent storage. This is a core 2 quad, disks are
7200rpm sata (with NCQ) and a 15krpm SCSI disk. IO scheduler is
deadline.

SATA disk:

Engine          Depth      Batch	Bw (KiB/sec)
----------------------------------------------------
libaio		64	   8		17,486
syslet		64	   8		17,357
libaio		20000	   8		17,625
syslet		20000	   8		16,526
sync            1          1             7,529


SCSI disk:

Engine          Depth      Batch	Bw (KiB/sec)
----------------------------------------------------
libaio		64	   8		20,723
syslet		64	   8		20,742
libaio		20000	   8		21,125
syslet		20000	   8		19,610
sync            1          1            16,659


> > > Engine          Depth      Batch	Bw (KiB/sec)
> > > ----------------------------------------------------
> > > libaio		64	   default	17,429
> > > syslet		64	   default	16,155
> > > libaio		20000	   default	15,494
> > > syslet		20000	   default	7,971
> > >
> > If iodepth_batch isn't set, the syslet queued io will be serialized and
> 
> I see, so then this particular setting is not very meaningful

Not if you want to take advantage of hw queuing, as in this random
workload. fio being a test tool, it's important to be able to control as
many aspects of what happens as possible. That means you can also do
things that you do not want to do in real life, having a pending list of
20000 serialized requests is indeed one of them. It also means you
pretty much have to know what you are doing, when testing little details
like this.

-- 
Jens Axboe

