Return-Path: <linux-kernel-owner+w=401wt.eu-S1755042AbYIYGJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbYIYGJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 02:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754365AbYIYGII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 02:08:08 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:36147 "EHLO
	QMTA10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754321AbYIYGIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 02:08:06 -0400
X-Authority-Analysis: v=1.0 c=1 a=SbUXHhBrzMYA:10 a=sDv5-TTEXxYA:10
 a=e9xhmM40zqqwFlG3hwAA:9 a=nQ0vRzC8zil8t1hcVc8A:7
 a=VCb2D9vS5JHHNJKuH0SIg0MUzSAA:4 a=wZiCkNY6m2YA:10 a=eZLSmJVMEtUA:10
Subject: [RFC PATCH 7/8] relay - Remove padding-related code from
	relay_read()/relay_splice_read() et al.
From: Tom Zanussi <zanussi@comcast.net>
To: Martin Bligh <mbligh@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, prasad@linux.vnet.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>
In-Reply-To: <1222228215.7761.0.camel@charm-linux>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
	 <1221869279.8359.31.camel@lappy.programming.kicks-ass.net>
	 <20080922140740.GB5279@in.ibm.com>
	 <1222094724.16700.11.camel@lappy.programming.kicks-ass.net>
	 <1222147545.6875.135.camel@charm-linux>
	 <33307c790809230700o4bf0d22fg8ab2dcb904f7d66c@mail.gmail.com>
	 <1222228215.7761.0.camel@charm-linux>
Content-Type: text/plain
Date: Thu, 25 Sep 2008 01:07:59 -0500
Message-Id: <1222322879.6435.62.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove padding-related code from relay_read()/relay_splice_read() et al.

Because we no longer write padding, we no longer have to read it or
account for it anywhere else, greatly simplifying the related code.
---
 kernel/relay.c |  149 ++++++++------------------------------------------------
 1 files changed, 20 insertions(+), 129 deletions(-)

diff --git a/kernel/relay.c b/kernel/relay.c
index 15e4de2..21b3e19 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -966,72 +966,13 @@ static void relay_file_read_consume(struct rchan_buf *buf,
 				    size_t bytes_consumed)
 {
 	size_t subbuf_size = buf->chan->subbuf_size;
-	size_t n_subbufs = buf->chan->n_subbufs;
-	size_t read_subbuf;
-
-	if (buf->subbufs_produced == buf->subbufs_consumed &&
-	    buf->offset == buf->bytes_consumed)
-		return;
-
-	if (buf->bytes_consumed + bytes_consumed > subbuf_size) {
-		relay_subbufs_consumed(buf->chan, buf->cpu, 1);
-		buf->bytes_consumed = 0;
-	}
 
 	buf->bytes_consumed += bytes_consumed;
-	if (!read_pos)
-		read_subbuf = buf->subbufs_consumed % n_subbufs;
-	else
-		read_subbuf = read_pos / buf->chan->subbuf_size;
-	if (buf->bytes_consumed + buf->padding[read_subbuf] == subbuf_size) {
-		if ((read_subbuf == buf->subbufs_produced % n_subbufs) &&
-		    (buf->offset == subbuf_size))
-			return;
-		relay_subbufs_consumed(buf->chan, buf->cpu, 1);
-		buf->bytes_consumed = 0;
-	}
-}
 
