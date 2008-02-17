Return-Path: <linux-kernel-owner+w=401wt.eu-S1756579AbYBQXCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbYBQXCj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 18:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbYBQXCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 18:02:30 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:30813 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbYBQXC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 18:02:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=ZuC0QqWFFrV7oYE1E2LYrRsuHFGRkgobKDIbnTpFdORy6FUAWjpXth53S+MippJJlQsctWzEH9C9oc//2kXvZuOxCiUP43biexT1O8bgQq6APbBfuui/N0SLNcInXo7ouvKjRg+Uo7m04FLUpZ2UdqkZW7Zadse0RqQpgu4WttU=
Date: Mon, 18 Feb 2008 00:59:54 +0200
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH x86] i8259A_32: Remove redundant irq_desc[NR_IRQ]
	initialization
Message-ID: <20080217225954.GA3020@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Remove redundant irq_desc[NR_IRQS] element initialization in 
init_ISA_irqs(). irq_desc[NR_IRQS] is already statically 
initialized with the same values in kernel/irq/handle.c .

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

 i8259_32.c |   26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

Tested only on a UP machine with an i8259A PIC.

diff --git a/arch/x86/kernel/i8259_32.c b/arch/x86/kernel/i8259_32.c
index 2d25b77..0fea87d 100644
--- a/arch/x86/kernel/i8259_32.c
+++ b/arch/x86/kernel/i8259_32.c
@@ -26,8 +26,6 @@
  * present in the majority of PC/AT boxes.
  * plus some generic x86 specific things if generic specifics makes
  * any sense at all.
- * this file should become arch/i386/kernel/irq.c when the old irq.c
- * moves to arch independent land
  */
 
 static int i8259A_auto_eoi;
@@ -362,24 +360,12 @@ void __init init_ISA_irqs (void)
 #endif
 	init_8259A(0);
 
-	for (i = 0; i < NR_IRQS; i++) {
-		irq_desc[i].status = IRQ_DISABLED;
-		irq_desc[i].action = NULL;
-		irq_desc[i].depth = 1;
-
-		if (i < 16) {
-			/*
-			 * 16 old-style INTA-cycle interrupts:
-			 */
-			set_irq_chip_and_handler_name(i, &i8259A_chip,
-						      handle_level_irq, "XT");
-		} else {
-			/*
-			 * 'high' PCI IRQs filled in on demand
-			 */
-			irq_desc[i].chip = &no_irq_chip;
-		}
-	}
+	/*
+	 * 16 old-style INTA-cycle interrupts:
+	 */
+	for (i = 0; i < 16; i++)
+		set_irq_chip_and_handler_name(i, &i8259A_chip,
+					      handle_level_irq, "XT");
 }
 
 /* Overridden in paravirt.c */

Regards,

-- 
Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

