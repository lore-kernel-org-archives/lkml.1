Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375AbZEGN0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbZEGN0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 09:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbZEGN02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 09:26:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57191 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbZEGN02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 09:26:28 -0400
Date: Thu, 7 May 2009 09:26:27 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/7] ring-buffer: make moving the tail page a separate
 function
In-Reply-To: <20090507082717.GF12285@elte.hu>
Message-ID: <alpine.DEB.2.00.0905070924250.32734@gandalf.stny.rr.com>
References: <20090507031335.815354104@goodmis.org> <20090507031434.018038090@goodmis.org> <20090507082717.GF12285@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 7 May 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> >  
> > +static struct ring_buffer_event *
> > +__rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
> > +		  unsigned type, unsigned long length, u64 *ts)
> > +{
> > +	struct buffer_page *tail_page, *commit_page;
> > +	struct ring_buffer_event *event;
> > +	unsigned long tail, write;
> > +
> > +	commit_page = cpu_buffer->commit_page;
> > +	/* we just need to protect against interrupts */
> > +	barrier();
> > +	tail_page = cpu_buffer->tail_page;
> > +	write = local_add_return(length, &tail_page->write);
> > +	tail = write - length;
> > +
> > +	/* See if we shot pass the end of this buffer page */
> > +	if (write > BUF_PAGE_SIZE)
> > +		return rb_move_tail(cpu_buffer, length, tail,
> > +				    commit_page, tail_page, ts);
> 
> Nice! The __rb_reserve_next() fast-path logic became a lot clearer.

Thanks!

> 
> The above branch might be unlikely(), right? With usual record sizes 
> of around 40 bytes, we'll have a 100 records for every page 
> overflow. That's i think within the reach of unlikely().
> 
> Depends on how much of a mess GCC makes of it though.

I looked at the assembly that gcc generates, and it is fine. gcc inlines 
the function and puts it at the end, thus it already treats it as an 
unlikely. I would like to avoid adding unlikely annotations when possible.

-- Steve

