Return-Path: <linux-kernel-owner+w=401wt.eu-S1754267AbYJAVBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbYJAVBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 17:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbYJAVBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 17:01:23 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:47786 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753855AbYJAVBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 17:01:21 -0400
Subject: Re: [RFC] CPUID usage for interaction between Hypervisors and
	Linux.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "avi@redhat.com" <avi@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Daniel Hecht <dhecht@vmware.com>, Zach Amsden <zach@vmware.com>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
In-Reply-To: <48E3BBC1.2050607@goop.org>
References: <1222881242.9381.17.camel@alok-dev1> <48E3BBC1.2050607@goop.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Wed, 01 Oct 2008 14:01:18 -0700
Message-Id: <1222894878.9381.63.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-01 at 11:04 -0700, Jeremy Fitzhardinge wrote:

> No, we're not getting anywhere.  This is an outright broken idea.  The
> space is too small to be able to chop up in this way, and the number of
> vendors too large to be able to do it without having a central oversight.
> 
> The only way this can work is by having explicit positive identification
> of each group of leaves with a signature.  If there's a recognizable
> signature, then you can inspect the rest of the group; if not, then you
> can't.  That way, you can avoid any leaf usage which doesn't conform to
> this model, and you can also simultaneously support multiple hypervisor
> ABIs.  It also accommodates existing hypervisor use of this leaf space,
> even if they currently use a fixed location within it.
> 
> A concrete counter-proposal:
> 
> The space 0x40000000-0x400000ff is reserved for hypervisor usage.
> 
> This region is divided into 16 16-leaf blocks.  Each block has the
> structure:
> 
> 0x400000x0:
>     eax: max used leaf within the leaf block (max 0x400000xf)
>     e[bcd]x: leaf block signature.  This may be a hypervisor-specific
> signature, or a generic signature, depending on the contents of the block
> 
> A guest may search for any supported Hypervisor ABIs by inspecting each
> leaf at 0x400000x0 for a known signature, and then may choose its mode
> of operation accordingly.  It must ignore any unknown signatures, and
> not touch any of the leaves within an unknown leaf block.
> Hypervisor vendors who want to add a hypervisor-specific leaf block must
> choose a signature which is recognizably related to their or their
> hypervisor's name.
> 
> Signatures starting with "Generic" are reserved for generic leaf blocks.
> 
> A guest may scan leaf blocks to enumerate what hypervisor ABIs/hypercall
> interfaces are available to it.  It may mix and match any information
> from leaves it understands.  However, once it starts using a specific
> hypervisor ABI by making hypercalls or doing other operations with
> side-effects, it must commit to using that ABI exclusively (a specific
> hypervisor ABI may include the generic ABI by reference, however).
> 
> Correspondingly, a hypervisor must treat any cpuid accesses as
> side-effect free.
> 
> Definition of specific blocks:
> 
> Generic hypervisor leaf block:
>   0x400000x0 signature is "GenericVMMIF" (or something)
>   0x400000x1 tsc leaf as you've described
> 

I see following issues with this proposal,

1. Kernel complexity : Just thinking about the complexity that this will
put in the kernel to handle these multiple ABI signatures and scanning
all of these leaf block's is difficult to digest.

2. Divergence in the interface provided by the hypervisors  : 
	The reason we brought up a flat hierarchy is because we think we should
be moving towards a approach where the guest code doesn't diverge too
much when running under different hypervisors. That is the guest
essentially does the same thing if its running on say Xen or VMware.

This design IMO, will take us a step backward to  what we already have
seen with para virt ops. Each hypervisor (mostly) defines its own cpuid
block, the guest correspondingly needs to have code to handle each of
these cpuid blocks, with these blocks will mostly being exclusive.


3. Is their a need to do all this over engineering : 
	Aren't we over engineering a simple interface over here. The point is,
there are right now 256 cpuid leafs do we realistically think we are
ever going to exhaust all these leafs. We are really surprised to know
that people may think this space is small enough. It would be
interesting to know what all use you might want to put cpuid for.

Thanks,
Alok



>     J

