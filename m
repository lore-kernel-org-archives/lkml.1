Return-Path: <linux-kernel-owner+w=401wt.eu-S1759972AbYBWXbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759972AbYBWXbj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 18:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757499AbYBWX2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 18:28:05 -0500
Received: from smtp-out.google.com ([216.239.33.17]:5187 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757494AbYBWX2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 18:28:03 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:references:user-agent:date:from:to:cc:
	subject:content-disposition;
	b=Oem48ptGMqjiNa51WemBJD3sk6/87yBVtR+BHh9XhenM+8cGW+Z42jThZmnl94f98
	WzyCp1+r4K3rSTpW9YqSQ==
Message-Id: <20080223232618.606225000@menage.corp.google.com>
References: <20080223224725.115590000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Sat, 23 Feb 2008 14:47:34 -0800
From: menage@google.com
To: akpm@linux-foundation.org, balbir@in.ibm.com, pj@sgi.com,
       Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: [PATCH 09/10] CGroup API files: Move "releasable" to cgroup_debug subsystem
Content-Disposition: inline; filename=move_releasable.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "releasable" control file provided by the cgroup framework exports
the state of a per-cgroup flag that's related to the notify-on-release
feature. This isn't really generally useful, unless you're trying to
debug this particular feature of cgroups.

This patch moves the "releasable" file to the cgroup_debug subsystem.

Signed-off-by: Paul Menage <menage@google.com>

---
 include/linux/cgroup.h |   11 +++++++++++
 kernel/cgroup.c        |   23 -----------------------
 kernel/cgroup_debug.c  |   12 +++++++++++-
 3 files changed, 22 insertions(+), 24 deletions(-)

Index: cgroup-2.6.25-rc2-mm1/include/linux/cgroup.h
===================================================================
--- cgroup-2.6.25-rc2-mm1.orig/include/linux/cgroup.h
+++ cgroup-2.6.25-rc2-mm1/include/linux/cgroup.h
@@ -88,6 +88,17 @@ static inline void css_put(struct cgroup
 		__css_put(css);
 }
 
+/* bits in struct cgroup flags field */
+enum {
+	/* Control Group is dead */
+	CGRP_REMOVED,
+	/* Control Group has previously had a child cgroup or a task,
+	 * but no longer (only if CGRP_NOTIFY_ON_RELEASE is set) */
+	CGRP_RELEASABLE,
+	/* Control Group requires release notifications to userspace */
+	CGRP_NOTIFY_ON_RELEASE,
+};
+
 struct cgroup {
 	unsigned long flags;		/* "unsigned long" so bitops work */
 
Index: cgroup-2.6.25-rc2-mm1/kernel/cgroup.c
===================================================================
--- cgroup-2.6.25-rc2-mm1.orig/kernel/cgroup.c
+++ cgroup-2.6.25-rc2-mm1/kernel/cgroup.c
@@ -119,17 +119,6 @@ static int root_count;
  */
 static int need_forkexit_callback;
 
-/* bits in struct cgroup flags field */
-enum {
-	/* Control Group is dead */
-	CGRP_REMOVED,
-	/* Control Group has previously had a child cgroup or a task,
-	 * but no longer (only if CGRP_NOTIFY_ON_RELEASE is set) */
-	CGRP_RELEASABLE,
-	/* Control Group requires release notifications to userspace */
-	CGRP_NOTIFY_ON_RELEASE,
-};
-
 /* convenient tests for these bits */
 inline int cgroup_is_removed(const struct cgroup *cgrp)
 {
@@ -1299,7 +1288,6 @@ enum cgroup_filetype {
 	FILE_DIR,
 	FILE_TASKLIST,
 	FILE_NOTIFY_ON_RELEASE,
-	FILE_RELEASABLE,
 	FILE_RELEASE_AGENT,
 };
 
@@ -2169,11 +2157,6 @@ static u64 cgroup_read_notify_on_release
 	return notify_on_release(cgrp);
 }
 
-static u64 cgroup_read_releasable(struct cgroup *cgrp, struct cftype *cft)
-{
-	return test_bit(CGRP_RELEASABLE, &cgrp->flags);
-}
-
 /*
  * for the common functions, 'private' gives the type of file
  */
@@ -2193,12 +2176,6 @@ static struct cftype files[] = {
 		.write = cgroup_common_file_write,
 		.private = FILE_NOTIFY_ON_RELEASE,
 	},
-
-	{
-		.name = "releasable",
-		.read_u64 = cgroup_read_releasable,
-		.private = FILE_RELEASABLE,
-	}
 };
 
 static struct cftype cft_release_agent = {
Index: cgroup-2.6.25-rc2-mm1/kernel/cgroup_debug.c
===================================================================
--- cgroup-2.6.25-rc2-mm1.orig/kernel/cgroup_debug.c
+++ cgroup-2.6.25-rc2-mm1/kernel/cgroup_debug.c
@@ -1,5 +1,5 @@
 /*
- * kernel/ccontainer_debug.c - Example cgroup subsystem that
+ * kernel/cgroup_debug.c - Example cgroup subsystem that
  * exposes debug info
  *
  * Copyright (C) Google Inc, 2007
@@ -62,6 +62,11 @@ static u64 current_css_set_refcount_read
 	return count;
 }
 
+static u64 releasable_read(struct cgroup *cgrp, struct cftype *cft)
+{
+	return test_bit(CGRP_RELEASABLE, &cgrp->flags);
+}
+
 static struct cftype files[] =  {
 	{
 		.name = "cgroup_refcount",
@@ -81,6 +86,11 @@ static struct cftype files[] =  {
 		.name = "current_css_set_refcount",
 		.read_u64 = current_css_set_refcount_read,
 	},
+
+	{
+		.name = "releasable",
+		.read_u64 = releasable_read,
+	}
 };
 
 static int debug_populate(struct cgroup_subsys *ss, struct cgroup *cont)

--
