Return-Path: <linux-kernel-owner+w=401wt.eu-S1758603AbYAOWPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603AbYAOWPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 17:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbYAOWPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 17:15:08 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:48269 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbYAOWPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 17:15:06 -0500
Date: Tue, 15 Jan 2008 17:15:02 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 28/30 v3] Generic command line storage
In-Reply-To: <20080115213044.GC17439@Krystal>
Message-ID: <Pine.LNX.4.58.0801151704140.29090@gandalf.stny.rr.com>
References: <20080115204907.838227723@goodmis.org> <20080115205026.559348520@goodmis.org>
 <20080115213044.GC17439@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 15 Jan 2008, Mathieu Desnoyers wrote:

> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > Saving the comm of tasks for each trace is very expensive.
> > This patch includes in the context switch hook, a way to
> > store the last 100 command lines of tasks. This table is
> > examined when a trace is to be printed.
> >
>
> Instead of saving the comm at context switch, could we save them when a
> process exits ? (actually, if we want to do this right, we would also
> have to trace the changes of "comm" upon exec(), so we deal correctly
> with processes that do multiple execs).
>
> This way, we would not duplicate the comm of processes still active in
> the system, and would trigger on a much lower event-rate trace point.
>
> And the idea would be to save only the comm of processes present in your
> summary (top X processes); why do you save the last 100 ? (if the system
> has more than 100 active tasks, this code will always be executed, which
> seems bad)

100 was just an arbitrary number that seems to be fine in my current
tests. But yes, a function trace over a thousand tasks will clean them
out. But the recording is only done when a trace is active.

>
> Also, if we do as I propose, we would have to keep process exit/exec
> tracing active until the summary is cleared, even though the rest of
> "high event rate" tracing could be stopped sooner.

One thing I planned on doing was at a low path point (hit max latency to
record, etc) we could copy the array into the trace buffer, so the info
stays with the trace.

Going with your approach (marker at exit), I could flush the traces that
were saved, as well as the comms of the current tasks that are still
running. The thing is, this all starts to get a bit intrusive into the
rest of the kernel.  What is suppose to be a compact latency tracer,
starts to become larger, problematic, entity. Now changes in exit could
require updates to the tracer. Which is something I want to avoid.

-- Steve

