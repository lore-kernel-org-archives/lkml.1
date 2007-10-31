Return-Path: <linux-kernel-owner+w=401wt.eu-S1755016AbXJaUBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbXJaUBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 16:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759480AbXJaUAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 16:00:00 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:48817 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbXJaT77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 15:59:59 -0400
Date: Wed, 31 Oct 2007 15:59:38 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 1/4] UML - Fix spurious IRQ testing
Message-ID: <20071031195938.GA9630@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The spurious IRQ testing in request_irq is mishandled in
um_request_irq, which sets the incoming file descriptors non-blocking
only after request_irq succeeds.  This results in the spurious irq
calling read on a blocking descriptor, and a hang.

Fixed by reversing the O_NONBLOCK setting and the request_irq call.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/kernel/irq.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

Index: linux-2.6.22/arch/um/kernel/irq.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/irq.c	2007-10-25 12:23:09.000000000 -0400
+++ linux-2.6.22/arch/um/kernel/irq.c	2007-10-29 13:00:18.000000000 -0400
@@ -347,14 +347,15 @@ int um_request_irq(unsigned int irq, int
 {
 	int err;
 
-	err = request_irq(irq, handler, irqflags, devname, dev_id);
-	if (err)
-		return err;
-
-	if (fd != -1)
+	if (fd != -1) {
 		err = activate_fd(irq, fd, type, dev_id);
-	return err;
+		if (err)
+			return err;
+	}
+
+	return request_irq(irq, handler, irqflags, devname, dev_id);
 }
+
 EXPORT_SYMBOL(um_request_irq);
 EXPORT_SYMBOL(reactivate_fd);
 
