Return-Path: <linux-kernel-owner+w=401wt.eu-S1755690AbYL2D67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbYL2D67 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 22:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbYL2D6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 22:58:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59457 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752242AbYL2D61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 22:58:27 -0500
Message-ID: <49584AA2.4010506@cn.fujitsu.com>
Date: Mon, 29 Dec 2008 11:57:22 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Thomas Graf <tgraf@suug.ch>, LKML <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: [PATCH 2/3] cls_cgroup: clean up for cgroup part
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- It's better to use container_of() instead of casting cgroup_subsys_state *
  to cgroup_cls_state *.
- Add helper function task_cls_state().
- Rename net_cls_state() to cgrp_cls_state().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 net/sched/cls_cgroup.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/sched/cls_cgroup.c b/net/sched/cls_cgroup.c
index 31d95b1..40e1411 100644
--- a/net/sched/cls_cgroup.c
+++ b/net/sched/cls_cgroup.c
@@ -24,10 +24,16 @@ struct cgroup_cls_state
 	u32 classid;
 };
 
-static inline struct cgroup_cls_state *net_cls_state(struct cgroup *cgrp)
+static inline struct cgroup_cls_state *cgrp_cls_state(struct cgroup *cgrp)
 {
-	return (struct cgroup_cls_state *)
-		cgroup_subsys_state(cgrp, net_cls_subsys_id);
+	return container_of(cgroup_subsys_state(cgrp, net_cls_subsys_id),
+			    struct cgroup_cls_state, css);
+}
+
+static inline struct cgroup_cls_state *task_cls_state(struct task_struct *p)
+{
+	return container_of(task_subsys_state(p, net_cls_subsys_id),
+			    struct cgroup_cls_state, css);
 }
 
 static struct cgroup_subsys_state *cgrp_create(struct cgroup_subsys *ss,
@@ -39,19 +45,19 @@ static struct cgroup_subsys_state *cgrp_create(struct cgroup_subsys *ss,
 		return ERR_PTR(-ENOMEM);
 
 	if (cgrp->parent)
-		cs->classid = net_cls_state(cgrp->parent)->classid;
+		cs->classid = cgrp_cls_state(cgrp->parent)->classid;
 
 	return &cs->css;
 }
 
 static void cgrp_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
-	kfree(net_cls_state(cgrp));
+	kfree(cgrp_cls_state(cgrp));
 }
 
 static u64 read_classid(struct cgroup *cgrp, struct cftype *cft)
 {
-	return net_cls_state(cgrp)->classid;
+	return cgrp_cls_state(cgrp)->classid;
 }
 
 static int write_classid(struct cgroup *cgrp, struct cftype *cft, u64 value)
@@ -115,8 +121,7 @@ static int cls_cgroup_classify(struct sk_buff *skb, struct tcf_proto *tp,
 		return -1;
 
 	rcu_read_lock();
-	cs = (struct cgroup_cls_state *) task_subsys_state(current,
-							   net_cls_subsys_id);
+	cs = task_cls_state(current);
 	if (cs->classid && tcf_em_tree_match(skb, &head->ematches, NULL)) {
 		res->classid = cs->classid;
 		res->class = 0;
-- 
1.5.4.rc3
