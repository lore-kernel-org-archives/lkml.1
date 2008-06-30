Return-Path: <linux-kernel-owner+w=401wt.eu-S932364AbYF3T6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364AbYF3T6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763500AbYF3T54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:57:56 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:28695 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762913AbYF3T5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:57:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=QqB75F2irTZv/ZXBVauYy8ElDMFQCkOHg1zJhX339qEqf6/JdMdrLJFpTFVURvK47aR3eajkvTlfHWfhQXNuFOy/S9gxELuU/faVqewr7A1jdhcRoEjPODRalBGpqmD1reYVEY7npvxXthHQ9/QxC8f699yjlR6nTFhbCxIMIh8=  ;
X-YMail-OSG: 160DooYVM1kwMPPVvjGoHo1IJAQC1GPdX2Bx5saUAxwZ1BMscBLB.27C1AR0BDwtuUKKT8o66MHPD6edy.iSkOwU56gFOasejJMeyzzqDsPGKf9MuFA2N3fybcJu7M_3qMs-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Stefan Becker <Stefan.Becker@nokia.com>
Subject: Re: PATCH: 2.6.26-rc8: Fix IRQF_DISABLED for shared interrupts
Date: Mon, 30 Jun 2008 12:57:48 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <Pine.LNX.4.44L0.0806281241200.23326-100000@netrider.rowland.org> <4868A8B1.3090805@nokia.com> <200806300415.15796.david-b@pacbell.net>
In-Reply-To: <200806300415.15796.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806301257.49220.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 June 2008, David Brownell wrote:
> 
> On Monday 30 June 2008, Stefan Becker wrote:
> > It seems IRQF_SHARED | IRQF_DISABLED has already been discussed several 
> > times on LKML:
> 
> Given that, I'm surprised that nobody has added a warning that
> prints when those two flags are both passed to request_irq().

Well, here's a fix for that little problem.

Notice the rude interaction with LOCKDEP too.  If you used that,
you'd never have seen the behavior you saw.  And if you did use
that, with non-IRQF_DISABLED interrupt handlers, you'd wrongly
believe some IRQ code paths always ran with IRQs disabled...

- Dave


===== CUT HERE
We periodically have problems that get tracked down to the IRQ
framework not respecting IRQF_DISABLED for some shared IRQ cases.
Linus views this as "will not fix", but we're still left with
the bugs caused by this misbehavior.

This patch adds a nag message in request_irq(), so that drivers
can fix their IRQ handlers to avoid this problem.

Note that developers will never see the relevant bugs when they
run with LOCKDEP, so it's no wonder these bugs are hard to find.
(That also means LOCKDEP will be missing some IRQ-related bugs
involving IRQ handlers that don't set IRQF_DISABLED.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 kernel/irq/manage.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/kernel/irq/manage.c	2008-06-30 12:28:58.000000000 -0700
+++ b/kernel/irq/manage.c	2008-06-30 12:46:54.000000000 -0700
@@ -539,6 +539,18 @@ int request_irq(unsigned int irq, irq_ha
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

