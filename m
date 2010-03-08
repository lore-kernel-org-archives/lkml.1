Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab0CHL0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 06:26:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395Ab0CHL0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 06:26:46 -0500
Message-ID: <4B94DED9.6000104@redhat.com>
Date: Mon, 08 Mar 2010 13:26:17 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: linux-kernel@vger.kernel.org,
       Kerstin Jonsson <kerstin.jonsson@ericsson.com>, jbohac@novell.com,
       Yinghai Lu <yinghai@kernel.org>, akpm@linux-foundation.org,
       mingo@elte.hu
Subject: Re: [PATCH] x86 apic: Ack all pending irqs when crashed/on kexec
References: <1268047030-29911-1-git-send-email-trenn@suse.de>
In-Reply-To: <1268047030-29911-1-git-send-email-trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2010 01:17 PM, Thomas Renninger wrote:
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
> V2: Use tsc if avail to bail out after 1 sec due to possible virtual apic_read
>      calls which may take rather long (suggested by: Avi Kivity<avi@redhat.com>)
>      If no tsc is available bail out quickly after cpu_khz, if we broke out too
>      early and still have irqs pending (which should never happen?) we still
>      get a WARN_ON...
>
>
>
> @@ -1151,8 +1152,12 @@ static void __cpuinit lapic_setup_esr(void)
>    */
>   void __cpuinit setup_local_APIC(void)
>   {
> -	unsigned int value;
> -	int i, j;
> +	unsigned int value, queued;
> +	int i, j, acked = 0;
> +	unsigned long long tsc = 0, ntsc, max_loops = cpu_khz;
> +
> +	if (cpu_has_tsc)
> +		rdtscll(ntsc);
>
>
>    

...

> +	    if (cpu_has_tsc) {
> +		    rdtscll(ntsc);
> +		    max_loops = (cpu_khz<<  10) - (ntsc - tsc);
>    

Since max_loops is unsigned, this will always be positive.

> +	    } else
> +		    max_loops--;
> +        } while (queued&&  max_loops>  0);
> +	WARN_ON(!max_loops);
>    

So the loop never terminates unless queued becomes true.

-- 
error compiling committee.c: too many arguments to function

