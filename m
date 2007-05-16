Return-Path: <linux-kernel-owner+w=401wt.eu-S1761393AbXEPMwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761393AbXEPMwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 08:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757241AbXEPMwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 08:52:10 -0400
Received: from pat.uio.no ([129.240.10.15]:52097 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbXEPMwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 08:52:09 -0400
Subject: Re: (NFS) BUG: at page-writeback.c:829 [Was: 2.6.22-rc1-mm1]
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <464AF4A6.5060000@gmail.com>
References: <20070515201914.16944e04.akpm@linux-foundation.org>
	 <464AF4A6.5060000@gmail.com>
Content-Type: text/plain
Date: Wed, 16 May 2007 08:52:02 -0400
Message-Id: <1179319922.6521.7.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.142)
X-UiO-Scanned: 6F1722DA78E7AAA34B888A40F659E5A54B0C8E54
X-UiO-Ratelimit-Test: Ratelimit
X-UiO-SPAM-Test: UIO-RATELIMIT remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 2099 total 1774469 max/h 8345 blacklist 0 greylist 0 ratelimit 1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-16 at 14:10 +0200, Jiri Slaby wrote:
> Andrew Morton napsal(a):
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/
> 
> I've got this in dmesg:
> 
> BUG: at /local/xslaby/xxx/mm/page-writeback.c:829 __set_page_dirty_nobuffers()
>  [<c010531e>] dump_trace+0x1ce/0x200
>  [<c010536a>] show_trace_log_lvl+0x1a/0x30
>  [<c0106012>] show_trace+0x12/0x20
>  [<c0106086>] dump_stack+0x16/0x20
>  [<c015566d>] __set_page_dirty_nobuffers+0x11d/0x130
>  [<c0155690>] redirty_page_for_writepage+0x10/0x20
>  [<c01938fc>] __block_write_full_page+0x20c/0x330
>  [<c0193b0a>] block_write_full_page+0xea/0x100
>  [<c0196c82>] blkdev_writepage+0x12/0x20
>  [<c015539e>] __writepage+0xe/0x30
>  [<c01558c2>] write_cache_pages+0x222/0x340
>  [<c0155a03>] generic_writepages+0x23/0x30
>  [<c0155a3e>] do_writepages+0x2e/0x50
>  [<c018decb>] __writeback_single_inode+0x8b/0x470
>  [<c018e75b>] generic_sync_sb_inodes+0x24b/0x470
>  [<c018e9a7>] sync_sb_inodes+0x27/0x30
>  [<c018ec33>] writeback_inodes+0xb3/0xe0
>  [<c01560f2>] wb_kupdate+0x82/0xf0
>  [<c015660b>] pdflush+0xeb/0x1b0
>  [<c0132e72>] kthread+0x42/0x70
>  [<c0104d4b>] kernel_thread_helper+0x7/0x1c
>  =======================
> BUG: at /local/xslaby/xxx/mm/page-writeback.c:829 __set_page_dirty_nobuffers()
>  [<c010531e>] dump_trace+0x1ce/0x200
>  [<c010536a>] show_trace_log_lvl+0x1a/0x30
>  [<c0106012>] show_trace+0x12/0x20
>  [<c0106086>] dump_stack+0x16/0x20
>  [<c015566d>] __set_page_dirty_nobuffers+0x11d/0x130
>  [<f8b1fc5b>] nfs_updatepage+0x7b/0x200 [nfs]
>  [<f8b156df>] nfs_commit_write+0x2f/0x50 [nfs]
>  [<c0150911>] generic_file_buffered_write+0x2a1/0x660
>  [<c0150f52>] __generic_file_aio_write_nolock+0x282/0x520
>  [<c0151252>] generic_file_aio_write+0x62/0xd0
>  [<f8b15def>] nfs_file_write+0xef/0x1c0 [nfs]
>  [<c01715e0>] do_sync_write+0xd0/0x110
>  [<c0171e04>] vfs_write+0x94/0x130
>  [<c017248d>] sys_write+0x3d/0x70
>  [<c01040e8>] syscall_call+0x7/0xb
>  [<b7eb7b3e>] 0xb7eb7b3e
>  =======================
> 
> regards,

The first Oops is not NFS: it is some block file system, however the
problem is the same. The crux of the matter would appear to be that some
task is changing the page_mapping() of random pages while the page lock
is held by another task.

Do you see the same thing in mainline?

Trond

