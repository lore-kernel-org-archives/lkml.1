Return-Path: <linux-kernel-owner+w=401wt.eu-S932351AbYFFXRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351AbYFFXRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 19:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYFFXRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 19:17:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51190 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbYFFXRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 19:17:43 -0400
Message-ID: <4849C257.40603@zytor.com>
Date: Fri, 06 Jun 2008 16:03:51 -0700
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
Subject: Re: x86: xsave/xrstor support; ucontext_t extensions
References: <18485.13663.51624.694435@harpo.it.uu.se> <20080522205619.GB7998@linux-os.sc.intel.com> <4835DF64.6080104@zytor.com> <20080522212920.GC7998@linux-os.sc.intel.com> <4835E6F5.5010801@zytor.com> <20080523014855.GA18385@linux-os.sc.intel.com> <20080523021222.8E1A626FA24@magilla.localdomain> <483630AE.3050905@zytor.com> <20080523180928.GE18385@linux-os.sc.intel.com> <4848849F.6000502@zytor.com> <20080606201421.GE25114@linux-os.sc.intel.com>
In-Reply-To: <20080606201421.GE25114@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> I thought we had a closure on the previous thread. But no problem.
> It's better late than never.

I apologize.  The last two months have been exceptionally tough.

> xsave,xrstor are performance senstive instructions as they are used
> in process context switches. It doesn't have to describe itself and
> at any time, one can get all the xsave relevant layout information using
> cpuid. And when needed, SW can always pass extra information with the
> xsave image.

Yes, the big problem with it is its monolithic nature (with no realistic 
alternate instruction.)

>>   - Magic number (M2)
> 
> As I mentioned earlier, we can avoid this magic number, by including
> a pointer (which points to start of the fp and xstate on stack) along with M1. 

As I mentioned before, this introduces a very different constraint, 
which is a really bad precedent; data shouldn't be dependent on its own 
location.

> This will catch any one copying the FP state of the frame but not aware of
> Xstate.
> 
>>   - Descriptor count (DC)
>>   - DC * <EBX, EAX> from CPUID leaf 0Dh
> 
> As you mentioned, this doesn't change after a kernel boot. So do we really
> need to save this static information on every signal? (also please see below
> about the compaction).

I think given the compaction constraint we're okay with the bitmap plus 
length of the area.

>>   - Possibly a checksum or CRC of this structure
>>
>> Note that this tail structure will always be the same on a given kernel, 
>> so it can be pre-canned at boot time.  This tail structure serves two 
>> purposes:
>>
>>   - It can be used to verify against truncation of the state.
>>     (I.e. if an XSAVE-unaware application tries to copy and save away
>>     a state and later restore it, but only copies the first 512 bytes
>>     and later just puts a pointer to it.)
> 
> As I mentioned above, pointer along with M1 should be enough to catch this?

I think the pointer is a really really bad idea.  Even if we don't need 
the structure I think having a tail magic is the better alternative, and 
it's also really cheap to do since you have to have the length pointer 
anyway.

>>   - It can be used to verify against an alien state (saved and restored
>>     from another CPU, or even just another kernel version with different
>>     support.)
> 
> Though the xsave layout is extendable, save area is not
> compacted if some features are not supported by processor and/or
> system software. This is documented in Vol 2b under "xsave"
> instruction.

Ah, you're right, my bad.  That does make the problem substantially 
simpler (I somehow read only the second half of the and/or clause, but 
it's all there.)  So, OK, no need for descriptors (he says, as he waits 
for the architectural shoe to drop, especially in a multivendor 
environment.)

> Given that the descriptor offsets don't change, we can
> achieve the same thing with a bit mask representing the state in
> the xsave layout. xrstor with the approriate bit masks will automatically
> restore/init the state.

Agreed.

>>   - Mismatch on descriptor sizes:
>>     -> Consider that region corrupt and reinitialize?
>>
>> The region-by-region copy could of course be used even in the same-CPU 
>> case, if there turns out to be a negible performance difference over 
>> whole-block copy.
> 
> Today in 64bit, we directly do fxsave/fxrstor in and out of user-space
> for signal handlers. I would like to retain this behavior as much as possible
> with xsave/xrstor aswell (and at the same time, provide as much information
> as possible for the user to interpret the signal frame). Bit mask representing
> the state saved in the xsave image, M1, length and some cookie (pointer along
> with M1) to detect the image truncation can achieve this. Isn't it?

If the state is complete, which it of course will be something like 
99.9999% of the time, then doing XRSTOR from user space should work just 
fine.  The case of having to stitch up state is clearly an exceptional 
case, which is not at all performance critical in any way.

	-hpa
