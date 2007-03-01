Return-Path: <linux-kernel-owner+w=401wt.eu-S932980AbXCAIRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980AbXCAIRO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 03:17:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932993AbXCAIRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 03:17:14 -0500
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:45804 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932980AbXCAIRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 03:17:14 -0500
Subject: Re: [Fastboot] [PATCH 2/5] Use the APIC to determine the hardware
	processor id -	i386
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: vgoyal@in.ibm.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, judith@linux-foundation.org,
       fastboot@lists.osdl.org, ebiederm@xmission.com, ak@suse.de
In-Reply-To: <20070301075900.GA17405@in.ibm.com>
References: <1172733419.1498.269.camel@sebastian.intellilink.co.jp>
	 <20070301075900.GA17405@in.ibm.com>
Content-Type: text/plain; charset=utf-8
Organization: NTT Open Source Software Center
Date: Thu, 01 Mar 2007 17:17:39 +0900
Message-Id: <1172737059.21214.11.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-01 at 13:29 +0530, Vivek Goyal wrote:
> On Thu, Mar 01, 2007 at 04:16:59PM +0900, Fernando Luis Vázquez Cao wrote:
> > Use the APIC to determine the hardware processor id when APIC support
> > has been selected, independently of whether CONFIG_SMP is set or not.
> > 
> > Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> > ---
> > 
> > diff -urNp linux-2.6.21-rc2/include/asm-i386/smp.h linux-2.6.21-rc2-hwcpuid/include/asm-i386/smp.h
> > --- linux-2.6.21-rc2/include/asm-i386/smp.h	2007-03-01 14:02:21.000000000 +0900
> > +++ linux-2.6.21-rc2-hwcpuid/include/asm-i386/smp.h	2007-03-01 14:08:50.000000000 +0900
> > @@ -74,20 +74,6 @@ static inline int num_booting_cpus(void)
> >  	return cpus_weight(cpu_callout_map);
> >  }
> >  
> > -#ifdef CONFIG_X86_LOCAL_APIC
> > -
> > -#ifdef APIC_DEFINITION
> > -extern int hard_smp_processor_id(void);
> > -#else
> > -#include <mach_apicdef.h>
> > -static inline int hard_smp_processor_id(void)
> > -{
> > -	/* we don't want to mark this access volatile - bad code generation */
> > -	return GET_APIC_ID(*(unsigned long *)(APIC_BASE+APIC_ID));
> > -}
> > -#endif
> > -#endif
> > -
> >  extern int safe_smp_processor_id(void);
> >  extern int __cpu_disable(void);
> >  extern void __cpu_die(unsigned int cpu);
> > @@ -102,10 +88,23 @@ extern unsigned int num_processors;
> >  
> >  #define NO_PROC_ID		0xFF		/* No processor magic marker */
> >  
> > -#endif
> > +#endif /* CONFIG_SMP */
> >  
> >  #ifndef __ASSEMBLY__
> >  
> > +#ifdef CONFIG_X86_LOCAL_APIC
> > +#ifdef APIC_DEFINITION
> > +extern int hard_smp_processor_id(void);
> > +#else
> > +#include <mach_apicdef.h>
> > +static inline int hard_smp_processor_id(void)
> > +{
> > +	/* we don't want to mark this access volatile - bad code generation */
> > +	return GET_APIC_ID(*(unsigned long *)(APIC_BASE+APIC_ID));
> > +}
> > +#endif /* APIC_DEFINITION */
> > +#endif /* CONFIG_X86_LOCAL_APIC */
> > +
> 
> I think compilation will fail if CONFIG_X86_LOCAL_APIC=n and I build a UP
> kernel? There is no definition of hard_smp_processor_id in that case.
Hi Vivek,

Thank you for the feedback.

I tested that combination and it compiled properly. The reason is that
hard_smp_processor_id is not used anywhere in the kernel when
CONFIG_X86_LOCAL_APIC=n and CONFIG_SMP=n.

I tested all the combinations (including voyager) and everything seems
to work as expected.

Regards,

Fernando

> Otherwise, as a concept it seems to make sense that hard_smp_processor_id()
> is not necessarily zero on UP systems.
> 
> Thanks
> Vivek

