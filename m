Return-Path: <linux-kernel-owner+w=401wt.eu-S1756998AbZDUSB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998AbZDUSB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 14:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbZDUSBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 14:01:16 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:21603 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548AbZDUSBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 14:01:14 -0400
X-BigFish: VPS-51(z971J3dc9i6f5iz154cP1432R98dR14ffO1402J936eQ1805M936fKzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KIGQ1G-02-REJ-01
Date: Tue, 21 Apr 2009 20:00:37 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Jeff Mahoney <jeffm@suse.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] IO-APIC + timer doesn't work!
Message-ID: <20090421180037.GA2763@alberich.amd.com>
References: <49E89D1B.7060800@suse.com> <20090420085854.GB7286@alberich.amd.com> <49EC8556.10105@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <49EC8556.10105@suse.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 21 Apr 2009 18:00:48.0094 (UTC) FILETIME=[19919FE0:01C9C2AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 10:23:18AM -0400, Jeff Mahoney wrote:
> Andreas Herrmann wrote:
> > On Fri, Apr 17, 2009 at 11:15:39AM -0400, Jeff Mahoney wrote:
> >> -----BEGIN PGP SIGNED MESSAGE-----
> >> Hash: SHA1
> >>
> >> Hi all -
> >>
> >> I saw this while booting 2.6.30-rc1, -rc2, and today's git, on one of
> >> my development nodes. This output is with apic=debug. With noapic,
> >> it still hung. Both outputs follow.
> >>
> >> git bisect leads to commit 8d6f0c8214928f7c5083dd54ecb69c5d615b516e,
> >> but I'm not seeing anything obvious there. Backing just that change
> >> out doesn't fix it.
> >>
> >> - -Jeff
> > 
> > This looks similar to http://bugzilla.kernel.org/show_bug.cgi?id=12961
> > 
> > Can you please provide lspci -nnxxx and dmesg when booting with hpet=verbose.
> 
> Sure, attached.
> 
> -Jeff
> 
> -- 
> Jeff Mahoney
> SUSE Labs

> [    0.004000] hpet: hpet_enable(842):
> [    0.004000] hpet: ID: 0x10228203, PERIOD: 0x429b17f
> [    0.004000] hpet: CFG: 0x0, STATUS: 0x0
> [    0.004000] hpet: COUNTER_l: 0x0, COUNTER_h: 0x0
> [    0.004000] hpet: T0: CFG_l: 0x10, CFG_h: 0xfdefa
> [    0.004000] hpet: T0: CMP_l: 0xffffffff, CMP_h: 0x0
> [    0.004000] hpet: T0 ROUTE_l: 0x0, ROUTE_h: 0x0
> [    0.004000] hpet: T1: CFG_l: 0x0, CFG_h: 0xfdefa
> [    0.004000] hpet: T1: CMP_l: 0xffffffff, CMP_h: 0x0
> [    0.004000] hpet: T1 ROUTE_l: 0x0, ROUTE_h: 0x0
> [    0.004000] hpet: T2: CFG_l: 0x0, CFG_h: 0xfdefa
> [    0.004000] hpet: T2: CMP_l: 0xffffffff, CMP_h: 0x0
> [    0.004000] hpet: T2 ROUTE_l: 0x0, ROUTE_h: 0x0
> [    0.004000] hpet: hpet_set_mode(328):
> [    0.004000] hpet: ID: 0x10228203, PERIOD: 0x429b17f
> [    0.004000] hpet: CFG: 0x3, STATUS: 0x1
> [    0.004000] hpet: COUNTER_l: 0x2b4a5, COUNTER_h: 0x0
                                  ^^^^^^^
> [    0.004000] hpet: T0: CFG_l: 0x261c, CFG_h: 0xfdefa
> [    0.004000] hpet: T0: CMP_l: 0xdfb7, CMP_h: 0x0
                                  ^^^^^^

Same as in above mentioned bugzilla (and btw with similar chipset).
First I thought that reset of HPET_COUNTER had no effect but in fact
this worked. HPET implementation on that chipset differs from
other implementation wrt setting the delta when programmed in
periodic mode. T0_CMP is less than COUNTER (next interrupt
usually happens after COUNTER overflows). But this does
not matter as the kernel detected that timer does not properly
work:

..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
..MP-BIOS bug: 8254 timer not connected to IO-APIC
   ...

See for instance
www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/24674.pdf

I suggest to partially revert my last hpet-commit. See attached patch.

Attached patch was tested on a system with AMD81xx chipset and also on
the system where I've encountered the system hang when main counter
was neither reset or stopped during programming of HPET in periodic mode.


Regards,
Andreas


---
x86: hpet: fix periodic mode programming on AMD 81xx

Impact: fix boot time hang on machines with AMD 81xx chipset

(See http://bugzilla.kernel.org/show_bug.cgi?id=12961)

It partially reverts commit c23e253e67c9d8a91a0ffa33c1f571a17f0a2403
(x86: hpet: stop HPET_COUNTER when programming periodic mode)

HPET on AMD 81xx chipset needs a second write (with HPET_TN_SETVAL
cleared) to T0_CMP register to set the period in periodic mode.

With this patch HPET_COUNTER is still stopped but not reset when HPET
is programmed in periodic mode. This should help to avoid races when
HPET is programmed in periodic mode and fixes a boot time hang that
I've observed on a machine when using 1000HZ.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/hpet.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 648b3a2..b30f79c 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -236,6 +236,10 @@ static void hpet_stop_counter(void)
 	unsigned long cfg = hpet_readl(HPET_CFG);
 	cfg &= ~HPET_CFG_ENABLE;
 	hpet_writel(cfg, HPET_CFG);
+}
+
+static void hpet_reset_counter(void)
+{
 	hpet_writel(0, HPET_COUNTER);
 	hpet_writel(0, HPET_COUNTER + 4);
 }
@@ -250,6 +254,7 @@ static void hpet_start_counter(void)
 static void hpet_restart_counter(void)
 {
 	hpet_stop_counter();
+	hpet_reset_counter();
 	hpet_start_counter();
 }
 
@@ -309,7 +314,7 @@ static int hpet_setup_msi_irq(unsigned int irq);
 static void hpet_set_mode(enum clock_event_mode mode,
 			  struct clock_event_device *evt, int timer)
 {
-	unsigned long cfg;
+	unsigned long cfg, cmp, now;
 	uint64_t delta;
 
 	switch (mode) {
@@ -317,12 +322,23 @@ static void hpet_set_mode(enum clock_event_mode mode,
 		hpet_stop_counter();
 		delta = ((uint64_t)(NSEC_PER_SEC/HZ)) * evt->mult;
 		delta >>= evt->shift;
+		now = hpet_readl(HPET_COUNTER);
+		cmp = now + (unsigned long) delta;
 		cfg = hpet_readl(HPET_Tn_CFG(timer));
 		/* Make sure we use edge triggered interrupts */
 		cfg &= ~HPET_TN_LEVEL;
 		cfg |= HPET_TN_ENABLE | HPET_TN_PERIODIC |
 		       HPET_TN_SETVAL | HPET_TN_32BIT;
 		hpet_writel(cfg, HPET_Tn_CFG(timer));
+		hpet_writel(cmp, HPET_Tn_CMP(timer));
+		udelay(1);
+		/*
+		 * HPET on AMD 81xx needs a second write (with HPET_TN_SETVAL
+		 * cleared) to T0_CMP to set the period. The HPET_TN_SETVAL
+		 * bit is automatically cleared after the first write.
+		 * (See AMD-8111 HyperTransport I/O Hub Data Sheet,
+		 * Publication # 24674)
+		 */
 		hpet_writel((unsigned long) delta, HPET_Tn_CMP(timer));
 		hpet_start_counter();
 		hpet_print_config();
-- 
1.6.2



