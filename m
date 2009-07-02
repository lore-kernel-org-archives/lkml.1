Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbZGBCMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbZGBCMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 22:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755389AbZGBCLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 22:11:34 -0400
Received: from smtp-out.google.com ([216.239.45.13]:20739 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367AbZGBCLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 22:11:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=k1wRpJB0K6/Y+TaLMnzGWzIS1gPWItUK9On8lGuTObREafNS7Ttm/YDDTXXZimZTU
	gGxRUADCilMpxL9j7krmg==
From: Paul Menage <menage@google.com>
Subject: [PATCH 6/9] [RFC] Remove the cgroup_subsys.bind callback
To: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com
Date: Wed, 01 Jul 2009 19:11:23 -0700
Message-ID: <20090702021123.14469.90837.stgit@menage.mtv.corp.google.com>
In-Reply-To: <20090702020624.14469.47066.stgit@menage.mtv.corp.google.com>
References: <20090702020624.14469.47066.stgit@menage.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[RFC] Remove the cgroup_subsys.bind callback

In preparation for supporting cgroup subsystems that can be bound to
multiple hierarchies, remove the "bind" callback. It's not currently
used by any in-tree subsystem and its semantics become fuzzy for
multi-bindable subsystems.  It can be re-added with clearer semantics
in the future if necessary.

Signed-off-by: Paul Menage <menage@google.com>

---

 Documentation/cgroups/cgroups.txt |    8 --------
 include/linux/cgroup.h            |    1 -
 kernel/cgroup.c                   |    4 ----
 3 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index 6eb1a97..d5be8ae 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -544,14 +544,6 @@ initialization which might be required before a task could attach.  For
 example in cpusets, no task may attach before 'cpus' and 'mems' are set
 up.
 
-void bind(struct cgroup_subsys *ss, struct cgroup *root)
-(cgroup_mutex and ss->hierarchy_mutex held by caller)
-
-Called when a cgroup subsystem is rebound to a different hierarchy
-and root cgroup. Currently this will only involve movement between
-the default hierarchy (which never has sub-cgroups) and a hierarchy
-that is being created/destroyed (and hence has no sub-cgroups).
-
 4. Questions
 ============
 
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index adf6739..a6bb0ca 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -386,7 +386,6 @@ struct cgroup_subsys {
 	int (*populate)(struct cgroup_subsys *ss,
 			struct cgroup *cgrp);
 	void (*post_clone)(struct cgroup_subsys *ss, struct cgroup *cgrp);
-	void (*bind)(struct cgroup_subsys *ss, struct cgroup *root);
 
 	int subsys_id;
 	int active;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 8b1b92f..74840ea 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -897,8 +897,6 @@ static int rebind_subsystems(struct cgroupfs_root *root,
 			mutex_lock(&ss->hierarchy_mutex);
 			cgrp->subsys[i] = dummytop->subsys[i];
 			cgrp->subsys[i]->cgroup = cgrp;
-			if (ss->bind)
-				ss->bind(ss, cgrp);
 			rootnode.subsys_bits &= ~bit;
 			root->subsys_bits |= bit;
 			mutex_unlock(&ss->hierarchy_mutex);
@@ -908,8 +906,6 @@ static int rebind_subsystems(struct cgroupfs_root *root,
 			BUG_ON(cgrp->subsys[i]->cgroup != cgrp);
 			BUG_ON(rootnode.subsys_bits & bit);
 			mutex_lock(&ss->hierarchy_mutex);
-			if (ss->bind)
-				ss->bind(ss, dummytop);
 			dummytop->subsys[i]->cgroup = dummytop;
 			cgrp->subsys[i] = NULL;
 			root->subsys_bits &= ~bit;

