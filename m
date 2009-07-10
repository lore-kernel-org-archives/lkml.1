Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbZGJSMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbZGJSMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 14:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbZGJSMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 14:12:35 -0400
Received: from smtp4.Stanford.EDU ([171.67.219.84]:48264 "EHLO
	smtp4.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbZGJSMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 14:12:32 -0400
Subject: Re: [ANNOUNCE] 2.6.29.5-rt22
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: nando@ccrma.Stanford.EDU, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0906231418500.2767@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0904020155320.12916@localhost.localdomain>
	 <alpine.LFD.2.00.0904031918090.12916@localhost.localdomain>
	 <alpine.LFD.2.00.0904081937191.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904092046440.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904110003370.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904181204420.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904251500150.4529@localhost.localdomain>
	 <alpine.LFD.2.00.0904290036500.4529@localhost.localdomain>
	 <alpine.LFD.2.00.0905012348200.3375@localhost.localdomain>
	 <alpine.LFD.2.00.0905130122250.3561@localhost.localdomain>
	 <alpine.LFD.2.00.0905221459030.3570@localhost.localdomain>
	 <alpine.LFD.2.00.0906101803210.3367@localhost.localdomain>
	 <alpine.LFD.2.00.0906121800590.3369@localhost.localdomain>
	 <alpine.LFD.2.00.0906151117440.2800@localhost.localdomain>
	 <alpine.LFD.2.00.0906170903370.2800@localhost.localdomain>
	 <alpine.LFD.2.00.0906231418500.2767@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 11:06:24 -0700
Message-Id: <1247249184.18898.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-23 at 14:30 +0200, Thomas Gleixner wrote:
> We are pleased to announce the next update to our new preempt-rt
> series.
>  
>     - fix the network live lock issue for real
> 
>     - disable preemption across iomap atomic section
> 
>     - indentify false positives in the softirq pending check
>       in the nohz code.

One of my users has been hitting an issue with suspend, the machine
suspends but will not come back alive. 

Below is the latest debug info he sent me (the issue still happens with
rt23, got a report this morning)

-- Fernando



On Wed, 2009-07-01 at 19:53 -0500, S C Rigler wrote:
On Thu, 2009-06-25 at 22:27 -0700, Fernando Lopez-Lezcano wrote: 
> > It's really suspending.  The power light is blinking like it
normally
> > > does when suspended.  Just when the laptop lid is opened or the
power
> > > button pressed it tries to wake up (the screen comes on and a
blinking
> > > cursor appears for a second) and then it resets itself.
> > 
> > Ok, I was going to post to lkml to see if they can spot something,
but
> > maybe you could look a bit more /var/log/messages to see what the
> > context is for that BUG statement (that is, what is happening before
and
> > after - is this while powering down, trying to power up, etc), that
> > could maybe help them... 
> > 
> > Thanks for the report!
> > > 
Amazingly enough, I was finally able to get some information logged by
following some of the steps in basic-pm-debugging.txt.  This
accomplished by doing "echo 1 > /sys/power/pm_trace; echo core
> /sys/power/pm_test; echo mem > /sys/power/state."  Some of the other
test modes also created the exact same log message.  Here it is with
some context:
> 
> Jul  1 19:32:35 localhost kernel: PM: Syncing filesystems ... done.
> Jul  1 19:32:36 localhost kernel: [drm:i915_get_vblank_counter]
*ERROR* trying to get vblank count for disabled pipe 0
> Jul  1 19:32:45 localhost kernel: Freezing user space processes ...
(elapsed 0.00 seconds) done.
> Jul  1 19:32:45 localhost kernel: Freezing remaining freezable
tasks ... (elapsed 0.00 seconds) done.
> Jul  1 19:32:45 localhost kernel: Suspending console(s) (use
no_console_suspend to debug)
> Jul  1 19:32:45 localhost kernel: sd 0:0:0:0: [sda] Synchronizing SCSI
cache
> Jul  1 19:32:45 localhost kernel: sd 0:0:0:0: [sda] Stopping disk
> Jul  1 19:32:45 localhost kernel: sdhci-pci 0000:09:09.1: PME#
disabled
> Jul  1 19:32:45 localhost kernel: sdhci-pci 0000:09:09.1: PCI INT B
disabled
> Jul  1 19:32:45 localhost kernel: r8169 0000:08:00.0: PME# enabled
> Jul  1 19:32:45 localhost kernel: r8169 0000:08:00.0: wake-up
capability enabled by ACPI
> Jul  1 19:32:45 localhost kernel: iwlagn 0000:02:00.0: PCI INT A
disabled
> Jul  1 19:32:45 localhost kernel: ata_piix 0000:00:1f.1: PCI INT A
disabled
> Jul  1 19:32:45 localhost kernel: ehci_hcd 0000:00:1d.7: PCI INT A
disabled
> Jul  1 19:32:45 localhost kernel: ehci_hcd 0000:00:1d.7: PME# disabled
> Jul  1 19:32:45 localhost kernel: uhci_hcd 0000:00:1d.2: PCI INT C
disabled
> Jul  1 19:32:45 localhost kernel: uhci_hcd 0000:00:1d.1: PCI INT B
disabled
> Jul  1 19:32:45 localhost kernel: uhci_hcd 0000:00:1d.0: PCI INT A
disabled
> Jul  1 19:32:45 localhost kernel: HDA Intel 0000:00:1b.0: PCI INT A
disabled
> Jul  1 19:32:45 localhost kernel: ehci_hcd 0000:00:1a.7: PCI INT C
disabled
> Jul  1 19:32:45 localhost kernel: ehci_hcd 0000:00:1a.7: PME# disabled
> Jul  1 19:32:45 localhost kernel: uhci_hcd 0000:00:1a.1: PCI INT B
disabled
> Jul  1 19:32:45 localhost kernel: uhci_hcd 0000:00:1a.0: PCI INT A
disabled
> Jul  1 19:32:45 localhost kernel: ACPI: Preparing to enter system
sleep state S3
> Jul  1 19:32:45 localhost kernel: Disabling non-boot CPUs ...
> Jul  1 19:32:45 localhost kernel: Broke affinity for irq 9
> Jul  1 19:32:45 localhost kernel: Broke affinity for irq 12
> Jul  1 19:32:45 localhost kernel: Broke affinity for irq 27
> Jul  1 19:32:45 localhost kernel: CPU 1 is now offline
> Jul  1 19:32:45 localhost kernel: SMP alternatives: switching to UP
code
> Jul  1 19:32:45 localhost kernel: CPU1 is down
> Jul  1 19:32:45 localhost kernel: ricoh-mmc: Suspending.
> Jul  1 19:32:45 localhost kernel: ricoh-mmc: Controller is now
re-enabled.
> Jul  1 19:32:45 localhost kernel: BUG: sleeping function called from
invalid context at kernel/rtmutex.c:685
> Jul  1 19:32:45 localhost kernel: in_atomic(): 0, irqs_disabled(): 1,
pid: 4322, name: bash
> Jul  1 19:32:45 localhost kernel: Pid: 4322, comm: bash Not tainted
2.6.29.5-rt22 #1
> Jul  1 19:32:45 localhost kernel: Call Trace:
> Jul  1 19:32:45 localhost kernel: [<ffffffff8144b3ff>] ?
rt_spin_lock_slowlock+0x0/0x27e
> Jul  1 19:32:45 localhost kernel: [<ffffffff81047e30>] __might_sleep
+0x11d/0x133
> Jul  1 19:32:45 localhost kernel: [<ffffffff81087d17>]
rt_spin_lock_fastlock+0x43/0xa2
> Jul  1 19:32:45 localhost kernel: [<ffffffff8144c0c5>] rt_spin_lock
+0x23/0x39
> Jul  1 19:32:45 localhost kernel: [<ffffffff8101a6df>]
read_persistent_clock+0x24/0x58
> Jul  1 19:32:45 localhost kernel: [<ffffffff811fd63d>] ?
pci_pm_suspend_noirq+0x43/0xb5
> Jul  1 19:32:45 localhost kernel: [<ffffffff8107dccd>]
timekeeping_suspend+0x1d/0xb2
> Jul  1 19:32:45 localhost kernel: [<ffffffff812a3260>] sysdev_suspend
+0x98/0x1f1
> Jul  1 19:32:45 localhost kernel: [<ffffffff812aa564>] ?
device_power_down+0x55/0x141
> Jul  1 19:32:45 localhost kernel: [<ffffffff8108ecc8>]
suspend_devices_and_enter+0x111/0x1c9
> Jul  1 19:32:45 localhost kernel: [<ffffffff8108ef42>] enter_state
+0x172/0x1f0
> Jul  1 19:32:45 localhost kernel: [<ffffffff8108f086>] state_store
+0xc6/0xfd
> Jul  1 19:32:45 localhost kernel: [<ffffffff810fc5f2>] ?
alloc_pages_current+0xcc/0xed
> Jul  1 19:32:45 localhost kernel: [<ffffffff811e56c5>] kobj_attr_store
+0x2a/0x40
> Jul  1 19:32:45 localhost kernel: [<ffffffff8116aaa7>]
sysfs_write_file+0xee/0x137
> Jul  1 19:32:45 localhost kernel: [<ffffffff8110ab1c>] ?
rw_verify_area+0x97/0xd1
> Jul  1 19:32:45 localhost kernel: [<ffffffff8110b380>] vfs_write
+0xbe/0x130
> Jul  1 19:32:45 localhost kernel: [<ffffffff8110b4e8>] sys_write
+0x56/0x93
> Jul  1 19:32:45 localhost kernel: [<ffffffff81013102>]
system_call_fastpath+0x16/0x1b
> Jul  1 19:32:45 localhost kernel: Extended CMOS year: 2000
> Jul  1 19:32:45 localhost kernel: suspend debug: Waiting for 5
seconds.
> Jul  1 19:32:45 localhost kernel: Extended CMOS year: 2000
> Jul  1 19:32:45 localhost kernel: ricoh-mmc: Resuming.
> Jul  1 19:32:45 localhost kernel: ricoh-mmc: Controller is now
disabled.
> Jul  1 19:32:45 localhost kernel: Enabling non-boot CPUs ...

-- Fernando


