Return-Path: <linux-kernel-owner+w=401wt.eu-S932634AbXBNV1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634AbXBNV1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 16:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932638AbXBNV1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 16:27:21 -0500
Received: from mta5.adelphia.net ([68.168.78.187]:41017 "EHLO
	mta5.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932634AbXBNV1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 16:27:20 -0500
X-Greylist: delayed 1684 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Feb 2007 16:27:20 EST
Date: Wed, 14 Feb 2007 14:04:50 -0600
From: Corey Minyard <minyard@acm.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Cc: Patrick Schoeller <Patrick.Schoeller@hp.com>
Subject: [patch 2/4] ipmi: allow shared interrupts
Message-ID: <20070214200450.GB5364@localdomain>
Reply-To: minyard@acm.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The IPMI driver used enable_irq and disable_irq when it got into
situations where it couldn't allocate memory; it did this to avoid
having the interrupt just lock the machine when it couldn't get
memory to perform the transaction to disable the interrupt.

This patch modifies the driver to not use disable_irq and enable_irq.
It instead sends the messages to the BMC to perform this operation.
It also makes sure interrupts are cleanly disabled when the interface
is shut down and cleans up some shutdown things that are no longer
necessary.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: Patrick Schoeller <Patrick.Schoeller@hp.com>

Index: linux-2.6.19/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux-2.6.19.orig/drivers/char/ipmi/ipmi_si_intf.c	2006-12-30 12:57:04.000000000 -0600
+++ linux-2.6.19/drivers/char/ipmi/ipmi_si_intf.c	2006-12-30 12:57:06.000000000 -0600
@@ -83,6 +83,12 @@
 #define SI_SHORT_TIMEOUT_USEC  250 /* .25ms when the SM request a
                                        short timeout */
 
+/* Bit for BMC global enables. */
+#define IPMI_BMC_RCV_MSG_INTR     0x01
+#define IPMI_BMC_EVT_MSG_INTR     0x02
+#define IPMI_BMC_EVT_MSG_BUFF     0x04
+#define IPMI_BMC_SYS_LOG          0x08
+
 enum si_intf_state {
 	SI_NORMAL,
 	SI_GETTING_FLAGS,
@@ -91,7 +97,9 @@
 	SI_CLEARING_FLAGS_THEN_SET_IRQ,
 	SI_GETTING_MESSAGES,
 	SI_ENABLE_INTERRUPTS1,
-	SI_ENABLE_INTERRUPTS2
+	SI_ENABLE_INTERRUPTS2,
+	SI_DISABLE_INTERRUPTS1,
+	SI_DISABLE_INTERRUPTS2
 	/* FIXME - add watchdog stuff. */
 };
 
@@ -340,6 +348,17 @@
 	smi_info->si_state = SI_ENABLE_INTERRUPTS1;
 }
 
+static void start_disable_irq(struct smi_info *smi_info)
+{
+	unsigned char msg[2];
+
+	msg[0] = (IPMI_NETFN_APP_REQUEST << 2);
+	msg[1] = IPMI_GET_BMC_GLOBAL_ENABLES_CMD;
+
+	smi_info->handlers->start_transaction(smi_info->si_sm, msg, 2);
+	smi_info->si_state = SI_DISABLE_INTERRUPTS1;
+}
+
 static void start_clear_flags(struct smi_info *smi_info)
 {
 	unsigned char msg[3];
@@ -360,7 +379,7 @@
 static inline void disable_si_irq(struct smi_info *smi_info)
 {
 	if ((smi_info->irq) && (!smi_info->interrupt_disabled)) {
-		disable_irq_nosync(smi_info->irq);
+		start_disable_irq(smi_info);
 		smi_info->interrupt_disabled = 1;
 	}
 }
@@ -368,7 +387,7 @@
 static inline void enable_si_irq(struct smi_info *smi_info)
 {
 	if ((smi_info->irq) && (smi_info->interrupt_disabled)) {
-		enable_irq(smi_info->irq);
+		start_enable_irq(smi_info);
 		smi_info->interrupt_disabled = 0;
 	}
 }
@@ -590,7 +609,9 @@
 		} else {
 			msg[0] = (IPMI_NETFN_APP_REQUEST << 2);
 			msg[1] = IPMI_SET_BMC_GLOBAL_ENABLES_CMD;
-			msg[2] = msg[3] | 1; /* enable msg queue int */
+			msg[2] = (msg[3] |
+				  IPMI_BMC_RCV_MSG_INTR |
+				  IPMI_BMC_EVT_MSG_INTR);
 			smi_info->handlers->start_transaction(
 				smi_info->si_sm, msg, 3);
 			smi_info->si_state = SI_ENABLE_INTERRUPTS2;
@@ -612,6 +633,45 @@
 		smi_info->si_state = SI_NORMAL;
 		break;
 	}
