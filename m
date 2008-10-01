Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbYJASFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbYJASFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 14:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbYJASE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 14:04:57 -0400
Received: from gw.goop.org ([64.81.55.164]:45265 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871AbYJASE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 14:04:56 -0400
Message-ID: <48E3BBC1.2050607@goop.org>
Date: Wed, 01 Oct 2008 11:04:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080919)
MIME-Version: 1.0
To: akataria@vmware.com
CC: "avi@redhat.com" <avi@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Nakajima, Jun" <jun.nakajima@intel.com>, Dan Hecht <dhecht@vmware.com>,
       Zachary Amsden <zach@vmware.com>,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [RFC] CPUID usage for interaction between Hypervisors and Linux.
References: <1222881242.9381.17.camel@alok-dev1>
In-Reply-To: <1222881242.9381.17.camel@alok-dev1>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> Hi,
>
> Please find below the proposal for the generic use of cpuid space
> allotted for hypervisors. Apart from this cpuid space another thing
> worth noting would be that, Intel & AMD reserve the MSRs from 0x40000000
> - 0x400000FF for software use. Though the proposal doesn't talk about
> MSR's right now, we should be aware of these reservations as we may want
> to extend the way we use CPUID to MSR usage as well.
>
> While we are at it, we also think we should form a group which has at
> least one person representing each of the hypervisors interested in
> generalizing the hypervisor CPUID space for Linux guest OS. This group
> will be informed whenever a new CPUID leaf from the generic space is to
> be used. This would help avoid any duplicate definitions for a CPUID
> semantic by two different hypervisors. I think most of the people are
> subscribed to LKML or the virtualization lists and we should use these
> lists as a platform to decide on things. 
>
> Thanks,
> Alok
>
> ---
>
> Hypervisor CPUID Interface Proposal
> -----------------------------------
>
> Intel & AMD have reserved cpuid levels 0x40000000 - 0x400000FF for
> software use.  Hypervisors can use these levels to provide an interface
> to pass information from the hypervisor to the guest running inside a
> virtual machine.
>
> This proposal defines a standard framework for the way in which the
> Linux and hypervisor communities incrementally define this CPUID space.
>
> (This proposal may be adopted by other guest OSes.  However, that is not
> a requirement because a hypervisor can expose a different CPUID
> interface depending on the guest OS type that is specified by the VM
> configuration.)
>
> Hypervisor Present Bit:
>         Bit 31 of ECX of CPUID leaf 0x1.
>
>         This bit has been reserved by Intel & AMD for use by
>         hypervisors, and indicates the presence of a hypervisor.
>
>         Virtual CPU's (hypervisors) set this bit to 1 and physical CPU's
>         (all existing and future cpu's) set this bit to zero.  This bit
> 	can be probed by the guest software to detect whether they are
> 	running inside a virtual machine.
>
> Hypervisor CPUID Information Leaf:
>         Leaf 0x40000000.
>
>         This leaf returns the CPUID leaf range supported by the
>         hypervisor and the hypervisor vendor signature.
>
>         # EAX: The maximum input value for CPUID supported by the hypervisor.
>         # EBX, ECX, EDX: Hypervisor vendor ID signature.
>
> Hypervisor Specific Leaves:
>         Leaf range 0x40000001 - 0x4000000F.
>
>         These cpuid leaves are reserved as hypervisor specific leaves.
>         The semantics of these 15 leaves depend on the signature read
>         from the "Hypervisor Information Leaf".
>
> Generic Leaves:
>         Leaf range 0x40000010 - 0x4000000FF.
>
>         The semantics of these leaves are consistent across all
>         hypervisors.  This allows the guest kernel to probe and
>         interpret these leaves without checking for a hypervisor
>         signature.
>
>         A hypervisor can indicate that a leaf or a leaf's field is
>         unsupported by returning zero when that leaf or field is probed.
>
>         To avoid the situation where multiple hypervisors attempt to define the
>         semantics for the same leaf during development, we can partition
>         the generic leaf space to allow each hypervisor to define a part
>         of the generic space.
>
>         For instance:
>           VMware could define 0x4000001X
>           Xen could define 0x4000002X
>           KVM could define 0x4000003X
> 	  and so on...
>   

No, we're not getting anywhere.  This is an outright broken idea.  The 
space is too small to be able to chop up in this way, and the number of 
vendors too large to be able to do it without having a central oversight.

The only way this can work is by having explicit positive identification 
of each group of leaves with a signature.  If there's a recognizable 
signature, then you can inspect the rest of the group; if not, then you 
can't.  That way, you can avoid any leaf usage which doesn't conform to 
this model, and you can also simultaneously support multiple hypervisor 
ABIs.  It also accommodates existing hypervisor use of this leaf space, 
even if they currently use a fixed location within it.

A concrete counter-proposal:

The space 0x40000000-0x400000ff is reserved for hypervisor usage.

This region is divided into 16 16-leaf blocks.  Each block has the 
structure:

0x400000x0:
    eax: max used leaf within the leaf block (max 0x400000xf)
    e[bcd]x: leaf block signature.  This may be a hypervisor-specific 
signature, or a generic signature, depending on the contents of the block

A guest may search for any supported Hypervisor ABIs by inspecting each 
leaf at 0x400000x0 for a known signature, and then may choose its mode 
of operation accordingly.  It must ignore any unknown signatures, and 
not touch any of the leaves within an unknown leaf block.

Hypervisor vendors who want to add a hypervisor-specific leaf block must 
choose a signature which is recognizably related to their or their 
hypervisor's name.

Signatures starting with "Generic" are reserved for generic leaf blocks.

A guest may scan leaf blocks to enumerate what hypervisor ABIs/hypercall 
interfaces are available to it.  It may mix and match any information 
from leaves it understands.  However, once it starts using a specific 
hypervisor ABI by making hypercalls or doing other operations with 
side-effects, it must commit to using that ABI exclusively (a specific 
hypervisor ABI may include the generic ABI by reference, however).

Correspondingly, a hypervisor must treat any cpuid accesses as 
side-effect free.

Definition of specific blocks:

Generic hypervisor leaf block:
  0x400000x0 signature is "GenericVMMIF" (or something)
  0x400000x1 tsc leaf as you've described

    J
