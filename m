Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535Ab0AIC3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab0AIC3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 21:29:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519Ab0AIC3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 21:29:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33440 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab0AIC3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 21:29:41 -0500
Message-ID: <4B47E7A9.6090904@zytor.com>
Date: Fri, 08 Jan 2010 18:19:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       Yinghai Lu <yinghai@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, apic: use 0x20 for the IRQ_MOVE_CLEANUP_VECTOR instead
 of 0x1f
References: <1263002989.2879.664.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1263002989.2879.664.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2010 06:09 PM, Suresh Siddha wrote:
> 
> So change the IRQ_MOVE_CLEANUP_VECTOR to 0x20 and  allow 0x21-0x2f to be used
> for device interrupts. 0x30-0x3f will be used for ISA interrupts (these
> also can be migrated in the context of IOAPIC and hence need to be at a higher
> priority level than IRQ_MOVE_CLEANUP_VECTOR).
> 

You're referring to when they're accessed as IOAPIC interrupts as
opposed to ExtInt interrupts?

>  
> -/*
> - * First APIC vector available to drivers: (vectors 0x30-0xee).  We
> - * start allocating at 0x31 to spread out vectors evenly between
> - * priority levels. (0x80 is the syscall vector)
> - */
> -#define FIRST_DEVICE_VECTOR		(IRQ15_VECTOR + 1)
> -#define VECTOR_OFFSET_START		1
> -
>  #define NR_VECTORS			 256
>  
>  #define FPU_IRQ				  13
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index d5bfa29..5c090a1 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -1162,8 +1162,8 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
>  	 * Also, we've got to be careful not to trash gate
>  	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
>  	 */
> -	static int current_vector = FIRST_DEVICE_VECTOR + VECTOR_OFFSET_START;
> -	static int current_offset = VECTOR_OFFSET_START % 8;
> +	static int current_vector = FIRST_DEVICE_VECTOR;
> +	static int current_offset = 0;
>  	unsigned int old_vector;
>  	int cpu, err;
>  	cpumask_var_t tmp_mask;
> 

I'm not entirely sure I like losing this bit, even though it isn't
really necessary with your changes (VECTOR_OFFSET_START would be 0).
I'm afraid we might end up with the same buglet being "reinvented" later.

However, my most serious concern with this patch is that there is a
fairly significant change due to this patch, which is that the legacy
IRQ vectors now fall *inside* the FIRST_DEVICE_VECTOR range.  This isn't
a bad thing -- in fact, it is fundamentally the right thing to do
especially once we consider platforms which *don't* have the legacy IRQs
-- but it makes me scared of unexpected behavior changes as a result.
If you feel confident that that is not the case, could you outline why
it shouldn't be a problem?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

