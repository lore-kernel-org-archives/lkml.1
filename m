Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453AbYKCTAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbYKCTAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 14:00:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbYKCTAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 14:00:20 -0500
Received: from gv-out-0910.google.com ([216.239.58.190]:61059 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbYKCTAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 14:00:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=xmJ4ENMk8SbPSMMSQUiO/5bEkuGhdRv6oyJrO5A4fz0jov0yIeLxLxGc1etWYx3fJn
         tmeES6vVaz96NL1x5U6SnQP0tazoS+IMjYGpjfOSmAZXFZlqeW0NiBiOhEgT+AcLzLen
         L4d2QBTjxqEbHKsxEErOwHxnqhoHO8Z/URckM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: akataria@vmware.com
Subject: Re: upstream regression (IO-APIC?)
Date: Mon, 3 Nov 2008 19:57:37 +0100
User-Agent: KMail/1.9.10
Cc: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Robert Hancock <hancockr@shaw.ca>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Machek <pavel@suse.cz>
References: <fa.mewpISr5S4wcdUNw1DVfOnQfl8s@ifi.uio.no> <200811022124.24992.bzolnier@gmail.com> <1225734574.8168.16.camel@alok-dev1>
In-Reply-To: <1225734574.8168.16.camel@alok-dev1>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811031957.38076.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday 03 November 2008, Alok Kataria wrote:
> On Sun, 2008-11-02 at 12:24 -0800, Bartlomiej Zolnierkiewicz wrote:
> > On Sunday 02 November 2008, Bartlomiej Zolnierkiewicz wrote:
> > > On Thursday 30 October 2008, Robert Hancock wrote:
> > > > Bartlomiej Zolnierkiewicz wrote:
> > > > > The current Linus tree as of commit e946217e4fdaa67681bbabfa8e6b18641921f750
> > > > > is broken for me.  I get either the following panic (see log from qemu below)
> > > > > or lost IRQs on ATA init...  Is this a known issue?
> > > > > 
> > > > > PS The tree that I used before and was supposedly good (sorry, I'm too tired
> > > > > to verify it now) had commit 57f8f7b60db6f1ed2c6918ab9230c4623a9dbe37 at head.
> > > 
> > > Unfortunately 57f8f7b60db6f1ed2c6918ab9230c4623a9dbe37 (v2.6.28-rc1)
> > > is also bad.  Bisecting it further was a real pain (i.e. I hit broken
> > > build with x86 irqbalance changes, broken build with netfilter nat
> > > changes and jbd journal problem).  In the end it turned out that 2.6.27
> > > is bad too!  However with 2.6.27 the panic occurs only once per several
> > > attempts and if there is no panic kernel boots normally (no lost IRQs).
> > > 
> > > [...]
> > > 
> > > I finally managed to narrow it down to change making x86 use tsc_khz
> > > for loops_per_jiffy -- commit 3da757daf86e498872855f0b5e101f763ba79499
> > > ("x86: use cpu_khz for loops_per_jiffy calculation").  This approach
> > > seems too simplistic (as I see now Arjan & Pavel expressed concerns
> > > about it back when the patch was posted initially [1][2]).  Also it
> > > would probably be preferred to re-use existing preset_lpj variable
> > > (just like KVM does it for similar purpose [3]) instead of adding a
> > > lpj_tsc one and increasing complexity.
> > 
> > It turned out that I can boot a kernel with different config with
> > HZ == 250 just fine and switching to HZ == 1000 makes it fail.
> > 
> > 
> > Looking into it some more:
> > 
> > HZ == 250 kernel (good):
> > 
> > Calibrating delay loop (skipped), value calculated using timer frequency.. 2986.79 BogoMIPS (lpj=5973580)
> > 
> > HZ == 1000 kernel (bad):
> > 
> > Calibrating delay loop (skipped), using tsc calculated value.. 2990.35 BogoMIPS (lpj=1495176)
> > 
> > HZ == 1000 kernel with hackyfix (good):
> > 
> > Calibrating delay using timer specific routine.. 3016.68 BogoMIPS (lpj=6033376)
> > 
> > 
> > Argggh... lpj is used for udelay() & friends so this bug is quite
> > dangerous (since udelay() & friends are used for hardware delays)...
> > 
> > [ The commit works for HZ == 250 because it does tsc_khz * 1000 / HZ,
> >   tsc_khz * 4 => lpj assumption holds true and there is no frequency
> >   scaling at boot. ]
> > 
> > The quick fix would be to replace 1000 / HZ by the magic number "4"
> 
> That's not right, the magic number 4 thing would not be correct.
> On one of my systems for eg, i get this in dmesg
> 
> Detected 2010.400 MHz processor.
> ...
> Calibrating delay using timer specific routine.. 4022.47 BogoMIPS
> (lpj=2011235)
> 
> This is with an earlier kernel, the HZ value is 1000. And the lpj value
> that we get from the calculation of (tsc_khz * 1000)/HZ is correct in
> this case.  And on all the systems that i have checked this assumption
> holds true.

Yes, I realized this once I tried to reproduce issue on the real h/w.

> One of the things that i suspect is that you are not using delay_tsc in
> this case, i.e. tsc is not used for delay which is causing that panic
> 
> can you please try the patch below on your system ? 
> 
> [test-patch]
> 
> Index: linux-2.6/arch/x86/kernel/tsc.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/tsc.c	2008-10-15 10:51:14.000000000 -0700
> +++ linux-2.6/arch/x86/kernel/tsc.c	2008-11-03 09:43:01.000000000 -0800
> @@ -847,10 +847,6 @@
>  		cpu_khz = calibrate_cpu();
>  #endif
>  
> -	lpj = ((u64)tsc_khz * 1000);
> -	do_div(lpj, HZ);
> -	lpj_fine = lpj;
> -
>  	printk("Detected %lu.%03lu MHz processor.\n",
>  			(unsigned long)cpu_khz / 1000,
>  			(unsigned long)cpu_khz % 1000);
> @@ -871,6 +867,10 @@
>  	tsc_disabled = 0;
>  
>  	use_tsc_delay();
> +	lpj = ((u64)tsc_khz * 1000);
> +	do_div(lpj, HZ);
> +	lpj_fine = lpj;
> +
>  	/* Check and install the TSC clocksource */
>  	dmi_check_system(bad_tsc_dmi_table);
>  	check_system_tsc_reliable();

Didn't help but it looks like we should apply it anyway
(so "notsc" continues to work as before).

Thanks,
Bart
