Return-Path: <linux-kernel-owner+w=401wt.eu-S1758245AbYH2Oct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245AbYH2Oct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 10:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757416AbYH2Ock
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 10:32:40 -0400
Received: from web82108.mail.mud.yahoo.com ([209.191.84.221]:46940 "HELO
	web82108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754960AbYH2Ocj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 10:32:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=dJvPJBgeUA9fvsBmq7h70moIyAIPknM+JCex/UbjORO99sdWL29ztKIFwGhWm/QUQPSTvh66C577zExBGmlmCjzroHBsKeqdXMnYh5m1RLNcwxBa7Ng4ftt2Mk3g7GZ32SPe+gso7J2u5JRMPsZFFUQMo1DIjnKdewdcROfbQto=;
X-YMail-OSG: X_b0jLkVM1kRp0sUBFmlvtXzyeHpqVGgFKyqt7IsPHZreIsHVrmuO9_XRaKUApBp5cnUjA4.wbnVpTljxCoUINIvpupeguUgEH5NVvZfu66B8i6gl556rrQjA0oEPoePufLVivzvVhvO4IxB6xwW
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218.2
Date: Fri, 29 Aug 2008 07:32:38 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v2
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <757514.62388.qm@web82108.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> From: Yinghai Lu <yhlu.kernel@gmail.com>
[...]
> please hang a while, there is some merging problem with current tip/master.
> 
> one or two hours later ingo may fix it.
> 
> or please try attached two patches....

Yinghai,

I applied your patches to the tip/master from yesterday (IOW, I did not
run 'git remote update' before the following session.

The patches applied fine and the kernel built and ran OK (though with a
little weirdness... see further down), but it seems that the combined 
changes that these 2 patches make to e820.h result in no change to that
file at all!  See 'git status' output at the end of this session:

===== SHELL STUFF ============
$ git show |head
commit e3fc96d5aca609bcf6ab0327850a109df65c1dbb
Merge: 6b8c836... a36d241...
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Aug 28 22:57:20 2008 +0200

    Merge branch 'x86/core'

$ git apply --verbose --check ../yh01-revert_wrong_split_e820_reserve.patch 
Checking patch arch/x86/kernel/e820.c...
Checking patch arch/x86/pci/i386.c...
Checking patch include/asm-x86/e820.h...

$ git apply --verbose ../yh01-revert_wrong_split_e820_reserve.patch 
Checking patch arch/x86/kernel/e820.c...
Checking patch arch/x86/pci/i386.c...
Checking patch include/asm-x86/e820.h...
Applied patch arch/x86/kernel/e820.c cleanly.
Applied patch arch/x86/pci/i386.c cleanly.
Applied patch include/asm-x86/e820.h cleanly.

$ git apply --verbose --check ../yh02-split_e820_reserve.patch 
Checking patch arch/x86/kernel/e820.c...
Checking patch arch/x86/pci/i386.c...
Checking patch include/asm-x86/e820.h...

$ git apply --verbose ../yh02-split_e820_reserve.patch 
Checking patch arch/x86/kernel/e820.c...
Checking patch arch/x86/pci/i386.c...
Checking patch include/asm-x86/e820.h...
Applied patch arch/x86/kernel/e820.c cleanly.
Applied patch arch/x86/pci/i386.c cleanly.
Applied patch include/asm-x86/e820.h cleanly.

$ git status
# Not currently on any branch.
# Changed but not updated:
#   (use "git add <file>..." to update what will be committed)
#
#    modified:   arch/x86/kernel/e820.c
#    modified:   arch/x86/pci/i386.c
#
no changes added to commit (use "git add" and/or "git commit -a")
==============================

I installed the kernel and it booted OK.  There was a delay when my
MTA (exim4) loaded, but that happens sometimes.  However, I got a
call trace I've never seen before.  This could just be a fluke, but
I'm passing it along in case it's meaningful.  I grabbed the trace on
TTY1 by logging in on TTY2 and using 'setterm -append 1':

===== SETTERM OUTPUT =====
Clocksource tsc unstable (delta = -98677795 ns)
NETDEV WATCHDOG: eth0 (r8169): transmit timed out
------------[ cut here ]------------
WARNING: at net/sched/sch_generic.c:221 dev_watchdog+0x21e/0x250()
Modules linked in: ipv6 cpufreq_userspace pcspkr 8250_pnp 8250 serial_core evdev
Pid: 0, comm: swapper Not tainted 2.6.27-rc4.080829.yh-patches-tip #1
Call Trace:
 <IRQ>  [<ffffffff8023b524>] warn_on_slowpath+0x64/0xb0
 [<ffffffff80584adc>] printk+0x4e/0x5a
 [<ffffffff80245ab4>] lock_timer_base+0x34/0x70
 [<ffffffff80245ca0>] __mod_timer+0xb0/0xd0
 [<ffffffff802565b8>] getnstimeofday+0x48/0xc0
 [<ffffffff8050f9be>] dev_watchdog+0x21e/0x250
 [<ffffffff802389bf>] scheduler_tick+0xcf/0x220
 [<ffffffff802451eb>] cascade+0x7b/0xa0
 [<ffffffff8050f7a0>] dev_watchdog+0x0/0x250
 [<ffffffff8024538c>] run_timer_softirq+0x13c/0x210
 [<ffffffff802548ac>] ktime_get+0xc/0x50
 [<ffffffff80240d13>] __do_softirq+0x73/0xf0
 [<ffffffff8020ca3c>] call_softirq+0x1c/0x30
 [<ffffffff8020eac5>] do_softirq+0x35/0x70
 [<ffffffff80240a0d>] irq_exit+0x8d/0x90
 [<ffffffff8021e9b6>] smp_apic_timer_interrupt+0x86/0xd0
 [<ffffffff8020c486>] apic_timer_interrupt+0x66/0x70
 <EOI>  [<ffffffff8021e130>] lapic_next_event+0x0/0x20
 [<ffffffff80212fca>] default_idle+0x3a/0x40
 [<ffffffff802130d4>] c1e_idle+0x34/0xe0
 [<ffffffff8020a8d6>] cpu_idle+0x56/0xa0
---[ end trace 28095e4c2b529c2a ]---
r8169: eth0: link up
===== END SETTERM OUTPUT =====

Other than this strangeness, everything seems OK with your patches.  This
looks like some random networking annoyance to me, not really related to
the regression patches, but I'll let better minds be the judge of that.

The HPET-related output in 'dmesg' looks just fine:

==============================
$ dmesg | grep -i -3 hpet
ACPI: DSDT 77FE3180, 4B0B (r1 RS690  AWRDACPI     1000 MSFT  3000000)
ACPI: FACS 77FE0000, 0040
ACPI: SSDT 77FE7DC0, 028A (r1 PTLTD  POWERNOW        1  LTP        1)
ACPI: HPET 77FE80C0, 0038 (r1 RS690  AWRDACPI 42302E31 AWRD       98)
ACPI: MCFG 77FE8140, 003C (r1 RS690  AWRDACPI 42302E31 AWRD        0)
ACPI: APIC 77FE7D00, 0068 (r1 RS690  AWRDACPI 42302E31 AWRD        0)
No NUMA configuration found
--
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
ACPI: HPET id: 0x10b9a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 80000000 (gap: 78000000:68000000)
dyn_array 0xffffffff80840c68 size:0x10 nr:256 align:0x1000
--
Memory: 1929712k/1965952k available (3625k kernel code, 35852k reserved, 1446k data, 1116k init)
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer frequency.. 5001.73 BogoMIPS (lpj=8332380)
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
--
initcall pci_iommu_init+0x0/0x1e returned 0 after 0 msecs
calling  print_all_ICs+0x0/0x565
initcall print_all_ICs+0x0/0x565 returned 0 after 0 msecs
calling  hpet_late_init+0x0/0xed
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 32-bit 14.318180 MHz counter
initcall hpet_late_init+0x0/0xed returned 0 after 0 msecs
calling  clocksource_done_booting+0x0/0xd
initcall clocksource_done_booting+0x0/0xd returned 0 after 0 msecs
calling  init_pipe_fs+0x0/0x44
--
initcall tty_init+0x0/0x1dc returned 0 after 21 msecs
calling  pty_init+0x0/0x2eb
initcall pty_init+0x0/0x2eb returned 0 after 0 msecs
calling  hpet_init+0x0/0x6b
hpet_resources: 0xfed00000 is busy
initcall hpet_init+0x0/0x6b returned 0 after 0 msecs
calling  agp_init+0x0/0x2d
Linux agpgart interface v0.103
initcall agp_init+0x0/0x2d returned 0 after 0 msecs
--
powernow-k8:    4 : fid 0xa (1800 MHz), vid 0x13
powernow-k8:    5 : fid 0x2 (1000 MHz), vid 0x16
initcall powernowk8_init+0x0/0x94 returned 0 after 14 msecs
calling  hpet_insert_resource+0x0/0x1e
initcall hpet_insert_resource+0x0/0x1e returned 0 after 0 msecs
calling  update_mp_table+0x0/0x68e
initcall update_mp_table+0x0/0x68e returned 0 after 0 msecs
calling  lapic_insert_resource+0x0/0x45
==============================


HTH,
Dave W.
