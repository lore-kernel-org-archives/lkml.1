Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbYI0AaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbYI0AaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 20:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbYI0AaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 20:30:09 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:57495 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752162AbYI0AaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 20:30:07 -0400
Subject: Re: Use CPUID to communicate with the hypervisor.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Zach Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>,
       "Jun.Nakajima@Intel.Com" <Jun.Nakajima@Intel.Com>
In-Reply-To: <48DD799C.3070706@zytor.com>
References: <1222472815.29886.43.camel@alok-dev1>
	 <48DD799C.3070706@zytor.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Fri, 26 Sep 2008 17:30:03 -0700
Message-Id: <1222475403.29886.57.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Thanks for the comments, please find my replies below.

On Fri, 2008-09-26 at 17:09 -0700, H. Peter Anvin wrote:
> Alok Kataria wrote:

> >
> > Leaf 0x40000000, Hypervisor CPUID information
> > # EAX: The maximum input value for hypervisor CPUID info (0x40000010).
> > # EBX, ECX, EDX: Hypervisor vendor ID signature. E.g. "VMwareVMware"
> >
> 
> This is great, obviously... although we'll have to deal with legacy
> methods for a while if not indefinitely (just as we have to for
> pre-CPUID processors).

Ok, do you think we should keep those (legacy) interfaces separate so
that they can be phased out whenever the time is right. 

> 
> >
> > +static void __init detect_hypervisor(void)
> > +{
> > +     if (cpu_has_hypervisor) {
> > +             unsigned int eax, ebx, ecx, edx;
> > +             char hyper_vendor_id[13];
> > +
> > +             cpuid(HYPERVISOR_INFO_LEAF, &eax, &ebx, &ecx, &edx);
> > +             memcpy(hyper_vendor_id + 0, &ebx, 4);
> > +             memcpy(hyper_vendor_id + 4, &ecx, 4);
> > +             memcpy(hyper_vendor_id + 8, &edx, 4);
> > +             hyper_vendor_id[12] = '\0';
> > +             printk(KERN_INFO "Hypervisor vendor id %s\n", hyper_vendor_id);
> > +     }
> > +}
> > +
> 
> This should be broken out into a separate file in cpu/*, because we
> *will* need to detect hypervisors by other means.
Ok, i will  do that.

> > --- a/arch/x86/kernel/tsc.c
> > +++ b/arch/x86/kernel/tsc.c
> > @@ -345,16 +345,38 @@ failed:
> >       return 0;
> >  }
> >
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
> > +
> 
> I would call this "vmware_tsc_freq()" because it is a VMWare-defined
> interface... you can't just poke at 0x40000010 and assume it is using
> the VMWare definition.

I would like to see this as a generic hypervisor way to get frequency
rather than a VMware specific thingy. 
> 
> In order for *that* to be safe, you'd have to have well-defined ranges
> for different virtualization vendors where each of them can define their
> own stuff.

My motivation for doing this is to have a standard across all the
hypervisor's. If all the different hypervisor guys can come to some
sought of consensus on the various hypervisor leafs that would help keep
this simple and a lot more maintainable.

> 
> > diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
> > index ee7cbb3..70ca49b 100644
> > --- a/include/asm-x86/processor.h
> > +++ b/include/asm-x86/processor.h
> > @@ -124,6 +124,27 @@ struct cpuinfo_x86 {
> >  #define X86_VENDOR_UNKNOWN   0xff
> >
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
> > + * This leaf gets timing information from the hypervisor.
> > + * EAX: (Virtual) TSC frequency in kHz.
> > + * EBX: (Virtual) Bus (local apic timer) frequency in kHz.
> > + * ECX, EDX: RESERVED
> > + */
> > +#define HYPERVISOR_TIMING_LEAF 0x40000010
> > +
> 
> <asm/processor.h> is the wrong place for this, and these constants
> should have CPUID_ in them to tell what they fundamentally are.
> 
> My preference would be for <asm/cpuid.h>, but otherwise
> <asm/cpufeature.h> wouldn't be entirely wrong.

Ok makes sense, will do that.

Thanks,
Alok
> 
>         -hpa

