Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbYKDLER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbYKDLER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 06:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYKDLEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 06:04:01 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:47053 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbYKDLEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 06:04:00 -0500
X-Greylist: delayed 3362 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Nov 2008 06:03:59 EST
Date: Tue, 4 Nov 2008 12:02:53 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Rakib Mullick <rakib.mullick@gmail.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] kernel/cpu.c: Section mismatch warning fix.
Message-ID: <20081104110253.GA7044@uranus.ravnborg.org>
References: <b9df5fa10810292104h38fcee68kae42cf5ab6275fbb@mail.gmail.com> <20081103153425.7282ab84.akpm@linux-foundation.org> <20081104094831.GP23790@elte.hu> <20081104100912.GB6651@uranus.ravnborg.org> <20081104102252.GA14339@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081104102252.GA14339@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2008 at 11:22:52AM +0100, Ingo Molnar wrote:
> 
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > On Tue, Nov 04, 2008 at 10:48:31AM +0100, Ingo Molnar wrote:
> > > 
> > > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > > On Thu, 30 Oct 2008 10:04:54 +0600
> > > > "Rakib Mullick" <rakib.mullick@gmail.com> wrote:
> > > > 
> > > > >  LD      kernel/built-in.o
> > > > > WARNING: kernel/built-in.o(.text+0xb7c8): Section mismatch in
> > > > > reference from the function notify_cpu_starting() to the variable
> > > > > .cpuinit.data:cpu_chain
> > > > > The function notify_cpu_starting() references
> > > > > the variable __cpuinitdata cpu_chain.
> > > > > This is often because notify_cpu_starting lacks a __cpuinitdata
> > > > > annotation or the annotation of cpu_chain is wrong.
> > > > > 
> > > > > This patch fixes the above section mismatch warning. If anything else
> > > > > please notice.
> > > > > Thanks.
> > > > > 
> > > > > Signed-off-by: Md.Rakib H. Mullick <rakib.mullick@gmail.com>
> > > > > 
> > > > > --- linux-2.6-orig/kernel/cpu.c	2008-10-28 20:52:38.000000000 +0600
> > > > > +++ linux-2.6/kernel/cpu.c	2008-10-28 22:46:22.000000000 +0600
> > > > > @@ -462,7 +462,7 @@ out:
> > > > >   * It must be called by the arch code on the new cpu, before the new cpu
> > > > >   * enables interrupts and before the "boot" cpu returns from __cpu_up().
> > > > >   */
> > > > > -void notify_cpu_starting(unsigned int cpu)
> > > > > +void __cpuinit notify_cpu_starting(unsigned int cpu)
> > > > >  {
> > > > >  	unsigned long val = CPU_STARTING;
> > > > 
> > > > arch/alpha/kernel/smp.c calls notify_cpu_starting() from __init code.
> > > > 
> > > > arch/cris/arch-v32/kernel/smp.c calls notify_cpu_starting() from __init code.
> > > > 
> > > > arch/x86/mach-voyager/voyager_smp.c calls notify_cpu_starting() from
> > > > __init code.
> > > > 
> > > > arch/m32r/kernel/smpboot.c calls notify_cpu_starting() from __init code.
> > > > 
> > > > arch/sparc/kernel/sun4d_smp.c calls notify_cpu_starting() from __init code.
> > > > 
> > > > arch/powerpc/kernel/smp.c calls notify_cpu_starting() from __devinit
> > > > code.
> > > > 
> > > > arch/um/kernel/smp.c calls notify_cpu_starting() from .text code.
> > > > 
> > > > 
> > > > The other nine callers call notify_cpu_starting() from __cpuinit code.
> > > > 
> > > > 
> > > > What a mess.
> > > 
> > > __cpuinit seems safe for all but UML.
> > > 
> > > But even for UML it appears to be de-facto safe: as after bootup we 
> > > never return back into arch/um/kernel/smp.c::idle_proc(). (as UML's 
> > >From the list Andrew provided powerpc needs to be looked after.
> > We cannot call an __init function from __devinit context.
> > If you already checked that then no objections.
> 
> the patch/context in question is attached below - in that we weaken 
> the persistency of notify_cpu_starting() from .text to __cpuinit. 
> Which should be safe, right?

The problem is powerpc where we have a __devinit function that
now calls a __cpuinit function.
And last I looked it was possible to tweak the configuration
so we had HOTPLUG enabled but HOTPLUG_CPU disabled in which
case we could end up in a situation where we call
notify_cpu_starting() from __devinit context but we have freed
the __cpuinit memory where notify_cpu_starting() was living.

>From a quick look the annotation in powerpc is wrong
but as it is used from assembler and I did not look carefully
I cannot say for sure.

So until the powerpc case is properly analysed we should hold
on this patch. If this patch is correct then we should also
get powerpc fixed.

	Sam
