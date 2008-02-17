Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbYBQJza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbYBQJza (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 04:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754530AbYBQJzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 04:55:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:7264 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249AbYBQJzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 04:55:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=akbft/abNJwOPpSNbQULYOI8Lsb57lZEd928LL2zL20TvLdBUR8LQ7vEOgBPYpeUQbZl2+ylVffG8Qia3cAQ95Zy/Jfra8dg2xq/X2jFFVKMTAHwpOmB+H/ikuAcDrlstxAcXI+4AGAXyLNyz3L+Iqp9/XE2bHcg9UOG8jNtZAk=
Date: Sun, 17 Feb 2008 10:54:32 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Russell Leidich <rml@google.com>, Pavel Machek <pavel@suse.cz>,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc2-mm1: build failure (x86)
Message-ID: <20080217095426.GA6054@joi>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <20080216030949.5b11ba4c.akpm@linux-foundation.org> <20080216113722.GA9041@joi> <200802170122.12669.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802170122.12669.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 01:22:11AM +0100, Rafael J. Wysocki wrote:
> On Saturday, 16 of February 2008, Marcin Slusarz wrote:
> > On Sat, Feb 16, 2008 at 03:09:49AM -0800, Andrew Morton wrote:
> > > On Sat, 16 Feb 2008 11:59:07 +0100 Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> > > 
> > > > arch/x86/kernel/built-in.o: In function `amd_smp_thermal_interrupt':
> > > > (.text+0xe03b): undefined reference to `mce_log_therm_throt_event'
> 
> This one is easily fixed by the appended patch (whether it works is a separate
> issue, though).
Yes. It fixed compilation error.
 
> > > > arch/x86/kernel/built-in.o: In function `acpi_save_state_mem':
> > > > (.text+0x12239): undefined reference to `setup_trampoline'
> > > > 
> > > > #
> > > > # Automatically generated make config: don't edit
> > > > # Linux kernel version: 2.6.25-rc2-mm1
> > > > # Sat Feb 16 11:32:49 2008
> > > 
> > > ho hum, thanks.  I think I'll drop x86-amd-thermal-interrupt-support.patch.
> > >  I don't think it's the final version anwyay.
> > > 
> > Ok, I had to revert x86-remove-pt_regs-arg-from-smp_thermal_interrupt before x86-amd-thermal-interrupt-support.
> > 
> > Second error vanished when I reverted "suspend: wakeup code in C".
> 
> It will compile if you set CONFIG_SMP.  Working on a fix.
> 
> Thanks,
> Rafael
> 
> 
> ---
>  arch/x86/kernel/cpu/mcheck/mce_64.c      |    4 ++--
>  arch/x86/kernel/cpu/mcheck/mce_thermal.h |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6.25-rc2-mm1/arch/x86/kernel/cpu/mcheck/mce_64.c
> ===================================================================
> --- linux-2.6.25-rc2-mm1.orig/arch/x86/kernel/cpu/mcheck/mce_64.c
> +++ linux-2.6.25-rc2-mm1/arch/x86/kernel/cpu/mcheck/mce_64.c
> @@ -317,7 +317,7 @@ void do_machine_check(struct pt_regs * r
>  	atomic_dec(&mce_entry);
>  }
>  
> -#ifdef CONFIG_X86_MCE_INTEL
> +#ifdef CONFIG_X86_MCE
>  /***
>   * mce_log_therm_throt_event - Logs the thermal throttling event to mcelog
>   * @cpu: The CPU on which the event occurred.
> @@ -342,7 +342,7 @@ void mce_log_therm_throt_event(unsigned 
>  	rdtscll(m.tsc);
>  	mce_log(&m);
>  }
> -#endif /* CONFIG_X86_MCE_INTEL */
> +#endif /* CONFIG_X86_MCE */
>  
>  /*
>   * Periodic polling timer for "silent" machine check errors.  If the
> Index: linux-2.6.25-rc2-mm1/arch/x86/kernel/cpu/mcheck/mce_thermal.h
> ===================================================================
> --- linux-2.6.25-rc2-mm1.orig/arch/x86/kernel/cpu/mcheck/mce_thermal.h
> +++ linux-2.6.25-rc2-mm1/arch/x86/kernel/cpu/mcheck/mce_thermal.h
> @@ -4,5 +4,5 @@
>  typedef void (*smp_thermal_interrupt_callback_t)(void);
>  extern smp_thermal_interrupt_callback_t	smp_thermal_interrupt;
>  
> -void mce_log_therm_throt_event(unsigned int cpu, __u64 status);
> +extern void mce_log_therm_throt_event(unsigned int cpu, __u64 status);
>  
