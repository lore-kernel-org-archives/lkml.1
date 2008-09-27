Return-Path: <linux-kernel-owner+w=401wt.eu-S1752863AbYI0DL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbYI0DL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 23:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbYI0DLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 23:11:21 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:41401 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751323AbYI0DLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 23:11:20 -0400
Subject: Re: Use CPUID to communicate with the hypervisor.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Zach Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>,
       "Jun.Nakajima@Intel.Com" <Jun.Nakajima@Intel.Com>,
       Tim Deegan <Tim.Deegan@citrix.com>
In-Reply-To: <48DD860C.50809@goop.org>
References: <1222472815.29886.43.camel@alok-dev1>  <48DD860C.50809@goop.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Fri, 26 Sep 2008 20:11:19 -0700
Message-Id: <1222485079.23825.13.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremy,

Please see my comments below.

On Fri, 2008-09-26 at 18:02 -0700, Jeremy Fitzhardinge wrote:
> Alok Kataria wrote:
> > From: Alok N Kataria <akataria@vmware.com>
> >
> > This patch proposes to use a cpuid interface to detect if we are running on an
> > hypervisor.
> > The discovery of a hypervisor is determined by bit 31 of CPUID#1_ECX, which is
> > defined to be "hypervisor present bit". For a VM, the bit is 1, otherwise it is
> > set to 0. This bit is not officially documented by either Intel/AMD yet, but
> > they plan to do so some time soon, in the meanwhile they have promised to keep
> > it reserved for virtualization.
> >
> > Also, Intel & AMD have reserved the cpuid levels 0x40000000 - 0x400000FF for
> > software use. Hypervisors can use these levels to provide an interface to pass
> > information from the hypervisor to the guest. This is similar to how we extract
> > information about a physical cpu by using cpuid.
> > XEN/KVM are already using the info leaf to get the hypervisor signature.
> >
> > VMware hardware version 7 defines some of these cpuid levels, below is a brief
> > description about those. These levels can be implemented by other hypervisors
> > too so that Linux has a standard way of communicating to any hypervisor.
> >
> > Leaf 0x40000000, Hypervisor CPUID information
> > # EAX: The maximum input value for hypervisor CPUID info (0x40000010).
> > # EBX, ECX, EDX: Hypervisor vendor ID signature. E.g. "VMwareVMware"
> >
> > Leaf 0x40000010,  Timing information.
> > # EAX: (Virtual) TSC frequency in kHz.
> > # EBX: (Virtual) Bus (local apic timer) frequency in kHz.
> > # ECX, EDX: RESERVED
> >
> 
> I'm sympathetic to the idea, but it seems a bit under-defined.
> 
> Are you leaving a gap between 0x40000000 and -10 for what?  Future
> extension?  Avoiding existing hypervisor-specific leaves?

Avoiding existing leaves,
Microsoft's Hypervisor  is using levels 0x40000000 - 0x40000005.
The first 2 are standard levels and the rest of them are Microsoft
hypervisors specific levels. So started with 0x40000010.

> 
> I think there's a move towards doing a scan for a signature, such as
> checking every 16 leaves after 0x40000000 for "a while" looking for
> interesting signatures, so that a hypervisor can support multiple ABIs
> at once.  Given this, it would be better to define a "Generic Hypervisor
> ABI" signature, and put all the related leaves together.

Hmm interesting, do you have any pointers to this ?
> 
> And then, rather than having a simple "maximum leaf", it would be better
> to have cap bits for each specific feature.  For example, how would the
> "RESERVED" registers in "Timing information" ever get used?  How would
> you know that they were no longer reserved, but now meaningful?

The unused (reserved) value is set to zero right now, whenever a need is
felt we can define a meaningful value and that can be used. 

> 
> That said, I'm a bit worried about the whole idea of having these kinds
> of timing parameters.  It does assume that they're constant for the
> whole life of the VM.  What if they change due to power management or
> migration?

For power management, the trend, even on native hardware, is toward a
constant rate TSC. So, I don't see this is a big concern; after all a
virtual cpu should be able to virtualize the TSC as constant rate even
when the underlying TSC is not (by trapping out).  And since this is
only true for older processors, this seems acceptable.  In other words,
my feeling is we should think of the cpu-scaling issues as a legacy
issue and not optimize the interface for it.

As far as live migration, for full-virt, we think that it should happen
invisibly to the guest.  So even if we move to a host with different TSC
frequency it should be the job of the hypervisor to still emulate the
old frequency. 

Thanks,
Alok

> 
>     J

