Return-Path: <linux-kernel-owner+w=401wt.eu-S1759482AbYFLK3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482AbYFLK3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 06:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754946AbYFLK2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 06:28:55 -0400
Received: from www.tglx.de ([62.245.132.106]:33194 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213AbYFLK2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 06:28:54 -0400
Message-Id: <20080610171639.551369443@linutronix.de>
User-Agent: quilt/0.46-1
Date: Thu, 12 Jun 2008 10:28:32 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Veen <arjan@infradead.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: [patch 0/6] AMD C1E aware idle support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMD CPUs with C1E support are currently excluded from high resolution
timers and NOHZ support. The reason is that C1E is a BIOS controlled
C3 power state which switches off TSC and the local APIC timer. The
ACPI C-State control manages the TSC/local APIC timer wreckage, but
this does not include the C1 based ("halt" instruction) C1E mode. The
BIOS/SMM controlled C1E state works on most systems even without
enabling ACPI C-State control.

The fact that a system has C1E support enabled is advertised in a MSR,
but the time during boot when the C1E bit is set by the BIOS varies:

1) Boot CPU has already C1E bit set
2) Secondary CPU sets C1E bit
3) C1E bit is set after ACPI C-State query

Case #1 and #2 are covered by the current implementation, but case #3
results in a complete system lockup due to missing timer
interrupts. The current solution is to disable the local APIC timer
and use the PIT in broadcast mode. This restricts the C1E enabled
systems to periodic timer mode.

The following patch series implements a C1E aware idle function which
also covers the late C1E enablement (case #3):

The function is selected during boot for CPUs which have possibly C1E
support. The function checks the MSR which contains the C1E active
bits before executing the halt instruction. When one of the C1E active
bits is set, it makes the system C1E aware by enabling the timer
broadcast mechanism for all CPUs. For high resolution timer and/or
nohz enabled systems it calls the oneshot timer broadcast mechanism
before executing the halt instruction. This is the same mechanism
which is used in the ACPI C-State control for C2/C3 power states.

On my C1E affected X2 box these patches reduce the wakeups/sec down to
20 according to powertop.

The patches work fine on systems which are not affected by the dreaded
ATI chipset timer wreckage. On those which have the problem, the box
needs help from the keyboard to continue working.

The x86 changes for .27 contain a complete overhaul of the affected
code, but this is out of scope for this patchset.

For those who are interested to test those patches on top of 2.6.26-rc
I extracted a patch and added it to the c1e series. It's available
from:

http://www.kernel.org/pub/linux/kernel/people/tglx/c1e/2.6.26-rc5-c1e-patches.tar.gz
or
http://www.kernel.org/pub/linux/kernel/people/tglx/c1e/2.6.26-rc5-c1e-patches.tar.bz2

@Macej: I bisected your patches and the commit which solves the mysterious
hangs is:

x86: I/O APIC: timer through 8259A second-chance
(7e3530cd98a0c6ab38f5898e855a5beffab26561 in linux-2.6-tip.git)

That's the patch which you worried about possible impacts, but it
seems that it actually fixes the stupid timer irq issue finally. I
have tested it on various machines which had timer irq problems in the
past and they all run smothly. Great work!

Thanks,

	tglx

-- 

