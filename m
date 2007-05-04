Return-Path: <linux-kernel-owner+w=401wt.eu-S1161538AbXEDVrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161538AbXEDVrb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 17:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031718AbXEDVrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 17:47:31 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59850 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031716AbXEDVra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 17:47:30 -0400
Subject: Re: [PATCH] Blacklist Dell Optiplex 320 from using the HPET
From: john stultz <johnstul@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Guilherme M. Schroeder" <guilherme@centralinf.com.br>,
       lkml <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070504144408.c041d8df.akpm@linux-foundation.org>
References: <1178314144.6094.7.camel@localhost.localdomain>
	 <20070504144408.c041d8df.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 04 May 2007 14:47:27 -0700
Message-Id: <1178315247.6094.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-04 at 14:44 -0700, Andrew Morton wrote:
> On Fri, 04 May 2007 14:29:04 -0700
> john stultz <johnstul@us.ibm.com> wrote:
> 
> > One of the 2.6.21 regressions was Guilherme's problem seeing his box
> > lock up when the system detected an unstable TSC and dropped back to
> > using the HPET.
> > 
> > In digging deeper, we found the HPET is not actually incrementing on
> > this system. And in fact, the reason why this issue just cropped up was
> > because of Thomas's clocksource watchdog code was comparing the TSC to
> > the HPET (which wasn't moving) and thought the TSC was broken.
> > 
> > Anyway, Guliherme checked for a BIOS update and did not find one, so
> > I've added a DMI blacklist against his system so the HPET is not used.
> > 
> > Many thanks to Guilherme for the slow and laborious testing that finally
> > narrowed down this issue.
> > 
> 
> OK, I tagged that for -stable too.

Thanks.


> > 
> > diff --git a/arch/i386/kernel/hpet.c b/arch/i386/kernel/hpet.c
> > index 17d7345..1ae27f3 100644
> > --- a/arch/i386/kernel/hpet.c
> > +++ b/arch/i386/kernel/hpet.c
> > @@ -5,6 +5,7 @@
> >  #include <linux/init.h>
> >  #include <linux/sysdev.h>
> >  #include <linux/pm.h>
> > +#include <linux/dmi.h>
> >  
> >  #include <asm/hpet.h>
> >  #include <asm/io.h>
> > @@ -48,6 +49,31 @@ static int __init hpet_setup(char* str)
> >  }
> >  __setup("hpet=", hpet_setup);
> >  
> > +
> > +/* DMI Blacklist for bad HPETs */
> > +static int __init dmi_mark_hpet_broken(struct dmi_system_id *d)
> > +{
> > +	printk(KERN_NOTICE "%s detected: HPET does not function.\n",
> > +		       d->ident);
> > +	boot_hpet_disable = 1;
> > +	return 0;
> > +}
> > +
> > +/* List of systems that have known HPETproblems */
> > +static struct dmi_system_id bad_hpet_dmi_table[] = {
> > +	{
> > +	 .callback = dmi_mark_hpet_broken,
> > +	 .ident = "Dell OptiPlex 320",
> > +	 .matches = {
> > +		     DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 320"),
> > +		     DMI_MATCH(DMI_BOARD_VENDOR, "Dell Inc."),
> > +		     DMI_MATCH(DMI_BOARD_NAME, "0UT237"),
> > +		     },
> > +	 },
> > +	 {}
> > +};
> > +
> > +
> >  static inline int is_hpet_capable(void)
> >  {
> >  	return (!boot_hpet_disable && hpet_address);
> > @@ -228,6 +254,8 @@ int __init hpet_enable(void)
> >  	uint64_t hpet_freq;
> >  	u64 tmp;
> >  
> > +	dmi_check_system(bad_hpet_dmi_table);
> > +
> >  	if (!is_hpet_capable())
> >  		return 0;
> 
> The table can be __initdata, can't it?

Yep. Thanks for catching that.

-john



