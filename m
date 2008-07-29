Return-Path: <linux-kernel-owner+w=401wt.eu-S1752495AbYG2UHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbYG2UHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 16:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbYG2UGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 16:06:14 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:21107 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752555AbYG2UGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 16:06:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=OBaCvxFV7/weranvmojfrp6DHn1wzxNpNJZf5mAvMnGcuU94khbkiyCmoGY6PnI4hdzxfK8nBlwQTdKnvthJ0r+VvUnSdE2kmUsEKIwzO/Jkb0NqEVTZB4wKobCHSO0yxOqtwsBMx2OTDBGdNMR8CJ92VWAcWVY6FMDIAPzKqa0=  ;
X-YMail-OSG: Gfym0jsVM1lngP5a871xcDY571lZbW1ikl2_dnryKmXHqIXQm9Gz7UkmCSiZyarawA7J.FagzFAr53Gk2JpmkKRHc7ToA8nElrL2Ik_hbg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.27-r1] irq: warn about (IRQF_DISABLED|IRQF_SHARED)
Date: Tue, 29 Jul 2008 13:00:19 -0700
User-Agent: KMail/1.9.9
Cc: Alan Stern <stern@rowland.harvard.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807291300.20094.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

We periodically waste time tracking down problems caused by the IRQ
framework not respecting IRQF_DISABLED for some shared IRQ cases.
Linus views this as "will not fix", but we're still left with
the bugs caused by this misbehavior.

This patch adds a nag message in request_irq(), so that drivers
can fix their IRQ handlers to avoid this problem.

Note that developers will never see the relevant bugs when they
run with LOCKDEP, so it's no wonder these bugs are hard to find.
(That also means LOCKDEP is overlooking some IRQ-related bugs
involving IRQ handlers that don't set IRQF_DISABLED...)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
This was the root cause of some USB oopsing a while back ...

 kernel/irq/manage.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/kernel/irq/manage.c	2008-07-26 17:40:47.000000000 -0700
+++ b/kernel/irq/manage.c	2008-07-26 17:40:50.000000000 -0700
@@ -597,6 +597,18 @@ int request_irq(unsigned int irq, irq_ha
 	struct irqaction *action;
 	int retval;
 
+	/*
+	 * handle_IRQ_event() always ignores IRQF_DISABLED except for
+	 * the _first_ irqaction (sigh).  That can cause oopsing, but
+	 * the behavior is classified as "will not fix" so we need to
+	 * start nudging drivers away from using that idiom.
+	 */
+	if ((irqflags & (IRQF_SHARED|IRQF_DISABLED))
+			== (IRQF_SHARED|IRQF_DISABLED))
+		pr_warning("IRQ %d/%s: IRQF_DISABLED is not "
+				"guaranteed on shared IRQs\n",
+				irq, devname);
+
 #ifdef CONFIG_LOCKDEP
 	/*
 	 * Lockdep wants atomic interrupt handlers:
