Return-Path: <linux-kernel-owner+w=401wt.eu-S1760643AbXJQSwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760643AbXJQSwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 14:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755207AbXJQSv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 14:51:59 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:12230 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbXJQSv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 14:51:58 -0400
Date: Wed, 17 Oct 2007 14:51:57 -0400
From: "George G. Davis" <gdavis@mvista.com>
To: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] Fix hang in posix_locks_deadlock()
Message-ID: <20071017185157.GC3785@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Armin Kuster <AKuster@mvista.com>

We have observed hangs in posix_locks_deadlock() when multiple threads
use fcntl(2) F_SETLKW to synchronize file accesses.  The problem appears
to be due to an error in the implementation of posix_locks_deadlock() in
which "goto next_task" is used to break out of the list_for_each_entry()
file_lock search after which the posix_same_owner(caller_fl, block_fl)
test may evaluate to false and the list_for_each_entry() loop restarts
all over again.  This in turn leads to a hang where posix_locks_deadlock()
never returns.  The workaround is to change the posix_same_owner()
test within the list_for_each_entry() loop to directly compare caller_fl
against current fl entry.


Signed-off-by: Armin Kuster <AKuster@mvista.com>
Signed-off-by: George G. Davis <gdavis@mvista.com>

---
Not sure if this is the correct fix but it does resolve the hangs we're
observing in posix_locks_deadlock().  Comments greatly appreciated...

diff --git a/fs/locks.c b/fs/locks.c
index 7f9a3ea..7669a0c 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -702,14 +702,11 @@ static int posix_locks_deadlock(struct file_lock *caller_fl,
 {
 	struct file_lock *fl;
 
-next_task:
 	if (posix_same_owner(caller_fl, block_fl))
 		return 1;
 	list_for_each_entry(fl, &blocked_list, fl_link) {
-		if (posix_same_owner(fl, block_fl)) {
-			fl = fl->fl_next;
-			block_fl = fl;
-			goto next_task;
+		if (posix_same_owner(fl, caller_fl)) {
+ 			return 1;
 		}
 	}
 	return 0;

-- 
Regards,
George
