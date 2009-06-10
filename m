Return-Path: <linux-kernel-owner+w=401wt.eu-S1756912AbZFJDfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbZFJDfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 23:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755436AbZFJDdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 23:33:39 -0400
Received: from kroah.org ([198.145.64.141]:56643 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755415AbZFJDdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 23:33:38 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 17:23:41 2009
Message-Id: <20090610002341.717841012@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 17:13:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 09/60] sparc64: Fix lost interrupts on sun4u.
References: <20090610001328.251476848@blue.kroah.org>
Content-Disposition: inline; filename=sparc64-fix-lost-interrupts-on-sun4u.patch
In-Reply-To: <20090610032135.GA19346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David S. Miller <davem@davemloft.net>

[ Upstream commit d0cac39e4ec8097e4c7099d291b1fdcc0fe56b58 ]

Based upon a report by Meelis Roos.

Sparc64 SBUS and PCI controllers use a combination of IMAP and ICLR
registers to manage device interrupts.

The IMAP register contains the "valid" enable bit as well as CPU
targetting information.  Whereas the ICLR register is written with
zero at the end of handling an interrupt to reset the state machine
for that interrupt to IDLE so it can be sent again.

For PCI slot and SBUS slot devices we can have multiple interrupts
sharing the same IMAP register.  There are individual ICLR registers
but only one IMAP register for managing those.

We represent each shared case with individual virtual IRQs so the
generic IRQ layer thinks there is only one user of the IRQ instance.

In such shared IMAP cases this is wrong, so if there are multiple
active users then a free_irq() call will prematurely turn off the
interrupt by clearing the Valid bit in the IMAP register even though
there are other active users.

Fix this by simply doing nothing in sun4u_disable_irq() and checking
IRQF_DISABLED during IRQ dispatch.

This situation doesn't exist in the hypervisor sun4v cases, so I left
those alone.

Tested-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc64/kernel/irq.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

--- a/arch/sparc64/kernel/irq.c
+++ b/arch/sparc64/kernel/irq.c
@@ -318,17 +318,25 @@ static void sun4u_set_affinity(unsigned 
 	sun4u_irq_enable(virt_irq);
 }
 
+/* Don't do anything.  The desc->status check for IRQ_DISABLED in
+ * handler_irq() will skip the handler call and that will leave the
+ * interrupt in the sent state.  The next ->enable() call will hit the
+ * ICLR register to reset the state machine.
+ *
+ * This scheme is necessary, instead of clearing the Valid bit in the
+ * IMAP register, to handle the case of IMAP registers being shared by
+ * multiple INOs (and thus ICLR registers).  Since we use a different
+ * virtual IRQ for each shared IMAP instance, the generic code thinks
+ * there is only one user so it prematurely calls ->disable() on
+ * free_irq().
+ *
+ * We have to provide an explicit ->disable() method instead of using
+ * NULL to get the default.  The reason is that if the generic code
+ * sees that, it also hooks up a default ->shutdown method which
+ * invokes ->mask() which we do not want.  See irq_chip_set_defaults().
+ */
 static void sun4u_irq_disable(unsigned int virt_irq)
 {
-	struct irq_handler_data *data = get_irq_chip_data(virt_irq);
-
-	if (likely(data)) {
-		unsigned long imap = data->imap;
-		unsigned long tmp = upa_readq(imap);
-
-		tmp &= ~IMAP_VALID;
-		upa_writeq(tmp, imap);
-	}
 }
 
 static void sun4u_irq_eoi(unsigned int virt_irq)
@@ -739,7 +747,8 @@ void handler_irq(int irq, struct pt_regs
 
 		desc = irq_desc + virt_irq;
 
-		desc->handle_irq(virt_irq, desc);
+		if (!(desc->status & IRQ_DISABLED))
+			desc->handle_irq(virt_irq, desc);
 
 		bucket_pa = next_pa;
 	}


