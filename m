Return-Path: <linux-kernel-owner+w=401wt.eu-S1764610AbYEIQt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764610AbYEIQt2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 12:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbYEIQtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 12:49:20 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:56984 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746AbYEIQtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 12:49:19 -0400
Date: Fri, 9 May 2008 19:47:50 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Glauber Costa <glommer@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Glauber Costa <gcosta@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "Carlos R. Mafra" <crmafra2@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Possible regression? 2.6.26-rc1: T61s failure after
	suspend/resume
Message-ID: <20080509164750.GB13897@cs181133002.pp.htv.fi>
References: <E1JuCBA-0002NZ-4E@closure.thunk.org> <Pine.LNX.4.64.0805082148060.3994@blonde.site> <5d6222a80805090828j1a1af054y547640c3408bca1b@mail.gmail.com> <Pine.LNX.4.64.0805091706390.11688@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805091706390.11688@blonde.site>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 05:21:14PM +0100, Hugh Dickins wrote:
> On Fri, 9 May 2008, Glauber Costa wrote:
> > 
> > I can't reproduce it neither, and looking at the code over and over
> > again, see no obvious point for the breakage. I'll try to reproduce it
> > myself,
> > to see if I can spot something. But correct me if I'm wrong, this is
> > all 64-bit machines, right?
> > 
> > I'm stuck with mostly 32-bit hardware, but will give it a try anyway.
> 
> The machine is 64-bit capable (Core2 Duo), but the kernels I'm running
> for this are 32-bit, so I doubt that the 64-bitability is relevant.
> I'd love to see what happens with a 64-bit kernel, but I never get
> back from suspend with it (and that's not a recent regression).
> Carlos is also seeing this with a 32-bit kernel (on P4 Xeon with HT).
> 
> Please don't take my git bisection result too seriously: that's where
> it led when I fudged things around enough, and treated blank screens
> as manifestations of the problem, which very likely they're not
> (there's some other bug which makes it very variable how quickly
> I resume).  And also, I wasn't checking how many cpus came up each
> time: I wouldn't be surprised if at some points in your series only
> one would come up, which would then look like a "good" point to me.

For 64bit kernels this commit seems to be a nop, but not for
32bit kernels.

Looking at commit 4fe29a85642544503cf81e9cf251ef0f4e65b162 it contained 
two changes for 32bit SMP kernels:
- it enables the previously not enabled HAVE_SETUP_PER_CPU_AREA
- the following hunk:

--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -665,6 +665,7 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
 		unmap_cpu_to_logical_apicid(cpu);
 		cpu_clear(cpu, cpu_callout_map); /* was set here (do_boot_cpu()) */
 		cpu_clear(cpu, cpu_initialized); /* was set by cpu_init() */
+		cpu_clear(cpu, cpu_possible_map);
 		cpucount--;
 	} else {
 		per_cpu(x86_cpu_to_apicid, cpu) = apicid;
@@ -743,6 +744,7 @@ EXPORT_SYMBOL(xquad_portio);
 
 static void __init disable_smp(void)
 {
+	cpu_possible_map = cpumask_of_cpu(0);
 	smpboot_clear_io_apic_irqs();
 	phys_cpu_present_map = physid_mask_of_physid(0);
 	map_cpu_to_logical_apicid();



Before assuming the bisection pointed to a wrong commit it might be 
worth checking these.

BTW:
I don't understand why these were mixed into a commit that
moved much stuff previously only used on 64bit kernels from 
arch/x86/kernel/setup64.c to arch/x86/kernel/setup.c ...


> Thanks,
> Hugh

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

