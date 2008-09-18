Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432AbYIRNhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbYIRNhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 09:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbYIRNhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 09:37:35 -0400
Received: from relay1.sgi.com ([192.48.171.29]:53012 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753164AbYIRNhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 09:37:35 -0400
Date: Thu, 18 Sep 2008 08:37:33 -0500
From: Dean Nelson <dcn@sgi.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Mayer <ajm@sgi.com>,
       Dimitri Sivanich <sivanich@sgi.com>, jeremy@goop.org,
       rusty@rustcorp.com.au, suresh.b.siddha@intel.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <Yinghai.lu@amd.com>
Subject: Re: [RFC 0/4] dynamically allocate arch specific system vectors
Message-ID: <20080918133733.GA8830@sgi.com>
References: <20080811165930.GI4524@elte.hu> <48A0737F.9010207@sgi.com> <m1y733mjdh.fsf@frodo.ebiederm.org> <20080911152304.GA13655@sgi.com> <20080914153522.GJ29290@elte.hu> <20080915215053.GA11657@sgi.com> <20080916082448.GA17287@elte.hu> <20080916204654.GA3532@sgi.com> <20080917173032.GA5674@sgi.com> <m17i9a61l2.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m17i9a61l2.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 11:59:05AM -0700, Eric W. Biederman wrote:
> 
> I need to look at these patches some more (apologies I got busy).

Thanks for taking a look.

I've got a not-quite-complete new version of the patchset that addresses
most of the issues raised by Ingo. At it's heart is the following:


 arch/x86/kernel/irq.c___(new)_________________________________

#include <linux/irq.h>

static cpumask_t domain_online;

int grab_irq_vector(struct irq_desc *desc, unsigned int vector,
		   cpumask_t *domain)
{
	/* Must be called with vector lock held */
	int cpu;

	cpus_and(domain_online, *domain, cpu_online_map);

	for_each_cpu_mask_nr(cpu, domain_online) {
		if (per_cpu(vector_irq, cpu)[vector] != NULL)
			return -EBUSY;
	}

	/* Available reserve it */
	for_each_cpu_mask_nr(cpu, domain_online)
		per_cpu(vector_irq, cpu)[vector] = desc;

	return vector;
}


 arch/x86/kernel/io_apic.c_____________________________________

static int ioapic_grab_irq_vector(struct irq_desc *desc, unsigned int vector,
				  cpumask_t *domain)
{
	/* Must be called with vector lock held */
	struct irq_cfg *cfg;
	int ret;

	ret = grab_irq_vector(desc, vector, domain);
	if (ret == vector) {
		cfg = irq_cfg(desc->irq);
		if (cfg->vector) {
			cfg->move_in_progress = 1;
			cfg->old_domain = cfg->domain;
		}
		cfg->vector = vector;
		cfg->domain = *domain;
	}
	return ret;
}

I've also restructured the order of the patchset so that the first
three patches switch vector_irq from an irq # to an irq_desc pointer, 
replace system_vectors[] usage by a call to grab_irq_vector(), and
finally replace used_vectors[] usage by a call to grab_irq_vector().
You may find these three patches meaningful in and of themselves
since Ingo seemed to indicate that they cleaned up some of the code.

The last patch adds the dynamic allocate of system irq, which, if I'm
understanding correctly, needs to be reworked so that SGI's UV irq
needs get satisfied through a variant of MSI. The MSI code isn't
something I've looked at before.


> We can not assign a vector to all CPUS.
> 
> We don't have the fields for vector -> irq mapping for cpus that
> are not-online.  So we can only assign to cpus that are online now.
> And latter add the other cpus when they come online.
> 
> I have had that oops, it sucks, I don't want to go back.

I reworked the above functions so that grab_irq_vector() enforces
online CPUS only. (I'm assuming your statements applies to per_cpu
vector_irq, as well. If not, then grab_irq_vector() could accept a
cpu_possible_map domain if NON_IRQ_DESC is passed as the desc pointer.)

We'll need to ensure that when a CPU comes online that its vector_irqs
that need to be set to NON_IRQ_DESC, get set properly by
__setup_vector_irq().


Thanks,
Dean
