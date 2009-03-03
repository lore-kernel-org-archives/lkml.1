Return-Path: <linux-kernel-owner+w=401wt.eu-S1758149AbZCCPXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbZCCPXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 10:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbZCCPXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 10:23:00 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:31542 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbZCCPW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 10:22:59 -0500
Date: Tue, 03 Mar 2009 09:22:45 -0600
From: Corey Minyard <minyard@acm.org>
To: Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
       dann frazier <dannf@hp.com>
Subject: [PATCH 5/5] IPMI: Add oem message handling
Message-id: <20090303152245.GE7777@minyard.local>
Reply-to: minyard@acm.org
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: dann frazier <dannf@hp.com>

Enable userspace to receive messages that a BMC transmits using an OEM
medium. This is used by the HP iLO2.

Based on code originally written by Patrick Schoeller.

Signed-off-by: dann frazier <dannf@hp.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 drivers/char/ipmi/ipmi_msghandler.c |  138 +++++++++++++++++++++++++++++++++-
 include/linux/ipmi.h                |    2 +
 include/linux/ipmi_msgdefs.h        |    2 +
 3 files changed, 137 insertions(+), 5 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 7a88dfd..2ad7237 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -3267,6 +3267,114 @@ static int handle_lan_get_msg_cmd(ipmi_smi_t          intf,
 	return rv;
 }
 
