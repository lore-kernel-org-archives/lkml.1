Return-Path: <linux-kernel-owner+w=401wt.eu-S1753097AbXC0Dg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbXC0Dg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 23:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932372AbXC0Dg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 23:36:29 -0400
Received: from smtp101.sbc.mail.re2.yahoo.com ([68.142.229.104]:44191 "HELO
	smtp101.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753089AbXC0Dg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 23:36:28 -0400
X-YMail-OSG: MQnGP_oVM1nHdzvrvCTn5tBYsBSFTvSWZUq0gKRuqLlAuRjLhZ4RvWcLLy7vJ9GD_QhpVHCdCw--
Date: Mon, 26 Mar 2007 22:36:26 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: dev@openvz.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       Badari Pulavarty <badari@us.ibm.com>, Andrew Morton <akpm@osdl.org>
Subject: [PATCH] ipcns: fix stupid !CONFIG_IPC error
Message-ID: <20070327033626.GA4312@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I broke CONFIG_IPC=n.  This is a port of the patch Andrew
used to fix it in -mm

Here is a question...  When CONFIG_IPC_NS=n and the user asks for
a new IPC namespace, we want to return -EINVAL to let them know
we couldn't oblige.  But if CONFIG_IPC=n is it ok to just return 0?

If not, then we'll need a somewhat different fix, as we can't
#include sched.h in ipc.h.

thanks,
-serge

From: Serge E. Hallyn <serue@us.ibm.com>
Subject: [PATCH] ipcns: fix stupid !CONFIG_IPC error

Andrew Morton pointed out my patch to fix CLONE_NEWIPC behavior
when CONFIG_IPC_NS=n broke compilation when CONFIG_IPC=n.

Make sure copy_ipcs() is always defined.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>

---

 include/linux/ipc.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

d731d029f908b76af52d2abd9ab199fa931d2c98
diff --git a/include/linux/ipc.h b/include/linux/ipc.h
index 5c05c88..6da6772 100644
--- a/include/linux/ipc.h
+++ b/include/linux/ipc.h
@@ -92,11 +92,13 @@ extern struct ipc_namespace init_ipc_ns;
 
 #ifdef CONFIG_SYSVIPC
 #define INIT_IPC_NS(ns)		.ns		= &init_ipc_ns,
+extern int copy_ipcs(unsigned long flags, struct task_struct *tsk);
 #else
 #define INIT_IPC_NS(ns)
+static inline int copy_ipcs(unsigned long flags, struct task_struct *tsk)
+{ return 0; }
 #endif
 
-extern int copy_ipcs(unsigned long flags, struct task_struct *tsk);
 #ifdef CONFIG_IPC_NS
 extern void free_ipc_ns(struct kref *kref);
 extern int unshare_ipcs(unsigned long flags, struct ipc_namespace **ns);
-- 
1.3.2

