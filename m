Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbZEVMoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbZEVMoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbZEVMoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:44:14 -0400
Received: from smtp02.lnh.mail.rcn.net ([207.172.157.102]:37938 "EHLO
	smtp02.lnh.mail.rcn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbZEVMoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:44:12 -0400
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 May 2009 08:44:12 EDT
Subject: [2.6.27.24] Kernel coredump to a pipe is failing
From: Paul Smith <paul@mad-scientist.net>
Reply-To: paul@mad-scientist.net
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: GNU's Not Unix!
Date: Fri, 22 May 2009 08:34:28 -0400
Message-Id: <1242995668.29860.55.camel@homebase.localnet>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all; I'm having issues trying to get my system to dump core through a
pipe to a process, by setting /proc/sys/kernel/core_pattern to start
with a "|".  I'm working on a ramdisk-based system that I boot via PXE.
It's a 64bit 4core system with hyperthreading for 8 CPUs reported by
Linux, and I'm running 2.6.27.24.  Unfortunately it would be quite some
effort to try to update to a newer kernel on this system.

Here's my scenario: I'm running a single process on the system.  That
process receives a job, and it forks a number of copies of itself
(between 4 and 8) to do this work.  In this processing there are two
areas of the code.  In the first area, any core is considered
unrecoverable; in this area when one of the workers takes a core a
signal handler is fired that stops all processes in the process group,
dumps the single core, then all the processes are killed so they never
dump core.  This style of single-core dumping works just fine.

In the second area, a core is considered local to that worker process
and so the system as a whole is considered recoverable.  In this area,
each process dumps core without trying to affect its siblings or parent.
Of course, since the workers are running the same code it could be
(depending on the fault condition) that most or all of the workers dump
core at the same time.

In that last situation, when many of them dump core at the same time, if
I use a filename pattern in core_pattern it works fine, but I'm seeing
major problems when I try to pipe the core to a process.  To test this
I've added an explicit SEGV (invalid pointer dereference) to the code
just when it enters the "recoverable" area, so all workers hit it at the
same time and all dump core.

My core handler process does various things with locking, compression of
the core, etc., but I've reproduced my problem with as simple a setup as
this:

        # cat >/tmp/savecore <<EOF
        #!/bin/sh
        exec cat > /path/to/cores/core.$1
        EOF
        # chmod 755 /tmp/savecore
        # echo '|/tmp/savecore %p' > /proc/sys/kernel/core_pattern

With this, when my workers dump core, the best outcome is that all of
the cores are "short".  A normal core for these processes would be about
1G, but these are anywhere from 50M to as small as 64K.  Examining the
core it basically contains the first 50M (or 64K) of a valid core, so
that GDB will even load it, but obviously as soon as you do any
operation like examine backtraces, etc. it says invalid memory address.
Of course I have core size set to unlimited, etc.

I instrumented fs/binfmt_elf.c:elf_core_dump() with some printk's to try
to figure out what's going on.  I've added a printout to show the value
of "offset" which is how large the core is expected to be.  I also added
printk's before each of the "goto end_coredump" jumps inside the VMA
dump loop.  Just before the end_coredump label I print a message saying
all VMAs were successfully dumped, then after the end_coredump label I
show how many VMA entries were dumped and the total size of them (I
added some variables to track this).  So, on my console when I use a
simple filename pattern in core_patterm, I get this output which is
correct; in this example we have 6 helpers:

        file ffff88046e9e8240: foffset=2820 / offset=1085698048 / dataoff=4096
        file ffff8803ba38e300: foffset=2788 / offset=1085566976 / dataoff=4096
        file ffff88046a264600: foffset=2788 / offset=1085566976 / dataoff=4096
        file ffff8803b9164cc0: foffset=2788 / offset=1085566976 / dataoff=4096
        file ffff88042cf58900: foffset=2788 / offset=1085566976 / dataoff=4096
        file ffff88042cf58d80: foffset=2788 / offset=1085566976 / dataoff=4096
        file ffff8803ba38e300: Completed VMA write
        file ffff8803ba38e300: 41 VMA / 1085562880 B
        file ffff88046a264600: Completed VMA write
        file ffff8803b9164cc0: Completed VMA write
        file ffff8803b9164cc0: 41 VMA / 1085562880 B
        file ffff88042cf58d80: Completed VMA write
        file ffff88042cf58d80: 41 VMA / 1085562880 B
        file ffff88046e9e8240: Completed VMA write
        file ffff88046e9e8240: 42 VMA / 1085693952 B
        file ffff88042cf58900: Completed VMA write
        file ffff88042cf58900: 41 VMA / 1085562880 B
        file ffff88046a264600: 41 VMA / 1085562880 B

Here we see the offset, then the message that the loop dumping VMA
completes, then the size (this is the size of VMA segments, so it's less
than the total core size).

However, when I install the pipe as described above, things do not go so
well at all:

        file ffff88042cf58cc0: foffset=2820 / offset=1085698048 / dataoff=4096
        file ffff88046e9e8540: foffset=2788 / offset=1085566976 / dataoff=4096
        file ffff8803ba38e840: foffset=2788 / offset=1085566976 / dataoff=4096
        file ffff88042fd1a6c0: foffset=2788 / offset=1085566976 / dataoff=4096
        file ffff88042fd1ae40: foffset=2788 / offset=1085566976 / dataoff=4096
        file ffff8803ba245f00: foffset=2788 / offset=1085566976 / dataoff=4096
        file ffff88042cf58cc0: (3540372 > 18446744073709551615 || dump_write() == 0)
        file ffff8803ba245f00: (5277044 > 18446744073709551615 || dump_write() == 0)
        file ffff8803ba245f00: 1 VMA / 5484544 B
        file ffff88046e9e8540: (5309812 > 18446744073709551615 || dump_write() == 0)
        file ffff88046e9e8540: 1 VMA / 5484544 B
        file ffff8803ba38e840: (5277044 > 18446744073709551615 || dump_write() == 0)
        file ffff88042fd1a6c0: (5277044 > 18446744073709551615 || dump_write() == 0)
        file ffff88042fd1ae40: (5277044 > 18446744073709551615 || dump_write() == 0)
        file ffff8803ba38e840: 1 VMA / 5484544 B
        file ffff88042fd1a6c0: 1 VMA / 5484544 B
        file ffff88042fd1ae40: 1 VMA / 5484544 B
        file ffff88042cf58cc0: 1 VMA / 5484544 B

What this shows is that the cores were supposed to be about the same
size, but that in all cases the VMA dump loop exited early (in this case
after 1 try) at the if-statement here:

        if ((size += PAGE_SIZE) > limit ||
            !dump_write(file, kaddr,
                        PAGE_SIZE)) {
                kunmap(page);
                page_cache_release(page);
          printk("file %p: (%lu > %lu || dump_write() == 0)\n", file, size, limit);
                goto end_coredump;
        }

Basically this means that the file->f_op->write() method returned a 0...
but I don't know why it would return that!  There are no other messages
in dmesg or syslog etc.

Even worse, after 3 or so times of this, I get a kernel panic, every
time.  The details of the panic vary but a sample is included below.

I'm not sure how to go further.  Any pointers, advice, requests, etc.
are gratefully received.


Kernel panic info:

Bad page state in process 'worker'
page:ffffe20010d63d00 flags:0x8000000000000001 mapping:0000000000000000 mapcount:0 count:0
Trying to fix it up, but a reboot is needed
Backtrace:
Pid: 3346, comm: worker Tainted: P          2.6.27.24-worker #4

Call Trace:
 [<ffffffff80284fd4>] bad_page+0x74/0xc0
 [<ffffffff80286168>] free_hot_cold_page+0x248/0x2f0
 [<ffffffff802f4096>] free_wr_note_data+0x56/0x70
 [<ffffffff802a95c6>] kfree+0x86/0x100
 [<ffffffff802f4096>] free_wr_note_data+0x56/0x70
 [<ffffffff802f0991>] elf_core_dump+0x611/0x1160
 [<ffffffff802b49ba>] do_coredump+0x9ea/0xa30
 [<ffffffff8048bb31>] _read_unlock+0x11/0x40
 [<ffffffff802801e3>] find_lock_page+0x23/0x80
 [<ffffffff80280c25>] filemap_fault+0x275/0x4e0
 [<ffffffff80249771>] __dequeue_signal+0xe1/0x190
 [<ffffffff8024bb22>] get_signal_to_deliver+0x272/0x3b0
 [<ffffffff8020b6f7>] do_notify_resume+0xd7/0x9c0
 [<ffffffff8022fe9f>] task_rq_lock+0x4f/0xa0
 [<ffffffff8048baf2>] _spin_unlock_irqrestore+0x12/0x40
 [<ffffffff802368fe>] try_to_wake_up+0x16e/0x250
 [<ffffffff80226c96>] do_page_fault+0x426/0xbc0
 [<ffffffff802388c7>] kick_process+0x57/0x90
 [<ffffffff80249c2f>] send_signal+0x17f/0x320
 [<ffffffff8048baf2>] _spin_unlock_irqrestore+0x12/0x40
 [<ffffffff802487eb>] sys_rt_sigprocmask+0x8b/0x120
 [<ffffffff8048b88f>] _spin_lock_irqsave+0x1f/0x50
 [<ffffffff8022c0e5>] sys32_rt_sigprocmask+0x75/0x120
 [<ffffffff8022c0e5>] sys32_rt_sigprocmask+0x75/0x120
 [<ffffffff8020c90b>] int_signal+0x12/0x17

general protection fault: 0000 [1] PREEMPT SMP 
CPU 3 
Modules linked in: rng_core dock scsi_mod libata ata_piix zlib_inflate bnx2 libphy tg3 ipmi_msghandler ipmi_si ipmi_devintf nsoc sd_mod sg scsi_transport_sas mptbase mptscsih mptsas mptctl md_mod raid1 raid10 raid0 linear dm_mod dm_multipath dm_round_robin jbd ext3 disklog xxds(P)
Pid: 2895, comm: md4_resync Tainted: P    B     2.6.27.24-worker #4
RIP: 0010:[<ffffffff802a989e>]  [<ffffffff802a989e>] kmem_cache_alloc+0x4e/0xc0
RSP: 0000:ffff88046baf3a70  EFLAGS: 00010086
RAX: 0000000000000000 RBX: 8000000000000000 RCX: 0000000000000010
RDX: ffff88002805d5e0 RSI: 0000000000011220 RDI: ffffffff8058cce8
RBP: 0000000000000082 R08: ffffffffa000d2b0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff8058cce8
R13: ffffffff80282da5 R14: 0000000000011220 R15: 0000000000000200
FS:  0000000000000000(0000) GS:ffff88046f805a80(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000000080a35ac CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process md4_resync (pid: 2895, threadinfo ffff88046baf2000, task ffff88046e505b00)
Stack:  ffff88046a2b6580 0000000000000010 ffff88046fa8f060 0000000000011220
 ffff88046baf3ac0 ffff88046fa8f090 0000000000000000 ffffffff80282da5
 ffff88046a243c00 ffff88046baf3ad8 0000000000001000 ffffffffa0181924
Call Trace:
 [<ffffffff80282da5>] ? mempool_alloc+0x55/0x130
 [<ffffffffa0181924>] ? multipath_map+0x74/0xc0 [dm_multipath]
 [<ffffffff8036c2e4>] ? __sg_alloc_table+0x64/0x130
 [<ffffffffa000d2b0>] ? scsi_sg_alloc+0x0/0x50 [scsi_mod]
 [<ffffffffa000d1f4>] ? scsi_init_sgtable+0x34/0xa0 [scsi_mod]
 [<ffffffffa000d561>] ? scsi_init_io+0x21/0x100 [scsi_mod]
 [<ffffffffa00e37fc>] ? sd_prep_fn+0x9c/0x5b0 [sd_mod]
 [<ffffffff8034c23d>] ? elv_next_request+0x15d/0x290
 [<ffffffffa000cbfa>] ? scsi_request_fn+0x6a/0x3c0 [scsi_mod]
 [<ffffffff8034e884>] ? generic_unplug_device+0x24/0x40
 [<ffffffffa0172b14>] ? dm_table_unplug_all+0x34/0x50 [dm_mod]
 [<ffffffffa01713fd>] ? dm_unplug_all+0x1d/0x40 [dm_mod]
 [<ffffffffa0172b14>] ? dm_table_unplug_all+0x34/0x50 [dm_mod]
 [<ffffffffa01713fd>] ? dm_unplug_all+0x1d/0x40 [dm_mod]
 [<ffffffffa015c4d6>] ? unplug_slaves+0xb6/0x140 [raid1]
 [<ffffffffa015c570>] ? raid1_unplug+0x10/0x20 [raid1]
 [<ffffffffa014ae1c>] ? md_do_sync+0x5cc/0xb40 [md_mod]
 [<ffffffff8048baf2>] ? _spin_unlock_irqrestore+0x12/0x40
 [<ffffffffa014b937>] ? md_thread+0x47/0x120 [md_mod]
 [<ffffffffa014b8f0>] ? md_thread+0x0/0x120 [md_mod]
 [<ffffffff80253267>] ? kthread+0x47/0x90
 [<ffffffff80253220>] ? kthread+0x0/0x90
 [<ffffffff8020d5f9>] ? child_rip+0xa/0x11
 [<ffffffff80253220>] ? kthread+0x0/0x90
 [<ffffffff80253220>] ? kthread+0x0/0x90
 [<ffffffff8020d5ef>] ? child_rip+0x0/0x11


Code: 89 fc 41 89 f6 4c 8b 6c 24 38 9c 5d fa e8 bb 3b 0c 00 48 98 49 8b 94 c4 e8 00 00 00 48 8b 1a 44 8b 7a 18 48 85 db 74 4d 8b 42 14 <48> 8b 04 c3 48 89 02 55 9d 66 45 85 f6 79 12 48 85 db 74 0d 44 
RIP  [<ffffffff802a989e>] kmem_cache_alloc+0x4e/0xc0
 RSP <ffff88046baf3a70>
Kernel panic - not syncing: Fatal exception
------------[ cut here ]------------
WARNING: at /home/build/linux/kernel/smp.c:332 smp_call_function_mask+0x25d/0x270()
Modules linked in: rng_core dock scsi_mod libata ata_piix zlib_inflate bnx2 libphy tg3 ipmi_msghandler ipmi_si ipmi_devintf nsoc sd_mod sg scsi_transport_sas mptbase mptscsih mptsas mptctl md_mod raid1 raid10 raid0 linear dm_mod dm_multipath dm_round_robin jbd ext3 disklog xxds(P)
Pid: 2895, comm: md4_resync Tainted: P    B D   2.6.27.24-worker #4

Call Trace:
 [<ffffffff8023bf54>] warn_on_slowpath+0x64/0xb0
 [<ffffffff8048b88f>] _spin_lock_irqsave+0x1f/0x50
 [<ffffffff8048baf2>] _spin_unlock_irqrestore+0x12/0x40
 [<ffffffff80257f30>] down_trylock+0x30/0x50
 [<ffffffff8048bbb0>] _spin_unlock+0x10/0x30
 [<ffffffff8023cce2>] vprintk+0x1f2/0x490
 [<ffffffff8048bbb0>] _spin_unlock+0x10/0x30
 [<ffffffff8048b88f>] _spin_lock_irqsave+0x1f/0x50
 [<ffffffff8048baf2>] _spin_unlock_irqrestore+0x12/0x40
 [<ffffffff8021c9b0>] stop_this_cpu+0x0/0x30
 [<ffffffff8026234d>] smp_call_function_mask+0x25d/0x270
 [<ffffffff80282da5>] mempool_alloc+0x55/0x130
 [<ffffffff8048916f>] printk+0xc0/0xd1
 [<ffffffff8048bbb0>] _spin_unlock+0x10/0x30
 [<ffffffff80269d8d>] crash_kexec+0x6d/0x110
 [<ffffffff8020ea84>] show_registers+0x2a4/0x2c0
 [<ffffffff8048916f>] printk+0xc0/0xd1
 [<ffffffff8021c9b0>] stop_this_cpu+0x0/0x30
 [<ffffffff80262398>] smp_call_function+0x38/0x80
 [<ffffffff80282da5>] mempool_alloc+0x55/0x130
 [<ffffffff8021c9a0>] native_smp_send_stop+0x20/0x30
 [<ffffffff80488ffb>] panic+0x9f/0x153
 [<ffffffff80253729>] autoremove_wake_function+0x9/0x30
 [<ffffffff8022e2ca>] __wake_up_common+0x5a/0x90
 [<ffffffff8022fc13>] __wake_up+0x43/0x70
 [<ffffffff80282da5>] mempool_alloc+0x55/0x130
 [<ffffffff8020dfa1>] oops_end+0x81/0xd0
 [<ffffffff8048bf69>] error_exit+0x0/0x51
 [<ffffffff80282da5>] mempool_alloc+0x55/0x130
 [<ffffffffa000d2b0>] scsi_sg_alloc+0x0/0x50 [scsi_mod]
 [<ffffffff802a989e>] kmem_cache_alloc+0x4e/0xc0
 [<ffffffff80282da5>] mempool_alloc+0x55/0x130
 [<ffffffffa0181924>] multipath_map+0x74/0xc0 [dm_multipath]
 [<ffffffff8036c2e4>] __sg_alloc_table+0x64/0x130
 [<ffffffffa000d2b0>] scsi_sg_alloc+0x0/0x50 [scsi_mod]
 [<ffffffffa000d1f4>] scsi_init_sgtable+0x34/0xa0 [scsi_mod]
 [<ffffffffa000d561>] scsi_init_io+0x21/0x100 [scsi_mod]
 [<ffffffffa00e37fc>] sd_prep_fn+0x9c/0x5b0 [sd_mod]
 [<ffffffff8034c23d>] elv_next_request+0x15d/0x290
 [<ffffffffa000cbfa>] scsi_request_fn+0x6a/0x3c0 [scsi_mod]
 [<ffffffff8034e884>] generic_unplug_device+0x24/0x40
 [<ffffffffa0172b14>] dm_table_unplug_all+0x34/0x50 [dm_mod]
 [<ffffffffa01713fd>] dm_unplug_all+0x1d/0x40 [dm_mod]
 [<ffffffffa0172b14>] dm_table_unplug_all+0x34/0x50 [dm_mod]
 [<ffffffffa01713fd>] dm_unplug_all+0x1d/0x40 [dm_mod]
 [<ffffffffa015c4d6>] unplug_slaves+0xb6/0x140 [raid1]
 [<ffffffffa015c570>] raid1_unplug+0x10/0x20 [raid1]
 [<ffffffffa014ae1c>] md_do_sync+0x5cc/0xb40 [md_mod]
 [<ffffffff8048baf2>] _spin_unlock_irqrestore+0x12/0x40
 [<ffffffffa014b937>] md_thread+0x47/0x120 [md_mod]
 [<ffffffffa014b8f0>] md_thread+0x0/0x120 [md_mod]
 [<ffffffff80253267>] kthread+0x47/0x90
 [<ffffffff80253220>] kthread+0x0/0x90
 [<ffffffff8020d5f9>] child_rip+0xa/0x11
 [<ffffffff80253220>] kthread+0x0/0x90
 [<ffffffff80253220>] kthread+0x0/0x90
 [<ffffffff8020d5ef>] child_rip+0x0/0x11

---[ end trace b6e9b2155948c94b ]---

