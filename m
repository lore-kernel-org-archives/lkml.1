Return-Path: <linux-kernel-owner+w=401wt.eu-S1761340AbYFFAjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761340AbYFFAjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 20:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbYFFAjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 20:39:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43700 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbYFFAjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 20:39:11 -0400
Message-ID: <4848849F.6000502@zytor.com>
Date: Thu, 05 Jun 2008 17:28:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Roland McGrath <roland@redhat.com>, Mikael Pettersson <mikpe@it.uu.se>,
       Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       drepper@redhat.com, Hongjiu.lu@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, rmk+lkml@arm.linux.org.uk, dan@debian.org,
       asit.k.mallick@intel.com
Subject: x86: xsave/xrstor support; ucontext_t extensions
References: <20080520175325.GE30034@linux-os.sc.intel.com> <4834BE39.2000904@zytor.com> <18485.13663.51624.694435@harpo.it.uu.se> <20080522205619.GB7998@linux-os.sc.intel.com> <4835DF64.6080104@zytor.com> <20080522212920.GC7998@linux-os.sc.intel.com> <4835E6F5.5010801@zytor.com> <20080523014855.GA18385@linux-os.sc.intel.com> <20080523021222.8E1A626FA24@magilla.localdomain> <483630AE.3050905@zytor.com> <20080523180928.GE18385@linux-os.sc.intel.com>
In-Reply-To: <20080523180928.GE18385@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for not getting back on this for so long.

I have looked at the XSAVE architecture, and it is pretty darn hideous, 
mostly because it doesn't describe itself in the absence of CPUID 
information.  Given that, it would have been much better if there had 
been separate invocations of XSAVE for each substate region.  On the 
other hand, normalizing to the current CPU format is probably desirable 
anyway.

I would like to make this proposal for the signal frames (again, flagged 
with a uc_flags bit for RT frames):

- The SW-reserved areas at the bottom of the FXSAVE region will be used 
as follows:
   - A magic number (M1)
   - A length pointer (L1), giving the length of the entire XSAVE region.

- At the end of the XSAVE region, i.e. at the offset given by the length 
pointer, we create a secondary structure looking something like this:

   - Magic number (M2)
   - Descriptor count (DC)
   - DC * <EBX, EAX> from CPUID leaf 0Dh
   - Possibly a checksum or CRC of this structure

Note that this tail structure will always be the same on a given kernel, 
so it can be pre-canned at boot time.  This tail structure serves two 
purposes:

   - It can be used to verify against truncation of the state.
     (I.e. if an XSAVE-unaware application tries to copy and save away
     a state and later restore it, but only copies the first 512 bytes
     and later just puts a pointer to it.)
   - It can be used to verify against an alien state (saved and restored
     from another CPU, or even just another kernel version with different
     support.)

If there is a mismatch, we can then take appropriate action:

   - No M1 or M2 signature, or L1 or DC are insane:
     -> Reinitialize any non-FXSAVE state.

   - M1, M2, L1, and DC make sense, but mismatch on DC or descriptor
     offsets:
     -> Do a region-by-region copy in of the state; reinitialize any
        regions not provided.

   - Mismatch on descriptor sizes:
     -> Consider that region corrupt and reinitialize?

The region-by-region copy could of course be used even in the same-CPU 
case, if there turns out to be a negible performance difference over 
whole-block copy.

Thoughts?

	-hpa

