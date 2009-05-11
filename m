Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbZEKOWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbZEKOWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbZEKOWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:22:39 -0400
Received: from www.tglx.de ([62.245.132.106]:39799 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbZEKOWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:22:38 -0400
Date: Mon, 11 May 2009 16:22:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frans Pop <elendil@planet.nl>
cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       len.brown@intel.com, mingo@elte.hu, johnstul@us.ibm.com
Subject: [PATCH] ACPI: do not mark TSC unstable for invalid C-states
In-Reply-To: <200905110226.50115.elendil@planet.nl>
Message-ID: <alpine.LFD.2.00.0905111614570.3561@localhost.localdomain>
References: <alpine.DEB.2.00.0905072359530.28378@gandalf.stny.rr.com> <200905110226.50115.elendil@planet.nl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit a71e4917dc0ebbcb5a0ecb7ca3486643c1c9a6e2 (ACPI: idle:
mark_tsc_unstable() at init-time, not run-time) marks TSC unstable
even on non affected systems.

The reason is that the state enumeration does not check the cx->valid
flag before calling tsc_halts_in_c(), so it marks TSC unstable for any
enumerated albeit invalid C state which is known to turn off TSC.

Check cx->valid before checking whether the TSC might become unstable.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/acpi/processor_idle.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/acpi/processor_idle.c
===================================================================
--- linux-2.6.orig/drivers/acpi/processor_idle.c
+++ linux-2.6/drivers/acpi/processor_idle.c
@@ -583,7 +583,7 @@ static int acpi_processor_power_verify(s
 
 #if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
 		/* TSC could halt in idle, so notify users */
-		if (tsc_halts_in_c(cx->type))
+		if (cx->valid && tsc_halts_in_c(cx->type))
 			mark_tsc_unstable("TSC halts in idle");;
 #endif
 		switch (cx->type) {


