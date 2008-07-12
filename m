Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbYGLX17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbYGLX17 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 19:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYGLX1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 19:27:52 -0400
Received: from mail4.aster.pl ([212.76.33.58]:22185 "EHLO mail4.aster.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451AbYGLX1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 19:27:51 -0400
Content-Disposition: inline
From: "Jakub W. Jozwicki" <jozwicki@aster.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.25.10 1/2] libata: fix locking for kmap_atomic
Date: Sun, 13 Jul 2008 01:27:36 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200807130127.36706.jozwicki@aster.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change locking surrounding kmap_atomic from local_irqsave to 
local_irqsave_nort. This fixes issues with PREEMPT_RT.
 
Signed-off-by:  Jakub Jozwicki <jozwicki@aster.pl>

--- linux-2.6.25.10/drivers/ata/libata-core.c	2008-07-03 05:46:47.000000000 
+0200
+++ linux-2.6.25.10-rt7/drivers/ata/libata-core.c	2008-07-12 
23:59:33.132140258 +0200
@@ -5157,14 +5157,14 @@
 		unsigned long flags;
 
 		/* FIXME: use a bounce buffer */
-		local_irq_save(flags);
+		local_irq_save_nort(flags);
 		buf = kmap_atomic(page, KM_IRQ0);
 
 		/* do the actual data transfer */
 		ap->ops->data_xfer(qc->dev, buf + offset, qc->sect_size, do_write);
 
 		kunmap_atomic(buf, KM_IRQ0);
-		local_irq_restore(flags);
+		local_irq_restore_nort(flags);
 	} else {
 		buf = page_address(page);
 		ap->ops->data_xfer(qc->dev, buf + offset, qc->sect_size, do_write);
@@ -5294,14 +5294,14 @@
 		unsigned long flags;
 
 		/* FIXME: use bounce buffer */
-		local_irq_save(flags);
+		local_irq_save_nort(flags);
 		buf = kmap_atomic(page, KM_IRQ0);
 
 		/* do the actual data transfer */
 		consumed = ap->ops->data_xfer(dev,  buf + offset, count, rw);
 
 		kunmap_atomic(buf, KM_IRQ0);
-		local_irq_restore(flags);
+		local_irq_restore_nort(flags);
 	} else {
 		buf = page_address(page);
 		consumed = ap->ops->data_xfer(dev,  buf + offset, count, rw);
