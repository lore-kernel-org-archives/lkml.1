Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924Ab0AVDNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab0AVDNF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 22:13:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755585Ab0AVDNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 22:13:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37084 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478Ab0AVDNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 22:13:00 -0500
X-Authority-Analysis: v=1.0 c=1 a=6AAhZGXoe_sA:10 a=7U3hwN5JcxgA:10 a=meVymXHHAAAA:8 a=kq5xjdUIGCl-Xw0Hkc0A:9 a=3onnBbwQr0NkiaHueeYA:7 a=2zgsIPtjzREbbOebHvh7tjBZW4gA:4 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC PATCH 03/10] ftrace: Drop the ftrace_profile_enabled
 checks in tracing hot path
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
In-Reply-To: <20100122022858.GA2604@Krystal>
References: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com>
	 <1264122982-1553-4-git-send-regression-fweisbec@gmail.com>
	 <1264125917.31321.312.camel@gandalf.stny.rr.com>
	 <20100122022858.GA2604@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 21 Jan 2010 22:12:58 -0500
Message-ID: <1264129978.31321.333.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-21 at 21:28 -0500, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:

> > Now for the reason I Cc'd Paul and Mathieu...
> > 
> > If we had a synchronize_sched() like function that would wait and return
> > when all preempted tasks have been scheduled again and went to either
> > userspace or called schedule directly, then we could actually do this.
> > 
> > After unregistering the function graph trace, you call this
> > "synchronize_tasks()" and it will guarantee that all currently preempted
> > tasks have either went to userspace or have called schedule() directly.
> > Then it would be safe to remove this check.
> 
> OK, so basically you need to know when you reach a quiescent state, but
> preemption is enabled and there is no RCU read lock taken around these
> code paths, am I correct ?
> 
> With tracepoints, life is easy because I disable preemption around the
> calls, so I can use synchronize_sched() to know when quiescent state is
> reached.
> 
> I recommend looking at kernel/kprobes.c:check_safety(). It uses
> thaw_processes() and synchronize_sched() for this purpose. Basically, it
> rely on the "refrigeration" points to detect such quiescent state. This
> trick should do the job for the function graph tracer too.
> 
> I'm adding Masami in CC. He is the one who implemented check_safety(),
> and I remember discussing it with him in the past.

Hmm, interesting. Maybe something like that might work. But what if
CONFIG_PREEMPT is enabled but CONFIG_FREEZER is not?

-- Steve


