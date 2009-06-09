Return-Path: <linux-kernel-owner+w=401wt.eu-S1759917AbZFIKdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759917AbZFIKdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760242AbZFIKV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:21:27 -0400
Received: from kroah.org ([198.145.64.141]:55399 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760732AbZFIKVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:21:25 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:41:08 2009
Message-Id: <20090609094108.173791423@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@elte.hu>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Mark Hounschell <markh@compro.net>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 68/87] x86: hpet: stop HPET_COUNTER when programming periodic mode
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=x86-hpet-stop-hpet_counter-when-programming-periodic-mode.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andreas Herrmann <andreas.herrmann3@amd.com>

commit c23e253e67c9d8a91a0ffa33c1f571a17f0a2403 upstream

x86: hpet: stop HPET_COUNTER when programming periodic mode

Impact: fix system hang on some systems operating with HZ_1000

On a system that stalled with HZ_1000, the first value written to
T0_CMP (when the main counter was not stopped) did not trigger an
interrupt. Instead after the main counter wrapped around (after
several minutes) an interrupt was triggered and afterwards the
periodic interrupt took effect.

This can be fixed by implementing HPET spec recommendation for
programming the periodic mode (i.e. stopping the main counter).

[cebbert@redhat.com: backport to 2.6.29]

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Mark Hounschell <markh@compro.net>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

---
 arch/x86/kernel/hpet.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -269,29 +269,22 @@ static int hpet_setup_msi_irq(unsigned i
 static void hpet_set_mode(enum clock_event_mode mode,
 			  struct clock_event_device *evt, int timer)
 {
-	unsigned long cfg, cmp, now;
+	unsigned long cfg;
 	uint64_t delta;
 
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
+		hpet_stop_counter();
 		delta = ((uint64_t)(NSEC_PER_SEC/HZ)) * evt->mult;
 		delta >>= evt->shift;
-		now = hpet_readl(HPET_COUNTER);
-		cmp = now + (unsigned long) delta;
 		cfg = hpet_readl(HPET_Tn_CFG(timer));
 		/* Make sure we use edge triggered interrupts */
 		cfg &= ~HPET_TN_LEVEL;
 		cfg |= HPET_TN_ENABLE | HPET_TN_PERIODIC |
 		       HPET_TN_SETVAL | HPET_TN_32BIT;
 		hpet_writel(cfg, HPET_Tn_CFG(timer));
-		/*
-		 * The first write after writing TN_SETVAL to the
-		 * config register sets the counter value, the second
-		 * write sets the period.
-		 */
-		hpet_writel(cmp, HPET_Tn_CMP(timer));
-		udelay(1);
 		hpet_writel((unsigned long) delta, HPET_Tn_CMP(timer));
+		hpet_start_counter();
 		break;
 
 	case CLOCK_EVT_MODE_ONESHOT:


