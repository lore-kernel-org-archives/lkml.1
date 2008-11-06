Return-Path: <linux-kernel-owner+w=401wt.eu-S1752019AbYKFRd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbYKFRd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 12:33:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbYKFRds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 12:33:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57622 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750975AbYKFRdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 12:33:47 -0500
Date: Thu, 6 Nov 2008 09:33:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-acpi@vger.kernel.org
Subject: Re: 2.6.28-rc2-mm1: multiple BUG: scheduling while atomic: swapper,
 first in acpi_idle_enter_simple, then fbcon has problems
Message-Id: <20081106093324.57d88a43.akpm@linux-foundation.org>
In-Reply-To: <20081106102309.GA334@atrey.karlin.mff.cuni.cz>
References: <20081106102309.GA334@atrey.karlin.mff.cuni.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2008 11:23:09 +0100 Pavel Machek <pavel@suse.cz> wrote:

> 
> ...kernel contains experimental version of HP accelerometer driver and
> new HP acclerometer LED, but hopefully they are not causing this?
> 

The trace is a bit of a mess, but we first hit problems around
acpi_idle(), so I'd be suspecting acpi, x86 or sched-type changes.

> ...
>
> Failed to execute /tmp/swsusp-init.  Attempting defaults...
> BUG: scheduling while atomic: swapper/0/0x10000100
> no locks held by swapper/0.
> Modules linked in:
> 
> Pid: 0, comm: swapper Not tainted (2.6.28-rc2-mm1 #1) HP 2133
> EIP: 0060:[<c03f23d7>] EFLAGS: 00000292 CPU: 0
> EIP is at acpi_idle_enter_simple+0x180/0x1ed
> EAX: c0a29fb0 EBX: 00000267 ECX: 00000003 EDX: 008fe000
> ESI: 00000000 EDI: 00624c8c EBP: 00624a25 ESP: c0a29fb0
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> CR0: 8005003b CR2: b7f167b0 CR3: 1afd9000 CR4: 00000690
> DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> DR6: ffff0ff0 DR7: 00000400
> Call Trace:
>  [<c05d6076>] ? cpuidle_idle_call+0x66/0xc0
>  [<c0202732>] ? cpu_idle+0x52/0xa0
> EXT3 FS on sda4, internal journal

Then this points at fb_pad_unaligned_buffer which is weird, because
that function takes no locks, doesn't schedule, no nothin.  All it does
is modify memory.

> BUG: scheduling while atomic: sss/1538/0x10000100
> 1 lock held by sss/1538:
>  #0:  (&tty->atomic_write_lock){....}, at: [<c0400fd9>] tty_write_lock+0x19/0x50
> Modules linked in:
> 
> Pid: 1538, comm: sss Not tainted (2.6.28-rc2-mm1 #1) HP 2133
> EIP: 0060:[<c03b8726>] EFLAGS: 00000246 CPU: 0
> EIP is at fb_pad_unaligned_buffer+0xa6/0xf0
> EAX: 00000000 EBX: 00000001 ECX: db166a3f EDX: 00000000
> ESI: 00000001 EDI: c07a64c1 EBP: db166a3f ESP: da00bbe8
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> CR0: 8005003b CR2: 080fb408 CR3: 1affb000 CR4: 00000690
> DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> DR6: ffff0ff0 DR7: 00000400
> Call Trace:
>  [<c03c73c8>] ? bit_putcs+0x538/0x620
>  [<c03c7c99>] ? soft_cursor+0x189/0x1f0
>  [<c03c7c99>] ? soft_cursor+0x189/0x1f0
>  [<c03c1bee>] ? fbcon_putcs+0x18e/0x2d0
>  [<c03c6e90>] ? bit_putcs+0x0/0x620
>  [<c03c3389>] ? fbcon_redraw+0x139/0x1a0
>  [<c03c5390>] ? fbcon_scroll+0x1c0/0xe80
>  [<c040e551>] ? scrup+0xe1/0xf0
>  [<c040e5f7>] ? lf+0x47/0x50
>  [<c0411007>] ? do_con_write+0x887/0x1a60
>  [<c0240030>] ? bump_cpu_timer+0xf0/0x1e0
>  [<c024c630>] ? __lock_acquire+0x230/0xa10
>  [<c0412209>] ? con_put_char+0x29/0x40
>  [<c03ff5f6>] ? tty_put_char+0x16/0x40
>  [<c077f80a>] ? __reacquire_kernel_lock+0xa/0x30
>  [<c0402b49>] ? opost+0xa9/0x210
>  [<c0403531>] ? n_tty_write+0x111/0x340
>  [<c0224a90>] ? default_wake_function+0x0/0x10
>  [<c0401202>] ? tty_write+0x142/0x1f0
>  [<c0403420>] ? n_tty_write+0x0/0x340
>  [<c040132b>] ? redirected_tty_write+0x7b/0xa0
>  [<c0287673>] ? vfs_write+0xa3/0x140
>  [<c04012b0>] ? redirected_tty_write+0x0/0xa0
>  [<c0287cb1>] ? sys_write+0x41/0x70
>  [<c0203ca2>] ? syscall_call+0x7/0xb
>
> ...
>

