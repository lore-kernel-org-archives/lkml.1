Return-Path: <linux-kernel-owner+w=401wt.eu-S1758555AbZAHMOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555AbZAHMOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 07:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbZAHMOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 07:14:31 -0500
Received: from mercury.realtime.net ([205.238.132.86]:37581 "EHLO
	mercury.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbZAHMOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:14:31 -0500
Subject: [PATCH 3/4] hvc_console: free_irq only if request_irq was successful
From: Milton Miller <miltonm@bga.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>,
       Benjiman Herrenschmidt <benh@kernel.crashing.org>
cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       lkml <linux-kernel@vger.kernel.org>, Joe Peterson <joe@skyrush.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-Id: <hvc-console-29-3-3@bga.com>
In-Reply-To: : <hvc-console-29-3@bga.com>
Date: Thu, 08 Jan 2009 06:14:21 -0600
X-Originating-IP: 205.232.218.56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only call free_irq if we marked the request_irq has having succeeded
instead of whenever the the sub-driver identified the interrupt to use.

Signed-off-by: Milton Miller <miltonm@bga.com>
---
Appears to be a bugfix but might use a bit of time in -next.
This code was created in 2.6.28 to allow s390 to build without adding ifdefs.
Many hvc-console sub-drivers have a single channel and are not modules.

Index: work.git/drivers/char/hvc_irq.c
===================================================================
--- work.git.orig/drivers/char/hvc_irq.c	2009-01-08 04:07:28.000000000 -0600
+++ work.git/drivers/char/hvc_irq.c	2009-01-08 04:07:47.000000000 -0600
@@ -37,7 +37,7 @@ int notifier_add_irq(struct hvc_struct *
 
 void notifier_del_irq(struct hvc_struct *hp, int irq)
 {
-	if (!irq)
+	if (!hp->irq_requested)
 		return;
 	free_irq(irq, hp);
 	hp->irq_requested = 0;
