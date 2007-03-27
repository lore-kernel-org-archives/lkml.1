Return-Path: <linux-kernel-owner+w=401wt.eu-S934152AbXC0Sb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934152AbXC0Sb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 14:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934157AbXC0SbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 14:31:00 -0400
Received: from [198.99.130.12] ([198.99.130.12]:45434 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S934163AbXC0Saz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 14:30:55 -0400
Date: Tue, 27 Mar 2007 14:27:49 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 5/6] UML - irq locking fixes
Message-ID: <20070327182749.GA8416@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As the comment immediately preceding this points out, this list is
changed in irq context, so it needs to be protected with
spin_lock_irqsave in process context when it is processed.

Sometimes, gcc should just compile the comments and forget the code.

The IRQ side of this was better, in the sense that it blocked and
unblocked interrupts, but it still should have saved and restored
them.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/drivers/chan_kern.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

Index: linux-2.6.21-mm/arch/um/drivers/chan_kern.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/chan_kern.c	2007-03-27 12:25:09.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/chan_kern.c	2007-03-27 12:56:21.000000000 -0400
@@ -235,11 +235,11 @@ void free_irqs(void)
 	struct chan *chan;
 	LIST_HEAD(list);
 	struct list_head *ele;
+	unsigned long flags;
 
-	spin_lock_irq(&irqs_to_free_lock);
+	spin_lock_irqsave(&irqs_to_free_lock, flags);
 	list_splice_init(&irqs_to_free, &list);
-	INIT_LIST_HEAD(&irqs_to_free);
-	spin_unlock_irq(&irqs_to_free_lock);
+	spin_unlock_irqrestore(&irqs_to_free_lock, flags);
 
 	list_for_each(ele, &list){
 		chan = list_entry(ele, struct chan, free_list);
@@ -254,13 +254,15 @@ void free_irqs(void)
 
 static void close_one_chan(struct chan *chan, int delay_free_irq)
 {
+	unsigned long flags;
+
 	if(!chan->opened)
 		return;
 
 	if(delay_free_irq){
-		spin_lock_irq(&irqs_to_free_lock);
+		spin_lock_irqsave(&irqs_to_free_lock, flags);
 		list_add(&chan->free_list, &irqs_to_free);
-		spin_unlock_irq(&irqs_to_free_lock);
+		spin_unlock_irqrestore(&irqs_to_free_lock, flags);
 	}
 	else {
 		if(chan->input)
