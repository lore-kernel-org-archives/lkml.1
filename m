Return-Path: <linux-kernel-owner+w=401wt.eu-S1757611AbZCRDHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611AbZCRDHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 23:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757066AbZCRDGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 23:06:17 -0400
Received: from n15b.bullet.mail.mud.yahoo.com ([68.142.207.236]:38614 "HELO
	n15b.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756192AbZCRDGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 23:06:11 -0400
X-Yahoo-Newman-Id: 415842.97194.bm@omp403.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=vVQUl4GjJhNMUayCZ4zdNX0hrgIdM5Rb527CtWQy8N0oj1IUasyCJV3ojhIkIf/cUduEfRViQx64yc8epsbr1+pQBFLnEvX5cRS8H3XplcdU2Y6UDg2tqSA3H/CtZKHOsRd8tK9fn13ZwUwvErFNMXehX4Qobd7fGdkaCjjezIM=  ;
X-YMail-OSG: p2u.DfQVM1nd76vK9T1jb6LCpzUQnMyByJikScLATqY_YNjt0EcO.v._lh_fUW1lXzYMxWg5v1Zfro_KZj2K7AHtLvOinmCNxYLbiy7BZ11hLH92TsXTS3xCkqP5jpU9FXa0UEPojfmz53FsdHtQqxCOcMM4TPjTDLn_0dxm7EnsYBkjitPxoA10.h.yseUL4_5o9H..lEY9v5lxL1JHRUmx4GbwK2KiPvJOeQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Subject: [patch/rfc 2/2] twl4030: use new handle_threaded_irq() flow handler
Date: Tue, 17 Mar 2009 19:22:25 -0700
User-Agent: KMail/1.9.10
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, me@felipebalbi.com,
       dmitry.torokhov@gmail.com, sameo@openedhand.com
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <20090303004427.GA8638@elte.hu> <200903171914.53688.david-b@pacbell.net>
In-Reply-To: <200903171914.53688.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903171922.25647.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Make the toplevel twl4030 irq dispatch code use the new 
handle_threaded_irq() flow handler.  Also, minor cleanup,
use the newish generic_handle_irq_desc().

Since that flow handler guarantees the IRQ handlers are
called only in a normal (sleeping) thread context, remove
some of the workarounds for the lockdep goofage whereby
it breaks various drivers by forcing IRQF_DISABLED on.
 
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/mfd/twl4030-irq.c     |   15 +++++----------
 drivers/rtc/rtc-twl4030.c     |    8 --------
 drivers/usb/otg/twl4030-usb.c |    8 --------
 3 files changed, 5 insertions(+), 26 deletions(-)

--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -215,7 +215,6 @@ static int twl4030_irq_thread(void *data
 		}
 
 		/* these handlers deal with the relevant SIH irq status */
-		local_irq_disable();
 		for (module_irq = twl4030_irq_base;
 				pih_isr;
 				pih_isr >>= 1, module_irq++) {
@@ -235,10 +234,9 @@ static int twl4030_irq_thread(void *data
 					note_interrupt(module_irq, d,
 							IRQ_NONE);
 				else
-					d->handle_irq(module_irq, d);
+					generic_handle_irq_desc(module_irq, d);
 			}
 		}
-		local_irq_enable();
 
 		desc->chip->unmask(irq);
 	}
@@ -578,7 +576,7 @@ static inline int sih_read_isr(const str
 }
 
 /*
- * Generic handler for SIH interrupts ... we "know" this is called
+ * Generic handler for SIH interrupts ... we know this is called
  * in task context, with IRQs enabled.
  */
 static void handle_twl4030_sih(unsigned irq, struct irq_desc *desc)
@@ -588,10 +586,7 @@ static void handle_twl4030_sih(unsigned 
 	int isr;
 
 	/* reading ISR acks the IRQs, using clear-on-read mode */
-	local_irq_enable();
 	isr = sih_read_isr(sih);
-	local_irq_disable();
-
 	if (isr < 0) {
 		pr_err("twl4030: %s SIH, read ISR error %d\n",
 			sih->name, isr);
@@ -658,7 +653,7 @@ int twl4030_sih_setup(int module)
 		irq = irq_base + i;
 
 		set_irq_chip_and_handler(irq, &twl4030_sih_irq_chip,
-				handle_edge_irq);
+				handle_threaded_irq);
 		set_irq_chip_data(irq, agent);
 		activate_irq(irq);
 	}
@@ -666,7 +661,7 @@ int twl4030_sih_setup(int module)
 	status = irq_base;
 	twl4030_irq_next += i;
 
-	/* replace generic PIH handler (handle_simple_irq) */
+	/* replace generic PIH handler (handle_threaded_irq) */
 	irq = sih_mod + twl4030_irq_base;
 	set_irq_data(irq, agent);
 	set_irq_chained_handler(irq, handle_twl4030_sih);
@@ -719,7 +714,7 @@ int twl_init_irq(int irq_num, unsigned i
 
 	for (i = irq_base; i < irq_end; i++) {
 		set_irq_chip_and_handler(i, &twl4030_irq_chip,
-				handle_simple_irq);
+				handle_threaded_irq);
 		activate_irq(i);
 	}
 	twl4030_irq_next = i;
--- a/drivers/rtc/rtc-twl4030.c
+++ b/drivers/rtc/rtc-twl4030.c
@@ -325,14 +325,6 @@ static irqreturn_t twl4030_rtc_interrupt
 	int res;
 	u8 rd_reg;
 
-#ifdef CONFIG_LOCKDEP
-	/* WORKAROUND for lockdep forcing IRQF_DISABLED on us, which
-	 * we don't want and can't tolerate.  Although it might be
-	 * friendlier not to borrow this thread context...
-	 */
-	local_irq_enable();
-#endif
-
 	res = twl4030_rtc_read_u8(&rd_reg, REG_RTC_STATUS_REG);
 	if (res)
 		goto out;
--- a/drivers/usb/otg/twl4030-usb.c
+++ b/drivers/usb/otg/twl4030-usb.c
@@ -517,14 +517,6 @@ static irqreturn_t twl4030_usb_irq(int i
 	struct twl4030_usb *twl = _twl;
 	int status;
 
-#ifdef CONFIG_LOCKDEP
-	/* WORKAROUND for lockdep forcing IRQF_DISABLED on us, which
-	 * we don't want and can't tolerate.  Although it might be
-	 * friendlier not to borrow this thread context...
-	 */
-	local_irq_enable();
-#endif
-
 	status = twl4030_usb_linkstat(twl);
 	if (status != USB_LINK_UNKNOWN) {
 

