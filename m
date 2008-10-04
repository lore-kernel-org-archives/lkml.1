Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbYJDWbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbYJDWbf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 18:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbYJDWb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 18:31:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45098 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938AbYJDWb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 18:31:27 -0400
Date: Sat, 4 Oct 2008 18:30:14 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: <PING> Re: [patch x86/core] x86: allow number of additional
 hotplug CPUs to be set at compile time
Message-ID: <20081004183014.769836ff@redhat.com>
In-Reply-To: <87ljx4nw09.fsf_-_@basil.nowhere.org>
References: <20081001191945.4182d0be@redhat.com>
	<87bpy3pdgs.fsf@basil.nowhere.org>
	<20081002152521.16c4835b@redhat.com>
	<20081002194409.GB8318@one.firstfloor.org>
	<20081002160907.68d79e0b@redhat.com>
	<20081002204018.GD8318@one.firstfloor.org>
	<87ljx4nw09.fsf_-_@basil.nowhere.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 04 Oct 2008 18:52:06 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> 
> Ping? Can you please test the patch?  I think that's the correct fix.
>  
> I see Ingo unfortunately merged your initial broken hack, but it's wrong
> and when actually used on a distribution will break real CPU hotplug there.
> Please don't enable that CONFIG option in Fedora. Ideally drop
> the CONFIG patch completely because it cannot do much good.
> 
> It should be replaced with the appended patch, which should go into 2.6.27
> after it is confirmed to fix the problem.
> 

Yes, it works and I don't see how it could cause any problems.

Ingo, can we get this in 2.6.27? You can drop my original patch.

Tested-by: Chuck Ebbert <cebbert@redhat.com>

> > ---
> >
> > Take disabled cpus into account in alternative.c
> >
> > Otherwise an UP system with one hotplug CPU will not 
> > go into UP mode.
> >
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> >
> > Index: linux-2.6.27-rc4-misc/arch/x86/kernel/alternative.c
> > ===================================================================
> > --- linux-2.6.27-rc4-misc.orig/arch/x86/kernel/alternative.c
> > +++ linux-2.6.27-rc4-misc/arch/x86/kernel/alternative.c
> > @@ -454,7 +454,7 @@ void __init alternative_instructions(voi
> >  					    _text, _etext);
> >  
> >  		/* Only switch to UP mode if we don't immediately boot others */
> > -		if (num_possible_cpus() == 1 || setup_max_cpus <= 1)
> > +		if (num_possible_cpus() - additional_cpus == 1 || setup_max_cpus <= 1)
> >  			alternatives_smp_switch(0);
> >  	}
> >  #endif
> > Index: linux-2.6.27-rc4-misc/arch/x86/kernel/smpboot.c
> > ===================================================================
> > --- linux-2.6.27-rc4-misc.orig/arch/x86/kernel/smpboot.c
> > +++ linux-2.6.27-rc4-misc/arch/x86/kernel/smpboot.c
> > @@ -1276,7 +1276,7 @@ static void remove_siblinginfo(int cpu)
> >  	cpu_clear(cpu, cpu_sibling_setup_map);
> >  }
> >  
> > -static int additional_cpus __initdata = -1;
> > +int additional_cpus = -1;
> >  
> >  static __init int setup_additional_cpus(char *s)
> >  {
> > Index: linux-2.6.27-rc4-misc/include/asm-x86/smp.h
> > ===================================================================
> > --- linux-2.6.27-rc4-misc.orig/include/asm-x86/smp.h
> > +++ linux-2.6.27-rc4-misc/include/asm-x86/smp.h
> > @@ -204,5 +204,7 @@ static inline int hard_smp_processor_id(
> >  extern void cpu_uninit(void);
> >  #endif
> >  
> > +extern int additional_cpus;
> > +
> >  #endif /* __ASSEMBLY__ */
> >  #endif
> > -- 
> > ak@linux.intel.com
> 
