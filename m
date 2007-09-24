Return-Path: <linux-kernel-owner+w=401wt.eu-S1761102AbXIXW0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761102AbXIXW0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 18:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755398AbXIXWZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 18:25:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47355 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753568AbXIXWZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 18:25:54 -0400
Date: Mon, 24 Sep 2007 15:25:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 24/25] r/o bind mounts: track number of mount writers
Message-Id: <20070924152532.305ec951.akpm@linux-foundation.org>
In-Reply-To: <1190671602.26982.261.camel@localhost>
References: <20070920195249.852667D5@kernel>
	<20070920195320.38C8E20D@kernel>
	<20070923231713.f81ee0db.akpm@linux-foundation.org>
	<1190671602.26982.261.camel@localhost>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007 15:06:42 -0700
Dave Hansen <haveblue@us.ibm.com> wrote:

> On Sun, 2007-09-23 at 23:17 -0700, Andrew Morton wrote:
> > It look like a false positive to me, but really, for a patchset of this
> > complexity and maturity I cannot fathom how it could have escaped any
> > lockdep testing.
> 
> I test with lockdep all the time.  The problem was that lockdep doesn't
> complain until you have 8 nested locks, and I only tested on a 4-cpu
> system.
> 
> I lowered the lockdep nesting limit to 3, and got the warning on my
> machine.
> 

hm.  I saw that warning on my 2-way.  It has CONFIG_NR_CPUS=8 so perhaps
the kernel has decided that this machine can possibly have eight CPUs.

It's an old super-micro board, doesn't have ACPI.

OEM ID: INTEL    Product ID: 440BX        APIC at: 0xFEE00000
Processor #0 6:8 APIC version 17
Processor #1 6:8 APIC version 17
I/O APIC #2 Version 17 at 0xFEC00000.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Processors: 2

...

Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 1707.03 BogoMIPS (lpj=3414067)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0383fbff 00000000 00000000 00000000 00000000 00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
CPU: After all inits, caps: 0383fbff 00000000 00000000 00000040 00000000 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
lockdep: not fixing up alternatives.
CPU0: Intel Pentium III (Coppermine) stepping 03
lockdep: not fixing up alternatives.
Booting processor 1/1 eip 2000
Initializing CPU#1
Calibrating delay using timer specific routine.. 1704.02 BogoMIPS (lpj=3408054)
CPU: After generic identify, caps: 0383fbff 00000000 00000000 00000000 00000000 00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
CPU: After all inits, caps: 0383fbff 00000000 00000000 00000040 00000000 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel Pentium III (Coppermine) stepping 03
Total of 2 processors activated (3411.06 BogoMIPS).
ExtINT not setup in hardware but reported by MP table
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=0 pin2=0
APIC timer registered as dummy, due to nmi_watchdog=1!
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs


One would think that the kernel would work out that eight CPUs ain't
possible on such a machine.  But we don't seem to print out any info which
allows me to confirm that this is really what the kernel did.


