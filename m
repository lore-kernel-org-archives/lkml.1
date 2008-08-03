Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317AbYHCGpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbYHCGpO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 02:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbYHCGpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 02:45:01 -0400
Received: from gw.goop.org ([64.81.55.164]:58095 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbYHCGpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 02:45:00 -0400
Message-ID: <489553E5.4020908@goop.org>
Date: Sat, 02 Aug 2008 23:44:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: Restore the proper NR_IRQS define so larger systems
 work.
References: <1217642575-22727-1-git-send-email-yhlu.kernel@gmail.com>	 <m18wveacu6.fsf@frodo.ebiederm.org> <86802c440808022258x1198093x7d21274b82e75f4b@mail.gmail.com>
In-Reply-To: <86802c440808022258x1198093x7d21274b82e75f4b@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Sat, Aug 2, 2008 at 10:26 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>   
>> As pointed out and tracked by Yinghai Lu <yhlu.kernel@gmail.com>:
>>
>> Dhaval Giani got:
>> kernel BUG at arch/x86/kernel/io_apic_64.c:357!
>> invalid opcode: 0000 [1] SMP
>> CPU 24
>> ...
>>
>> his system (x3950) has 8 ioapic, irq > 256
>>
>> This was caused by:
>>        commit 9b7dc567d03d74a1fbae84e88949b6a60d922d82
>>        Author: Thomas Gleixner <tglx@linutronix.de>
>>        Date:   Fri May 2 20:10:09 2008 +0200
>>
>>           x86: unify interrupt vector defines
>>
>>           The interrupt vector defines are copied 4 times around with minimal
>>           differences. Move them all into asm-x86/irq_vectors.h
>>
>> It appears that Thomas did not notice that x86_64 does something
>> completely different when he merge irq_vectors.h
>>
>> We can solve this for 2.6.27 by simply reintroducing the old heuristic
>> for setting NR_IRQS on x86_64 to a usable value, which trivially removes
>> the regression.
>>
>> Long term it would be nice to harmonize the handling of ioapic interrupts
>> of x86_32 and x86_64 so we don't have this kind of confusion.
>>
>> Dhaval Giani <dhaval@linux.vnet.ibm.com> tested an earlier version of
>> this patch by YH which confirms simply increasing NR_IRQS fixes the
>> problem.
>>
>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>> ---
>>  include/asm-x86/irq_vectors.h |   10 +++++++++-
>>  1 files changed, 9 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/asm-x86/irq_vectors.h b/include/asm-x86/irq_vectors.h
>> index 90b1d1f..a13eb6c 100644
>> --- a/include/asm-x86/irq_vectors.h
>> +++ b/include/asm-x86/irq_vectors.h
>> @@ -109,7 +109,15 @@
>>  #define LAST_VM86_IRQ          15
>>  #define invalid_vm86_irq(irq)  ((irq) < 3 || (irq) > 15)
>>
>> -#if !defined(CONFIG_X86_VOYAGER)
>> +#ifdef CONFIG_X86_64
>> +# if NR_CPUS < MAX_IO_APICS
>> +#  define NR_IRQS (NR_VECTORS + (32 * NR_CPUS))
>> +# else
>> +#  define NR_IRQS (NR_VECTORS + (32 * MAX_IO_APICS ))
>> +# endif
>> +# define NR_IRQ_VECTORS NR_IRQS
>> +
>> +#elif !defined(CONFIG_X86_VOYAGER)
>>
>>  # if defined(CONFIG_X86_IO_APIC) || defined(CONFIG_PARAVIRT) || defined(CONFIG_X86_VISWS)
>>
>>     
>
> what should xen pv 64 get for NR_IRQS?
>   

Much the same as usual; perhaps a bit lower.  16/CPU would probably be 
ample.

But given that the kernel also needs to be able to boot native properly, 
just choosing the normal number would be best.

I long for the day it becomes dynamic...

    J
