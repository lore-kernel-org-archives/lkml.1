Return-Path: <linux-kernel-owner+w=401wt.eu-S1753441AbXCYIHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbXCYIHL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 04:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbXCYIHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 04:07:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42206 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441AbXCYIHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 04:07:08 -0400
Date: Sun, 25 Mar 2007 10:06:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Early hang with 2.6.21-rc4-rt1
Message-ID: <20070325080626.GA22223@elte.hu>
References: <adad52xnccs.fsf@cisco.com> <ada8xdlnb6f.fsf@cisco.com> <20070325072947.GA10734@elte.hu> <20070325073424.GA14242@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070325073424.GA14242@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> hm - on 32-bit, CRITICAL_IRQSOFF_TIMING+FUNCTION_TRACING works fine 
> for me. I'll try the 64-bit kernel too.

the 64-bit kernel indeed hangs. Does the patch below fix it for you?

	Ingo

Index: linux/kernel/timer.c
===================================================================
--- linux.orig/kernel/timer.c
+++ linux/kernel/timer.c
@@ -822,8 +822,23 @@ EXPORT_SYMBOL(xtime);
 /* XXX - all of this timekeeping code should be later moved to time.c */
 #include <linux/clocksource.h>
 
+/*
+ * Dummy clocksource just in case someone tries to use the
+ * clocksource infrastructure before timekeeping_init() is
+ * called:
+ */
+static notrace cycle_t read_boot(void)
+{
+	return 0;
+}
+
+static __initdata struct clocksource clocksource_boot = {
+	.name			= "boot",
+	.read			= read_boot,
+};
+
 /* pointer to current clocksource: */
-static __read_mostly struct clocksource *clock;
+static __read_mostly struct clocksource *clock = &clocksource_boot;
 
 #ifdef CONFIG_GENERIC_TIME
 /**