+/*
+ * This routine will handle "Get Message" command responses with
+ * channels that use an OEM Medium. The message format belongs to
+ * the OEM.  See IPMI 2.0 specification, Chapter 6 and
+ * Chapter 22, sections 22.6 and 22.24 for more details.
+ */
+static int handle_oem_get_msg_cmd(ipmi_smi_t          intf,
+				  struct ipmi_smi_msg *msg)
+{
+	struct cmd_rcvr       *rcvr;
+	int                   rv = 0;
+	unsigned char         netfn;
+	unsigned char         cmd;
+	unsigned char         chan;
+	ipmi_user_t           user = NULL;
+	struct ipmi_system_interface_addr *smi_addr;
+	struct ipmi_recv_msg  *recv_msg;
+
+	/*
+	 * We expect the OEM SW to perform error checking
+	 * so we just do some basic sanity checks
+	 */
+	if (msg->rsp_size < 4) {
+		/* Message not big enough, just ignore it. */
+		ipmi_inc_stat(intf, invalid_commands);
+		return 0;
+	}
+
+	if (msg->rsp[2] != 0) {
+		/* An error getting the response, just ignore it. */
+		return 0;
+	}
+
+	/*
+	 * This is an OEM Message so the OEM needs to know how
+	 * handle the message. We do no interpretation.
+	 */
+	netfn = msg->rsp[0] >> 2;
+	cmd = msg->rsp[1];
+	chan = msg->rsp[3] & 0xf;
+
+	rcu_read_lock();
+	rcvr = find_cmd_rcvr(intf, netfn, cmd, chan);
+	if (rcvr) {
+		user = rcvr->user;
+		kref_get(&user->refcount);
+	} else
+		user = NULL;
+	rcu_read_unlock();
+
+	if (user == NULL) {
+		/* We didn't find a user, just give up. */
+		ipmi_inc_stat(intf, unhandled_commands);
+
+		/*
+		 * Don't do anything with these messages, just allow
+		 * them to be freed.
+		 */
+
+		rv = 0;
+	} else {
+		/* Deliver the message to the user. */
+		ipmi_inc_stat(intf, handled_commands);
+
+		recv_msg = ipmi_alloc_recv_msg();
+		if (!recv_msg) {
+			/*
+			 * We couldn't allocate memory for the
+			 * message, so requeue it for handling
+			 * later.
+			 */
+			rv = 1;
+			kref_put(&user->refcount, free_user);
+		} else {
+			/*
+			 * OEM Messages are expected to be delivered via
+			 * the system interface to SMS software.  We might
+			 * need to visit this again depending on OEM
+			 * requirements
+			 */
+			smi_addr = ((struct ipmi_system_interface_addr *)
+				    &(recv_msg->addr));
+			smi_addr->addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
+			smi_addr->channel = IPMI_BMC_CHANNEL;
+			smi_addr->lun = msg->rsp[0] & 3;
+
+			recv_msg->user = user;
+			recv_msg->user_msg_data = NULL;
+			recv_msg->recv_type = IPMI_OEM_RECV_TYPE;
+			recv_msg->msg.netfn = msg->rsp[0] >> 2;
+			recv_msg->msg.cmd = msg->rsp[1];
+			recv_msg->msg.data = recv_msg->msg_data;
+
+			/*
+			 * The message starts at byte 4 which follows the
+			 * the Channel Byte in the "GET MESSAGE" command
+			 */
+			recv_msg->msg.data_len = msg->rsp_size - 4;
+			memcpy(recv_msg->msg_data,
+			       &(msg->rsp[4]),
+			       msg->rsp_size - 4);
+			deliver_response(recv_msg);
+		}
+	}
+
+	return rv;
+}
+
 static void copy_event_into_recv_msg(struct ipmi_recv_msg *recv_msg,
 				     struct ipmi_smi_msg  *msg)
 {
@@ -3522,6 +3630,17 @@ static int handle_new_recv_msg(ipmi_smi_t          intf,
 			goto out;
 		}
 
+		/*
+		** We need to make sure the channels have been initialized.
+		** The channel_handler routine will set the "curr_channel"
+		** equal to or greater than IPMI_MAX_CHANNELS when all the
+		** channels for this interface have been initialized.
+		*/
+		if (intf->curr_channel < IPMI_MAX_CHANNELS) {
+			requeue = 1;     /* Just put the message back for now */
+			goto out;
+		}
+
 		switch (intf->channels[chan].medium) {
 		case IPMI_CHANNEL_MEDIUM_IPMB:
 			if (msg->rsp[4] & 0x04) {
@@ -3557,11 +3676,20 @@ static int handle_new_recv_msg(ipmi_smi_t          intf,
 			break;
 
 		default:
-			/*
-			 * We don't handle the channel type, so just
-			 * free the message.
-			 */
-			requeue = 0;
+			/* Check for OEM Channels.  Clients had better
+			   register for these commands. */
+			if ((intf->channels[chan].medium
+			     >= IPMI_CHANNEL_MEDIUM_OEM_MIN)
+			    && (intf->channels[chan].medium
+				<= IPMI_CHANNEL_MEDIUM_OEM_MAX)) {
+				requeue = handle_oem_get_msg_cmd(intf, msg);
+			} else {
+				/*
+				 * We don't handle the channel type, so just
+				 * free the message.
+				 */
+				requeue = 0;
+			}
 		}
 
 	} else if ((msg->rsp[0] == ((IPMI_NETFN_APP_REQUEST|1) << 2))
diff --git a/include/linux/ipmi.h b/include/linux/ipmi.h
index 7ebdb4f..65aae34 100644
--- a/include/linux/ipmi.h
+++ b/include/linux/ipmi.h
@@ -198,6 +198,8 @@ struct kernel_ipmi_msg {
 					      response.  When you send a
 					      response message, this will
 					      be returned. */
+#define IPMI_OEM_RECV_TYPE		5 /* The response for OEM Channels */
+
 /* Note that async events and received commands do not have a completion
    code as the first byte of the incoming data, unlike a response. */
 
diff --git a/include/linux/ipmi_msgdefs.h b/include/linux/ipmi_msgdefs.h
index b56a158..991b138 100644
--- a/include/linux/ipmi_msgdefs.h
+++ b/include/linux/ipmi_msgdefs.h
@@ -109,5 +109,7 @@
 #define IPMI_CHANNEL_MEDIUM_USB1	10
 #define IPMI_CHANNEL_MEDIUM_USB2	11
 #define IPMI_CHANNEL_MEDIUM_SYSINTF	12
+#define IPMI_CHANNEL_MEDIUM_OEM_MIN	0x60
+#define IPMI_CHANNEL_MEDIUM_OEM_MAX	0x7f
 
 #endif /* __LINUX_IPMI_MSGDEFS_H */
