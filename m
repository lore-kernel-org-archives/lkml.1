Return-Path: <linux-kernel-owner+w=401wt.eu-S1759512AbYGPQ13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512AbYGPQ13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 12:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757454AbYGPQ1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 12:27:20 -0400
Received: from ns1.suse.de ([195.135.220.2]:49973 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757359AbYGPQ1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 12:27:19 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Linux - Novell
To: Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] Re: AMD Mobile Semprons (3500+, 3600+,...) break with nohz and highres enabled
Date: Wed, 16 Jul 2008 18:27:15 +0200
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, "linux-kernel" <linux-kernel@vger.kernel.org>,
       "andreas.herrmann3" <andreas.herrmann3@amd.com>,
       Richard <tuxbox.guru@gmail.com>, eumaster@gmail.com,
       uli.geins@geins-web.de
References: <1213638474.1684.21.camel@queen.suse.de>
In-Reply-To: <1213638474.1684.21.camel@queen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807161827.16898.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is against Andi's (ak) release branch,
hope that is ok...
Can this one be reviewed/added, pls.

Thanks,

          Thomas


NO_HZ: Blacklist AMD Mobile Semprons 3500/3600 to not use no_hz by default

Tested-by: uli.geins@geins-web.de
Signed-off-by: Thomas Renninger <trenn@suse.de>
---
 kernel/time/tick-sched.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index b854a89..bda0164 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -589,6 +589,32 @@ static enum hrtimer_restart tick_sched_timer(struct 
hrtimer *timer)
 	return HRTIMER_RESTART;
 }
 
+#if defined(CONFIG_X86) && defined(CONFIG_NO_HZ)
+static __init int is_nohz_broken(void)
+{
+	struct cpuinfo_x86 *c = &cpu_data(0);
+	/* AMD Sempron Mobile 3500+ and 3600+ are known to break
+	 * with tickless idle
+	 */
+	if (c->x86_vendor == X86_VENDOR_AMD &&
+	    c->x86 == 15) {
+		if (strstr(c->x86_model_id, "Sempron") &&
+		    strstr(c->x86_model_id, "Mobile") &&
+		    (strstr(c->x86_model_id, "3500") ||
+		     strstr(c->x86_model_id, "3600"))) {
+			printk(KERN_INFO "AMD Sempron Mobile found");
+			return 1;
+		}
+	}
+	return 0;
+}
+#else
+static __init int is_nohz_broken(void)
+{
+	return 0;
+}
+#endif
+
 /**
  * tick_setup_sched_timer - setup the tick emulation timer
  */
@@ -623,6 +649,11 @@ void tick_setup_sched_timer(void)
 	}
 
 #ifdef CONFIG_NO_HZ
+	if (is_nohz_broken()) {
+		printk("- disabling tickless idle\n");
+		tick_nohz_enabled = 0;
+	}
+
 	if (tick_nohz_enabled)
 		ts->nohz_mode = NOHZ_MODE_HIGHRES;
 #endif
-- 
1.5.4.5

