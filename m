Return-Path: <linux-kernel-owner+w=401wt.eu-S932318AbYBMQ2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbYBMQ2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758159AbYBMQ2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:28:03 -0500
Received: from vms048pub.verizon.net ([206.46.252.48]:37569 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757882AbYBMQ2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:28:01 -0500
Date: Wed, 13 Feb 2008 10:27:49 -0600
From: Corey Minyard <minyard@acm.org>
Subject: [PATCH 4/8] IPMI: Don't grab locks in run-to-completion mode
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>,
       Konstantin Baydarov <kbaidarov@ru.mvista.com>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Reply-to: minyard@acm.org
Message-id: <20080213162749.GD9830@minyard.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konstantin Baydarov <kbaidarov@ru.mvista.com>

This patch prevents deadlocks in IPMI panic handler caused by msg_lock
in smi_info structure and waiting_msgs_lock in ipmi_smi structure.
  
Signed-off-by: Konstantin Baydarov <kbaidarov@ru.mvista.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
---

Index: linux-2.6.24/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux-2.6.24.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux-2.6.24/drivers/char/ipmi/ipmi_si_intf.c
@@ -289,7 +289,8 @@ static enum si_sm_result start_next_msg(
 
 	/* No need to save flags, we aleady have interrupts off and we
 	   already hold the SMI lock. */
-	spin_lock(&(smi_info->msg_lock));
+	if (!smi_info->run_to_completion)
+		spin_lock(&(smi_info->msg_lock));
 
 	/* Pick the high priority queue first. */
 	if (!list_empty(&(smi_info->hp_xmit_msgs))) {
@@ -329,7 +330,8 @@ static enum si_sm_result start_next_msg(
 		rv = SI_SM_CALL_WITHOUT_DELAY;
 	}
 	out:
-	spin_unlock(&(smi_info->msg_lock));
+	if (!smi_info->run_to_completion)
+		spin_unlock(&(smi_info->msg_lock));
 
 	return rv;
 }
Index: linux-2.6.24/drivers/char/ipmi/ipmi_msghandler.c
===================================================================
--- linux-2.6.24.orig/drivers/char/ipmi/ipmi_msghandler.c
+++ linux-2.6.24/drivers/char/ipmi/ipmi_msghandler.c
@@ -351,8 +351,16 @@ struct ipmi_smi
 
 	/* Invalid data in an event. */
 	unsigned int invalid_events;
+
 	/* Events that were received with the proper format. */
 	unsigned int events;
+
+	/*
+	 * run_to_completion duplicate of smb_info, smi_info
+	 * and ipmi_serial_info structures. Used to decrease numbers of
+	 * parameters passed by "low" level IPMI code.
+	 */
+	int run_to_completion;
 };
 #define to_si_intf_from_dev(device) container_of(device, struct ipmi_smi, dev)
 
@@ -3451,8 +3459,9 @@ static int handle_new_recv_msg(ipmi_smi_
 void ipmi_smi_msg_received(ipmi_smi_t          intf,
 			   struct ipmi_smi_msg *msg)
 {
-	unsigned long flags;
+	unsigned long flags = 0; /* keep us warning-free. */
 	int           rv;
+	int           run_to_completion;
 
 
 	if ((msg->data_size >= 2)
@@ -3501,21 +3510,30 @@ void ipmi_smi_msg_received(ipmi_smi_t   
 
 	/* To preserve message order, if the list is not empty, we
            tack this message onto the end of the list. */
-	spin_lock_irqsave(&intf->waiting_msgs_lock, flags);
+	run_to_completion = intf->run_to_completion;
+	barrier();
+	if (!run_to_completion)
+		spin_lock_irqsave(&intf->waiting_msgs_lock, flags);
 	if (!list_empty(&intf->waiting_msgs)) {
 		list_add_tail(&msg->link, &intf->waiting_msgs);
-		spin_unlock_irqrestore(&intf->waiting_msgs_lock, flags);
+		if (!run_to_completion)
+			spin_unlock_irqrestore(&intf->waiting_msgs_lock, flags);
 		goto out;
 	}
-	spin_unlock_irqrestore(&intf->waiting_msgs_lock, flags);
+	if (!run_to_completion)
+		spin_unlock_irqrestore(&intf->waiting_msgs_lock, flags);
 		
 	rv = handle_new_recv_msg(intf, msg);
 	if (rv > 0) {
 		/* Could not handle the message now, just add it to a
                    list to handle later. */
-		spin_lock_irqsave(&intf->waiting_msgs_lock, flags);
+		run_to_completion = intf->run_to_completion;
+		barrier();
+		if (!run_to_completion)
+			spin_lock_irqsave(&intf->waiting_msgs_lock, flags);
 		list_add_tail(&msg->link, &intf->waiting_msgs);
-		spin_unlock_irqrestore(&intf->waiting_msgs_lock, flags);
+		if (!run_to_completion)
+			spin_unlock_irqrestore(&intf->waiting_msgs_lock, flags);
 	} else if (rv == 0) {
 		ipmi_free_smi_msg(msg);
 	}
@@ -3884,6 +3902,7 @@ static void send_panic_events(char *str)
 			/* Interface is not ready. */
 			continue;
 
+		intf->run_to_completion = 1;
 		/* Send the event announcing the panic. */
 		intf->handlers->set_run_to_completion(intf->send_info, 1);
 		i_ipmi_request(NULL,
@@ -4059,6 +4078,7 @@ static int panic_event(struct notifier_b
 			/* Interface is not ready. */
 			continue;
 
+		intf->run_to_completion = 1;
 		intf->handlers->set_run_to_completion(intf->send_info, 1);
 	}
 
