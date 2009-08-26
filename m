Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbZHZJnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbZHZJnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 05:43:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbZHZJnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 05:43:13 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:23037 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbZHZJnM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 05:43:12 -0400
X-SpamScore: -39
X-BigFish: VPS-39(z21eWz1102K1432R98dN936eM148cMa4a4ka594izz1202hzzz32i6bh203h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KOZ9NO-02-33U-02
X-M-MSG: 
Date: Wed, 26 Aug 2009 11:42:38 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: James Dingwall <james.dingwall@amdocs.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: BUG: 2.6.30.1 pv_ops kernel boot failure - bisected
Message-ID: <20090826094238.GB8347@alberich.amd.com>
References: <683099EDC3E36D40942EBF636EB88BF00701E35F@batmail1.corp.amdocs.com> <20090825114233.GL20811@alberich.amd.com> <683099EDC3E36D40942EBF636EB88BF00701E3FA@batmail1.corp.amdocs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <683099EDC3E36D40942EBF636EB88BF00701E3FA@batmail1.corp.amdocs.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 26 Aug 2009 09:42:38.0757 (UTC) FILETIME=[8C98FD50:01CA2631]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 02:06:32PM +0100, James Dingwall wrote:
> 
> > > On Tue, Aug 25, 2009 at 12:04:54PM +0100, James Dingwall wrote:
> > > >
> > > > Hi,
> > > >
> > > > I have encountered what appears to be a bug when using the 2.6.30
> > > stable
> > > > series as a pv_ops kernel under Xen 3.4.1.  The problem appears to
> > > have
> > > > been introduced with the following commit (provided I bisected it
> > > > correctly)
> > > >
> > > > commit bb9b409349f533a919b6b6d95698fbe6ff4aa209
> > > > Author: Andreas Herrmann <andreas.herrmann3@amd.com>
> > > > Date:   Mon Jun 8 15:55:09 2009 +0200
> > > >
> > > >     x86: Detect use of extended APIC ID for AMD CPUs
> > > >
> > > > When I try and boot the domU (xm create -c) I do not get any
> > output.
> > > > With this commit reverted I can boot 2.6.30.5 pv_ops without
> issue,
> > > > output follows below.  The system is a dual Opteron 242.  If more
> > > > details about the hardware or configuration are required to debug
> > > this
> > > > please let me know.  I'm willing to test any patches.
> > >
> > >
> > > So it seems that commit
> > >
> > >  commit 2cb078603abb612e3bcd428fb8122c3d39e08832
> > >  Author: Jeremy Fitzhardinge <jeremy@goop.org>
> > >  Date:   Wed Jul 22 09:59:35 2009 -0700
> > >
> > >     x86, amd: Don't probe for extended APIC ID if APICs are disabled
> > >
> > >     If we've logically disabled apics, don't probe the PCI space for
> > > the
> > >     AMD extended APIC ID.
> > >
> > >     [ Impact: prevent boot crash under Xen. ]
> > >
> > >     Signed-off-by: Jeremy Fitzhardinge
> > <jeremy.fitzhardinge@citrix.com>
> > >     Reported-by: Bastian Blank <bastian@waldi.eu.org>
> > >     Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> > >
> > > needs to be added to 2.6.30.y for proper boot under Xen.
> > > James, can you test this please?
> > 
> > Hi Andreas,
> > 
> > That commit won't apply directly on top of 2.6.30.5 as the #ifdef
> which
> > contains it is missing.  However, based on what you suggested I have
> > the following patch below which resolves the problem for me.  Here's
> > hoping it doesn't get munged by my mailer...
> > 
> > James
> > 
> > diff --git a/arch/x86/include/asm/cpufeature.h
> > b/arch/x86/include/asm/cpufeature.h
> > index bb83b1c..2f5ebf1 100644
> > --- a/arch/x86/include/asm/cpufeature.h
> > +++ b/arch/x86/include/asm/cpufeature.h
> > @@ -94,6 +94,7 @@
> >  #define X86_FEATURE_TSC_RELIABLE (3*32+23) /* TSC is known to be
> > reliable */
> >  #define X86_FEATURE_NONSTOP_TSC        (3*32+24) /* TSC does not stop
> > in C states */
> >  #define X86_FEATURE_CLFLUSH_MONITOR (3*32+25) /* "" clflush reqd with
> > monitor */
> > +#define X86_FEATURE_EXTD_APICID (3*32+26) /* has extended APICID (8
> > bits) */
> > 
> >  /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4
> */
> >  #define X86_FEATURE_XMM3       (4*32+ 0) /* "pni" SSE-3 */
> > diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> > index 0a9092f..61a592e 100644
> > --- a/arch/x86/kernel/cpu/amd.c
> > +++ b/arch/x86/kernel/cpu/amd.c
> > @@ -6,6 +6,7 @@
> >  #include <asm/processor.h>
> >  #include <asm/apic.h>
> >  #include <asm/cpu.h>
> > +#include <asm/pci-direct.h>
> > 
> >  #ifdef CONFIG_X86_64
> >  # include <asm/numa_64.h>
> > @@ -353,6 +354,15 @@ static void __cpuinit early_init_amd(struct
> > cpuinfo_x86 *c)
> >                     (c->x86_model == 8 && c->x86_mask >= 8))
> >                         set_cpu_cap(c, X86_FEATURE_K6_MTRR);
> >  #endif
> > +#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_PCI)
> > +       /* check CPU config space for extended APIC ID */
> > +       if (cpu_has_apic && c->x86 >= 0xf) {
> > +               unsigned int val;
> > +               val = read_pci_config(0, 24, 0, 0x68);
> > +               if ((val & ((1 << 17) | (1 << 18))) == ((1 << 17) | (1
> > << 18)))
> > +                       set_cpu_cap(c, X86_FEATURE_EXTD_APICID);
> > +       }
> > +#endif
> >  }
> > 
> >  static void __cpuinit init_amd(struct cpuinfo_x86 *c)
> > 
> 
> Ok - my mistake.  I'm a unfamiliar with git so after I reverted the
> commit I was testing I thought that a reset would take it back to the
> unmodified 2.6.30.5 release.  In fact the commit
> 2cb078603abb612e3bcd428fb8122c3d39e08832 does apply directly on top of
> this and solves the problem.
> 

So this commit should be integrated in 2.6.30 stable tree.
Will take care of this soon.

Thanks for testing.


Regards,

Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


