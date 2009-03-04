Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbZCDDna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbZCDDna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 22:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZCDDnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 22:43:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53408 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbZCDDnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 22:43:20 -0500
Date: Tue, 3 Mar 2009 22:43:16 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Martin Bligh <mbligh@google.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 5/5] tracing: add binary buffer files for use with
 splice
In-Reply-To: <20090303193501.0055e329.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0903032242180.6862@gandalf.stny.rr.com>
References: <20090304024921.153061228@goodmis.org> <20090304025251.015368537@goodmis.org> <20090303193501.0055e329.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 3 Mar 2009, Andrew Morton wrote:

> On Tue, 03 Mar 2009 21:49:26 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > +static ssize_t
> > +tracing_buffers_read(struct file *filp, char __user *ubuf,
> > +		     size_t count, loff_t *ppos)
> > +{
> > +	struct ftrace_buffer_info *info = filp->private_data;
> > +	unsigned int pos;
> > +	ssize_t ret;
> > +	size_t size;
> > +
> > +	/* Do we have previous read data to read? */
> > +	if (info->read < PAGE_SIZE)
> > +		goto read;
> > +
> > +	info->read = 0;
> > +
> > +	ret = ring_buffer_read_page(info->tr->buffer,
> > +				    &info->spare,
> > +				    count,
> > +				    info->cpu, 0);
> > +	if (ret < 0)
> > +		return 0;
> > +
> > +	pos = ring_buffer_page_len(info->spare);
> > +
> > +	if (pos < PAGE_SIZE)
> > +		memset(info->spare + pos, 0, PAGE_SIZE - pos);
> > +
> > +read:
> > +	size = PAGE_SIZE - info->read;
> > +	if (size > count)
> > +		size = count;
> > +
> > +	ret = copy_to_user(ubuf, info->spare + info->read, size);
> > +	if (ret)
> > +		return -EFAULT;
> 
> Conventionally a read() system call will return the number of bytes
> copied, and will only return -EFOO if the number of bytes copied was
> zero.
> 
> Lots of parts of the kernel break this, but it's usually device drivers
> and scruffy pseudo files, in which case a partial file read doesn't
> make much sense.  This doesn't make the broken behaviour right, but at
> least we have a bit of a weaselly excuse in that case.
> 

I just went by the read man page:

       EFAULT buf is outside your accessible address space.

-- Steve

