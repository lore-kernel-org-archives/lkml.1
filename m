Return-Path: <linux-kernel-owner+w=401wt.eu-S1758683AbZLQBoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683AbZLQBoc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965080AbZLQBn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:43:58 -0500
Received: from mga02.intel.com ([134.134.136.20]:34720 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965096AbZLQBnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:43:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,409,1257148800"; 
   d="scan'208";a="579706492"
Date: Wed, 16 Dec 2009 17:43:48 -0800
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       H Peter Anvin <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>
Subject: [PATCH] x86: trivial - reenable Skipped synchronization message once at boot
Message-ID: <20091217014348.GA684@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


commit 9b3660a5 changed below

-               printk_once(KERN_INFO "Skipping synchronization checks
                as TSC is
+               if (cpu == (nr_cpu_ids-1) || system_state !=
SYSTEM_BOOTING)
+                       pr_info(
+                       "Skipped synchronization checks as TSC is
reliable.\n");

which results in "Skipped synchronization checks as TSC is reliable"
message missing from my dmesg. The problem is that nr_cpu_ids is number
of possible CPUs, and courtesy extra disabled cpus in my bios, that
number is higher than real cpus.

Change the check to num_present_cpus() - 1, which gets us back to old
behavior of printing this message once at boot.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 arch/x86/kernel/tsc_sync.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index 0aa5fed..6fe5184 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -114,9 +114,11 @@ void __cpuinit check_tsc_sync_source(int cpu)
 		return;
 
 	if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE)) {
-		if (cpu == (nr_cpu_ids-1) || system_state != SYSTEM_BOOTING)
+		if (cpu == (num_present_cpus() - 1) ||
+		    system_state != SYSTEM_BOOTING) {
 			pr_info(
 			"Skipped synchronization checks as TSC is reliable.\n");
+		}
 		return;
 	}
 
-- 
1.6.0.6

