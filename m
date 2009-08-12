Return-Path: <linux-kernel-owner+w=401wt.eu-S1755101AbZHLUwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101AbZHLUwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 16:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbZHLUwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 16:52:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:51048 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbZHLUwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 16:52:31 -0400
Date: Wed, 12 Aug 2009 20:52:00 GMT
From: tip-bot for Shaohua Li <shaohua.li@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       shaohua.li@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, shaohua.li@intel.com, mingo@elte.hu
In-Reply-To: <20090812031612.GA10062@sli10-desk.sh.intel.com>
References: <20090812031612.GA10062@sli10-desk.sh.intel.com>
Subject: [tip:timers/hpet] x86, hpet: Disable per-cpu hpet timer if ARAT is supported
Message-ID: <tip-39fe05e58c5e448601ce46e6b03900d5bf31c4b0@git.kernel.org>
Git-Commit-ID: 39fe05e58c5e448601ce46e6b03900d5bf31c4b0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 12 Aug 2009 20:52:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  39fe05e58c5e448601ce46e6b03900d5bf31c4b0
Gitweb:     http://git.kernel.org/tip/39fe05e58c5e448601ce46e6b03900d5bf31c4b0
Author:     Shaohua Li <shaohua.li@intel.com>
AuthorDate: Wed, 12 Aug 2009 11:16:12 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 12 Aug 2009 16:45:02 +0200

x86, hpet: Disable per-cpu hpet timer if ARAT is supported

If CPU support always running local APIC timer, per-cpu hpet
timer could be disabled, which is useless and wasteful in such
case. Let's leave the timers to others.

The effect is that we reserve less timers.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: venkatesh.pallipadi@intel.com
LKML-Reference: <20090812031612.GA10062@sli10-desk.sh.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/hpet.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index dedc2bd..5969e10 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -584,6 +584,8 @@ static void hpet_msi_capability_lookup(unsigned int start_timer)
 	unsigned int num_timers_used = 0;
 	int i;
 
+	if (boot_cpu_has(X86_FEATURE_ARAT))
+		return;
 	id = hpet_readl(HPET_ID);
 
 	num_timers = ((id & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT);
@@ -872,10 +874,8 @@ int __init hpet_enable(void)
 
 	if (id & HPET_ID_LEGSUP) {
 		hpet_legacy_clockevent_register();
-		hpet_msi_capability_lookup(2);
 		return 1;
 	}
-	hpet_msi_capability_lookup(0);
 	return 0;
 
 out_nohpet:
@@ -908,9 +908,17 @@ static __init int hpet_late_init(void)
 	if (!hpet_virt_address)
 		return -ENODEV;
 
+	if (hpet_readl(HPET_ID) & HPET_ID_LEGSUP)
+		hpet_msi_capability_lookup(2);
+	else
+		hpet_msi_capability_lookup(0);
+
 	hpet_reserve_platform_timers(hpet_readl(HPET_ID));
 	hpet_print_config();
 
+	if (boot_cpu_has(X86_FEATURE_ARAT))
+		return 0;
+
 	for_each_online_cpu(cpu) {
 		hpet_cpuhp_notify(NULL, CPU_ONLINE, (void *)(long)cpu);
 	}
