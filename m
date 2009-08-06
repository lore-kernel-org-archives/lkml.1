Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbZHFCxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbZHFCxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 22:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbZHFCxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 22:53:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50076 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbZHFCxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 22:53:01 -0400
Message-Id: <20090806025300.651647545@goodmis.org>
References: <20090806025206.306150861@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 05 Aug 2009 22:52:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Matt Fleming <mjf@gentoo.org>,
       Dave Airlie <airlied@gmail.com>
Subject: [PATCH 2/3] ring-buffer: do not disable ring buffer on oops_in_progress
Content-Disposition: inline; filename=0002-ring-buffer-do-not-disable-ring-buffer-on-oops_in_pr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The commit:

  commit e0fdace10e75dac67d906213b780ff1b1a4cc360
  Author: David Miller <davem@davemloft.net>
  Date:   Fri Aug 1 01:11:22 2008 -0700

    debug_locks: set oops_in_progress if we will log messages.

    Otherwise lock debugging messages on runqueue locks can deadlock the
    system due to the wakeups performed by printk().

    Signed-off-by: David S. Miller <davem@davemloft.net>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

Will permanently set oops_in_progress on any lockdep failure.
When this triggers it will cause any read from the ring buffer to
permanently disable the ring buffer (not to mention no locking of
printk).

This patch removes the check. It keeps the print in NMI which makes
sense. This is probably OK, since the ring buffer should not cause
something to set oops_in_progress anyway.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2fd1752..2606cee 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2486,7 +2486,7 @@ static inline int rb_ok_to_lock(void)
 	 * buffer too. A one time deal is all you get from reading
 	 * the ring buffer from an NMI.
 	 */
-	if (likely(!in_nmi() && !oops_in_progress))
+	if (likely(!in_nmi()))
 		return 1;
 
 	tracing_off_permanent();
-- 
1.6.3.3

-- 
