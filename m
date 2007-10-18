Return-Path: <linux-kernel-owner+w=401wt.eu-S1762897AbXJRS6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762897AbXJRS6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 14:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758824AbXJRS6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 14:58:05 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:31604 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758796AbXJRS6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 14:58:04 -0400
Date: Thu, 18 Oct 2007 14:57:59 -0400
From: "George G. Davis" <gdavis@mvista.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Fix hang in posix_locks_deadlock()
Message-ID: <20071018185759.GU3785@mvista.com>
References: <20071017185157.GC3785@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017185157.GC3785@mvista.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 02:51:57PM -0400, George G. Davis wrote:
> ---
> Not sure if this is the correct fix but it does resolve the hangs we're
> observing in posix_locks_deadlock().

Please disregard the previous patch, it's not quite right - causes occasional
segfaults and clearly did not retain the posix_same_owner() checks implemented
in the original code.  Here's a new version which I believe retains the
intent of the original code:

diff --git a/fs/locks.c b/fs/locks.c
index 7f9a3ea..e012b27 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -702,14 +702,12 @@ static int posix_locks_deadlock(struct file_lock *caller_fl,
 {
 	struct file_lock *fl;
 
-next_task:
 	if (posix_same_owner(caller_fl, block_fl))
 		return 1;
 	list_for_each_entry(fl, &blocked_list, fl_link) {
 		if (posix_same_owner(fl, block_fl)) {
-			fl = fl->fl_next;
-			block_fl = fl;
-			goto next_task;
+			if (posix_same_owner(caller_fl, fl))
+				return 1;
 		}
 	}
 	return 0;


I'm not sure about those "fl = fl->fl_next; block_fl = fl;" statements,
first, the order of those statements seems reversed to me.  Otherwise,
I think the intent was to advance the "fl" for loop variable to the next
entry in the list but it doesn't work out that way at all - the for
loop restarts from the beginning - this is where we get into an
infinite loop condition.  Whether the test case I posted before is
valid or not, I reckon it shouldn't be possible for non-root Joe user
to contrive a test case which can hang the system as we're observing
with that test case.  The above patch fixes the hang.

Comments greatly appreciated...

-- 
Regards,
George
