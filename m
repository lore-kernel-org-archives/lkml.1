Return-Path: <linux-kernel-owner+w=401wt.eu-S1753585AbYJ0ViW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbYJ0ViW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 17:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbYJ0ViG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 17:38:06 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:42581 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751474AbYJ0ViF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 17:38:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=CsH9J8xWUuP6NxRlorwWVAC6TFOdR643+lLOj5yd2EFD2/Qh5/x5FQupNCN+WX0JWxWRDOk0uWKpF+7tzYUcdbzLQDsl+hiabCx6nq1SIktfUgsW+2Z/CBWn7p47TvKmxjrrcNmbLbalRctsfdjhDleht4Hs+v7ARUIzPUsk8g8=  ;
X-YMail-OSG: JWQ9e5kVM1n0Nizv.aIZbWadTCPT1m5090PXiiMQvEGNeiJqqUX0qu2PnOx8KKAFtFyaAm06nmI9mzB4FMmdimWKolQOpdexsE9nBYzj2vOX.JjVFiXnqZbOqN3CrmzE86H1c7VlNhH7OTPUEH1V.1ax
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [patch/RESEND 2.6.28-rc2] genirq: warn when IRQF_DISABLED may be ignored
Date: Mon, 27 Oct 2008 13:48:53 -0700
User-Agent: KMail/1.9.10
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810271348.53492.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

We periodically waste time tracking down problems from the genirq
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
 kernel/irq/manage.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -635,6 +635,18 @@ int request_irq(unsigned int irq, irq_ha
 	struct irq_desc *desc;
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
