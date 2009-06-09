Return-Path: <linux-kernel-owner+w=401wt.eu-S932169AbZFIKde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbZFIKde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760826AbZFIKVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:21:23 -0400
Received: from kroah.org ([198.145.64.141]:55374 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760148AbZFIKVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:21:22 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:41:08 2009
Message-Id: <20090609094107.906495786@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:55 -0700
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
       Mark Hounschell <markh@compro.net>,
       Borislav Petkov <borislav.petkov@amd.com>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 67/87] x86: hpet: provide separate functions to stop and start the counter
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=x86-hpet-provide-separate-functions-to-stop-and-start-the-counter.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andreas Herrmann <andreas.herrmann3@amd.com>

commit 8d6f0c8214928f7c5083dd54ecb69c5d615b516e upstream.

By splitting up existing hpet_start_counter function.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Mark Hounschell <markh@compro.net>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/hpet.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -191,27 +191,37 @@ static struct clock_event_device hpet_cl
 	.rating		= 50,
 };
 
-static void hpet_start_counter(void)
+static void hpet_stop_counter(void)
 {
 	unsigned long cfg = hpet_readl(HPET_CFG);
-
 	cfg &= ~HPET_CFG_ENABLE;
 	hpet_writel(cfg, HPET_CFG);
 	hpet_writel(0, HPET_COUNTER);
 	hpet_writel(0, HPET_COUNTER + 4);
+}
+
+static void hpet_start_counter(void)
+{
+	unsigned long cfg = hpet_readl(HPET_CFG);
 	cfg |= HPET_CFG_ENABLE;
 	hpet_writel(cfg, HPET_CFG);
 }
 
+static void hpet_restart_counter(void)
+{
+	hpet_stop_counter();
+	hpet_start_counter();
+}
+
 static void hpet_resume_device(void)
 {
 	force_hpet_resume();
 }
 
-static void hpet_restart_counter(void)
+static void hpet_resume_counter(void)
 {
 	hpet_resume_device();
-	hpet_start_counter();
+	hpet_restart_counter();
 }
 
 static void hpet_enable_legacy_int(void)
@@ -695,7 +705,7 @@ static struct clocksource clocksource_hp
 	.mask		= HPET_MASK,
 	.shift		= HPET_SHIFT,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
-	.resume		= hpet_restart_counter,
+	.resume		= hpet_resume_counter,
 #ifdef CONFIG_X86_64
 	.vread		= vread_hpet,
 #endif
@@ -707,7 +717,7 @@ static int hpet_clocksource_register(voi
 	cycle_t t1;
 
 	/* Start the counter */
-	hpet_start_counter();
+	hpet_restart_counter();
 
 	/* Verify whether hpet counter works */
 	t1 = read_hpet();


