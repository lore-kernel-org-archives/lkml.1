Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512Ab0AVBvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab0AVBvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 20:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723Ab0AVBvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 20:51:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48639 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab0AVBvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 20:51:51 -0500
X-Authority-Analysis: v=1.0 c=1 a=JS5V5-kzzowA:10 a=7U3hwN5JcxgA:10 a=t3w-cV6e7KteTzMpuqsA:9 a=tOs8TZeX2MzoEjPUMegA:7 a=1sme-inuxpBvxkztisvG7Bel0W0A:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC PATCH 02/10] ftrace: Ensure tracing has really stopped
 before leaving unregister_ftrace_graph
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>
In-Reply-To: <1264122982-1553-3-git-send-regression-fweisbec@gmail.com>
References: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com>
	 <1264122982-1553-3-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 21 Jan 2010 20:51:48 -0500
Message-ID: <1264125108.31321.304.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-22 at 02:16 +0100, Frederic Weisbecker wrote:
> When we run under dynamic tracing, we know that after calling
> unregister_ftrace_graph(), tracing has really stopped because of
> the hot patching and use of stop_machine().

This is incorrect. Even after unregister_ftrace_graph() with
stop_machine(), we still have no guarantee that a call back is not being
called. This is the reason I use sub tracing instead of NULLs. The call
to the trace function could have been loaded in a register and then
preempted. Even after stop_machine() that trace function can be called.
This is also the reason that I never let modules add hooks to the
function tracer (although I can easily make a wrapper to do so).

> 
> But in static tracing case, we only set stub callbacks. This is
> not sufficient on archs that have weak memory ordering to assume
> the older callbacks won't be called right after we leave
> unregister_ftrace_graph().
> 
> Insert a read/write memory barrier in the end of
> unregister_ftrace_graph() so that the code that follow can safely
> assume tracing has really stopped. This can avoid its older tracing
> callbacks to perform checks about various states like ensuring
> needed buffers have been allocated, etc...

There's no guarantee, even with a smp_mb() that a trace function will
not be called after being unregistered.

-- Steve



