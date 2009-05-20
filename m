Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbZETQff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbZETQff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 12:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbZETQf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 12:35:28 -0400
Received: from claw.goop.org ([74.207.240.146]:58787 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811AbZETQf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 12:35:27 -0400
Message-ID: <4A14314E.7030406@goop.org>
Date: Wed, 20 May 2009 09:35:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jan Beulich <JBeulich@novell.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] Re: [GIT PULL] xen /proc/mtrr implementation
References: <4A0DCC11.10307@goop.org> <m1my9ex818.fsf@fess.ebiederm.org> <4A0DFF78.6000501@goop.org> <20090515202250.0f1218ef@jbarnes-g45> <m1iqk1k708.fsf@fess.ebiederm.org> <4A10EAC4.9070701@goop.org> <20090518085902.GE10687@elte.hu> <4A11A3F8.1010202@goop.org> <20090519095918.GA11790@elte.hu> <4A12A46A02000078000017E1@vpn.id2.novell.com> <20090519110837.GA10548@elte.hu>
In-Reply-To: <20090519110837.GA10548@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jan Beulich <JBeulich@novell.com> wrote:
>
>   
>>>>> Ingo Molnar <mingo@elte.hu> 19.05.09 11:59 >>>
>>>>>           
>>> Exactly what is 'bizarre' about using the API defined by the 
>>> _CPU_ already, without adding any ad-hoc hypecall? Catch the 
>>> dom0 WRMSRs, filter out the MTRR indices - that's it.
>>>       
>> But that is *not* the same as using the hypercalls: The hypercall 
>> tells Xen "Change all CPUs' MTRRs with the indicated index to the 
>> indicated value", while the MSR write says "Change the MTRR with 
>> the given index on the physical CPU the current virtual CPU 
>> happens to run on to the given value". [...]
>>     
>
> The change of MTRR's on _any_ of the guest CPUs in a dom0 context 
> should immediately be refected on all CPUs. Assymetric MTRR settings 
> are madness.
>
> ( And the thing is, changing MTRRs is fragile and racy on native 
>   Linux no matter what - even without any hypervisors - due to SMM 
>   contexts possibly relying on them etc. )
>
>   
>> [...] A write-base/write-mask pair may happen to get interrupted 
>> (preempted) by the hypervisor, and hence the two writes may happen 
>> on different pCPU-s. Teaching the hypervisor to (correctly!) guess 
>> what the guest meant in that situation isn't trivial, as then it 
>> needs to handle all possible situations (and it can never know 
>> whether Dom0 really intended to do something that may look 
>> bogus/inconsistent at the first glance). [...]
>>     
>
> None of this is a problem really if a sane approach is used: a 
> change to the MTRR state on dom0 is applied symmetrically on all 
> CPUs.
>
> Or, alternatively, the hypervisor can expose its own administrative 
> interface to manage MTRRs.
>
> There's no need to fuglify the Linux kernel for that.

I'm not sure what you mean by that, other than as a description of the 
current case.  The Xen MTRR hypercall:

   1. treats MTRR ranges as allocatable resources, and keep track of how
      many uses there are of each
   2. updates all physical cpus synchronously (ie, the MTRR is not
      presented as a property of dom0's virtual CPU, but as a
      system-wide resource)
   3. prevents guests from setting inconsistent or conflicting MTRRs

Mapping from MSR writes to this interface is moderately complex, because 
it requires a mapping from a low-semantic-content interface to a 
high-semantic-content interface.  It essentially requires parsing the 
MSR writes to map them back to the relatively high-level operations at 
the mtrr_ops interface and then present that to Xen.

There are at least a couple of secondary issues which arise from that 
approach:

    * mtrr/generic.c also has to do a number of other things like
      disabling caching, tlb flushes, etc.  That adds complexity because
      Xen guests are never allowed to globally disable caching, so we'd
      have to add additional filtering to remove those cr0 writes
    * As we've discussed, we'd need to make the mtrr writes implicitly
      change all cpus atomically, as the dom0 kernel can't see physical cpus


The net effect would be that we would be making a pile of apparently 
generic CPU operations (MSR writes, control register writes) actually 
feed a fairly complex parser, increasing the difference between the Xen 
and native cases even more.

mtrr/generic.c about 730 lines of fairly intricate arch-specific code.  
mtrr/xen.c is 120 lines of straightforward hypercalls.  The mtrr_ops 
interface and the Xen hypercall interface are a close semantic match, so 
there's very little glue code in there.


But that said, this a huge distraction, an unbelievable amount of noise 
for a fairly minor point.  We can live without these changes, and 
they're certainly easy enough to carry out of tree in the meantime.  If 
you can't live with these changes, then drop them and we'll work out 
something else.

    J
