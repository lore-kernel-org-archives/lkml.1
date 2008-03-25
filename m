Return-Path: <linux-kernel-owner+w=401wt.eu-S1756519AbYCYOcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbYCYOcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 10:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754489AbYCYOb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 10:31:59 -0400
Received: from styx.suse.cz ([82.119.242.94]:40848 "EHLO elijah.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753797AbYCYOb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:31:59 -0400
Subject: [PATCH] Discard notification signals when a tracer exits
From: Petr Tesarik <ptesarik@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@tv-sign.ru>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: SuSE CR
Date: Tue, 25 Mar 2008 15:31:53 +0100
Message-Id: <1206455513.17227.4.camel@elijah.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a tracer exits without detaching from the traced process, the
tracee may be at a tracer notification stop and will thus interpret
the value in task->exit_code (SIGTRAP | 0x80) as the signal to be
delivered.

This patch fixes the problem by clearing exit_code when detaching
the traced process from a dying tracer.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>

---
 exit.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -642,8 +642,10 @@ reparent_thread(struct task_struct *p, s
 			/*
 			 * If it was at a trace stop, turn it into
 			 * a normal stop since it's no longer being
-			 * traced.
+			 * traced.  Cancel the notification signal,
+			 * or the tracee may get a SIGTRAP.
 			 */
+			p->exit_code = 0;
 			ptrace_untrace(p);
 		}
 	}
@@ -713,6 +715,10 @@ static void forget_original_parent(struc
 			p->real_parent = reaper;
 			reparent_thread(p, father, 0);
 		} else {
+			/* cancel the notification signal at a trace stop */
+			if (p->state == TASK_TRACED)
+				p->exit_code = 0;
+
 			/* reparent ptraced task to its real parent */
 			__ptrace_unlink (p);
 			if (p->exit_state == EXIT_ZOMBIE && p->exit_signal != -1 &&

