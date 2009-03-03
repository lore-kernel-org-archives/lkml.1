Return-Path: <linux-kernel-owner+w=401wt.eu-S1757491AbZCCQUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbZCCQUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 11:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbZCCQUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 11:20:25 -0500
Received: from vms173011pub.verizon.net ([206.46.173.11]:44184 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669AbZCCQUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 11:20:24 -0500
X-Greylist: delayed 3612 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Mar 2009 11:20:24 EST
Date: Tue, 03 Mar 2009 09:19:59 -0600
From: Corey Minyard <minyard@acm.org>
To: Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Bela Lubkin <blubkin@vmware.com>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Subject: [PATCH 3/5] IPMI: Fix statistics counting issues
Message-id: <20090303151959.GC7777@minyard.local>
Reply-to: minyard@acm.org
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

Bela Lubkin noticed that the statistics for send IPMB and LAN commands
in the IPMI driver could be incremented even if an error occurred.
Move the increments to the proper place to avoid this.

Also add some statistics for retransmissions that failed, and some
little helper functions to neaten up the code a little.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: Bela Lubkin <blubkin@vmware.com>

Index: linux-2.6.27/drivers/char/ipmi/ipmi_msghandler.c
===================================================================
--- linux-2.6.27.orig/drivers/char/ipmi/ipmi_msghandler.c
+++ linux-2.6.27/drivers/char/ipmi/ipmi_msghandler.c
@@ -284,6 +284,11 @@ enum ipmi_stat_indexes {
 	/* Events that were received with the proper format. */
 	IPMI_STAT_events,
 
+	/* Retransmissions on IPMB that failed. */
+	IPMI_STAT_dropped_rexmit_ipmb_commands,
+
+	/* Retransmissions on LAN that failed. */
+	IPMI_STAT_dropped_rexmit_lan_commands,
 
 	/* This *must* remain last, add new values above this. */
 	IPMI_NUM_STATS
@@ -452,6 +457,20 @@ static DEFINE_MUTEX(smi_watchers_mutex);
 #define ipmi_get_stat(intf, stat) \
 	((unsigned int) atomic_read(&(intf)->stats[IPMI_STAT_ ## stat]))
 
+static int is_lan_addr(struct ipmi_addr *addr)
+{
+	return addr->addr_type == IPMI_LAN_ADDR_TYPE;
+}
+
+static int is_ipmb_addr(struct ipmi_addr *addr)
+{
+	return addr->addr_type == IPMI_IPMB_ADDR_TYPE;
+}
+
+static int is_ipmb_bcast_addr(struct ipmi_addr *addr)
+{
+	return addr->addr_type == IPMI_IPMB_BROADCAST_ADDR_TYPE;
+}
 
 static void free_recv_msg_list(struct list_head *q)
 {
@@ -608,8 +627,7 @@ ipmi_addr_equal(struct ipmi_addr *addr1,
 		return (smi_addr1->lun == smi_addr2->lun);
 	}
 
-	if ((addr1->addr_type == IPMI_IPMB_ADDR_TYPE)
-	    || (addr1->addr_type == IPMI_IPMB_BROADCAST_ADDR_TYPE)) {
+	if (is_ipmb_addr(addr1) || is_ipmb_bcast_addr(addr1)) {
 		struct ipmi_ipmb_addr *ipmb_addr1
 		    = (struct ipmi_ipmb_addr *) addr1;
 		struct ipmi_ipmb_addr *ipmb_addr2
@@ -619,7 +637,7 @@ ipmi_addr_equal(struct ipmi_addr *addr1,
 			&& (ipmb_addr1->lun == ipmb_addr2->lun));
 	}
 
-	if (addr1->addr_type == IPMI_LAN_ADDR_TYPE) {
+	if (is_lan_addr(addr1)) {
 		struct ipmi_lan_addr *lan_addr1
 			= (struct ipmi_lan_addr *) addr1;
 		struct ipmi_lan_addr *lan_addr2
@@ -652,14 +670,13 @@ int ipmi_validate_addr(struct ipmi_addr 
 	    || (addr->channel < 0))
 		return -EINVAL;
 
-	if ((addr->addr_type == IPMI_IPMB_ADDR_TYPE)
-	    || (addr->addr_type == IPMI_IPMB_BROADCAST_ADDR_TYPE)) {
+	if (is_ipmb_addr(addr) || is_ipmb_bcast_addr(addr)) {
 		if (len < sizeof(struct ipmi_ipmb_addr))
 			return -EINVAL;
 		return 0;
 	}
 
-	if (addr->addr_type == IPMI_LAN_ADDR_TYPE) {
+	if (is_lan_addr(addr)) {
 		if (len < sizeof(struct ipmi_lan_addr))
 			return -EINVAL;
 		return 0;
@@ -1517,8 +1534,7 @@ static int i_ipmi_request(ipmi_user_t   
 			memcpy(&(smi_msg->data[2]), msg->data, msg->data_len);
 		smi_msg->data_size = msg->data_len + 2;
 		ipmi_inc_stat(intf, sent_local_commands);
-	} else if ((addr->addr_type == IPMI_IPMB_ADDR_TYPE)
-		   || (addr->addr_type == IPMI_IPMB_BROADCAST_ADDR_TYPE)) {
+	} else if (is_ipmb_addr(addr) || is_ipmb_bcast_addr(addr)) {
 		struct ipmi_ipmb_addr *ipmb_addr;
 		unsigned char         ipmb_seq;
 		long                  seqid;
@@ -1597,8 +1613,6 @@ static int i_ipmi_request(ipmi_user_t   
 
 			spin_lock_irqsave(&(intf->seq_lock), flags);
 
-			ipmi_inc_stat(intf, sent_ipmb_commands);
-
 			/*
 			 * Create a sequence number with a 1 second
 			 * timeout and 4 retries.
@@ -1620,6 +1634,8 @@ static int i_ipmi_request(ipmi_user_t   
 				goto out_err;
 			}
 
+			ipmi_inc_stat(intf, sent_ipmb_commands);
+
 			/*
 			 * Store the sequence number in the message,
 			 * so that when the send message response
@@ -1649,7 +1665,7 @@ static int i_ipmi_request(ipmi_user_t   
 			 */
 			spin_unlock_irqrestore(&(intf->seq_lock), flags);
 		}
-	} else if (addr->addr_type == IPMI_LAN_ADDR_TYPE) {
+	} else if (is_lan_addr(addr)) {
 		struct ipmi_lan_addr  *lan_addr;
 		unsigned char         ipmb_seq;
 		long                  seqid;
@@ -1710,8 +1726,6 @@ static int i_ipmi_request(ipmi_user_t   
 
 			spin_lock_irqsave(&(intf->seq_lock), flags);
 
-			ipmi_inc_stat(intf, sent_lan_commands);
-
 			/*
 			 * Create a sequence number with a 1 second
 			 * timeout and 4 retries.
@@ -1733,6 +1747,8 @@ static int i_ipmi_request(ipmi_user_t   
 				goto out_err;
 			}
 
+			ipmi_inc_stat(intf, sent_lan_commands);
+
 			/*
 			 * Store the sequence number in the message,
 			 * so that when the send message response
@@ -1951,6 +1967,10 @@ static int stat_file_read_proc(char *pag
 		       ipmi_get_stat(intf, invalid_events));
 	out += sprintf(out, "events:                      %u\n",
 		       ipmi_get_stat(intf, events));
+	out += sprintf(out, "failed rexmit LAN msgs:      %u\n",
+		       ipmi_get_stat(intf, dropped_rexmit_lan_commands));
+	out += sprintf(out, "failed rexmit IPMB msgs:     %u\n",
+		       ipmi_get_stat(intf, dropped_rexmit_ipmb_commands));
 
 	return (out - ((char *) page));
 }
@@ -3754,7 +3774,7 @@ static void check_msg_timeout(ipmi_smi_t
 		list_add_tail(&msg->link, timeouts);
 		if (ent->broadcast)
 			ipmi_inc_stat(intf, timed_out_ipmb_broadcasts);
-		else if (ent->recv_msg->addr.addr_type == IPMI_LAN_ADDR_TYPE)
+		else if (is_lan_addr(&ent->recv_msg->addr))
 			ipmi_inc_stat(intf, timed_out_lan_commands);
 		else
 			ipmi_inc_stat(intf, timed_out_ipmb_commands);
@@ -3768,15 +3788,17 @@ static void check_msg_timeout(ipmi_smi_t
 		 */
 		ent->timeout = MAX_MSG_TIMEOUT;
 		ent->retries_left--;
-		if (ent->recv_msg->addr.addr_type == IPMI_LAN_ADDR_TYPE)
-			ipmi_inc_stat(intf, retransmitted_lan_commands);
-		else
-			ipmi_inc_stat(intf, retransmitted_ipmb_commands);
-
 		smi_msg = smi_from_recv_msg(intf, ent->recv_msg, slot,
 					    ent->seqid);
-		if (!smi_msg)
+		if (!smi_msg) {
+			if (is_lan_addr(&ent->recv_msg->addr))
+				ipmi_inc_stat(intf,
+					      dropped_rexmit_lan_commands);
+			else
+				ipmi_inc_stat(intf,
+					      dropped_rexmit_ipmb_commands);
 			return;
+		}
 
 		spin_unlock_irqrestore(&intf->seq_lock, *flags);
 
@@ -3788,10 +3810,17 @@ static void check_msg_timeout(ipmi_smi_t
 		 * resent.
 		 */
 		handlers = intf->handlers;
-		if (handlers)
+		if (handlers) {
+			if (is_lan_addr(&ent->recv_msg->addr))
+				ipmi_inc_stat(intf,
+					      retransmitted_lan_commands);
+			else
+				ipmi_inc_stat(intf,
+					      retransmitted_ipmb_commands);
+
 			intf->handlers->sender(intf->send_info,
 					       smi_msg, 0);
-		else
+		} else
 			ipmi_free_smi_msg(smi_msg);
 
 		spin_lock_irqsave(&intf->seq_lock, *flags);
