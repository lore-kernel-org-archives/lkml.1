Return-Path: <linux-kernel-owner+w=401wt.eu-S1760615AbZFIKeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760615AbZFIKeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760824AbZFIKVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:21:30 -0400
Received: from kroah.org ([198.145.64.141]:55415 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760576AbZFIKV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:21:29 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:41:08 2009
Message-Id: <20090609094108.439675561@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:57 -0700
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
       alan@lxorguk.ukuu.org.uk, Andreas Herrmann <andreas.herrmann3@amd.com>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 69/87] x86: hpet: fix periodic mode programming on AMD 81xx
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=x86-hpet-fix-periodic-mode-programming-on-amd-81xx.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andreas Herrmann <andreas.herrmann3@amd.com>

commit 7a6f9cbb37120c745fc187083fb5c3de4dca4f97 upstream.

(See http://bugzilla.kernel.org/show_bug.cgi?id=12961)

It partially reverts commit c23e253e67c9d8a91a0ffa33c1f571a17f0a2403
(x86: hpet: stop HPET_COUNTER when programming periodic mode)

HPET on AMD 81xx chipset needs a second write (with HPET_TN_SETVAL
cleared) to T0_CMP register to set the period in periodic mode.

With this patch HPET_COUNTER is still stopped but not reset when HPET
is programmed in periodic mode. This should help to avoid races when
HPET is programmed in periodic mode and fixes a boot time hang that
I've observed on a machine when using 1000HZ.

[ Impact: fix boot time hang on machines with AMD 81xx chipset ]

Reported-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Tested-by: Jeff Mahoney <jeffm@suse.com>
LKML-Reference: <20090421180037.GA2763@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/hpet.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -196,6 +196,10 @@ static void hpet_stop_counter(void)
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
@@ -210,6 +214,7 @@ static void hpet_start_counter(void)
 static void hpet_restart_counter(void)
 {
 	hpet_stop_counter();
+	hpet_reset_counter();
 	hpet_start_counter();
 }
 
@@ -269,7 +274,7 @@ static int hpet_setup_msi_irq(unsigned i
 static void hpet_set_mode(enum clock_event_mode mode,
 			  struct clock_event_device *evt, int timer)
 {
-	unsigned long cfg;
+	unsigned long cfg, cmp, now;
 	uint64_t delta;
 
 	switch (mode) {
@@ -277,12 +282,23 @@ static void hpet_set_mode(enum clock_eve
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
 		break;


