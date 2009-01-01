Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbZAAC0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbZAAC0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 21:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbZAAC02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 21:26:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752451AbZAAC01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 21:26:27 -0500
Date: Wed, 31 Dec 2008 18:26:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [mmotm 2008-12-30-16-05] Warning at MPT driver initialization.
Message-Id: <20081231182613.a37eab90.akpm@linux-foundation.org>
In-Reply-To: <200901011051.ICE39590.JOFQLHFtSFMVOO@I-love.SAKURA.ne.jp>
References: <200812310006.mBV060iV029753@imap1.linux-foundation.org>
	<200901011051.ICE39590.JOFQLHFtSFMVOO@I-love.SAKURA.ne.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Jan 2009 10:51:12 +0900 Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:

> Hello.
> 
> I got below warning.
> 
> Regards.
> ----------------------------------------
> Fusion MPT base driver 3.04.07
> Copyright (c) 1999-2008 LSI Corporation
> Fusion MPT SPI Host driver 3.04.07
> ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
> PCI: setting IRQ 11 as level-triggered
> mptspi 0000:00:10.0: PCI INT A -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
> mptbase: ioc0: Initiating bringup
> ioc0: LSI53C1030 B0: Capabilities={Initiator}
> ODEBUG: object is on stack, but not annotated
> ------------[ cut here ]------------
> WARNING: at lib/debugobjects.c:253 __debug_object_init+0x1f3/0x276()
> Hardware name: VMware Virtual Platform
> Modules linked in: mptspi(+) mptscsih mptbase scsi_transport_spi ext3 jbd mbcache
> Pid: 540, comm: insmod Not tainted 2.6.28-mm1 #2
> Call Trace:
>  [<c042c51c>] warn_slowpath+0x74/0x8a
>  [<c0469600>] ? start_critical_timing+0x96/0xb7
>  [<c060c8ea>] ? _spin_unlock_irqrestore+0x2f/0x3c
>  [<c0446fad>] ? trace_hardirqs_off_caller+0x18/0xaf
>  [<c044704f>] ? trace_hardirqs_off+0xb/0xd
>  [<c060c8ea>] ? _spin_unlock_irqrestore+0x2f/0x3c
>  [<c042cb84>] ? release_console_sem+0x1a5/0x1ad
>  [<c05013e6>] __debug_object_init+0x1f3/0x276
>  [<c0501494>] debug_object_init+0x13/0x17
>  [<c0433c56>] init_timer+0x10/0x1a
>  [<e08e5b54>] mpt_config+0x1c1/0x2b7 [mptbase]
>  [<e08e3b82>] ? kmalloc+0x8/0xa [mptbase]
>  [<e08e3b82>] ? kmalloc+0x8/0xa [mptbase]
>  [<e08e6fa2>] mpt_do_ioc_recovery+0x950/0x1212 [mptbase]
>  [<c04496c2>] ? __lock_acquire+0xa69/0xacc
>  [<c060c8f1>] ? _spin_unlock_irqrestore+0x36/0x3c
>  [<c060c3af>] ? _spin_unlock_irq+0x22/0x26
>  [<c04f2d8b>] ? string+0x2b/0x76
>  [<c04f310e>] ? vsnprintf+0x338/0x7b3
>  [<c04496c2>] ? __lock_acquire+0xa69/0xacc
>  [<c060c8ea>] ? _spin_unlock_irqrestore+0x2f/0x3c
>  [<c04496c2>] ? __lock_acquire+0xa69/0xacc
>  [<c044897d>] ? debug_check_no_locks_freed+0xeb/0x105
>  [<c060c8f1>] ? _spin_unlock_irqrestore+0x36/0x3c
>  [<c04488bc>] ? debug_check_no_locks_freed+0x2a/0x105
>  [<c0446b8c>] ? lock_release_holdtime+0x43/0x48
>  [<c043f742>] ? up_read+0x16/0x29
>  [<c05076f8>] ? pci_get_slot+0x66/0x72
>  [<e08e89ca>] mpt_attach+0x881/0x9b1 [mptbase]
>  [<e091c8e5>] mptspi_probe+0x11/0x354 [mptspi]

Well it's the debugobjects stuff complaining about
init_timer(&pCfg->timer) in mpt_config().

I spent a minute trying to work out what the heck
debug_object_is_on_stack() is trying to tell me, but it seems that code
was designed to only be used by Thomas, so let's cc him and ask.

Thomas, could we have some nice code comments please, so that random
kernel developers don't need to go and reverse engineer the
debugobjects design before they can work out what they did wrong?
