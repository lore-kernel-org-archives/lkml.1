Return-Path: <linux-kernel-owner+w=401wt.eu-S1759390AbYHNQee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759390AbYHNQee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 12:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbYHNQe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 12:34:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752732AbYHNQeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 12:34:25 -0400
Date: Thu, 14 Aug 2008 09:33:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] irq: sparse irqs, fix #2
Message-Id: <20080814093326.1d8d0a88.akpm@linux-foundation.org>
In-Reply-To: <20080814133652.GA10972@elte.hu>
References: <1218705441-21838-1-git-send-email-yhlu.kernel@gmail.com>
	<20080814132638.GA18743@elte.hu>
	<20080814133652.GA10972@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008 15:36:52 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> +static inline cpumask_t vector_allocation_domain(int cpu)
> +{
> +        /* Careful. Some cpus do not strictly honor the set of cpus
> +         * specified in the interrupt destination when using lowest
> +         * priority interrupt delivery mode.
> +         *
> +         * In particular there was a hyperthreading cpu observed to
> +         * deliver interrupts to the wrong hyperthread when only one
> +         * hyperthread was specified in the interrupt desitination.
> +         */
> +        cpumask_t domain = { { [0] = APIC_ALL_CPUS, } };
> +        return domain;
> +}

I haven't looked at callers of this, but...

Does it need to be allocated on the stack?  Local cpumask_t's are a
size problem.  Can we build this in .rodata at compile time instead?

Is this the caller?

+	for_each_cpu_mask(cpu, mask) {
+		cpumask_t domain, new_mask;
+		int new_cpu;
+		int vector;
+
+		domain = vector_allocation_domain(cpu);
+		cpus_and(new_mask, domain, cpu_online_map);

If so we could perhaps do


static noinline const cpumask_t *vector_allocation_domain(int cpu)
{
        /* Careful. Some cpus do not strictly honor the set of cpus
         * specified in the interrupt destination when using lowest
         * priority interrupt delivery mode.
         *
         * In particular there was a hyperthreading cpu observed to
         * deliver interrupts to the wrong hyperthread when only one
         * hyperthread was specified in the interrupt desitination.
         */
        static const cpumask_t domain = { { [0] = APIC_ALL_CPUS, } };
        return &domain;
}


...

+	for_each_cpu_mask(cpu, mask) {
+		cpumask_t domain, new_mask;
+		int new_cpu;
+		int vector;
+
+		__cpus_and(new_mask, vector_allocation_domain(cpu),
+				&cpu_online_map);

otoh, perhaps this new function is one implementation of
genapic.vector_allocation_domain(), in which case the inlining was
unneeded and misleading.

I give up.  Have a little think about the stack bloat, please.

btw, whoever wrote that function is in need of a tab key.
