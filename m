Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbXIYSyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbXIYSyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 14:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbXIYSyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 14:54:25 -0400
Received: from dxa01.wellsfargo.com ([151.151.65.117]:53086 "EHLO
	dxa01.wellsfargo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbXIYSyY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 14:54:24 -0400
X-Greylist: delayed 4934 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Sep 2007 14:54:24 EDT
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.0.6619.12
Subject: RE: [PATCH 1/1] Kernel compile bug in 2.6.22.6/7 {maybe more} ARM/StrongARM
Date: Tue, 25 Sep 2007 12:31:38 -0500
Message-ID: <1E7A4807A136DF45AD33DB341D93C3BD1F0C7F@msgswbmnmsp46.wellsfargo.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] Kernel compile bug in 2.6.22.6/7 {maybe more} ARM/StrongARM
Thread-Index: Acf/Rt742t8eqZ1xSye1EAep+XEjIwAUuEtw
References: <1E7A4807A136DF45AD33DB341D93C3BD1F0C19@msgswbmnmsp46.wellsfargo.com> <20070925073132.GA29127@flint.arm.linux.org.uk>
From: <Greg.Chandler@wellsfargo.com>
To: <rmk+lkml@arm.linux.org.uk>, <cpufreq@lists.linux.org.uk>,
       <davej@redhat.com>
Cc: <linux-kernel@vger.kernel.org>, <dan.j.williams@intel.com>
X-OriginalArrivalTime: 25 Sep 2007 17:31:39.0399 (UTC) FILETIME=[EE277170:01C7FF99]
X-WFMX: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Well then, now I guess I know why the FB isn't working...
Sorry to open up the can of worms this turned out to be {after reading
all the other replies first}...

 

-----Original Message-----
From: Russell King [mailto:rmk@arm.linux.org.uk] On Behalf Of Russell
King
Sent: Tuesday, September 25, 2007 2:32 AM
To: Chandler, Greg; cpufreq@lists.linux.org.uk; davej@redhat.com
Cc: linux-kernel@vger.kernel.org; dan.j.williams@intel.com
Subject: Re: [PATCH 1/1] Kernel compile bug in 2.6.22.6/7 {maybe more}
ARM/StrongARM

On Mon, Sep 24, 2007 at 05:53:57PM -0500, Greg.Chandler@wellsfargo.com
wrote:
> I was building a kernel for an iPaq {SA1110} and ran into this.
> 
> linux-2.6.22.7/arch/arm/mach-sa1100/generic.c:
> Has a: #include <linux/cpufreq.h>
> Then afterwards there is a: #if defined(CONFIG_CPU_FREQ_SA1100) ||
> defined(CONFIG_CPU_FREQ_SA1110)
> who's else section redefines the cpufreq_get function inhereited from 
> the header....
> 
> I'm guessing no one ever ended up in the "else" section until now, and

> that the header was added some time ago and no one caught this.
> This patch worked for me to get rid of the compile time problems.  I'm

> having issues with the kernel, but as far as I can tell they are form 
> the Frame buffer and not because of this.  If this assessment is 
> correct {the not needing this code anymore} then please pass this 
> along so it makes it into an upcoming release.
> 
> --- linux-2.6.22.7/arch/arm/mach-sa1100/generic.c.orig  2007-09-24 
> 17:36:21.000000000 -0500
> +++ linux-2.6.22.7/arch/arm/mach-sa1100/generic.c       2007-09-24
> 17:40:02.000000000 -0500
> @@ -107,15 +107,6 @@ unsigned int sa11x0_getspeed(unsigned in
>         return cclk_frequency_100khz[PPCR & 0xf] * 100;  }
> 
> -#else
> -/*
> - * We still need to provide this so building without cpufreq works.
> - */
> -unsigned int cpufreq_get(unsigned int cpu) -{
> -       return cclk_frequency_100khz[PPCR & 0xf] * 100;
> -}
> -EXPORT_SYMBOL(cpufreq_get);
>  #endif
> 
>  /*

No.  That code is required - the StrongARM 1100 framebuffer driver
*needs* to know what the CPU frequency is so it can set the pixel clock
divisor.

The real problem is the silly people who added this to cpufreq.h:

#ifdef CONFIG_CPU_FREQ
unsigned int cpufreq_quick_get(unsigned int cpu); unsigned int
cpufreq_get(unsigned int cpu); #else static inline unsigned int
cpufreq_quick_get(unsigned int cpu) {
        return 0;
}
static inline unsigned int cpufreq_get(unsigned int cpu) {
        return 0;
}
#endif

which utterly bogus.

--
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

