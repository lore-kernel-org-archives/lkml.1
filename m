Return-Path: <linux-kernel-owner+w=401wt.eu-S1754463Ab0AMAfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab0AMAfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 19:35:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217Ab0AMAfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 19:35:38 -0500
Received: from UNIX37.ANDREW.CMU.EDU ([128.2.13.167]:54582 "EHLO
	unix37.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab0AMAfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 19:35:01 -0500
X-Greylist: delayed 3553 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jan 2010 19:35:00 EST
Date: Tue, 12 Jan 2010 18:36:30 -0500
From: Ben Blum <bblum@andrew.cmu.edu>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
       axboe@kernel.dk, ryov@valinux.co.jp,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, menage@google.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] cgroups: modular subsystems support for use_id
Message-ID: <20100112233630.GC5098@unix37.andrew.cmu.edu>
References: <20091231051050.GA714@andrew.cmu.edu>
 <20100106160414.bd555474.akpm@linux-foundation.org>
 <20100107012606.GA25577@andrew.cmu.edu>
 <20100107120732.97d502bd.kamezawa.hiroyu@jp.fujitsu.com>
 <4B45824B.9030108@cn.fujitsu.com>
 <20100108163352.GB22219@redhat.com>
 <20100112233453.GB5098@unix37.andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="cgroups-module-use_id-support.patch"
In-Reply-To: <20100112233453.GB5098@unix37.andrew.cmu.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for subsys.use_id in module-loadable subsystems.

From: Ben Blum <bblum@andrew.cmu.edu>

Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>
---
 kernel/cgroup.c |   25 +++++++++++++++++++------
 1 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index cc2e1f6..b4ae6ef 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -240,7 +240,8 @@ struct cg_cgroup_link {
 static struct css_set init_css_set;
 static struct cg_cgroup_link init_css_set_link;
 
-static int cgroup_subsys_init_idr(struct cgroup_subsys *ss);
+static int cgroup_init_idr(struct cgroup_subsys *ss,
+			   struct cgroup_subsys_state *css);
 
 /* css_set_lock protects the list of css_set objects, and the
  * chain of tasks off each css_set.  Nests outside task->alloc_lock
@@ -3396,6 +3397,18 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
 
 	/* our new subsystem will be attached to the dummy hierarchy. */
 	init_cgroup_css(css, ss, dummytop);
+	/* init_idr must be after init_cgroup_css because it sets css->id. */
+	if (ss->use_id) {
+		int ret = cgroup_init_idr(ss, css);
+		if (ret) {
+			dummytop->subsys[ss->subsys_id] = NULL;
+			ss->destroy(ss, dummytop);
+			subsys[i] = NULL;
+			mutex_unlock(&cgroup_mutex);
+			return ret;
+		}
+	}
+
 	/*
 	 * Now we need to entangle the css into the existing css_sets. unlike
 	 * in cgroup_init_subsys, there are now multiple css_sets, so each one
@@ -3484,7 +3497,8 @@ void cgroup_unload_subsys(struct cgroup_subsys *ss)
 	/*
 	 * remove subsystem's css from the dummytop and free it - need to free
 	 * before marking as null because ss->destroy needs the cgrp->subsys
-	 * pointer to find their state.
+	 * pointer to find their state. note that this also takes care of
+	 * freeing the css_id.
 	 */
 	ss->destroy(ss, dummytop);
 	dummytop->subsys[ss->subsys_id] = NULL;
@@ -3563,7 +3577,7 @@ int __init cgroup_init(void)
 		if (!ss->early_init)
 			cgroup_init_subsys(ss);
 		if (ss->use_id)
-			cgroup_subsys_init_idr(ss);
+			cgroup_init_idr(ss, init_css_set.subsys[ss->subsys_id]);
 	}
 
 	/* Add init_css_set to the hash table */
@@ -4231,15 +4245,14 @@ err_out:
 
 }
 
-static int __init cgroup_subsys_init_idr(struct cgroup_subsys *ss)
+static int __init_or_module cgroup_init_idr(struct cgroup_subsys *ss,
+					    struct cgroup_subsys_state *rootcss)
 {
 	struct css_id *newid;
-	struct cgroup_subsys_state *rootcss;
 
 	spin_lock_init(&ss->id_lock);
 	idr_init(&ss->idr);
 
-	rootcss = init_css_set.subsys[ss->subsys_id];
 	newid = get_new_cssid(ss, 0);
 	if (IS_ERR(newid))
 		return PTR_ERR(newid);
