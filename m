Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbYGNTf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbYGNTf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 15:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755028AbYGNTfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 15:35:45 -0400
Received: from delay-av.club-internet.fr ([194.158.96.170]:60270 "EHLO
	delay-av.club-internet.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142AbYGNTfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 15:35:44 -0400
X-Greylist: delayed 1449 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jul 2008 15:35:44 EDT
Date: Mon, 14 Jul 2008 21:11:33 +0200
From: Dimitri Gorokhovik <dimitri.gorokhovik@free.fr>
To: linux-ide@vger.kernel.org, bzolnier@gmail.com
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] ide: it821x in pass-through mode segfaults in 2.6.26-stable
Message-ID: <20080714211133.514936a4@laphroaig>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Let me know if you need the kernel config for this.) 
---
The driver of ITE8212 in pass-through mode (it8212.noraid=1 on cmndline)
attempts to use the field `.dma_host_set' of the struct ide_dma_ops in
`ide_config_drive_speed' which is set to NULL by default.

So give a value to all fields of the struct ide_dma_ops.

---
diff --git a/drivers/ide/pci/it821x.c b/drivers/ide/pci/it821x.c
index 6ab0411..cbf6472 100644
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -512,8 +512,14 @@ static void __devinit it821x_quirkproc(ide_drive_t *drive)
 }
 
 static struct ide_dma_ops it821x_pass_through_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= it821x_dma_start,
 	.dma_end		= it821x_dma_end,
+	.dma_test_irq		= ide_dma_test_irq,
+	.dma_timeout		= ide_dma_timeout,
+	.dma_lost_irq		= ide_dma_lost_irq,
 };
 
 /**
	
