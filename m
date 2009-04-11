Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375AbZDKBRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbZDKBRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 21:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbZDKBR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 21:17:26 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:6563 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347AbZDKBRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 21:17:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dHnOFe9Z0xNrVcLczsTCenXkjHYD7W+zQtmbTMh+EenFe0KC6h/wt+OnteXZCETT58
         cL1n8Ub42RAcBxdCC3eG4oTtf9jAGJLVL8zqmQDMJdrEnOWQsJFY1uTvRzGk5XUri7FI
         m3pc8uniiTS/J9lOwgwAWezZDzwO59oe0EFfA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LTP <ltp-list@lists.sourceforge.net>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>
Subject: [PATCH 2/2 v2] lockdep: continue lock debugging despite some taints
Date: Sat, 11 Apr 2009 03:17:18 +0200
Message-Id: <1239412638-6739-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <20090410134520.GC17878@elte.hu>
References: <20090410134520.GC17878@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lockdep is disabled after any kernel taints. This might be convenient
to ignore bad locking issues which sources come from outside the kernel
tree. Nevertheless, it might be a frustrating experience for the
staging developers or those who experience a warning but are focused
on another things that require lockdep.

The v2 of this patch simply don't disable anymore lockdep in case
of TAINT_CRAP and TAINT_WARN events.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Greg KH <gregkh@suse.de>
---
 kernel/panic.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 940ca14..934fb37 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -217,8 +217,10 @@ void add_taint(unsigned flag)
 	 * Can't trust the integrity of the kernel anymore.
 	 * We don't call directly debug_locks_off() because the issue
 	 * is not necessarily serious enough to set oops_in_progress to 1
+	 * Also we want to keep up lockdep for staging development and
+	 * post-warning case.
 	 */
-	if (__debug_locks_off())
+	if (flag != TAINT_CRAP && flag != TAINT_WARN && __debug_locks_off())
 		printk(KERN_WARNING "Disabling lockdep due to kernel taint\n");
 
 	set_bit(flag, &tainted_mask);
-- 
1.6.1