-/*
- *	relay_file_read_avail - boolean, are there unconsumed bytes available?
- */
-static int relay_file_read_avail(struct rchan_buf *buf, size_t read_pos)
-{
-	size_t subbuf_size = buf->chan->subbuf_size;
-	size_t n_subbufs = buf->chan->n_subbufs;
-	size_t produced = buf->subbufs_produced;
-	size_t consumed = buf->subbufs_consumed;
-
-	relay_file_read_consume(buf, read_pos, 0);
-
-	consumed = buf->subbufs_consumed;
-
-	if (unlikely(buf->offset > subbuf_size)) {
-		if (produced == consumed)
-			return 0;
-		return 1;
-	}
-
-	if (unlikely(produced - consumed >= n_subbufs)) {
-		consumed = produced - n_subbufs + 1;
-		buf->subbufs_consumed = consumed;
+	if (buf->bytes_consumed == subbuf_size) {
+		relay_subbufs_consumed(buf->chan, buf->cpu, 1);
 		buf->bytes_consumed = 0;
 	}
-
-	produced = (produced % n_subbufs) * subbuf_size + buf->offset;
-	consumed = (consumed % n_subbufs) * subbuf_size + buf->bytes_consumed;
-
-	if (consumed > produced)
-		produced += n_subbufs * subbuf_size;
-
-	if (consumed == produced) {
-		if (buf->offset == subbuf_size &&
-		    buf->subbufs_produced > buf->subbufs_consumed)
-			return 1;
-		return 0;
-	}
-
-	return 1;
 }
 
 /**
@@ -1042,21 +983,19 @@ static int relay_file_read_avail(struct rchan_buf *buf, size_t read_pos)
 static size_t relay_file_read_subbuf_avail(size_t read_pos,
 					   struct rchan_buf *buf)
 {
-	size_t padding, avail = 0;
+	size_t avail;
 	size_t read_subbuf, read_offset, write_subbuf, write_offset;
 	size_t subbuf_size = buf->chan->subbuf_size;
 
 	write_subbuf = (buf->data - buf->start) / subbuf_size;
-	write_offset = buf->offset > subbuf_size ? subbuf_size : buf->offset;
+	write_offset = buf->offset;
 	read_subbuf = read_pos / subbuf_size;
 	read_offset = read_pos % subbuf_size;
-	padding = buf->padding[read_subbuf];
 
-	if (read_subbuf == write_subbuf) {
-		if (read_offset + padding < write_offset)
-			avail = write_offset - (read_offset + padding);
-	} else
-		avail = (subbuf_size - padding) - read_offset;
+	avail = subbuf_size - read_offset;
+
+	if (read_subbuf == write_subbuf && read_offset < write_offset)
+		avail = write_offset - read_offset;
 
 	return avail;
 }
@@ -1066,28 +1005,17 @@ static size_t relay_file_read_subbuf_avail(size_t read_pos,
  *	@read_pos: file read position
  *	@buf: relay channel buffer
  *
- *	If the @read_pos is in the middle of padding, return the
- *	position of the first actually available byte, otherwise
- *	return the original value.
+ *	If the @read_pos is 0, return the position of the first
+ *	unconsumed byte, otherwise return the original value.
  */
 static size_t relay_file_read_start_pos(size_t read_pos,
 					struct rchan_buf *buf)
 {
-	size_t read_subbuf, padding, padding_start, padding_end;
 	size_t subbuf_size = buf->chan->subbuf_size;
-	size_t n_subbufs = buf->chan->n_subbufs;
-	size_t consumed = buf->subbufs_consumed % n_subbufs;
+	size_t consumed = buf->subbufs_consumed % buf->chan->n_subbufs;
 
 	if (!read_pos)
 		read_pos = consumed * subbuf_size + buf->bytes_consumed;
-	read_subbuf = read_pos / subbuf_size;
-	padding = buf->padding[read_subbuf];
-	padding_start = (read_subbuf + 1) * subbuf_size - padding;
-	padding_end = (read_subbuf + 1) * subbuf_size;
-	if (read_pos >= padding_start && read_pos < padding_end) {
-		read_subbuf = (read_subbuf + 1) % n_subbufs;
-		read_pos = read_subbuf * subbuf_size;
-	}
 
 	return read_pos;
 }
@@ -1102,17 +1030,9 @@ static size_t relay_file_read_end_pos(struct rchan_buf *buf,
 				      size_t read_pos,
 				      size_t count)
 {
-	size_t read_subbuf, padding, end_pos;
-	size_t subbuf_size = buf->chan->subbuf_size;
-	size_t n_subbufs = buf->chan->n_subbufs;
+	size_t end_pos = read_pos + count;
 
-	read_subbuf = read_pos / subbuf_size;
-	padding = buf->padding[read_subbuf];
-	if (read_pos % subbuf_size + count + padding == subbuf_size)
-		end_pos = (read_subbuf + 1) * subbuf_size;
-	else
-		end_pos = read_pos + count;
-	if (end_pos >= subbuf_size * n_subbufs)
+	if (end_pos >= buf->chan->subbuf_size * buf->chan->n_subbufs)
 		end_pos = 0;
 
 	return end_pos;
@@ -1166,9 +1086,6 @@ static ssize_t relay_file_read_subbufs(struct file *filp, loff_t *ppos,
 
 	mutex_lock(&filp->f_path.dentry->d_inode->i_mutex);
 	do {
-		if (!relay_file_read_avail(buf, *ppos))
-			break;
-
 		read_start = relay_file_read_start_pos(*ppos, buf);
 		avail = relay_file_read_subbuf_avail(read_start, buf);
 		if (!avail)
@@ -1243,8 +1160,7 @@ static int subbuf_splice_actor(struct file *in,
 			       loff_t *ppos,
 			       struct pipe_inode_info *pipe,
 			       size_t len,
-			       unsigned int flags,
-			       int *nonpad_ret)
+			       unsigned int flags)
 {
 	unsigned int pidx, poff, total_len, subbuf_pages, nr_pages, ret;
 	struct rchan_buf *rbuf = in->private_data;
@@ -1252,9 +1168,6 @@ static int subbuf_splice_actor(struct file *in,
 	uint64_t pos = (uint64_t) *ppos;
 	uint32_t alloc_size = (uint32_t) rbuf->chan->alloc_size;
 	size_t read_start = (size_t) do_div(pos, alloc_size);
-	size_t read_subbuf = read_start / subbuf_size;
-	size_t padding = rbuf->padding[read_subbuf];
-	size_t nonpad_end = read_subbuf * subbuf_size + subbuf_size - padding;
 	struct page *pages[PIPE_BUFFERS];
 	struct partial_page partial[PIPE_BUFFERS];
 	struct splice_pipe_desc spd = {
@@ -1266,7 +1179,8 @@ static int subbuf_splice_actor(struct file *in,
 		.spd_release = relay_page_release,
 	};
 
-	if (rbuf->subbufs_produced == rbuf->subbufs_consumed)
+	if (rbuf->subbufs_produced == rbuf->subbufs_consumed &&
+	    rbuf->offset == rbuf->bytes_consumed)
 		return 0;
 
 	/*
@@ -1281,46 +1195,25 @@ static int subbuf_splice_actor(struct file *in,
 	nr_pages = min_t(unsigned int, subbuf_pages, PIPE_BUFFERS);
 
 	for (total_len = 0; spd.nr_pages < nr_pages; spd.nr_pages++) {
-		unsigned int this_len, this_end, private;
-		unsigned int cur_pos = read_start + total_len;
+		unsigned int this_len;
 
 		if (!len)
 			break;
 
 		this_len = min_t(unsigned long, len, PAGE_SIZE - poff);
-		private = this_len;
 
 		spd.pages[spd.nr_pages] = rbuf->page_array[pidx];
 		spd.partial[spd.nr_pages].offset = poff;
 
-		this_end = cur_pos + this_len;
-		if (this_end >= nonpad_end) {
-			this_len = nonpad_end - cur_pos;
-			private = this_len + padding;
-		}
 		spd.partial[spd.nr_pages].len = this_len;
-		spd.partial[spd.nr_pages].private = private;
 
 		len -= this_len;
 		total_len += this_len;
 		poff = 0;
 		pidx = (pidx + 1) % subbuf_pages;
-
-		if (this_end >= nonpad_end) {
-			spd.nr_pages++;
-			break;
-		}
 	}
 
-	if (!spd.nr_pages)
-		return 0;
-
-	ret = *nonpad_ret = splice_to_pipe(pipe, &spd);
-	if (ret < 0 || ret < total_len)
-		return ret;
-
-        if (read_start + ret == nonpad_end)
-                ret += padding;
+	ret = splice_to_pipe(pipe, &spd);
 
         return ret;
 }
@@ -1333,13 +1226,12 @@ static ssize_t relay_file_splice_read(struct file *in,
 {
 	ssize_t spliced;
 	int ret;
-	int nonpad_ret = 0;
 
 	ret = 0;
 	spliced = 0;
 
 	while (len && !spliced) {
-		ret = subbuf_splice_actor(in, ppos, pipe, len, flags, &nonpad_ret);
+		ret = subbuf_splice_actor(in, ppos, pipe, len, flags);
 		if (ret < 0)
 			break;
 		else if (!ret) {
@@ -1356,8 +1248,7 @@ static ssize_t relay_file_splice_read(struct file *in,
 			len = 0;
 		else
 			len -= ret;
-		spliced += nonpad_ret;
-		nonpad_ret = 0;
+		spliced += ret;
 	}
 
 	if (spliced)
-- 
1.5.3.5



