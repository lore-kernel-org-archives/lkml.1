Return-Path: <linux-kernel-owner+w=401wt.eu-S1751102AbZHZHuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751102AbZHZHuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 03:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750784AbZHZHuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 03:50:55 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:51711 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbZHZHuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 03:50:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aMGvzdwbPursT7OKnnlk78WRR2jr57HAZY76Zwt4xyVRCMgJlhHbTJ8ZkLo2IGuuEf
         LprabUDcNDVb6B0T8Q2IZpSurDhDxN28r2Xve7Ra6I12Geh0+uOK9PEnpDEDLFtNaTnC
         RIkZZi5pvyVajkStJ36ScYUnVKKhCw4RZAKD0=
Subject: Re: Subject:[ PATCH 001:003] OFFSCHED CORE
From: raz ben yehuda <raziebe@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: riel@redhat.com, mingo@elte.hu, peterz@infradead.org,
       wiseman@macs.biu.ac.il, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <m163cbm3rd.fsf@fess.ebiederm.org>
References: <1250983786.5688.23.camel@raz>
	 <m163cbm3rd.fsf@fess.ebiederm.org>
Content-Type: text/plain
Date: Wed, 26 Aug 2009 13:51:04 +0300
Message-Id: <1251283864.3514.25.camel@raz>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2009-08-26 at 00:29 -0700, Eric W. Biederman wrote:
> raz ben yehuda <raziebe@gmail.com> writes:
> 
> > 		OFFSCHED support.
> >
> > . A callback invoked just before halting the processor.
> > . SMP alternative work-around. we do not run smp alternatives if we are
> >    left with a single processor.
> > . A set of utilities used by the offsched driver.
> 
> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> 
> Cpu hotunplug is mostly broken when it comes to irqs.
> Building on and extending broken code is just asking for trouble,
> especially for out of tree code.
I have this code for 4 years. The least of my problems was the
hot-unplugging. as for the tree, I will use git. much depends if the
patch is excepted. you say - i do. 

