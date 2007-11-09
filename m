Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbXKIRa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbXKIRa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 12:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbXKIRaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 12:30:20 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:59928 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596AbXKIRaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 12:30:19 -0500
Message-ID: <4734992C.7000408@oracle.com>
Date: Fri, 09 Nov 2007 09:30:20 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-aio@kvack.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: dio_get_page() lockdep complaints
References: <20070419073828.GB20928@kernel.dk> <1194627742.6289.175.camel@twins>
In-Reply-To: <1194627742.6289.175.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


So, reiserfs and NFS are nesting i_mutex inside the mmap_sem.

>>        [<b038c6e5>] mutex_lock+0x1c/0x1f
>>        [<b01b17e9>] reiserfs_file_release+0x54/0x447
>>        [<b016afe7>] __fput+0x53/0x101
>>        [<b016b0ee>] fput+0x19/0x1c
>>        [<b015bcd5>] remove_vma+0x3b/0x4d
>>        [<b015c659>] do_munmap+0x17f/0x1cf

>        [<ffffffff802686a1>] _mutex_lock+0x28/0x34
>        [<ffffffff883e71d0>] nfs_revalidate_mapping+0x6d/0xac [nfs]
>        [<ffffffff883e4b51>] nfs_file_mmap+0x5c/0x74 [nfs]
>        [<ffffffff8020df7e>] do_mmap_pgoff+0x51a/0x817
>        [<ffffffff80225d19>] sys_mmap+0x90/0x119

I think i_mutex is fundamentally nested outside of the mmap_sem because
of faulting in the buffered write path.  I think these warnings could be
reproduced with a careful test app which tries buffered writes from an
address which will fault.

DIO just tripped it up because it *always* performs get_user_pages() on
the memory.

So reiser and NFS need to be fixed.  No?

(reiser is grabbing i_mutex from any final fput?  brave!)

- z
