Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbZLCCdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbZLCCdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 21:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754748AbZLCCdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 21:33:20 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50317 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbZLCCdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 21:33:20 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B172364.7090809@jp.fujitsu.com>
Date: Thu, 03 Dec 2009 11:33:08 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Jan Beulich <JBeulich@novell.com>, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, stable@kernel.org
Subject: [PATCH] x86/mce: don't restart timer if disabled
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even it is in error path unlikely taken, add_timer_on() at
CPU_DOWN_FAILED* needs to be skipped if mce_timer is disabled.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: <stable@kernel.org>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index a06b4fe..c756e13 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1997,9 +1997,11 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		break;
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
-		t->expires = round_jiffies(jiffies +
+		if (!mce_ignore_ce && check_interval) {
+			t->expires = round_jiffies(jiffies +
 					   __get_cpu_var(mce_next_interval));
-		add_timer_on(t, cpu);
+			add_timer_on(t, cpu);
+		}
 		smp_call_function_single(cpu, mce_reenable_cpu, &action, 1);
 		break;
 	case CPU_POST_DEAD:
-- 
1.6.5.3


