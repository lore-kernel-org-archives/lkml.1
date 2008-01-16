Return-Path: <linux-kernel-owner+w=401wt.eu-S1752297AbYAPPXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbYAPPXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 10:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYAPPXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 10:23:04 -0500
Received: from www.tglx.de ([62.245.132.106]:55488 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbYAPPXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 10:23:03 -0500
Date: Wed, 16 Jan 2008 16:21:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
cc: Andrew Paprocki <andrew@ishiboo.com>, linux-kernel@vger.kernel.org,
       Balaji Rao <balajirrao@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       clemens@ladisch.de, venkatesh.pallipadi@intel.com, bob.picco@hp.com
Subject: Re: HPET timer broken using 2.6.23.13 / nanosleep() hangs
In-Reply-To: <alpine.LFD.0.99999.0801161524250.3764@localhost.localdomain>
Message-ID: <alpine.LFD.0.99999.0801161618380.3764@localhost.localdomain>
References: <76366b180801130310x57f24cc8s641d3ccb2415524c@mail.gmail.com> <20080113120337.GA5548@linux.vnet.ibm.com> <76366b180801130510w2af714fevf03f59164f90806f@mail.gmail.com> <20080113140620.GA22507@linux.vnet.ibm.com> <alpine.LFD.0.99999.0801161458470.3764@localhost.localdomain>
 <alpine.LFD.0.99999.0801161524250.3764@localhost.localdomain>
User-Agent: Alpine 0.99999 (LFD 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2008, Thomas Gleixner wrote:

> On Wed, 16 Jan 2008, Thomas Gleixner wrote:
> 
> > On Sun, 13 Jan 2008, Dhaval Giani wrote:
> > > On Sun, Jan 13, 2008 at 08:10:46AM -0500, Andrew Paprocki wrote:
> > > > I applied the patch to my 2.6.23.13 tree and upon reboot it stopped right after:
> > > > 
> > > > Clocksource tsc unstable (delta = ... ns)
> > > > Time: hpet clocksource has been installed.
> > > > 
> > > > It locked up hard.. cursor stopped blinking and SysRq isn't working either.
> > 
> > The hint is in the original report:
> > 
> > Clocksource tsc unstable (delta = 500013666 ns)
> > 
> > That means, that the TSC was counting, but HPET not. So it looks like
> > the HPET readout is stale. Which explains, why after switching to HPET
> > clocksource the time system gets hosed.
> > 
> > I wonder why the HPET counter works check did not catch this.
> > 
> > Can you please apply the path below and provide the output ?

This time against 2.6.23

Thanks,
	tglx


--- a/arch/i386/kernel/hpet.c
+++ b/arch/i386/kernel/hpet.c
@@ -233,7 +233,7 @@ int __init hpet_enable(void)
 	unsigned long id;
 	uint64_t hpet_freq;
 	u64 tmp, start, now;
-	cycle_t t1;
+	cycle_t t1, t2;
 
 	if (!is_hpet_capable())
 		return 0;
@@ -295,12 +295,17 @@ int __init hpet_enable(void)
 		rdtscll(now);
 	} while ((now - start) < 200000UL);
 
-	if (t1 == read_hpet()) {
+	t2 = read_hpet();
+	if (t1 == t2) {
 		printk(KERN_WARNING
 		       "HPET counter not counting. HPET disabled\n");
 		goto out_nohpet;
 	}
 
+	printk(KERN_INFO "HPET check: t1=%llu t2=%llu s=%llu n=%llu\n",
+	       (unsigned long long) t1, (unsigned long long) t2,
+	       (unsigned long long) start, (unsigned long long) now);
+
 	/* Initialize and register HPET clocksource
 	 *
 	 * hpet period is in femto seconds per cycle
