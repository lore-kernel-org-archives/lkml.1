Return-Path: <linux-kernel-owner+w=401wt.eu-S1758978AbYABUmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978AbYABUmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:42:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758202AbYABUmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:42:36 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:53438 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758151AbYABUme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:42:34 -0500
Message-ID: <477BF72B.4000608@oracle.com>
Date: Wed, 02 Jan 2008 12:42:19 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Erez Zadok <ezk@cs.sunysb.edu>
CC: linux-kernel@vger.kernel.org, ext3-users@redhat.com,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
       Jan Kara <jack@suse.cz>
Subject: Re: lockdep warning with LTP dio test (v2.6.24-rc6-125-g5356f66)
References: <200712242302.lBON2O8s011190@agora.fsl.cs.sunysb.edu>
In-Reply-To: <200712242302.lBON2O8s011190@agora.fsl.cs.sunysb.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Erez Zadok wrote:
> Setting: ltp-full-20071031, dio01 test on ext3 with Linus's latest tree.
> Kernel w/ SMP, preemption, and lockdep configured.

This is a real lock ordering problem.  Thanks for reporting it.

The updating of atime inside sys_mmap() orders the mmap_sem in the vfs
outside of the journal handle in ext3's inode dirtying:

> -> #1 (jbd_handle){--..}:
>        [<c023068f>] __lock_acquire+0x9cc/0xb95
>        [<c0230c2f>] lock_acquire+0x5f/0x78
>        [<c029c7e9>] journal_start+0xee/0xf8
>        [<c02959d6>] ext3_journal_start_sb+0x48/0x4a
>        [<c029152b>] ext3_dirty_inode+0x27/0x6c
>        [<c026f701>] __mark_inode_dirty+0x29/0x144
>        [<c026817b>] touch_atime+0xb7/0xbc
>        [<c023af6d>] generic_file_mmap+0x2d/0x42
>        [<c024a5cc>] mmap_region+0x1e6/0x3b4
>        [<c024aa6b>] do_mmap_pgoff+0x1fb/0x253
>        [<c02067af>] sys_mmap2+0x9b/0xb5
>        [<c020275e>] syscall_call+0x7/0xb
>        [<ffffffff>] 0xffffffff

ext3_direct_IO() orders the journal handle outside of the mmap_sem that
dio_get_page() acquires to pin pages with get_user_pages():

> -> #0 (&mm->mmap_sem){----}:
>        [<c023057f>] __lock_acquire+0x8bc/0xb95
>        [<c0230c2f>] lock_acquire+0x5f/0x78
>        [<c0397d4f>] down_read+0x3a/0x4c
>        [<c02778a2>] dio_get_page+0x4e/0x15d
>        [<c0278352>] __blockdev_direct_IO+0x431/0xa81
>        [<c0291318>] ext3_direct_IO+0x10c/0x1a1
>        [<c023c091>] generic_file_direct_IO+0x124/0x139
>        [<c023c0fc>] generic_file_direct_write+0x56/0x11c
>        [<c023ca15>] __generic_file_aio_write_nolock+0x33d/0x489
>        [<c023cbb9>] generic_file_aio_write+0x58/0xb6
>        [<c028d4e3>] ext3_file_write+0x27/0x99
>        [<c0256d0f>] do_sync_write+0xc5/0x102
>        [<c0257463>] vfs_write+0x90/0x119
>        [<c0257a25>] sys_write+0x3d/0x61
>        [<c02026d6>] sysenter_past_esp+0x5f/0xa5
>        [<ffffffff>] 0xffffffff

Two fixes come to mind:

1) use something like Peter's ->mmap_prepare() to update atime before
acquiring the mmap_sem.  ( http://lkml.org/lkml/2007/11/11/97 ).  I
don't know if this would leave more paths which do a journal_start()
while holding the mmap_sem.

2) rework ext3's dio to only hold the jbd handle in ext3_get_block().
Chris has a patch for this kicking around somewhere but I'm told it has
problems exposing old blocks in ordered data mode.

Does anyone have preferences?  I could go either way.  I certainly don't
like the idea of journal handles being held across the entirety of
fs/direct-io.c.  It's yet another case of O_DIRECT differing wildly from
the buffered path :(.

- z
