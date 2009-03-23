Return-Path: <linux-kernel-owner+w=401wt.eu-S1758998AbZCWSye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758998AbZCWSye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 14:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbZCWSyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 14:54:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:65502 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbZCWSyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 14:54:24 -0400
Date: Mon, 23 Mar 2009 14:54:21 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/4] tracing: add ring_buffer_event_discard() to ring
 buffer
In-Reply-To: <20090322175859.GC6002@nowhere>
Message-ID: <alpine.DEB.2.00.0903231452450.3578@gandalf.stny.rr.com>
References: <1237710649.7703.47.camel@charm-linux> <20090322175859.GC6002@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 22 Mar 2009, Frederic Weisbecker wrote:

> >  
> > -/* inline for ring buffer fast paths */

[...]

> >  static unsigned
> > -rb_event_length(struct ring_buffer_event *event)
> > +rb_event_data_length(struct ring_buffer_event *event)
> >  {
> >  	unsigned length;
> >  
> > +	if (event->len)
> > +		length = event->len * RB_ALIGNMENT;
> > +	else
> > +		length = event->array[0];
> > +	return length + RB_EVNT_HDR_SIZE;
> > +}
> > +
> > +/* inline for ring buffer fast paths */
> 
> 
> I don't see an inline here.

That was my comment. I use to have a bunch of inlines, but someone thought 
gcc could do better and took them all out. The comment needs to be 
removed.

-- Steve


> 
> 
> > +static unsigned
> > +rb_event_length(struct ring_buffer_event *event)
> > +{
> >  	switch (event->type) {
> >  	case RINGBUF_TYPE_PADDING:
> > -		/* undefined */
> > -		return -1;
> > +		if (rb_null_event(event))
> > +			/* undefined */
> > +			return -1;
> > +		return rb_event_data_length(event);
> >  
> >  	case RINGBUF_TYPE_TIME_EXTEND:
