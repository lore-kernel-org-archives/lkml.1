Return-Path: <linux-kernel-owner+w=401wt.eu-S934828AbYD1R1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934828AbYD1R1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932613AbYD1R1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:27:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:37560 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932481AbYD1R1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:27:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,717,1199692800"; 
   d="scan'208";a="238983820"
From: PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>
Subject: [PATCH] ARCH 2.6.25.y: Fix 32-bit x86 MSI-X allocation leakage
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Date: Fri, 25 Apr 2008 18:00:26 -0700
Message-ID: <20080426010025.7212.3940.stgit@scrappy.jf.intel.com>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Apr 2008 17:27:31.0547 (UTC) FILETIME=[23A63AB0:01C8A955]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bug was introduced in the 2.6.24 i386/x86_64 tree merge, where
MSI-X vector allocation will eventually fail.  The cause is the new
bit array tracking used vectors is not getting cleared properly on
IRQ destruction on the 32-bit APIC code.

This can be seen easily using the ixgbe 10 GbE driver on multi-core
systems by simply loading and unloading the driver a few times.
Depending on the number of available vectors on the host system, the
MSI-X allocation will eventually fail, and the driver will only be
able to use legacy interrupts.

Signed-off-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
---

 arch/x86/kernel/io_apic_32.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index 4ca5486..f239b30 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -2477,6 +2477,7 @@ void destroy_irq(unsigned int irq)
 	dynamic_irq_cleanup(irq);
 
 	spin_lock_irqsave(&vector_lock, flags);
+	clear_bit(irq_vector[irq], used_vectors);
 	irq_vector[irq] = 0;
 	spin_unlock_irqrestore(&vector_lock, flags);
 }

