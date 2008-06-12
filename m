Return-Path: <linux-kernel-owner+w=401wt.eu-S1761412AbYFLMap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761412AbYFLMap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 08:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759009AbYFLMad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 08:30:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38605 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760950AbYFLMab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 08:30:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 0/6] AMD C1E aware idle support
Date: Thu, 12 Jun 2008 14:31:23 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
References: <20080610171639.551369443@linutronix.de>
In-Reply-To: <20080610171639.551369443@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806121431.24305.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 12 of June 2008, Thomas Gleixner wrote:
> AMD CPUs with C1E support are currently excluded from high resolution
> timers and NOHZ support. The reason is that C1E is a BIOS controlled
> C3 power state which switches off TSC and the local APIC timer. The
> ACPI C-State control manages the TSC/local APIC timer wreckage, but
> this does not include the C1 based ("halt" instruction) C1E mode. The
> BIOS/SMM controlled C1E state works on most systems even without
> enabling ACPI C-State control.
> 
> The fact that a system has C1E support enabled is advertised in a MSR,
> but the time during boot when the C1E bit is set by the BIOS varies:
> 
> 1) Boot CPU has already C1E bit set
> 2) Secondary CPU sets C1E bit
> 3) C1E bit is set after ACPI C-State query
> 
> Case #1 and #2 are covered by the current implementation, but case #3
> results in a complete system lockup due to missing timer
> interrupts. The current solution is to disable the local APIC timer
> and use the PIT in broadcast mode. This restricts the C1E enabled
> systems to periodic timer mode.
> 
> The following patch series implements a C1E aware idle function which
> also covers the late C1E enablement (case #3):
> 
> The function is selected during boot for CPUs which have possibly C1E
> support. The function checks the MSR which contains the C1E active
> bits before executing the halt instruction. When one of the C1E active
> bits is set, it makes the system C1E aware by enabling the timer
> broadcast mechanism for all CPUs. For high resolution timer and/or
> nohz enabled systems it calls the oneshot timer broadcast mechanism
> before executing the halt instruction. This is the same mechanism
> which is used in the ACPI C-State control for C2/C3 power states.
> 
> On my C1E affected X2 box these patches reduce the wakeups/sec down to
> 20 according to powertop.
> 
> The patches work fine on systems which are not affected by the dreaded
> ATI chipset timer wreckage. On those which have the problem, the box
> needs help from the keyboard to continue working.
> 
> The x86 changes for .27 contain a complete overhaul of the affected
> code, but this is out of scope for this patchset.
> 
> For those who are interested to test those patches on top of 2.6.26-rc
> I extracted a patch and added it to the c1e series. It's available
> from:
> 
> http://www.kernel.org/pub/linux/kernel/people/tglx/c1e/2.6.26-rc5-c1e-patches.tar.gz
> or
> http://www.kernel.org/pub/linux/kernel/people/tglx/c1e/2.6.26-rc5-c1e-patches.tar.bz2

I guess the x86-next-apic-timer-fixes.patch is a combination of all patches in
this series.  Is that correct?

Thanks,
Rafael
