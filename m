Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbZBWDeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbZBWDeg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 22:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbZBWDe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 22:34:28 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:56215 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbZBWDe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 22:34:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:cc:date:subject:mime-version:content-type
         :content-transfer-encoding;
        b=XVVaRru2EBREqShmbihi4NjJT7HfgjDgC0/1PnUNwmuf8wGpRVOUQFBz415PKPR3bl
         hlL5173BsWDZmrXVTi9L4e+2+40ASe7FBxznhjg5Z+9nzZ75hHy68Kesv1g/Tx89mX5w
         LgWn8AnfdbSByEJK0uu6GUqG95JlQAc5ZRLKw=
Message-ID: <49a21941.0a04d00a.5f94.1245@mx.google.com>
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 23 Feb 2009 04:31:22 +0100
Subject: [PATCH] rt: fix a build error on locking-selftest.c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a build error while rt mutexes selftests:

lib/locking-selftest.c: In function ‘dotest’:
lib/locking-selftest.c:951: erreur: incompatible types in initialization
lib/locking-selftest.c:1003: erreur: incompatible types in assignment

lock_count is of type atomic_t.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 lib/locking-selftest.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index 0732078..9520632 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -948,7 +948,7 @@ static void dotest(void (*testcase_fn)(void), int expected, int lockclass_mask)
 	unsigned long saved_preempt_count = preempt_count();
 	int expected_failure = 0;
 #if defined(CONFIG_DEBUG_PREEMPT) && defined(CONFIG_DEBUG_RT_MUTEXES)
-        int saved_lock_count = current->lock_count;
+        int saved_lock_count = atomic_read(&current->lock_count);
 #endif
 
 	WARN_ON(irqs_disabled());
@@ -1000,7 +1000,7 @@ static void dotest(void (*testcase_fn)(void), int expected, int lockclass_mask)
 
 	reset_locks();
 #if defined(CONFIG_DEBUG_PREEMPT) && defined(CONFIG_DEBUG_RT_MUTEXES)
-        current->lock_count = saved_lock_count;
+        atomic_set(&current->lock_count, saved_lock_count);
 #endif
 }
 
-- 
1.6.1


