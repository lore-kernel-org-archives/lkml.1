Return-Path: <linux-kernel-owner+w=401wt.eu-S1753613AbZBSSIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbZBSSIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 13:08:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbZBSSIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 13:08:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51029 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbZBSSIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 13:08:39 -0500
Date: Thu, 19 Feb 2009 13:08:37 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [PATCH][git pull] tracing: limit the number of loops the ring
 buffer self test can make
In-Reply-To: <20090219092348.GD2354@elte.hu>
Message-ID: <alpine.DEB.1.10.0902191308000.30122@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0902182254570.30122@gandalf.stny.rr.com> <20090219092348.GD2354@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Feb 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Ingo,
> > 
> > I added one more fix. Thinking about the solution, although 
> > the disabling of the ring buffer is good enough to prevent the 
> > bug you hit. I became worried about a corrupted ring buffer 
> > that can cause an inifinite loop. This patch adds a fix for 
> > that too.
> 
> yes, that's a good idea too:
> 
> > @@ -23,10 +23,20 @@ static int trace_test_buffer_cpu(struct trace_array *tr, int cpu)
> >  {
> >  	struct ring_buffer_event *event;
> >  	struct trace_entry *entry;
> > +	unsigned int loops = 0;
> >  
> >  	while ((event = ring_buffer_consume(tr->buffer, cpu, NULL))) {
> >  		entry = ring_buffer_event_data(event);
> >  
> > +		/*
> > +		 * The ring buffer is a size of trace_buf_size, if
> > +		 * we loop more than the size, there's something wrong
> > +		 * with the ring buffer.
> > +		 */
> > +		if (loops++ > trace_buf_size) {
> > +			printk(KERN_CONT ".. bad ring buffer ");
> > +			goto failed;
> > +		}
> 
> Would be nice to also emit a WARN_ONCE() message about the test 
> failure, to make sure automated tests like mine pick even 
> soft-failures up.

I could put a warn on in the register_tracer code. It checks all self 
tests there, and if one fails, it disables that tracer.

-- Steve

