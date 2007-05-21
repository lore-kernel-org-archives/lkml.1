Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbXEUQsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbXEUQsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761321AbXEUQru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:47:50 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:48960 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761130AbXEUQrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:47:48 -0400
From: Darren Hart <dvhltc@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Ignore bogus ACPI info for offline CPUs
Date: Mon, 21 May 2007 09:47:33 -0700
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>,
       Stable Team <stable@kernel.org>
References: <1179584570.12981.123.camel@chaos>
In-Reply-To: <1179584570.12981.123.camel@chaos>
Organization: IBM Linux Technology Center
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705210947.35350.dvhltc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 May 2007 07:22:50 Thomas Gleixner wrote:
> Booting a SMP kernel with maxcpus=1 on a SMP system leads to a hard
> hang, because ACPI ignores the maxcpus setting and sends timer broadcast
> info for the offline CPUs. This results in a stuck for ever call to
> smp_call_function_single() on an offline CPU.
>
> Ignore the bogus information and print a kernel error to remind ACPI
> folks to fix it.
>
> Affects 2.6.21 / 2.6.22-rc
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

When I first booted with this patch I received the following in a loop:

irq 9: nobody cared (try booting with the "irqpoll" option)

Call Trace:
 [<ffffffff8106d5a4>] dump_trace+0xaa/0x32a
 [<ffffffff8106d865>] show_trace+0x41/0x5c
 [<ffffffff8106d895>] dump_stack+0x15/0x17
 [<ffffffff810c50b8>] __report_bad_irq+0x38/0x87
 [<ffffffff810c52cb>] note_interrupt+0x1c4/0x1fc
 [<ffffffff810c458d>] thread_simple_irq+0x6c/0x7e
 [<ffffffff810c4dc3>] do_irqd+0x14a/0x3e4
 [<ffffffff81033d3a>] kthread+0xf5/0x128
 [<ffffffff8105ff68>] child_rip+0xa/0x12

handlers:
[<ffffffff8117736e>] (acpi_irq+0x0/0x1b)

I then tried to boot with maxcpus=1 and acpi=noirq and I got all the way to a 
login prompt.  As we have seen this "nobody cared" and child_rip dump issues 
before - I think these are independent issues that should be tracked 
separately.

Thanks,

Darren

>
> Index: linux-2.6.22-rc/kernel/time/tick-broadcast.c
> ===================================================================
> --- linux-2.6.22-rc.orig/kernel/time/tick-broadcast.c
> +++ linux-2.6.22-rc/kernel/time/tick-broadcast.c
> @@ -244,11 +244,18 @@ void tick_broadcast_on_off(unsigned long
>  {
>  	int cpu = get_cpu();
>
> -	if (cpu == *oncpu)
> -		tick_do_broadcast_on_off(&reason);
> -	else
> -		smp_call_function_single(*oncpu, tick_do_broadcast_on_off,
> -					 &reason, 1, 1);
> +	if (!cpu_isset(*oncpu, cpu_online_map)) {
> +		printk(KERN_ERR "tick-braodcast: ignoring broadcast for "
> +		       "offline CPU #%d\n", *oncpu);
> +	} else {
> +
> +		if (cpu == *oncpu)
> +			tick_do_broadcast_on_off(&reason);
> +		else
> +			smp_call_function_single(*oncpu,
> +						 tick_do_broadcast_on_off,
> +						 &reason, 1, 1);
> +	}
>  	put_cpu();
>  }



-- 
Darren Hart
IBM Linux Technology Center
Realtime Linux Team
