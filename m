Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbYKJHvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbYKJHvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 02:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbYKJHvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 02:51:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37777 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764AbYKJHvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 02:51:32 -0500
Date: Mon, 10 Nov 2008 08:51:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Markus Metzger <markus.t.metzger@googlemail.com>,
       Roland McGrath <roland@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] x86, bts: DS and BTS initialization
Message-ID: <20081110075117.GC2093@elte.hu>
References: <1226237361.6104.20.camel@raistlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226237361.6104.20.camel@raistlin>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Markus Metzger <markus.t.metzger@googlemail.com> wrote:

> Move BTS initialisation out of an #ifdef CONFIG_X86_64 guard.
> 
> Assume core2 BTS and DS layout for future models of family 6 processors.
> 
> Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
> ---
> 
> Index: gits/arch/x86/kernel/ds.c

applied the commit below to tip/x86/ptrace, thanks Markus!

	Ingo

--------------->
>From f4166c54bfe04f64603974058e44fbd7cfef0ccc Mon Sep 17 00:00:00 2001
From: Markus Metzger <markus.t.metzger@googlemail.com>
Date: Sun, 9 Nov 2008 14:29:21 +0100
Subject: [PATCH] x86, bts: DS and BTS initialization

Impact: widen BTS/PEBS ptrace enablement to more CPU models

Move BTS initialisation out of an #ifdef CONFIG_X86_64 guard.

Assume core2 BTS and DS layout for future models of family 6 processors.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/intel.c |    3 +--
 arch/x86/kernel/ds.c        |    9 ++++-----
 arch/x86/kernel/ptrace.c    |    9 ++++-----
 3 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index cce0b61..816f27f 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -307,12 +307,11 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 		set_cpu_cap(c, X86_FEATURE_P4);
 	if (c->x86 == 6)
 		set_cpu_cap(c, X86_FEATURE_P3);
+#endif
 
 	if (cpu_has_bts)
 		ptrace_bts_init_intel(c);
 
-#endif
-
 	detect_extended_topology(c);
 	if (!cpu_has(c, X86_FEATURE_XTOPOLOGY)) {
 		/*
diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index 2b69994..c570252 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -821,17 +821,16 @@ void __cpuinit ds_init_intel(struct cpuinfo_x86 *c)
 	switch (c->x86) {
 	case 0x6:
 		switch (c->x86_model) {
+		case 0 ... 0xC:
+			/* sorry, don't know about them */
+			break;
 		case 0xD:
 		case 0xE: /* Pentium M */
 			ds_configure(&ds_cfg_var);
 			break;
-		case 0xF: /* Core2 */
-		case 0x1C: /* Atom */
+		default: /* Core2, Atom, ... */
 			ds_configure(&ds_cfg_64);
 			break;
-		default:
-			/* sorry, don't know about them */
-			break;
 		}
 		break;
 	case 0xF:
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 0a6d8c1..06180df 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -929,17 +929,16 @@ void __cpuinit ptrace_bts_init_intel(struct cpuinfo_x86 *c)
 	switch (c->x86) {
 	case 0x6:
 		switch (c->x86_model) {
+		case 0 ... 0xC:
+			/* sorry, don't know about them */
+			break;
 		case 0xD:
 		case 0xE: /* Pentium M */
 			bts_configure(&bts_cfg_pentium_m);
 			break;
-		case 0xF: /* Core2 */
-        case 0x1C: /* Atom */
+		default: /* Core2, Atom, ... */
 			bts_configure(&bts_cfg_core2);
 			break;
-		default:
-			/* sorry, don't know about them */
-			break;
 		}
 		break;
 	case 0xF:
