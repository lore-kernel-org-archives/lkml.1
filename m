Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbXLCTf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbXLCTf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 14:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbXLCTfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 14:35:16 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52085 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751725AbXLCTfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 14:35:13 -0500
Date: Mon, 3 Dec 2007 11:34:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ed L. Cashin" <ecashin@coraid.com>
Cc: jnelson-kernel-bugzilla@jamponi.net, bugme-daemon@bugzilla.kernel.org,
       nickpiggin@yahoo.com.au, clameter@sgi.com, linux-kernel@vger.kernel.org,
       rjw@sisk.pl
Subject: Re: [Bugme-new] [Bug 9482] New: kernel GPF in 2.6.24 (g09f345da)
Message-Id: <20071203113459.d36c1a01.akpm@linux-foundation.org>
In-Reply-To: <20071203162137.GB25251@coraid.com>
References: <bug-9482-10286@http.bugzilla.kernel.org/>
	<20071201122302.10dd9c44.akpm@linux-foundation.org>
	<20071203162137.GB25251@coraid.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2007 11:21:37 -0500
"Ed L. Cashin" <ecashin@coraid.com> wrote:

> On Sat, Dec 01, 2007 at 12:23:02PM -0800, Andrew Morton wrote:
> > (switched to email - please respond via emailed reply-to-all, not via the
> > bugzilla web interface)
> > 
> > On Sat,  1 Dec 2007 11:54:11 -0800 (PST) bugme-daemon@bugzilla.kernel.org wrote:
> > 
> > > http://bugzilla.kernel.org/show_bug.cgi?id=9482
> ...
> > Damn that's odd.  General Protection Fault in
> > __set_page_dirty->__percpu_counter_add().  No sign of AOE in the trace.
> > 
> > I assume that it is repeatable and that it doesn't occur with mkfs on
> > regular local disk drives?
> 
> I am encountering this same problem during testing of some patches I
> would like to send to the LKML, applied to 2.6.24-rc3, and I can trip
> this problem with just,
> 
>   echo > /dev/etherd/e7.0
> 
> ... at which point I get the trace below.  (I had added a couple of
> checks for 0xffffffffffffffff pointers to __percpu_counter_add.)  I
> haven't been able to check the unpatched aoe driver, but it looks the
> same.
> 
> Unable to handle kernel paging request at ffffffffffffffff RIP: 
>  [<ffffffff8036d597>] __percpu_counter_add+0x24/0x6d
> PGD 203067 PUD 204067 PMD 0 
> Oops: 0000 [1] SMP 
> CPU 0 
> Modules linked in: aoe
> Pid: 2860, comm: bash Not tainted 2.6.24-rc3-47dbg #5
> RIP: 0010:[<ffffffff8036d597>]  [<ffffffff8036d597>] __percpu_counter_add+0x24/0x6d
> RSP: 0018:ffff81007a0fbaa8  EFLAGS: 00010092
> RAX: ffffffffffffffff RBX: ffff81007fcc48e0 RCX: 0000000000000010
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff81007ace7240
> RBP: ffff81007a0fbac8 R08: ffff81007cc077b0 R09: ffffffff802ae5ee
> R10: ffff81007a0fbaa8 R11: ffff810077dd99d8 R12: ffff81007ace7240
> R13: 0000000000000000 R14: 0000000000000200 R15: ffff810078473bb0
> FS:  00002ba601c5cdb0(0000) GS:ffffffff8078b000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: ffffffffffffffff CR3: 0000000077c31000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process bash (pid: 2860, threadinfo ffff81007a0fa000, task ffff81007bf48040)
> Stack:  ffff81007a0fbac8 ffff81007fcc48e0 ffff81007c81c380 0000000000000000
>  ffff81007a0fbaf8 ffffffff802ae682 000010007a0fbae8 ffff810078473bb0
>  0000000000000200 ffff81007fcc48e0 ffff81007a0fbb18 ffffffff802ae75c
> Call Trace:
>  [<ffffffff802ae682>] __set_page_dirty+0xdc/0x121
>  [<ffffffff802ae75c>] mark_buffer_dirty+0x95/0x99
>  [<ffffffff802ae7d2>] __block_commit_write+0x72/0xac
>  [<ffffffff802ae988>] block_write_end+0x4f/0x5b
>  [<ffffffff802b243f>] blkdev_write_end+0x1b/0x38
>  [<ffffffff80265d96>] generic_file_buffered_write+0x1c0/0x648
>  [<ffffffff8023a752>] current_fs_time+0x22/0x29
>  [<ffffffff80266576>] __generic_file_aio_write_nolock+0x358/0x3c2
>  [<ffffffff80266c84>] filemap_fault+0x1c4/0x320
>  [<ffffffff80264cce>] unlock_page+0x2d/0x31
>  [<ffffffff802666dd>] generic_file_aio_write_nolock+0x3b/0x8d
>  [<ffffffff8028e40f>] do_sync_write+0xe2/0x126
>  [<ffffffff802497d0>] autoremove_wake_function+0x0/0x38
>  [<ffffffff8058e705>] do_page_fault+0x3f8/0x7bb
>  [<ffffffff8028cae8>] fd_install+0x5f/0x68
>  [<ffffffff8028eb98>] vfs_write+0xae/0x137
>  [<ffffffff8028f102>] sys_write+0x47/0x70
>  [<ffffffff8020b7ae>] system_call+0x7e/0x83

Strange.  It _looks_ like we've somehow caused smp_processor_id() to return
a not-possible CPU number.  This code:

void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
{
	s64 count;
	s32 *pcount;
	int cpu = get_cpu();

	pcount = per_cpu_ptr(fbc->counters, cpu);

grabs a null pointer out of fbc->counters and then does the
__percpu_disguise() thing on it, thus getting an address of ~0.

Which I think implies that something in AOE is scribbling on task_struct,
thread_info or a machine register (%fs).  Quite an achievement if so...

Could you debug this a bit please?  Find out which CPU number
__percpu_counter_add() is using, for a start?  I'd do:

in __percpu_counter_add():

int foo;
EXPORT_SYMBOL(foo);

__percpu_counter_add()
{
	int cpu = get_cpu();

	if (foo)
		printk("cpu:%d\n", cpu);
	...
}

in aoe:

extern int foo;

{
	...
	foo = 1;
}



Alternatively, just do

	if (!cpu_possible(cpu))
		printk(...)

in __percpu_counter_add().  Then you can proceed to work through the
various operations which smp_processor_id() does and find out where it went
wrong: print out %fs, mainly.

If the cpu number is valid then perhaps something scribbled on the cpu's
per-cpu memory.
