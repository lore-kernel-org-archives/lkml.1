Return-Path: <linux-kernel-owner+w=401wt.eu-S932696AbXCPLb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696AbXCPLb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 07:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932987AbXCPLb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 07:31:59 -0400
Received: from mx10.go2.pl ([193.17.41.74]:51091 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932696AbXCPLb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 07:31:58 -0400
Date: Fri, 16 Mar 2007 12:36:15 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Richard Hughes <hughsient@gmail.com>, Philippe Elie <phil.el@wanadoo.fr>,
       oprofile-list@lists.sourceforge.net
Subject: [PATCH] Re: Fwd: oprofile lockdep warning on rc1
Message-ID: <20070316113614.GA5877@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070228004641.GC12600@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28-02-2007 01:46, Dave Jones wrote:
> This happened on a 2.6.21rc1 kernel.
...
> Richard Hughes <hughsient@gmail.com>
> Date:
> Tue, 27 Feb 2007 21:59:07 +0000
> To:
> Development discussions related to Fedora Core 
> <fedora-devel-list@redhat.com>
...
> But also I get this (!!!):
> 
> oprofile: using NMI interrupt.
> 
> =================================
> [ INFO: inconsistent lock state ]
> 2.6.20-1.2949.fc7 #1
> ---------------------------------
> inconsistent {hardirq-on-W} -> {in-hardirq-W} usage.
> swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
>  (oprofilefs_lock){+-..}, at: [<f8c6db5e>] nmi_cpu_setup+0x15/0x4f
> [oprofile]
> {hardirq-on-W} state was registered at:
>   [<c0442440>] __lock_acquire+0x448/0xba4
>   [<c0442f8e>] lock_acquire+0x56/0x6f
>   [<c0614949>] _spin_lock+0x2b/0x38
>   [<f8c6d33c>] oprofilefs_ulong_from_user+0x4e/0x74 [oprofile]
>   [<f8c6d38c>] ulong_write_file+0x2a/0x38 [oprofile]
>   [<c047e20b>] vfs_write+0xaf/0x163
>   [<c047e859>] sys_write+0x3d/0x61
>   [<c0405134>] syscall_call+0x7/0xb
>   [<ffffffff>] 0xffffffff
> irq event stamp: 23424902
> hardirqs last  enabled at (23424901): [<c0614d4d>]
> _spin_unlock_irqrestore+0x36/0x3c
> hardirqs last disabled at (23424902): [<c0405bb5>]
> call_function_interrupt+0x29/0x38
> softirqs last  enabled at (23424892): [<c042c0d8>] __do_softirq
> +0xdc/0xe2
> softirqs last disabled at (23424885): [<c04074dc>] do_softirq+0x61/0xd0
> 
> other info that might help us debug this:
> no locks held by swapper/0.
> 
> stack backtrace:
>  [<c04062a5>] show_trace_log_lvl+0x1a/0x2f
>  [<c0406869>] show_trace+0x12/0x14
>  [<c04068ed>] dump_stack+0x16/0x18
>  [<c0440f67>] print_usage_bug+0x141/0x14b
>  [<c0441620>] mark_lock+0xa2/0x419
>  [<c04423b1>] __lock_acquire+0x3b9/0xba4
>  [<c0442f8e>] lock_acquire+0x56/0x6f
>  [<c0614949>] _spin_lock+0x2b/0x38
>  [<f8c6db5e>] nmi_cpu_setup+0x15/0x4f [oprofile]
>  [<c0417e6a>] smp_call_function_interrupt+0x3f/0x5b
>  [<c0405bbf>] call_function_interrupt+0x33/0x38
>  [<c0614896>] _spin_unlock+0x16/0x20
>  [<c043ded6>] clockevents_notify+0x3e/0x42
>  [<c0532f67>] acpi_state_timer_broadcast+0x2e/0x31
>  [<c05338e8>] acpi_processor_idle+0x285/0x419
>  [<c040348e>] cpu_idle+0xb7/0xdd
>  [<c0418eef>] start_secondary+0x330/0x338
>  [<00000000>] 0x0
>  =======================
> 
> Why do the simplest bugs always turn into the most complicated ones ;-)
> 
> Richard.

Here is my patch proposal for testing.

Regards,
Jarek P.

lockdep found oprofilefs_lock is taken both in process
context (oprofilefs_ulong_from_user()) and from hardirq
(nmi_cpu_setup()), so the lockup is possible.

Reported-by: Richard Hughes <hughsient@gmail.com>
Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>

---

diff -Nurp linux-2.6.21-rc1-/drivers/oprofile/oprofilefs.c linux-2.6.21-rc1/drivers/oprofile/oprofilefs.c
--- linux-2.6.21-rc1-/drivers/oprofile/oprofilefs.c	2007-02-27 10:47:38.000000000 +0100
+++ linux-2.6.21-rc1/drivers/oprofile/oprofilefs.c	2007-03-16 11:36:30.000000000 +0100
@@ -65,6 +65,7 @@ ssize_t oprofilefs_ulong_to_user(unsigne
 int oprofilefs_ulong_from_user(unsigned long * val, char const __user * buf, size_t count)
 {
 	char tmpbuf[TMPBUFSIZE];
+	unsigned long flags;
 
 	if (!count)
 		return 0;
@@ -77,9 +78,9 @@ int oprofilefs_ulong_from_user(unsigned 
 	if (copy_from_user(tmpbuf, buf, count))
 		return -EFAULT;
 
-	spin_lock(&oprofilefs_lock);
+	spin_lock_irqsave(&oprofilefs_lock, flags);
 	*val = simple_strtoul(tmpbuf, NULL, 0);
-	spin_unlock(&oprofilefs_lock);
+	spin_unlock_irqrestore(&oprofilefs_lock, flags);
 	return 0;
 }
 
