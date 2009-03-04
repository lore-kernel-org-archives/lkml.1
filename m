Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbZCDUa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbZCDUa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 15:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755850AbZCDUaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 15:30:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:56277 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986AbZCDUaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 15:30:18 -0500
Message-ID: <49AEE494.7070104@kernel.org>
Date: Wed, 04 Mar 2009 12:29:08 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: ioremap mptable
References: <49AE485B.8000902@kernel.org> <49AE4901.3090801@kernel.org> <20090304195014.GA21488@elte.hu>
In-Reply-To: <20090304195014.GA21488@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> Impact: fix boot with mptable above max_low_mapped
>>
>> try to use early_ioremap to map mpc to make sure it works even it is
>> at end of ram on system.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> Reported-and-tested-by: Kevin O'Connor <kevin@koconnor.net>
>>
>> ---
>>  arch/x86/kernel/mpparse.c |   26 +++++++++++++++++++++++---
>>  1 file changed, 23 insertions(+), 3 deletions(-)
>>
>> Index: linux-2.6/arch/x86/kernel/mpparse.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/mpparse.c
>> +++ linux-2.6/arch/x86/kernel/mpparse.c
>> @@ -558,6 +558,19 @@ static inline void __init construct_defa
>>  
>>  static struct mpf_intel *mpf_found;
>>  
>> +static unsigned long __init get_mpc_size(unsigned long physptr)
>> +{
>> +	struct mpc_table *mpc;
>> +	unsigned long size;
>> +
>> +	mpc = early_ioremap(physptr, PAGE_SIZE);
>> +	size = mpc->length;
>> +	early_iounmap(mpc, PAGE_SIZE);
>> +	apic_printk(APIC_VERBOSE, "  mpc: %lx-%lx\n", physptr, physptr + size);
>> +
>> +	return size;
>> +}
>> +
>>  /*
>>   * Scan the memory blocks for an SMP configuration block.
>>   */
>> @@ -611,12 +624,16 @@ static void __init __get_smp_config(unsi
>>  		construct_default_ISA_mptable(mpf->feature1);
>>  
>>  	} else if (mpf->physptr) {
>> +		struct mpc_table *mpc;
>> +		unsigned long size;
>>  
>> +		size = get_mpc_size(mpf->physptr);
>> +		mpc = early_ioremap(mpf->physptr, size);
>>  		/*
>>  		 * Read the physical hardware table.  Anything here will
>>  		 * override the defaults.
>>  		 */
>> -		if (!smp_read_mpc(phys_to_virt(mpf->physptr), early)) {
>> +		if (!smp_read_mpc(mpc, early)) {
>>  #ifdef CONFIG_X86_LOCAL_APIC
>>  			smp_found_config = 0;
>>  #endif
>> @@ -624,8 +641,10 @@ static void __init __get_smp_config(unsi
>>  			       "BIOS bug, MP table errors detected!...\n");
>>  			printk(KERN_ERR "... disabling SMP support. "
>>  			       "(tell your hw vendor)\n");
>> +			early_iounmap(mpc, size);
>>  			return;
>>  		}
>> +		early_iounmap(mpc, size);
>>  
>>  		if (early)
>>  			return;
> 
> the whole "else if" branch here:
> 
>  	} else if (mpf->physptr) {
> 
> should move into a helper function, not just get_mpc_size().
> 

will check that.

another solution is change smp_read_mpc interface, let it pass mpf->physptr directly.

YH
