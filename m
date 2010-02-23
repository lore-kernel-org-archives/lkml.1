Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab0BWMFP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 07:05:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471Ab0BWMFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 07:05:12 -0500
Message-ID: <4B83C411.9050308@redhat.com>
Date: Tue, 23 Feb 2010 14:03:29 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: linux-kernel@vger.kernel.org,
       Kerstin Jonsson <kerstin.jonsson@ericsson.com>, jbohac@novell.com,
       Yinghai Lu <yinghai@kernel.org>, akpm@linux-foundation.org,
       mingo@elte.hu
Subject: Re: [PATCH] x86 apic: Ack all pending irqs when crashed/on kexec
References: <1266925885-17616-1-git-send-email-trenn@suse.de>
In-Reply-To: <1266925885-17616-1-git-send-email-trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2010 01:51 PM, Thomas Renninger wrote:
> From: Kerstin Jonsson<kerstin.jonsson@ericsson.com>
>
> When the SMP kernel decides to crash_kexec() the local APICs may have
> pending interrupts in their vector tables.
> The setup routine for the local APIC has a deficient mechanism for
> clearing these interrupts, it only handles interrupts that has already
> been dispatched to the local core for servicing (the ISR register)
> safely, it doesn't consider lower prioritized queued interrupts stored
> in the IRR register.
>
> If you have more than one pending interrupt within the same 32 bit word
> in the LAPIC vector table registers you may find yourself entering the
> IO APIC setup with pending interrupts left in the LAPIC. This is a
> situation for wich the IO APIC setup is not prepared. Depending of
> what/which interrupt vector/vectors are stuck in the APIC tables your
> system may show various degrees of malfunctioning.
> That was the reason why the check_timer() failed in our system, the
> timer interrupts was blocked by pending interrupts from the old kernel
> when routed trough the IO APIC.
>
> Additional comment from Jiri Bohac:
> ==============
> If this should go into stable release,
> I'd add some kind of limit on the number of iterations, just to be safe from
> hard to debug lock-ups:
>
> +if (loops++>  MAX_LOOPS) {
> +        printk("LAPIC pending clean-up")
> +        break;
> +}
>   while (queued);
>
> with MAX_LOOPS something like 1E9 this would leave plenty of time for the
> pending IRQs to be cleared and would and still cause at most a second of delay
> if the loop were to lock-up for whatever reason.
> ==============
>
>  From trenn@suse.de:
> Merged Jiri suggestion into the patch.
> Also made the max_loops depend on cpu_khz. Not sure how long an apic_read
> takes, as it is on the CPU it may only be one cycle and we now wait 1 sec
> in WARN_ON(..) case?
>
>    

An apic_read() can take a couple of microseconds when running 
virtualized, so this loop may run for hours.  On the other hand, 
virtualized hardware is unlikely to misbehave.

Still I recommend using a clocksource (tsc would do) and not a loop count.

-- 
error compiling committee.c: too many arguments to function

