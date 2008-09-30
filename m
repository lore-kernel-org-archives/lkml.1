Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbYI3FP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbYI3FP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 01:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbYI3FPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 01:15:15 -0400
Received: from qmta05.westchester.pa.mail.comcast.net ([76.96.62.48]:59004
	"EHLO QMTA05.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751157AbYI3FPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 01:15:12 -0400
X-Authority-Analysis: v=1.0 c=1 a=s2ll_0Qm4N0A:10 a=50Yn32J636AA:10
 a=SxGOc3d1EUYGlrl4QggA:9 a=JoksKTwBIJvVK_AaOj4A:7
 a=Ndx4bo2f_WkGmtkw8EqbhZ8ivzIA:4 a=wZiCkNY6m2YA:10 a=si9q_4b84H0A:10
 a=WuK_CZDBSqoA:10
Subject: Re: [RFC PATCH 7/11] relay - Remove padding-related code from
	relay_read()/relay_splice_read() et al.
From: Tom Zanussi <zanussi@comcast.net>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>, Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20080929162743.GA15472@Krystal>
References: <1222666828.7637.180.camel@charm-linux>
	 <20080929162743.GA15472@Krystal>
Content-Type: text/plain
Date: Tue, 30 Sep 2008 00:04:40 -0500
Message-Id: <1222751080.8703.133.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-09-29 at 12:27 -0400, Mathieu Desnoyers wrote:
> * Tom Zanussi (zanussi@comcast.net) wrote:
> > Remove padding-related code from relay_read()/relay_splice_read() et al.
> > 
> > Because we no longer write padding, we no longer have to read it or
> > account for it anywhere else, greatly simplifying the related code.
> > 
> > Signed-off-by: Tom Zanussi <zanussi@comcast.net>
> > 
> 
> Hi Tom,
> 
> This question might sound a bit dumb, but I'll ask anyway : why do you
> implement a splice_read rather than a splice_write in relay ?
> 
> splice_read allows reading information from a file or from a socket to a
> pipe, while splice_write does the opposite.
> 
> So if you implement a relay splice_read, you probably consider the
> relay buffers to be a "file", so you really have to send the information
> to a pipe, and then you have to use this pipe to send the data
> elsewhere.
> 

Yeah, that's pretty much it.  In the case of splicing from a relay file
to an output file, the path is basically relay->pipe->outfile. To do the
relay->pipe part, do_splice_to() needs a splice_read() implementation,
which for relay is relay_splice_read().

> My first reaction when looking at the splice implementation is that what
> we would really want is a splice_write which would take the data from a
> pipe (actually, we would have to write an actor which would make the
> relay buffer behave like a pipe) and write it either to disk or to a
> socket.
> 

Yes, I think a relay splice_write implementation would take the data
from a pipe but would write it into a relay buffer i.e.
input->pipe->relay with do_splice_from() calling relay's splice_write()
implementation.  Once the data is in relay, getting it from there to the
disk or socket would follow the same path as the relay->outfile path.
At least that's the way I think of it.

For tracing, it probably doesn't make sense to splice_write file data
into relay, but it would to splice in pages of data from other tracing
sources, such as for example pages of trace data from userspace tracers,
which they could do using vmsplice i.e. userpages->pipe->relay. 

If you used SPLICE_F_MOVE for the relay->outfile part and SPLICE_F_GIFT
for the userpages->relay part, you'd get the trace data directly from
the writer to the destination without any copying.  Unfortunately,
SPLICE_F_MOVE support was removed so this won't really work right now.
Also, pages would have to be kept in a linked list instead of an array
for this.

Also, for this scheme to work, your trace stream would need to be able
to tolerate having pages from different sources inserted basically
anywhere in the stream, which means each page would have to be
self-contained.  If you could atomically insert a set of pages, you
could I guess make that a self-contained unit as well and have some kind
of flag that says the next n pages in the stream are part of the current
event. That might provide a simple way to have multi-page events or to
log blobs of binary data - rather than reserving space for them, you'd
just splice the pages directly into the buffer.

So maybe splice_read and splice_write on a list of pages, some write
functions for tracing into the pages and a userspace post-processor to
demultiplex it all is all you need, at least for the streaming-to-disk
type of tracing lttng does.

Tom

> Is there something I am misunderstanding here ?
> 
> Thanks,
> 
> Mathieu
> 
> > ---
> >  kernel/relay.c |  149
> > ++++++++------------------------------------------------
> >  1 files changed, 20 insertions(+), 129 deletions(-)
> > 
> > diff --git a/kernel/relay.c b/kernel/relay.c
> > index d382528..b55466d 100644
> > --- a/kernel/relay.c
> > +++ b/kernel/relay.c
> > @@ -965,72 +965,13 @@ static void relay_file_read_consume(struct
> > rchan_buf *buf,
> >  				    size_t bytes_consumed)
> >  {
> >  	size_t subbuf_size = buf->chan->subbuf_size;
> > -	size_t n_subbufs = buf->chan->n_subbufs;
> > -	size_t read_subbuf;
> > -
> > -	if (buf->subbufs_produced == buf->subbufs_consumed &&
> > -	    buf->offset == buf->bytes_consumed)
> > -		return;
> > -
> > -	if (buf->bytes_consumed + bytes_consumed > subbuf_size) {
> > -		relay_subbufs_consumed(buf->chan, buf->cpu, 1);
> > -		buf->bytes_consumed = 0;
> > -	}
> >  
> >  	buf->bytes_consumed += bytes_consumed;
> > -	if (!read_pos)
> > -		read_subbuf = buf->subbufs_consumed % n_subbufs;
> > -	else
> > -		read_subbuf = read_pos / buf->chan->subbuf_size;
> > -	if (buf->bytes_consumed + buf->padding[read_subbuf] == subbuf_size) {
> > -		if ((read_subbuf == buf->subbufs_produced % n_subbufs) &&
> > -		    (buf->offset == subbuf_size))
> > -			return;
> > -		relay_subbufs_consumed(buf->chan, buf->cpu, 1);
> > -		buf->bytes_consumed = 0;
> > -	}
> > -}
> >  
> > -/*
> > - *	relay_file_read_avail - boolean, are there unconsumed bytes
> > available?
> > - */
> > -static int relay_file_read_avail(struct rchan_buf *buf, size_t
> > read_pos)
> > -{
> > -	size_t subbuf_size = buf->chan->subbuf_size;
> > -	size_t n_subbufs = buf->chan->n_subbufs;
> > -	size_t produced = buf->subbufs_produced;
> > -	size_t consumed = buf->subbufs_consumed;
> > -
> > -	relay_file_read_consume(buf, read_pos, 0);
> > -
> > -	consumed = buf->subbufs_consumed;
> > -
> > -	if (unlikely(buf->offset > subbuf_size)) {
> > -		if (produced == consumed)
> > -			return 0;
> > -		return 1;
> > -	}
> > -
> > -	if (unlikely(produced - consumed >= n_subbufs)) {
> > -		consumed = produced - n_subbufs + 1;
> > -		buf->subbufs_consumed = consumed;
> > +	if (buf->bytes_consumed == subbuf_size) {
> > +		relay_subbufs_consumed(buf->chan, buf->cpu, 1);
> >  		buf->bytes_consumed = 0;
> >  	}
> > -
> > -	produced = (produced % n_subbufs) * subbuf_size + buf->offset;
> > -	consumed = (consumed % n_subbufs) * subbuf_size + buf->bytes_consumed;
> > -
> > -	if (consumed > produced)
> > -		produced += n_subbufs * subbuf_size;
> > -
> > -	if (consumed == produced) {
> > -		if (buf->offset == subbuf_size &&
> > -		    buf->subbufs_produced > buf->subbufs_consumed)
> > -			return 1;
> > -		return 0;
> > -	}
> > -
> > -	return 1;
> >  }
> >  
> >  /**
> > @@ -1041,21 +982,19 @@ static int relay_file_read_avail(struct rchan_buf
> > *buf, size_t read_pos)
> >  static size_t relay_file_read_subbuf_avail(size_t read_pos,
> >  					   struct rchan_buf *buf)
> >  {
> > -	size_t padding, avail = 0;
> > +	size_t avail;
> >  	size_t read_subbuf, read_offset, write_subbuf, write_offset;
> >  	size_t subbuf_size = buf->chan->subbuf_size;
> >  
> >  	write_subbuf = (buf->data - buf->start) / subbuf_size;
> > -	write_offset = buf->offset > subbuf_size ? subbuf_size : buf->offset;
> > +	write_offset = buf->offset;
> >  	read_subbuf = read_pos / subbuf_size;
> >  	read_offset = read_pos % subbuf_size;
> > -	padding = buf->padding[read_subbuf];
> >  
> > -	if (read_subbuf == write_subbuf) {
> > -		if (read_offset + padding < write_offset)
> > -			avail = write_offset - (read_offset + padding);
> > -	} else
> > -		avail = (subbuf_size - padding) - read_offset;
> > +	avail = subbuf_size - read_offset;
> > +
> > +	if (read_subbuf == write_subbuf && read_offset < write_offset)
> > +		avail = write_offset - read_offset;
> >  
> >  	return avail;
> >  }
> > @@ -1065,28 +1004,17 @@ static size_t
> > relay_file_read_subbuf_avail(size_t read_pos,
> >   *	@read_pos: file read position
> >   *	@buf: relay channel buffer
> >   *
> > - *	If the @read_pos is in the middle of padding, return the
> > - *	position of the first actually available byte, otherwise
> > - *	return the original value.
> > + *	If the @read_pos is 0, return the position of the first
> > + *	unconsumed byte, otherwise return the original value.
> >   */
> >  static size_t relay_file_read_start_pos(size_t read_pos,
> >  					struct rchan_buf *buf)
> >  {
> > -	size_t read_subbuf, padding, padding_start, padding_end;
> >  	size_t subbuf_size = buf->chan->subbuf_size;
> > -	size_t n_subbufs = buf->chan->n_subbufs;
> > -	size_t consumed = buf->subbufs_consumed % n_subbufs;
> > +	size_t consumed = buf->subbufs_consumed % buf->chan->n_subbufs;
> >  
> >  	if (!read_pos)
> >  		read_pos = consumed * subbuf_size + buf->bytes_consumed;
> > -	read_subbuf = read_pos / subbuf_size;
> > -	padding = buf->padding[read_subbuf];
> > -	padding_start = (read_subbuf + 1) * subbuf_size - padding;
> > -	padding_end = (read_subbuf + 1) * subbuf_size;
> > -	if (read_pos >= padding_start && read_pos < padding_end) {
> > -		read_subbuf = (read_subbuf + 1) % n_subbufs;
> > -		read_pos = read_subbuf * subbuf_size;
> > -	}
> >  
> >  	return read_pos;
> >  }
> > @@ -1101,17 +1029,9 @@ static size_t relay_file_read_end_pos(struct
> > rchan_buf *buf,
> >  				      size_t read_pos,
> >  				      size_t count)
> >  {
> > -	size_t read_subbuf, padding, end_pos;
> > -	size_t subbuf_size = buf->chan->subbuf_size;
> > -	size_t n_subbufs = buf->chan->n_subbufs;
> > +	size_t end_pos = read_pos + count;
> >  
> > -	read_subbuf = read_pos / subbuf_size;
> > -	padding = buf->padding[read_subbuf];
> > -	if (read_pos % subbuf_size + count + padding == subbuf_size)
> > -		end_pos = (read_subbuf + 1) * subbuf_size;
> > -	else
> > -		end_pos = read_pos + count;
> > -	if (end_pos >= subbuf_size * n_subbufs)
> > +	if (end_pos >= buf->chan->subbuf_size * buf->chan->n_subbufs)
> >  		end_pos = 0;
> >  
> >  	return end_pos;
> > @@ -1165,9 +1085,6 @@ static ssize_t relay_file_read_subbufs(struct file
> > *filp, loff_t *ppos,
> >  
> >  	mutex_lock(&filp->f_path.dentry->d_inode->i_mutex);
> >  	do {
> > -		if (!relay_file_read_avail(buf, *ppos))
> > -			break;
> > -
> >  		read_start = relay_file_read_start_pos(*ppos, buf);
> >  		avail = relay_file_read_subbuf_avail(read_start, buf);
> >  		if (!avail)
> > @@ -1242,8 +1159,7 @@ static int subbuf_splice_actor(struct file *in,
> >  			       loff_t *ppos,
> >  			       struct pipe_inode_info *pipe,
> >  			       size_t len,
> > -			       unsigned int flags,
> > -			       int *nonpad_ret)
> > +			       unsigned int flags)
> >  {
> >  	unsigned int pidx, poff, total_len, subbuf_pages, nr_pages, ret;
> >  	struct rchan_buf *rbuf = in->private_data;
> > @@ -1251,9 +1167,6 @@ static int subbuf_splice_actor(struct file *in,
> >  	uint64_t pos = (uint64_t) *ppos;
> >  	uint32_t alloc_size = (uint32_t) rbuf->chan->alloc_size;
> >  	size_t read_start = (size_t) do_div(pos, alloc_size);
> > -	size_t read_subbuf = read_start / subbuf_size;
> > -	size_t padding = rbuf->padding[read_subbuf];
> > -	size_t nonpad_end = read_subbuf * subbuf_size + subbuf_size - padding;
> >  	struct page *pages[PIPE_BUFFERS];
> >  	struct partial_page partial[PIPE_BUFFERS];
> >  	struct splice_pipe_desc spd = {
> > @@ -1265,7 +1178,8 @@ static int subbuf_splice_actor(struct file *in,
> >  		.spd_release = relay_page_release,
> >  	};
> >  
> > -	if (rbuf->subbufs_produced == rbuf->subbufs_consumed)
> > +	if (rbuf->subbufs_produced == rbuf->subbufs_consumed &&
> > +	    rbuf->offset == rbuf->bytes_consumed)
> >  		return 0;
> >  
> >  	/*
> > @@ -1280,46 +1194,25 @@ static int subbuf_splice_actor(struct file *in,
> >  	nr_pages = min_t(unsigned int, subbuf_pages, PIPE_BUFFERS);
> >  
> >  	for (total_len = 0; spd.nr_pages < nr_pages; spd.nr_pages++) {
> > -		unsigned int this_len, this_end, private;
> > -		unsigned int cur_pos = read_start + total_len;
> > +		unsigned int this_len;
> >  
> >  		if (!len)
> >  			break;
> >  
> >  		this_len = min_t(unsigned long, len, PAGE_SIZE - poff);
> > -		private = this_len;
> >  
> >  		spd.pages[spd.nr_pages] = rbuf->page_array[pidx];
> >  		spd.partial[spd.nr_pages].offset = poff;
> >  
> > -		this_end = cur_pos + this_len;
> > -		if (this_end >= nonpad_end) {
> > -			this_len = nonpad_end - cur_pos;
> > -			private = this_len + padding;
> > -		}
> >  		spd.partial[spd.nr_pages].len = this_len;
> > -		spd.partial[spd.nr_pages].private = private;
> >  
> >  		len -= this_len;
> >  		total_len += this_len;
> >  		poff = 0;
> >  		pidx = (pidx + 1) % subbuf_pages;
> > -
> > -		if (this_end >= nonpad_end) {
> > -			spd.nr_pages++;
> > -			break;
> > -		}
> >  	}
> >  
> > -	if (!spd.nr_pages)
> > -		return 0;
> > -
> > -	ret = *nonpad_ret = splice_to_pipe(pipe, &spd);
> > -	if (ret < 0 || ret < total_len)
> > -		return ret;
> > -
> > -        if (read_start + ret == nonpad_end)
> > -                ret += padding;
> > +	ret = splice_to_pipe(pipe, &spd);
> >  
> >          return ret;
> >  }
> > @@ -1332,13 +1225,12 @@ static ssize_t relay_file_splice_read(struct
> > file *in,
> >  {
> >  	ssize_t spliced;
> >  	int ret;
> > -	int nonpad_ret = 0;
> >  
> >  	ret = 0;
> >  	spliced = 0;
> >  
> >  	while (len && !spliced) {
> > -		ret = subbuf_splice_actor(in, ppos, pipe, len, flags, &nonpad_ret);
> > +		ret = subbuf_splice_actor(in, ppos, pipe, len, flags);
> >  		if (ret < 0)
> >  			break;
> >  		else if (!ret) {
> > @@ -1355,8 +1247,7 @@ static ssize_t relay_file_splice_read(struct file
> > *in,
> >  			len = 0;
> >  		else
> >  			len -= ret;
> > -		spliced += nonpad_ret;
> > -		nonpad_ret = 0;
> > +		spliced += ret;
> >  	}
> >  
> >  	if (spliced)
> > -- 
> > 1.5.3.5
> > 
> > 
> > 
> 

