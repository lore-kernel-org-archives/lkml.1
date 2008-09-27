Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbYI0BCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbYI0BCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 21:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbYI0BCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 21:02:09 -0400
Received: from gw.goop.org ([64.81.55.164]:58958 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbYI0BCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 21:02:08 -0400
Message-ID: <48DD860C.50809@goop.org>
Date: Fri, 26 Sep 2008 18:02:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>, avi@redhat.com,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>,
       Dan Hecht <dhecht@vmware.com>, Jun.Nakajima@Intel.Com,
       Tim Deegan <Tim.Deegan@citrix.com>
Subject: Re: Use CPUID to communicate with the hypervisor.
References: <1222472815.29886.43.camel@alok-dev1>
In-Reply-To: <1222472815.29886.43.camel@alok-dev1>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
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
> Leaf 0x40000010,  Timing information.
> # EAX: (Virtual) TSC frequency in kHz.
> # EBX: (Virtual) Bus (local apic timer) frequency in kHz.
> # ECX, EDX: RESERVED
>   

I'm sympathetic to the idea, but it seems a bit under-defined.

Are you leaving a gap between 0x40000000 and -10 for what?  Future
extension?  Avoiding existing hypervisor-specific leaves?

I think there's a move towards doing a scan for a signature, such as
checking every 16 leaves after 0x40000000 for "a while" looking for
interesting signatures, so that a hypervisor can support multiple ABIs
at once.  Given this, it would be better to define a "Generic Hypervisor
ABI" signature, and put all the related leaves together.

And then, rather than having a simple "maximum leaf", it would be better
to have cap bits for each specific feature.  For example, how would the
"RESERVED" registers in "Timing information" ever get used?  How would
you know that they were no longer reserved, but now meaningful?

That said, I'm a bit worried about the whole idea of having these kinds
of timing parameters.  It does assume that they're constant for the
whole life of the VM.  What if they change due to power management or
migration?

    J
