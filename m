Return-Path: <linux-kernel-owner+w=401wt.eu-S933125AbYBMQab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125AbYBMQab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761358AbYBMQaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:30:13 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:34600 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761304AbYBMQaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:30:11 -0500
Date: Wed, 13 Feb 2008 10:29:24 -0600
From: Corey Minyard <minyard@acm.org>
Subject: [PATCH 5/8] IPMI: Don't print event queue full on every event
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Reply-to: minyard@acm.org
Message-id: <20080213162924.GE9830@minyard.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

Don't print out that the event queue is full on every event, only
print something out when it becomes full or becomes not full.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
---

Index: linux-2.6.23/drivers/char/ipmi/ipmi_msghandler.c
===================================================================
--- linux-2.6.23.orig/drivers/char/ipmi/ipmi_msghandler.c
+++ linux-2.6.23/drivers/char/ipmi/ipmi_msghandler.c
@@ -253,7 +253,8 @@ struct ipmi_smi
 	spinlock_t       events_lock; /* For dealing with event stuff. */
 	struct list_head waiting_events;
 	unsigned int     waiting_events_count; /* How many events in queue? */
-	int              delivering_events;
+	char             delivering_events;
+	char             event_msg_printed;
 
 	/* The event receiver for my BMC, only really used at panic
 	   shutdown as a place to store this. */
@@ -1075,6 +1076,11 @@ int ipmi_set_gets_events(ipmi_user_t use
 		list_for_each_entry_safe(msg, msg2, &intf->waiting_events, link)
 			list_move_tail(&msg->link, &msgs);
 		intf->waiting_events_count = 0;
+		if (intf->event_msg_printed) {
+			printk(KERN_WARNING PFX "Event queue no longer"
+			       " full\n");
+			intf->event_msg_printed = 0;
+		}
 
 		intf->delivering_events = 1;
 		spin_unlock_irqrestore(&intf->events_lock, flags);
@@ -3253,11 +3259,12 @@ static int handle_read_event_rsp(ipmi_sm
 		copy_event_into_recv_msg(recv_msg, msg);
 		list_add_tail(&(recv_msg->link), &(intf->waiting_events));
 		intf->waiting_events_count++;
-	} else {
+	} else if (!intf->event_msg_printed) {
 		/* There's too many things in the queue, discard this
 		   message. */
-		printk(KERN_WARNING PFX "Event queue full, discarding an"
-		       " incoming event\n");
+		printk(KERN_WARNING PFX "Event queue full, discarding"
+		       " incoming events\n");
+		intf->event_msg_printed = 1;
 	}
 
  out:
