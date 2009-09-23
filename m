Return-Path: <linux-kernel-owner+w=401wt.eu-S1751372AbZIWJDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372AbZIWJDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 05:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750901AbZIWJDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 05:03:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:50341 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbZIWJDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 05:03:41 -0400
Subject: Re: perf sched record hangs machine
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Malley <mail@chrismalley.co.uk>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20090923073253.GA18022@elte.hu>
References: <7863dc4c0909221409v7893bfd3o4b590d5951a233ba@mail.gmail.com>
	 <20090922212453.GB6062@nowhere> <1253686585.7695.84.camel@twins>
	 <20090923073253.GA18022@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 23 Sep 2009 11:03:37 +0200
Message-Id: <1253696617.7695.126.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-23 at 09:32 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> >         .size   default_send_IPI_self, .-default_send_IPI_self
> > 
> > Which seems to suggest that cmove is in __prepare_ICR, but I'm not 
> > sure how that can cause a page-fault, as that function is rather 
> > pointer-less.
> > 
> > Did it maybe delay evaluating apic->dest_logical that late, it appear 
> > to be the first usage of that argument?
> > 
> > Ingo, any ideas?
> 
> Yeah, the problem is:
> 
> [    0.042445] Local APIC not detected. Using dummy APIC emulation.

The below seems like the best fix. You disabled all lapic bits, except
that one.

---
 arch/x86/kernel/cpu/perf_event.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index a3c7adb..b5801c3 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1790,6 +1790,9 @@ void smp_perf_pending_interrupt(struct pt_regs *regs)
 void set_perf_event_pending(void)
 {
 #ifdef CONFIG_X86_LOCAL_APIC
+	if (!x86_pmu.apic || !x86_pmu_initialized())
+		return;
+
 	apic->send_IPI_self(LOCAL_PENDING_VECTOR);
 #endif
 }

