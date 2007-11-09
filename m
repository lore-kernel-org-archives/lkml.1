Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbXKIRmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbXKIRmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 12:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754641AbXKIRmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 12:42:06 -0500
Received: from pat.uio.no ([129.240.10.15]:56812 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553AbXKIRmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 12:42:05 -0500
Subject: Re: dio_get_page() lockdep complaints
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Zach Brown <zach.brown@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-aio@kvack.org, Chris Mason <chris.mason@oracle.com>
In-Reply-To: <4734992C.7000408@oracle.com>
References: <20070419073828.GB20928@kernel.dk>
	 <1194627742.6289.175.camel@twins>  <4734992C.7000408@oracle.com>
Content-Type: text/plain
Date: Fri, 09 Nov 2007 12:45:00 -0500
Message-Id: <1194630300.7459.65.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.111)
X-UiO-Scanned: C7FE6CD2FD7C0B442739A492DF772C0CE74E7ED4
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 465 total 5035297 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-11-09 at 09:30 -0800, Zach Brown wrote:
> So, reiserfs and NFS are nesting i_mutex inside the mmap_sem.
> 
> >>        [<b038c6e5>] mutex_lock+0x1c/0x1f
> >>        [<b01b17e9>] reiserfs_file_release+0x54/0x447
> >>        [<b016afe7>] __fput+0x53/0x101
> >>        [<b016b0ee>] fput+0x19/0x1c
> >>        [<b015bcd5>] remove_vma+0x3b/0x4d
> >>        [<b015c659>] do_munmap+0x17f/0x1cf
> 
> >        [<ffffffff802686a1>] _mutex_lock+0x28/0x34
> >        [<ffffffff883e71d0>] nfs_revalidate_mapping+0x6d/0xac [nfs]
> >        [<ffffffff883e4b51>] nfs_file_mmap+0x5c/0x74 [nfs]
> >        [<ffffffff8020df7e>] do_mmap_pgoff+0x51a/0x817
> >        [<ffffffff80225d19>] sys_mmap+0x90/0x119
> 
> I think i_mutex is fundamentally nested outside of the mmap_sem because
> of faulting in the buffered write path.  I think these warnings could be
> reproduced with a careful test app which tries buffered writes from an
> address which will fault.
> 
> DIO just tripped it up because it *always* performs get_user_pages() on
> the memory.
> 
> So reiser and NFS need to be fixed.  No?

Actually, it is rather mmap() needs to be fixed. It is cold calling the
filesystem while holding all sorts of nasty locks. It needs to be
migrated to the same sort of syscall layout as read() and write().

You _first_ call the filesystem so that it can make whatever
preparations it needs outside the lock. The filesystem then calls the
VM, which can then call the filesystem back if needed.

Trond

