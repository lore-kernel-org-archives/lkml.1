Return-Path: <linux-kernel-owner+w=401wt.eu-S1757108AbYKTVJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbYKTVJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 16:09:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755468AbYKTVJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 16:09:50 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:48156 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467AbYKTVJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 16:09:50 -0500
Date: Thu, 20 Nov 2008 14:09:33 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@osdl.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: Fix interrupt leak due to migration
Message-ID: <20081120210932.GW1617@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When we migrate an interrupt from one CPU to another, we set the
move_in_progress flag and clean up the vectors later once they're not
being used.  If you're unlucky and call destroy_irq() before the vectors
become un-used, the move_in_progress flag is never cleared, which causes
the interrupt to become unusable.

This was discovered by Jesse Brandeburg for whom it manifested as an
MSI-X device refusing to use MSI-X mode when the driver was unloaded
and reloaded repeatedly.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 7a3f202..c9513e1 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -1140,6 +1140,20 @@ static void __clear_irq_vector(int irq)
 
 	cfg->vector = 0;
 	cpus_clear(cfg->domain);
+
+	if (likely(!cfg->move_in_progress))
+		return;
+	cpus_and(mask, cfg->old_domain, cpu_online_map);
+	for_each_cpu_mask_nr(cpu, mask) {
+		for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS;
+								vector++) {
+			if (per_cpu(vector_irq, cpu)[vector] != irq)
+				continue;
+			per_cpu(vector_irq, cpu)[vector] = -1;
+			break;
+		}
+	}
+	cfg->move_in_progress = 0;
 }
 
 void __setup_vector_irq(int cpu)

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
