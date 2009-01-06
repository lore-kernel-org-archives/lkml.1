Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbZAFQ7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbZAFQ7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 11:59:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbZAFQ7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 11:59:00 -0500
Received: from sh.osrg.net ([192.16.179.4]:51614 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbZAFQ67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 11:58:59 -0500
Date: Wed, 7 Jan 2009 01:58:29 +0900
To: travis@sgi.com
Cc: mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       mingo@redhat.com, rusty@rustcorp.com.au
Subject: Re: tip: IA64 build error
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <49637A72.3020600@sgi.com>
References: <20090106233758L.fujita.tomonori@lab.ntt.co.jp>
	<20090106152111.GA11114@elte.hu>
	<49637A72.3020600@sgi.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090107013420F.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Jan 2009 07:36:18 -0800
Mike Travis <travis@sgi.com> wrote:

> Ingo Molnar wrote:
> > * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > 
> >> I got the followings with tip/master:
> >>
> >> drivers/pci/probe.c: In function 'pci_bus_show_cpuaffinity':
> >> drivers/pci/probe.c:56: error: implicit declaration of function 'cpumask_from_node'
> >> drivers/pci/probe.c:56: warning: pointer/integer type mismatch in conditional expression
> >> make[3]: *** [drivers/pci/probe.o] Error 1
> >> make[2]: *** [drivers/pci] Error 2
> >>
> >>
> >> it's due to the typo in arch/ia64/include/asm/topology.h, I guess.
> > 
> > yeah. Does the patch below fix it for you?
> > 
> > 	Ingo

Yeah, I've used the same patch but I was not sure if it's the correct
fix.


> > ---------------->
> >>From 36c401a44abcc389a00f9cd14892c9cf9bf0780d Mon Sep 17 00:00:00 2001
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Tue, 6 Jan 2009 16:19:22 +0100
> > Subject: [PATCH] [IA64] fix typo in cpumask_of_pcibus()
> > 
> > Impact: build fix
> > 
> > Fujita Tomonori reported:
> > 
> >  drivers/pci/probe.c: In function 'pci_bus_show_cpuaffinity':
> >  drivers/pci/probe.c:56: error: implicit declaration of function 'cpumask_from_node'
> >  drivers/pci/probe.c:56: warning: pointer/integer type mismatch in conditional expression
> >  make[3]: *** [drivers/pci/probe.o] Error 1
> >  make[2]: *** [drivers/pci] Error 2
> > 
> > FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  arch/ia64/include/asm/topology.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
> > index 76a33a9..32f3af1 100644
> > --- a/arch/ia64/include/asm/topology.h
> > +++ b/arch/ia64/include/asm/topology.h
> > @@ -124,7 +124,7 @@ extern void arch_fix_phys_package_id(int num, u32 slot);
> >  
> >  #define cpumask_of_pcibus(bus)	(pcibus_to_node(bus) == -1 ?		\
> >  				 cpu_all_mask :				\
> > -				 cpumask_from_node(pcibus_to_node(bus)))
> > +				 cpumask_of_node(pcibus_to_node(bus)))
> >  
> >  #include <asm-generic/topology.h>
> >  
> 
> Did I do that?  I could have sworn I test-built on ia64.  But here's the commit,
> and I merged it.

Well, I was too lazy to check who did this. :)

I sent you simply because I thought that you know the correct way to
fix this.


Thanks,


> Sorry about that.
> 
> Mike
> 
> --commit fbb776c3ca4501d5a2821bf1e9bceefcaec7ae47
> Author: Rusty Russell <rusty@rustcorp.com.au>
> Date:   Fri Dec 26 22:23:40 2008 +1030
> 
>     cpumask: IA64: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
> 
> ...
> +#define cpumask_of_pcibus(bus) (pcibus_to_node(bus) == -1 ?            \
> +                                cpu_all_mask :                         \
> +                                cpumask_from_node(pcibus_to_node(bus)))
> +
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
