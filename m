Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbZIPFaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbZIPFaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 01:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbZIPFaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 01:30:20 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:56450 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbZIPFaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 01:30:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oP53XapfUjpMHnXIwLWkwr8ZxhEfVIUm9Se3MEe6ka6RD5TUfyPztoVz+jG+0sFwtQ
         cpizYKQYkZXMbxirUj64xpeOlfTbZquPe++rGYn57fR+ON/gRDJ0puKVDaweDsMsTBqK
         0oQzri5/i1zvVZIFHvexeG08SqzX4bmt2+Pdw=
Date: Wed, 16 Sep 2009 07:30:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [GIT PULL v2] tracing/kprobes: v1 + two fixes
Message-ID: <20090916053017.GD5121@nowhere>
References: <1251340337-5640-1-git-send-email-fweisbec@gmail.com> <1251344087-28719-1-git-send-email-fweisbec@gmail.com> <20090827152625.GB32553@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827152625.GB32553@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 05:26:25PM +0200, Ingo Molnar wrote:
> 
> It would also be nice to have a pie-in-the-sky list of usecases and 
> workflows where this would be useful, and of future planned 
> features. (maybe we want some of them before we merge it upstream)
> 
> Why would the upstream kernel want to have this feature, and what is 
> the road ahead in terms of integration into tooling?
> 
> Thanks,
> 
> 	Ingo



In term, it would have the same skyline than static tracepoints events.
It already has actually, it supports filters, perf, etc...

For now one have yet to create these tracepoints through debugfs.

So what does it bring us?

First of all, the ability to profile the kernel at every random points.

2) It can be useful as a single counter

Say you want to trace:

long sys_kill(int pid, int sig)

(I know it's a bad example, we already have syscalls tracepoints, it's just
for the example).


And you want to see who is calling most this function. You could probably just
do:

	sudo perf record -f -a -g
	./perf report

And look at the result by looking at your function in the list, then
look at its callchain.

Of course the timer could give you the overhead of send_signal,
but:

- at the cost of profiling the whole system
- putting a kprobe there plus -c 1 on record would give you more
  accurate results, you won't loose any callchains


2) It can be useful as a tracepoint


Now you have your profile, and you want to know more about it.
You may want to know which signal and which task are often concerned
in this function call.

So you can fetch the pid and sig arguments, you can also set pid=a0
and sig=a1 in the kprobes debugfs interface, so that the format
takes these names intead of the raw a0,a1.

If you want a high level of details, you can just do

	perf trace

And look at the result.

	sig_kill: (common headers), pid=... sig=...


That, in essence, is a live patching trace_printk(),
something that I personally miss every day.

Also in my perf trace TODO list is the ability to implement a
sorting by fields:

        ./perf trace -s pid

        pid = 4765
         |
         |
         ------------ sig_kill: .... pid = 4765, sig = 7
         |
         ------------ sig_kill: .... pid = 4765, sig = 10
         |
         ------------ etc...

        pid = 7645
         |
         |
         ------------ etc...


In my perf trace TODO list is also the ability to get the callchains:

	./perf trace -s pid -g

        pid = 4765
         |
         |
         ------------ sig_kill: .... pid = 4765, sig = 7
         |              |
         |              |
         |              -------- caller 1
         |              |
         |              -------- caller 2
         |              |
         |              -------- caller 3
         |              |
         |              --------- .....
         |
         ------------ .......


3) It can find *much* more sunchine with C-expressions


I've used kprobes events through debugfs for debugging purposes.
If you just want to fetch the arguments of a function or global
variables, it's fine and easy to use.
But once you want to digg and diplay some local, variables,
it takes too much time and pain (find in which ip you can fetch
which register which matches which variable you want).

As you know, Masami has posted a translator from C-like level
expressions to kprobes debugfs command line using libdwarf.

One of the plans is to make a perf integration of this tool
so that one can fetch values from variables names (global and local)
and set such smart dynamic tracepoints everywhere in the kernel
(if it's not __kprobe annotated).

Concerning the possible syntax and workflow of this tool,
it's in daily open debate :)


	Frederic.

