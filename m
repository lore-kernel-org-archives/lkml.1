Return-Path: <linux-kernel-owner+w=401wt.eu-S1760845AbYHEN4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760845AbYHEN4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 09:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758035AbYHEN4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 09:56:31 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:38299 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbYHEN4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 09:56:30 -0400
Date: Tue, 5 Aug 2008 07:55:59 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] Make kthread_stop() not oops when passed a bad pointer
Message-ID: <20080805135559.GQ26461@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Due to some botched error handling code in a driver I was writing, I
recently called kthread_stop(NULL).  It's terribly exciting to discover
that you've just oopsed while holding a mutex that's required in order
to shut down.  Make kthread_stop a little more robust against numbskulls
like me.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 96cff2f..06c3477 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -201,6 +201,9 @@ int kthread_stop(struct task_struct *k)
 {
 	int ret;
 
+	if (!k || IS_ERR(k))
+		return -EINVAL;
+
 	mutex_lock(&kthread_stop_lock);
 
 	/* It could exit after stop_info.k set, but before wake_up_process. */
-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
