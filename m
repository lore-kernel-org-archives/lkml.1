Return-Path: <linux-kernel-owner+w=401wt.eu-S1758817AbXERMji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817AbXERMji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 08:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754378AbXERMja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 08:39:30 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:53416 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862AbXERMj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 08:39:29 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Jackson <pj@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 18 May 2007 18:09:16 +0530
Message-Id: <20070518123916.21450.21761.sendpatchset@balbir-laptop>
Subject: [PATCH] Fix a simple issue w.r.t mounting of containers
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Fix containers mounting issue. With the current v9 patches if a container
hierarchy is mounted and then umounted. A second mount of the hierarchy
fails

Steps to reproduce the problem

1. mount -t container container /<mnt point>
2. umount /<mnt point>
3. mount -t container container /<mnt point>

Step 3 fails with -EBUSY. This is due to the fact that when we unmount,
in container_put_super(), we need to delete the current root from the roots
list.

The patch below fixes the issue


Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 kernel/container.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/container.c~fix-remount-issue kernel/container.c
--- linux-2.6.21-mm1/kernel/container.c~fix-remount-issue	2007-05-18 17:59:40.000000000 +0530
+++ linux-2.6.21-mm1-balbir/kernel/container.c	2007-05-18 18:00:02.000000000 +0530
@@ -574,6 +574,7 @@ static void container_put_super(struct s
 	ret = rebind_subsystems(root, 0);
 	BUG_ON(ret);
 
+	list_del(&root->root_list);
 	kfree(root);
 	mutex_unlock(&container_mutex);
 }
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
