Return-Path: <linux-kernel-owner+w=401wt.eu-S1761701AbYESQKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761701AbYESQKv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 12:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760910AbYESQKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 12:10:36 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37790 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757526AbYESQKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 12:10:35 -0400
X-Sasl-enc: YYsoG0nl8VltkXhaWQXIR3jOiRSFZC68wR8V1gAOCz/7 1211213432
Message-ID: <4831A678.5070208@ladisch.de>
Date: Mon, 19 May 2008 18:10:32 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Kevin Hao <kexin.hao@windriver.com>
CC: venkatesh.pallipadi@intel.com, bob.picco@hp.com, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Get irq for hpet timer
References: <1210917912.10881.1.camel@kevin-desktop>	 <482D49CF.4030902@ladisch.de> <1210929270.11912.3.camel@kevin-desktop>
In-Reply-To: <1210929270.11912.3.camel@kevin-desktop>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Hao wrote:
> +	for (irq = find_first_bit(&cap, HPET_MAX_IRQ); irq < HPET_MAX_IRQ;
> +		irq = find_next_bit(&cap, HPET_MAX_IRQ, 1 + irq)) {
> +		if (request_irq(irq, hpet_interrupt, irq_flags,
> +				devp->hd_name, (void *)devp))

This spams my log with interrupt sharing violations.  As long as we do
not know that the interrupt slot is empty, we need IRQF_PROBE_SHARED
here.

Another problem: the interrupt controller doesn't get correctly
initialized for some interrupt line that didn't already have some
routing:
| $ cat /proc/interrupts
|            CPU0
|   0:         63   IO-APIC-edge      timer
|   1:         96   IO-APIC-edge      i8042
|   2:          0    XT-PIC-XT        hpet2
|   6:          3   IO-APIC-edge      floppy
|   7:          0   IO-APIC-edge      parport0
|   8:          3   IO-APIC-edge      rtc
|   9:          0   IO-APIC-fasteoi   acpi
| ...

Additionally, I vaguely remember that on X86, there is some funny stuff
going on with interrupt lines 0, 2 and 8 which means that the interrupt
number passed to request_irq() is not necessarily identical to the
hardware interrupt line.

I don't know which of these problems is responsible, or if I'm totally
wrong, but on my machine, interrupts from hpet2 do not arrive.


Regards,
Clemens
