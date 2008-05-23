Return-Path: <linux-kernel-owner+w=401wt.eu-S1753684AbYEWRF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbYEWRF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 13:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYEWRFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 13:05:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45122 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbYEWRFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 13:05:16 -0400
Message-ID: <4836F77C.309@zytor.com>
Date: Fri, 23 May 2008 09:57:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
       Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
       mingo@elte.hu, tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, drepper@redhat.com, Hongjiu.lu@intel.com,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       rmk+lkml@arm.linux.org.uk, dan@debian.org, asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
References: <18482.53246.642835.894623@harpo.it.uu.se>	<4832E705.2010900@zytor.com>	<18482.60491.764019.292031@harpo.it.uu.se>	<20080520175325.GE30034@linux-os.sc.intel.com>	<4834BE39.2000904@zytor.com>	<18485.13663.51624.694435@harpo.it.uu.se>	<20080522205619.GB7998@linux-os.sc.intel.com>	<4835DF64.6080104@zytor.com>	<18485.62848.335125.152538@harpo.it.uu.se>	<483610DA.7010606@zytor.com>	<20080523004206.GD7998@linux-os.sc.intel.com> <20080523013353.7FBB026FA24@magilla.localdomain>
In-Reply-To: <20080523013353.7FBB026FA24@magilla.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
>> What I was doing in the RFC is: restore the state what ever that was
>> present and init the state that was not present in the stack frame.
> 
> That is consistent in spirit with the existing treatment of FPU data.
> That is, if the sigcontext.fpstate pointer is NULL, the thread's FPU
> state is reset to default.  (And despite what hpa said about being
> "supported", the facts in the code are that sigreturn just follows the
> sigcontext.fpstate pointer, whatever it is.  On 32-bit, the pointer is
> NULL in the context saved when the thread had not used the FPU, so
> modifying the sigcontext to include FP state when it didn't before
> requires putting in some user-chosen pointer.  There in fact may well be
> existing code that does user-level coroutine switching using sigreturn
> and relies on this, for all we know.)
> 

Okay.  Pretty much what it comes down to is that there is no ideal 
solution.  Thus, we're trying to explore the potential tradeoffs.  The 
scenario you describe above will crash horribly for a non-FXSAVE aware 
application running on an FXSAVE kernel.

Either way, there has been a long time since, and new bad applications 
have obviously emerged, partially "assisted" by our propensity to not 
document, and the deep gulf between our kernel and userspace developers.

Let's try another strawman on for size:

- It is clear it is desirable not just for the frame itself but for the 
fpstate to be self-describing.

- Thus, let's put a magic cookie in one of the reserved fields at the 
end of the FXSAVE region, and make sure it is long enough to be unlikely 
to pop up randomly; as well as another magic cookie outside the FXSAVE 
region.

- The signal delivery code will write the cookie (or zero, for !XSAVE) 
regardless of any crap ptrace might have written into it.

- We will ALSO set bit 0 in uc_flags for RT sigframes as an additional 
assurance.

- We will introduce at least a 32-bit field for future use, to be 
written unconditionally zero for now.  We don't want to have to go 
through this particular torture yet again.

- The XSAVE state beyond the FXSAVE region needs to be self-describing. 
  This may mean adding information not provided by the hardware. 
Furthermore, it must be possible for userspace to know the length of the 
frame, even if it doesn't understand its detailed contents.


None of this is foolproof on older kernels -- there simply *IS* no 
option for older kernels that is 100% guaranteed, thanks to various 
assumptions made and design decisions taken over the years.  There are a 
couple of failure scenarious here:

- XSAVE-aware application running on pre-XSAVE kernel:

   Such an application will be aware that the XSAVE information may not
   exist, but needs to know (with high probability) that it isn't
   present.  We have CPUID.OSXSAVE, the uc_flags bit, and the magic
   cookie to help here.  ptrace can introduce the magic cookie falsely
   into the state, but ptrace can introduce all kinds of failures;
   either way they would (probablistically) not see the *second*
   cookie.

   The fact that 64-bit kernels don't clear the unused fields is of
   less concern, since 64-bit kernels get the uc_flags field.

- Pre-XSAVE application running on XSAVE kernel with XSAVE enabled:

   Here we have the potential for all kinds of corrupt state, including
   userspace trying to save away the state and load it later, not
   knowing the proper size of it.  Worse, some sick person might try to
   save and restore state from different hosts, with potential for
   all kinds of mayhem.

   The saved state, if copied from the original, would contain the first
   cookie but not the second cookie.

   Again, the use of two cookies here adds some amount of assurance;
   but that again amounts to probabilistic failure detection.  However,
   I personally don't see any way to avoid that scenario at all.

	-hpa
