Return-Path: <linux-kernel-owner+w=401wt.eu-S1753119AbZLXAaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbZLXAaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 19:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbZLXAaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 19:30:25 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:42939 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbZLXAaY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 19:30:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=CoNqs+xWnA8/QbOl6u4RjCCe3xk3TUj8XBTadneeuoXATacEla9ZgWGcEc1imr5oq1
         8utbo93jNBI17D0DUgfT/PHA8dJsuLOmIlYUDWQ+Uku7OhmMai7FbbaoU8IYpVfSAMPN
         VvwD+MtbQaKPVUMkXTCBQhQJ6GmeVogijkg1w=
MIME-Version: 1.0
In-Reply-To: <20091223060634.GC14805@elte.hu>
References: <86802c440912222050o2d634667p4702a87171d045ed@mail.gmail.com>
	 <20091223060634.GC14805@elte.hu>
Date: Wed, 23 Dec 2009 16:30:23 -0800
X-Google-Sender-Auth: 2451f7ac9540b913
Message-ID: <86802c440912231630g6ae8d37cu4abf96f87fea3edf@mail.gmail.com>
Subject: Re: lockdep with reiserfs
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/22 Ingo Molnar <mingo@elte.hu>:
>
> * Yinghai Lu <yinghai@kernel.org> wrote:
>
>> x:~ # mount /dev/sda2 /xx
>>
>> [  277.586941] =======================================================
>> [  277.594680] [ INFO: possible circular locking dependency detected ]
>> [  277.601299] 2.6.33-rc1-tip-yh-00304-g97a015d-dirty #1007
>> [  277.605492] -------------------------------------------------------
>> [  277.622611] mount/19427 is trying to acquire lock:
>> [  277.627353]  (&journal->j_mutex){+.+...}, at: [<ffffffff811c6d40>]
>> do_journal_begin_r+0x9f/0x308
>
> Frederic has posted the patch below to lkml - does it do the trick for you?
>
with that patch, the problem still happen...

how to duplicate it:
1. boot sles 11 to user mode
2. hard reset the system
3. boot from network, current kernel with ramdisk as /
4. mount the root fs of sles11, will get this warning.

YH

x:/ # mount /dev/sda2 /xx
l
[ 2645.186516] =======================================================
[ 2645.194297] [ INFO: possible circular locking dependency detected ]
[ 2645.205945] 2.6.33-rc1-tip-yh-00306-gae7a88c-dirty #1009
[ 2645.210995] -------------------------------------------------------
[ 2645.225078] mount/23498 is trying to acquire lock:
[ 2645.228448]  (&journal->j_mutex){+.+...}, at: [<ffffffff811c6d3c>]
do_journal_begin_r+0x9f/0x308
[ 2645.s247950]
[ 2645.247951] but task is already holding lock:
[ 2645.254794]  (&REISERFS_SB(s)->lock){+.+.+.}, at:
[<ffffffff811cc0f0>] reiserfs_write_lock+0x30/0x42
[ 2645.269575]
[ 2645.269576] which lock already depends on the new lock.
[ 2645.269577]
[ 2645.287630]
[ 2645.287631] the existing dependency chain (in reverse order) is:
[ 2645.304305]
[ 2645.304305] -> #1 (&REISERFS_SB(s)->lock){+.+.+.}:
[ 2645.311154]        [<ffffffff810a8731>] check_prev_add+0x3ca/0x583
[ 2645.325728]        [<ffffffff810a8d47>] validate_chain+0x45d/0x567
[ 2645.334270]        [<ffffffff810a9601>] __lock_acquire+0x7b0/0x838
[ 2645.348666]        [<ffffffff810a974d>] lock_acquire+0xc4/0xe1
[ 2645.353764]        [<ffffffff81d3060f>] mutex_lock_nested+0x68/0x2d2
[ 2645.368392]        [<ffffffff811cc0f0>] reiserfs_write_lock+0x30/0x42
[ 2645.384411]        [<ffffffff811c6d44>] do_journal_begin_r+0xa7/0x308
[ 2645.388725]        [<ffffffff811c7178>] journal_begin+0xcb/0x10f
[ 2645.406960]        [<ffffffff811b924b>] reiserfs_fill_super+0x6f6/0xa04
[ 2645.415302]        [<ffffffff81134090>] get_sb_bdev+0x134/0x17f
[ 2645.426778]        [<ffffffff811b67b3>] get_super_block+0x18/0x1a
[ 2645.431864]        [<ffffffff81132d7d>] vfs_kern_mount+0x5b/0xce
[ 2645.447564]        [<ffffffff81132e57>] do_kern_mount+0x4c/0xec
[ 2645.463593]        [<ffffffff8114aa3f>] do_mount+0x1c7/0x228
[ 2645.470094]
       [<ffffffff8114ab24>] sys_mount+0x84/0xc4
