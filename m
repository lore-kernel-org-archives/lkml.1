Return-Path: <linux-kernel-owner+w=401wt.eu-S1751560AbYANP6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbYANP6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 10:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbYANP5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 10:57:48 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43373 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYANP5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 10:57:47 -0500
Message-Id: <20080114155601.696542000@bull.net>
References: <20080114155402.690906000@bull.net>
User-Agent: quilt/0.45-1
Date: Mon, 14 Jan 2008 16:54:03 +0100
From: Nadia.Derbey@bull.net
To: akmp@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, matthltc@us.ibm.com,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [RFC PATCH 1/4] [RESEND] Scaling msgmni to the amount of lowmem
Content-Disposition: inline; filename=ipc_scale_msgmni_with_lowmem.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 01/04]

This patch computes msg_ctlmni to make it scale with the amount of lowmem.
msg_ctlmni is now set to make the message queues occupy 1/32 of the available
lowmem.

Some cleaning has also been done in the MSGXXX constants:
  . MSGPOOL: the msgctl man page says it's not used, but it also defines it as
             a size in bytes (the code expresses it in Kbytes).
  . MSGSEG definition has been removed since it used only once in msgctl().

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 include/linux/msg.h |   14 +++++++++++---
 ipc/msg.c           |   44 ++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 53 insertions(+), 5 deletions(-)

Index: linux-2.6.24-rc7/include/linux/msg.h
===================================================================
--- linux-2.6.24-rc7.orig/include/linux/msg.h	2008-01-11 14:08:41.000000000 +0100
+++ linux-2.6.24-rc7/include/linux/msg.h	2008-01-11 14:50:47.000000000 +0100
@@ -49,17 +49,25 @@ struct msginfo {
 	unsigned short  msgseg; 
 };
 
+/*
+ * Scaling factor to compute msgmni:
+ * the memory dedicated to msg queues (msgmni * msgmnb) should occupy
+ * at most 1/MSG_MEM_SCALE of the lowmem (see the formula in ipc/msg.c):
+ * up to 8MB       : msgmni = 16 (MSGMNI)
+ * 4 GB            : msgmni = 8K
+ * more than 16 GB : msgmni = 32K (IPCMNI)
+ */
+#define MSG_MEM_SCALE 32
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
Index: linux-2.6.24-rc7/ipc/msg.c
===================================================================
--- linux-2.6.24-rc7.orig/ipc/msg.c	2008-01-11 14:08:48.000000000 +0100
+++ linux-2.6.24-rc7/ipc/msg.c	2008-01-11 15:51:00.000000000 +0100
@@ -27,6 +27,7 @@
 #include <linux/msg.h>
 #include <linux/spinlock.h>
 #include <linux/init.h>
+#include <linux/mm.h>
 #include <linux/proc_fs.h>
 #include <linux/list.h>
 #include <linux/security.h>
@@ -79,12 +80,51 @@ static int newque(struct ipc_namespace *
 static int sysvipc_msg_proc_show(struct seq_file *s, void *it);
 #endif
 
+/*
+ * Scale msgmni with the available lowmem size: the memory dedicated to msg
+ * queues should occupy at most 1/MSG_MEM_SCALE of lowmem.
+ */
+static void recompute_msgmni(struct ipc_namespace *ns)
+{
+	struct sysinfo i;
+	unsigned long allowed;
+
+	si_meminfo(&i);
+	allowed = (((i.totalram - i.totalhigh) / MSG_MEM_SCALE) * i.mem_unit)
+		/ MSGMNB;
+
+	/*
+	 * Never fall under the current minimum value
+	 */
+	if (allowed < MSGMNI) {
+		ns->msg_ctlmni = MSGMNI;
+		goto out_callback;
+	}
+
+	/*
+	 * Never go over the current max value
+	 */
+	if (allowed > IPCMNI) {
+		ns->msg_ctlmni = IPCMNI;
+		goto out_callback;
+	}
+
+	ns->msg_ctlmni = allowed;
+
+out_callback:
+
+	printk(KERN_INFO "msgmni has been set to %d for ipc namespace %p\n",
+		ns->msg_ctlmni, ns);
+}
+
 static void __msg_init_ns(struct ipc_namespace *ns, struct ipc_ids *ids)
 {
 	ns->ids[IPC_MSG_IDS] = ids;
 	ns->msg_ctlmax = MSGMAX;
 	ns->msg_ctlmnb = MSGMNB;
-	ns->msg_ctlmni = MSGMNI;
+
+	recompute_msgmni(ns);
+
 	atomic_set(&ns->msg_bytes, 0);
 	atomic_set(&ns->msg_hdrs, 0);
 	ipc_init_ids(ids);
@@ -458,7 +498,7 @@ asmlinkage long sys_msgctl(int msqid, in
 		msginfo.msgmax = ns->msg_ctlmax;
 		msginfo.msgmnb = ns->msg_ctlmnb;
 		msginfo.msgssz = MSGSSZ;
-		msginfo.msgseg = MSGSEG;
+		msginfo.msgseg = min(MSGPOOL / MSGSSZ, 0xffff);
 		down_read(&msg_ids(ns).rw_mutex);
 		if (cmd == MSG_INFO) {
 			msginfo.msgpool = msg_ids(ns).in_use;

--
