Return-Path: <linux-kernel-owner+w=401wt.eu-S932392AbYFFUOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392AbYFFUOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 16:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759007AbYFFUOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 16:14:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:21469 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758975AbYFFUOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 16:14:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,602,1204531200"; 
   d="scan'208";a="257319955"
Date: Fri, 6 Jun 2008 13:14:21 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Roland McGrath <roland@redhat.com>, Mikael Pettersson <mikpe@it.uu.se>,
       Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       drepper@redhat.com, Hongjiu.lu@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, rmk+lkml@arm.linux.org.uk, dan@debian.org,
       asit.k.mallick@intel.com
Subject: Re: x86: xsave/xrstor support; ucontext_t extensions
Message-ID: <20080606201421.GE25114@linux-os.sc.intel.com>
References: <18485.13663.51624.694435@harpo.it.uu.se> <20080522205619.GB7998@linux-os.sc.intel.com> <4835DF64.6080104@zytor.com> <20080522212920.GC7998@linux-os.sc.intel.com> <4835E6F5.5010801@zytor.com> <20080523014855.GA18385@linux-os.sc.intel.com> <20080523021222.8E1A626FA24@magilla.localdomain> <483630AE.3050905@zytor.com> <20080523180928.GE18385@linux-os.sc.intel.com> <4848849F.6000502@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4848849F.6000502@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2008 at 05:28:15PM -0700, H. Peter Anvin wrote:
> Sorry for not getting back on this for so long.

I thought we had a closure on the previous thread. But no problem.
It's better late than never.

> I have looked at the XSAVE architecture, and it is pretty darn hideous, 
> mostly because it doesn't describe itself in the absence of CPUID 
> information.

xsave,xrstor are performance senstive instructions as they are used
in process context switches. It doesn't have to describe itself and
at any time, one can get all the xsave relevant layout information using
cpuid. And when needed, SW can always pass extra information with the
xsave image.

> Given that, it would have been much better if there had 
> been separate invocations of XSAVE for each substate region.

It's primarily designed for context switch handling, with
fxsave's interoperability in mind. Even though the substates are
laidout one after another, xsave/xrstor can operate on individual
states based on the edx:eax mask.

Each substate will probably also have different instructions to
save/restore/init their substate.

> On the 
> other hand, normalizing to the current CPU format is probably desirable 
> anyway.

yes.

> I would like to make this proposal for the signal frames (again, flagged 
> with a uc_flags bit for RT frames):
> 
> - The SW-reserved areas at the bottom of the FXSAVE region will be used 
> as follows:
>   - A magic number (M1)
>   - A length pointer (L1), giving the length of the entire XSAVE region.

As previously agreed.

> - At the end of the XSAVE region, i.e. at the offset given by the length 
> pointer, we create a secondary structure looking something like this:
> 
>   - Magic number (M2)

As I mentioned earlier, we can avoid this magic number, by including
a pointer (which points to start of the fp and xstate on stack) along with M1. 

This will catch any one copying the FP state of the frame but not aware of
Xstate.

>   - Descriptor count (DC)
>   - DC * <EBX, EAX> from CPUID leaf 0Dh

As you mentioned, this doesn't change after a kernel boot. So do we really
need to save this static information on every signal? (also please see below
about the compaction).

>   - Possibly a checksum or CRC of this structure
> 
> Note that this tail structure will always be the same on a given kernel, 
> so it can be pre-canned at boot time.  This tail structure serves two 
> purposes:
> 
>   - It can be used to verify against truncation of the state.
>     (I.e. if an XSAVE-unaware application tries to copy and save away
>     a state and later restore it, but only copies the first 512 bytes
>     and later just puts a pointer to it.)

As I mentioned above, pointer along with M1 should be enough to catch this?

>   - It can be used to verify against an alien state (saved and restored
>     from another CPU, or even just another kernel version with different
>     support.)

Though the xsave layout is extendable, save area is not
compacted if some features are not supported by processor and/or
system software. This is documented in Vol 2b under "xsave"
instruction.

In my RFC, we had the bit mask also saved in the SW-reserved area,
which represents the extended state saved in the signal frame.
This is in addition to the bit mask represeted by the xstate_bv
in the header. xstate_bv indicates the current status (init/non-init)
of the sub-states for the bit mask saved in the SW-reserved area.

While restoring, kernel can also use the same bit mask in SW area to restore
the state and init the other state not referred by the bit mask.

> If there is a mismatch, we can then take appropriate action:
> 
>   - No M1 or M2 signature, or L1 or DC are insane:
>     -> Reinitialize any non-FXSAVE state.
> 
>   - M1, M2, L1, and DC make sense, but mismatch on DC or descriptor
>     offsets:
>     -> Do a region-by-region copy in of the state; reinitialize any
>        regions not provided.

Given that the descriptor offsets don't change, we can
achieve the same thing with a bit mask representing the state in
the xsave layout. xrstor with the approriate bit masks will automatically
restore/init the state.

>   - Mismatch on descriptor sizes:
>     -> Consider that region corrupt and reinitialize?
> 
> The region-by-region copy could of course be used even in the same-CPU 
> case, if there turns out to be a negible performance difference over 
> whole-block copy.

Today in 64bit, we directly do fxsave/fxrstor in and out of user-space
for signal handlers. I would like to retain this behavior as much as possible
with xsave/xrstor aswell (and at the same time, provide as much information
as possible for the user to interpret the signal frame). Bit mask representing
the state saved in the xsave image, M1, length and some cookie (pointer along
with M1) to detect the image truncation can achieve this. Isn't it?

thanks,
suresh
