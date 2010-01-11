Return-Path: <linux-kernel-owner+w=401wt.eu-S1753122Ab0AKXAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab0AKXAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 18:00:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356Ab0AKXAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 18:00:05 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:43126 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab0AKXAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 18:00:03 -0500
Subject: Re: [RFC] [PATCH 0/7] UBP, XOL and Uprobes
From: Jim Keniston <jkenisto@us.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B4B373B.5010802@redhat.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <4B4B373B.5010802@redhat.com>
Content-Type: text/plain
Date: Mon, 11 Jan 2010 14:59:32 -0800
Message-Id: <1263250772.5094.41.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2010-01-11 at 09:35 -0500, Masami Hiramatsu wrote:
> Srikar Dronamraju wrote:
> > Hi, 
> > 
> > This patchset implements Uprobes which enables you to dynamically
> > break into any routine in a user space application and collect
> > information non-disruptively.  Uprobes is based on utrace and uses
> > x86 instruction decoder.
...
> 
> > - Return probes.
> 
> Hmm, I think we need some symbol information for supporting
> return probes in user space. Could you tell me how to work it?
> is that requires some user-space helper?

Return probes are on the TODO list, but we actually already have a
pretty solid implementation of that.  It's held out for now because
Srikar's patch set is already big, and we want get a review of the basic
ubp/xol/uprobes feature.

For the most part, we don't need special symbol information for return
probes.  We just do as we did in kretprobes: hijack the return address
and replace it with the address of a trampoline.  In user-space return
probes, the trampoline is one of the instruction slots in the XOL vma,
and contains a breakpoint to trap us into the kernel.  (Of course, as in
kretprobes, we need to know the address of the function so we can hijack
the return address upon entry to the function.)

One place where symbol info would come in handy is when a function
returns in a weird way.  We handle longjmps by noticing that the task's
stack is smaller than expected, and presumably missing stack frames that
were bypassed by the longjmp.  But this heuristic gets dicey when you
consider that in a 32-bit x86 app, a struct-returning function pops not
only the return address upon return, but also the address of the
returned struct value.  So it'd be nice to know if a function returns a
struct.

Does this answer your question, or did I miss something?

> 
> > - Support for Other Architectures.
> > - Jump optimization.
> 
> I assume that you meant this is "uprobe-booster" to skip
> just single stepping after probing, isn't it?

Yes, I think that's what Srikar meant: avoid single-stepping by adding a
jump instruction after the instruction-copy in the XOL slot -- as you
did in your kprobes-booster work.  Your instruction-analysis work makes
this much more feasible.

> 
> 
> Thank you,

Jim Keniston

