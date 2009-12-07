Return-Path: <linux-kernel-owner+w=401wt.eu-S935499AbZLGRCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935499AbZLGRCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 12:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935424AbZLGRCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 12:02:46 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:44757 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935483AbZLGRCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 12:02:45 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH] SLAB: Fix slab_test.c CONFIG_CPUMASK_OFFSTACK build
Date: Mon,  7 Dec 2009 19:02:43 +0200
Message-Id: <1260205363-6015-1-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell reported the following build breakage:

  Today's linux-next build (x86_64 allmodconfig) failed like this:

  tests/slab_test.c: In function 'test_func':
  tests/slab_test.c:176: error: implicit declaration of function 'set_cpus_allowed'

  Caused by commit 1c999557258d251e2e5790de4b723d5996c06d5d ("Add slab
  performance tests").

  set_cpus_allowed it now only defined if CONFIG_CPUMASK_OFFSTACK is not
  set.  This was changed by commit e0ad955680878998ff7dc51ce06ddad12260423a
  ("cpumask: don't define set_cpus_allowed() if CONFIG_CPUMASK_OFFSTACK=y")
  which entered Linus' tree before 2.6.32-rc1.

Fix that up.

Cc: Christoph Lameter <cl@linux-foundation.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 tests/slab_test.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/tests/slab_test.c b/tests/slab_test.c
index e97afc4..0d23dc1 100644
--- a/tests/slab_test.c
+++ b/tests/slab_test.c
@@ -170,10 +170,13 @@ static int started;
 static int test_func(void *private)
 {
 	struct test_struct *t = private;
-	cpumask_t newmask = CPU_MASK_NONE;
+	cpumask_var_t newmask;
 
-        cpu_set(t->cpu, newmask);
-        set_cpus_allowed(current, newmask);
+	if (!alloc_cpumask_var(&newmask, GFP_KERNEL))
+		return -ENOMEM;
+
+        cpumask_set_cpu(t->cpu, newmask);
+        set_cpus_allowed_ptr(current, newmask);
 	t->v = kzalloc(t->count * sizeof(void *), GFP_KERNEL);
 
 	atomic_inc(&tests_running);
@@ -188,6 +191,7 @@ static int test_func(void *private)
 		t->test_p2(t);
 	t->stop2 = get_cycles();
 	kfree(t->v);
+	free_cpumask_var(newmask);
 	atomic_dec(&tests_running);
 	set_current_state(TASK_UNINTERRUPTIBLE);
 	schedule();
-- 
1.6.3.3

