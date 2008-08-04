Return-Path: <linux-kernel-owner+w=401wt.eu-S1755630AbYHDSUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbYHDSUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 14:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbYHDSSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 14:18:17 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:45089 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbYHDSQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 14:16:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=n4g8U6s5QmZwOaDz0QUeOm0hCE/nuFyVc/F2/TGab62jl3nBaiN/BIue7rZn93kXUe
         xCNjdJhNVI3+BEVnA8HpV57csjhhU37qXcsX7RRnAWGOGV/zW4r02rq/kRRVQyVdAJ4B
         5jW7zKY/3LM86OtiOW7pTwGKMHJQWFYhrjPzc=
Message-ID: <86802c440808041116s5336b882i8cbd1b8ef2beb80@mail.gmail.com>
Date: Mon, 4 Aug 2008 11:16:04 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH] x86: 64bit support more than 256 irq v2
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Alan Mayer" <ajm@sgi.com>
In-Reply-To: <4897021D.7040708@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217642575-22727-1-git-send-email-yhlu.kernel@gmail.com>
	 <86802c440808011916q1a279ael995eaeaa655c239@mail.gmail.com>
	 <m14p64i0lr.fsf@frodo.ebiederm.org> <4897021D.7040708@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 4, 2008 at 6:20 AM, Mike Travis <travis@sgi.com> wrote:
> Eric W. Biederman wrote:
>> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>>
>>> On Fri, Aug 1, 2008 at 7:02 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>>> Dhaval Giani got:
>>>> kernel BUG at arch/x86/kernel/io_apic_64.c:357!
>>>> invalid opcode: 0000 [1] SMP
>>>> CPU 24
>>>> ...
>>>>
>>>> his system (x3950) has 8 ioapic, irq > 256
>>>>
>>>> caused by
>>>>        commit 9b7dc567d03d74a1fbae84e88949b6a60d922d82
>>>>        Author: Thomas Gleixner <tglx@linutronix.de>
>>>>        Date:   Fri May 2 20:10:09 2008 +0200
>>>>
>>>>           x86: unify interrupt vector defines
>>>>
>>>>           The interrupt vector defines are copied 4 times around with minimal
>>>>           differences. Move them all into asm-x86/irq_vectors.h
>>>>
>>>> because 64bit allow same vector for different cpu to serve different irq
>>>>
>>>> need to create that array dynamically later
>>>>
>>>> v2: change NR_IRQS to 1024
>>>>
>>>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>>> Tested-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
>>> this is for
>>> http://bugzilla.kernel.org/show_bug.cgi?id=11201
>>>
>>> but need SGI guys to verify in their system. they like to have NR_IRQS to be 224
>>
>> There was a patch that came out a while ago that set NR_IRQS as NR_IOAPICS*32 from
>> SGI.  Where that got to I don't recall.
>>
>> Eric
>
> That was from Alan ... I'll Cc: him.  Here's an early copy (not sure if
> this was the final one though.)
>
>
>>From: Alan Mayer <ajm@sgi.com>
> Subject:  [PATCH] x86_64: resize NR_IRQS for large machines
>
> On machines with very large numbers of cpus, tables that are dimensioned
> by NR_IRQS get very large, especially the irq_desc table.  They are also
> very sparsely used.  When the cpu count is > MAX_IO_APICS, use MAX_IO_APICS
> to set NR_IRQS, otherwise use NR_CPUS.
>
> Reviewed-by: Christoph Lameter <clameter@sgi.com>
>
> Signed-off-by: Alan Mayer <ajm@sgi.com>
> Index: v2.6.25-rc6/include/asm-x86/irq_64.h
> ===================================================================
> --- v2.6.25-rc6.orig/include/asm-x86/irq_64.h   2008-03-19 16:52:52.000000000 -0500
> +++ v2.6.25-rc6/include/asm-x86/irq_64.h        2008-03-20 16:46:51.000000000 -0500
> @@ -10,6 +10,10 @@
>  *     <tomsoft@informatik.tu-chemnitz.de>
>  */
>
> +#if !defined(MAX_IO_APICS)
> +#include <asm/apicdef.h>
> +#endif
> +
>  #define TIMER_IRQ 0
>
>  /*
> @@ -31,7 +35,11 @@
>
>  #define FIRST_SYSTEM_VECTOR    0xef   /* duplicated in hw_irq.h */
>
> -#define NR_IRQS (NR_VECTORS + (32 *NR_CPUS))
> +#if NR_CPUS < MAX_IO_APICS
> +#define NR_IRQS (NR_VECTORS + (32 * NR_CPUS))
> +#else
> +#define NR_IRQS (NR_VECTORS + (32 * MAX_IO_APICS))
> +#endif
>  #define NR_IRQ_VECTORS NR_IRQS
>
>  static __inline__ int irq_canonicalize(int irq)
> Index: v2.6.25-rc6/include/linux/kernel_stat.h
> ===================================================================
> --- v2.6.25-rc6.orig/include/linux/kernel_stat.h        2008-03-19 16:53:00.000000000 -0500
> +++ v2.6.25-rc6/include/linux/kernel_stat.h     2008-03-20 11:12:27.000000000 -0500
> @@ -1,11 +1,11 @@
>  #ifndef _LINUX_KERNEL_STAT_H
>  #define _LINUX_KERNEL_STAT_H
>
> -#include <asm/irq.h>
>  #include <linux/smp.h>
>  #include <linux/threads.h>
>  #include <linux/percpu.h>
>  #include <linux/cpumask.h>
> +#include <asm/irq.h>
>  #include <asm/cputime.h>
>
>  /*
>

so this one have right sequence...

could add sth say why need special including sequence...

YH
