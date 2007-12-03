Return-Path: <linux-kernel-owner+w=401wt.eu-S1751975AbXLCQps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbXLCQps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 11:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750858AbXLCQpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 11:45:36 -0500
Received: from baron.coile-labs.com ([65.14.39.133]:16387 "EHLO coraid.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750723AbXLCQpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 11:45:35 -0500
X-Greylist: delayed 1183 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Dec 2007 11:45:35 EST
Date: Mon, 3 Dec 2007 11:21:37 -0500
From: "Ed L. Cashin" <ecashin@coraid.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jnelson-kernel-bugzilla@jamponi.net, bugme-daemon@bugzilla.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bugme-new] [Bug 9482] New: kernel GPF in 2.6.24 (g09f345da)
Message-ID: <20071203162137.GB25251@coraid.com>
References: <bug-9482-10286@http.bugzilla.kernel.org/> <20071201122302.10dd9c44.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071201122302.10dd9c44.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 01, 2007 at 12:23:02PM -0800, Andrew Morton wrote:
> (switched to email - please respond via emailed reply-to-all, not via the
> bugzilla web interface)
> 
> On Sat,  1 Dec 2007 11:54:11 -0800 (PST) bugme-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=9482
...
> Damn that's odd.  General Protection Fault in
> __set_page_dirty->__percpu_counter_add().  No sign of AOE in the trace.
> 
> I assume that it is repeatable and that it doesn't occur with mkfs on
> regular local disk drives?

I am encountering this same problem during testing of some patches I
would like to send to the LKML, applied to 2.6.24-rc3, and I can trip
this problem with just,

  echo > /dev/etherd/e7.0

... at which point I get the trace below.  (I had added a couple of
checks for 0xffffffffffffffff pointers to __percpu_counter_add.)  I
haven't been able to check the unpatched aoe driver, but it looks the
same.

Unable to handle kernel paging request at ffffffffffffffff RIP: 
 [<ffffffff8036d597>] __percpu_counter_add+0x24/0x6d
PGD 203067 PUD 204067 PMD 0 
Oops: 0000 [1] SMP 
CPU 0 
Modules linked in: aoe
Pid: 2860, comm: bash Not tainted 2.6.24-rc3-47dbg #5
RIP: 0010:[<ffffffff8036d597>]  [<ffffffff8036d597>] __percpu_counter_add+0x24/0x6d
RSP: 0018:ffff81007a0fbaa8  EFLAGS: 00010092
RAX: ffffffffffffffff RBX: ffff81007fcc48e0 RCX: 0000000000000010
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff81007ace7240
RBP: ffff81007a0fbac8 R08: ffff81007cc077b0 R09: ffffffff802ae5ee
R10: ffff81007a0fbaa8 R11: ffff810077dd99d8 R12: ffff81007ace7240
R13: 0000000000000000 R14: 0000000000000200 R15: ffff810078473bb0
FS:  00002ba601c5cdb0(0000) GS:ffffffff8078b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffffffffffff CR3: 0000000077c31000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process bash (pid: 2860, threadinfo ffff81007a0fa000, task ffff81007bf48040)
Stack:  ffff81007a0fbac8 ffff81007fcc48e0 ffff81007c81c380 0000000000000000
 ffff81007a0fbaf8 ffffffff802ae682 000010007a0fbae8 ffff810078473bb0
 0000000000000200 ffff81007fcc48e0 ffff81007a0fbb18 ffffffff802ae75c
