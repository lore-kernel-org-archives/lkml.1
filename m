Return-Path: <linux-kernel-owner+w=401wt.eu-S1758446AbZDUVRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446AbZDUVRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 17:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758208AbZDUVRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 17:17:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46166 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758451AbZDUVRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 17:17:21 -0400
Date: Tue, 21 Apr 2009 17:17:17 -0400 (EDT)
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
In-Reply-To: <20090421202828.GB32179@basil>
Message-ID: <alpine.DEB.2.00.0904211711260.10097@gandalf.stny.rr.com>
References: <49E51FC1.8090306@goop.org> <20090415014548.GA7984@Krystal> <49E6065B.7080409@goop.org> <20090416023456.GC22378@Krystal> <49E69E76.9030608@goop.org> <20090416234410.GA20513@Krystal> <87zlebpzmk.fsf@basil.nowhere.org> <20090421155106.GE3792@Krystal>
 <49EDFFE6.1080401@goop.org> <alpine.DEB.2.00.0904211320440.10097@gandalf.stny.rr.com> <20090421202828.GB32179@basil>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 21 Apr 2009, Andi Kleen wrote:

> > It is needed for the function tracer (gcc -pg wont work without it). It is 
> > the only tracer that selects it.
> 
> FWIW i still have gcc patches to fix that. They were first stalled
> on copyright assignment and then on gcc's merge window being closed,
> but now with 4.5 open for game I hope to resubmit them soon
> again.
> 
> With that you can use -pg without frame pointer, but you have
> to supply a special mcount function that expects the different
> stack layout.

I think it was Ingo that let out the idea, and I'm starting to like it.

Perhaps we should fork off gcc and ship Linux with its own compiler. This 
way we can optimize it for the kernel and not worry about any userland 
optimizations.

I would like to do something like:

	if (unlikely(err)) {
		__section__(".error_sect") {
			/* put error code here */
		}
	}

And have gcc in the error section (if it is big enough perhaps) do:

	jmp .L123
.L124   [...]

and in the section ".error_sect" we would have:

.L123
	/* error code here */
	jmp .L124

We could do the same for trace points. That is, any part of code that 
really would happen once in a while (error handling for one) we can move 
off to its own section and keep hot paths hot.

-- Steve

