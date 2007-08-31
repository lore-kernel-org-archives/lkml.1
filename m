Return-Path: <linux-kernel-owner+w=401wt.eu-S932436AbXHaDI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbXHaDI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 23:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756751AbXHaDIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 23:08:16 -0400
Received: from deeprooted.net ([216.254.16.51]:52753 "EHLO paris.hilman.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756714AbXHaDIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 23:08:15 -0400
Message-Id: <20070831030745.794000733@mvista.com>
User-Agent: quilt/0.45-1
Date: Thu, 30 Aug 2007 20:07:45 -0700
From: Kevin Hilman <khilman@mvista.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>
Subject: [PATCH 2.6.23-rc2-rt2] call IRQ-chip's end hook in thread_simple_irq()
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When using the 'simple' handler as a chained handler, the end hook
should be called so the chained handler can properly ack/unmask
etc. after the threaded handler has completed.

In particular, the chained GPIO IRQ hander on OMAP uses the 'simple'
handler since the GPIO IRQs can be dynamically configured either as
edge or level.  When using threaded IRQs, the only way to know when
the handler is done and do the proper ack/unmask is via the end hook.

Signed-off-by: Kevin Hilman <khilman@mvista.com>

--- linux-2.6.21.orig/kernel/irq/manage.c
+++ linux-2.6.21/kernel/irq/manage.c
@@ -637,6 +637,8 @@ static void thread_simple_irq(irq_desc_t
 			note_interrupt(irq, desc, action_ret);
 	}
 	desc->status &= ~IRQ_INPROGRESS;
+	if (desc->chip->end)
+		desc->chip->end(irq);
 }
 
 /*
--