[ 2645.483554]        [<ffffffff81033bdb>] system_call_fastpath+0x16/0x1b
[ 2645.489348]
[ 2645.489348] -> #0 (&journal->j_mutex){+.+...}:
[ 2645.504216]        [<ffffffff810a8460>] check_prev_add+0xf9/0x583
[ 2645.510208]        [<ffffffff810a8d47>] validate_chain+0x45d/0x567
[ 2645.525881]        [<ffffffff810a9601>] __lock_acquire+0x7b0/0x838
[ 2645.531541]        [<ffffffff810a974d>] lock_acquire+0xc4/0xe1
[ 2645.545697]        [<ffffffff81d3060f>] mutex_lock_nested+0x68/0x2d2
[ 2645.550231]        [<ffffffff811c6d3c>] do_journal_begin_r+0x9f/0x308
[ 2645.567055]        [<ffffffff811c7178>] journal_begin+0xcb/0x10f
[ 2645.583683]        [<ffffffff811b24c9>] reiserfs_delete_inode+0x96/0x141
[ 2645.588035]        [<ffffffff81145b3c>] generic_delete_inode+0xe1/0x174
[ 2645.606570]        [<ffffffff81145beb>] generic_drop_inode+0x1c/0x67
[ 2645.614302]        [<ffffffff81144a2d>] iput+0x66/0x6a
[ 2645.625184]        [<ffffffff811b8290>] finish_unfinished+0x47a/0x529
[ 2645.630581]        [<ffffffff811b93eb>] reiserfs_fill_super+0x896/0xa04
[ 2645.647972]        [<ffffffff81134090>] get_sb_bdev+0x134/0x17f
[ 2645.663248]        [<ffffffff811b67b3>] get_super_block+0x18/0x1a
[ 2645.669144]        [<ffffffff81132d7d>] vfs_kern_mount+0x5b/0xce
[ 2645.684350]        [<ffffffff81132e57>] do_kern_mount+0x4c/0xec
[ 2645.694616]        [<ffffffff8114aa3f>] do_mount+0x1c7/0x228
[ 2645.704382]        [<ffffffff8114ab24>] sys_mount+0x84/0xc4
[ 2645.710595]        [<ffffffff81033bdb>] system_call_fastpath+0x16/0x1b
[ 2645.724680]
[ 2645.724681] other info that might help us debug this:
[ 2645.724682]
[ 2645.733003] 2 locks held by mount/23498:
[ 2645.745553]  #0:  (&type->s_umount_key#17/1){+.+.+.}, at:
[<ffffffff81133989>] alloc_super+0x153/0x227
[ 2645.765911]  #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at:
[<ffffffff811cc0f0>] reiserfs_write_lock+0x30/0x42
[ 2645.782668]
[ 2645.782668] stack backtrace:
[ 2645.785547] Pid: 23498, comm: mount Not tainted
2.6.33-rc1-tip-yh-00306-gae7a88c-dirty #1009
[ 2645.803579] Call Trace:
[ 2645.807937]  [<ffffffff810a7dc8>] print_circular_bug+0xb3/0xc2
[ 2645.812166]  [<ffffffff810a8460>] check_prev_add+0xf9/0x583
[ 2645.825199]  [<ffffffff810a8d47>] validate_chain+0x45d/0x567
[ 2645.829286]  [<ffffffff810a9601>] __lock_acquire+0x7b0/0x838
[ 2645.845975]  [<ffffffff81d3042e>] ? __mutex_unlock_slowpath+0x112/0x11e
[ 2645.862834]  [<ffffffff810a974d>] lock_acquire+0xc4/0xe1
[ 2645.865698]  [<ffffffff811c6d3c>] ? do_journal_begin_r+0x9f/0x308
[ 2645.883721]  [<ffffffff81d3060f>] mutex_lock_nested+0x68/0x2d2
[ 2645.891066]  [<ffffffff811c6d3c>] ? do_journal_begin_r+0x9f/0x308
[ 2645.903975]  [<ffffffff811c6d3c>] ? do_journal_begin_r+0x9f/0x308
[ 2645.908421]  [<ffffffff811cb414>] ? reiserfs_for_each_xattr+0x72/0x2f0
[ 2645.926237]  [<ffffffff8109b2c4>] ? cpu_clock+0x2d/0x3f
[ 2645.931855]  [<ffffffff811c6d3c>] do_journal_begin_r+0x9f/0x308
[ 2645.946286]  [<ffffffff810a5c2a>] ? trace_hardirqs_off_caller+0x1f/0xa9
[ 2645.950545]  [<ffffffff811c7178>] journal_begin+0xcb/0x10f
[ 2645.966761]  [<ffffffff811b24c9>] reiserfs_delete_inode+0x96/0x141
[ 2645.982242]  [<ffffffff811b2433>] ? reiserfs_delete_inode+0x0/0x141
[ 2645.987447]  [<ffffffff81145b3c>] generic_delete_inode+0xe1/0x174
[ 2646.002256]  [<ffffffff81145beb>] generic_drop_inode+0x1c/0x67
[ 2646.008206]  [<ffffffff81144a2d>] iput+0x66/0x6a
[ 2646.022186]  [<ffffffff811b8290>] finish_unfinished+0x47a/0x529
[ 2646.030400]  [<ffffffff811cc0f0>] ? reiserfs_write_lock+0x30/0x42
[ 2646.042801]  [<ffffffff810a6f25>] ? trace_hardirqs_on+0xd/0xf
[ 2646.046242]  [<ffffffff811b93eb>] reiserfs_fill_super+0x896/0xa04
[ 2646.063914]  [<ffffffff81134090>] get_sb_bdev+0x134/0x17f
[ 2646.071513]  [<ffffffff811b8b55>] ? reiserfs_fill_super+0x0/0xa04
[ 2646.083348]  [<ffffffff811b67b3>] get_super_block+0x18/0x1a
[ 2646.090453]  [<ffffffff81132d7d>] vfs_kern_mount+0x5b/0xce
[ 2646.104207]  [<ffffffff81132e57>] do_kern_mount+0x4c/0xec
[ 2646.109827]  [<ffffffff8114aa3f>] do_mount+0x1c7/0x228
[ 2646.124419]  [<ffffffff8114ab24>] sys_mount+0x84/0xc4
[ 2646.130317]  [<ffffffff81d31c4e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 2646.145285]  [<ffffffff81033bdb>] system_call_fastpath+0x16/0x1b
[ 2646.154272] done
[ 2646.156395] REISERFS (device sda2): There were 1 uncompleted
unlinks/truncates. Completed
