Return-Path: <linux-kernel-owner+w=401wt.eu-S1757276AbZA2IIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276AbZA2IIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 03:08:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbZA2IIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 03:08:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45854 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbZA2IIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 03:08:34 -0500
Date: Thu, 29 Jan 2009 09:05:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] reparent_thread: fix the "is it traced" check
Message-ID: <20090129080558.GA26871@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reparent_thread() uses ptrace_reparented() to check whether this thread
is ptraced, in that case we should not notify the new parent.

But ptrace_reparented() is not exactly correct when the reparented thread
is traced by /sbin/init, because forget_original_parent() has already
changed ->real_parent.

Currently, the only problem is the false notification. But with the next
patch the kernel crash in this (yes, pathological) case.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29-rc3/kernel/exit.c~6_FIX_PTRACE_CHECK	2009-01-29 06:21:51.000000000 +0100
+++ 6.29-rc3/kernel/exit.c	2009-01-29 06:57:09.000000000 +0100
@@ -826,7 +826,7 @@ static void reparent_thread(struct task_
 	/* If we'd notified the old parent about this child's death,
 	 * also notify the new parent.
 	 */
-	if (!ptrace_reparented(p) &&
+	if (!p->ptrace &&
 	    p->exit_state == EXIT_ZOMBIE && thread_group_empty(p))
 		do_notify_parent(p, p->exit_signal);
 

