Return-Path: <linux-kernel-owner+w=401wt.eu-S1762717AbZEGOBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762717AbZEGOBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 10:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762095AbZEGN5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 09:57:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33117 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762081AbZEGN5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 09:57:05 -0400
Date: Thu, 7 May 2009 15:56:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/7] ring-buffer: make moving the tail page a separate
	function
Message-ID: <20090507135645.GC481@elte.hu>
References: <20090507031335.815354104@goodmis.org> <20090507031434.018038090@goodmis.org> <20090507082717.GF12285@elte.hu> <alpine.DEB.2.00.0905070924250.32734@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905070924250.32734@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Thu, 7 May 2009, Ingo Molnar wrote:
> 
> > 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > >  
> > > +static struct ring_buffer_event *
> > > +__rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
> > > +		  unsigned type, unsigned long length, u64 *ts)
> > > +{
> > > +	struct buffer_page *tail_page, *commit_page;
> > > +	struct ring_buffer_event *event;
> > > +	unsigned long tail, write;
> > > +
> > > +	commit_page = cpu_buffer->commit_page;
> > > +	/* we just need to protect against interrupts */
> > > +	barrier();
> > > +	tail_page = cpu_buffer->tail_page;
> > > +	write = local_add_return(length, &tail_page->write);
> > > +	tail = write - length;
> > > +
> > > +	/* See if we shot pass the end of this buffer page */
> > > +	if (write > BUF_PAGE_SIZE)
> > > +		return rb_move_tail(cpu_buffer, length, tail,
> > > +				    commit_page, tail_page, ts);
> > 
> > Nice! The __rb_reserve_next() fast-path logic became a lot clearer.
> 
> Thanks!
> 
> > 
> > The above branch might be unlikely(), right? With usual record sizes 
> > of around 40 bytes, we'll have a 100 records for every page 
> > overflow. That's i think within the reach of unlikely().
> > 
> > Depends on how much of a mess GCC makes of it though.
> 
> I looked at the assembly that gcc generates, and it is fine. gcc 
> inlines the function and puts it at the end, thus it already 
> treats it as an unlikely. I would like to avoid adding unlikely 
> annotations when possible.

Fair enough!

	Ingo
