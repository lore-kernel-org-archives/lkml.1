Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbZGXDWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbZGXDWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 23:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbZGXDWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 23:22:11 -0400
Received: from smtp-out.google.com ([216.239.33.17]:5194 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZGXDWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 23:22:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:content-transfer-encoding;
	b=luaA4IztG22RYaQynzAHSq/9cese3Klfix6hmDJN3f4/jr7t8DYO8K/bsFUMZFCFT
	VzZ4Rmg343jqqw3HP7omw==
From: Ben Blum <bblum@google.com>
Subject: [PATCH 3/6] Quick vmalloc vs kmalloc fix to the case where array size
	is too large
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, serue@us.ibm.com, lizf@cn.fujitsu.com,
       menage@google.com, bblum@google.com
Date: Thu, 23 Jul 2009 20:21:50 -0700
Message-ID: <20090724032150.2463.49019.stgit@hastromil.mtv.corp.google.com>
In-Reply-To: <20090724032033.2463.79256.stgit@hastromil.mtv.corp.google.com>
References: <20090724032033.2463.79256.stgit@hastromil.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quick vmalloc vs kmalloc fix to the case where array size is too large

Separates all pidlist allocation requests to a separate function that judges
based on the requested size whether or not the array needs to be vmalloced or
can be gotten via kmalloc, and similar for kfree/vfree. Should be replaced
entirely with a kernel-wide solution to this general problem.

Depends on cgroup-pidlist-namespace.patch, cgroup-procs.patch

Signed-off-by: Ben Blum <bblum@google.com>

---

 kernel/cgroup.c |   47 ++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b3773a5..7e6b183 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -48,6 +48,7 @@
 #include <linux/namei.h>
 #include <linux/smp_lock.h>
 #include <linux/pid_namespace.h>
+#include <linux/vmalloc.h> /* TODO: replace with more sophisticated array */
 
 #include <asm/atomic.h>
 
@@ -2123,6 +2124,42 @@ int cgroup_scan_tasks(struct cgroup_scanner *scan)
  */
 
 /*
+ * The following two functions "fix" the issue where there are more pids
+ * than kmalloc will give memory for; in such cases, we use vmalloc/vfree.
+ * TODO: replace with a kernel-wide solution to this problem
+ */
+#define PIDLIST_TOO_LARGE(c) ((c) * sizeof(pid_t) > (PAGE_SIZE * 2))
+static void *pidlist_allocate(int count)
+{
+	if (PIDLIST_TOO_LARGE(count))
+		return vmalloc(count * sizeof(pid_t));
+	else
+		return kmalloc(count * sizeof(pid_t), GFP_KERNEL);
+}
+static void pidlist_free(void *p)
+{
+	if (is_vmalloc_addr(p))
+		vfree(p);
+	else
+		kfree(p);
+}
+static void *pidlist_resize(void *p, int newcount)
+{
+	void *newlist;
+	/* note: if new alloc fails, old p will still be valid either way */
+	if (is_vmalloc_addr(p)) {
+		newlist = vmalloc(newcount * sizeof(pid_t));
+		if (!newlist)
+			return NULL;
+		memcpy(newlist, p, newcount * sizeof(pid_t));
+		vfree(p);
+	} else {
+		newlist = krealloc(p, newcount * sizeof(pid_t), GFP_KERNEL);
+	}
+	return newlist;
+}
+
+/*
  * pidlist_uniq - given a kmalloc()ed list, strip out all duplicate entries
  * If the new stripped list is sufficiently smaller and there's enough memory
  * to allocate a new buffer, will let go of the unneeded memory. Returns the
@@ -2161,7 +2198,7 @@ after:
 	 * we'll just stay with what we've got.
 	 */
 	if (PIDLIST_REALLOC_DIFFERENCE(length, dest)) {
-		newlist = krealloc(list, dest * sizeof(pid_t), GFP_KERNEL);
+		newlist = pidlist_resize(list, dest);
 		if (newlist)
 			*p = newlist;
 	}
@@ -2242,7 +2279,7 @@ static int pidlist_array_load(struct cgroup *cgrp, enum cgroup_filetype type,
 	 * show up until sometime later on.
 	 */
 	length = cgroup_task_count(cgrp);
-	array = kmalloc(length * sizeof(pid_t), GFP_KERNEL);
+	array = pidlist_allocate(length);
 	if (!array)
 		return -ENOMEM;
 	/* now, populate the array */
@@ -2267,11 +2304,11 @@ static int pidlist_array_load(struct cgroup *cgrp, enum cgroup_filetype type,
 	}
 	l = cgroup_pidlist_find(cgrp, type);
 	if (!l) {
-		kfree(array);
+		pidlist_free(array);
 		return -ENOMEM;
 	}
 	/* store array, freeing old if necessary - lock already held */
-	kfree(l->list);
+	pidlist_free(l->list);
 	l->list = array;
 	l->length = length;
 	l->use_count++;
@@ -2432,7 +2469,7 @@ static void cgroup_release_pid_array(struct cgroup_pidlist *l)
 		/* we're the last user if refcount is 0; remove and free */
 		list_del(&l->links);
 		mutex_unlock(&l->owner->pidlist_mutex);
-		kfree(l->list);
+		pidlist_free(l->list);
 		put_pid_ns(l->key.ns);
 		up_write(&l->mutex);
 		kfree(l);

