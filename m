Return-Path: <linux-kernel-owner+w=401wt.eu-S1754265AbZESCIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbZESCIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 22:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbZESCIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 22:08:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61219 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbZESCIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 22:08:23 -0400
Message-ID: <4A1213E1.8050608@cn.fujitsu.com>
Date: Tue, 19 May 2009 10:05:21 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: add trace_event_read_lock()
References: <4A114806.7090302@cn.fujitsu.com> <20090518135930.GC4704@nowhere>
In-Reply-To: <20090518135930.GC4704@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Mon, May 18, 2009 at 07:35:34PM +0800, Lai Jiangshan wrote:
>> I found that there is nothing to protect event_hash in
>> ftrace_find_event().
> 
> 
> 
> Actually, rcu protects it, but not enough. We have neither
> synchronize_rcu() nor rcu_read_lock.

We have no rcu_read_lock(), RCU can not protects it.

> 
> So we protect against concurrent hlist accesses.
> But the event can be removed when a module is unloaded,
> and that can happen between the time we get the event output
> callback and the time we actually use it.
> 

[...]

> It could be more fine grained.

I think it's fine-grained enough, write-side(modules loading/unloading)
is happened rarely. trace_event_read_lock() will not sleep very likely.

Thoughts?

> We could have a per event rwsem, and also place the
> protected read section only in trace_print_entry() which is the only racy window.
> 

print_trace_line() is the only racy window.
So I just protect print_trace_line()(except __ftrace_dump())

I protect loops which call print_trace_line(), it
reduces invoke-times:

trace_event_read_lock();
while (...) {
	...
	print_trace_line();
	...
}
trace_event_read_unlock();

Thanks!
Lai

> But I'm not sure it's that worthy since event removal is a rare thing.
> 
> So I guess this patch is fine.
> 
> 
> 
> 


