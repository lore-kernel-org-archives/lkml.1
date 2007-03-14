Return-Path: <linux-kernel-owner+w=401wt.eu-S933804AbXCNCZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933804AbXCNCZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 22:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933806AbXCNCZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 22:25:52 -0400
Received: from ozlabs.org ([203.10.76.45]:43676 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933804AbXCNCZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 22:25:51 -0400
Subject: Re: [PATCH 0/8] x86 boot, pda and gdt cleanups
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
In-Reply-To: <45F70E25.7050704@goop.org>
References: <1173184747.4644.23.camel@localhost.localdomain>
	 <45F70E25.7050704@goop.org>
Content-Type: text/plain
Date: Wed, 14 Mar 2007 13:25:49 +1100
Message-Id: <1173839149.5443.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 13:48 -0700, Jeremy Fitzhardinge wrote:
> Rusty Russell wrote:
> > Hi all,
> >
> > 	The GDT stuff on x86 is a little more complex than it need be, but
> > playing with boot code is always dangerous.  These compile and boot on
> > UP and SMP for me, but Andrew should let the cook in -mm for a while.
> >   
> Hi Rusty,
> 
> This is my rough hacking patch I needed to get things into a Xen-shape
> state.

Looks good.  Just one thing:

>  void __devinit native_smp_prepare_boot_cpu(void)
>  {
> -	cpu_set(smp_processor_id(), cpu_online_map);
> -	cpu_set(smp_processor_id(), cpu_callout_map);
> -	cpu_set(smp_processor_id(), cpu_present_map);
> -	cpu_set(smp_processor_id(), cpu_possible_map);
> -	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
> +	int cpu = smp_processor_id();
> +
> +	cpu_set(cpu, cpu_online_map);
> +	cpu_set(cpu, cpu_callout_map);
> +	cpu_set(cpu, cpu_present_map);
> +	cpu_set(cpu, cpu_possible_map);
> +	per_cpu(cpu_state, cpu) = CPU_ONLINE;
>  
>  	/* Set up %fs to point to our per-CPU area now it's allocated */
> -	init_gdt(smp_processor_id(), &init_task);
> -	cpu_set_gdt(smp_processor_id());
> +	init_gdt(cpu, &init_task);
> +	cpu_set_gdt(cpu);
>  }

This is called "pissing in the corners".  Don't do it: we don't need to
touch that code and I actually prefer the original anyway (explicit is
*good*).  

The habit of extracting cpu number once then using it is an optimization
which we should be aiming to get rid of (it simply hurts archs with
efficient per-cpu implementations).

Cheers,
Rusty.

