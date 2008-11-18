Return-Path: <linux-kernel-owner+w=401wt.eu-S1753033AbYKRSMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033AbYKRSMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 13:12:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbYKRSMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 13:12:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:29642 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbYKRSMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 13:12:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=XKsRapeuvuERgc0vx04zF/HXBmt0aZEi3o0eqZ9CWl8HyLyhAdawnr6OCjDKOkNJQl
         SbEWbzHuXeebcnOPUZ122emboO6o+2OXdWpjSly9Uhi4h3wdWPlQHcvRCAmiGmwtD2mY
         nw8+XSGS3Fl/Wy4+tWRLbc/ncwJMTRQb80Kck=
Date: Tue, 18 Nov 2008 18:12:26 +0000
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Eric Biederman <ebiederm@xmision.com>
Subject: [Patch] ipc/ipc_sysctl.c: move the definition of
	ipc_auto_callback()
Message-ID: <20081118181226.GG3185@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


proc_ipcauto_dointvec_minmax() is the only user of ipc_auto_callback(),
since the former function is protected by CONFIG_PROC_FS, so should be
the latter one.

Just move its definition down.


Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Eric Biederman <ebiederm@xmision.com>

---
diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
index 0dfebc5..4a7a12c 100644
--- a/ipc/ipc_sysctl.c
+++ b/ipc/ipc_sysctl.c
@@ -26,29 +26,6 @@ static void *get_ipc(ctl_table *table)
 	return which;
 }
 
-/*
- * Routine that is called when the file "auto_msgmni" has successfully been
- * written.
- * Two values are allowed:
- * 0: unregister msgmni's callback routine from the ipc namespace notifier
- *    chain. This means that msgmni won't be recomputed anymore upon memory
- *    add/remove or ipc namespace creation/removal.
- * 1: register back the callback routine.
- */
-static void ipc_auto_callback(int val)
-{
-	if (!val)
-		unregister_ipcns_notifier(current->nsproxy->ipc_ns);
-	else {
-		/*
-		 * Re-enable automatic recomputing only if not already
-		 * enabled.
-		 */
-		recompute_msgmni(current->nsproxy->ipc_ns);
-		cond_register_ipcns_notifier(current->nsproxy->ipc_ns);
-	}
-}
-
 #ifdef CONFIG_PROC_FS
 static int proc_ipc_dointvec(ctl_table *table, int write, struct file *filp,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
@@ -94,6 +71,29 @@ static int proc_ipc_doulongvec_minmax(ctl_table *table, int write,
 					lenp, ppos);
 }
 
+/*
+ * Routine that is called when the file "auto_msgmni" has successfully been
+ * written.
+ * Two values are allowed:
+ * 0: unregister msgmni's callback routine from the ipc namespace notifier
+ *    chain. This means that msgmni won't be recomputed anymore upon memory
+ *    add/remove or ipc namespace creation/removal.
+ * 1: register back the callback routine.
+ */
+static void ipc_auto_callback(int val)
+{
+	if (!val)
+		unregister_ipcns_notifier(current->nsproxy->ipc_ns);
+	else {
+		/*
+		 * Re-enable automatic recomputing only if not already
+		 * enabled.
+		 */
+		recompute_msgmni(current->nsproxy->ipc_ns);
+		cond_register_ipcns_notifier(current->nsproxy->ipc_ns);
+	}
+}
+
 static int proc_ipcauto_dointvec_minmax(ctl_table *table, int write,
 	struct file *filp, void __user *buffer, size_t *lenp, loff_t *ppos)
 {


