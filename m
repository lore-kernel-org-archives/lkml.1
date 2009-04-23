Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbZDWDur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbZDWDur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 23:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbZDWDug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 23:50:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57178 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752120AbZDWDue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 23:50:34 -0400
Date: Wed, 22 Apr 2009 20:45:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, jstultz <jstultz@us.ibm.com>,
       linux-acpi <linux-acpi@vger.kernel.org>, lenb@kernel.org,
       john stultz <johnstul@us.ibm.com>
Subject: Re: 2.6.30-rc2 soft lockups: ACPI?  clock source problem?
Message-Id: <20090422204557.10c3cc37.akpm@linux-foundation.org>
In-Reply-To: <1240335038.11194.11.camel@nimitz>
References: <1240335038.11194.11.camel@nimitz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Is jstultz@us.ibm.com correct?)

On Tue, 21 Apr 2009 10:30:38 -0700 Dave Hansen <dave@sr71.net> wrote:

> This was during my first boot of 2.6.30-rc2.

Did it ever happen again?

I assume this is a post-2.6.29 regression?  (Yet another.  We've been
extra bad this time)

>  At the end of all this,
> there's a "Clocksource tsc unstable (delta = -222703151079 ns)" which
> makes me think this probably wasn't a real soft lockup.  Maybe just a
> bad guess since the clock source changed.  It seems really odd that both
> CPUs would do this at precisely the same time, but in different code.
> 
> I'm including the ACPI folks since there was some ACPI stuff in here
> that is way beyond me. :)
> 
> [   76.657737] ACPI: SSDT bf6e1b32 002C4 (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
> [   76.676235] ACPI: SSDT bf6e1e7b 0085E (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
> [   76.695503] Monitor-Mwait will be used to enter C-1 state
> [   76.695531] Monitor-Mwait will be used to enter C-2 state
> [   76.695557] Monitor-Mwait will be used to enter C-3 state
> [  299.485576] BUG: soft lockup - CPU#1 stuck for 207s! [udevd:3994]

we got a softlockup

> [  299.485639] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
> [  299.485680] processor ACPI_CPU:00: registered as cooling_device0
> [  299.485684] ACPI: Processor [CPU0] (supports 8 throttling states)

then a bunch of acpi messages which are probably unrelated.

> [  299.485576] Modules linked in: processor(+) ohci1394 ehci_hcd uhci_hcd ieee1394 usbcore thermal fan fuse
> [  299.485576] 
> [  299.485576] Pid: 3994, comm: udevd Not tainted (2.6.30-rc2 #304) 7659A71
> [  299.485576] EIP: 0060:[<c014d0f5>] EFLAGS: 00000202 CPU: 1
> [  299.485576] EIP is at current_kernel_time+0x35/0x40
> [  299.485576] EAX: 00009529 EBX: f75cf400 ECX: 00000000 EDX: f7687480
> [  299.485576] ESI: f70a49a0 EDI: f765ac80 EBP: f749de38 ESP: f749de2c
> [  299.485576]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [  299.485576] CR0: 8005003b CR2: b7f09078 CR3: 36db7000 CR4: 000006b0
> [  299.485576] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [  299.485576] DR6: ffff0ff0 DR7: 00000400
> [  299.485576] Call Trace:
> [  299.485576]  [<c013629b>] current_fs_time+0xb/0x20
> [  299.485576]  [<c01ba7b8>] file_update_time+0x48/0xc0
> [  299.485576]  [<c01af03f>] pipe_write+0x2ff/0x410
> [  299.485576]  [<c013f2a6>] ? get_signal_to_deliver+0x276/0x380
> [  299.485576]  [<c01a7bed>] do_sync_write+0xcd/0x110
> [  299.485576]  [<c0145cd0>] ? autoremove_wake_function+0x0/0x40
> [  299.485576]  [<c0191d89>] ? remove_vma+0x49/0x60
> [  299.485576]  [<c01a8436>] vfs_write+0x96/0x160
> [  299.485576]  [<c01a7b20>] ? do_sync_write+0x0/0x110
> [  299.485576]  [<c01a8afd>] sys_write+0x3d/0x70
> [  299.485576]  [<c0102e18>] sysenter_do_call+0x12/0x2c

then the softlockup backtrace.  current_kernel_time() got stuck.


