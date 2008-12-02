Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbYLBWZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbYLBWZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 17:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbYLBWZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 17:25:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65319 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbYLBWZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 17:25:07 -0500
Date: Tue, 2 Dec 2008 17:25:04 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       srostedt@redhat.com, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/5] ring-buffer: read page interface
In-Reply-To: <20081202133654.2dfa51cd.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0812021723270.13684@gandalf.stny.rr.com>
References: <20081202203404.496794864@goodmis.org> <20081202203425.040910271@goodmis.org> <20081202133654.2dfa51cd.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2 Dec 2008, Andrew Morton wrote:

> On Tue, 02 Dec 2008 15:34:07 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > Impact: new API to ring buffer
> > 
> > This patch adds a new interface into the ring buffer that allows a
> > page to be read from the ring buffer on a given CPU. For every page
> > read, one must also be given to allow for a "swap" of the pages.
> > 
> >  rpage = ring_buffer_alloc_read_page(buffer);
> >  if (!rpage)
> > 	goto err;
> >  ret = ring_buffer_read_page(buffer, &rpage, cpu, full);
> >  if (!ret)
> > 	goto empty;
> >  process_page(rpage);
> >  ring_buffer_free_read_page(rpage);
> > 
> > The caller of these functions must handle any waits that are
> > needed to wait for new data. The ring_buffer_read_page will simply
> > return 0 if there is no data, or if "full" is set and the writer
> > is still on the current page.
> > 
> >  ...
> >
> > +static inline void *
> > +__rb_data_page_index(struct buffer_data_page *page, unsigned index)
> > +{
> > +	return page->data + index;
> > +}
> 
> Many kernel developers will fall over stunned and confused when they
> see a variable called `page' which does not have type `struct page *'. 
> This is a very strong kernel convention and this code tromps all over
> it :(
> 
> How's about renaming all of these everywhere to `bpage' or whatever?

OK, I'll send a patch to Ingo to make this update.

> 
> >
> > ...
> >
> > +	if (!local_read(&cpu_buffer->reader_page->page->commit))
> >
> 
> Rusty (I think it was Rusty) has convincingly argued that local_t is
> irredeemably busted.  I forget the details?

Really?? I've been using local for quite a bit. Using atomic seems 
overkill, since I only want to be able to protect against updates by 
interrupts. Perhaps what needs to be done is to fix local?

-- Steve