> > process.c |  109 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > smpboot.c |   13 +++++--
> > 2 files changed, 118 insertions(+), 4 deletions(-)
> >
> > Signed-off-by: raziebe@gmail.com
> > ---
> > diff -X 2.6.30-offsched/Documentation/dontdiff -urN tmp/linux-2.6.30/arch/x86/kernel/process.c 2.6.30-offsched/arch/x86/kernel/process.c
> > --- tmp/linux-2.6.30/arch/x86/kernel/process.c	2009-06-10 06:05:27.000000000 +0300
> > +++ 2.6.30-offsched/arch/x86/kernel/process.c	2009-08-21 22:02:44.000000000 +0300
> > @@ -613,3 +613,112 @@
> >  }
> >  early_param("idle", idle_setup);
> >  
> > +#ifdef CONFIG_HOTPLUG_CPU
> > +struct hotplug_cpu{
> > +	long flags;
> > +	void (*hotplug_cpu_dead)(void);
> > +};
> > +
> > +static long 	offsched_services;
> > +
> > +#define CPU_OFFSCHED		31
> > +#define CPU_OFFSCHED_KMEM	30
> > +#define SERVICE_TIMER		01
> > +#define SERVICE_NAPI		02
> > +
> > +DEFINE_PER_CPU(struct hotplug_cpu, offschedcpu);
> > +
> > +void unregister_offsched(int cpuid)
> > +{
> > +	struct hotplug_cpu *cpu = &per_cpu(offschedcpu, cpuid);
> > +	cpu->hotplug_cpu_dead = NULL;
> > +	clear_bit(CPU_OFFSCHED, &cpu->flags);
> > +}
> > +EXPORT_SYMBOL_GPL(unregister_offsched);
> > +
> > +int is_offsched(int cpuid)
> > +{
> > +	struct hotplug_cpu *cpu = &per_cpu(offschedcpu, cpuid);
> > +	return test_bit(CPU_OFFSCHED, &cpu->flags);
> > +}
> > +EXPORT_SYMBOL_GPL(is_offsched);
> > +
> > +int is_offsched_kmem(int cpuid)
> > +{
> > +	struct hotplug_cpu *cpu = &per_cpu(offschedcpu, cpuid);
> > +	return test_bit(CPU_OFFSCHED_KMEM, &cpu->flags);
> > +}
> > +EXPORT_SYMBOL_GPL(is_offsched_kmem);
> > +
> > +void set_offsched_kmem(int cpuid)
> > +{
> > +	struct hotplug_cpu *cpu = &per_cpu(offschedcpu, cpuid);
> > +	set_bit(CPU_OFFSCHED_KMEM, &cpu->flags);
> > +}
> > +EXPORT_SYMBOL_GPL(set_offsched_kmem);
> > +
> > +void unset_offsched_kmem(int cpuid)
> > +{
> > +	struct hotplug_cpu *cpu = &per_cpu(offschedcpu, cpuid);
> > +	clear_bit(CPU_OFFSCHED_KMEM, &cpu->flags);
> > +}
> > +EXPORT_SYMBOL_GPL(unset_offsched_kmem);
> > +
> > +int register_offsched(void (*offsched_callback)(void), int cpuid)
> > +{
> > +	struct hotplug_cpu *cpu = &per_cpu(offschedcpu, cpuid);
> > +	if (is_offsched(cpuid))
> > +		return -1;
> > +	cpu->hotplug_cpu_dead = offsched_callback;
> > +	set_bit(CPU_OFFSCHED, &cpu->flags);
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(register_offsched);
> > +
> > +void run_offsched(void)
> > +{
> > +	int cpuid = raw_smp_processor_id();
> > +	struct hotplug_cpu *cpu = &per_cpu(offschedcpu, cpuid);
> > +	cpu->hotplug_cpu_dead();
> > +}
> > +
> > +int  offsched_is_napi_avail(void)
> > +{
> > +	return SERVICE_NAPI & offsched_services;
> > +}
> > +
> > +int (*offsched_rule)(void *);
> > +EXPORT_SYMBOL(offsched_rule);
> > +/*
> > +* if we a have filter than apply filter.
> > +* return 0 if packet should go to kernel
> > +* return 1 if packet should go to offsched.
> > +*/
> > +int offsched_pkt(void *s)
> > +{
> > +	if (offsched_rule)
> > +		return offsched_rule(s);
> > +	return 0;
> > +}
> > +
> > +void offsched_register_napi(void)
> > +{
> > +	offsched_services |= SERVICE_NAPI;
> > +}
> > +EXPORT_SYMBOL_GPL(offsched_register_napi);
> > +
> > +void offsched_unregister_napi(void)
> > +{
> > +	offsched_services &= ~SERVICE_NAPI;
> > +}
> > +EXPORT_SYMBOL_GPL(offsched_unregister_napi);
> > +
> > +/*
> > + * napi scheudule is called in offsched context.
> > +*/
> > +void offsched_napi_schedule(void *n)
> > +{
> > +
> > +}
> > +
> > +#endif
> > diff -X 2.6.30-offsched/Documentation/dontdiff -urN tmp/linux-2.6.30/arch/x86/kernel/smpboot.c 2.6.30-offsched/arch/x86/kernel/smpboot.c
> > --- tmp/linux-2.6.30/arch/x86/kernel/smpboot.c	2009-06-10 06:05:27.000000000 +0300
> > +++ 2.6.30-offsched/arch/x86/kernel/smpboot.c	2009-07-25 13:59:19.000000000 +0300
> > @@ -39,6 +39,8 @@
> >   *	Glauber Costa		:	i386 and x86_64 integration
> >   */
> >  
> > +#define DEBUG
> > +
> >  #include <linux/init.h>
> >  #include <linux/smp.h>
> >  #include <linux/module.h>
> > @@ -686,8 +688,8 @@
> >  	};
> >  
> >  	INIT_WORK(&c_idle.work, do_fork_idle);
> > -
> > -	alternatives_smp_switch(1);
> > +	if (!is_offsched(cpu))
> > +		alternatives_smp_switch(1);
> >  
> >  	c_idle.idle = get_idle_for_cpu(cpu);
> >  
> > @@ -1283,8 +1285,9 @@
> >  	for (i = 0; i < 10; i++) {
> >  		/* They ack this in play_dead by setting CPU_DEAD */
> >  		if (per_cpu(cpu_state, cpu) == CPU_DEAD) {
> > -			printk(KERN_INFO "CPU %d is now offline\n", cpu);
> > -			if (1 == num_online_cpus())
> > +			printk(KERN_INFO "CPU %d is now offline %s\n", cpu,
> > +				is_offsched(cpu) ? "and OFFSCHED" : "");
> > +			if (1 == num_online_cpus() && !is_offsched(cpu))
> >  				alternatives_smp_switch(0);
> >  			return;
> >  		}
> > @@ -1313,6 +1316,8 @@
> >  void native_play_dead(void)
> >  {
> >  	play_dead_common();
> > +	if (is_offsched(raw_smp_processor_id()))
> > +		run_offsched();
> >  	wbinvd_halt();
> >  }
> >  
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/

