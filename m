Return-Path: <linux-kernel-owner+w=401wt.eu-S933608AbZDJPeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933608AbZDJPeI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 11:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757265AbZDJPdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 11:33:42 -0400
Received: from gw.goop.org ([64.81.55.164]:50364 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754442AbZDJPdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 11:33:41 -0400
Message-ID: <49DF66D2.1010107@goop.org>
Date: Fri, 10 Apr 2009 08:33:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Luis Henriques <henrix@sapo.pt>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: Problem with kvm on -tip
References: <20090409210738.GA4566@hades.domain.com> <20090410115803.GL21506@elte.hu>
In-Reply-To: <20090410115803.GL21506@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Luis Henriques <henrix@sapo.pt> wrote:
>
>   
>> Hi,
>>
>> Since I am not sure if this problem has already been reported, here it goes.
>>
>> My log gets the following messages in -tip tree.  I don't know for 
>> how long this issue is around and whether the problem is on 
>> lockdep or on kvm.  After the first lockdep message, I get a huge 
>> amount of BUGs from kvm (which stop only when I kill kvm).  So, I 
>> believe issue is on kvm.
>>     
>
> Jeremy, have you considered (and tested) KVM when doing the MMU/CPU 
> notifier changes? It's these changes:
>   

I use kvm regularly with those changes in place, without seeing a 
problem.   KVM uses a different mechanism to be notified about context 
switches, so the context-switch hook changes should have no effect on 
it.  The preempt-lazy-mmu changes are near the mmu notifiers, but 
shouldn't interact any differently with them.  KVM also outright uses 
lazy mmu updates and the pte pvops, but not in any way that's unusual or 
be broken by these updates (as far as I can tell).

I would expect one of b8bcfe997e4, b407fc57b8 or 252a6bf2a to be the 
ones which would actually change preemption in a way which could cause 
problems (though the last just removes a preempt disable/enable pair 
added a few changes earlier).

Looking back at the lockdep messages, they're definitely not paths I 
would expect to be affected by these changes.  Did you identify them by 
bisection, or are you just trying to winnow out likely candidates?

> 224101e: x86/paravirt: finish change from lazy cpu to context switch start/end
>   
This just passes an extra parameter to arch_start_context_switch, but 
has no other code changes.

> b407fc5: x86/paravirt: flush pending mmu updates on context switch
>   
This shouldn't have any effect on a properly implemented pvops user.  I 
updated kvm along with the other pvops users when I made this change, 
and it appeared to be correct.
> 7fd7d83: x86/pvops: replace arch_enter_lazy_cpu_mode with arch_start_context_switch
This is a simple rename.

    J
