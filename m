Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbYI2Rzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbYI2Rzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 13:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbYI2Rzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 13:55:36 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:57082 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751377AbYI2Rzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 13:55:35 -0400
Subject: Re: Use CPUID to communicate with the hypervisor.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Zach Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>,
       "Jun.Nakajima@Intel.Com" <Jun.Nakajima@Intel.Com>
In-Reply-To: <48E090B6.2080809@redhat.com>
References: <1222472815.29886.43.camel@alok-dev1>
	 <48E090B6.2080809@redhat.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 29 Sep 2008 10:55:24 -0700
Message-Id: <1222710924.30247.21.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gerd,

On Mon, 2008-09-29 at 01:24 -0700, Gerd Hoffmann wrote:
>   Hi,
> 
> > +unsigned long hypervisor_tsc_freq(void)
> > +{
> > +     unsigned long tsc_khz;
> > +     unsigned int max_cpuid_leaf;
> > +
> > +     if (cpu_has_hypervisor) {
> > +             max_cpuid_leaf = cpuid_eax(HYPERVISOR_INFO_LEAF);
> > +             if (max_cpuid_leaf >= HYPERVISOR_TIMING_LEAF) {
> > +                     tsc_khz = cpuid_eax(HYPERVISOR_TIMING_LEAF);
> > +                     printk(KERN_INFO
> > +                             "TSC frequency read from hypervisor\n");
> > +                     return tsc_khz;
> > +             }
> > +     }
> > +     return 0;
> > +}
> 
> Shouldn't you check the hypervisor signature here?

Nope the whole idea of not checking the hypervisor signature is that we
should keep this interface generic. 
In the current code, before poking the TIMING_LEAF, we do check if the
maximum supported cpuid level is greater than that leaf. If it is we go
ahead and probe that cpuid leaf. 
Also one thing to remember is, that a hypervisor can decide to not
implement this level and just return "0" the kernel can then just ignore
that value. That's what we do currently in native_calibrate_tsc.

> 
> >  /*
> > + * Intel & AMD have reserved the cpuid levels 0x40000000 - 0x400000FF for
> > + * software use. Hypervisors can use these levels to provide an interface
> > + * to pass information from the hypervisor to the guest. This is similar
> > + * to how we extract information about a physical cpu by using cpuid.
> > + */
> > +
> > +/*
> > + * This CPUID leaf returns the information about the hypervisor.
> > + * EAX : maximum input value for CPUID supported by the hypervisor.
> > + * EBX, ECX, EDX : Hypervisor vendor ID signature. E.g. VMwareVMware.
> > + */
> > +#define HYPERVISOR_INFO_LEAF   0x40000000
> > +/*
> > + * This leaf gets timing information from the hypervisor.info.
> > + * EAX: (Virtual) TSC frequency in kHz.
> > + * EBX: (Virtual) Bus (local apic timer) frequency in kHz.
> > + * ECX, EDX: RESERVED
> > + */
> > +#define HYPERVISOR_TIMING_LEAF 0x40000010
> 
> Likewise, I think this should be HYPERVISOR_VMWARE_TIMING_LEAF.
Nope, lets do the "Or" part :)
> 
> Or we need some way to
>   (a) standardize hypervisor cpuid leafes (or parts of it) and
>   (b) handle sparsely filled cpuid info.
> 
Exactly.
Returning zero for the fields which are not supported by the hypervisor,
lets us do that. 
So for instance right now, VMware has defined 40000010 leaf, if either
kvm/xen think it could be useful they could just define that leaf to
return nonzero value and the kernel will start using it for them.
Likewise, if in future either kvm/xen come up with a need to define a
new CPUID leaf they can define the semantics for that leaf, and the
corresponding kernel side stuff. If VMware, think that this new leaf is
useful, we can then support that leaf in our hypervisor or return zero
otherwise.

> Right now both kvm and xen use the first one or two leafes (after info),
> but in incompatible ways, so for these the signature *must* be checked
> before using the info found there.

Hmm that's unfortunate, but we can have exceptions for these one of
cases and AFAIK these are only checked in the kvm/xen code path and not
in any generic code as of now, right ? 

btw, i could only find the semantics for 0x40000001 leaf in KVM's header
file but don't see Xen using that leaf, can you please point me which
leafs are you referring to here. 

> 
> 0x40000010 doesn't clash with anything as far I know, so we could
> attempt to make that standard accross hypervisors.
Yep.

Thanks,
Alok
> 
> cheers,
>   Gerd

