Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbYI0Tmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbYI0Tmg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 15:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbYI0Tm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 15:42:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40079 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbYI0Tm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 15:42:27 -0400
Date: Sat, 27 Sep 2008 21:41:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v9] Unified trace buffer
Message-ID: <20080927194105.GF18619@elte.hu>
References: <20080925185236.244343232@goodmis.org> <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com> <48DC406D.1050508@redhat.com> <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809261631420.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809262148070.30105@gandalf.stny.rr.com> <alpine.DEB.1.10.0809270203270.1628@gandalf.stny.rr.com> <20080927183912.GA13685@elte.hu> <alpine.DEB.1.10.0809271444460.11865@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0809271444460.11865@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > > Index: linux-trace.git/include/linux/ring_buffer.h
> > > +enum {
> > > +	RB_TYPE_PADDING,	/* Left over page padding
> > 
> > RB_ clashes with red-black tree namespace. (on the thought level)
> 
> Yeah, Linus pointed this out with the rb_ static function names. But since 
> the functions are static I kept them as is. But here we have global names.
> 
> Would RNGBF_ be OK, or do you have any other ideas?

that's even worse i think :-/ And this isnt bikeshed-painting really, 
the RNGBF_ name hurts my eyes and RB_ is definitely confusing to read. 
(as the rbtree constants are in capitals as well and similarly named)

 RING_TYPE_PADDING

or:

 RINGBUF_TYPE_PADDING

yes, it's longer, but still, saner.

> > too large, please uninline.
> 
> I calculated this on x86_64 to add 78 bytes. Is that still too big?

yes, way too big. Sometimes we make savings from a 10 bytes function 
already. (but it's always case dependent - if a function has a lot of 
parameters then uninlining can hurt)

the only exception would be if there's normally only a single 
instantiation per tracer, and if it's in the absolute tracing hotpath. 

> > hm, should not be raw, at least initially. I am 95% sure we'll see 
> > lockups, we always did when we iterated ftrace's buffer 
> > implementation ;-)
> 
> It was to prevent lockdep from checking the locks from inside. We had 
> issues with ftroce and lockdep in the past, because ftrace would trace 
> the internals of lockdep, and lockdep would then recurse back into 
> itself to trace.  If lockdep itself can get away with not using 
> raw_spinlocks, then this will be OK to make back to spinlock.

would be nice to make sure that ftrace's recursion checks work as 
intended - and the same goes for lockdep's recursion checks. Yes, we had 
problems in this area, and it would be nice to make sure it all works 
fine. (or fix it if it doesnt)


> > > +	for (head = 0; head < rb_head_size(cpu_buffer);
> > > +	     head += ring_buffer_event_length(event)) {
> > > +		event = rb_page_index(cpu_buffer->head_page, head);
> > > +		BUG_ON(rb_null_event(event));
> > 
> > ( optional:when there's a multi-line loop then i generally try to insert 
> >   an extra newline when starting the body - to make sure the iterator 
> >   and the body stands apart visually. Matter of taste. )
> 
> Will fix, I have no preference.

clarification: multi-line loop _condition_. It's pretty rare (this is 
such a case) but sometimes unavoidable - and then the newline helps 
visually.

> > > +	RB_TYPE_TIME_EXTENT,	/* Extent the time delta
> > > +				 * array[0] = time delta (28 .. 59)
> > > +				 * size = 8 bytes
> > > +				 */
> > 
> > please use standard comment style:
> > 
> >  /*
> >   * Comment
> >   */
> 
> Hmm, this is interesting. I kind of like this because it is not really a 
> standard comment. It is a comment about the definitions of the enum. I 
> believe if they are above:
> 
>   /*
>    * Comment
>    */
>    RB_ENUM_TYPE,
> 
> It is not as readable. But if we do:

no, it is not readable. My point was that you should do:
> 
>    RB_ENUM_TYPE,	/*
> 			 * Comment
> 			 */
> 
> The comment is not at the same line as the enum, which also looks 
> unpleasing.

but you did:

>    RB_ENUM_TYPE,	/* Comment
> 			 */

So i suggested to fix it to:

 +	RB_TYPE_TIME_EXTENT,	/*
 +				 * Extent the time delta
 +				 * array[0] = time delta (28 .. 59)
 +				 * size = 8 bytes
 +				 */

ok? I.e. "comment" should have the same visual properties as other 
comments.

I fully agree with moving it next to the enum, i sometimes use that 
style too, it's a nice touch and more readable in this case than 
comment-ahead. (which we use for statements)

	Ingo
