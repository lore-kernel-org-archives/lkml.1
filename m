Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbYGaWN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbYGaWN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 18:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759989AbYGaWNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 18:13:08 -0400
Received: from 1wt.eu ([62.212.114.60]:2321 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759937AbYGaWNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 18:13:07 -0400
Date: Fri, 1 Aug 2008 00:11:45 +0200
From: Willy Tarreau <w@1wt.eu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] x86: fdiv bug detection fix
Message-ID: <20080731221145.GD615@1wt.eu>
References: <20080731234344.eb3c4ed2.krzysztof.h1@wp.pl> <20080731144920.0016e02d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080731144920.0016e02d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 02:49:20PM -0700, Andrew Morton wrote:
> On Thu, 31 Jul 2008 23:43:44 +0200
> Krzysztof Helt <krzysztof.h1@wp.pl> wrote:
> 
> > From: Krzysztof Helt <krzysztof.h1@wp.pl>
> > 
> > The fdiv detection code writes s32 integer into
> > the boot_cpu_data.fdiv_bug. 
> > However, the boot_cpu_data.fdiv_bug is only char (s8)
> > field so the detection overwrites already set fields for
> > other bugs, e.g. the f00f bug field.
> > 
> > Use local s32 variable to receive result.
> > 
> > Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
> > ---
> > 
> > This is a partial fix to Bugzilla #9928  - fixes wrong 
> > information about the f00f bug (tested) and probably
> > for coma bug (I have no cpu to test this).
> > 
> > diff -urp linux-alsa/arch/x86/kernel/cpu/bugs.c linux-new/arch/x86/kernel/cpu/bugs.c
> > --- linux-alsa/arch/x86/kernel/cpu/bugs.c	2008-07-31 12:40:31.000000000 +0200
> > +++ linux-new/arch/x86/kernel/cpu/bugs.c	2008-07-31 23:24:07.722657435 +0200
> > @@ -50,6 +50,8 @@ static double __initdata y = 3145727.0;
> >   */
> >  static void __init check_fpu(void)
> >  {
> > +	s32 fdiv_bug;
> > +
> >  	if (!boot_cpu_data.hard_math) {
> >  #ifndef CONFIG_MATH_EMULATION
> >  		printk(KERN_EMERG "No coprocessor found and no math emulation present.\n");
> > @@ -74,8 +76,10 @@ static void __init check_fpu(void)
> >  		"fistpl %0\n\t"
> >  		"fwait\n\t"
> >  		"fninit"
> > -		: "=m" (*&boot_cpu_data.fdiv_bug)
> > +		: "=m" (*&fdiv_bug)
> >  		: "m" (*&x), "m" (*&y));
> > +
> > +	boot_cpu_data.fdiv_bug = fdiv_bug;
> >  	if (boot_cpu_data.fdiv_bug)
> >  		printk("Hmm, FPU with FDIV bug.\n");
> >  }
> 
> hm, the code seems to have been that way for quite some time.

Indeed! since boot_cpu_data.fdiv_bug was declared as an int in 2.4, I
think it might have changed when a lot of code was moved from asm/*.h
to arch/*.c.

> I wonder why nobody noticed this before.

For the same reason those bugs were noticed very late in the products'
lifetime I guess : because unless someone actively plays with them on
your machine, you hardly trigger them by accident.

Willy

