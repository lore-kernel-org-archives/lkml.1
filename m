Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbXLCVk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbXLCVk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 16:40:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbXLCVks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 16:40:48 -0500
Received: from baron.miniblade.com ([65.14.39.133]:16431 "EHLO coraid.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751160AbXLCVkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 16:40:47 -0500
Date: Mon, 3 Dec 2007 16:38:37 -0500
From: "Ed L. Cashin" <ecashin@coraid.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jnelson-kernel-bugzilla@jamponi.net, bugme-daemon@bugzilla.kernel.org,
       nickpiggin@yahoo.com.au, clameter@sgi.com, linux-kernel@vger.kernel.org,
       rjw@sisk.pl
Subject: Re: [Bugme-new] [Bug 9482] New: kernel GPF in 2.6.24 (g09f345da)
Message-ID: <20071203213837.GE27094@coraid.com>
References: <bug-9482-10286@http.bugzilla.kernel.org/> <20071201122302.10dd9c44.akpm@linux-foundation.org> <20071203162137.GB25251@coraid.com> <20071203113459.d36c1a01.akpm@linux-foundation.org> <20071203210005.GB27094@coraid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071203210005.GB27094@coraid.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2007 at 04:00:05PM -0500, Ed L. Cashin wrote:
...
> I'll keep looking at this, but at a glance it looks like the cpu
> number is valid, because I don't trip a BUG_ON when I make the change
> below (the badval variable is noise, sorry).
> 
>   --- lx/lib/percpu_counter.c.20071130    2007-12-03 15:43:19.000000000 -0500
>   +++ lx/lib/percpu_counter.c     2007-12-03 15:47:38.000000000 -0500
>   @@ -33,7 +33,9 @@ void __percpu_counter_add(struct percpu_
>           s64 count;
>           s32 *pcount;
>           int cpu = get_cpu();
>   +       u64 badval = 0xffffffffffffffffULL;
>    
>   +       BUG_ON(!cpu_possible(cpu));
>           pcount = per_cpu_ptr(fbc->counters, cpu);
>           count = *pcount + amount;
>           if (count >= batch || count <= -batch) {

It appears that the fbc->counters pointer is NULL.  I added the line,

	BUG_ON(!fbc->counters);

... (on line 39 in my percpu_counter.c), and it results in the trace
below.  It looks like when it's NULL, percpu_ptr passes it to
__percpu_disguise, which makes it all ones and then tries to
dereference 0xffffffffffffffff to access to the "ptrs" member of the
struct percpu_data.

------------[ cut here ]------------
kernel BUG at lib/percpu_counter.c:39!
invalid opcode: 0000 [1] SMP 
CPU 0 
Modules linked in: aoe
Pid: 3354, comm: bash Not tainted 2.6.24-rc3-47dbg #10
RIP: 0010:[<ffffffff8036d5f7>]  [<ffffffff8036d5f7>] __percpu_counter_add+0x2a/0x8f
RSP: 0018:ffff810075031aa8  EFLAGS: 00010046
RAX: 00000000ffffffff RBX: ffff81007fd19bd8 RCX: 0000000000000000
RDX: 0000000000000010 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffff810075031ac8 R08: ffff81007cc077b0 R09: ffffffff802ae5ee
R10: ffff810075031aa8 R11: ffff8100750318e8 R12: ffff81007c81c380
R13: ffff810073ce8250 R14: 0000000000000200 R15: ffff8100755016b0
FS:  00002b3e5c052db0(0000) GS:ffffffff8078b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00002b7f44fb64e0 CR3: 000000007c4b1000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process bash (pid: 3354, threadinfo ffff810075030000, task ffff81007b4da040)
Stack:  ffff810075031ac8 ffff81007fd19bd8 ffff81007c81c380 0000000000000000
 ffff810075031af8 ffffffff802ae682 0000100075031ae8 ffff8100755016b0
 0000000000000200 ffff81007fd19bd8 ffff810075031b18 ffffffff802ae75c
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
 [<ffffffff8058e725>] do_page_fault+0x3f8/0x7bb
 [<ffffffff8028cae8>] fd_install+0x5f/0x68
 [<ffffffff8028eb98>] vfs_write+0xae/0x137
 [<ffffffff8028f102>] sys_write+0x47/0x70
 [<ffffffff8020b7ae>] system_call+0x7e/0x83


Code: 0f 0b eb fe 0f a3 3d 7e 08 4f 00 19 c0 85 c0 75 04 0f 0b eb 
RIP  [<ffffffff8036d5f7>] __percpu_counter_add+0x2a/0x8f
 RSP <ffff810075031aa8>
BUG: sleeping function called from invalid context at kernel/rwsem.c:20
in_atomic():0, irqs_disabled():1
INFO: lockdep is turned off.

Call Trace:
 [<ffffffff802518cb>] debug_show_held_locks+0x1b/0x24
 [<ffffffff8022f352>] __might_sleep+0xc7/0xc9
 [<ffffffff8024c4d0>] down_read+0x1d/0x4a
 [<ffffffff80237bd8>] exit_mm+0x34/0xf7
 [<ffffffff8023933e>] do_exit+0x247/0x75b
 [<ffffffff8020d01e>] kernel_math_error+0x0/0x7e
 [<ffffffff8058d35b>] do_trap+0x101/0x110
 [<ffffffff8020d4a6>] do_invalid_op+0x91/0x9a
 [<ffffffff8036d5f7>] __percpu_counter_add+0x2a/0x8f
 [<ffffffff88002544>] :aoe:aoeblk_make_request+0x1c3/0x1d0
 [<ffffffff8058aaeb>] io_schedule+0x28/0x34
 [<ffffffff8058cb8d>] error_exit+0x0/0x9a
 [<ffffffff802ae5ee>] __set_page_dirty+0x48/0x121
 [<ffffffff8036d5f7>] __percpu_counter_add+0x2a/0x8f
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
 [<ffffffff8058e725>] do_page_fault+0x3f8/0x7bb
 [<ffffffff8028cae8>] fd_install+0x5f/0x68
 [<ffffffff8028eb98>] vfs_write+0xae/0x137
 [<ffffffff8028f102>] sys_write+0x47/0x70
 [<ffffffff8020b7ae>] system_call+0x7e/0x83



-- 
  Ed L Cashin <ecashin@coraid.com>
