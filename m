Return-Path: <linux-kernel-owner+w=401wt.eu-S1762125AbYHAVbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762125AbYHAVbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756868AbYHAVa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:30:58 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:50146 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141AbYHAVa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:30:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=an7JSaOHgknW/S7vQkSKOvsdtLlBHWvnFb0iEW70y6Rp7eqEwsftCmUayDKu+5Hnx/
         8PKr4InqmPxITdLHnqGNE0Q4vtIfRZa25yFztEYz/6stbz5Bkcj2IfRNcQG1UqNVDohK
         uf4uapSA+DLSiwDwseen9jlKmnxdSlHT4y0K4=
Message-ID: <86802c440808011430i6cf5cb8cn519777a78dd987b0@mail.gmail.com>
Date: Fri, 1 Aug 2008 14:30:55 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 00/16] dyn_array and nr_irqs support v2
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       hpa <hpa@zytor.com>, "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <m1iqukwjjg.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>
	 <m1iqukwjjg.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 1, 2008 at 1:46 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Yinghai Lu <yhlu.kernel@gmail.com> writes:
>
>> Please check dyn_array support for x86
>
> YH you have not addressed any of my core concerns and this exceeds my review limit.

i mean drivers/serial/8250.c

> Unfortunately I don't feel like this is a productive process.
>
> My core concerns are:
> - You have not separated out and separately pushed the regression patch.  So that we can
>  fix the current rc release.  Simply tuning NR_IRQS is all I feel comfortable with for
>  fixing things in the post merge window period.

Increase NR_IRQS to 512 for x86_64?

>
> - The generic code has no business with dealing with NR_IRQS sized arrays.
>  Since we don't have a generic problem I don't see why we should have a generic dyn_array solution.
besides

arch/x86/kernel/io_apic_32.c:DEFINE_DYN_ARRAY(irq_2_pin, sizeof(struct
irq_pin_list), pin_map_size, 16, NULL);
arch/x86/kernel/io_apic_32.c:DEFINE_DYN_ARRAY(balance_irq_affinity,
sizeof(struct balance_irq_affinity), nr_irqs, PAGE_SIZE,
irq_affinity_init_work);
arch/x86/kernel/io_apic_32.c:DEFINE_DYN_ARRAY(irq_vector, sizeof(u8),
nr_irqs, PAGE_SIZE, irq_vector_init_work);
arch/x86/kernel/io_apic_64.c:DEFINE_DYN_ARRAY(irq_cfg, sizeof(struct
irq_cfg), nr_irqs, PAGE_SIZE, init_work);
arch/x86/kernel/io_apic_64.c:DEFINE_DYN_ARRAY(irq_2_pin, sizeof(struct
irq_pin_list), pin_map_size, sizeof(struct irq_pin_list), NULL);

kernel/sched.c:DEFINE_PER_CPU_DYN_ARRAY_ADDR(per_cpu__kstat_irqs,
per_cpu__kstat.irqs, sizeof(unsigned int), nr_irqs, sizeof(unsigned
long), NULL);

and kstat.irqs is the killer... every cpu will have that. [NR_CPUS][NR_IRQS]...

>
> - The dyn_array infrastructure does not provide for per numa node allocation of
>  irq_desc structures, limiting NUMA scalability.

you plan to move irq_desc when irq_affinity is set to cpus on other node?

something like DEFINE_PER_NODE_DYN_ARRAY ?

>
> - You appear to be papering over problems instead of digging in and actually fixing them.

use dyn_array is less intrusive at this point. and dyn_array related
code is not big.
just NR_IRQS to nr_irqs to make the patches more bigger. actually it is simple.

with acpi_madt probing, nr_irqs is much small. like 48 or 98. and
current one is MACRO 224 or 256.

>
> YH  Here is what I was suggesting when the topic of killing NR_IRQs came up a week or so
> ago.
> http://lkml.org/lkml/2008/7/10/439
> http://lkml.org/lkml/2008/7/10/532
>
> Which essentially boils down to:
> - Removing NR_IRQS from the non-irq infrastructure code.
> - Add a config option for architectures that are not going to use an array
> - In the genirq code have a lookup function that goes from irq number to irq_desc *.

so we need one pointer array with that lookup function? what is the
pointer array index size?
or use list in that lookup function?

how about percpu kstat.irqs?

>
> The rest we should be able to handle in a arch dependent fashion.
>
> When we are done we should be able to create a stable irq number for msi interrupts
> that is something like:  bus:dev:fun:vector_no which is 8+5+3+12=28 bits long.

how about irq migration from one cpu to another with different vector_no ?

YH
