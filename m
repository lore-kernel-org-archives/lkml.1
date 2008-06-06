Return-Path: <linux-kernel-owner+w=401wt.eu-S1760122AbYFFGRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122AbYFFGRz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 02:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764450AbYFFGRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 02:17:37 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:59253 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764435AbYFFGRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 02:17:35 -0400
Message-Id: <20080606060958.059451929@bull.net>
References: <20080606060955.317871352@bull.net>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 08:09:56 +0200
From: <Solofo.Ramangalahy@bull.net>
To: <linux-kernel@vger.kernel.org>
Cc: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>
Subject: [RFC -mm 1/6] sysv ipc: scale msgmnb to the number of cpus
Content-Disposition: inline;
 filename=ipc-scale-msgmnb-with-the-number-of-cpus.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>

Initialize msgmnb value to
min(MSGMNB * num_online_cpus(), MSGMNB * MSG_CPU_SCALE)
to increase the default value for larger machines.

MSG_CPU_SCALE scaling factor is defined to be 4, as 16384 x 4 = 65536
is an already used and recommended value.

The msgmni value is made dependant of msgmnb to keep the memory
dedicated to message queues within the 1/MSG_MEM_SCALE of lowmem
bound.

Unlike msgmni, the value is not scaled (down) with respect to the
number of ipc namespaces for simplicity.

Signed-off-by: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>

---
 include/linux/msg.h |    5 +++++
 ipc/msg.c           |   19 +++++++++++++++----
 2 files changed, 20 insertions(+), 4 deletions(-)

Index: b/ipc/msg.c
===================================================================
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -38,6 +38,7 @@
 #include <linux/rwsem.h>
 #include <linux/nsproxy.h>
 #include <linux/ipc_namespace.h>
+#include <linux/cpumask.h>
 
 #include <asm/current.h>
 #include <asm/uaccess.h>
@@ -92,7 +93,7 @@ void recompute_msgmni(struct ipc_namespa
 
 	si_meminfo(&i);
 	allowed = (((i.totalram - i.totalhigh) / MSG_MEM_SCALE) * i.mem_unit)
-		/ MSGMNB;
+		/ ns->msg_ctlmnb;
 	nb_ns = atomic_read(&nr_ipc_ns);
 	allowed /= nb_ns;
 
@@ -108,11 +109,21 @@ void recompute_msgmni(struct ipc_namespa
 
 	ns->msg_ctlmni = allowed;
 }
+/*
+ * Scale msgmnb with the number of online cpus, up to 4x MSGMNB.
+ * ns->msg_ctlmnb cannot be assigned zero because of division in
+ * recompute_msgmni()
+ */
+void recompute_msgmnb(struct ipc_namespace *ns)
+{
+	ns->msg_ctlmnb =
+		min(MSGMNB * num_online_cpus(), MSGMNB * MSG_CPU_SCALE);
+}
 
 void msg_init_ns(struct ipc_namespace *ns)
 {
 	ns->msg_ctlmax = MSGMAX;
-	ns->msg_ctlmnb = MSGMNB;
+	recompute_msgmnb(ns);
 
 	recompute_msgmni(ns);
 
@@ -132,8 +143,8 @@ void __init msg_init(void)
 {
 	msg_init_ns(&init_ipc_ns);
 
-	printk(KERN_INFO "msgmni has been set to %d\n",
-		init_ipc_ns.msg_ctlmni);
+	printk(KERN_INFO "msgmni has been set to %d, msgmnb to %d\n",
+	       init_ipc_ns.msg_ctlmni, init_ipc_ns.msg_ctlmnb);
 
 	ipc_init_proc_interface("sysvipc/msg",
 				"       key      msqid perms      cbytes       qnum lspid lrpid   uid   gid  cuid  cgid      stime      rtime      ctime\n",
Index: b/include/linux/msg.h
===================================================================
--- a/include/linux/msg.h
+++ b/include/linux/msg.h
@@ -58,6 +58,11 @@ struct msginfo {
  * more than 16 GB : msgmni = 32K (IPCMNI)
  */
 #define MSG_MEM_SCALE 32
+/*
+ * Scaling factor to compute msgmnb:
+ * ns->msg_ctlmnb is between MSGMNB and MSGMNB * MSG_CPU_SCALE
+ */
+#define MSG_CPU_SCALE 4
 
 #define MSGMNI    16   /* <= IPCMNI */     /* max # of msg queue identifiers */
 #define MSGMAX  8192   /* <= INT_MAX */   /* max size of message (bytes) */

-- 
Solofo Ramangalahy
Bull SA.
