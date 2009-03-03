Return-Path: <linux-kernel-owner+w=401wt.eu-S1757005AbZCCPTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005AbZCCPTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 10:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbZCCPT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 10:19:27 -0500
Received: from vms173009pub.verizon.net ([206.46.173.9]:39821 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbZCCPT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 10:19:27 -0500
Date: Tue, 03 Mar 2009 09:18:56 -0600
From: Corey Minyard <minyard@acm.org>
To: Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Subject: [PATCH 2/5] IPMI: Test for event buffer before using
Message-id: <20090303151856.GB7777@minyard.local>
Reply-to: minyard@acm.org
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IPMI driver would attempt to use the event buffer even if that
didn't exist on the BMC.  This patch modified the IPMI driver to check
for the event buffer's existence before trying to use it.

Signed-off-by: Corey Minyard <minyard@acm.org>
---
 drivers/char/ipmi/ipmi_si_intf.c |  148 +++++++++++++++++++++++++++++++--------
 include/linux/ipmi_msgdefs.h     |    6 +
 2 files changed, 125 insertions(+), 29 deletions(-)

Index: linux-2.6.25/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux-2.6.25.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux-2.6.25/drivers/char/ipmi/ipmi_si_intf.c
@@ -82,12 +82,6 @@
 #define SI_SHORT_TIMEOUT_USEC  250 /* .25ms when the SM request a
 				      short timeout */
 
-/* Bit for BMC global enables. */
-#define IPMI_BMC_RCV_MSG_INTR     0x01
-#define IPMI_BMC_EVT_MSG_INTR     0x02
-#define IPMI_BMC_EVT_MSG_BUFF     0x04
-#define IPMI_BMC_SYS_LOG          0x08
-
 enum si_intf_state {
 	SI_NORMAL,
 	SI_GETTING_FLAGS,
@@ -218,6 +212,9 @@ struct smi_info {
 			     OEM2_DATA_AVAIL)
 	unsigned char       msg_flags;
 
+	/* Does the BMC have an event buffer? */
+	char		    has_event_buffer;
+
 	/*
 	 * If set to true, this will request events the next time the
 	 * state machine is idle.
@@ -967,7 +964,8 @@ static void request_events(void *send_in
 {
 	struct smi_info *smi_info = send_info;
 
-	if (atomic_read(&smi_info->stop_operation))
+	if (atomic_read(&smi_info->stop_operation) ||
+				!smi_info->has_event_buffer)
 		return;
 
 	atomic_set(&smi_info->req_events, 1);
@@ -2406,26 +2404,9 @@ static struct of_platform_driver ipmi_of
 };
 #endif /* CONFIG_PPC_OF */
 
-
-static int try_get_dev_id(struct smi_info *smi_info)
+static int wait_for_msg_done(struct smi_info *smi_info)
 {
-	unsigned char         msg[2];
-	unsigned char         *resp;
-	unsigned long         resp_len;
 	enum si_sm_result     smi_result;
-	int                   rv = 0;
-
-	resp = kmalloc(IPMI_MAX_MSG_LENGTH, GFP_KERNEL);
-	if (!resp)
-		return -ENOMEM;
-
-	/*
-	 * Do a Get Device ID command, since it comes back with some
-	 * useful info.
-	 */
-	msg[0] = IPMI_NETFN_APP_REQUEST << 2;
-	msg[1] = IPMI_GET_DEVICE_ID_CMD;
-	smi_info->handlers->start_transaction(smi_info->si_sm, msg, 2);
 
 	smi_result = smi_info->handlers->event(smi_info->si_sm, 0);
 	for (;;) {
@@ -2440,16 +2421,39 @@ static int try_get_dev_id(struct smi_inf
 		} else
 			break;
 	}
-	if (smi_result == SI_SM_HOSED) {
+	if (smi_result == SI_SM_HOSED)
 		/*
 		 * We couldn't get the state machine to run, so whatever's at
 		 * the port is probably not an IPMI SMI interface.
 		 */
-		rv = -ENODEV;
+		return -ENODEV;
+
+	return 0;
+}
+
+static int try_get_dev_id(struct smi_info *smi_info)
+{
+	unsigned char         msg[2];
+	unsigned char         *resp;
+	unsigned long         resp_len;
+	int                   rv = 0;
+
+	resp = kmalloc(IPMI_MAX_MSG_LENGTH, GFP_KERNEL);
+	if (!resp)
+		return -ENOMEM;
+
+	/*
+	 * Do a Get Device ID command, since it comes back with some
+	 * useful info.
+	 */
+	msg[0] = IPMI_NETFN_APP_REQUEST << 2;
+	msg[1] = IPMI_GET_DEVICE_ID_CMD;
+	smi_info->handlers->start_transaction(smi_info->si_sm, msg, 2);
+
+	rv = wait_for_msg_done(smi_info);
+	if (rv)
 		goto out;
-	}
 
-	/* Otherwise, we got some data. */
 	resp_len = smi_info->handlers->get_result(smi_info->si_sm,
 						  resp, IPMI_MAX_MSG_LENGTH);
 
@@ -2461,6 +2465,88 @@ static int try_get_dev_id(struct smi_inf
 	return rv;
 }
 
+static int try_enable_event_buffer(struct smi_info *smi_info)
+{
+	unsigned char         msg[3];
+	unsigned char         *resp;
+	unsigned long         resp_len;
+	int                   rv = 0;
+
+	resp = kmalloc(IPMI_MAX_MSG_LENGTH, GFP_KERNEL);
+	if (!resp)
+		return -ENOMEM;
+
+	msg[0] = IPMI_NETFN_APP_REQUEST << 2;
+	msg[1] = IPMI_GET_BMC_GLOBAL_ENABLES_CMD;
+	smi_info->handlers->start_transaction(smi_info->si_sm, msg, 2);
+
+	rv = wait_for_msg_done(smi_info);
+	if (rv) {
+		printk(KERN_WARNING
+		       "ipmi_si: Error getting response from get global,"
+		       " enables command, the event buffer is not"
+		       " enabled.\n");
+		goto out;
+	}
+
+	resp_len = smi_info->handlers->get_result(smi_info->si_sm,
+						  resp, IPMI_MAX_MSG_LENGTH);
+
+	if (resp_len < 4 ||
+			resp[0] != (IPMI_NETFN_APP_REQUEST | 1) << 2 ||
+			resp[1] != IPMI_GET_BMC_GLOBAL_ENABLES_CMD   ||
+			resp[2] != 0) {
+		printk(KERN_WARNING
+		       "ipmi_si: Invalid return from get global"
+		       " enables command, cannot enable the event"
+		       " buffer.\n");
+		rv = -EINVAL;
+		goto out;
+	}
+
+	if (resp[3] & IPMI_BMC_EVT_MSG_BUFF)
+		/* buffer is already enabled, nothing to do. */
+		goto out;
+
+	msg[0] = IPMI_NETFN_APP_REQUEST << 2;
+	msg[1] = IPMI_SET_BMC_GLOBAL_ENABLES_CMD;
+	msg[2] = resp[3] | IPMI_BMC_EVT_MSG_BUFF;
+	smi_info->handlers->start_transaction(smi_info->si_sm, msg, 3);
+
+	rv = wait_for_msg_done(smi_info);
+	if (rv) {
+		printk(KERN_WARNING
+		       "ipmi_si: Error getting response from set global,"
+		       " enables command, the event buffer is not"
+		       " enabled.\n");
+		goto out;
+	}
+
+	resp_len = smi_info->handlers->get_result(smi_info->si_sm,
+						  resp, IPMI_MAX_MSG_LENGTH);
+
+	if (resp_len < 3 ||
+			resp[0] != (IPMI_NETFN_APP_REQUEST | 1) << 2 ||
+			resp[1] != IPMI_SET_BMC_GLOBAL_ENABLES_CMD) {
+		printk(KERN_WARNING
+		       "ipmi_si: Invalid return from get global,"
+		       "enables command, not enable the event"
+		       " buffer.\n");
+		rv = -EINVAL;
+		goto out;
+	}
+
+	if (resp[2] != 0)
+		/*
+		 * An error when setting the event buffer bit means
+		 * that the event buffer is not supported.
+		 */
+		rv = -ENOENT;
+ out:
+	kfree(resp);
+	return rv;
+}
+
 static int type_file_read_proc(char *page, char **start, off_t off,
 			       int count, int *eof, void *data)
 {
@@ -2848,6 +2934,10 @@ static int try_smi_init(struct smi_info 
 	new_smi->intf_num = smi_num;
 	smi_num++;
 
+	rv = try_enable_event_buffer(new_smi);
+	if (rv == 0)
+		new_smi->has_event_buffer = 1;
+
 	/*
 	 * Start clearing the flags before we enable interrupts or the
 	 * timer to avoid racing with the timer.
Index: linux-2.6.25/include/linux/ipmi_msgdefs.h
===================================================================
--- linux-2.6.25.orig/include/linux/ipmi_msgdefs.h
+++ linux-2.6.25/include/linux/ipmi_msgdefs.h
@@ -58,6 +58,12 @@
 #define IPMI_READ_EVENT_MSG_BUFFER_CMD	0x35
 #define IPMI_GET_CHANNEL_INFO_CMD	0x42
 
+/* Bit for BMC global enables. */
+#define IPMI_BMC_RCV_MSG_INTR     0x01
+#define IPMI_BMC_EVT_MSG_INTR     0x02
+#define IPMI_BMC_EVT_MSG_BUFF     0x04
+#define IPMI_BMC_SYS_LOG          0x08
+
 #define IPMI_NETFN_STORAGE_REQUEST		0x0a
 #define IPMI_NETFN_STORAGE_RESPONSE		0x0b
 #define IPMI_ADD_SEL_ENTRY_CMD		0x44
