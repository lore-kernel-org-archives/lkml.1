Return-Path: <linux-kernel-owner+w=401wt.eu-S1753806AbXDRFlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbXDRFlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 01:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753782AbXDRFlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 01:41:11 -0400
Received: from smtp.osdl.org ([65.172.181.24]:47826 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806AbXDRFlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 01:41:08 -0400
Date: Tue, 17 Apr 2007 22:37:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Florin Iucha <florin@iucha.net>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues
Message-Id: <20070417223738.8f49a39f.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704172148490.31155@woody.linux-foundation.org>
References: <1176792399.3035.30.camel@twins>
	<1176796503.3035.33.camel@twins>
	<87hcrfaqam.fsf@duaron.myhome.or.jp>
	<20070418011946.11679.34920.stgit@heimdal.trondhjem.org>
	<20070417195823.943f9472.akpm@linux-foundation.org>
	<1176865565.6796.16.camel@heimdal.trondhjem.org>
	<20070418033055.GA24044@iucha.net>
	<1176868485.6796.42.camel@heimdal.trondhjem.org>
	<20070418040730.GC24044@iucha.net>
	<20070417211350.ebba1493.akpm@linux-foundation.org>
	<20070418043040.GD24044@iucha.net>
	<alpine.LFD.0.98.0704172148490.31155@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007 22:14:02 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Tue, 17 Apr 2007, Florin Iucha wrote:
> > 
> > Already did.  Traces from vanilla kernel at
> >    http://iucha.net/nfs/21-rc7/big-copy
> 
> Well, there's a pdflush in io_schedule_timeout/congestion_wait, and 
> there's a nfsv4-scv in svc_recv/nfs_callback_sv, and a lot of processes 
> either just in schedule_timeout or similar "normal" waiting (pollwait 
> etc).
> 
> [ The call traces could be prettier, but sadly, even if you enable frame 
>   pointers, the x86-64 kernel is too stupid to follow them. So you kind of 
>   just have to ignore the noise) ]
> 
> The triggering process looks like it might be that "cp", it is in the 
> __wait_on_bit/sync_page/wait_on_page_bit/wait_on_page_writeback_range/ 
> filemap_fdatawait.
> 
> Is this a trace from the "big copy" hang, or from a gnome splashscreen 
> hang? It *looks* like it's a big copy. Yes/no?
> 
> Anyway, looks like the cp did a "utimes()" system call, which triggers 
> "nfs_setattr(), which in turn triggers the filemap_fdatawait() and some 
> kind of endless wait. Nothing stands out from the traces, in other words. 
> Doesn't look like a locking thing, for example - we're not stuck on some 
> inode semaphore, we're literally waiting for the page to be written out.
> 

That's the unpatched kernel.  I think the trace with Trond's patchset
is http://iucha.net/nfs/21-rc7-nfs1/big-copy

[  243.594565] cp            S 00000038b55df454     0  2547   2526 (NOTLB)
[  243.594570]  ffff810078339988 0000000000000086 0000000000000000 00000001000087a9
[  243.594574]  ffff810078339908 ffffffff80162c03 000000000000000a ffff81007f612fe0
[  243.594579]  ffffffff8054c3e0 000000000000063f ffff81007f6131b8 0000000000000292
[  243.594583] Call Trace:
[  243.594587]  [<ffffffff80162c03>] _spin_lock_irqsave+0x11/0x18
[  243.594591]  [<ffffffff8011c0c5>] __mod_timer+0xa9/0xbb
[  243.594595]  [<ffffffff80161283>] schedule_timeout+0x8d/0xb4
[  243.594599]  [<ffffffff8018b8ac>] process_timeout+0x0/0xb
[  243.594603]  [<ffffffff80160bcf>] io_schedule_timeout+0x28/0x33
[  243.594607]  [<ffffffff801a9400>] congestion_wait_interruptible+0x86/0xa3
[  243.594611]  [<ffffffff8019489f>] autoremove_wake_function+0x0/0x38
[  243.594615]  [<ffffffff80418952>] rpc_save_sigmask+0x2f/0x31
[  243.594619]  [<ffffffff80236cfa>] nfs_writepage_setup+0xc8/0x482
[  243.594624]  [<ffffffff80237507>] nfs_updatepage+0x101/0x143
[  243.594628]  [<ffffffff8022da30>] nfs_commit_write+0x2e/0x41
[  243.594633]  [<ffffffff8010fb96>] generic_file_buffered_write+0x530/0x773
[  243.594639]  [<ffffffff8015fae7>] copy_user_generic_string+0x17/0x40
[  243.594643]  [<ffffffff8010cb51>] file_read_actor+0xaa/0x130
[  243.594648]  [<ffffffff80115ee8>] __generic_file_aio_write_nolock+0x38b/0x3fe
[  243.594652]  [<ffffffff8013824c>] debug_mutex_free_waiter+0x5b/0x5f
[  243.594657]  [<ffffffff80120d73>] generic_file_aio_write+0x64/0xc0
[  243.594662]  [<ffffffff8022e128>] nfs_file_write+0xee/0x15a
[  243.594666]  [<ffffffff801175c8>] do_sync_write+0xe2/0x126
[  243.594671]  [<ffffffff8019489f>] autoremove_wake_function+0x0/0x38
[  243.594676]  [<ffffffff80162ab5>] _spin_unlock+0x9/0xb
[  243.594680]  [<ffffffff80116294>] vfs_write+0xae/0x137
[  243.594684]  [<ffffffff80116bea>] sys_write+0x47/0x70
[  243.594688]  [<ffffffff8015ad5e>] system_call+0x7e/0x83

