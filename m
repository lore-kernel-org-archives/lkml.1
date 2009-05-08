Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbZEHTDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbZEHTDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 15:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764106AbZEHTDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 15:03:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35899 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757789AbZEHTDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 15:03:21 -0400
Message-ID: <4A0481C2.3070306@redhat.com>
Date: Fri, 08 May 2009 22:02:26 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Anthony Liguori <anthony@codemonkey.ws>, paulmck@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <20090506160712.GW3036@sequoia.sous-sol.org> <4A031471.7000406@novell.com> <20090507233503.GA9103@amt.cnet> <4A03E644.5000103@redhat.com> <20090508104228.GD3011@amt.cnet> <4A0428FC.8080304@novell.com> <20090508153320.GB8522@amt.cnet>
In-Reply-To: <20090508153320.GB8522@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcelo Tosatti wrote:
> On Fri, May 08, 2009 at 08:43:40AM -0400, Gregory Haskins wrote:
>   
>> The problem is the exit time in of itself isnt all that interesting to
>> me.  What I am interested in measuring is how long it takes KVM to
>> process the request and realize that I want to execute function "X". 
>> Ultimately that is what matters in terms of execution latency and is
>> thus the more interesting data.  I think the exit time is possibly an
>> interesting 5th data point, but its more of a side-bar IMO.   In any
>> case, I suspect that both exits will be approximately the same at the
>> VT/SVM level.
>>
>> OTOH: If there is a patch out there to improve KVMs code (say
>> specifically the PIO handling logic), that is fair-game here and we
>> should benchmark it.  For instance, if you have ideas on ways to improve
>> the find_pio_dev performance, etc....   
>>     
>
> <guess mode on>
>
> One easy thing to try is to cache the last successful lookup on a
> pointer, to improve patterns where there's "device locality" (like
> nullio test).
>   

We should do that everywhere, memory slots, pio slots, etc.  Or even 
keep statistics on accesses and sort by that.

> <guess mode off>
>
>   

I'd leave it on if I were you.

>> One item may be to replace the kvm->lock on the bus scan with an RCU
>> or something.... (though PIOs are very frequent and the constant
>> re-entry to an an RCU read-side CS may effectively cause a perpetual
>> grace-period and may be too prohibitive). CC'ing pmck.
>>     
>
> Yes, locking improvements are needed there badly (think for eg the cache
> bouncing of kvm->lock _and_ bouncing of kvm->slots_lock on 4-way SMP
> guests).
>   

There's no reason for kvm->lock on pio.  We should push the locking to 
devices.

I'm going to rename slots_lock as 
slots_lock_please_reimplement_me_using_rcu, this keeps coming up.

>> FWIW: the PIOoHCs were about 140ns slower than pure HC, so some of that
>> 140 can possibly be recouped.  I currently suspect the lock acquisition
>> in the iobus-scan is the bulk of that time, but that is admittedly a
>> guess.  The remaining 200-250ns is elsewhere in the PIO decode.
>>     
>
> vmcs_read is significantly expensive
> (http://www.mail-archive.com/kvm@vger.kernel.org/msg00840.html,
> likely that my measurements were foobar, Avi mentioned 50 cycles for
> vmcs_write).
>   

IIRC vmcs reads are pretty fast, and are being improved.

> See for eg how vmx.c reads VM_EXIT_INTR_INFO twice on every exit.
>   

Ugh.

> Also this one looks pretty bad for a 32-bit PAE guest (and you can 
> get away with the unconditional GUEST_CR3 read too).
>
>         /* Access CR3 don't cause VMExit in paging mode, so we need
>          * to sync with guest real CR3. */
>         if (enable_ept && is_paging(vcpu)) {
>                 vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
>                 ept_load_pdptrs(vcpu);
>         }
>
>   

We should use an accessor here just like with registers and segment 
registers.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

