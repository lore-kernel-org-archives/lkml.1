Return-Path: <linux-kernel-owner+w=401wt.eu-S1758685AbYLDOvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685AbYLDOvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 09:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755535AbYLDOuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 09:50:12 -0500
Received: from cavolo.yandex.ru ([87.250.244.45]:53993 "EHLO cavolo.yandex.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324AbYLDOuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 09:50:07 -0500
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>
Subject: [W1] Updated documentation.
Date: Thu,  4 Dec 2008 17:50:08 +0300
Message-Id: <12284022141659-git-send-email-zbr@ioremap.net>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12284022144105-git-send-email-zbr@ioremap.net>
References: <12284022104086-git-send-email-zbr@ioremap.net>
 <122840221468-git-send-email-zbr@ioremap.net>
 <12284022143564-git-send-email-zbr@ioremap.net>
 <12284022144105-git-send-email-zbr@ioremap.net>
X-Antivirus: Dr.Web (R) for Mail Servers on cavolo.yandex.ru host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 Documentation/w1/w1.netlink |   34 +++++++++++++++++++++++++---------
 1 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/Documentation/w1/w1.netlink b/Documentation/w1/w1.netlink
index 3640c7c..eae5c8b 100644
--- a/Documentation/w1/w1.netlink
+++ b/Documentation/w1/w1.netlink
@@ -17,25 +17,27 @@ Protocol.
 [struct cn_msg] - connector header. It's length field is equal to size of the attached data.
 [struct w1_netlink_msg] - w1 netlink header.
 	__u8 type 	- message type.
+			W1_LIST_MASTERS - list current bus master list
 			W1_SLAVE_ADD/W1_SLAVE_REMOVE - slave add/remove events.
 			W1_MASTER_ADD/W1_MASTER_REMOVE - master add/remove events.
 			W1_MASTER_CMD - userspace command for bus master device (search/alarm search).
 			W1_SLAVE_CMD - userspace command for slave device (read/write/ search/alarm search
 					for bus master device where given slave device found).
 	__u8 res	- reserved
-	__u16 len	- size of attached to this header data.
+	__u16 len	- size of data attached to this header data.
 	union {
-		__u8 id;			 - slave unique device id
+		__u8 id[8];			 - slave unique device id
 		struct w1_mst {
 			__u32		id;	 - master's id.
 			__u32		res;	 - reserved
 		} mst;
 	} id;
 
-[strucrt w1_netlink_cmd] - command for gived master or slave device.
+[struct w1_netlink_cmd] - command for given master or slave device.
 	__u8 cmd	- command opcode.
 			W1_CMD_READ 	- read command.
 			W1_CMD_WRITE	- write command.
+			W1_CMD_TOUCH	- touch command (write and sample data back to userspace).
 			W1_CMD_SEARCH	- search command.
 			W1_CMD_ALARM_SEARCH - alarm search command.
 	__u8 res	- reserved
@@ -44,7 +46,7 @@ Protocol.
 	__u8 data[0]	- data for this command.
 
 
-Each connector message can include one or more w1_netlink_msg with zero of more attached w1_netlink_cmd messages.
+Each connector message can include one or more w1_netlink_msg with zero or more attached w1_netlink_cmd messages.
 
 For event messages there are no w1_netlink_cmd embedded structures, only connector header
 and w1_netlink_msg strucutre with "len" field being zero and filled type (one of event types)
@@ -59,11 +61,25 @@ cn_msg.len = sizeof(struct w1_netlink_msg) + sizeof(struct w1_netlink_cmd) + cmd
 w1_netlink_msg.len = sizeof(struct w1_netlink_cmd) + cmd->len;
 w1_netlink_cmd.len = cmd->len;
 
+Replies to W1_LIST_MASTERS should send a message back to the userspace
+which will contain list of all registered master ids in the following
+format:
+	
+	cn_msg (CN_W1_IDX.CN_W1_VAL as id, len is equal to sizeof(struct
+	w1_netlink_msg) plus number of masters multipled by 4)
+	w1_netlink_msg (type: W1_LIST_MASTERS, len is equal to number of masters
+	multiplied by 4 (u32 size))
+	id0 ... idN
+	
+	Each message is at most 4k in size, so if number of master devices
+	exceeds this, it will be split into several messages, cn.seq will be
+	increased for each one.
+	
 
 Operation steps in w1 core when new command is received.
 =======================================================
 
-When new message (w1_netlink_msg) is received w1 core detects if it is master of slave request,
+When new message (w1_netlink_msg) is received w1 core detects if it is master or slave request,
 according to w1_netlink_msg.type field.
 Then master or slave device is searched for.
 When found, master device (requested or those one on where slave device is found) is locked.
@@ -82,10 +98,10 @@ Connector [1] specific documentation.
 Each connector message includes two u32 fields as "address".
 w1 uses CN_W1_IDX and CN_W1_VAL defined in include/linux/connector.h header.
 Each message also includes sequence and acknowledge numbers.
-Sequence number for event messages is appropriate bus master sequence number increased with
+Sequence number for event messages is appropriate bus master sequence number increased with 
 each event message sent "through" this master.
 Sequence number for userspace requests is set by userspace application.
-Sequence number for reply is the same as was in request, and
+Sequence number for reply is the same as was in request, and 
 acknowledge number is set to seq+1.
 
 
@@ -93,6 +109,6 @@ Additional documantion, source code examples.
 ============================================
 
 1. Documentation/connector
-2. http://tservice.net.ru/~s0mbre/archive/w1
-This archive includes userspace application w1d.c which
+2. http://www.ioremap.net/archive/w1
+This archive includes userspace application w1d.c which 
 uses read/write/search commands for all master/slave devices found on the bus.
-- 
1.5.2.5

