Return-Path: <linux-kernel-owner+w=401wt.eu-S1753731AbZGTNai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbZGTNai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 09:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbZGTNah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 09:30:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:41947 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbZGTNah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 09:30:37 -0400
Subject: [PATCH] lockdep: fixup stacktrace wastage
From: Peter Zijlstra <peterz@infradead.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Jones <davej@redhat.com>, Joao Correia <joaomiguelcorreia@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@linux.intel.com>, mingo <mingo@elte.hu>
In-Reply-To: <1247130598.9777.326.camel@twins>
References: <a5d9929e0907070825j1dda6584t93196e2730dedc5c@mail.gmail.com>
	 <1246980836.9777.5.camel@twins>
	 <a5d9929e0907070838q7ed3306du3bb7880e47d7207b@mail.gmail.com>
	 <1246981444.9777.11.camel@twins>
	 <a5d9929e0907070850v72cd4da4y1cbbb10fddebd575@mail.gmail.com>
	 <1246982101.9777.15.camel@twins>  <20090708172248.GB2521@redhat.com>
	 <1247078164.16156.18.camel@laptop>
	 <1247130416.11409.14.camel@pc1117.cambridge.arm.com>
	 <1247130598.9777.326.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 20 Jul 2009 15:31:05 +0200
Message-Id: <1248096665.15751.8816.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-09 at 11:10 +0200, Peter Zijlstra wrote:
> On Thu, 2009-07-09 at 10:06 +0100, Catalin Marinas wrote:
> > On Wed, 2009-07-08 at 20:36 +0200, Peter Zijlstra wrote:
> > > As a side node, I see that each and every trace ends with a -1 entry:
> > > 
> > > ...
> > > [ 1194.412158]    [<c01f7990>] do_mount+0x3c0/0x7c0
> > > [ 1194.412158]    [<c01f7e14>] sys_mount+0x84/0xb0
> > > [ 1194.412158]    [<c01221b1>] syscall_call+0x7/0xb
> > > [ 1194.412158]    [<ffffffff>] 0xffffffff
> > > 
> > > Which seems to come from:
> > > 
> > > void save_stack_trace(struct stack_trace *trace)
> > > {
> > >         dump_trace(current, NULL, NULL, 0, &save_stack_ops, trace);
> > >         if (trace->nr_entries < trace->max_entries)
> > >                 trace->entries[trace->nr_entries++] = ULONG_MAX;
> > > }
> > > EXPORT_SYMBOL_GPL(save_stack_trace);
> > > 
> > > commit 006e84ee3a54e393ec6bef2a9bc891dc5bde2843 seems involved,..
> > 
> > The reason for this is that if there are no more traces to show, it
> > inserts -1. In this case, it cannot trace beyond the system call. If the
> > stack trace is truncated because of the maximum number of trace entries
> > it can show, you won't get a -1.
> > 
> > Before the commit above, it was always inserting -1 even if the trace
> > was longer than the maximum number of entries.
> 
> Seems daft to me, I'll fix up lockdep to truncate that last entry,
> having a gazillion copies of -1 in the trace entries doesn't make sense.

Bugger, not all arches have that. I'll queue up the below, if it breaks
anything, I'll go around and fix up all arches to never emit this -1
crap.

---
Subject: lockdep: fixup stacktrace wastage
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon Jul 20 15:27:04 CEST 2009

Some silly architectures emit trailing -1 entries on stacktraces, trim those
to save space.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -367,6 +367,12 @@ static int save_trace(struct stack_trace
 
 	save_stack_trace(trace);
 
+	/*
+	 * Some daft arches put -1 at the end to indicate its a full trace.
+	 */
+	if (trace->entries[trace->nr_entries-1] == ULONG_MAX)
+		trace->nr_entries--;
+
 	trace->max_entries = trace->nr_entries;
 
 	nr_stack_trace_entries += trace->nr_entries;

