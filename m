Return-Path: <linux-kernel-owner+w=401wt.eu-S1757644AbXLKXFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644AbXLKXFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 18:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbXLKXF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 18:05:28 -0500
Received: from deeprooted.net ([216.254.16.51]:55085 "EHLO paris.hilman.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753034AbXLKXF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 18:05:27 -0500
X-Greylist: delayed 674 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Dec 2007 18:05:27 EST
From: Kevin Hilman <khilman@mvista.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Kevin Hilman <khilman@mvista.com>
Subject: [PATCH] Generic IRQ: Add unlocked version of set_irq_handler()
Date: Tue, 11 Dec 2007 14:54:11 -0800
Message-Id: <1197413651-23076-1-git-send-email-khilman@mvista.com>
X-Mailer: git-send-email 1.5.3.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add unlocked version for use by irq_chip.set_type handlers which may
wish to change handler to level or edge handler when IRQ type is
changed.

The normal set_irq_handler() call cannot be used because it tries to
take irq_desc.lock which is already held when the irq_chip.set_type
hook is called.

Signed-off-by: Kevin Hilman <khilman@mvista.com>
---
 include/linux/irq.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index efc8853..4669be0 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -339,6 +339,13 @@ extern void
 __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		  const char *name);
 
+/* caller has locked the irq_desc and both params are valid */
+static inline void __set_irq_handler_unlocked(int irq,
+					      irq_flow_handler_t handler)
+{
+	irq_desc[irq].handle_irq = handler;
+}
+
 /*
  * Set a highlevel flow handler for a given IRQ:
  */
-- 
1.5.3.7

