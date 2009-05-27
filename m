Return-Path: <linux-kernel-owner+w=401wt.eu-S1759176AbZE0XKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176AbZE0XKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756311AbZE0XKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:10:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57912 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756289AbZE0XKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:10:03 -0400
Date: Thu, 28 May 2009 01:05:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: ptrace && task->exit_code
Message-ID: <20090527230523.GA10032@redhat.com>
References: <20090525000016.GA2239@redhat.com> <20090525215903.GA9113@redhat.com> <20090527021131.4778BFC36B@magilla.sf.frob.com> <20090527224140.GC6770@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527224140.GC6770@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't realize this until yesterday, but perhaps it makes sense
to decouple ptrace && task_struct->exit_code?

If not - do not read further.

This is not completely trivial, needs another short series.

And. I spent a lot of time, but I can't see how to solve the problems
with TASK_STOPPED tasks if we do this change.

For the moment, forget that ->exit_code is used by do_exit/etc. Suppose
we just move task->exit_code into ptrace_task->xxx.

Now. The never traced task (->ptrace_task == NULL) stops and sleeps in
TASK_STOPPED.

The tracer attaches, and then ptrace_check_attach() changes its ->state
to TASK_TRACED. But what should we do to ensure do_wait() will succeed
later?

Currently wait_task_stopped(ptrace => 1) needs ->exit_code != 0. Perhaps
we can change ptrace_check_attach() to set ptrace_task->xxx if it is zero.

But can't we just change wait_task_stopped() to return success when
ptrace == T regardless of ->exit_code == 0 ? I guess, the answer is
"we can break things".

What do you think?

Oleg.

