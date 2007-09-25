Return-Path: <linux-kernel-owner+w=401wt.eu-S1759245AbXIYQx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245AbXIYQx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 12:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756314AbXIYQxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 12:53:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35161 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756088AbXIYQxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 12:53:09 -0400
Date: Tue, 25 Sep 2007 09:52:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Greg.Chandler@wellsfargo.com,
       cpufreq@lists.linux.org.uk, linux-kernel@vger.kernel.org,
       dan.j.williams@intel.com, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 1/1] Kernel compile bug in 2.6.22.6/7 {maybe more}
 ARM/StrongARM
Message-Id: <20070925095229.d1aec1a5.akpm@linux-foundation.org>
In-Reply-To: <20070925143651.GA2769@redhat.com>
References: <1E7A4807A136DF45AD33DB341D93C3BD1F0C19@msgswbmnmsp46.wellsfargo.com>
	<20070925073132.GA29127@flint.arm.linux.org.uk>
	<20070925143651.GA2769@redhat.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 10:36:51 -0400 Dave Jones <davej@redhat.com> wrote:

> On Tue, Sep 25, 2007 at 08:31:32AM +0100, Russell King wrote:
>  > On Mon, Sep 24, 2007 at 05:53:57PM -0500, Greg.Chandler@wellsfargo.com wrote:
>  > > I was building a kernel for an iPaq {SA1110} and ran into this.
>  > > 
>  > > linux-2.6.22.7/arch/arm/mach-sa1100/generic.c:
>  > > Has a: #include <linux/cpufreq.h>
>  > > Then afterwards there is a: #if defined(CONFIG_CPU_FREQ_SA1100) ||
>  > > defined(CONFIG_CPU_FREQ_SA1110)
>  > > who's else section redefines the cpufreq_get function inhereited from
>  > > the header....
>  > > 
>  > > I'm guessing no one ever ended up in the "else" section until now, and
>  > > that the header was added some time ago and no one caught this.
>  > > This patch worked for me to get rid of the compile time problems.  I'm
>  > > having issues with the kernel, but as far as I can tell they are form
>  > > the Frame buffer and not because of this.  If this assessment is correct
>  > > {the not needing this code anymore} then please pass this along so it
>  > > makes it into an upcoming release.
>  > > 
>  > > --- linux-2.6.22.7/arch/arm/mach-sa1100/generic.c.orig  2007-09-24
>  > > 17:36:21.000000000 -0500
>  > > +++ linux-2.6.22.7/arch/arm/mach-sa1100/generic.c       2007-09-24
>  > > 17:40:02.000000000 -0500
>  > > @@ -107,15 +107,6 @@ unsigned int sa11x0_getspeed(unsigned in
>  > >         return cclk_frequency_100khz[PPCR & 0xf] * 100;
>  > >  }
>  > > 
>  > > -#else
>  > > -/*
>  > > - * We still need to provide this so building without cpufreq works.
>  > > - */
>  > > -unsigned int cpufreq_get(unsigned int cpu)
>  > > -{
>  > > -       return cclk_frequency_100khz[PPCR & 0xf] * 100;
>  > > -}
>  > > -EXPORT_SYMBOL(cpufreq_get);
>  > >  #endif
>  > > 
>  > >  /*
>  > 
>  > No.  That code is required - the StrongARM 1100 framebuffer driver
>  > *needs* to know what the CPU frequency is so it can set the pixel
>  > clock divisor.
>  > 
>  > The real problem is the silly people who added this to cpufreq.h:
>  > 
>  > #ifdef CONFIG_CPU_FREQ
>  > unsigned int cpufreq_quick_get(unsigned int cpu);
>  > unsigned int cpufreq_get(unsigned int cpu);
>  > #else
>  > static inline unsigned int cpufreq_quick_get(unsigned int cpu)
>  > {
>  >         return 0;
>  > }
>  > static inline unsigned int cpufreq_get(unsigned int cpu)
>  > {
>  >         return 0;
>  > }
>  > #endif
>  > 
>  > which utterly bogus.
> 
> Which came from ...
> 
> commit 184c44d2049c4db7ef6ec65794546954da2c6a0e
> Author: Andrew Morton <akpm@linux-foundation.org>
> Date:   Wed May 2 19:27:08 2007 +0200
> 
>     [PATCH] x86-64: fix x86_64-mm-sched-clock-share
>     
>     Fix for the following patch. Provide dummy cpufreq functions when
>     CPUFREQ is not compiled in.
>     
>     Cc: Andi Kleen <ak@suse.de>
>     Cc: Dave Jones <davej@codemonkey.org.uk>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Andi Kleen <ak@suse.de>
> 
> I don't remember seeing any problem here, so I'm not entirely sure what
> this was supposed to be fixing.  Perhaps the -mm-esque patch name
> will provide Andrew/Andi clues. It lacks sufficient information for
> my brain to guess what the problem was.

Oh geeze.  sched-clock-share went through about 18 different versions, was
merged, unmerged, remerged, dropped, etc.  I don't recall at what stage in
this mess the above fix was inserted, sorry.

> "Fix for the following patch" is also something that really should
> never be added to a git changelog too, because 'next' means absolutely
> nothing to me, nor I expect 99% of changelog readers.

184c44d2049c4db7ef6ec65794546954da2c6a0e should never have existed,
actually.  I intended that Andi fold it into the base patch prior to
sending it to Linus.  He normally does that, but it looks like this
one was handled as a standalone commit for some reason.


