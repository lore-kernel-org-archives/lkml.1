Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbXLKPfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbXLKPfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 10:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754516AbXLKPfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 10:35:23 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:44550 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470AbXLKPfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 10:35:21 -0500
Message-Id: <20071211154143.964066000@bull.net>
References: <20071211153845.766147000@bull.net>
User-Agent: quilt/0.45-1
Date: Tue, 11 Dec 2007 16:38:46 +0100
From: Nadia.Derbey@bull.net
To: linux-kernel@vger.kernel.org
Cc: matthltc@us.ibm.com, Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [RFC PATCH 1/2] Scaling msgmni to the system memory
Content-Disposition: inline; filename=ipc_scale_msgmni_with_totalram.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 01/02]

This patch computes msg_ctlmni to make it scale with system memory.
msg_ctlmni is now set to make the message queues occupy 1/32 of the available
memory.

Some cleaning has also been done in the MSGXXX constants:
  . MSGPOOL: the msgctl man page says it's not used, but it also defines it as
             a size in bytes (the code expresses it in Kbytes).
  . MSGSEG definition has been removed since it used only once in msgctl().

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 include/linux/msg.h |    6 +++---
 ipc/msg.c           |   20 ++++++++++++++++++--
 2 files changed, 21 insertions(+), 5 deletions(-)

Index: linux-2.6.24-rc4/include/linux/msg.h
===================================================================
--- linux-2.6.24-rc4.orig/include/linux/msg.h	2007-12-11 11:57:53.000000000 +0100
+++ linux-2.6.24-rc4/include/linux/msg.h	2007-12-11 12:10:01.000000000 +0100
@@ -49,17 +49,17 @@ struct msginfo {
 	unsigned short  msgseg; 
 };
 
+#define MSG_MEM_SCALE 32    /* Scaling factor to compute msgmni */
+
 #define MSGMNI    16   /* <= IPCMNI */     /* max # of msg queue identifiers */
 #define MSGMAX  8192   /* <= INT_MAX */   /* max size of message (bytes) */
 #define MSGMNB 16384   /* <= INT_MAX */   /* default max size of a message queue */
 
 /* unused */
-#define MSGPOOL (MSGMNI*MSGMNB/1024)  /* size in kilobytes of message pool */
+#define MSGPOOL (MSGMNI * MSGMNB) /* size in bytes of message pool */
 #define MSGTQL  MSGMNB            /* number of system message headers */
 #define MSGMAP  MSGMNB            /* number of entries in message map */
 #define MSGSSZ  16                /* message segment size */
-#define __MSGSEG ((MSGPOOL*1024)/ MSGSSZ) /* max no. of segments */
-#define MSGSEG (__MSGSEG <= 0xffff ? __MSGSEG : 0xffff)
 
 #ifdef __KERNEL__
 #include <linux/list.h>
Index: linux-2.6.24-rc4/ipc/msg.c
===================================================================
--- linux-2.6.24-rc4.orig/ipc/msg.c	2007-12-11 11:57:58.000000000 +0100
+++ linux-2.6.24-rc4/ipc/msg.c	2007-12-11 12:12:32.000000000 +0100
@@ -27,6 +27,7 @@
 #include <linux/msg.h>
 #include <linux/spinlock.h>
 #include <linux/init.h>
+#include <linux/mm.h>
 #include <linux/proc_fs.h>
 #include <linux/list.h>
 #include <linux/security.h>
@@ -81,10 +82,25 @@ static int sysvipc_msg_proc_show(struct 
 
 static void __msg_init_ns(struct ipc_namespace *ns, struct ipc_ids *ids)
 {
+	struct sysinfo i;
+	unsigned long allowed;
+
 	ns->ids[IPC_MSG_IDS] = ids;
 	ns->msg_ctlmax = MSGMAX;
 	ns->msg_ctlmnb = MSGMNB;
-	ns->msg_ctlmni = MSGMNI;
+
+	/*
+	 * Scale msgmni with the available memory size: the memory dedicated
+	 * to msg queues should occupy 1/32 of the available memory:
+	 * up to 8MB       : msgmni = 16 (MSGMNI)
+	 * 4 GB            : msgmni = 8K
+	 * more than 16 GB : msgmni = 32K (IPCMNI)
+	 */
+	si_meminfo(&i);
+	allowed = ((i.totalram / MSG_MEM_SCALE) * i.mem_unit) / MSGMNB;
+	ns->msg_ctlmni = min((unsigned long) IPCMNI,
+			max((unsigned long) MSGMNI, allowed));
+
 	atomic_set(&ns->msg_bytes, 0);
 	atomic_set(&ns->msg_hdrs, 0);
 	ipc_init_ids(ids);
@@ -458,7 +474,7 @@ asmlinkage long sys_msgctl(int msqid, in
 		msginfo.msgmax = ns->msg_ctlmax;
 		msginfo.msgmnb = ns->msg_ctlmnb;
 		msginfo.msgssz = MSGSSZ;
-		msginfo.msgseg = MSGSEG;
+		msginfo.msgseg = min(MSGPOOL / MSGSSZ, 0xffff);
 		down_read(&msg_ids(ns).rw_mutex);
 		if (cmd == MSG_INFO) {
 			msginfo.msgpool = msg_ids(ns).in_use;

--
