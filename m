Return-Path: <linux-kernel-owner+w=401wt.eu-S1753255AbZFBUoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbZFBUoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 16:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbZFBUoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 16:44:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52415 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbZFBUoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 16:44:00 -0400
Date: Tue, 2 Jun 2009 22:39:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH for 2.6.30] ptrace: revert "ptrace_detach: the wrong wakeup
	breaks the ERESTARTxxx logic"
Message-ID: <20090602203939.GA13939@redhat.com>
References: <20090529103017.D548FFC2BD@magilla.sf.frob.com> <20090529125405.GD19812@redhat.com> <20090529143049.GA27424@redhat.com> <20090530202313.GA12066@host0.dyn.jankratochvil.net> <20090530234449.GA31604@redhat.com> <20090601014258.E3EA2FC3C7@magilla.sf.frob.com> <20090602011318.GA2461@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602011318.GA2461@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 95a3540da9c81a5987be810e1d9a83640a366bd5 removed the "extra"
wake_up_process() from ptrace_detach(), but as Jan pointed out this breaks
the compatibility.

I believe the changelog is right and this wake_up() is wrong in many ways.
But GDB assumes that ptrace(PTRACE_DETACH, child, 0, 0) always wakes up the
tracee. Despite the fact this breaks SIGNAL_STOP_STOPPED/group_stop_count logic,
and despite the fact this wake_up_process() can break another assumption:
PTRACE_DETACH with SIGSTOP should leave the tracee in TASK_STOPPED case.
Because the untraced child can dequeue SIGSTOP and call do_signal_stop()
before ptrace_detach() calls wake_up_process().

Revert this change for now. We need some fixes even if we we want to keep
the current behaviour, but these fixes are not for 2.6.30.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -304,6 +304,8 @@ int ptrace_detach(struct task_struct *ch
 	if (child->ptrace) {
 		child->exit_code = data;
 		dead = __ptrace_detach(current, child);
+		if (!child->exit_state)
+			wake_up_process(child);
 	}
 	write_unlock_irq(&tasklist_lock);
 

