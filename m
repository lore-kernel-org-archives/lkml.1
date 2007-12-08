Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbXLHBsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbXLHBsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 20:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbXLHBsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 20:48:03 -0500
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:34907 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbXLHBsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 20:48:00 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Dec 2007 20:48:00 EST
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH/RFC -rt] local_bh_enable() is safe for irqs_disabled()
From: Kevin Hilman <kevin@hilman.org>
Organization: None to speak of.
Date: Fri, 07 Dec 2007 17:41:24 -0800
Message-ID: <87fxyearp7.fsf@vence.hilman.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In local_bh_enable() there is a WARN_ON(irqs_disabled()), but looking
at the rest of the code, it seems it expects to be used with
interrupts off, so is this warning really necessary?

I hit this warning in the ads7846 touchscreen driver timer function
where enable_irq() may be called with interrupts disabled.  Since
enable_irq now calls local_bh_disable/enable for IRQ resend, this
warning is triggered.

Patch against 2.6.23.9-rt12

Signed-off-by: Kevin Hilman <khilman@mvista.com>

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 4c19017..68149ae 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -207,7 +207,6 @@ void local_bh_enable(void)
 
 	WARN_ON_ONCE(in_irq());
 #endif
-	WARN_ON_ONCE(irqs_disabled());
 
 #ifdef CONFIG_TRACE_IRQFLAGS
 	local_irq_save(flags);
