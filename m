Return-Path: <linux-kernel-owner+w=401wt.eu-S1756927AbYESQ5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbYESQ5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 12:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbYESQ5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 12:57:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:60462 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbYESQ5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 12:57:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,510,1204531200"; 
   d="scan'208";a="566255816"
Date: Mon, 19 May 2008 09:57:35 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
       Suresh Siddha <suresh.b.siddha@intel.com>, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, andi@firstfloor.org, roland@redhat.com,
       drepper@redhat.com, Hongjiu.lu@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, rmk+lkml@arm.linux.org.uk, dan@debian.org,
       asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
Message-ID: <20080519165735.GC30034@linux-os.sc.intel.com>
References: <20080513011030.GA31448@linux-os.sc.intel.com> <18477.35703.679574.760417@harpo.it.uu.se> <20080518013416.GB30034@linux-os.sc.intel.com> <18481.37905.297556.288317@harpo.it.uu.se> <4831AACD.8030607@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4831AACD.8030607@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 09:29:01AM -0700, H. Peter Anvin wrote:
> Mikael Pettersson wrote:
> >
> >My problem with the OSXAVE flag is that it's a very indirect way of
> >communicating the layout of sigframes and sigcontexts. These structures
> >should, if at all possible, be self-describing. A single flag bit in
> >the sigcontext could handle both structures (since a sigframe always
> >includes a sigcontext).
> >
> 
> It's also wrong, since OSXSAVE indicates that the CPU can do it, not 
> that the kernel can.

OSXSAVE indicates the OS support and XSAVE indicates the cpu support.

> >>>struct _fpstate has a 'magic' field which distinguishes x87-only
> >>>from x87+FXSR structs. Could that field also be used to indicate XSAVE?
> >>I don't think we can use the existing 'magic' field.
> >
> >Hmm, right now it seems this field has a de-facto ABI of being
> >either 0xffff (plain) or 0x0000 (fxsr). Using other values would
> >confuse at least one application I know of. Sad.
> >
> 
> Well, arguably it is the right thing to use since we're talking about a 
> new format.  The difference is that the new format *does* extend 
> backwards to match the old format.

There might be some old applications, which just care about FP/SSE and
just check for  0xffff (plain) or 0x0000 (fxsr). We should extend this
in a backward compatible manner.

> >>But we can
> >>use some what similar magic, if the fxsave/fxrstor give away
> >>some of the fields at the end of fxsave image (today it is reserved
> >>and ignored during fxsave/fxrstor) for software use.
> >>We can then use these fields at the end of fpstate, to indicate the 
> >>presence of
> >>xstate. But this requires some architecture changes like giving
> >>away this space for SW use. We can take this to architects and
> >>see what they think.
> >
> >If the HW doesn't store anything valuable there, we could store
> >SW flags/cookies there on signal delivery, and clear them before
> >fxrstor (unless the HW is known to ignore those fields).
> >But it depends on how forgiving the HW is.
> 
> All we need is a single field -- a single byte -- reserved indefinitely 
> for software use.  Existing FXSAVE kernels will have set it to zero.
> 
> There might be fields the existing FXSAVE format which can be equally 
> abused, even.  I will do some looking.

All the reserved fields at the end of fxsave format are zeroed and
presented as such to the user. If HW makes some of these fields SW available,
then we can use those (will check). If there is any scope with the
existing format it self, that will be much better.

thanks,
suresh
