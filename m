Return-Path: <linux-kernel-owner+w=401wt.eu-S1753043AbYGXFJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbYGXFJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 01:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbYGXFJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 01:09:51 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:36388 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbYGXFJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 01:09:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FP76IkTI7nw4wHSTC1ZQsj/rHxJNjtS9MU+9/oUa8ciJpppCJxBTiZHJ+815Apn5KU
         5o1/gbqoCejo7tP18qr5Cjm9ziy8UhElxbtFE9f1nqD8CNZmQvwSiou3sFYKlOTyibtx
         SOPdxlZA1MK/RqVksP27lyRDN5wIhB4kAMuCU=
Subject: Re: [PATCH 1/3] relay: Fix 4 off-by-one errors occuring when
	writing to a CPU buffer.
From: Tom Zanussi <tzanussi@gmail.com>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: penberg@cs.helsinki.fi, akpm@linux-foundation.org,
       compudj@krystal.dyndns.org, linux-kernel@vger.kernel.org,
       righi.andrea@gmail.com
In-Reply-To: <20080621050632.4a7a6c16@linux360.ro>
References: <20080613040947.7465b9a5@linux360.ro>
	 <1213418437.8237.51.camel@charm-linux>
	 <20080614175223.4d3c6084@linux360.ro>
	 <1213593748.7744.34.camel@charm-linux>
	 <20080621050632.4a7a6c16@linux360.ro>
Content-Type: text/plain
Date: Thu, 24 Jul 2008 00:09:36 -0500
Message-Id: <1216876176.6392.38.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-06-21 at 05:06 +0300, Eduard - Gabriel Munteanu wrote:
> On Mon, 16 Jun 2008 00:22:27 -0500
> Tom Zanussi <tzanussi@gmail.com> wrote:
> 
> > So apparently what you're seeing is zeroes being read when there's a
> > buffer-full condition?  If so, we need to figure out exactly why
> > that's happening to see whether your fix is really what's needed; I
> > haven't seen problems in the buffer-full case before and I think your
> > fix would break it even if it fixed your read problem.  So it would
> > be good to be able to reproduce it first.
> > 
> > Tom  
> 
> Hi,
> 
> Sorry for being so late, there were some exams I had to cope with.
> 
> Although I couldn't reproduce zeros, I've come up with something I'd
> say is equally good. This has been done on a vanilla 2.6.26-rc6.
> 
> Please look at the testcase below and tell me what you think.
> 

Hi,

Yes, this is a bug - thanks for sending the nice test case.  This patch
should fix it.  BTW, if the output still looks a little different from
what you were expecting, it might make more sense after adding a
relay_test printk for each dropped event, something like this:

diff --git a/kernel/relay_test.c b/kernel/relay_test.c
index 38c2755..2d4ecb1 100644
--- a/kernel/relay_test.c
+++ b/kernel/relay_test.c
@@ -64,8 +64,23 @@ relay_test_create_buf_file(const char *filename, struct dentry *parent,
 				   buf, &relay_file_operations);
 }
 
+static int relay_test_subbuf_start(struct rchan_buf *buf,
+				   void *subbuf,
+				   void *prev_subbuf,
+				   size_t prev_padding)
+{
+	if (relay_buf_full(buf)) {
+		printk(KERN_INFO "relay_test: Dropped event on CPU %lu.\n",
+		       smp_processor_id());
+		return 0;
+	}
+
+	return 1;
+}
+
 static struct rchan_callbacks relay_test_callbacks = {
 	.create_buf_file = relay_test_create_buf_file,
+	.subbuf_start = relay_test_subbuf_start,
 };
 
 static int relay_test_init(void)


Thanks,

Tom

---

In relay's current read implementation, if the buffer is completely full
but hasn't triggered the buffer-full condition (i.e. the last write
didn't cross the subbuffer boundary) and the last subbuffer is exactly
full, the subbuffer accounting code erroneously finds nothing available.
This patch fixes the problem.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com> 

diff --git a/kernel/relay.c b/kernel/relay.c
index 7de644c..f5a5a96 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -832,6 +832,10 @@ static void relay_file_read_consume(struct rchan_buf *buf,
 	size_t n_subbufs = buf->chan->n_subbufs;
 	size_t read_subbuf;
 
+	if (buf->subbufs_produced == buf->subbufs_consumed &&
+	    buf->offset == buf->bytes_consumed)
+		return;
+
 	if (buf->bytes_consumed + bytes_consumed > subbuf_size) {
 		relay_subbufs_consumed(buf->chan, buf->cpu, 1);
 		buf->bytes_consumed = 0;
@@ -863,6 +867,8 @@ static int relay_file_read_avail(struct rchan_buf *buf, size_t read_pos)
 
 	relay_file_read_consume(buf, read_pos, 0);
 
+	consumed = buf->subbufs_consumed;
+
 	if (unlikely(buf->offset > subbuf_size)) {
 		if (produced == consumed)
 			return 0;
@@ -881,8 +887,12 @@ static int relay_file_read_avail(struct rchan_buf *buf, size_t read_pos)
 	if (consumed > produced)
 		produced += n_subbufs * subbuf_size;
 
-	if (consumed == produced)
+	if (consumed == produced) {
+		if (buf->offset == subbuf_size &&
+		    buf->subbufs_produced > buf->subbufs_consumed)
+			return 1;
 		return 0;
+	}
 
 	return 1;
 }




