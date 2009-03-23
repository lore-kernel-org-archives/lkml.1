Return-Path: <linux-kernel-owner+w=401wt.eu-S1760374AbZCWWHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760374AbZCWWHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 18:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbZCWWH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 18:07:28 -0400
Received: from [213.79.90.228] ([213.79.90.228]:48380 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751674AbZCWWH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 18:07:27 -0400
Date: Tue, 24 Mar 2009 01:07:24 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, Steven Rostedt <srostedt@redhat.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tracing: Fix TRACING_SUPPORT dependency for PPC32
Message-ID: <20090323220724.GA9851@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090320150914.GA22769@oksana.dev.rtsoft.ru> <20090320190428.GD6224@elte.hu> <20090320193904.GA13707@oksana.dev.rtsoft.ru> <20090320195743.GA25147@elte.hu> <20090320202247.GA30654@oksana.dev.rtsoft.ru> <20090321161814.GC11183@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090321161814.GC11183@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 40ada30f9621fbd831ac2437b9a2a399aa ("tracing: clean up menu"),
despite the "clean up" in its purpose, introduced a behavioural
change for Kconfig symbols: we no longer able to select tracing
support on PPC32 (because IRQFLAGS_SUPPORT isn't yet implemented).

The IRQFLAGS_SUPPORT is not mandatory for most tracers, tracing core
has a special case for platforms w/o irqflags (which, by the way, has
become useless as of the commit above).

Though according to Ingo Molnar, there was periodic build failures on
weird, unmaintained architectures that had no irqflags-tracing support
and hence didn't know the raw_irqs_save/restore primitives. Thus we'd
better not enable irqflags-less tracing for all architectures.

This patch restores the old behaviour for PPC32, and thus brings the
tracing back. Other architectures can either add themselves to the
exception list or (better) implement TRACE_IRQFLAGS_SUPPORT.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---

On Sat, Mar 21, 2009 at 05:18:14PM +0100, Ingo Molnar wrote:
[...]
> > > > Surely I'll look into implementing irqflags tracing, but 
> > > > considering that no one ever needed this for almost three years, 
> > > > [...]
> > > 
> > > Weird, there's no lockdep support?
> > 
> > *ashamed*: apparently no such support currently exist for PPC32. ;-)
> 
> Hm, do all the tracers even compile on ppc32 with your patch?

Following config compiles fine:

$ grep TRAC .config
CONFIG_STACKTRACE_SUPPORT=y
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_STACKTRACE=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACING=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_EVENT_TRACER=y
CONFIG_BOOT_TRACER=y
# CONFIG_TRACE_BRANCH_PROFILING is not set
CONFIG_STACK_TRACER=y
CONFIG_KMEMTRACE=y
CONFIG_WORKQUEUE_TRACER=y
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y

With CONFIG_TRACE_BRANCH_PROFILING=y the kernel builds fine too,
but vmlinux is too big to boot (we still can boot it, but we'll
need a bit modified bootloader for that).

OK, how about the patch down below?

 kernel/trace/Kconfig |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index ee70841..2246141 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -63,7 +63,11 @@ config TRACING
 #
 config TRACING_SUPPORT
 	bool
-	depends on TRACE_IRQFLAGS_SUPPORT
+	# PPC32 has no irqflags tracing support, but it can use most of the
+	# tracers anyway, they were tested to build and work. Note that new
+	# exceptions to this list aren't welcomed, better implement the
+	# irqflags tracing for your architecture.
+	depends on TRACE_IRQFLAGS_SUPPORT || PPC32
 	depends on STACKTRACE_SUPPORT
 	default y
 
-- 
1.5.6.5

