Return-Path: <linux-kernel-owner+w=401wt.eu-S1756969AbYE0IYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969AbYE0IYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 04:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755593AbYE0IYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 04:24:43 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:51482 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbYE0IYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 04:24:42 -0400
Message-Id: <20080527082502.538707000@bull.net>
References: <20080527082441.239624000@bull.net>
User-Agent: quilt/0.45-1
Date: Tue, 27 May 2008 10:24:42 +0200
From: Nadia.Derbey@bull.net
To: akpm@linux-foundation.org
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 1/1] Only output msgmni value at boot time
Content-Disposition: inline; filename=fix_msgmni_printk.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When posting:
[PATCH 1/8] Scaling msgmni to the amount of lowmem
(see http://lkml.org/lkml/2008/2/11/171), I have added a KERN_INFO message
that is output each time msgmni is recomputed.

In http://lkml.org/lkml/2008/4/29/575 Tony Luck complained that this message
references an ipc namespace address that is useless.

I first thought of using an audit_log instead of a printk, as suggested by
Serge Hallyn. But unfortunately, we do not have any other information than
the namespace address to provide here too.
So I chose to move the message and output it only at boot time, removing the
reference to the namespace.

This patch applies to 2.6.26-rc2-mm1.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 ipc/msg.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

Index: linux-2.6.26-rc2-mm1/ipc/msg.c
===================================================================
--- linux-2.6.26-rc2-mm1.orig/ipc/msg.c	2008-05-26 12:25:37.000000000 +0200
+++ linux-2.6.26-rc2-mm1/ipc/msg.c	2008-05-27 10:59:34.000000000 +0200
@@ -98,20 +98,15 @@ void recompute_msgmni(struct ipc_namespa
 
 	if (allowed < MSGMNI) {
 		ns->msg_ctlmni = MSGMNI;
-		goto out_callback;
+		return;
 	}
 
 	if (allowed > IPCMNI / nb_ns) {
 		ns->msg_ctlmni = IPCMNI / nb_ns;
-		goto out_callback;
+		return;
 	}
 
 	ns->msg_ctlmni = allowed;
-
-out_callback:
-
-	printk(KERN_INFO "msgmni has been set to %d for ipc namespace %p\n",
-		ns->msg_ctlmni, ns);
 }
 
 void msg_init_ns(struct ipc_namespace *ns)
@@ -136,6 +131,10 @@ void msg_exit_ns(struct ipc_namespace *n
 void __init msg_init(void)
 {
 	msg_init_ns(&init_ipc_ns);
+
+	printk(KERN_INFO "msgmni has been set to %d\n",
+		init_ipc_ns.msg_ctlmni);
+
 	ipc_init_proc_interface("sysvipc/msg",
 				"       key      msqid perms      cbytes       qnum lspid lrpid   uid   gid  cuid  cgid      stime      rtime      ctime\n",
 				IPC_MSG_IDS, sysvipc_msg_proc_show);

--
