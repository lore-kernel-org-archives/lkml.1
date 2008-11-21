Return-Path: <linux-kernel-owner+w=401wt.eu-S1756461AbYKUIyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461AbYKUIyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbYKUIwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:52:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49400 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753182AbYKUIwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:52:39 -0500
Message-ID: <4926761B.2060608@cn.fujitsu.com>
Date: Fri, 21 Nov 2008 16:49:31 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] cgroups: defer free css_set
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


we free css_set when refcnt became 0 immediately(except cgroup_attach_task()).
I will destroy the data which read side maybe still access it.
this patch use call_rcu() to defer free css_set

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 1164963..22901ff 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -178,6 +178,8 @@ struct css_set {
 	 */
 	struct list_head cg_links;
 
+	struct rcu_head rcu;
+
 	/*
 	 * Set of subsystem states, one for each subsystem. This array
 	 * is immutable after creation apart from the init_css_set
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 358e775..ddc10ac 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -252,6 +252,11 @@ static void unlink_css_set(struct css_set *cg)
 	}
 }
 
+static void rcu_free_css_set(struct rcu_head *head)
+{
+	kfree(container_of(head, struct css_set, rcu));
+}
+
 static void __put_css_set(struct css_set *cg, int taskexit)
 {
 	int i;
@@ -281,7 +286,7 @@ static void __put_css_set(struct css_set *cg, int taskexit)
 		}
 	}
 	rcu_read_unlock();
-	kfree(cg);
+	call_rcu(&cg->rcu, rcu_free_css_set);
 }
 
 /*
@@ -1267,7 +1277,6 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 			ss->attach(ss, cgrp, oldcgrp, tsk);
 	}
 	set_bit(CGRP_RELEASABLE, &oldcgrp->flags);
-	synchronize_rcu();
 	put_css_set(cg);
 	return 0;
 }

