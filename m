Return-Path: <linux-kernel-owner+w=401wt.eu-S1760127AbZELCrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127AbZELCrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 22:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759377AbZELCrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 22:47:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759057AbZELCrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 22:47:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Jason Baron <jbaron@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, fche@redhat.com
Subject: Re: [RFC] convert ftrace syscall tracer to TRACE_EVENT()
In-Reply-To: Ingo Molnar's message of  Saturday, 9 May 2009 10:37:37 +0200 <20090509083737.GE3656@elte.hu>
References: <20090508210347.GA3121@redhat.com>
	<20090509083737.GE3656@elte.hu>
X-Shopping-List: (1) Lubricating annoyers
   (2) Promiscuous bureaucratic harmonizers
   (3) Barbarous complaisant wavechord inquisitions
Message-Id: <20090512024437.F19ADFC35D@magilla.sf.frob.com>
Date: Mon, 11 May 2009 19:44:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Firstly, it adds two new tracepoints to every system call. That is 
> unnecessary - we already have the TIF flag based callbacks, and we 
> can use the existing syscall attributes table to get to tracepoints 
> - without slow down (or impacting) the fast path in any way.

This is one of the key differences of this approach.  It has very different
trade-offs.  I'm afraid that you might be sweeping this issue under the rug
inadvertently.  I see two major thrusts of Jason's proposal, and I think we
should be clear about each of those on its own separate merits.

#1 is the mechanism for getting to a tracing path.

If you use TIF_SYSCALL_TRACE (or new equivalents) then this is a choice you
make for the task (or all tasks, or whichever subset you choose).  This
means every system call in that task takes the slow path for tracing.
(The slow path is slow primarily to enable fetching and changing all user
registers, which is not needed for just tracing syscall arguments/results.)

Conversely, an actual tracepoint in a syscall function or its wrapper
always affects every task, but only affects that particular syscall's code
path.  If the tracepoint on sys_reboot is enabled, that has no effect
whatsoever on the paths taken by any task's sys_read calls.  OTOH, if the
sys_read tracepoint is enabled (with whatever filtering), that makes each
and every sys_read call by each and every task go through the tracepoint
callback path.  The "collateral damage" overhead paid by "uninteresting"
tasks (whose tracepoint hits are all filtered out) is whatever cost the
filtering code has.

#2 is the richness of the method for handling syscall arguments.

(I have the impression this one was Jason's motivation.)  The new(ish)
syscall definition macros make it easy(ish) to pull out parameter types and
names statically at kernel build time, and do intelligent things with
those.  As Jason is already looking into in his second pass, you can find a
way to exploit this either with direct tracepoints, or via syscall register
values fetched with syscall_get_arguments().


Thanks,
Roland
