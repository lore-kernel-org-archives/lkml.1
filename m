Return-Path: <linux-kernel-owner+w=401wt.eu-S932839AbZKDX7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839AbZKDX7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 18:59:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932814AbZKDX7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 18:59:50 -0500
Received: from ozlabs.org ([203.10.76.45]:58862 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932692AbZKDX7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 18:59:49 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19186.5488.320389.567026@cargo.ozlabs.ibm.com>
Date: Thu, 5 Nov 2009 10:59:44 +1100
From: Paul Mackerras <paulus@samba.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Avi Kivity <avi@redhat.com>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 4/6] hw-breakpoints: Rewrite the hw-breakpoints layer on top of perf events
In-Reply-To: <1257275474-5285-5-git-send-email-fweisbec@gmail.com>
References: <1257275474-5285-1-git-send-email-fweisbec@gmail.com>
	<1257275474-5285-5-git-send-email-fweisbec@gmail.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker writes:

> This patch rebase the implementation of the breakpoints API on top of
> perf events instances.
> 
> Each breakpoints are now perf events that handle the
> register scheduling, thread/cpu attachment, etc..

What I haven't managed to understand yet is how you provide reliable
breakpoints for debugging purposes.  If I'm debugging a program and I
have set a breakpoint, I'll be very unhappy if the breakpoint should
trigger but doesn't because the perf_event infrastructure has decided
it can't schedule that breakpoint in.  If the breakpoint isn't going
to work then I want to know that at the time that I set it.

We can go some distance towards that with the pinned attribute, but
not far enough.  The pinned attribute doesn't guarantee that the event
will always be scheduled in, it just says that we'll do our best to
schedule it in, and if we can't, we'll put the event into error state
so that the user knows we didn't manage to schedule it in.  But
there's no way to get back to gdb and tell it that a breakpoint that
it had previously successfully created is no longer working.

Also, we don't currently fail the creation of a pinned event if it
would conflict with another pinned event already created in the same
context.  We would need to do something like that if we want to use
pinned events for debugging breakpoints (as distinct from breakpoints
for performance monitoring purposes, for which it matters less if they
are sometimes not scheduled in).

And then there's the question of whether a per-cpu pinned breakpoint
event conflicts with a per-task pinned breakpoint event if you only
have one breakpoint register (as is the case on Power server CPUs).
Plus the fact that we don't currently give per-task pinned events
priority over per-cpu non-pinned events (perhaps that would be a good
idea anyway).

Paul.
