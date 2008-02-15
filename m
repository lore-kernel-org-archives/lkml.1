Return-Path: <linux-kernel-owner+w=401wt.eu-S934374AbYBOOK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934374AbYBOOK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 09:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933599AbYBOOKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 09:10:37 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:42642 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761338AbYBOOKf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 09:10:35 -0500
X-IronPort-AV: E=Sophos;i="4.25,358,1199682000"; 
   d="scan'208";a="62322178"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: linux/kernel/irq/chip.c IRQ disable, shutdown bug
Date: Fri, 15 Feb 2008 14:10:18 -0000
Message-ID: <600D5CB4DFD93545BF61FF01473D11AC124E5D34@limkexm2.ad.analog.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: linux/kernel/irq/chip.c IRQ disable, shutdown bug
Thread-Index: Achv3H69FqF5wehTQiWegSOtpRTnUw==
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 15 Feb 2008 14:10:33.0237 (UTC) FILETIME=[873B7C50:01C86FDC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

free_irq() does not disable/mask the irq, in case disable or shutdown in struct irq_chip is left uninitilazied.

/**
 * struct irq_chip - hardware interrupt chip descriptor
 *
 * @name:		name for /proc/interrupts
 * @startup:		start up the interrupt (defaults to ->enable if NULL)
 * @shutdown:		shut down the interrupt (defaults to ->disable if NULL)
 * @enable:		enable the interrupt (defaults to chip->unmask if NULL)
 * @disable:		disable the interrupt (defaults to chip->mask if NULL)


According to linux/irq.h struct irq_chip information,
chip->disable should default to chip->mask if NULL.
However irq_chip_set_defaults(struct irq_chip *chip) will set it to default_disable a empty function.


Looking through various architectures, it's pretty common that disable and shutdown is NULL.
So this bug affects many architectures.

This patch fixes the issue.

Best regards,
Michael

Index: irq/chip.c
===================================================================
--- irq/chip.c  (revision 4276)
+++ irq/chip.c  (working copy)
@@ -233,6 +233,10 @@
  */
 static void default_disable(unsigned int irq)
 {
+       struct irq_desc *desc = irq_desc + irq;
+
+       desc->chip->mask(irq);
+       desc->status |= IRQ_MASKED;
 }

 /*


------------------------------------------------------------------
********* Analog Devices GmbH         michael.hennerich@analog.com
**  *****                                      Systems Engineering
**     ** Wilhelm-Wagenfeld-Strasse 6       
**  ***** D-80807 Munich                      
********* Germany                          
Registergericht München HRB 40368,  Geschäftsführer:  Thomas Wessel,  Vincent Roche,  Joseph E. McDonough
