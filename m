Return-Path: <linux-kernel-owner+w=401wt.eu-S1763938AbYDYQeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763938AbYDYQeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 12:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760265AbYDYQeC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 12:34:02 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48106 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759319AbYDYQeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 12:34:00 -0400
Subject: Re: Voyager phys_cpu_present_map compile error
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Alexey Starikovskiy <astarikovskiy@suse.de>,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080425161745.GA21168@cs181133002.pp.htv.fi>
References: <20080421000238.GD26897@cs181133002.pp.htv.fi>
	 <20080421085314.GI26897@cs181133002.pp.htv.fi>
	 <20080421120054.GA6788@elte.hu>
	 <20080421132705.GG6011@cs181133002.pp.htv.fi>
	 <20080421201434.GN8770@elte.hu>
	 <1209135044.3087.3.camel@localhost.localdomain>
	 <20080425161745.GA21168@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Fri, 25 Apr 2008 11:33:53 -0500
Message-Id: <1209141233.3087.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-25 at 19:17 +0300, Adrian Bunk wrote:
> On Fri, Apr 25, 2008 at 09:50:43AM -0500, James Bottomley wrote:
> > On Mon, 2008-04-21 at 22:14 +0200, Ingo Molnar wrote:
> > > * Adrian Bunk <bunk@kernel.org> wrote:
> > > 
> > > > > +#ifndef CONFIG_X86_VOYAGER
> > > > >  /* Bitmask of physically existing CPUs */
> > > > >  physid_mask_t phys_cpu_present_map;
> > > > > +#endif
> > > > >...
> > > > 
> > > > Alexey noted that phys_cpu_present_map for Voyager and !Voyager also 
> > > > have different types and suggested to make the Voyager one static 
> > > > instead (additional renaming of the Voyager one also makes sense).
> > > 
> > > yep, done by the patch below.
> > 
> > Actually, this isn't the right patch.  The point is not to avoid the
> > symbol clash, it's to let voyager identify correctly that you have a
> > leaking symbol.  In this case phys_cpu_present_map is exposed outside of
> > SMP.  The correct fix (and one which sweeps op other storage for
> > unnecessary symbols is this):
> > 
> > James
> > 
> > ---
> > 
> > diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> > index c0c68c1..d68aa53 100644
> > --- a/arch/x86/kernel/setup.c
> > +++ b/arch/x86/kernel/setup.c
> > @@ -12,6 +12,7 @@
> >  #include <asm/mpspec.h>
> >  #include <asm/apicdef.h>
> >  
> > +#ifdef CONIFG_X86_SMP
> >...
> 
> tpyo  ;)

Oh ... oops ... unfortunately one I wouldn't spot in a voyager build.

This should be the corrected patch; thanks.

James

---

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c0c68c1..13ea170 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -12,6 +12,7 @@
 #include <asm/mpspec.h>
 #include <asm/apicdef.h>
 
+#ifdef CONFIG_X86_SMP
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


