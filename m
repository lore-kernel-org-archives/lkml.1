Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbYJAROU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbYJAROU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 13:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbYJAROF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 13:14:05 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:49846 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753274AbYJAROD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 13:14:03 -0400
Subject: [RFC] CPUID usage for interaction between Hypervisors and Linux.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Jeremy Fitzhardinge <jeremy@goop.org>, "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Nakajima, Jun" <jun.nakajima@intel.com>, Dan Hecht <dhecht@vmware.com>,
       Zachary Amsden <zach@vmware.com>,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Content-Type: text/plain
Organization: VMware INC.
Date: Wed, 01 Oct 2008 10:14:02 -0700
Message-Id: <1222881242.9381.17.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please find below the proposal for the generic use of cpuid space
allotted for hypervisors. Apart from this cpuid space another thing
worth noting would be that, Intel & AMD reserve the MSRs from 0x40000000
- 0x400000FF for software use. Though the proposal doesn't talk about
MSR's right now, we should be aware of these reservations as we may want
to extend the way we use CPUID to MSR usage as well.

While we are at it, we also think we should form a group which has at
least one person representing each of the hypervisors interested in
generalizing the hypervisor CPUID space for Linux guest OS. This group
will be informed whenever a new CPUID leaf from the generic space is to
be used. This would help avoid any duplicate definitions for a CPUID
semantic by two different hypervisors. I think most of the people are
subscribed to LKML or the virtualization lists and we should use these
lists as a platform to decide on things. 

Thanks,
Alok

---

Hypervisor CPUID Interface Proposal
-----------------------------------

Intel & AMD have reserved cpuid levels 0x40000000 - 0x400000FF for
software use.  Hypervisors can use these levels to provide an interface
to pass information from the hypervisor to the guest running inside a
virtual machine.

This proposal defines a standard framework for the way in which the
Linux and hypervisor communities incrementally define this CPUID space.

(This proposal may be adopted by other guest OSes.  However, that is not
a requirement because a hypervisor can expose a different CPUID
interface depending on the guest OS type that is specified by the VM
configuration.)

Hypervisor Present Bit:
        Bit 31 of ECX of CPUID leaf 0x1.

        This bit has been reserved by Intel & AMD for use by
        hypervisors, and indicates the presence of a hypervisor.

        Virtual CPU's (hypervisors) set this bit to 1 and physical CPU's
        (all existing and future cpu's) set this bit to zero.  This bit
	can be probed by the guest software to detect whether they are
	running inside a virtual machine.

Hypervisor CPUID Information Leaf:
        Leaf 0x40000000.

        This leaf returns the CPUID leaf range supported by the
        hypervisor and the hypervisor vendor signature.

        # EAX: The maximum input value for CPUID supported by the hypervisor.
        # EBX, ECX, EDX: Hypervisor vendor ID signature.

Hypervisor Specific Leaves:
        Leaf range 0x40000001 - 0x4000000F.

        These cpuid leaves are reserved as hypervisor specific leaves.
        The semantics of these 15 leaves depend on the signature read
        from the "Hypervisor Information Leaf".

Generic Leaves:
        Leaf range 0x40000010 - 0x4000000FF.

        The semantics of these leaves are consistent across all
        hypervisors.  This allows the guest kernel to probe and
        interpret these leaves without checking for a hypervisor
        signature.

        A hypervisor can indicate that a leaf or a leaf's field is
        unsupported by returning zero when that leaf or field is probed.

        To avoid the situation where multiple hypervisors attempt to define the
        semantics for the same leaf during development, we can partition
        the generic leaf space to allow each hypervisor to define a part
        of the generic space.

        For instance:
          VMware could define 0x4000001X
          Xen could define 0x4000002X
          KVM could define 0x4000003X
	  and so on...

        Note that hypervisors can implement any leaves that have been
        defined in the generic leaf space whenever common features can
        be found.  For example, VMware hypervisors can implement leafs
        that have been defined in the KVM area 0x4000003X and vice
        versa.

        The kernel can detect the support for a generic field inside 
        leaf 0x400000XY using the following algorithm:

		1.  Get EAX from Leaf 0x400000000, Hypervisor CPUID information.
		    EAX returns the maximum input value for the hypervisor CPUID
		    space.

		    If EAX < 0x400000XY, then the field is not available.

		2.  Else, extract the field from the target Leaf 0x400000XY 
                    by doing cpuid(0x400000XY).

		    If (field == 0), this feature is unsupported/unimplemented
                    by the hypervisor.  The kernel should handle this case 
                    gracefully so that a hypervisor is never required to 
                    support or implement any particular generic leaf.

--------------------------------------------------------------------------------

Definition of the Generic CPUID space.
        Leaf 0x40000010, Timing Information.

        VMware has defined the first generic leaf to provide timing
        information.  This leaf returns the current TSC frequency and
        current Bus frequency in kHz.

        # EAX: (Virtual) TSC frequency in kHz.
        # EBX: (Virtual) Bus (local apic timer) frequency in kHz.
        # ECX, EDX: RESERVED (Per above, reserved fields are set to zero).

--------------------------------------------------------------------------------

Written By,
	Alok N Kataria <akataria@vmware.com>
	Dan Hecht <dhecht@vmware.com>
Inputs from,
	Jun Nakajima <jun.nakajima@intel.com>


