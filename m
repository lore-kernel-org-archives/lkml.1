Return-Path: <linux-kernel-owner+w=401wt.eu-S1758417AbZJEDJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417AbZJEDJg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 23:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbZJEDJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 23:09:35 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44750 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbZJEDJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 23:09:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AC9633B.5030202@jp.fujitsu.com>
Date: Mon, 05 Oct 2009 12:08:43 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/6] mce-inject: add a barrier to raise_mce()
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com> <4AC95F5A.4000708@jp.fujitsu.com>
In-Reply-To: <4AC95F5A.4000708@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prepared mce_inject_cpumask needs to be referred soon in NMI
on other CPUs.

Reported-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce-inject.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index 105e527..4fb5b78 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -154,6 +154,9 @@ static void raise_mce(struct mce *m)
 							!= MCE_INJ_CTX_RANDOM)
 				cpu_clear(cpu, mce_inject_cpumask);
 		}
+		/* make sure mce_inject_cpumask is visible on other CPUs */
+		smp_mb();
+
 		if (!cpus_empty(mce_inject_cpumask))
 			apic->send_IPI_mask(&mce_inject_cpumask, NMI_VECTOR);
 		start = jiffies;
-- 
1.6.4.3


