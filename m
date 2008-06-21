Return-Path: <linux-kernel-owner+w=401wt.eu-S1752118AbYFUOgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbYFUOgf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 10:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbYFUOgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 10:36:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52704 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbYFUOgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 10:36:25 -0400
Date: Sat, 21 Jun 2008 10:36:23 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Hideo AOKI <haoki@redhat.com>
Subject: Re: [RFC][Patch 2/2] markers: example of irq regular kernel markers
In-Reply-To: <20080621190132.E835.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.58.0806211013300.32694@gandalf.stny.rr.com>
References: <20080620174529.GB10943@Krystal> <485C064E.5020705@redhat.com>
 <20080621190132.E835.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 21 Jun 2008, KOSAKI Motohiro wrote:
> >
> > even though, I think you can do that by adding below string table
> > to LTTng module.
> >
> > const char *lookup_table[MAX_MARKERS][2] = {
> > {"irq_entry", "%d %d"}, // or "(int irq_id, int kernel_mode)", "%d %d"
> > ...
> > };
>
> if move string to out of kernel core, compiler may kill some variable.
> thus, we will get incomplete tracing result.

I don't understand why the compiler would do such a thing? The compiler
shouldn't be removing parameters.

>
> I think your proposal is very interesting.
> but I dont understand why someone dislike format strings.
> Could you explain this reason?

Format strings only help for printf like operations. Not all tracers want
such a thing. The best example of this is the sched_switch code. LTTng and
friends just want a pid and comm to show. But there's tracers that want
more info from the task_struct. We also like to see the priority of the
task.

I also foresee these trace hooks be use for dynamic itegrity checks. On
switching out a process we might want to examine both the next and prev to
make sure the context switch should really occur.

There's other places in the core kernel that a tracer wants more than some
data in a structure. Recording all the data that might be needed in a
structure slows down those tracers that only want a little bit of data.
Passing in a pointer to the structure being traced should be enough for
all tracers.

If those that don't care about priority of a context switch, why should it
be parsing it out just for a single tracer that might need it. But all
tracers would need the prev and next pointers.

Now back to your question, why don't we like the printf format. Simply
because it does nothing for pointers. It might help you with a %d and
number of parameters, but a %p can not tell the difference between a
struct tasks_struct *, and a int *, which can have even more devastating
results. It also just looks like a debug session instead of a trace
marker.

Not to mention what Peter Zijlstra already stated, that a printf format
gives only run time checking, where we would like to see compile time
checking.

-- Steve

