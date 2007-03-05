Return-Path: <linux-kernel-owner+w=401wt.eu-S933090AbXCEPg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090AbXCEPg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 10:36:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932963AbXCEPg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 10:36:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41278 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933090AbXCEPgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 10:36:25 -0500
Date: Mon, 5 Mar 2007 16:27:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Emil Karlson <jkarlson@cc.hut.fi>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: [5/6] 2.6.21-rc2: known regressions
Message-ID: <20070305152749.GA22258@elte.hu>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015040.GJ3441@stusta.de> <20070305075747.GA19838@elte.hu> <20070305001358.2eebbfae.akpm@linux-foundation.org> <1173108303.31337.18.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173108303.31337.18.camel@imap.mvista.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> > > FYI, this is not a "wont boot" problem, this should be a "NMI 
> > > watchdog does not work" problem - which has far lower severity. 
> > > Also, Thomas did a fix for this which is now in -mm.
> > 
> > yup, you should be able to cross this one off, Adrian.  The fix 
> > worked for me, at least.
> 
> I didn't see a fix for this one go by .. I'll check the usual places I 
> guess ..

find it below.

	Ingo

------------------------------------------------------
Subject: fix "NMI appears to be stuck"
From: Thomas Gleixner <tglx@linutronix.de>

  Testing NMI watchdog ... CPU#0: NMI appears to be stuck (54->54)!
  CPU#1: NMI appears to be stuck (0->0)!

Keep the PIT/HPET alive when nmi_watchdog = 1 is given on the command
line.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/apic.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/apic.c~fix-nmi-appears-to-be-stuck arch/i386/kernel/apic.c
--- a/arch/i386/kernel/apic.c~fix-nmi-appears-to-be-stuck
+++ a/arch/i386/kernel/apic.c
@@ -493,8 +493,15 @@ void __init setup_boot_APIC_clock(void)
 		/* No broadcast on UP ! */
 		if (num_possible_cpus() == 1)
 			return;
-	} else
-		lapic_clockevent.features &= ~CLOCK_EVT_FEAT_DUMMY;
+	} else {
+		/*
+		 * If nmi_watchdog is set to IO_APIC, we need the
+		 * PIT/HPET going. So we register lapic as a dummy
+		 * device.
+		 */
+		if (nmi_watchdog != NMI_IO_APIC)
+			lapic_clockevent.features &= ~CLOCK_EVT_FEAT_DUMMY;
+	}
 
 	/* Setup the lapic or request the broadcast */
 	setup_APIC_timer();
