Return-Path: <linux-kernel-owner+w=401wt.eu-S1752373AbZIWWgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbZIWWgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 18:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbZIWWgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 18:36:23 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:25638 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbZIWWgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 18:36:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEADc/ukqrR7O6/2dsb2JhbAC+aYhPAY92BYQb
X-IronPort-AV: E=Sophos;i="4.44,440,1249257600"; 
   d="scan'208";a="394786026"
From: Roland Dreier <rdreier@cisco.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] x86: Reduce verbosity of "TSC is reliable" message
X-Message-Flag: Warning: May contain useful information
Date: Wed, 23 Sep 2009 15:33:23 -0700
Message-ID: <adazl8l2swc.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Sep 2009 22:33:23.0896 (UTC) FILETIME=[DC6A3380:01CA3C9D]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On modern systems, the kernel prints the message

    Skipping synchronization checks as TSC is reliable.

once for every non-boot CPU.  This gets kind of ridiculous on huge
systems; for example, on a 64-thread system I was lucky enough to get:

    $ dmesg | grep 'TSC is reliable' | wc
         63     567    4221

There's no point to doing this for every CPU, since the code is just
checking the boot CPU anyway, so change this to a printk_once() to make
the message appears only once.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 arch/x86/kernel/tsc_sync.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index 027b5b4..f379309 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -114,7 +114,7 @@ void __cpuinit check_tsc_sync_source(int cpu)
 		return;
 
 	if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE)) {
-		pr_info("Skipping synchronization checks as TSC is reliable.\n");
+		printk_once(KERN_INFO "Skipping synchronization checks as TSC is reliable.\n");
 		return;
 	}
 
