Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbZCDPxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbZCDPxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 10:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbZCDPxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 10:53:08 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58263 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214AbZCDPxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 10:53:07 -0500
Date: Wed, 4 Mar 2009 09:52:51 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Containers <containers@lists.osdl.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] ipc namespace: initialize init_ipc_ns.count to 1
Message-ID: <20090304155251.GA11741@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

when I sent an earlier version of the posix mqueue namespaces patchset
you called me on setting init_ipc_ns.count to 2.  The following patch
changes that to 1.  This is safe because the 1-count is for swapper, who
cannot unshare the namespace.  Having init do unshare(CLONE_NEWIPC) only
drops the count to 1.  No pre-init resources other than tasks pin (and
therefore can decrease the refcount on) an ipc_ns.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 ipc/msgutil.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/ipc/msgutil.c b/ipc/msgutil.c
index e5d6da1..f095ee2 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -26,8 +26,7 @@ DEFINE_SPINLOCK(mq_lock);
  * and not CONFIG_IPC_NS.
  */
 struct ipc_namespace init_ipc_ns = {
-	/* It's not for this patch to change, but should this be 1? */
-	.count		= ATOMIC_INIT(2),
+	.count		= ATOMIC_INIT(1),
 #ifdef CONFIG_POSIX_MQUEUE
 	.mq_queues_max   = DFLT_QUEUESMAX,
 	.mq_msg_max      = DFLT_MSGMAX,
-- 
1.5.4.3

