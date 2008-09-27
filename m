Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbYI0UBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbYI0UBT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 16:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbYI0UBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 16:01:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47921 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbYI0UBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 16:01:09 -0400
Date: Sat, 27 Sep 2008 22:00:28 +0200
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
Message-ID: <20080927200028.GA28937@elte.hu>
References: <48DC406D.1050508@redhat.com> <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809261631420.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809262148070.30105@gandalf.stny.rr.com> <alpine.DEB.1.10.0809270203270.1628@gandalf.stny.rr.com> <20080927183912.GA13685@elte.hu> <alpine.DEB.1.10.0809271444460.11865@gandalf.stny.rr.com> <20080927194105.GF18619@elte.hu> <alpine.DEB.1.10.0809271549160.16572@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0809271549160.16572@gandalf.stny.rr.com>
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

> >  RINGBUF_TYPE_PADDING
> > 
> > yes, it's longer, but still, saner.
> 
> I don't mind the extra typing, it is just a bit more difficult to keep 
> in the 80 character line limit.

that's really not a hard limit, but yeah.

generally, with clean and simple functions it's easy to keep it.

> > yes, way too big. Sometimes we make savings from a 10 bytes function 
> > already. (but it's always case dependent - if a function has a lot 
> > of parameters then uninlining can hurt)
> > 
> > the only exception would be if there's normally only a single 
> > instantiation per tracer, and if it's in the absolute tracing 
> > hotpath.
> 
> It is a hot path in the internals. Perhaps I'll make an inline 
> function in the interal code "rb_event_length" and have the other 
> users call.
> 
> unsigned ring_buffer_event(struct ring_buffer_event *event)
> {
> 	return rb_event_length(event);
> }

yeah, sounds sane.

> > no, it is not readable. My point was that you should do:
> > > 
> > >    RB_ENUM_TYPE,	/*
> > > 			 * Comment
> > > 			 */
> > > 
> > > The comment is not at the same line as the enum, which also looks 
> > > unpleasing.
> > 
> > but you did:
> > 
> > >    RB_ENUM_TYPE,	/* Comment
> > > 			 */
> > 
> > So i suggested to fix it to:
> > 
> >  +	RB_TYPE_TIME_EXTENT,	/*
> >  +				 * Extent the time delta
> >  +				 * array[0] = time delta (28 .. 59)
> >  +				 * size = 8 bytes
> >  +				 */
> > 
> > ok? I.e. "comment" should have the same visual properties as other 
> > comments.
> > 
> > I fully agree with moving it next to the enum, i sometimes use that 
> > style too, it's a nice touch and more readable in this case than 
> > comment-ahead. (which we use for statements)
> 
> But then we have:
> 
>         RB_TYPE_PADDING,        /*
> 				   * Left over page padding
>                                  * array is ignored
>                                  * size is variable depending on
>                                  * how much padding is needed
>                                  */
>         RB_TYPE_TIME_EXTENT,    /*
> 				   * Extent the time delta
>                                  * array[0] = time delta (28 .. 59)
>                                  * size = 8 bytes
>                                  */
> 
> Where it is not as easy to see which comment is with which enum. 
> Especially when you have many enums. That's why I like the method I 
> used with:

> 
>         RB_TYPE_PADDING,        /* Left over page padding
>                                  * array is ignored
>                                  * size is variable depending on
>                                  * how much padding is needed
>                                  */
>         RB_TYPE_TIME_EXTENT,    /* Extent the time delta
>                                  * array[0] = time delta (28 .. 59)
>                                  * size = 8 bytes
>                                  */
> 
> Where it is very easy to notice which comment goes with which enum.

this:

>         RB_TYPE_PADDING,        /*
> 				   * Left over page padding
>                                  * array is ignored
>                                  * size is variable depending on
>                                  * how much padding is needed
>                                  */
>
>         RB_TYPE_TIME_EXTENT,    /*
> 				   * Extent the time delta
>                                  * array[0] = time delta (28 .. 59)
>                                  * size = 8 bytes
>                                  */

or:

>	/*
>	 * Left over page padding. 'array' is ignored,
>	 * 'size' is variable depending on how much padding is needed.
>	 */
>	RB_TYPE_PADDING,
>
>	/*
>	 * Extent the time delta,
>	 * array[0] = time delta (28 .. 59), size = 8 bytes
>	 */
>	RB_TYPE_TIME_EXTENT,

oh, btw., that's a spelling mistake: s/extend/extend ?

	Ingo
