Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbZLAHaD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbZLAHaD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 02:30:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbZLAHaC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 02:30:02 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51875 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087AbZLAHaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 02:30:01 -0500
Date: Tue, 1 Dec 2009 08:29:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 0/9] perf-probe updates
Message-ID: <20091201072902.GA4587@elte.hu>
References: <20091201001912.10235.79411.stgit@harusame>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091201001912.10235.79411.stgit@harusame>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Hi,
> 
> Here are bugfixes and updates for perf-probe and kprobe-tracer. I've 
> fixed some minor bugs and added --list option and simple probe naming.

Applied, thanks Masami!

> TODO:
>  - Support build-id checking.
>  - Support --del option to remove probes.
>  - Support --line option to show which lines user can probe.
>  - Support lazy string matching.

ok, cool!

One other small detail i noticed wrt. probe naming. Right now if we 
insert a single probe into a function it gets named schedule_0:

 # perf probe schedule
 Could not open vmlinux/module file. Try to use symbols.
 Added new event: p:probe/schedule_0 schedule+0

the next one gets named schedule_1, schedule_2, etc.

It would be nice to special-case the first one and name it 'schedule'. 
Most of the time people insert a single probe into a function, so the _0 
postfix is extra and in most cases unnecessary typing for them.

Another small detail is that i dont think we should emit this line:

 Could not open vmlinux/module file. Try to use symbols.

when we can create a probe successfully - it's just unnecessary noise, 
the user does not care how we pulled it off, as long as we were able to 
get a reliable symbol address and the insertion worked fine.

A third detail is this line:

 Added new event: p:probe/schedule_0 schedule+0

If that is pasted to perf stat directly it wont work because the syntax 
is probe:schedule_0. So i'd suggest to print something like:

 Added new event: probe/schedule_0 (on schedule+0)

Perhaps even print another line:

  You can now use it on all perf tools, such as:

    perf probe -e probe/schedule_0 -a sleep 1
    perf record -e probe/schedule_0 -a sleep 1

... to show people how to make use of it.

Thanks,

	Ingo
