Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbYI3AMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbYI3AMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 20:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbYI3AMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 20:12:05 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:43872 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752307AbYI3AME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 20:12:04 -0400
Subject: Re: Use CPUID to communicate with the hypervisor.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Nakajima, Jun" <jun.nakajima@intel.com>,
       Gerd Hoffmann <kraxel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Zach Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>
In-Reply-To: <48E1486C.3060306@goop.org>
References: <1222472815.29886.43.camel@alok-dev1>
	 <48E090B6.2080809@redhat.com> <1222710924.30247.21.camel@alok-dev1>
	 <48E1227B.9040809@redhat.com> <1222717085.30247.44.camel@alok-dev1>
	 <0B53E02A2965CE4F9ADB38B34501A3A15726E15A@orsmsx505.amr.corp.intel.com>
	 <48E1437D.7080606@zytor.com>  <48E1486C.3060306@goop.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 29 Sep 2008 17:12:03 -0700
Message-Id: <1222733523.30247.91.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-29 at 14:28 -0700, Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
> > Nakajima, Jun wrote:
> >>
> >> For example, we can set the following ranges so that so that each VMM
> >> vender can define and implement features avoiding conflicts:
> >> vmware to define 0x4000001X
> >> xen to define 0x4000002X
> >> kvm to define 0x4000003X
> >> ...
> >>
> >
> > Unless there is a central authority assigning these, "we" can do all
> > we want, enough people will not pay attention.
> >
> > Basically, there needs to be a standards document that describes the
> > architecture, *and* needs to either have universal buy-in with all the
> > vendors or imposed by an authority with enough clout to do so (Intel
> > might.)
> 
> I think using fixed offsets is unwise, since there's already contention
> for the same leaves. 

Sure, some leaves have been defined already, but it's not too late to
try to go the generic route for the remaining leaves.
The longer we wait to come to a consensus on generic leaves, the more
contention we will have.  So let's try to address it now.  

>  Making sure that each block of leaves (where a
> block is 16, 256 or some other number of leaves) is self-describing via
> ABI signatures is the only sane way to go.  There's still the issue of
> assigning ABI signatures to vendors, but that's 1) less of an issue, and
> 2) can be self-assigned with very low likelihood of collision.  That way
> a guest can scan that region of leaf space for ABI signatures it
> understand, and can pick and choose among what it finds (but not mix and
> match - that sounds like a course for disaster).
> 
> If we use such a scheme, we can 1) avoid any existing users of that
> space, 2) cleanly delimit a hypervisor-agnostic ABI portion of the leaf
> space, and 3) allow hypervisors to implement multiple ABIs at once.

I don't agree that this solution makes any difference OTOH, it just
complicates the situation.
Here is why....

1. This solution really bloats the kernel, below are few observations

i)  What happens if two ABI signature blocks define a cpuid leaf which
have similar semantics, how does the kernel handle this ?
ii) Also, think about a case where a hypervisor supports 2 such ABI
blocks - which have cpuid leafs with similar semantics - and decides to
implement one of those and not the other leaf. How does the kernel
handle this ?

I do understand that there are ways to handle this in the kernel but at
the cost of just making the kernel more and more complicated for such
corner cases.

2. Also as a side note, what you are proposing just breaks down the
problem in to sub-problems, i.e we still need to make sure that the
individual cpuid leafs in the "block of leaves" are still generic. Also
we may still have situations where hypervisor "A" wants to define a
subset of cpuid block X, hypervisor B had defined.

3. All in all, the end result of doing this would be that each
hypervisor defines its own signature block forgetting about what the
other hypervisor is doing. This is hardly generalizing this space.

Seriously, if we want to generalize this in the current situation, how
about doing this ? 

1. Have 0x40000000 as the hypervisor signature leaf.
2. Have 0x40000001-0x4000000F as the hypervisor specific leafs.
3. 0x40000010 - 0x400000FF as the generic space. 
Use the non-zero meaning defined semantics for this generic space. 

Thanks,
Alok

> 
>     J

