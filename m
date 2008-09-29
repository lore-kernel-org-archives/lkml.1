Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbYI2I3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbYI2I3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 04:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbYI2I3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 04:29:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49218 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbYI2I3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 04:29:00 -0400
Message-ID: <48E090B6.2080809@redhat.com>
Date: Mon, 29 Sep 2008 10:24:22 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, avi@redhat.com,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>,
       Dan Hecht <dhecht@vmware.com>, Jun.Nakajima@Intel.Com
Subject: Re: Use CPUID to communicate with the hypervisor.
References: <1222472815.29886.43.camel@alok-dev1>
In-Reply-To: <1222472815.29886.43.camel@alok-dev1>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

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

Shouldn't you check the hypervisor signature here?

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
> + * This leaf gets timing information from the hypervisor.info.
> + * EAX: (Virtual) TSC frequency in kHz.
> + * EBX: (Virtual) Bus (local apic timer) frequency in kHz.
> + * ECX, EDX: RESERVED
> + */
> +#define HYPERVISOR_TIMING_LEAF 0x40000010

Likewise, I think this should be HYPERVISOR_VMWARE_TIMING_LEAF.

Or we need some way to
  (a) standardize hypervisor cpuid leafes (or parts of it) and
  (b) handle sparsely filled cpuid info.

Right now both kvm and xen use the first one or two leafes (after info),
but in incompatible ways, so for these the signature *must* be checked
before using the info found there.

0x40000010 doesn't clash with anything as far I know, so we could
attempt to make that standard accross hypervisors.

cheers,
  Gerd
