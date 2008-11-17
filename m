Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbYKQRzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbYKQRzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 12:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbYKQRzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 12:55:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:33670 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbYKQRza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 12:55:30 -0500
Message-ID: <4921AFEB.4060605@kernel.org>
Date: Mon, 17 Nov 2008 09:54:51 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix wakeup_cpu with numaq/es7000 v2
References: <491FDE2A.1010809@kernel.org> <49200031.2040701@kernel.org> <20081117165224.GH12081@elte.hu>
In-Reply-To: <20081117165224.GH12081@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> Impact: fix wakeup path with numaq and es7000
> 
> applied	to tip/x86/quirks, thanks Yinghai!
> 
> A couple of comments:
> 
>> +static inline void inquire_remote_apic(int apicid)
>> +{
>> +	if (apic_verbosity >= APIC_DEBUG)
>> +		__inquire_remote_apic(apicid);
>> +}
> 
> could you please make this a non-include-file function and only 
> install the function vector if the platform necessiates it?

good idea, after genapic get assigned,
update the genapic .inquire_remote_apic according to apic_verbosity...

> 
> I.e.:
> 
>> +	void (*wait_for_init_deassert)(atomic_t *deassert);
>> +	void (*smp_callin_clear_local_apic)(void);
>> +	void (*store_NMI_vector)(unsigned short *high, unsigned short *low);
>> +	void (*restore_NMI_vector)(unsigned short *high, unsigned short *low);
>> +	void (*inquire_remote_apic)(int apicid);
> 
> should have NULL in the 'default' case - and only have some exception 
> (quick) function installed in the non-default case.
> 
> That way the 3 separate wait_for_init_deassert() and 
> inquire_remote_apic() inline functions can be removed and the 
> exception be moved to es7000_32.c and numaq_32.c.
> 

will look at it...

> like you did it here properly to install the MIP-init sequence in the 
> es7000 case:
> 
>> Index: linux-2.6/arch/x86/kernel/es7000_32.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/es7000_32.c
>> +++ linux-2.6/arch/x86/kernel/es7000_32.c
>> @@ -40,6 +40,7 @@
>>  #include <asm/smp.h>
>>  #include <asm/apicdef.h>
>>  #include <mach_mpparse.h>
>> +#include <asm/setup.h>
>>  
>>  /*
>>   * ES7000 chipsets
>> @@ -161,6 +162,26 @@ es7000_rename_gsi(int ioapic, int gsi)
>>  	return gsi;
>>  }
>>  
>> +#ifdef CONFIG_ES7000_CLUSTERED_APIC
>> +static int wakeup_secondary_cpu_via_mip(int cpu, unsigned long eip)
>> +{
>> +	unsigned long vect = 0, psaival = 0;
>> +
>> +	if (psai == NULL)
>> +		return -1;
>> +
>> +	vect = ((unsigned long)__pa(eip)/0x1000) << 16;
>> +	psaival = (0x1000000 | vect | cpu);
>> +
>> +	while (*psai & 0x1000000)
>> +		;
>> +
>> +	*psai = psaival;
>> +
>> +	return 0;
>> +}
>> +#endif
>> +
>>  void __init
>>  setup_unisys(void)
>>  {
>> @@ -176,6 +197,9 @@ setup_unisys(void)
>>  	else
>>  		es7000_plat = ES7000_CLASSIC;
>>  	ioapic_renumber_irq = es7000_rename_gsi;
>> +#ifdef CONFIG_ES7000_CLUSTERED_APIC
>> +	x86_quirks->wakeup_secondary_cpu = wakeup_secondary_cpu_via_mip;
>> +#endif
>>  }
> 
> btw:
> 
> shouldnt CONFIG_ES7000_CLUSTERED_APIC be converted to a proper genapic 
> variant (like we have in apic.c), instead of this #ifdef driven 
> mechanism?

you are right, need to autodetect that. and we can reuse one in mach_default/mach_wakecpu.h

YH
