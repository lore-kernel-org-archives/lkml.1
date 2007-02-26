Return-Path: <linux-kernel-owner+w=401wt.eu-S1030279AbXBZOrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030279AbXBZOrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 09:47:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030291AbXBZOrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 09:47:47 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:16396 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030279AbXBZOrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 09:47:46 -0500
Date: Mon, 26 Feb 2007 15:45:48 +0100
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
Message-ID: <20070226144548.GH3822@kernel.dk>
References: <20070221211355.GA7302@elte.hu> <20070223125247.GO5737@kernel.dk> <20070223135525.GA31569@in.ibm.com> <20070223145826.GA32465@elte.hu> <20070223151515.GA12960@in.ibm.com> <20070223162508.GA16782@kernel.dk> <20070223171348.GA27838@in.ibm.com> <20070226135736.GF3822@kernel.dk> <20070226141315.GA15631@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070226141315.GA15631@in.ibm.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 26 2007, Suparna Bhattacharya wrote:
> On Mon, Feb 26, 2007 at 02:57:36PM +0100, Jens Axboe wrote:
> > 
> > Some more results, using a larger number of processes and io depths. A
> > repeat of the tests from friday, with added depth 20000 for syslet and
> > libaio:
> > 
> > Engine          Depth   Processes       Bw (MiB/sec)
> > ----------------------------------------------------
> > libaio            1         1            602
> > syslet            1         1            759
> > sync              1         1            776
> > libaio           32         1            832
> > syslet           32         1            898
> > libaio        20000         1            581
> > syslet        20000         1            609
> > 
> > syslet still on top. Measuring O_DIRECT reads (of 4kb size) on ramfs
> > with 100 processes each with a depth of 200, reading a per-process
> > private file of 10mb (need to fit in my ram...) 10 times each. IOW,
> > doing 10,000MiB of IO in total:
> 
> But, why ramfs ? Don't we want to exercise the case where O_DIRECT actually
> blocks ? Or am I missing something here ?

Just overhead numbers for that test case, lets try something like your
described job.

Test case is doing random reads from /dev/sdb, in chunks of 64kb:

Engine          Depth   Processes       Bw (KiB/sec)
----------------------------------------------------
libaio           200       100            2813
syslet           200       100            3944
libaio         20000         1            2793
syslet         20000         1            3854
sync (*)       20000         1            2866

deadline was used for IO scheduling, to minimize impact. Not sure why
syslet actually does so much better here, looing at vmstat the rate is
steady and all runs are basically 50/50 idle/wait. One difference is
that the submission itself takes a long time on libaio, since the
io_submit() will block on request allocation.  The generated IO pattern
from each process is the same for all runs. The drive is a lousy sata
that doesn't even do queuing, FWIW.

[*] Just for comparison, the depth is obviously really 1 at the kernel
    side since it's sync.

-- 
Jens Axboe

