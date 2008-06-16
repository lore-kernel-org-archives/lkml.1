Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbYFPNK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbYFPNK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 09:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbYFPNKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 09:10:18 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:43558 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753051AbYFPNKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 09:10:17 -0400
Message-ID: <48566639.4000006@suse.de>
Date: Mon, 16 Jun 2008 17:10:17 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: using dstapic in mp_config_acpi_legacy_irqs
References: <200806151819.47236.yhlu.kernel@gmail.com>
In-Reply-To: <200806151819.47236.yhlu.kernel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,

I think it should be split into 3 pieces, according to latest tradition :)
1. don't init variables with -1
2. use dstapic to allow moving of assignments together
3. move assignments

Other than that seems ok (thou I'm not sure that -1 is not used somewhere)

Regards,
Alex.

Yinghai Lu wrote:
> so don't get that same value multiple times.
> 
> also make mp_config_acpi_legacy_irqs more readable by moving some assignment
> together.
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> index d2a4768..04dbb35 100644
> --- a/arch/x86/kernel/acpi/boot.c
> +++ b/arch/x86/kernel/acpi/boot.c
> @@ -960,8 +960,8 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
>  
>  void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
>  {
> -	int ioapic = -1;
> -	int pin = -1;
> +	int ioapic;
> +	int pin;
>  
>  	/*
>  	 * Convert 'gsi' to 'ioapic.pin'.
> @@ -995,8 +995,9 @@ void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
>  
>  void __init mp_config_acpi_legacy_irqs(void)
>  {
> -	int i = 0;
> -	int ioapic = -1;
> +	int i;
> +	int ioapic;
> +	unsigned int dstapic;
>  
>  #if defined (CONFIG_MCA) || defined (CONFIG_EISA)
>  	/*
> @@ -1021,6 +1022,7 @@ void __init mp_config_acpi_legacy_irqs(void)
>  	ioapic = mp_find_ioapic(0);
>  	if (ioapic < 0)
>  		return;
> +	dstapic = mp_ioapics[ioapic].mp_apicid;
>  
>  	/*
>  	 * Use the default configuration for the IRQs 0-15.  Unless
> @@ -1029,11 +1031,6 @@ void __init mp_config_acpi_legacy_irqs(void)
>  	for (i = 0; i < 16; i++) {
>  		int idx;
>  
> -		mp_irqs[mp_irq_entries].mp_type = MP_INTSRC;
> -		mp_irqs[mp_irq_entries].mp_irqflag = 0;	/* Conforming */
> -		mp_irqs[mp_irq_entries].mp_srcbus = MP_ISA_BUS;
> -		mp_irqs[mp_irq_entries].mp_dstapic = mp_ioapics[ioapic].mp_apicid;
> -
>  		for (idx = 0; idx < mp_irq_entries; idx++) {
>  			struct mp_config_intsrc *irq = mp_irqs + idx;
>  
> @@ -1043,9 +1040,8 @@ void __init mp_config_acpi_legacy_irqs(void)
>  				break;
>  
>  			/* Do we already have a mapping for this IOAPIC pin */
> -			if ((irq->mp_dstapic ==
> -				mp_irqs[mp_irq_entries].mp_dstapic) &&
> -			    (irq->mp_dstirq == i))
> +			if (irq->mp_dstapic == dstapic &&
> +			    irq->mp_dstirq == i)
>  				break;
>  		}
>  
> @@ -1054,8 +1050,12 @@ void __init mp_config_acpi_legacy_irqs(void)
>  			continue;	/* IRQ already used */
>  		}
>  
> +		mp_irqs[mp_irq_entries].mp_type = MP_INTSRC;
> +		mp_irqs[mp_irq_entries].mp_irqflag = 0;	/* Conforming */
> +		mp_irqs[mp_irq_entries].mp_srcbus = MP_ISA_BUS;
> +		mp_irqs[mp_irq_entries].mp_dstapic = dstapic;
>  		mp_irqs[mp_irq_entries].mp_irqtype = mp_INT;
> -		mp_irqs[mp_irq_entries].mp_srcbusirq = i;	/* Identity mapped */
> +		mp_irqs[mp_irq_entries].mp_srcbusirq = i; /* Identity mapped */
>  		mp_irqs[mp_irq_entries].mp_dstirq = i;
>  
>  		if (++mp_irq_entries == MAX_IRQ_SOURCES)

