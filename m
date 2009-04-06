Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbZDFQ5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbZDFQ5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 12:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbZDFQ5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 12:57:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55492 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbZDFQ5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 12:57:13 -0400
Date: Mon, 6 Apr 2009 18:52:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] ptrace: fix exit_ptrace() vs ptrace_traceme() race
Message-ID: <20090406165238.GA25710@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pointed out by Roland. The bug was recently introduced by me in
"forget_original_parent: split out the un-ptrace part", commit
39c626ae47c469abdfd30c6e42eff884931380d6.

Since that patch we have a window after exit_ptrace() drops tasklist
and before forget_original_parent() takes it again. In this window
the child can do ptrace(PTRACE_TRACEME) and nobody can untrace this
child after that.

Change ptrace_traceme() to not attach to the exiting ->real_parent.
We don't report the error in this case, we pretend we attach right
before ->real_parent calls exit_ptrace() which should untrace us
anyway.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.30/kernel/ptrace.c~TRACEME	2009-04-06 00:03:42.000000000 +0200
+++ 6.30/kernel/ptrace.c	2009-04-06 18:25:53.000000000 +0200
@@ -606,10 +606,11 @@ repeat:
 		ret = security_ptrace_traceme(current->parent);
 
 		/*
-		 * Set the ptrace bit in the process ptrace flags.
-		 * Then link us on our parent's ptraced list.
+		 * Check PF_EXITING to ensure ->real_parent has not passed
+		 * exit_ptrace(). Otherwise we don't report the error but
+		 * pretend ->real_parent untraces us right after return.
 		 */
-		if (!ret) {
+		if (!ret && !(current->real_parent->flags & PF_EXITING)) {
 			current->ptrace |= PT_PTRACED;
 			__ptrace_link(current, current->real_parent);
 		}

