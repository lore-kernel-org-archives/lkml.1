Return-Path: <linux-kernel-owner+w=401wt.eu-S937439AbYBWAs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937439AbYBWAs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:48:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbYBWAf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:35:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:55701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935371AbYBWAf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:35:58 -0500
Date: Fri, 22 Feb 2008 16:31:20 -0800
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
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 30/38] genirq: do not leave interupts enabled on free_irq
Message-ID: <20080223003120.GE7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="genirq-do-not-leave-interupts-enabled-on-free_irq.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

commit 89d694b9dbe769ca1004e01db0ca43964806a611

The default_disable() function was changed in commit:

 76d2160147f43f982dfe881404cfde9fd0a9da21
 genirq: do not mask interrupts by default

It removed the mask function in favour of the default delayed
interrupt disabling. Unfortunately this also broke the shutdown in
free_irq() when the last handler is removed from the interrupt for
those architectures which rely on the default implementations. Now we
can end up with a enabled interrupt line after the last handler was
removed, which can result in spurious interrupts.

Fix this by adding a default_shutdown function, which is only
installed, when the irqchip implementation does provide neither a
shutdown nor a disable function.


Pointed-out-by: Michael Hennerich <Michael.Hennerich@analog.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Tested-by: Michael Hennerich <Michael.Hennerich@analog.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 kernel/irq/chip.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -246,6 +246,17 @@ static unsigned int default_startup(unsi
 }
 
 /*
+ * default shutdown function
+ */
+static void default_shutdown(unsigned int irq)
+{
+	struct irq_desc *desc = irq_desc + irq;
+
+	desc->chip->mask(irq);
+	desc->status |= IRQ_MASKED;
+}
+
+/*
  * Fixup enable/disable function pointers
  */
 void irq_chip_set_defaults(struct irq_chip *chip)
@@ -256,8 +267,15 @@ void irq_chip_set_defaults(struct irq_ch
 		chip->disable = default_disable;
 	if (!chip->startup)
 		chip->startup = default_startup;
+	/*
+	 * We use chip->disable, when the user provided its own. When
+	 * we have default_disable set for chip->disable, then we need
+	 * to use default_shutdown, otherwise the irq line is not
+	 * disabled on free_irq():
+	 */
 	if (!chip->shutdown)
-		chip->shutdown = chip->disable;
+		chip->shutdown = chip->disable != default_disable ?
+			chip->disable : default_shutdown;
 	if (!chip->name)
 		chip->name = chip->typename;
 	if (!chip->end)

-- 
