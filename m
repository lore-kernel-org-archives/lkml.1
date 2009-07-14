Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbZGNWnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbZGNWnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 18:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756688AbZGNWnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 18:43:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41387 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250AbZGNWnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 18:43:41 -0400
Date: Tue, 14 Jul 2009 18:43:40 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] ring_buffer: fix warning
In-Reply-To: <20090714141544.GA5728@nowhere>
Message-ID: <alpine.DEB.2.00.0907141841440.32740@gandalf.stny.rr.com>
References: <4A5C3549.7000905@cn.fujitsu.com> <20090714141544.GA5728@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 14 Jul 2009, Frederic Weisbecker wrote:

> On Tue, Jul 14, 2009 at 03:35:37PM +0800, Lai Jiangshan wrote:
> > 
> > kernel/trace/ring_buffer.c: In function 'rb_tail_page_update':
> > kernel/trace/ring_buffer.c:849: warning: value computed is not used
> > kernel/trace/ring_buffer.c:850: warning: value computed is not used
> > 
> > Add a "(void)" to fix this warning.
> > 
> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > ---
> > diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> > index e648ba4..d371279 100644
> > --- a/kernel/trace/ring_buffer.c
> > +++ b/kernel/trace/ring_buffer.c
> > @@ -846,8 +846,8 @@ static int rb_tail_page_update(struct ring_buffer_per_cpu *cpu_buffer,
> >  		 * not come in and change it. In which case, we
> >  		 * do not want to modify it.
> >  		 */
> > -		local_cmpxchg(&next_page->write, old_write, val);
> > -		local_cmpxchg(&next_page->entries, old_entries, eval);
> > +		(void)local_cmpxchg(&next_page->write, old_write, val);
> > +		(void)local_cmpxchg(&next_page->entries, old_entries, eval);
> >  
> >  		/*
> >  		 * No need to worry about races with clearing out the commit.
> 
> 
> Looks good. Indeed the rest of the path remains the same, whether the
> interrupts have already won the race or not.

Yes, but it needs a comment:

	/*
	 * We add (void) to let the compiler know that we do not care 
	 * about the return value of these functions. We use the
	 * cmpxchg to only update if an interrupt did not already
	 * do it for us. If the cmpxchg fails, we don't care.
	 */

Then you can have my:

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> 
> Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> 
