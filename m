Return-Path: <linux-kernel-owner+w=401wt.eu-S1763070AbZJOVVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763070AbZJOVVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 17:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758304AbZJOVVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 17:21:54 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:63084 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbZJOVVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 17:21:53 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAFcv10qrR7Ht/2dsb2JhbADBO5g3hDAE
X-IronPort-AV: E=Sophos;i="4.44,568,1249257600"; 
   d="scan'208";a="410299457"
From: Roland Dreier <rdreier@cisco.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [PATCH] x86: Don't print number of MCE banks for every CPU
X-Message-Flag: Warning: May contain useful information
Date: Thu, 15 Oct 2009 14:21:14 -0700
Message-ID: <adaeip473qt.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 Oct 2009 21:21:15.0109 (UTC) FILETIME=[6D583950:01CA4DDD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MCE initialization code explicitly says it doesn't handle asymmetric
configurations where different CPUs support different numbers of MCE
banks, and it prints a big warning in that case.  Therefore, printing
the "mce: CPU supports <x> MCE banks" message into the kernel log for
every CPU is pure redundancy that clutters the log significantly for
systems with lots of CPUs.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index b1598a9..721a77c 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1214,7 +1214,8 @@ static int __cpuinit mce_cap_init(void)
 	rdmsrl(MSR_IA32_MCG_CAP, cap);
 
 	b = cap & MCG_BANKCNT_MASK;
-	printk(KERN_INFO "mce: CPU supports %d MCE banks\n", b);
+	if (!banks)
+		printk(KERN_INFO "mce: CPU supports %d MCE banks\n", b);
 
 	if (b > MAX_NR_BANKS) {
 		printk(KERN_WARNING
