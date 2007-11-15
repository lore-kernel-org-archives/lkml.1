Return-Path: <linux-kernel-owner+w=401wt.eu-S1759311AbXKOGL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311AbXKOGL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbXKOGKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:10:32 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36470 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbXKOGK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:10:28 -0500
Date: Wed, 14 Nov 2007 22:09:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "George G. Davis" <gdavis@mvista.com>,
       linux-fsdevel@vger.kernel.org,
       "J. Bruce Fields" <bfields@citi.umich.edu>, Alan Cox <alan@redhat.com>
Subject: [patch 02/13] locks: fix possible infinite loop in posix deadlock
	detection
Message-ID: <20071115060921.GC7602@kroah.com>
References: <20071115042610.731859958@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="locks-fix-possible-infinite-loop-in-posix-deadlock-detection.patch"
In-Reply-To: <20071115060544.GA7602@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: J. Bruce Fields <bfields@citi.umich.edu>

patch 97855b49b6bac0bd25f16b017883634d13591d00 in mainline.

It's currently possible to send posix_locks_deadlock() into an infinite
loop (under the BKL).

For now, fix this just by bailing out after a few iterations.  We may
want to fix this in a way that better clarifies the semantics of
deadlock detection.  But that will take more time, and this minimal fix
is probably adequate for any realistic scenario, and is simple enough to
be appropriate for applying to stable kernels now.

Thanks to George Davis for reporting the problem.

Cc: "George G. Davis" <gdavis@mvista.com>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/locks.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/locks.c
+++ b/fs/locks.c
@@ -694,11 +694,20 @@ EXPORT_SYMBOL(posix_test_lock);
  * Note: the above assumption may not be true when handling lock requests
  * from a broken NFS client. But broken NFS clients have a lot more to
  * worry about than proper deadlock detection anyway... --okir
+ *
+ * However, the failure of this assumption (also possible in the case of
+ * multiple tasks sharing the same open file table) also means there's no
+ * guarantee that the loop below will terminate.  As a hack, we give up
+ * after a few iterations.
  */
+
+#define MAX_DEADLK_ITERATIONS 10
+
 static int posix_locks_deadlock(struct file_lock *caller_fl,
 				struct file_lock *block_fl)
 {
 	struct list_head *tmp;
+	int i = 0;
 
 next_task:
 	if (posix_same_owner(caller_fl, block_fl))
@@ -706,6 +715,8 @@ next_task:
 	list_for_each(tmp, &blocked_list) {
 		struct file_lock *fl = list_entry(tmp, struct file_lock, fl_link);
 		if (posix_same_owner(fl, block_fl)) {
+			if (i++ > MAX_DEADLK_ITERATIONS)
+				return 0;
 			fl = fl->fl_next;
 			block_fl = fl;
 			goto next_task;

-- 
