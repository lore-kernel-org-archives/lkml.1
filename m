Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbZCRQOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbZCRQOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 12:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbZCRQO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 12:14:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbZCRQO2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 12:14:28 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-aio <linux-aio@kvack.org>, zach.brown@oracle.com
Subject: Re: [patch] eventfd - remove fput() call from possible IRQ context (2nd rev)
References: <49B89B22.7080303@cosmosbay.com>
	<20090311224712.fb8db075.akpm@linux-foundation.org>
	<49B8A75E.6040409@cosmosbay.com>
	<20090311233903.f036027a.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0903120625340.6040@makko.or.mcafeemobile.com>
	<1236986902.7265.73.camel@heimdal.trondhjem.org>
	<alpine.DEB.1.10.0903131732300.13254@makko.or.mcafeemobile.com>
	<1237003328.7265.98.camel@heimdal.trondhjem.org>
	<alpine.DEB.1.10.0903140729060.26556@makko.or.mcafeemobile.com>
	<alpine.DEB.1.10.0903141826120.3888@makko.or.mcafeemobile.com>
	<20090315174445.GD18305@kvack.org>
	<alpine.DEB.1.10.0903151303490.16762@makko.or.mcafeemobile.com>
	<x49wsamhpvg.fsf@segfault.boston.devel.redhat.com>
	<49C10B6B.3040108@cosmosbay.com>
	<x49ocvyhmyu.fsf@segfault.boston.devel.redhat.com>
	<49C116BF.9080402@cosmosbay.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 18 Mar 2009 12:13:01 -0400
In-Reply-To: <49C116BF.9080402@cosmosbay.com> (Eric Dumazet's message of "Wed,
	18 Mar 2009 16:43:59 +0100")
Message-ID: <x49bpryhks2.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <dada1@cosmosbay.com> writes:

> Jeff Moyer a écrit :
>> Eric Dumazet <dada1@cosmosbay.com> writes:
>> 
>> 
>>>> 	rwfd = open("rwfile", O_RDWR|O_DIRECT);		assert(rwfd != -1);
>>>> 	if (posix_memalign((void **)&buf, getpagesize(), SIZE) < 0) {
>>>> 		perror("posix_memalign");
>>>> 		exit(1);
>>>> 	}
>>>> 	memset(buf, 0x42, SIZE);
>>>>
>>>> 	/* Write test. */
>>>> 	res = io_queue_init(1024, &io_ctx);		assert(res == 0);
>>>> 	io_prep_pwrite(&iocb, rwfd, buf, SIZE, 0);
>>>> 	io_set_eventfd(&iocb, efd);
>>>> 	res = io_submit(io_ctx, 1, iocbs);		assert(res == 1);
>>> yes but io_submit() is blocking. so your close(efd) will come after the release in fs/aio.c
>> 
>> I'm not sure why you think io_submit is blocking.  In my setup, I
>> preallocated the file, and the test code opens it with O_DIRECT.  So,
>> io_submit should return after the dio is issued, and the I/O size is
>> large enough that it should still be outstanding when io_submit returns.
>
> Hmm.. io_submit() is a blocking syscall, this is how I understood fs/aio.c

Hi, Eric,

The whole point of io_submit is to allow you to submit I/O without
waiting for it.  There are known cases where io_submit will block, of
course, such as when we run out of request descriptors.  See the
io_submit.stp script for some examples.[1]

Now, I admit I was testing using an SSD, so I didn't actually notice the
time it took for the 256MB write (!!!).  I tried the reproducer I posted
on my F9 box, and here is the output I get:

BUG: sleeping function called from invalid context at
fs/file_table.c:262
in_atomic():1, irqs_disabled():1
Pid: 0, comm: swapper Not tainted 2.6.27.15-78.2.23.fc9.x86_64 #1

Call Trace:
 <IRQ>  [<ffffffff8103892e>] __might_sleep+0xe7/0xec
 [<ffffffff810bfa86>] __fput+0x35/0x16d
 [<ffffffff810bfbd3>] fput+0x15/0x17
 [<ffffffff810d71bb>] really_put_req+0x34/0x9c
 [<ffffffff810d72f0>] __aio_put_req+0xcd/0xda
 [<ffffffff810d7f77>] aio_complete+0x15d/0x19f
 [<ffffffff810e7016>] dio_bio_end_aio+0x8e/0xa0
 [<ffffffff810e32ab>] bio_endio+0x2a/0x2c
 [<ffffffff8113beae>] req_bio_endio+0x9d/0xba
 [<ffffffff8113c073>] __end_that_request_first+0x1a8/0x2b5
 [<ffffffff8113cb89>] blk_end_io+0x2f/0xa9
 [<ffffffff8113cc2f>] blk_end_request+0xe/0x10
 [<ffffffffa005d30b>] scsi_end_request+0x30/0x90 [scsi_mod]
 [<ffffffffa005d9e9>] scsi_io_completion+0x1aa/0x3b3 [scsi_mod]
 [<ffffffffa0057658>] scsi_finish_command+0xde/0xe7 [scsi_mod]
 [<ffffffffa005de68>] scsi_softirq_done+0xe4/0xed [scsi_mod]
 [<ffffffff8113baa8>] blk_done_softirq+0x7e/0x8e
 [<ffffffff81045146>] __do_softirq+0x7e/0x10c
 [<ffffffff81011bfc>] call_softirq+0x1c/0x28
 [<ffffffff81012e06>] do_softirq+0x4d/0xb0
 [<ffffffff81044d1b>] irq_exit+0x4e/0x9d
 [<ffffffff81013122>] do_IRQ+0x147/0x169
 [<ffffffff81010963>] ret_from_intr+0x0/0x2e
 <EOI>  [<ffffffff810173a9>] ? mwait_idle+0x3e/0x4f
 [<ffffffff810173a0>] ? mwait_idle+0x35/0x4f
 [<ffffffff8100f2a7>] ? cpu_idle+0xb2/0x10b
 [<ffffffff812af35d>] ? rest_init+0x61/0x63

So, I think it is a valid reproducer as it stands.

> Then, using strace -tt -T on your program, I can confirm it is quite a long syscall (3.5 seconds,
> about time needed to write a 256 MB file on my disk ;) )

Did you preallocate the file?

Cheers,
Jeff

[1] http://sourceware.org/systemtap/wiki/ScriptsTools?action=AttachFile&do=view&target=io_submit.stp
