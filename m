Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbZGJXCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbZGJXCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 19:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757995AbZGJXCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 19:02:25 -0400
Received: from smtp-out.google.com ([216.239.33.17]:3548 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758019AbZGJXCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 19:02:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=peNr486M/ZqJvj1Y0Fbly1TsMCd/YHRPAKXvBMmEDnLRhfnkSJTJP/bsnqXMe3BtK
	1zvGjIyoszvH/x33po1NQ==
From: Ben Blum <bblum@google.com>
Subject: [PATCH 3/3] Quick vmalloc vs kmalloc fix to the case where array size
	is too large
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, serue@us.ibm.com, lizf@cn.fujitsu.com,
       menage@google.com
Date: Fri, 10 Jul 2009 16:02:05 -0700
Message-ID: <20090710230205.16778.11707.stgit@hastromil.mtv.corp.google.com>
In-Reply-To: <20090710230043.16778.29656.stgit@hastromil.mtv.corp.google.com>
References: <20090710230043.16778.29656.stgit@hastromil.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
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

 kernel/cgroup.c |   34 ++++++++++++++++++++++++++++------
 1 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 33d89be..0ed85fa 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -48,6 +48,7 @@
 #include <linux/namei.h>
 #include <linux/smp_lock.h>
 #include <linux/pid_namespace.h>
+#include <linux/vmalloc.h> /* TODO: replace with more sophisticated array */
 
 #include <asm/atomic.h>
 
@@ -2121,6 +2122,27 @@ int cgroup_scan_tasks(struct cgroup_scanner *scan)
  */
 
 /*
+ * The following two functions "fix" the issue where there are more pids
+ * than kmalloc will give memory for; in such cases, we use vmalloc/vfree.
+ * TODO: replace with a kernel-wide solution to this problem
+ */
+#define PIDLIST_TOO_LARGE(c) ((c) * sizeof(pid_t) > (PAGE_SIZE * 2))
+static inline void *pidlist_allocate(int count)
+{
+	if (PIDLIST_TOO_LARGE(count))
+		return vmalloc(count * sizeof(pid_t));
+	else
+		return kmalloc(count * sizeof(pid_t), GFP_KERNEL);
+}
+static inline void pidlist_free(void *p)
+{
+	if (is_vmalloc_addr(p))
+		vfree(p);
+	else
+		kfree(p);
+}
+
+/*
  * pidlist_uniq - given a kmalloc()ed list, strip out all duplicate entries
  * If the new stripped list is sufficiently smaller and there's enough memory
  * to allocate a new buffer, will let go of the unneeded memory. Returns the
@@ -2160,10 +2182,10 @@ static int pidlist_uniq(pid_t **p, int length)
 	 * we'll just stay with what we've got.
 	 */
 	if (PIDLIST_REALLOC_DIFFERENCE(length, dest)) {
-		newlist = kmalloc(dest * sizeof(pid_t), GFP_KERNEL);
+		newlist = pidlist_allocate(dest);
 		if (newlist) {
 			memcpy(newlist, list, dest * sizeof(pid_t));
-			kfree(list);
+			pidlist_free(list);
 			*p = newlist;
 		}
 	}
@@ -2243,7 +2265,7 @@ static int pidlist_array_load(struct cgroup *cgrp, enum cgroup_filetype type,
 	 * show up until sometime later on.
 	 */
 	length = cgroup_task_count(cgrp);
-	array = kmalloc(length * sizeof(pid_t), GFP_KERNEL);
+	array = pidlist_allocate(length);
 	if (!array)
 		return -ENOMEM;
 	/* now, populate the array */
@@ -2268,11 +2290,11 @@ static int pidlist_array_load(struct cgroup *cgrp, enum cgroup_filetype type,
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
@@ -2433,7 +2455,7 @@ static void cgroup_release_pid_array(struct cgroup_pidlist *l)
 		/* we're the last user if refcount is 0; remove and free */
 		list_del(&l->links);
 		mutex_unlock(&l->owner->pidlist_mutex);
-		kfree(l->list);
+		pidlist_free(l->list);
 		put_pid_ns(l->key.ns);
 		up_write(&l->mutex);
 		kfree(l);

