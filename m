Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbZCALmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbZCALmR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 06:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbZCALmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 06:42:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:47261 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbZCALmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 06:42:04 -0500
Subject: Re: [git-pull -tip] x86: Basic AMD Support for performance counters
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       x86 maintainers <x86@kernel.org>, Paul Mackerras <paulus@samba.org>
In-Reply-To: <20090301113010.GA1203@elte.hu>
References: <1235756278.3914.9.camel@localhost.localdomain>
	 <20090228094018.GF12095@elte.hu> <20090228134434.GA32473@elte.hu>
	 <20090301083616.GA1742@elte.hu>
	 <1235904087.3213.3.camel@localhost.localdomain>
	 <20090301113010.GA1203@elte.hu>
Content-Type: text/plain
Date: Sun, 01 Mar 2009 17:11:30 +0530
Message-Id: <1235907690.19758.1.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-01 at 12:30 +0100, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > On Sun, 2009-03-01 at 09:36 +0100, Ingo Molnar wrote:
> > > * Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > Seems to be working fine, here's the output from an Athlon 64 
> > > > 3200+ (Sempron) box:
> > > > 
> > > >  Performance counter stats for 'ls':
> > > > 
> > > >       17.420811  task clock ticks     (msecs)
> > > > 
> > > >               0  CPU migrations       (events)
> > > >              12  context switches     (events)
> > > >             583  pagefaults           (events)
> > > >        29760299  CPU cycles           (events)
> > > >        29401642  instructions         (events)
> > > >        12698498  cache references     (events)
> > > >           66269  cache misses         (events)
> > > > 
> > > >  Wall-clock time elapsed:   687.999988 msecs
> > > 
> > > The patches cause a crash on another system - an Opteron system 
> > > spontaneous reboots at this point during early bootup:
> > > 
> > > CPU 0/0x4 -> Node 0
> > > tseg: 00cfe00000
> > > CPU: Physical Processor ID: 0
> > > CPU: Processor Core ID: 0
> > > using C1E aware idle routine
> > > AMD Performance Monitoring support detected.
> > > ... num counters:    4
> > > ... value mask:      0000000000000000
> > > ... fixed counters:  0
> > > ... counter mask:    000000000000000f
> > > ACPI: Core revision 20081204
> > > ftrace: converting mcount calls to 0f 1f 44 00 00
> > > ftrace: allocating 16365 entries in 129 pages
> > > Setting APIC routing to physical flat
> > > masked ExtINT on CPU#0
> > > ENABLING IO
> > > [reboot]
> > > 
> > 
> > Can you please share your config file.
> 
> any config file will crash that box. I used the 64-bit defconfig 
> - i.e. 'make ARCH=x86_64 defconfig'.
> 

Can you please try this patch:

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 266618a..5447cc0 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -146,7 +146,9 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	 * Generate PMC IRQs:
 	 * (keep 'enabled' bit clear for now)
 	 */
-	hwc->config = ARCH_PERFMON_EVENTSEL_INT;
+	/* Currently Interrupts are disabled on AMD */
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
+		hwc->config = ARCH_PERFMON_EVENTSEL_INT;
 
 	/*
 	 * Count user and OS events unless requested not to.



