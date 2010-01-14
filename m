Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578Ab0ANTqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab0ANTqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 14:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757548Ab0ANTqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 14:46:46 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56044 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab0ANTqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 14:46:46 -0500
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
From: Jim Keniston <jkenisto@us.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1263467289.4244.288.camel@laptop>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122529.22050.32596.sendpatchset@srikar.in.ibm.com>
	 <1263467289.4244.288.camel@laptop>
Content-Type: text/plain
Date: Thu, 14 Jan 2010 11:46:06 -0800
Message-Id: <1263498366.4875.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2010-01-14 at 12:08 +0100, Peter Zijlstra wrote:
> On Mon, 2010-01-11 at 17:55 +0530, Srikar Dronamraju wrote:
> > User Space Breakpoint Assistance Layer (UBP)
> > 
> > User space breakpointing Infrastructure provides kernel subsystems
> > with architecture independent interface to establish breakpoints in
> > user applications. This patch provides core implementation of ubp and
> > also wrappers for architecture dependent methods.
> 
> So if this is the basic infrastructure to set userspace breakpoints,
> then why not call this uprobe?

Ubp is for setting and removing breakpoints, and for supporting the two
schemes (inline, out of line) for executing the probed instruction after
you hit the breakpoint.

Uprobes provides a higher-level API and deals with synchronization
issues, process-vs-thread issues, execution of the client's (potentially
buggy) probe handler, multiple probe clients, multiple probes at the
same location, thread- and process-lifetime events, etc.

> 
> > UBP currently supports both single stepping inline and execution out
> > of line strategies. Two different probepoints in the same process can
> > have two different strategies.
> 
> maybe explain wth these are?
> 

Here's a partial explanation from patch #6,section 1.1:

+When a CPU hits the breakpoint instruction, a trap occurs, the CPU's
+user-mode registers are saved, and a SIGTRAP signal is generated.
+Uprobes intercepts the SIGTRAP and finds the associated uprobe.
+It then executes the handler associated with the uprobe, passing the
+handler the addresses of the uprobe struct and the saved registers.
+...
+
+Next, Uprobes single-steps its copy of the probed instruction and
+resumes execution of the probed process at the instruction following
+the probepoint.  (It would be simpler to single-step the actual
+instruction in place, but then Uprobes would have to temporarily
+remove the breakpoint instruction.  This would create problems in a
+multithreaded application.  For example, it would open a time window
+when another thread could sail right past the probepoint.)
+
+Instruction copies to be single-stepped are stored in a per-process
+"single-step out of line (XOL) area," which is a little VM area
+created by Uprobes in each probed process's address space.

This (single-stepping out of line = SSOL) is essentially what kprobes
does on most architectures.  XOL (execution out of line) is actually a
broader category that could include other schemes, discussed elsewhere.

Jim

