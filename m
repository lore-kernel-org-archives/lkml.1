Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbYEIOWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbYEIOWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 10:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750755AbYEIOWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 10:22:35 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49664 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750816AbYEIOWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 10:22:33 -0400
Subject: Re: build issue #380 for v2.6.26-rc1-279-g28a4acb : mach-voyager:
	multiple definition of `phys_cpu_present_map'
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, toralf.foerster@gmx.de,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Travis <travis@sgi.com>
In-Reply-To: <20080509095837.GB19617@elte.hu>
References: <200805091114.00244.toralf.foerster@gmx.de>
	 <20080509095244.GJ2543@hacking>  <20080509095837.GB19617@elte.hu>
Content-Type: text/plain
Date: Fri, 09 May 2008 09:22:26 -0500
Message-Id: <1210342946.3069.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-09 at 11:58 +0200, Ingo Molnar wrote:
> * WANG Cong <xiyou.wangcong@gmail.com> wrote:
> 
> > Sorry. Ignore previous one. This one should be correct, I think.
> > 
> > ---
> > 
> > diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
> > index 8acbf0c..2e8388b 100644
> > --- a/arch/x86/mach-voyager/voyager_smp.c
> > +++ b/arch/x86/mach-voyager/voyager_smp.c
> > @@ -74,7 +74,7 @@ EXPORT_SYMBOL(cpu_online_map);
> >  
> >  /* Bitmask of CPUs present in the system - exported by i386_syms.c, used
> >   * by scheduler but indexed physically */
> > -cpumask_t phys_cpu_present_map = CPU_MASK_NONE;
> > +static cpumask_t phys_cpu_present_map = CPU_MASK_NONE;
> 
> i've got the one below queued up but it's stalled as it could easily be 
> wrong and there's no ack from James yet and there's been discussion back 
> and forth. James, what do you suggest?
> 
> 	Ingo
> 
> -------------------->
> Subject: x86, voyager: build fix
> From: Ingo Molnar <mingo@elte.hu>
> Date: Sun May 04 23:56:30 CEST 2008
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/mach-voyager/voyager_smp.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-x86.q/arch/x86/mach-voyager/voyager_smp.c
> ===================================================================
> --- linux-x86.q.orig/arch/x86/mach-voyager/voyager_smp.c
> +++ linux-x86.q/arch/x86/mach-voyager/voyager_smp.c
> @@ -74,7 +74,7 @@ EXPORT_SYMBOL(cpu_online_map);
>  
>  /* Bitmask of CPUs present in the system - exported by i386_syms.c, used
>   * by scheduler but indexed physically */
> -cpumask_t phys_cpu_present_map = CPU_MASK_NONE;
> +extern cpumask_t phys_cpu_present_map;
>  
>  /* The internal functions */
>  static void send_CPI(__u32 cpuset, __u8 cpi)

I already told you that this was incorrect.  This is what I sent as the
replacement on 28 April and I didn't hear back from you.

http://marc.info/?l=linux-kernel&m=120941111400620

James

---

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c0c68c1..808daf1 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -12,6 +12,7 @@
 #include <asm/mpspec.h>
 #include <asm/apicdef.h>
 
+#ifdef CONFIG_X86_MPPARSE
 unsigned int num_processors;
 unsigned disabled_cpus __cpuinitdata;
 /* Processor that is doing the boot up */
@@ -23,8 +24,9 @@ EXPORT_PER_CPU_SYMBOL(x86_cpu_to_apicid);
 
 /* Bitmask of physically existing CPUs */
 physid_mask_t phys_cpu_present_map;
+#endif
 
-#if defined(CONFIG_HAVE_SETUP_PER_CPU_AREA) && defined(CONFIG_SMP)
+#if defined(CONFIG_HAVE_SETUP_PER_CPU_AREA) && defined(CONFIG_X86_SMP)
 /*
  * Copy data used in early init routines from the initial arrays to the
  * per cpu data areas.  These arrays then become expendable and the



