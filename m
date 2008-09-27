Return-Path: <linux-kernel-owner+w=401wt.eu-S1754357AbYI0AOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbYI0AOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 20:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbYI0AOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 20:14:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60909 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbYI0AOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 20:14:22 -0400
Message-ID: <48DD799C.3070706@zytor.com>
Date: Fri, 26 Sep 2008 17:09:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, avi@redhat.com,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>,
       Dan Hecht <dhecht@vmware.com>, Jun.Nakajima@Intel.Com
Subject: Re: Use CPUID to communicate with the hypervisor.
References: <1222472815.29886.43.camel@alok-dev1>
In-Reply-To: <1222472815.29886.43.camel@alok-dev1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> From: Alok N Kataria <akataria@vmware.com>
> 
> This patch proposes to use a cpuid interface to detect if we are running on an
> hypervisor.
> The discovery of a hypervisor is determined by bit 31 of CPUID#1_ECX, which is
> defined to be "hypervisor present bit". For a VM, the bit is 1, otherwise it is
> set to 0. This bit is not officially documented by either Intel/AMD yet, but
> they plan to do so some time soon, in the meanwhile they have promised to keep
> it reserved for virtualization.
> 
> Also, Intel & AMD have reserved the cpuid levels 0x40000000 - 0x400000FF for
> software use. Hypervisors can use these levels to provide an interface to pass
> information from the hypervisor to the guest. This is similar to how we extract
> information about a physical cpu by using cpuid.
> XEN/KVM are already using the info leaf to get the hypervisor signature.
> 
> VMware hardware version 7 defines some of these cpuid levels, below is a brief
> description about those. These levels can be implemented by other hypervisors
> too so that Linux has a standard way of communicating to any hypervisor.
> 
> Leaf 0x40000000, Hypervisor CPUID information
> # EAX: The maximum input value for hypervisor CPUID info (0x40000010).
> # EBX, ECX, EDX: Hypervisor vendor ID signature. E.g. "VMwareVMware"
> 

This is great, obviously... although we'll have to deal with legacy 
methods for a while if not indefinitely (just as we have to for 
pre-CPUID processors).

>  
> +static void __init detect_hypervisor(void)
> +{
> +	if (cpu_has_hypervisor) {
> +		unsigned int eax, ebx, ecx, edx;
> +		char hyper_vendor_id[13];
> +
> +		cpuid(HYPERVISOR_INFO_LEAF, &eax, &ebx, &ecx, &edx);
> +		memcpy(hyper_vendor_id + 0, &ebx, 4);
> +		memcpy(hyper_vendor_id + 4, &ecx, 4);
> +		memcpy(hyper_vendor_id + 8, &edx, 4);
> +		hyper_vendor_id[12] = '\0';
> +		printk(KERN_INFO "Hypervisor vendor id %s\n", hyper_vendor_id);
> +	}
> +}
> +

This should be broken out into a separate file in cpu/*, because we 
*will* need to detect hypervisors by other means.
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -345,16 +345,38 @@ failed:
>  	return 0;
>  }
>  
> +unsigned long hypervisor_tsc_freq(void)
> +{
> +	unsigned long tsc_khz;
> +	unsigned int max_cpuid_leaf;
> +
> +	if (cpu_has_hypervisor) {
> +		max_cpuid_leaf = cpuid_eax(HYPERVISOR_INFO_LEAF);
> +		if (max_cpuid_leaf >= HYPERVISOR_TIMING_LEAF) {
> +			tsc_khz = cpuid_eax(HYPERVISOR_TIMING_LEAF);
> +			printk(KERN_INFO
> +				"TSC frequency read from hypervisor\n");
> +			return tsc_khz;
> +		}
> +	}
> +	return 0;
> +}
> +

I would call this "vmware_tsc_freq()" because it is a VMWare-defined 
interface... you can't just poke at 0x40000010 and assume it is using 
the VMWare definition.

In order for *that* to be safe, you'd have to have well-defined ranges 
for different virtualization vendors where each of them can define their 
own stuff.

> diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
> index ee7cbb3..70ca49b 100644
> --- a/include/asm-x86/processor.h
> +++ b/include/asm-x86/processor.h
> @@ -124,6 +124,27 @@ struct cpuinfo_x86 {
>  #define X86_VENDOR_UNKNOWN	0xff
>  
>  /*
> + * Intel & AMD have reserved the cpuid levels 0x40000000 - 0x400000FF for
> + * software use. Hypervisors can use these levels to provide an interface
> + * to pass information from the hypervisor to the guest. This is similar
> + * to how we extract information about a physical cpu by using cpuid.
> + */
> +
> +/*
> + * This CPUID leaf returns the information about the hypervisor.
> + * EAX : maximum input value for CPUID supported by the hypervisor.
> + * EBX, ECX, EDX : Hypervisor vendor ID signature. E.g. VMwareVMware.
> + */
> +#define HYPERVISOR_INFO_LEAF   0x40000000
> +/*
> + * This leaf gets timing information from the hypervisor.
> + * EAX: (Virtual) TSC frequency in kHz.
> + * EBX: (Virtual) Bus (local apic timer) frequency in kHz.
> + * ECX, EDX: RESERVED
> + */
> +#define HYPERVISOR_TIMING_LEAF 0x40000010
> +

<asm/processor.h> is the wrong place for this, and these constants 
should have CPUID_ in them to tell what they fundamentally are.

My preference would be for <asm/cpuid.h>, but otherwise 
<asm/cpufeature.h> wouldn't be entirely wrong.

	-hpa
