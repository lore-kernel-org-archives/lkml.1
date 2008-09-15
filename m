Return-Path: <linux-kernel-owner+w=401wt.eu-S1754064AbYIOFqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbYIOFqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 01:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbYIOFqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 01:46:07 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49478 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbYIOFqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 01:46:06 -0400
Date: Mon, 15 Sep 2008 14:45:27 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [mmotm] build error fix of "fix a race condition of oops_in_progress"
Cc: kosaki.motohiro@jp.fujitsu.com, Huang Ying <ying.huang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Message-Id: <20080915144251.1EEC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

I love CONFIG_DEBUG_MUTEXES.
Could you please pick up following patch?


=====================================
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Patch against: mmotm 09/13
Patch name: fix-a-race-condtion-of-oops_in_progress-fix2.patch
Applied after: fix-a-race-condtion-of-oops_in_progress-fix.patch


if CONFIG_DEBUG_MUTEXES=y, mutex.c makes following build error.
because oops_in_progress was changed from int to atomic_t.

------------------------------------------------------------------
  CC      kernel/mutex.o
kernel/mutex.c: In function '__mutex_lock_common':
kernel/mutex.c:135: error: wrong type argument to unary exclamation mark
kernel/mutex.c:135: error: wrong type argument to unary exclamation mark
kernel/mutex.c:183: error: wrong type argument to unary exclamation mark
kernel/mutex.c:183: error: wrong type argument to unary exclamation mark
kernel/mutex.c: In function '__mutex_unlock_common_slowpath':
kernel/mutex.c:240: error: wrong type argument to unary exclamation mark
kernel/mutex.c:240: error: wrong type argument to unary exclamation mark
kernel/mutex.c: In function '__mutex_trylock_slowpath':
kernel/mutex.c:351: error: wrong type argument to unary exclamation mark
kernel/mutex.c:351: error: wrong type argument to unary exclamation mark
make[1]: *** [kernel/mutex.o] Error 1
make: *** [kernel] Error 2
---------------------------------------------------------------


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Huang Ying <ying.huang@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>

---
 include/linux/debug_locks.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/include/linux/debug_locks.h
===================================================================
--- a/include/linux/debug_locks.h
+++ b/include/linux/debug_locks.h
@@ -17,7 +17,7 @@ extern int debug_locks_off(void);
 ({									\
 	int __ret = 0;							\
 									\
-	if (!oops_in_progress && unlikely(c)) {				\
+	if (!atomic_read(&oops_in_progress) && unlikely(c)) {		\
 		if (debug_locks_off() && !debug_locks_silent)		\
 			WARN_ON(1);					\
 		__ret = 1;						\


