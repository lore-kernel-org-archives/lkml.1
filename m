Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab0CHLe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 06:34:58 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:35665 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232Ab0CHLe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 06:34:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LFT3tjg4Pu8pZ9F56TK1gIyuy3lXrHzmBqj5tFdNkQySpby1OeU8Uux3isX0TKxxQ5
         DtVNzJOa23mfVqoXhtCTdeQXYrmBImCQPILTOSv82hFSru9WL93Llu8vJ1sdkmEsW3z7
         vcNNRkeJ9yEb0ISOMLEGO8elM/6m7wiIqPZfs=
Date: Mon, 8 Mar 2010 14:34:52 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org,
       Kerstin Jonsson <kerstin.jonsson@ericsson.com>, jbohac@novell.com,
       Yinghai Lu <yinghai@kernel.org>, akpm@linux-foundation.org,
       mingo@elte.hu, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] x86 apic: Ack all pending irqs when crashed/on kexec
Message-ID: <20100308113452.GK6004@lenovo>
References: <1268047030-29911-1-git-send-email-trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268047030-29911-1-git-send-email-trenn@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 08, 2010 at 12:17:10PM +0100, Thomas Renninger wrote:
...
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index 3987e44..93cdb2a 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -51,6 +51,7 @@
>  #include <asm/smp.h>
>  #include <asm/mce.h>
>  #include <asm/kvm_para.h>
> +#include <asm/tsc.h>
>  
>  unsigned int num_processors;
>  
> @@ -1151,8 +1152,12 @@ static void __cpuinit lapic_setup_esr(void)
>   */
>  void __cpuinit setup_local_APIC(void)
>  {
> -	unsigned int value;
> -	int i, j;
> +	unsigned int value, queued;
> +	int i, j, acked = 0;
> +	unsigned long long tsc = 0, ntsc, max_loops = cpu_khz;
> +
> +	if (cpu_has_tsc)
> +		rdtscll(ntsc);

Perhaps rdtscll(tsc)?

>  
>  	if (disable_apic) {
>  		arch_disable_smp_support();
> @@ -1204,13 +1209,32 @@ void __cpuinit setup_local_APIC(void)
>  	 * the interrupt. Hence a vector might get locked. It was noticed
>  	 * for timer irq (vector 0x31). Issue an extra EOI to clear ISR.
>  	 */
> -	for (i = APIC_ISR_NR - 1; i >= 0; i--) {
> -		value = apic_read(APIC_ISR + i*0x10);
> -		for (j = 31; j >= 0; j--) {
> -			if (value & (1<<j))
> -				ack_APIC_irq();
> -		}
> -	}
> +        do {
> +            queued = 0;
> +            for (i = APIC_ISR_NR - 1; i >= 0; i--)
> +                queued |= apic_read(APIC_IRR + i*0x10);
> +
> +            for (i = APIC_ISR_NR - 1; i >= 0; i--) {
> +                value = apic_read(APIC_ISR + i*0x10);
> +                for (j = 31; j >= 0; j--) {
> +                    if (value & (1<<j)) {
> +                        ack_APIC_irq();
> +                        acked++;
> +                    }
> +                }
> +            }
> +            if (acked > 256) {
> +                printk(KERN_ERR "LAPIC pending interrupts after %d EOI\n",
> +		       acked);
> +                break;
> +            }
> +	    if (cpu_has_tsc) {
> +		    rdtscll(ntsc);
> +		    max_loops = (cpu_khz << 10) - (ntsc - tsc);

Where is tsc modified? It remains tsc = 0 all the time?
Or I miss the snippet where it is set?

> +	    } else
> +		    max_loops--;
> +        } while (queued && max_loops > 0);
> +	WARN_ON(!max_loops);
>  
>  	/*
>  	 * Now that we are all set up, enable the APIC
> -- 
> 1.6.3
> 
	-- Cyrill
