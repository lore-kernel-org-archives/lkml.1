Return-Path: <linux-kernel-owner+w=401wt.eu-S1759583AbXKBRsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583AbXKBRsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755335AbXKBRs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:48:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41016 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbXKBRs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:48:27 -0400
Date: Fri, 2 Nov 2007 10:37:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 2/9] genirq: suppress resend of level interrupts
Message-ID: <20071102173752.GC6378@kroah.com>
References: <20071102173359.709442489@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="genirq-suppress-resend-of-level-interrupts.patch"
In-Reply-To: <20071102173733.GA6378@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

patch 2464286ace55b3abddfb9cc30ab95e2dac1de9a6 in mainline.

Level type interrupts are resent by the interrupt hardware when they are
still active at irq_enable().

Suppress the resend mechanism for interrupts marked as level.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/irq/resend.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/kernel/irq/resend.c
+++ b/kernel/irq/resend.c
@@ -62,7 +62,12 @@ void check_irq_resend(struct irq_desc *d
 	 */
 	desc->chip->enable(irq);
 
-	if ((status & (IRQ_PENDING | IRQ_REPLAY)) == IRQ_PENDING) {
+	/*
+	 * We do not resend level type interrupts. Level type
+	 * interrupts are resent by hardware when they are still
+	 * active.
+	 */
+	if ((status & (IRQ_LEVEL | IRQ_PENDING | IRQ_REPLAY)) == IRQ_PENDING) {
 		desc->status = (status & ~IRQ_PENDING) | IRQ_REPLAY;
 
 		if (!desc->chip || !desc->chip->retrigger ||

-- 
