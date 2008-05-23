Return-Path: <linux-kernel-owner+w=401wt.eu-S932949AbYEWGCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949AbYEWGCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 02:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbYEWGCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 02:02:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59118 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765655AbYEWGCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 02:02:19 -0400
Message-ID: <48362FD0.9030104@zytor.com>
Date: Thu, 22 May 2008 19:45:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
       mingo@elte.hu, tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, roland@redhat.com, drepper@redhat.com,
       Hongjiu.lu@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, rmk+lkml@arm.linux.org.uk, dan@debian.org,
       asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
References: <18482.53246.642835.894623@harpo.it.uu.se> <4832E705.2010900@zytor.com> <18482.60491.764019.292031@harpo.it.uu.se> <20080520175325.GE30034@linux-os.sc.intel.com> <4834BE39.2000904@zytor.com> <18485.13663.51624.694435@harpo.it.uu.se> <20080522205619.GB7998@linux-os.sc.intel.com> <4835DF64.6080104@zytor.com> <20080522212920.GC7998@linux-os.sc.intel.com> <4835E6F5.5010801@zytor.com> <20080523014855.GA18385@linux-os.sc.intel.com>
In-Reply-To: <20080523014855.GA18385@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> On Thu, May 22, 2008 at 02:34:45PM -0700, H. Peter Anvin wrote:
>> Suresh Siddha wrote:
>>> can you please elaborate? even in presence of virtualization, appropriate
>>> cpuid bits need to be set/visible for application, for xsave/xrstor to work
>>> properly.
>>>
>> For many paravirtualization solutions, CPUID "leak" from the hypervisor. 
>>  The fact that CPUID cannot be disabled (made ring 0 only) is a major 
>> flaw in the architecture.
>>
>> Therefore, relying on CPUID is too dangerous.
> 
> hmm.. so the kernel needs to export all the cpuid info (that the kernel enables
> and supports) to the user through some mechanism then?

Not really.  Most of the CPUID information doesn't have a OS-dependent 
portion, but the parts that do cause problems (there are other issues, 
like the hypervisor wanting to limit the feature set available to the 
client, but there is no real solution to that, and certainly it would be 
out of scope for this discussion.)

> atleast in the xsave case, hypervisor can completely control the
> OSXSAVE flag. I am still not convinced whether I need to add prctl()
> to indicate the layout. If I have to add, then it should not just
> be about whether xsave information is included in _fpstate or not, it should also
> be about the whole cpuid information provided by the xsave architecture. Because
> the user potentially needs all that information, to make sense out of
> the data layout included in the extended state area.

Agreed that this information is needed, although it probably would be 
better to leave it in the frame itself; that way at least the rt frames 
would stand on their own.  I'm worried about using the reserved fields 
since they could be messed up by ptrace, but you could also argue that 
if you have the ability to trace the process you can do anything else to 
it; that way we could use a reserved field to signal the presence of the 
XSAVE information in the frame; I would hope that that XSAVE information 
would be self-describing (perhaps a linked list of blocks or a separate 
chain of descriptors.)

In other words, we know of a place to stash the presence flag for rt 
signal frames, the uc_flags field; we effectively need to find a place 
to stash the uc_flags field for the non-rt frame.

Michael, you wrote:

> Hmm, right now it seems this field has a de-facto ABI of being
> either 0xffff (plain) or 0x0000 (fxsr). Using other values would
> confuse at least one application I know of. Sad.

... could you share what application that is?  This otherwise would be 
ideal.

	-hpa