Call Trace:
 [<ffffffff802ae682>] __set_page_dirty+0xdc/0x121
 [<ffffffff802ae75c>] mark_buffer_dirty+0x95/0x99
 [<ffffffff802ae7d2>] __block_commit_write+0x72/0xac
 [<ffffffff802ae988>] block_write_end+0x4f/0x5b
 [<ffffffff802b243f>] blkdev_write_end+0x1b/0x38
 [<ffffffff80265d96>] generic_file_buffered_write+0x1c0/0x648
 [<ffffffff8023a752>] current_fs_time+0x22/0x29
 [<ffffffff80266576>] __generic_file_aio_write_nolock+0x358/0x3c2
 [<ffffffff80266c84>] filemap_fault+0x1c4/0x320
 [<ffffffff80264cce>] unlock_page+0x2d/0x31
 [<ffffffff802666dd>] generic_file_aio_write_nolock+0x3b/0x8d
 [<ffffffff8028e40f>] do_sync_write+0xe2/0x126
 [<ffffffff802497d0>] autoremove_wake_function+0x0/0x38
 [<ffffffff8058e705>] do_page_fault+0x3f8/0x7bb
 [<ffffffff8028cae8>] fd_install+0x5f/0x68
 [<ffffffff8028eb98>] vfs_write+0xae/0x137
 [<ffffffff8028f102>] sys_write+0x47/0x70
 [<ffffffff8020b7ae>] system_call+0x7e/0x83


Code: 4c 8b 2c d0 49 63 45 00 48 8d 1c 30 48 63 c1 48 39 c3 7d 0a 
RIP  [<ffffffff8036d597>] __percpu_counter_add+0x24/0x6d
 RSP <ffff81007a0fbaa8>
CR2: ffffffffffffffff
BUG: sleeping function called from invalid context at kernel/rwsem.c:20
in_atomic():0, irqs_disabled():1
INFO: lockdep is turned off.

Call Trace:
 [<ffffffff802518cb>] debug_show_held_locks+0x1b/0x24
 [<ffffffff8022f352>] __might_sleep+0xc7/0xc9
 [<ffffffff8024c4d0>] down_read+0x1d/0x4a
 [<ffffffff80237bd8>] exit_mm+0x34/0xf7
 [<ffffffff8023933e>] do_exit+0x247/0x75b
 [<ffffffff8058e9d4>] do_page_fault+0x6c7/0x7bb
 [<ffffffff8058a81a>] thread_return+0x42/0x86
 [<ffffffff88002698>] :aoe:aoeblk_make_request+0x1e8/0x1f5
 [<ffffffff8058cb6d>] error_exit+0x0/0x9a
 [<ffffffff802ae5ee>] __set_page_dirty+0x48/0x121
 [<ffffffff8036d597>] __percpu_counter_add+0x24/0x6d
 [<ffffffff802ae682>] __set_page_dirty+0xdc/0x121
 [<ffffffff802ae75c>] mark_buffer_dirty+0x95/0x99
 [<ffffffff802ae7d2>] __block_commit_write+0x72/0xac
 [<ffffffff802ae988>] block_write_end+0x4f/0x5b
 [<ffffffff802b243f>] blkdev_write_end+0x1b/0x38
 [<ffffffff80265d96>] generic_file_buffered_write+0x1c0/0x648
 [<ffffffff8023a752>] current_fs_time+0x22/0x29
 [<ffffffff80266576>] __generic_file_aio_write_nolock+0x358/0x3c2
 [<ffffffff80266c84>] filemap_fault+0x1c4/0x320
 [<ffffffff80264cce>] unlock_page+0x2d/0x31
 [<ffffffff802666dd>] generic_file_aio_write_nolock+0x3b/0x8d
 [<ffffffff8028e40f>] do_sync_write+0xe2/0x126
 [<ffffffff802497d0>] autoremove_wake_function+0x0/0x38
 [<ffffffff8058e705>] do_page_fault+0x3f8/0x7bb
 [<ffffffff8028cae8>] fd_install+0x5f/0x68
 [<ffffffff8028eb98>] vfs_write+0xae/0x137
 [<ffffffff8028f102>] sys_write+0x47/0x70
 [<ffffffff8020b7ae>] system_call+0x7e/0x83



-- 
  Ed L Cashin <ecashin@coraid.com>
