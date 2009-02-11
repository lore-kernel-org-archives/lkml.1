Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbZBKNUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbZBKNUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 08:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbZBKNUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 08:20:05 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:63392 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556AbZBKNUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 08:20:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=M3lQFW85LVneRQCPQI3ty//1b9r1V8G7alYhZOpUePeTXBnJKxRPI9r/XJ7j6GN64i
         Oey624mCe9ONOKblMzdIt8oQCeox3NVruJ1gdNrUMpQnebme10N+Y5L8RIxENke/gFSO
         Dx1PRgKn4hGgZJmFrB6XJ3mAFQUmO86yvg4ys=
Date: Wed, 11 Feb 2009 14:19:58 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] trace: splice support for tracing_pipe
Message-ID: <20090211131957.GA5914@nowhere>
References: <cover.1234159200.git.eduard.munteanu@linux360.ro> <83d0bfae11560e926bea9c9e572d6facef145b47.1234159200.git.eduard.munteanu@linux360.ro> <da7111334b2e95966758bf982a7bcf3b31ccba9c.1234159200.git.eduard.munteanu@linux360.ro> <alpine.DEB.1.10.0902091048310.14528@gandalf.stny.rr.com> <20090211123526.GF16535@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090211123526.GF16535@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 01:35:26PM +0100, Ingo Molnar wrote:
> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Mon, 9 Feb 2009, Eduard - Gabriel Munteanu wrote:
> > > +
> > > +static ssize_t tracing_splice_read_pipe(struct file *filp,
> > > +					loff_t *ppos,
> > > +					struct pipe_inode_info *pipe,
> > > +					size_t len,
> > > +					unsigned int flags)
> > > +{
> > > +	struct page *pages[PIPE_BUFFERS];
> > > +	struct partial_page partial[PIPE_BUFFERS];
> > > +	struct trace_iterator *iter = filp->private_data;
> > > +	struct splice_pipe_desc spd = {
> > > +		.pages = pages,
> > > +		.partial = partial,
> > > +		.nr_pages = 0, /* This gets updated below. */
> > > +		.flags = flags,
> > > +		.ops = &tracing_pipe_buf_ops,
> > > +		.spd_release = tracing_spd_release_pipe,
> > > +	};
> > 
> > Note, this is getting a little stack heavy. It is still in bounds,
> > but I get very nervous when I see structure arrays on the stack.
> > If either the structure or the array grows large, we can be in trouble.
> 
> Good point - but note that this is how splice support is implemented in
> a number of other files - so if PIPE_BUFFERS or partial_page grows in
> size, those places will fail too.
> 
> 	Ingo

I first thought they can be declared as static, since the read_pipe functions
are not supposed to be reentrant, only one reader is allowed inside the pipe
(serialized with a global mutex).
But the mutex is released while waiting, and still, I guess it should be
reentrant one day if we plan to let the user having one trace_pipe per
cpu trace.

Would a dynamic allocation be too much overhead for that?