At a guess, bdi_write_congested() is failing to return false.  (nfs_update_request()
got inlined in nfs_writepage_setup(), even though it was defined afterwards?  gcc
got smarter)

We have a stuck pdflush, presumably waiting for dirty+writeback memory to subside:

[  243.594761] pdflush       D 00000038b5643b16     0  2552     11 (L-TLB)
[  243.594766]  ffff81000c617d70 0000000000000046 0000000000000000 00000001000087a9
[  243.594770]  ffff81000c617cf0 ffffffff80162c03 000000000000000a ffff81007e5ff510
[  243.594775]  ffff810002f4a080 0000000000000ae5 ffff81007e5ff6e8 0000000100000282
[  243.594779] Call Trace:
[  243.594783]  [<ffffffff80162c03>] _spin_lock_irqsave+0x11/0x18
[  243.594787]  [<ffffffff8011c0c5>] __mod_timer+0xa9/0xbb
[  243.594792]  [<ffffffff801946f2>] keventd_create_kthread+0x0/0x79
[  243.594795]  [<ffffffff80161283>] schedule_timeout+0x8d/0xb4
[  243.594799]  [<ffffffff8018b8ac>] process_timeout+0x0/0xb
[  243.594803]  [<ffffffff80160bcf>] io_schedule_timeout+0x28/0x33
[  243.594806]  [<ffffffff801a935e>] congestion_wait+0x6b/0x87
[  243.594810]  [<ffffffff8019489f>] autoremove_wake_function+0x0/0x38
[  243.594814]  [<ffffffff8014da11>] writeback_inodes+0xe1/0xea
[  243.594818]  [<ffffffff80153381>] pdflush+0x0/0x1e3
[  243.594821]  [<ffffffff801a732c>] wb_kupdate+0xbb/0x113
[  243.594825]  [<ffffffff80153381>] pdflush+0x0/0x1e3
[  243.594828]  [<ffffffff801534b9>] pdflush+0x138/0x1e3
[  243.594831]  [<ffffffff801a7271>] wb_kupdate+0x0/0x113
[  243.594835]  [<ffffffff801315d6>] kthread+0xd8/0x10b
[  243.594839]  [<ffffffff801270d2>] schedule_tail+0x45/0xa5
[  243.594843]  [<ffffffff8015bb78>] child_rip+0xa/0x12
[  243.594847]  [<ffffffff801946f2>] keventd_create_kthread+0x0/0x79
[  243.594850]  [<ffffffff801471f5>] worker_thread+0x0/0x14b
[  243.594854]  [<ffffffff801314fe>] kthread+0x0/0x10b
[  243.594858]  [<ffffffff8015bb6e>] child_rip+0x0/0x12

at a guess I'd say we have a ton of memory under writeback, but the completions
aren't coming back.

Florin, can we please see /proc/meminfo as well?

Also the result of `echo m > /proc/sysrq-trigger'

Thanks.
