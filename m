Return-Path: <linux-kernel-owner+w=401wt.eu-S1758536AbYE0QyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536AbYE0QyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 12:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757534AbYE0Qx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 12:53:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:17902 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756797AbYE0Qxz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 12:53:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,549,1204531200"; 
   d="scan'208";a="387565479"
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [PATCH 1/1] Only output msgmni value at boot time
Date: Tue, 27 May 2008 09:52:44 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843EC016AC45B@orsmsx424.amr.corp.intel.com>
In-Reply-To: <20080527082502.538707000@bull.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] Only output msgmni value at boot time
Thread-Index: Aci/0x41p8jIL31pRmauqLAGRpuo8QARjQdQ
References: <20080527082441.239624000@bull.net> <20080527082502.538707000@bull.net>
From: "Luck, Tony" <tony.luck@intel.com>
To: <Nadia.Derbey@bull.net>, <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 27 May 2008 16:53:43.0496 (UTC) FILETIME=[38D0F480:01C8C01A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In http://lkml.org/lkml/2008/4/29/575 Tony Luck complained that this message
> references an ipc namespace address that is useless.
>
> I first thought of using an audit_log instead of a printk, as suggested by
> Serge Hallyn. But unfortunately, we do not have any other information than
> the namespace address to provide here too.
> So I chose to move the message and output it only at boot time, removing the
> reference to the namespace.

Diffing my before/after dmesg(8) output:
< msgmni has been set to 7964 for ipc namespace a000000100a1ad58
---
> msgmni has been set to 7964

Much prettier.  Thank you.

I'll leave it to SGI to ponder whether it is correct to compute
msgmni based on a linear function of lowmem (their big systems can
have terabytes of memory, all of which is counted as lowmem).

> This patch applies to 2.6.26-rc2-mm1.

Acked-by: Tony Luck <tony.luck@intel.com>

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
