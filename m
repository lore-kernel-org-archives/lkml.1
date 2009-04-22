Return-Path: <linux-kernel-owner+w=401wt.eu-S1753045AbZDVLWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbZDVLWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 07:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbZDVLWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 07:22:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:43840 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbZDVLWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 07:22:21 -0400
Date: Wed, 22 Apr 2009 11:21:31 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andreas.herrmann3@amd.com, jeffm@suse.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, jeffm@suse.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090421180037.GA2763@alberich.amd.com>
References: <20090421180037.GA2763@alberich.amd.com>
Subject: [tip:x86/urgent] x86: hpet: fix periodic mode programming on AMD 81xx
Message-ID: <tip-86d855f62fabe344a4f66f509def6594abef9a91@git.kernel.org>
Git-Commit-ID: 86d855f62fabe344a4f66f509def6594abef9a91
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 22 Apr 2009 11:21:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  86d855f62fabe344a4f66f509def6594abef9a91
Gitweb:     http://git.kernel.org/tip/86d855f62fabe344a4f66f509def6594abef9a91
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Tue, 21 Apr 2009 20:00:37 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 22 Apr 2009 12:44:55 +0200

x86: hpet: fix periodic mode programming on AMD 81xx

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

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Jeff Mahoney <jeffm@suse.com>
LKML-Reference: <20090421180037.GA2763@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/hpet.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 3f0019e..81408b9 100644
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
