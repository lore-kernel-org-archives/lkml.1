Return-Path: <linux-kernel-owner+w=401wt.eu-S1753315AbZLIJph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbZLIJph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:45:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbZLIJpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:45:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60859 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbZLIJpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:45:35 -0500
Message-ID: <4B1F7198.708@cn.fujitsu.com>
Date: Wed, 09 Dec 2009 17:44:56 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 0/2][RFC] [RFC] tracing: separate out buffer from trace_seq
References: <20091208195405.653797300@goodmis.org>
In-Reply-To: <20091208195405.653797300@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> This is an RFC patch set. The trace_seq currently has its buffer
> within the structure itself. But this limits its ability and efficiency.
> 
> This patch set separates it out, but now it requires the callers
> to supply their own buffer. But this helps out the splice code because
> it can now write directly into the splice pages.
> 
> This may be too much for 33? But it is a nice fix.
> 
> Thoughs?
> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: rfc/tracing/core
> 
> 
> Steven Rostedt (2):
>       tracing: Change trace_seq to use separate buffer
>       tracing: Write directly into splice page for trace_pipe

It's great that you wrote it and trace_pipe benefit from it.
And it show separate buffer is required.

But I didn't expect so much/big changes. I'm wondering that
we can use seq file directly for some files and
kill all kmalloc(sizeof(struct trace_seq)).

kernel/trace/trace.c:3720:      s = kmalloc(sizeof(*s), GFP_KERNEL);
We can use a short buffer + simple_read_from_buffer()
Or seq file.

kernel/trace/trace_events.c:539:        s = kmalloc(sizeof(*s), GFP_KERNEL);
We can use seq file after of my patchset(today) is applied.

kernel/trace/trace_events.c:580:        s = kmalloc(sizeof(*s), GFP_KERNEL);
we can use a shor buffer. "char buf[20]" + simple_read_from_buffer()

kernel/trace/trace_events.c:604:        s = kmalloc(sizeof(*s), GFP_KERNEL);
We can use a short buffer + simple_read_from_buffer()
Or seq file.

kernel/trace/trace_events.c:660:        s = kmalloc(sizeof(*s), GFP_KERNEL);
We can use a short buffer + simple_read_from_buffer()
Or seq file.

kernel/trace/trace_events.c:715:        s = kmalloc(sizeof(*s), GFP_KERNEL);
We can use seq file.

kernel/trace/trace_ksym.c:230:  s = kmalloc(sizeof(*s), GFP_KERNEL);
We should use seq! It's very bad that we use trace_seq.

For function_stat_show(), it uses static trace_seq. but it can also
use a short buffer + simple_read_from_buffer().

I will do this.(or you if you would like to)

So could you write a simpler version of separate-buffer-trace_seq
with supposition that all kmalloc(sizeof(struct trace_seq)) are removed.

Lai.

> 
> ----
>  include/linux/ftrace_event.h |    6 ++++-
>  include/linux/trace_seq.h    |   22 +++++++++++++++-
>  include/trace/ftrace.h       |   20 +++++++++++----
>  kernel/trace/ftrace.c        |    3 +-
>  kernel/trace/trace.c         |   54 ++++++++++++++++-------------------------
>  kernel/trace/trace_events.c  |   45 +++++++++++++++++++++++++++++++----
>  kernel/trace/trace_ksym.c    |   10 +++++++-
>  kernel/trace/trace_output.c  |   24 ++++++++++--------
>  8 files changed, 125 insertions(+), 59 deletions(-)
> 
> 
> 

