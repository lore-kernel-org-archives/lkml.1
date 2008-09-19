Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831AbYISX0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbYISX0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 19:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbYISX0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 19:26:42 -0400
Received: from relay2.sgi.com ([192.48.171.30]:40173 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750846AbYISX0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 19:26:42 -0400
Date: Fri, 19 Sep 2008 18:26:40 -0500
From: Dean Nelson <dcn@sgi.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Alan Mayer <ajm@sgi.com>, jeremy@goop.org, rusty@rustcorp.com.au,
       suresh.b.siddha@intel.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <Yinghai.lu@amd.com>
Subject: Re: [PATCH 1/3] switch vector_irq[] from irq number to irq_desc pointer v2
Message-ID: <20080919232640.GB10245@sgi.com>
References: <20080919200212.GA6528@sgi.com> <20080919200449.GB6528@sgi.com> <86802c440809191340t75104d48g1f5cf5cf0e55035a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440809191340t75104d48g1f5cf5cf0e55035a@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 01:40:23PM -0700, Yinghai Lu wrote:
> On Fri, Sep 19, 2008 at 1:04 PM, Dean Nelson <dcn@sgi.com> wrote:
> > Change per_cpu variable vector_irq[] from holding an 'int' irq number to
> > holding a 'struct irq_desc' pointer.
> 
> why?
> 
> Eric wants to change int irq to some struct irq later?

Well, it was my take on what Eric was saying in the following:

On Mon, Aug 11, 2008 at 12:39:22PM -0700, Eric W. Biederman wrote:
>
> We create a common factor of assign_irq_vector that looks something like:
> 
> bool __grab_irq_vector(struct irq_desc *desc, unsigned vector, cpumask_t new_domain)
> {
>         /* Must be called with vector lock */
>         struct irq_cfg *cfg;
>         bool grabbed = false;
>         unsigned int old_vector;
>         cpumask_t mask;
>         int cpu;
> 
>         cfg = get_irqp_cfg(irq);
>         old_vector = cfg->vector;
>         cpus_and(mask, new_domain, cpu_online_map);
> 
>         for_each_cpu_mask_nr(cpu, mask) {
>               if (per_cpu(vector_irq, cpu)[vector])
>                       goto out;
>         }
>         /* Available reserve it */
>         for_each_cpu_mask_nr(cpu, mask)
>             per_cpu(vector_irq, cpu)[vector] = desc;

The previous line made me think that was what he wanted....

>         if (cfg->vector) {
>               cfg->move_in_progress;
>                 cfg->old_domain = cfg->domain;
>         }
>         cfg->vector = vector;
>         cfg->domain = mask;
>         grabbed = true;
>         
> out:
>         return grabbed;
> }

... Along with the following paragraph.

> I think vector_irq should return an irq_desc and have an entry for
> all of the static vectors as well (if we are going to do weird
> things with dynamic high priority vector allocation, and dynamic
> detection of which vectors assign_irq_vector may use).

If that's not what Eric meant, then I got it wrong and you can reject
the patchset.

Dean

