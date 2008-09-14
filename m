Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbYINR6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbYINR6w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 13:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbYINR6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 13:58:42 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:53251 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbYINR6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 13:58:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=gX4ZbSPGl+lirb9Aj83sCvvGEFEEnEcYFmYmwXUaAqHev+fwe9iR7QqB7ZkwDoTfCC
         m1vXPbr9fHz+bcPADEbeXDBpxE7LEEo/InDzPcvEPWPgB5qboqnAFdZWQx/hCO72kNdf
         gLkN86+eWPLWMEjoQPCYvCj0SmGp5EIkHg+3M=
Date: Sun, 14 Sep 2008 21:58:49 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: smpboot - check if we have ESR register in
	wakeup_secondary_cpu
Message-ID: <20080914175849.GC3907@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should check if we have ESR register before writting to it.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Please review!
it seems the same nit in do_boot_cpu - checking now.

Index: linux-2.6.git/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/smpboot.c	2008-09-14 19:43:03.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/smpboot.c	2008-09-14 21:49:36.000000000 +0400
@@ -598,10 +598,12 @@ wakeup_secondary_cpu(int logical_apicid,
 	 * Give the other CPU some time to accept the IPI.
 	 */
 	udelay(200);
-	maxlvt = lapic_get_maxlvt();
-	if (maxlvt > 3)			/* Due to the Pentium erratum 3AP.  */
-		apic_write(APIC_ESR, 0);
-	accept_status = (apic_read(APIC_ESR) & 0xEF);
+	if (APIC_INTEGRATED(apic_version[phys_apicid])) {
+		maxlvt = lapic_get_maxlvt();
+		if (maxlvt > 3)			/* Due to the Pentium erratum 3AP.  */
+			apic_write(APIC_ESR, 0);
+		accept_status = (apic_read(APIC_ESR) & 0xEF);
+	}
 	pr_debug("NMI sent.\n");
 
 	if (send_status)
