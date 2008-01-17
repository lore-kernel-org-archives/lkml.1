Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbYAQHBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbYAQHBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 02:01:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbYAQHAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 02:00:43 -0500
Received: from ozlabs.org ([203.10.76.45]:36578 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbYAQHAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 02:00:39 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] BUG_ON() bad input to request_irq
Date: Thu, 17 Jan 2008 17:59:58 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
References: <200801171757.59026.rusty@rustcorp.com.au>
In-Reply-To: <200801171757.59026.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801171759.59029.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any reason why these bugs should be treated gently?  The
caller might not want to check NR_IRQS and IRQ_NOREQUEST cases, but
a NULL handler or NULL dev_id w/ shared are coding bugs.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/irq/manage.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -r c2eb8ef5a0be kernel/irq/manage.c
--- a/kernel/irq/manage.c	Thu Jan 17 15:48:03 2008 +1100
+++ b/kernel/irq/manage.c	Thu Jan 17 15:49:33 2008 +1100
@@ -532,13 +532,12 @@ int request_irq(unsigned int irq, irq_ha
 	 * which interrupt is which (messes up the interrupt freeing
 	 * logic etc).
 	 */
-	if ((irqflags & IRQF_SHARED) && !dev_id)
-		return -EINVAL;
+	BUG_ON((irqflags & IRQF_SHARED) && !dev_id);
+	BUG_ON(!handler);
+
 	if (irq >= NR_IRQS)
 		return -EINVAL;
 	if (irq_desc[irq].status & IRQ_NOREQUEST)
-		return -EINVAL;
-	if (!handler)
 		return -EINVAL;
 
 	action = kmalloc(sizeof(struct irqaction), GFP_ATOMIC);
