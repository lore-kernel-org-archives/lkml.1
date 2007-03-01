Return-Path: <linux-kernel-owner+w=401wt.eu-S964988AbXCALeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964988AbXCALeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 06:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964989AbXCALeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 06:34:21 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:59330 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964988AbXCALeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 06:34:19 -0500
Message-ID: <45E6BA3A.2040306@vmware.com>
Date: Thu, 01 Mar 2007 03:34:18 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Daniel Hecht <dhecht@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Bug in on_each_cpu?
References: <45E6AC1A.8050608@vmware.com> <20070301024524.c7c8ea1a.akpm@linux-foundation.org>
In-Reply-To: <20070301024524.c7c8ea1a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 01 Mar 2007 02:34:02 -0800 Zachary Amsden <zach@vmware.com> wrote:
>
>   
>> I think on_each_cpu has a serious bug now that hrtimers has been 
>> integrated.  Basically, there are many callsites of clock_was_set, none 
>> of which actually know the current interrupt state - enabled or 
>> disabled.  So they save and restore irqs, as they should.  But 
>> on_each_cpu does not do so, creating bugs in any function which calls 
>> these functions with interrupts disabled.
>>     
>
> on_each_cpu() calls smp_call_function().  It is a bug to call
> smp_call_function() with local interrupts disabled, hence it is a bug to
> call on_each_cpu() with local interrupts disabled.
>
> There is a WARN_ON() in smp_call_function() to catch this.
>   

Ok, I thought that might be the case.  We probably infinite looped in 
the interrupt handler because of bad state and thus missed the WARN_ON 
output.

> Why is it a bug?  Because there's a deadlock where this CPU is waiting for
> CPU A to take the IPI, but CPU A is waiting (with interrupts disabled) for
> this CPU to take an IPI.
>   

Then the bug is not in on_each_cpu().  It is in the usage of 
clock_was_set().  For example, look at do_settimeofday in kernel/timer.c:

        write_sequnlock_irqrestore(&xtime_lock, flags);

        /* signal hrtimers about time change */
        clock_was_set();

        return 0;

And timekeeping_resume has similar code (and called from a sysdev 
callback, so I don't know what the interrupt state should be ).  Either 
the write_sequnlock_irqrestore is redundant, and should be merely an 
write_sequnlock_irq, or the callsite is not prepared to handle enabling 
interrupts temporarily as must be done for on_each_cpu(), which is a 
pretty scary scenario.

What would be really, really nice would be to statically check all 
callsites that issue irq disables actually keep irqs disabled.  
Presumably, there was a reason they disabled irqs, and re-enabling them 
underneath their noses, even if it is to avoid a race, breaks the logic 
behind that reason.

Basically, it is just always a bug to re-enable interrupts from a caller 
which has disabled them.  Either there is no reason they needed to 
disable them in the first place, and it is just a performance issue, or 
they are updating some shared state used by the interrupt handler, which 
can then operate incorrectly, or they were taking some lock to prevent 
this, and the interrupt handler can then attempt to take a nested lock 
and hang forever.

In our case, the bug is easily worked around - we don't actually need to 
set the wallclock time here.  But there is a deeper fundamental issue 
which I think needs to be addressed.

Zach
