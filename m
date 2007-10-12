Return-Path: <linux-kernel-owner+w=401wt.eu-S1762303AbXJLQn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762303AbXJLQn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759181AbXJLQnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:43:12 -0400
Received: from vms048pub.verizon.net ([206.46.252.48]:53573 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758129AbXJLQnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:43:09 -0400
Date: Fri, 12 Oct 2007 11:40:08 -0500
From: Corey Minyard <minyard@acm.org>
Subject: [PATCH 4/7] IPMI: add polled interface
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Reply-to: minyard@acm.org
Message-id: <20071012164008.GD22142@minyard.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Corey Minyard <cminyard@mvista.com>

Currently the IPMI watchdog timer sets the watchdog timeout on a
panic, but it doesn't actually poll the interface to make sure the
message goes out.

Add an interface for polling the IPMI driver, and add code to the IPMI
watchdog timer to poll the interface when the timer is set from a
panic.

Not needed for the stable kernel.

Signed-off-by: Corey Minyard <cminyard@mvista.com>

--
 drivers/char/ipmi/ipmi_msghandler.c |    9 +++
 drivers/char/ipmi/ipmi_si_intf.c    |    6 +-
 drivers/char/ipmi/ipmi_watchdog.c   |  105 ++++++++++++++++++++----------------
 include/linux/ipmi.h                |   10 +++
 4 files changed, 83 insertions(+), 47 deletions(-)

Index: linux-2.6.22/drivers/char/ipmi/ipmi_msghandler.c
===================================================================
--- linux-2.6.22.orig/drivers/char/ipmi/ipmi_msghandler.c
+++ linux-2.6.22/drivers/char/ipmi/ipmi_msghandler.c
@@ -2624,6 +2624,14 @@ channel_handler(ipmi_smi_t intf, struct 
 	return;
 }
 
+void ipmi_poll_interface(ipmi_user_t user)
+{
+	ipmi_smi_t intf = user->intf;
+
+	if (intf->handlers->poll)
+		intf->handlers->poll(intf->send_info);
+}
+
 int ipmi_register_smi(struct ipmi_smi_handlers *handlers,
 		      void		       *send_info,
 		      struct ipmi_device_id    *device_id,
@@ -4177,6 +4185,7 @@ EXPORT_SYMBOL(ipmi_destroy_user);
 EXPORT_SYMBOL(ipmi_get_version);
 EXPORT_SYMBOL(ipmi_request_settime);
 EXPORT_SYMBOL(ipmi_request_supply_msgs);
+EXPORT_SYMBOL(ipmi_poll_interface);
 EXPORT_SYMBOL(ipmi_register_smi);
 EXPORT_SYMBOL(ipmi_unregister_smi);
 EXPORT_SYMBOL(ipmi_register_for_cmd);
Index: linux-2.6.22/drivers/char/ipmi/ipmi_watchdog.c
===================================================================
--- linux-2.6.22.orig/drivers/char/ipmi/ipmi_watchdog.c
+++ linux-2.6.22/drivers/char/ipmi/ipmi_watchdog.c
@@ -314,8 +314,6 @@ static unsigned char ipmi_version_minor;
 static atomic_t preop_panic_excl = ATOMIC_INIT(-1);
 
 static int ipmi_heartbeat(void);
-static void panic_halt_ipmi_heartbeat(void);
-
 
 /* We use a mutex to make sure that only one thing can send a set
    timeout at one time, because we only have one copy of the data.
@@ -440,19 +438,64 @@ out:
 	return rv;
 }
 
-static void dummy_smi_free(struct ipmi_smi_msg *msg)
+static atomic_t panic_done_count = ATOMIC_INIT(0);
+
+static void panic_smi_free(struct ipmi_smi_msg *msg)
 {
+	atomic_dec(&panic_done_count);
 }
-static void dummy_recv_free(struct ipmi_recv_msg *msg)
+static void panic_recv_free(struct ipmi_recv_msg *msg)
+{
+	atomic_dec(&panic_done_count);
+}
+
+static struct ipmi_smi_msg panic_halt_heartbeat_smi_msg =
+{
+	.done = panic_smi_free
+};
+static struct ipmi_recv_msg panic_halt_heartbeat_recv_msg =
 {
+	.done = panic_recv_free
+};
+
+static void panic_halt_ipmi_heartbeat(void)
+{
+	struct kernel_ipmi_msg             msg;
+	struct ipmi_system_interface_addr addr;
+	int rv;
+
+	/* Don't reset the timer if we have the timer turned off, that
+           re-enables the watchdog. */
+	if (ipmi_watchdog_state == WDOG_TIMEOUT_NONE)
+		return;
+
+	addr.addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
+	addr.channel = IPMI_BMC_CHANNEL;
+	addr.lun = 0;
+
+	msg.netfn = 0x06;
+	msg.cmd = IPMI_WDOG_RESET_TIMER;
+	msg.data = NULL;
+	msg.data_len = 0;
+	rv = ipmi_request_supply_msgs(watchdog_user,
+				      (struct ipmi_addr *) &addr,
+				      0,
+				      &msg,
+				      NULL,
+				      &panic_halt_heartbeat_smi_msg,
+				      &panic_halt_heartbeat_recv_msg,
+				      1);
+	if (!rv)
+		atomic_add(2, &panic_done_count);
 }
+
 static struct ipmi_smi_msg panic_halt_smi_msg =
 {
-	.done = dummy_smi_free
+	.done = panic_smi_free
 };
 static struct ipmi_recv_msg panic_halt_recv_msg =
 {
-	.done = dummy_recv_free
+	.done = panic_recv_free
 };
 
 /* Special call, doesn't claim any locks.  This is only to be called
@@ -464,13 +507,21 @@ static void panic_halt_ipmi_set_timeout(
 	int send_heartbeat_now;
 	int rv;
 
+	/* Wait for the messages to be free. */
+	while (atomic_read(&panic_done_count) != 0)
+		ipmi_poll_interface(watchdog_user);
 	rv = i_ipmi_set_timeout(&panic_halt_smi_msg,
 				&panic_halt_recv_msg,
 				&send_heartbeat_now);
 	if (!rv) {
+		atomic_add(2, &panic_done_count);
 		if (send_heartbeat_now)
 			panic_halt_ipmi_heartbeat();
-	}
+	} else
+		printk(KERN_WARNING PFX
+		       "Unable to extend the watchdog timeout.");
+	while (atomic_read(&panic_done_count) != 0)
+		ipmi_poll_interface(watchdog_user);
 }
 
 /* We use a semaphore to make sure that only one thing can send a
@@ -499,15 +550,6 @@ static struct ipmi_recv_msg heartbeat_re
 	.done = heartbeat_free_recv
 };
  
-static struct ipmi_smi_msg panic_halt_heartbeat_smi_msg =
-{
-	.done = dummy_smi_free
-};
-static struct ipmi_recv_msg panic_halt_heartbeat_recv_msg =
-{
-	.done = dummy_recv_free
-};
- 
 static int ipmi_heartbeat(void)
 {
 	struct kernel_ipmi_msg            msg;
@@ -580,35 +622,6 @@ static int ipmi_heartbeat(void)
 	return rv;
 }
 
-static void panic_halt_ipmi_heartbeat(void)
-{
-	struct kernel_ipmi_msg             msg;
-	struct ipmi_system_interface_addr addr;
-
-
-	/* Don't reset the timer if we have the timer turned off, that
-           re-enables the watchdog. */
-	if (ipmi_watchdog_state == WDOG_TIMEOUT_NONE)
-		return;
-
-	addr.addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
-	addr.channel = IPMI_BMC_CHANNEL;
-	addr.lun = 0;
-
-	msg.netfn = 0x06;
-	msg.cmd = IPMI_WDOG_RESET_TIMER;
-	msg.data = NULL;
-	msg.data_len = 0;
-	ipmi_request_supply_msgs(watchdog_user,
-				 (struct ipmi_addr *) &addr,
-				 0,
-				 &msg,
-				 NULL,
-				 &panic_halt_heartbeat_smi_msg,
-				 &panic_halt_heartbeat_recv_msg,
-				 1);
-}
-
 static struct watchdog_info ident =
 {
 	.options	= 0,	/* WDIOF_SETTIMEOUT, */
@@ -998,7 +1011,7 @@ static int wdog_reboot_handler(struct no
 		/* Make sure we only do this once. */
 		reboot_event_handled = 1;
 
-		if (code == SYS_DOWN || code == SYS_HALT) {
+		if (code == SYS_POWER_OFF || code == SYS_HALT) {
 			/* Disable the WDT if we are shutting down. */
 			ipmi_watchdog_state = WDOG_TIMEOUT_NONE;
 			panic_halt_ipmi_set_timeout();
Index: linux-2.6.22/include/linux/ipmi.h
===================================================================
--- linux-2.6.22.orig/include/linux/ipmi.h
+++ linux-2.6.22/include/linux/ipmi.h
@@ -365,6 +365,16 @@ int ipmi_request_supply_msgs(ipmi_user_t
 			     int                  priority);
 
 /*
+ * Poll the IPMI interface for the user.  This causes the IPMI code to
+ * do an immediate check for information from the driver and handle
+ * anything that is immediately pending.  This will not block in any
+ * way.  This is useful if you need to implement polling from the user
+ * for things like modifying the watchdog timeout when a panic occurs
+ * or disabling the watchdog timer on a reboot.
+ */
+void ipmi_poll_interface(ipmi_user_t user);
+
+/*
  * When commands come in to the SMS, the user can register to receive
  * them.  Only one user can be listening on a specific netfn/cmd/chan tuple
  * at a time, you will get an EBUSY error if the command is already
Index: linux-2.6.22/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux-2.6.22.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux-2.6.22/drivers/char/ipmi/ipmi_si_intf.c
@@ -675,7 +675,8 @@ static void handle_transaction_done(stru
 }
 
 /* Called on timeouts and events.  Timeouts should pass the elapsed
-   time, interrupts should pass in zero. */
+   time, interrupts should pass in zero.  Must be called with
+   si_lock held and interrupts disabled. */
 static enum si_sm_result smi_event_handler(struct smi_info *smi_info,
 					   int time)
 {
@@ -892,13 +893,16 @@ static int ipmi_thread(void *data)
 static void poll(void *send_info)
 {
 	struct smi_info *smi_info = send_info;
+	unsigned long flags;
 
 	/*
 	 * Make sure there is some delay in the poll loop so we can
 	 * drive time forward and timeout things.
 	 */
 	udelay(10);
+	spin_lock_irqsave(&smi_info->si_lock, flags);
 	smi_event_handler(smi_info, 10);
+	spin_unlock_irqrestore(&smi_info->si_lock, flags);
 }
 
 static void request_events(void *send_info)
