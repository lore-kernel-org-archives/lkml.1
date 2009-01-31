Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbZAaTO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbZAaTO4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 14:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbZAaTOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 14:14:47 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:42360 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751517AbZAaTOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 14:14:46 -0500
Date: Sat, 31 Jan 2009 22:14:44 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: [PATCH -rt] powerpc/tracing: Add support for "PREEMPT_TRACE" tracer
Message-ID: <20090131191444.GA6896@oksana.dev.rtsoft.ru>
References: <1233338221.3833.65.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <1233338221.3833.65.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The support is pretty straightforward: issue print_preempt_trace()
just after the call trace.

Without CONFIG_PREEMPT_TRACE=y the print_preempt_trace() call turns
into no-op.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---

On Fri, Jan 30, 2009 at 12:57:01PM -0500, Steven Rostedt wrote:
[...]
> > > Turn on CONFIG_PREEMPT_TRACE (not TRACER) and it should show the
> > > location that left preemption disabled.
> > 
> > Thank you Steven, PREEMPT_TRACE is a great tool indeed (though on
> > PowerPC it doesn't work out of the box, but easily fixable).
> 
> Cool, I'd be interested in those fixes.

Here it is. "ftrace: On PowerPC we don't need frame pointers for
CALLER_ADDRs" patch (http://lkml.org/lkml/2009/1/31/141) is also
needed for this to work.

Thanks,

 arch/powerpc/kernel/process.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 957bded..b8642bf 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1020,7 +1020,7 @@ void show_stack(struct task_struct *tsk, unsigned long *stack)
 	printk("Call Trace:\n");
 	do {
 		if (!validate_sp(sp, tsk, STACK_FRAME_OVERHEAD))
-			return;
+			goto out;
 
 		stack = (unsigned long *) sp;
 		newsp = stack[0];
@@ -1049,6 +1049,8 @@ void show_stack(struct task_struct *tsk, unsigned long *stack)
 
 		sp = newsp;
 	} while (count++ < kstack_depth_to_print);
+out:
+	print_preempt_trace(tsk);
 }
 
 void dump_stack(void)
-- 
1.5.6.5
