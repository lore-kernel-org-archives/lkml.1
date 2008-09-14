Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbYINPj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbYINPj7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 11:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbYINPjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 11:39:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46655 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623AbYINPjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 11:39:51 -0400
Date: Sun, 14 Sep 2008 17:39:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dean Nelson <dcn@sgi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alan Mayer <ajm@sgi.com>,
       jeremy@goop.org, rusty@rustcorp.com.au, suresh.b.siddha@intel.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <Yinghai.lu@amd.com>
Subject: Re: [RFC 2/4] introduce dynamically allocated system vectors
Message-ID: <20080914153922.GK29290@elte.hu>
References: <489C6844.9050902@sgi.com> <20080811165930.GI4524@elte.hu> <48A0737F.9010207@sgi.com> <m1y733mjdh.fsf@frodo.ebiederm.org> <20080911152304.GA13655@sgi.com> <20080911152732.GC13655@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080911152732.GC13655@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dean Nelson <dcn@sgi.com> wrote:

> Introduce the dynamic allocation and deallocation of system vectors which
> are mapped to irq numbers allowing the use of request_irq()/free_irq().
> 
> Signed-off-by: Dean Nelson <dcn@sgi.com>
> 
> ---
> 
>  arch/x86/kernel/apic.c        |    3 
>  arch/x86/kernel/io_apic.c     |  264 +++++++++++++++++++++++++++++++++-----

it's not clean to put it into io_apic.c:

> -static int __assign_irq_vector(int irq, cpumask_t mask)
> +bool __grab_irq_vector(struct irq_desc *desc, unsigned int vector,
> +		       cpumask_t *new_domain_mask)

please put it into arch/x86/kernel/irq.c or so.

this bit:

> Index: linux/include/linux/irq.h
> ===================================================================
> --- linux.orig/include/linux/irq.h	2008-09-10 12:08:46.000000000 -0500
> +++ linux/include/linux/irq.h	2008-09-11 06:53:16.000000000 -0500
> @@ -390,11 +390,22 @@ set_irq_chained_handler(unsigned int irq
>  extern void set_irq_noprobe(unsigned int irq);
>  extern void set_irq_probe(unsigned int irq);
>  
> -/* Handle dynamic irq creation and destruction */
> +/* Handle dynamic irq device vector allocation and deallocation */
>  extern unsigned int create_irq_nr(unsigned int irq_want);
>  extern int create_irq(void);
>  extern void destroy_irq(unsigned int irq);
>  
> +/* Handle dynamic irq system vector allocation and deallocation */
> +extern unsigned int create_irq_system_vector(cpumask_t *mask, int priority,
> +					     char *irq_name,
> +					     int *assigned_vector);
> +#define IRQ_PRIORITY_LOW	1
> +#define IRQ_PRIORITY_HIGH	2
> +
> +extern void destroy_irq_system_vector(unsigned int irq);
> +
> +extern int reserve_system_vectors(int number);

does not belong into the generic kernel code - it's an x86 property.

	Ingo
