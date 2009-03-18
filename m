Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbZCRP1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbZCRP1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 11:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbZCRP1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 11:27:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbZCRP1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 11:27:11 -0400
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
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 18 Mar 2009 11:25:45 -0400
In-Reply-To: <49C10B6B.3040108@cosmosbay.com> (Eric Dumazet's message of "Wed,
	18 Mar 2009 15:55:39 +0100")
Message-ID: <x49ocvyhmyu.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <dada1@cosmosbay.com> writes:


>> 	rwfd = open("rwfile", O_RDWR|O_DIRECT);		assert(rwfd != -1);
>> 	if (posix_memalign((void **)&buf, getpagesize(), SIZE) < 0) {
>> 		perror("posix_memalign");
>> 		exit(1);
>> 	}
>> 	memset(buf, 0x42, SIZE);
>> 
>> 	/* Write test. */
>> 	res = io_queue_init(1024, &io_ctx);		assert(res == 0);
>> 	io_prep_pwrite(&iocb, rwfd, buf, SIZE, 0);
>> 	io_set_eventfd(&iocb, efd);
>> 	res = io_submit(io_ctx, 1, iocbs);		assert(res == 1);
>
> yes but io_submit() is blocking. so your close(efd) will come after the release in fs/aio.c

I'm not sure why you think io_submit is blocking.  In my setup, I
preallocated the file, and the test code opens it with O_DIRECT.  So,
io_submit should return after the dio is issued, and the I/O size is
large enough that it should still be outstanding when io_submit returns.

Cheers,
Jeff
