Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbZCRPoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbZCRPoz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 11:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbZCRPoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 11:44:46 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:38418 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbZCRPop convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 11:44:45 -0400
Message-ID: <49C116BF.9080402@cosmosbay.com>
Date: Wed, 18 Mar 2009 16:43:59 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-aio <linux-aio@kvack.org>, zach.brown@oracle.com
Subject: Re: [patch] eventfd - remove fput() call from possible IRQ context
 (2nd rev)
References: <49B89B22.7080303@cosmosbay.com>	<20090311224712.fb8db075.akpm@linux-foundation.org>	<49B8A75E.6040409@cosmosbay.com>	<20090311233903.f036027a.akpm@linux-foundation.org>	<alpine.DEB.1.10.0903120625340.6040@makko.or.mcafeemobile.com>	<1236986902.7265.73.camel@heimdal.trondhjem.org>	<alpine.DEB.1.10.0903131732300.13254@makko.or.mcafeemobile.com>	<1237003328.7265.98.camel@heimdal.trondhjem.org>	<alpine.DEB.1.10.0903140729060.26556@makko.or.mcafeemobile.com>	<alpine.DEB.1.10.0903141826120.3888@makko.or.mcafeemobile.com>	<20090315174445.GD18305@kvack.org>	<alpine.DEB.1.10.0903151303490.16762@makko.or.mcafeemobile.com>	<x49wsamhpvg.fsf@segfault.boston.devel.redhat.com>	<49C10B6B.3040108@cosmosbay.com> <x49ocvyhmyu.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49ocvyhmyu.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 18 Mar 2009 16:43:59 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer a écrit :
> Eric Dumazet <dada1@cosmosbay.com> writes:
> 
> 
>>> 	rwfd = open("rwfile", O_RDWR|O_DIRECT);		assert(rwfd != -1);
>>> 	if (posix_memalign((void **)&buf, getpagesize(), SIZE) < 0) {
>>> 		perror("posix_memalign");
>>> 		exit(1);
>>> 	}
>>> 	memset(buf, 0x42, SIZE);
>>>
>>> 	/* Write test. */
>>> 	res = io_queue_init(1024, &io_ctx);		assert(res == 0);
>>> 	io_prep_pwrite(&iocb, rwfd, buf, SIZE, 0);
>>> 	io_set_eventfd(&iocb, efd);
>>> 	res = io_submit(io_ctx, 1, iocbs);		assert(res == 1);
>> yes but io_submit() is blocking. so your close(efd) will come after the release in fs/aio.c
> 
> I'm not sure why you think io_submit is blocking.  In my setup, I
> preallocated the file, and the test code opens it with O_DIRECT.  So,
> io_submit should return after the dio is issued, and the I/O size is
> large enough that it should still be outstanding when io_submit returns.

Hmm.. io_submit() is a blocking syscall, this is how I understood fs/aio.c

Then, using strace -tt -T on your program, I can confirm it is quite a long syscall (3.5 seconds,
about time needed to write a 256 MB file on my disk ;) )

16:33:15.861301 eventfd(0)              = 3 <0.000010>
16:33:15.861344 open("rwfile", O_RDWR|O_DIRECT) = 4 <0.000010>
16:33:15.861444 mmap(NULL, 268443648, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f08eec55000 <0.000008>
16:33:16.100040 io_setup(1024, {139676618563584}) = 0 <0.000047>
16:33:16.100149 io_submit(139676618563584, 1, {...}) = 1 <3.558085>
16:33:19.658292 io_getevents(139676618563584, 1, 1, {...}NULL) = 1 <0.258104>
16:33:19.916486 fstat(1, {st_mode=S_IFCHR|0600, st_rdev=makedev(136, 0), ...}) = 0 <0.000007>
16:33:19.916559 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f08ff3b9000 <0.000009>
16:33:19.916607 write(1, "eventfd write test [SUCCESS]\n"..., 29eventfd write test [SUCCESS]
) = 29 <0.000008>
16:33:19.916653 exit_group(0)           = ?


