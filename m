Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbYE2IqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbYE2IqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 04:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbYE2Ip4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 04:45:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754026AbYE2Ipy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 04:45:54 -0400
Date: Thu, 29 May 2008 01:45:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eugene_Bordenkircher@selinc.com
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       linux-usb@vger.kernel.org, Li Yang <leoli@freescale.com>
Subject: Re: BUG/OOPS: Double Lock in fsl_usb2_udc.c
Message-Id: <20080529014535.6065fa39.akpm@linux-foundation.org>
In-Reply-To: <OF581BDA23.991E51FC-ON88257457.007166AD-88257457.007B3064@selinc.com>
References: <OF581BDA23.991E51FC-ON88257457.007166AD-88257457.007B3064@selinc.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008 15:25:31 -0700 Eugene_Bordenkircher@selinc.com wrote:

> Hello All, 
> 
> I have recently found an instance in the drivers/usb/gadget/fsl_usb2_udc.c 
> file that causes the udc->lock spinlock to be taken twice.  The problem 
> arises when you disconnect from the DR port and then reconnect.  The 
> interrupt routine for the driver receives a 'reset' event which takes the 
> lock and calls reset_queues() which in turn calls 
> udc->driver->disconnect().  Eventually, that disconnect() call comes back 
> up to the fsl_usb2_udc driver and calls fsl_ep_disable() which attempts to 
> take the udc->lock again.  Unfortunately the lock was not released before 
> the call to disconnect(), therefore the double lock is taken. 
> 
> Looking through other drivers, I have seen them releasing the lock 
> immediately before calling disconnect(), however, without being an expert 
> with this driver, I'm not entirely sure that is the best option here. 
> 
> I have seen the behavior directly on a 2.6.23.9-rt13 kernel, but have 
> perused the latest source and the same problem appears to be there. 
> Attached below is the generated BUG trace for the 2.6.23.9-rt13 kernel. 
> 
> Please CC me directly if possible for immediate responses.  Otherwise I 
> will have to wait for the archives to post to read responses. 
> 
> Eugene T. Bordenkircher 
> 
> ---Begin BUG: 
> 
> kernel BUG at kernel/rtmutex.c:683! 
> stopped custom tracer. 
> Oops: Exception in kernel mode, sig: 5 [#1] 
> PREEMPT MPC834x ITX 
> NIP: c021629c LR: c0216270 CTR: 00000000 
> REGS: df761d70 TRAP: 0700   Not tainted  (2.6.23.9-rt13) 
> MSR: 00021032 <ME,IR,DR>  CR: 28000022  XER: 00000000 
> TASK = df632080[241] 'IRQ-38' THREAD: df760000 
> GPR00: 00000001 df761e20 df632080 00000000 11111111 00000000 df761e6c 
> 00000000 
> GPR08: df761e48 00000000 df761e50 00000000 80000000 ede5cdde 1fffd000 
> 00800000 
> GPR16: ffffffff 00000000 007fff00 00000040 00000000 007ffeb0 00000000 
> 1fff8b08 
> GPR24: 00000000 00000026 00000000 df79a320 c026b2e8 c02240bc 00009032 
> df79a320 
> NIP [c021629c] rt_spin_lock_slowlock+0x9c/0x200 
> LR [c0216270] rt_spin_lock_slowlock+0x70/0x200 
> Call Trace: 
> [df761e20] [c0216270] rt_spin_lock_slowlock+0x70/0x200 (unreliable) 
> [df761e90] [c0182828] fsl_ep_disable+0xcc/0x154 
> [df761eb0] [c0184d30] eth_reset_config+0x88/0x1d0 
> [df761ed0] [c0184ec0] eth_disconnect+0x48/0x64 
> [df761ef0] [c01831a4] reset_queues+0x60/0x78 
> [df761f00] [c0183b74] fsl_udc_irq+0x9b8/0xa58 
> [df761f50] [c003ef30] handle_IRQ_event+0x64/0x100 
> [df761f80] [c003f758] thread_simple_irq+0x6c/0xc8 
> [df761fa0] [c003f888] do_irqd+0xd4/0x2e4 
> [df761fd0] [c0032284] kthread+0x50/0x8c 
> [df761ff0] [c000f9b4] kernel_thread+0x44/0x60 
> Instruction dump: 
> 4be25fb9 2f830000 41be0014 7fe3fb78 7fc4f378 48000f69 48000168 801f0024 
> 5400003a 7c001278 21600000 7c0b0114 <0f000000> 38000004 90010008 80010008 
> note: IRQ-38[241] exited with preempt_count 1 
> BUG: sleeping function called from invalid context IRQ-38(241) at 
> kernel/rtmutex.c:637 
> in_atomic():1 [00000001], irqs_disabled():0 
> Call Trace: 
> [df761c20] [c0008674] show_stack+0x54/0x174 (unreliable) 
> [df761c50] [c0014e74] __might_sleep+0xe0/0xf4 
> [df761c60] [c02169f8] __lock_text_start+0x30/0x48 
> [df761c70] [c001e928] do_exit+0x1f8/0x7bc 
> [df761ca0] [c000d0bc] die+0x198/0x1b0 
> [df761cc0] [c000d26c] _exception+0x38/0xf8 
> [df761d60] [c000f1bc] ret_from_except_full+0x0/0x4c 
> --- Exception: 700 at rt_spin_lock_slowlock+0x9c/0x200 
>    LR = rt_spin_lock_slowlock+0x70/0x200 
> [df761e90] [c0182828] fsl_ep_disable+0xcc/0x154 
> [df761eb0] [c0184d30] eth_reset_config+0x88/0x1d0 
> [df761ed0] [c0184ec0] eth_disconnect+0x48/0x64 
> [df761ef0] [c01831a4] reset_queues+0x60/0x78 
> [df761f00] [c0183b74] fsl_udc_irq+0x9b8/0xa58 
> [df761f50] [c003ef30] handle_IRQ_event+0x64/0x100 
> [df761f80] [c003f758] thread_simple_irq+0x6c/0xc8 
> [df761fa0] [c003f888] do_irqd+0xd4/0x2e4 
> [df761fd0] [c0032284] kthread+0x50/0x8c 
> [df761ff0] [c000f9b4] kernel_thread+0x44/0x60 
> 

Thanks, useful.

Let's cc some folks.
