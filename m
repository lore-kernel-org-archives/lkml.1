Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbZEZTqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbZEZTqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 15:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753339AbZEZTqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 15:46:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61950 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbZEZTqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 15:46:23 -0400
Date: Tue, 26 May 2009 15:46:24 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 0/5] tracing/core: various fixes
In-Reply-To: <1243303490-8019-1-git-send-email-fweisbec@gmail.com>
Message-ID: <alpine.DEB.2.00.0905261542230.26705@gandalf.stny.rr.com>
References: <1243303490-8019-1-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm just coming back off of a holiday.


On Tue, 26 May 2009, Frederic Weisbecker wrote:

> Hi Ingo, Steven,
> 
> I've gathered various tracing fixes that were posted recently.
> 
> Note: the commit b11c53e12f94a46b50bccc7a1a953d7ca1d54a31
> 	(ftrace: Add task_comm support for trace_event)
>       looks good to me. This v3 solves the two following unhandled
>       dependencies in v1:
> 
> ENABLE_EVENT_TRACING -> CONTEXT_SWITCH_TRACER
> EVENT_TRACING -> CONTEXT_SWITCH_TRACER
> 
> The latter is tricky because CONTEXT_SWITCH_TRACER depends
> on CONFIG_FTRACE (the tracers menu) from which EVENT_TRACING
> is excluded. A build error can then occur if something selects
> CONFIG_TRACING elsewhere.
> 
> The fix written by Zhaolei follows the {ENABLE_}EVENT_TRACING
> view: we now have CONTEXT_SWITCH_TRACER and ENABLE_CONTEXT_SWITCH_TRACER.
> 
> The former is used by EVENT_TRACING to record cmdlines.
> The latter selects CONTEXT_SWITCH_TRACER plus CONFIG_TRACING.
> To sum up, ENABLE_CONTEXT_SWITCH_TRACER acts only as a "relay".

The sched_switch tracer is very light weight. Not sure we need to keep
it separate.

Basically, when tracing is enabled, we should simply get the event tracer 
and the sched_switch tracer for free. The configs get a bit tricky with 
dependencies. I'll take a look at it.

-- Steve

> 
> It looks good to me, tell me and Zhaolei if you have doubts
> about it.
> 
> Thanks.
> 
> The following changes since commit 5537937696c55530447c20aa27daccb8d0d29b33:
>   Ming Lei (1):
>         ftrace: fix check for return value of register_module_notifier in event_trace_init
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	tracing/core
> 
> Lai Jiangshan (1):
>       tracing: add trace_event_read_lock()
> 
> Li Zefan (1):
>       tracing/events: change the type of __str_loc_item to unsigned short
> 
> Pekka Enberg (1):
>       kmemtrace: fix kernel parameter documentation
> 
> Zhaolei (2):
>       ftrace: Add task_comm support for trace_event
>       ftrace: clean up of using ftrace_event_enable_disable()
> 
>  Documentation/kernel-parameters.txt |   10 --------
>  include/trace/ftrace.h              |    2 +-
>  kernel/trace/Kconfig                |    9 +++++-
>  kernel/trace/trace.c                |    8 ++++++
>  kernel/trace/trace_events.c         |   42 +++++++++++++---------------------
>  kernel/trace/trace_output.c         |   25 +++++++++++++++-----
>  kernel/trace/trace_output.h         |    2 +
>  7 files changed, 52 insertions(+), 46 deletions(-)
> 
