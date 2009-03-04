Return-Path: <linux-kernel-owner+w=401wt.eu-S1753164AbZCDMW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbZCDMW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 07:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZCDMWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 07:22:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55976 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbZCDMWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 07:22:18 -0500
Message-ID: <49AE7274.2080206@suse.de>
Date: Wed, 04 Mar 2009 13:22:12 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>
Cc: akpm@linux-foundation.org, minyard@acm.org,
       openipmi-developer@lists.sourceforge.net,
       Frank Seidel <fseidel@suse.de>, Frank Seidel <fseidel@suse.de>,
       kernalert.de@gmail.com, djwong@us.ibm.com,
       Adrian Bunk <bunk@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       cminyard@mvista.com, kbaidarov@ru.mvista.com, crquan@gmail.com
Subject: [PATCH] ipmi: reduce stack size of msghandler
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Seidel <frank@f-seidel.de>

Reduce stack memory footprint in ipmi_msghandler
for send_panic_events. (From 992 bytes on i386
down to below 100)

Signed-off-by: Frank Seidel <frank@f-seidel.de>
---
 drivers/char/ipmi/ipmi_msghandler.c |   39 ++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -4001,8 +4001,20 @@ static void send_panic_events(char *str)
 	unsigned char                     data[16];
 	struct ipmi_system_interface_addr *si;
 	struct ipmi_addr                  addr;
-	struct ipmi_smi_msg               smi_msg;
-	struct ipmi_recv_msg              recv_msg;
+	struct ipmi_smi_msg               *smi_msg;
+	struct ipmi_recv_msg              *recv_msg;
+
+	smi_msg = kmalloc(sizeof(*smi_msg), GFP_KERNEL);
+	recv_msg = kmalloc(sizeof(*recv_msg), GFP_KERNEL);
+
+	if (!smi_msg || !recv_msg) {
+		printk(KERN_ERR PFX "Could not allocate memory\n");
+		if (smi_msg)
+			kfree(smi_msg);
+		else if (recv_msg)
+			kfree(recv_msg);
+		return;
+	}
 
 	si = (struct ipmi_system_interface_addr *) &addr;
 	si->addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
@@ -4030,8 +4042,8 @@ static void send_panic_events(char *str)
 		data[7] = str[2];
 	}
 
-	smi_msg.done = dummy_smi_done_handler;
-	recv_msg.done = dummy_recv_done_handler;
+	smi_msg->done = dummy_smi_done_handler;
+	recv_msg->done = dummy_recv_done_handler;
 
 	/* For every registered interface, send the event. */
 	list_for_each_entry_rcu(intf, &ipmi_interfaces, link) {
@@ -4048,8 +4060,8 @@ static void send_panic_events(char *str)
 			       0,
 			       &msg,
 			       intf,
-			       &smi_msg,
-			       &recv_msg,
+			       smi_msg,
+			       recv_msg,
 			       0,
 			       intf->channels[0].address,
 			       intf->channels[0].lun,
@@ -4107,8 +4119,8 @@ static void send_panic_events(char *str)
 			       0,
 			       &msg,
 			       intf,
-			       &smi_msg,
-			       &recv_msg,
+			       smi_msg,
+			       recv_msg,
 			       0,
 			       intf->channels[0].address,
 			       intf->channels[0].lun,
@@ -4127,8 +4139,8 @@ static void send_panic_events(char *str)
 				       0,
 				       &msg,
 				       intf,
-				       &smi_msg,
-				       &recv_msg,
+				       smi_msg,
+				       recv_msg,
 				       0,
 				       intf->channels[0].address,
 				       intf->channels[0].lun,
@@ -4195,8 +4207,8 @@ static void send_panic_events(char *str)
 				       0,
 				       &msg,
 				       intf,
-				       &smi_msg,
-				       &recv_msg,
+				       smi_msg,
+				       recv_msg,
 				       0,
 				       intf->channels[0].address,
 				       intf->channels[0].lun,
@@ -4204,6 +4216,9 @@ static void send_panic_events(char *str)
 		}
 	}
 #endif /* CONFIG_IPMI_PANIC_STRING */
+
+	kfree(smi_msg);
+	kfree(recv_msg);
 }
 #endif /* CONFIG_IPMI_PANIC_EVENT */
 
