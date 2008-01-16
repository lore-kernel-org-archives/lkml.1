Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbYAPOVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbYAPOVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 09:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYAPOVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 09:21:47 -0500
Received: from www.tglx.de ([62.245.132.106]:54516 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbYAPOVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 09:21:46 -0500
Date: Wed, 16 Jan 2008 15:15:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
cc: Andrew Paprocki <andrew@ishiboo.com>, linux-kernel@vger.kernel.org,
       Balaji Rao <balajirrao@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       clemens@ladisch.de, venkatesh.pallipadi@intel.com, bob.picco@hp.com
Subject: Re: HPET timer broken using 2.6.23.13 / nanosleep() hangs
In-Reply-To: <20080113140620.GA22507@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.0.99999.0801161458470.3764@localhost.localdomain>
References: <76366b180801130310x57f24cc8s641d3ccb2415524c@mail.gmail.com> <20080113120337.GA5548@linux.vnet.ibm.com> <76366b180801130510w2af714fevf03f59164f90806f@mail.gmail.com> <20080113140620.GA22507@linux.vnet.ibm.com>
User-Agent: Alpine 0.99999 (LFD 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jan 2008, Dhaval Giani wrote:
> On Sun, Jan 13, 2008 at 08:10:46AM -0500, Andrew Paprocki wrote:
> > I applied the patch to my 2.6.23.13 tree and upon reboot it stopped right after:
> > 
> > Clocksource tsc unstable (delta = ... ns)
> > Time: hpet clocksource has been installed.
> > 
> > It locked up hard.. cursor stopped blinking and SysRq isn't working either.

The hint is in the original report:

Clocksource tsc unstable (delta = 500013666 ns)

That means, that the TSC was counting, but HPET not. So it looks like
the HPET readout is stale. Which explains, why after switching to HPET
clocksource the time system gets hosed.

I wonder why the HPET counter works check did not catch this.

Can you please apply the path below and provide the output ?

Thanks,

	tglx

Index: linux-2.6/arch/x86/kernel/hpet.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/hpet.c	2008-01-16 08:29:28.000000000 +0100
+++ linux-2.6/arch/x86/kernel/hpet.c	2008-01-16 15:13:19.000000000 +0100
@@ -323,7 +323,7 @@ static struct clocksource clocksource_hp
 static int hpet_clocksource_register(void)
 {
 	u64 tmp, start, now;
-	cycle_t t1;
+	cycle_t t1, t2;
 
 	/* Start the counter */
 	hpet_start_counter();
@@ -343,12 +343,17 @@ static int hpet_clocksource_register(voi
 		rdtscll(now);
 	} while ((now - start) < 200000UL);
 
-	if (t1 == read_hpet()) {
+	t2 = read_hpet();
+	if (t1 == t2) {
 		printk(KERN_WARNING
 		       "HPET counter not counting. HPET disabled\n");
 		return -ENODEV;
 	}
 
+	printk(KERN_INFO "HPET check: t1=%lu t2=%lu s=%lu n=%lu\n",
+	       (unsigned long) t1, (unsigned long) t2,
+	       (unsigned long) start, (unsigned long) now);
+
 	/* Initialize and register HPET clocksource
 	 *
 	 * hpet period is in femto seconds per cycle

