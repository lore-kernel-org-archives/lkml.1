Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab0CIJNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 04:13:09 -0500
Received: from mailgw9.se.ericsson.net ([193.180.251.57]:64090 "EHLO
	mailgw9.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab0CIJNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 04:13:05 -0500
X-AuditID: c1b4fb39-b7c2dae000007b99-e3-4b96111da6d6
Message-ID: <4B96116A.6090705@ericsson.com>
Date: Tue, 09 Mar 2010 10:14:18 +0100
From: "kerstin.jonsson" <kerstin.jonsson@ericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jbohac@novell.com" <jbohac@novell.com>,
       Yinghai Lu <yinghai@kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] x86 apic: Ack all pending irqs when crashed/on kexec
 - V4
References: <20100308113452.GK6004@lenovo> <1268048582-12219-1-git-send-email-trenn@suse.de>
In-Reply-To: <1268048582-12219-1-git-send-email-trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Mar 2010 09:13:01.0196 (UTC) FILETIME=[B7A3F4C0:01CABF68]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2010 12:43 PM, Thomas Renninger wrote:
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
> V3: - Fixed indentation ->  checkpatch clean
>      - max_loops must be signed
>
> V4: - Fix typo, mixed up tsc and ntsc in first rdtscll() call
>
> CC: jbohac@novell.com
> CC: "Yinghai Lu"<yinghai@kernel.org>
> CC: akpm@linux-foundation.org
> CC: mingo@elte.hu
> CC: "Kerstin Jonsson"<kerstin.jonsson@ericsson.com>
> CC: "Avi Kivity"<avi@redhat.com>
> Signed-off-by: Thomas Renninger<trenn@suse.de>
> ---
>   arch/x86/kernel/apic/apic.c |   41 +++++++++++++++++++++++++++++++++--------
>   1 files changed, 33 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index 3987e44..414a5df 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -51,6 +51,7 @@
>   #include<asm/smp.h>
>   #include<asm/mce.h>
>   #include<asm/kvm_para.h>
> +#include<asm/tsc.h>
>
>   unsigned int num_processors;
>
> @@ -1151,8 +1152,13 @@ static void __cpuinit lapic_setup_esr(void)
>    */
>   void __cpuinit setup_local_APIC(void)
>   {
> -	unsigned int value;
> -	int i, j;
> +	unsigned int value, queued;
> +	int i, j, acked = 0;
> +	unsigned long long tsc = 0, ntsc;
> +	long long max_loops = cpu_khz;
> +
> +	if (cpu_has_tsc)
> +		rdtscll(tsc);
>
>   	if (disable_apic) {
>   		arch_disable_smp_support();
> @@ -1204,13 +1210,32 @@ void __cpuinit setup_local_APIC(void)
>   	 * the interrupt. Hence a vector might get locked. It was noticed
>   	 * for timer irq (vector 0x31). Issue an extra EOI to clear ISR.
>   	 */
> -	for (i = APIC_ISR_NR - 1; i>= 0; i--) {
> -		value = apic_read(APIC_ISR + i*0x10);
> -		for (j = 31; j>= 0; j--) {
> -			if (value&  (1<<j))
> -				ack_APIC_irq();
> +	do {
> +		queued = 0;
> +		for (i = APIC_ISR_NR - 1; i>= 0; i--)
> +			queued |= apic_read(APIC_IRR + i*0x10);
> +
> +		for (i = APIC_ISR_NR - 1; i>= 0; i--) {
> +			value = apic_read(APIC_ISR + i*0x10);
> +			for (j = 31; j>= 0; j--) {
> +				if (value&  (1<<j)) {
> +					ack_APIC_irq();
> +					acked++;
> +				}
> +			}
>   		}
> -	}
> +		if (acked>  256) {
> +			printk(KERN_ERR "LAPIC pending interrupts after %d EOI\n",
> +			       acked);
> +			break;
> +		}
> +		if (cpu_has_tsc) {
> +			rdtscll(ntsc);
> +			max_loops = (cpu_khz<<  10) - (ntsc - tsc);
> +		} else
> +			max_loops--;
> +	} while (queued&&  max_loops>  0);
> +	WARN_ON(!max_loops);
>
>   	/*
>   	 * Now that we are all set up, enable the APIC
>    
On the verge of being overzealous:

WARN_ON(!max_loops); max_loops<  0 will probably be the most common error exit in a system that has tsc...

