Return-Path: <linux-kernel-owner+w=401wt.eu-S1761423AbXJLQri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761423AbXJLQri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756244AbXJLQr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:47:28 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:62427 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440AbXJLQr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:47:27 -0400
Date: Fri, 12 Oct 2007 11:37:23 -0500
From: Corey Minyard <minyard@acm.org>
Subject: [PATCH 1/7] IPMI: don't init irq until ready
To: Andrew Morton <akpm@osdl.org>
Cc: Patrick Schoeller <Patrick.Schoeller@hp.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Reply-to: minyard@acm.org
Message-id: <20071012163723.GA22142@minyard.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Corey Minyard <cminyard@mvista.com>

Patrick found a race at startup.  Interrupts were being enabled for
the IPMI interface before the driver was really ready to handle them.
This could result in an oops if something was pending on the interface
at startup and interrupt were already enabled (technically shouldn't
happen, but need to cover for this in real life).  So move the IRQ
setup to the code that starts the actual IPMI processing.

Not needed for the stable kernel, very few IPMI devices have interrupts.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: Patrick Schoeller <Patrick.Schoeller@hp.com>

---
Index: linux-2.6.21/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux-2.6.21.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux-2.6.21/drivers/char/ipmi/ipmi_si_intf.c
@@ -1006,6 +1006,10 @@ static int smi_start_processing(void    
 
 	new_smi->intf = intf;
 
+	/* Try to claim any interrupts. */
+	if (new_smi->irq_setup)
+		new_smi->irq_setup(new_smi);
+
 	/* Set up the timer that drives the interface. */
 	setup_timer(&new_smi->si_timer, smi_timeout, (long)new_smi);
 	new_smi->last_timeout_jiffies = jiffies;
@@ -2762,10 +2766,6 @@ static int try_smi_init(struct smi_info 
 	setup_oem_data_handler(new_smi);
 	setup_xaction_handlers(new_smi);
 
-	/* Try to claim any interrupts. */
-	if (new_smi->irq_setup)
-		new_smi->irq_setup(new_smi);
-
 	INIT_LIST_HEAD(&(new_smi->xmit_msgs));
 	INIT_LIST_HEAD(&(new_smi->hp_xmit_msgs));
 	new_smi->curr_msg = NULL;
