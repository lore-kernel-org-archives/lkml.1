Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbZLWTSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbZLWTSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 14:18:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbZLWTSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 14:18:11 -0500
Received: from mga14.intel.com ([143.182.124.37]:47749 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735AbZLWTSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 14:18:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="226140505"
Date: Wed, 23 Dec 2009 11:18:06 -0800
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Mark Hounschell <markh@compro.net>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "dmarkh@cfl.rr.com" <dmarkh@cfl.rr.com>, Alain Knaff <alain@knaff.lu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "fdutils@fdutils.linux.lu" <fdutils@fdutils.linux.lu>,
       "Li, Shaohua" <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28
Message-ID: <20091223191806.GA3336@linux-os.sc.intel.com>
References: <alpine.LFD.2.00.0912220922250.31313@localhost.localdomain> <4B310879.9050701@compro.net> <1261525076.16916.4.camel@localhost.localdomain> <4B3162BC.9000508@cfl.rr.com> <4B3214EC.6020308@compro.net> <6598A4E21F1DB24D80BF72956484F59802EFD1C6@orsmsx001.amr.corp.intel.com> <4B32386B.2060509@compro.net> <alpine.LFD.2.00.0912230828230.6879@localhost.localdomain> <87bphpd4rt.fsf@basil.nowhere.org> <4B32565E.6000501@compro.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B32565E.6000501@compro.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 09:41:50AM -0800, Mark Hounschell wrote:
> On 12/23/2009 11:38 AM, Andi Kleen wrote:
> > Linus Torvalds <torvalds@linux-foundation.org> writes:
> > 
> >> It's not using the lapic for CPU0. 
> >>
> >> Using the HPET as a per-cpu timer is some crazy sh*t, since it's pretty 
> >> expensive to reprogram (compared to the local apic). And having different 
> >> timers for different CPU's is just odd.
> >>
> >> The fact that the timer subsystem can do this and it all (mostly) works at 
> >> all is nice and impressive, but doesn't make it any less crazy ;)
> > 
> > I suspect it's a system where the APIC timer stops in deeper idle
> > states and it supports them. In this case CPU #0 does timer broadcasts
> > when needed to wake the other CPUs up from deep C, but for that it has
> > to run with HPET. At least the other ones can still enjoy the LAPIC
> > timer.
> > 
> > This might suggest that Mark's floppy controller doesn't like
> > deep C? Mark, did you try booting with processor.max_cstate=1
> > and HPET enabled?
> 
> I just did and /proc/interrupts looks the same and the floppy still does
> not format.
> 

Can you try this one line patch either on .28 or .32 (with /proc/interrupts
output).
This disables hpet2 and lapic timer should then be used on CPU 0. If things
work with this test patch, we will know that the failure is somehow related
to HPET usage in MSI mode.

Thanks,
Venki

Reduce the rating of percpu hpet timer

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 arch/x86/kernel/hpet.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index cafb1c6..f89d17a 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -480,7 +480,7 @@ static void init_one_hpet_msi_clockevent(struct hpet_dev *hdev, int cpu)
 	hpet_setup_irq(hdev);
 	evt->irq = hdev->irq;
 
-	evt->rating = 110;
+	evt->rating = 40;
 	evt->features = CLOCK_EVT_FEAT_ONESHOT;
 	if (hdev->flags & HPET_DEV_PERI_CAP)
 		evt->features |= CLOCK_EVT_FEAT_PERIODIC;
-- 
1.6.0.6

