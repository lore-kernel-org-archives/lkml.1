Return-Path: <linux-kernel-owner+w=401wt.eu-S1752758AbZDVGYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbZDVGYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 02:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZDVGYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 02:24:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37499 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbZDVGYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 02:24:21 -0400
Date: Wed, 22 Apr 2009 02:24:17 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andi Kleen <andi@firstfloor.org>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Neil Horman <nhorman@tuxdriver.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka@firstfloor.org
Subject: Re: [PATCH 2/8] tracing: create automated trace defines
In-Reply-To: <20090422060701.GB14687@one.firstfloor.org>
Message-ID: <alpine.DEB.2.00.0904220215530.9714@gandalf.stny.rr.com>
References: <49E6065B.7080409@goop.org> <20090416023456.GC22378@Krystal> <49E69E76.9030608@goop.org> <20090416234410.GA20513@Krystal> <87zlebpzmk.fsf@basil.nowhere.org> <20090421155106.GE3792@Krystal> <49EDFFE6.1080401@goop.org>
 <alpine.DEB.2.00.0904211320440.10097@gandalf.stny.rr.com> <20090421202828.GB32179@basil> <alpine.DEB.2.00.0904211711260.10097@gandalf.stny.rr.com> <20090422060701.GB14687@one.firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 22 Apr 2009, Andi Kleen wrote:

> > I think it was Ingo that let out the idea, and I'm starting to like it.
> > 
> > Perhaps we should fork off gcc and ship Linux with its own compiler. This 
> > way we can optimize it for the kernel and not worry about any userland 
> > optimizations.
> > 
> > I would like to do something like:
> > 
> > 	if (unlikely(err)) {
> > 		__section__(".error_sect") {
> 
> 
> gcc already supports that, you don't need to fork anything. It's called
> hot/cold partitioning. Basically it splits functions into hot and cold
> and unlikely parts and all the cold/unlikely parts go into a separate 
> sections.
> 
> I think it's normally not enabled by default on x86 though, probably because
> it doesn't help too much.
> 
> By default (unless you specify -fno-reorder-blocks) it does the same
> without sections, just moving unlikely code out of line.

The unlikely code does not always get moved out that far. It still sits 
inside a function, and looking at the tracepoint code it did not move it 
far enough.

If you have a bunch of functions that each with an unlikely statement, 
those unlikely sections will still be interleaved within the function 
code.

In the case of tracepoints, it would be nice to move all the code that 
sets up the function call out of the hot paths. If we could move it to its 
own section, that would be much better.

Having all "unlikely"s go into a separate section would not help much, 
since according to the branch profiler there are a lot of "unlikely"s in 
the kernel that are not too unlikely.

If gcc can indeed move "unlikely" code completely out of the fast path, 
and put it into its own sections, then I think we should go through the 
kernel and start removing all "likely" and "unlikely"s that are not 99% 
accurate. Then we can enable the separate section cold paths and perhaps 
see a performance benefit.

-- Steve

