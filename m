Return-Path: <linux-kernel-owner+w=401wt.eu-S1755713AbZHUVbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbZHUVbN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755598AbZHUVbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:31:12 -0400
Received: from www.tglx.de ([62.245.132.106]:51442 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755017AbZHUVbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:31:11 -0400
Message-Id: <20090821205008.518392436@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:29:27 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 00/32] x86: Refactor the setup code to provide a base for
	embedded platforms
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recently posted Moorestown support patches finally indicate the
arrival of the embedded nightmare to arch/x86.

Moorestown is a SoC with a x86 core and a bunch of random peripherals
glued around it. It finally gets rid of legacy hardware like PIT, 8042
et. al. but on the other hand it introduces the full embedded horror
by adding random peripheral IP cores as an replacement which are glued
onto the x86 CPU with duct tape and other nasty tricks.

The most remarkable achievement is the PIT replacement AHBT timer
which is originally an ARM AMBA based IP core and provides random
timer readout and other fancy features. It's the final prove that
Intel HW folks are unable to design a working timer. Sigh, I
eventually hoped that we see something usable in that area after a
decade of suffering. :(

Anyway. We want to support Moorestown & Co. nevertheless, but as we
have seen from the initial patches it needs to fiddle in the guts of
the x86 setup code. Most of the points where it interferes are already
covered by x86_quirks or paravirt modifications, but we cannot use
either of those to do sane multi platform support.

The following patch series refactors the setup related x86_quirks and
the setup related paravirt hooks and puts them into an extensible
platform_setup infrastructure to provide a proper base for adding the
Moorestown modifications. As a side effect it also unifies
time_32/64.c and removes some leftovers of the pre arch/x86 era.

Note, this is not a replacement for paravirt_ops. It is just replacing
the setup related paravirt stuff so it can be reused for other
platforms though I have to say that it removes a fair amount of
obscurity which was introduced by paravirt & Co.

The total result of this overhaul is:

 arch/x86/include/asm/do_timer.h                |   16 --
 arch/x86/kernel/time_32.c                      |  137 -------------------------
 arch/x86/kernel/time_64.c                      |  135 ------------------------
 linux-2.6/arch/x86/include/asm/apic.h          |    3 
 linux-2.6/arch/x86/include/asm/e820.h          |    2 
 linux-2.6/arch/x86/include/asm/hypervisor.h    |    2 
 linux-2.6/arch/x86/include/asm/io_apic.h       |    3 
 linux-2.6/arch/x86/include/asm/irq.h           |    3 
 linux-2.6/arch/x86/include/asm/mpspec.h        |   40 ++++++-
 linux-2.6/arch/x86/include/asm/paravirt.h      |   63 -----------
 linux-2.6/arch/x86/include/asm/pgtable.h       |   10 -
 linux-2.6/arch/x86/include/asm/pgtable_types.h |    4 
 linux-2.6/arch/x86/include/asm/platform.h      |  130 +++++++++++++++++++++++
 linux-2.6/arch/x86/include/asm/setup.h         |   45 --------
 linux-2.6/arch/x86/include/asm/time.h          |    3 
 linux-2.6/arch/x86/include/asm/timer.h         |   14 --
 linux-2.6/arch/x86/include/asm/tsc.h           |    3 
 linux-2.6/arch/x86/include/asm/vmware.h        |    2 
 linux-2.6/arch/x86/kernel/Makefile             |    4 
 linux-2.6/arch/x86/kernel/apic/apic.c          |    3 
 linux-2.6/arch/x86/kernel/apic/io_apic.c       |   11 --
 linux-2.6/arch/x86/kernel/apic/numaq_32.c      |   55 ++++------
 linux-2.6/arch/x86/kernel/cpu/hypervisor.c     |   14 +-
 linux-2.6/arch/x86/kernel/cpu/vmware.c         |   35 +++---
 linux-2.6/arch/x86/kernel/e820.c               |   19 ---
 linux-2.6/arch/x86/kernel/head32.c             |   11 +-
 linux-2.6/arch/x86/kernel/head64.c             |    3 
 linux-2.6/arch/x86/kernel/irqinit.c            |   36 +-----
 linux-2.6/arch/x86/kernel/kvmclock.c           |    7 -
 linux-2.6/arch/x86/kernel/mpparse.c            |   75 ++++---------
 linux-2.6/arch/x86/kernel/paravirt.c           |   34 ------
 linux-2.6/arch/x86/kernel/platform_setup.c     |   73 +++++++++++++
 linux-2.6/arch/x86/kernel/setup.c              |  111 ++------------------
 linux-2.6/arch/x86/kernel/smpboot.c            |    4 
 linux-2.6/arch/x86/kernel/time.c               |  120 +++++++++++++++++++++
 linux-2.6/arch/x86/kernel/traps.c              |    5 
 linux-2.6/arch/x86/kernel/tsc.c                |   69 ++++++++++--
 linux-2.6/arch/x86/kernel/visws_quirks.c       |   56 +++-------
 linux-2.6/arch/x86/kernel/vmi_32.c             |    9 -
 linux-2.6/arch/x86/kernel/vmiclock_32.c        |    2 
 linux-2.6/arch/x86/lguest/boot.c               |    9 -
 linux-2.6/arch/x86/xen/enlighten.c             |   23 ++--
 linux-2.6/arch/x86/xen/irq.c                   |    5 
 linux-2.6/arch/x86/xen/mmu.c                   |   16 ++
 linux-2.6/arch/x86/xen/mmu.h                   |    2 
 linux-2.6/arch/x86/xen/xen-ops.h               |    2 
 linux-2.6/init/main.c                          |    2 
 47 files changed, 622 insertions(+), 808 deletions(-)

Thanks,

	tglx

