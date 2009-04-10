Return-Path: <linux-kernel-owner+w=401wt.eu-S933156AbZDJCe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156AbZDJCe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 22:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932592AbZDJCd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 22:33:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:37038 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764863AbZDJCdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 22:33:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=bCPy7+JPHkr1GO1tE3M7aNiBy77DHm737imrOAPwVirN/gieFAzEufwzDWNv93/i/W
         HwSrmmRCYQ3s/8U/Ssv2V+HEPsFWNxmIxwXRQ9mXLvbDPZCbXBlEz0q2tDUr+iuYNpaJ
         m8Z0REhhJ8n5ANhsAMNvnLOF2xwxVtoQ+yK+0=
Date: Fri, 10 Apr 2009 06:33:58 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, containers@lists.linux-foundation.org
Cc: xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, orenl@cs.columbia.edu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/30] ipcns: add create_ipc_ns()
Message-ID: <20090410023358.GE27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clone_ipc_ns() is misnamed, it doesn't clone anything and doesn't uses passed
parameter. Rename it.

create_ipc_ns() will be used by C/R to create ipcns on restart.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/ipc_namespace.h |    1 +
 ipc/namespace.c               |    9 ++-------
 2 files changed, 3 insertions(+), 7 deletions(-)

--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -97,6 +97,7 @@ static inline int mq_init_ns(struct ipc_namespace *ns) { return 0; }
 
 #if defined(CONFIG_IPC_NS)
 extern void free_ipc_ns(struct ipc_namespace *ns);
+struct ipc_namespace *create_ipc_ns(void);
 extern struct ipc_namespace *copy_ipcs(unsigned long flags,
 				       struct ipc_namespace *ns);
 extern void free_ipcs(struct ipc_namespace *ns, struct ipc_ids *ids,
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -14,7 +14,7 @@
 
 #include "util.h"
 
-static struct ipc_namespace *clone_ipc_ns(struct ipc_namespace *old_ns)
+struct ipc_namespace *create_ipc_ns(void)
 {
 	struct ipc_namespace *ns;
 	int err;
@@ -48,14 +48,9 @@ static struct ipc_namespace *clone_ipc_ns(struct ipc_namespace *old_ns)
 
 struct ipc_namespace *copy_ipcs(unsigned long flags, struct ipc_namespace *ns)
 {
-	struct ipc_namespace *new_ns;
-
 	if (!(flags & CLONE_NEWIPC))
 		return get_ipc_ns(ns);
-
-	new_ns = clone_ipc_ns(ns);
-
-	return new_ns;
+	return create_ipc_ns();
 }
 
 /*