+
+	case SI_DISABLE_INTERRUPTS1:
+	{
+		unsigned char msg[4];
+
+		/* We got the flags from the SMI, now handle them. */
+		smi_info->handlers->get_result(smi_info->si_sm, msg, 4);
+		if (msg[2] != 0) {
+			printk(KERN_WARNING
+			       "ipmi_si: Could not disable interrupts"
+			       ", failed get.\n");
+			smi_info->si_state = SI_NORMAL;
+		} else {
+			msg[0] = (IPMI_NETFN_APP_REQUEST << 2);
+			msg[1] = IPMI_SET_BMC_GLOBAL_ENABLES_CMD;
+			msg[2] = (msg[3] &
+				  ~(IPMI_BMC_RCV_MSG_INTR |
+				    IPMI_BMC_EVT_MSG_INTR));
+			smi_info->handlers->start_transaction(
+				smi_info->si_sm, msg, 3);
+			smi_info->si_state = SI_DISABLE_INTERRUPTS2;
+		}
+		break;
+	}
+
+	case SI_DISABLE_INTERRUPTS2:
+	{
+		unsigned char msg[4];
+
+		/* We got the flags from the SMI, now handle them. */
+		smi_info->handlers->get_result(smi_info->si_sm, msg, 4);
+		if (msg[2] != 0) {
+			printk(KERN_WARNING
+			       "ipmi_si: Could not disable interrupts"
+			       ", failed set.\n");
+		}
+		smi_info->si_state = SI_NORMAL;
+		break;
+	}
 	}
 }
 
@@ -865,9 +925,6 @@
 	struct timeval    t;
 #endif
 
-	if (atomic_read(&smi_info->stop_operation))
-		return;
-
 	spin_lock_irqsave(&(smi_info->si_lock), flags);
 #ifdef DEBUG_TIMING
 	do_gettimeofday(&t);
@@ -923,15 +980,11 @@
 	smi_info->interrupts++;
 	spin_unlock(&smi_info->count_lock);
 
-	if (atomic_read(&smi_info->stop_operation))
-		goto out;
-
 #ifdef DEBUG_TIMING
 	do_gettimeofday(&t);
 	printk("**Interrupt: %d.%9.9d\n", t.tv_sec, t.tv_usec);
 #endif
 	smi_event_handler(smi_info, 0);
- out:
 	spin_unlock_irqrestore(&(smi_info->si_lock), flags);
 	return IRQ_HANDLED;
 }
@@ -1118,7 +1171,7 @@
 	if (info->si_type == SI_BT) {
 		rv = request_irq(info->irq,
 				 si_bt_irq_handler,
-				 IRQF_DISABLED,
+				 IRQF_SHARED | IRQF_DISABLED,
 				 DEVICE_NAME,
 				 info);
 		if (!rv)
@@ -1128,7 +1181,7 @@
 	} else
 		rv = request_irq(info->irq,
 				 si_irq_handler,
-				 IRQF_DISABLED,
+				 IRQF_SHARED | IRQF_DISABLED,
 				 DEVICE_NAME,
 				 info);
 	if (rv) {
@@ -1708,15 +1761,11 @@
 	smi_info->interrupts++;
 	spin_unlock(&smi_info->count_lock);
 
-	if (atomic_read(&smi_info->stop_operation))
-		goto out;
-
 #ifdef DEBUG_TIMING
 	do_gettimeofday(&t);
 	printk("**ACPI_GPE: %d.%9.9d\n", t.tv_sec, t.tv_usec);
 #endif
 	smi_event_handler(smi_info, 0);
- out:
 	spin_unlock_irqrestore(&(smi_info->si_lock), flags);
 
 	return ACPI_INTERRUPT_HANDLED;
@@ -2929,28 +2978,33 @@
 
 	list_del(&to_clean->link);
 
-	/* Tell the timer and interrupt handlers that we are shutting
-	   down. */
-	spin_lock_irqsave(&(to_clean->si_lock), flags);
-	spin_lock(&(to_clean->msg_lock));
-
+	/* Tell the driver that we are shutting down. */
 	atomic_inc(&to_clean->stop_operation);
 
-	if (to_clean->irq_cleanup)
-		to_clean->irq_cleanup(to_clean);
-
-	spin_unlock(&(to_clean->msg_lock));
-	spin_unlock_irqrestore(&(to_clean->si_lock), flags);
-
-	/* Wait until we know that we are out of any interrupt
-	   handlers might have been running before we freed the
-	   interrupt. */
-	synchronize_sched();
-
+	/* Make sure the timer and thread are stopped and will not run
+	   again. */
 	wait_for_timer_and_thread(to_clean);
 
-	/* Interrupts and timeouts are stopped, now make sure the
-	   interface is in a clean state. */
+	/* Timeouts are stopped, now make sure the interrupts are off
+	   for the device.  A little tricky with locks to make sure
+	   there are no races. */
+	spin_lock_irqsave(&to_clean->si_lock, flags);
+	while (to_clean->curr_msg || (to_clean->si_state != SI_NORMAL)) {
+		spin_unlock_irqrestore(&to_clean->si_lock, flags);
+		poll(to_clean);
+		schedule_timeout_uninterruptible(1);
+		spin_lock_irqsave(&to_clean->si_lock, flags);
+	}
+	disable_si_irq(to_clean);
+	spin_unlock_irqrestore(&to_clean->si_lock, flags);
+	while (to_clean->curr_msg || (to_clean->si_state != SI_NORMAL)) {
+		poll(to_clean);
+		schedule_timeout_uninterruptible(1);
+	}
+
+	/* Clean up interrupts and make sure that everything is done. */
+	if (to_clean->irq_cleanup)
+		to_clean->irq_cleanup(to_clean);
 	while (to_clean->curr_msg || (to_clean->si_state != SI_NORMAL)) {
 		poll(to_clean);
 		schedule_timeout_uninterruptible(1);
