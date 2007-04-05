Return-Path: <linux-kernel-owner+w=401wt.eu-S932437AbXDEAip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437AbXDEAip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 20:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932433AbXDEAiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 20:38:24 -0400
Received: from [198.99.130.12] ([198.99.130.12]:50394 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932424AbXDEAiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 20:38:21 -0400
Date: Wed, 4 Apr 2007 20:34:03 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [ PATCH 4/4] UML - irq locking commentary
Message-ID: <20070405003403.GA13285@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Locking commentary.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/kernel/irq.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

Index: linux-2.6.21-mm/arch/um/kernel/irq.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/irq.c	2007-04-02 13:04:27.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/irq.c	2007-04-02 14:48:48.000000000 -0400
@@ -78,6 +78,14 @@ skip:
 	return 0;
 }
 
+/*
+ * This list is accessed under irq_lock, except in sigio_handler,
+ * where it is safe from being modified.  IRQ handlers won't change it -
+ * if an IRQ source has vanished, it will be freed by free_irqs just
+ * before returning from sigio_handler.  That will process a separate
+ * list of irqs to free, with its own locking, coming back here to
+ * remove list elements, taking the irq_lock to do so.
+ */
 static struct irq_fd *active_fds = NULL;
 static struct irq_fd **last_irq_ptr = &active_fds;
 
@@ -243,6 +251,7 @@ void free_irq_by_fd(int fd)
 	free_irq_by_cb(same_fd, &fd);
 }
 
+/* Must be called with irq_lock held */
 static struct irq_fd *find_irq_by_fd(int fd, int irqnum, int *index_out)
 {
 	struct irq_fd *irq;
@@ -308,6 +317,12 @@ void deactivate_fd(int fd, int irqnum)
 	ignore_sigio_fd(fd);
 }
 
+/*
+ * Called just before shutdown in order to provide a clean exec
+ * environment in case the system is rebooting.  No locking because
+ * that would cause a pointless shutdown hang if something hadn't
+ * released the lock.
+ */
 int deactivate_all_fds(void)
 {
 	struct irq_fd *irq;
