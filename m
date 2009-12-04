Return-Path: <linux-kernel-owner+w=401wt.eu-S1755596AbZLDI5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbZLDI5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 03:57:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbZLDI5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 03:57:32 -0500
Received: from RELAY.ANDREW.CMU.EDU ([128.2.10.212]:38030 "EHLO
	relay.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373AbZLDI5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 03:57:32 -0500
Date: Fri, 4 Dec 2009 03:57:12 -0500
From: Ben Blum <bblum@andrew.cmu.edu>
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       lizf@cn.fujitsu.com, akpm@linux-foundation.org, menage@google.com,
       bblum@andrew.cmu.edu
Cc: netdev@vger.kernel.org
Subject: [RFC] [PATCH 3/5] cgroups: net_cls as module
Message-ID: <20091204085712.GC18912@andrew.cmu.edu>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	containers@lists.linux-foundation.org, lizf@cn.fujitsu.com,
	akpm@linux-foundation.org, menage@google.com,
	netdev@vger.kernel.org
References: <20091204085349.GA18867@andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="cgroups-net_cls-as-module.patch"
In-Reply-To: <20091204085349.GA18867@andrew.cmu.edu>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows the net_cls cgroup subsystem to be compiled as a module

From: Ben Blum <bblum@andrew.cmu.edu>

This patch modifies net/sched/cls_cgroup.c to allow the net_cls subsystem to
be optionally compiled as a module instead of builtin. The cgroup_subsys
struct is moved around a bit to allow the subsys_id to be either declared as a
compile-time constant by the cgroup_subsys.h include in cgroup.h, or, if it's
a module, initialized within the struct by cgroup_load_subsys.

Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>
---

 net/sched/Kconfig      |    5 ++++-
 net/sched/cls_cgroup.c |   37 ++++++++++++++++++++++++++++---------
 2 files changed, 32 insertions(+), 10 deletions(-)


diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index 929218a..08ff9bc 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -328,13 +328,16 @@ config NET_CLS_FLOW
 	  module will be called cls_flow.
 
 config NET_CLS_CGROUP
-	bool "Control Group Classifier"
+	tristate "Control Group Classifier"
 	select NET_CLS
 	depends on CGROUPS
 	---help---
 	  Say Y here if you want to classify packets based on the control
 	  cgroup of their process.
 
+	  To compile this code as a module, choose M here: the
+	  module will be called cls_cgroup.
+
 config NET_EMATCH
 	bool "Extended Matches"
 	select NET_CLS
diff --git a/net/sched/cls_cgroup.c b/net/sched/cls_cgroup.c
index e4877ca..df9723b 100644
--- a/net/sched/cls_cgroup.c
+++ b/net/sched/cls_cgroup.c
@@ -24,6 +24,25 @@ struct cgroup_cls_state
 	u32 classid;
 };
 
+static struct cgroup_subsys_state *cgrp_create(struct cgroup_subsys *ss,
+					       struct cgroup *cgrp);
+static void cgrp_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp);
+static int cgrp_populate(struct cgroup_subsys *ss, struct cgroup *cgrp);
+
+struct cgroup_subsys net_cls_subsys = {
+	.name		= "net_cls",
+	.create		= cgrp_create,
+	.destroy	= cgrp_destroy,
+	.populate	= cgrp_populate,
+#ifdef CONFIG_NET_CLS_CGROUP
+	.subsys_id	= net_cls_subsys_id,
+#else
+#define net_cls_subsys_id net_cls_subsys.subsys_id
+#endif
+	.module		= THIS_MODULE,
+};
+
+
 static inline struct cgroup_cls_state *cgrp_cls_state(struct cgroup *cgrp)
 {
 	return container_of(cgroup_subsys_state(cgrp, net_cls_subsys_id),
@@ -79,14 +98,6 @@ static int cgrp_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
 	return cgroup_add_files(cgrp, ss, ss_files, ARRAY_SIZE(ss_files));
 }
 
-struct cgroup_subsys net_cls_subsys = {
-	.name		= "net_cls",
-	.create		= cgrp_create,
-	.destroy	= cgrp_destroy,
-	.populate	= cgrp_populate,
-	.subsys_id	= net_cls_subsys_id,
-};
-
 struct cls_cgroup_head
 {
 	u32			handle;
@@ -277,12 +288,20 @@ static struct tcf_proto_ops cls_cgroup_ops __read_mostly = {
 
 static int __init init_cgroup_cls(void)
 {
-	return register_tcf_proto_ops(&cls_cgroup_ops);
+	int ret = register_tcf_proto_ops(&cls_cgroup_ops);
+	if (ret)
+		return ret;
+	ret = cgroup_load_subsys(&net_cls_subsys);
+	if (ret)
+		unregister_tcf_proto_ops(&cls_cgroup_ops);
+	return ret;
 }
 
 static void __exit exit_cgroup_cls(void)
 {
 	unregister_tcf_proto_ops(&cls_cgroup_ops);
+	/* TODO: unload subsystem. for now, the try_module_get in load_subsys
+	 * prevents us from getting here. */
 }
 
 module_init(init_cgroup_cls);
