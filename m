Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbXKBRvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbXKBRvr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbXKBRvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:51:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43060 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbXKBRvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:51:39 -0400
Date: Fri, 2 Nov 2007 10:37:55 -0700
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
Subject: [patch 3/9] genirq: mark io_apic level interrupts to avoid resend
Message-ID: <20071102173755.GD6378@kroah.com>
References: <20071102173359.709442489@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="genirq-mark-io_apic-level-interrupts-to-avoid-resend.patch"
In-Reply-To: <20071102173733.GA6378@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

patch cc75b92d11384ba14f93828a2a0040344ae872e7 in mainline.

Level type interrupts do not need to be resent.  It was also found that
some chipsets get confused in case of the resend.

Mark the ioapic level type interrupts as such to avoid the resend
functionality in the generic irq code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/i386/kernel/io_apic.c   |    7 +++++--
 arch/x86_64/kernel/io_apic.c |    7 +++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

--- a/arch/i386/kernel/io_apic.c
+++ b/arch/i386/kernel/io_apic.c
@@ -1275,12 +1275,15 @@ static struct irq_chip ioapic_chip;
 static void ioapic_register_intr(int irq, int vector, unsigned long trigger)
 {
 	if ((trigger == IOAPIC_AUTO && IO_APIC_irq_trigger(irq)) ||
-			trigger == IOAPIC_LEVEL)
+	    trigger == IOAPIC_LEVEL) {
+		irq_desc[irq].status |= IRQ_LEVEL;
 		set_irq_chip_and_handler_name(irq, &ioapic_chip,
 					 handle_fasteoi_irq, "fasteoi");
-	else
+	} else {
+		irq_desc[irq].status &= ~IRQ_LEVEL;
 		set_irq_chip_and_handler_name(irq, &ioapic_chip,
 					 handle_edge_irq, "edge");
+	}
 	set_intr_gate(vector, interrupt[irq]);
 }
 
--- a/arch/x86_64/kernel/io_apic.c
+++ b/arch/x86_64/kernel/io_apic.c
@@ -774,12 +774,15 @@ static struct irq_chip ioapic_chip;
 
 static void ioapic_register_intr(int irq, unsigned long trigger)
 {
-	if (trigger)
+	if (trigger) {
+		irq_desc[irq].status |= IRQ_LEVEL;
 		set_irq_chip_and_handler_name(irq, &ioapic_chip,
 					      handle_fasteoi_irq, "fasteoi");
-	else
+	} else {
+		irq_desc[irq].status &= ~IRQ_LEVEL;
 		set_irq_chip_and_handler_name(irq, &ioapic_chip,
 					      handle_edge_irq, "edge");
+	}
 }
 
 static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq,

-- 
