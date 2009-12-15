Return-Path: <linux-kernel-owner+w=401wt.eu-S932506AbZLOQfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506AbZLOQfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 11:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759681AbZLOQey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 11:34:54 -0500
Received: from gv-out-0910.google.com ([216.239.58.189]:50098 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759461AbZLOQew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 11:34:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=od2QlmRxW3IP6ExASioZLlOTsDS4dhmLtYxnayyMLqCqDTHTUkOoWd5QEvWOWEK6qe
         OdVAuJj6Vxn6lvdWVR4ncgREM2Xs3cB3Lkyq/M33H6zv/sQmXzJBPaQnbPVqKSI1wKOU
         BNIcfrxGbQBvUKZKXrd4Q6aFLUOrleJaEM47g=
Message-ID: <4B27BB12.1050008@gmail.com>
Date: Tue, 15 Dec 2009 17:36:34 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sh: Fix test of unsigned in se7722_irq_demux()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

se7722_fpga_irq[] is unsigned so the test does not work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found using coccinelle: http://coccinelle.lip6.fr/

diff --git a/arch/sh/boards/mach-se/7722/irq.c b/arch/sh/boards/mach-se/7722/irq.c
index 4eb31ac..b221b68 100644
--- a/arch/sh/boards/mach-se/7722/irq.c
+++ b/arch/sh/boards/mach-se/7722/irq.c
@@ -57,15 +57,16 @@ static void se7722_irq_demux(unsigned int irq, struct irq_desc *desc)
  */
 void __init init_se7722_IRQ(void)
 {
-	int i;
+	int i, irq;
 
 	ctrl_outw(0, IRQ01_MASK);       /* disable all irqs */
 	ctrl_outw(0x2000, 0xb03fffec);  /* mrshpc irq enable */
 
 	for (i = 0; i < SE7722_FPGA_IRQ_NR; i++) {
-		se7722_fpga_irq[i] = create_irq();
-		if (se7722_fpga_irq[i] < 0)
+		irq = create_irq();
+		if (irq < 0)
 			return;
+		se7722_fpga_irq[i] = irq;
 
 		set_irq_chip_and_handler_name(se7722_fpga_irq[i],
 					      &se7722_irq_chip,
