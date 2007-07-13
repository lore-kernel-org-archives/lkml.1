Return-Path: <linux-kernel-owner+w=401wt.eu-S964940AbXGMJf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964940AbXGMJf1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 05:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934288AbXGMJfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 05:35:15 -0400
Received: from brick.kernel.dk ([80.160.20.94]:9585 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933801AbXGMJfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 05:35:13 -0400
Date: Fri, 13 Jul 2007 11:34:59 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: On current git head webservers stopped working
Message-ID: <20070713093459.GB5328@kernel.dk>
References: <469745A8.6010005@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469745A8.6010005@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13 2007, Gabriel C wrote:
> Hello ,
> 
> While doing some tests with 2.6.22-git2 ( at the time head
> 4eb6bf6bfb580afaf1e1a1d30cba17a078530cf4 ) all my webservers stopped
> working.
> I can't get any file using wget or whatever else , everything hangs
> after 1% forever.
> 
> I bisected this and here the result:
> 
> 534f2aaa6ab07cd71164180bc958a7dcde41db11 is first bad commit
> commit 534f2aaa6ab07cd71164180bc958a7dcde41db11
> Author: Jens Axboe <jens.axboe@oracle.com>
> Date:   Fri Jun 1 14:52:37 2007 +0200
> 
>     sys_sendfile: switch to using ->splice_read, if available
> 
>     This patch makes sendfile prefer to use ->splice_read(), if it's
>     available in the file_operations structure.
> 
>     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> 
> :040000 040000 b19013793692eee0f632b3703dca0bd40cea753f
> ed50576c0d3f0d3ce9f1a2ac9336d1164b45f63f M      fs

Does this work?

diff --git a/fs/splice.c b/fs/splice.c
index ed2ce99..92646aa 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -491,7 +491,7 @@ ssize_t generic_file_splice_read(struct file *in, loff_t *ppos,
 
 	ret = 0;
 	spliced = 0;
-	while (len) {
+	while (len && !spliced) {
 		ret = __generic_file_splice_read(in, ppos, pipe, len, flags);
 
 		if (ret < 0)
@@ -1051,15 +1051,10 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
 	sd->flags &= ~SPLICE_F_NONBLOCK;
 
 	while (len) {
-		size_t read_len, max_read_len;
-
-		/*
-		 * Do at most PIPE_BUFFERS pages worth of transfer:
-		 */
-		max_read_len = min(len, (size_t)(PIPE_BUFFERS*PAGE_SIZE));
+		size_t read_len;
 
-		ret = do_splice_to(in, &sd->pos, pipe, max_read_len, flags);
-		if (unlikely(ret < 0))
+		ret = do_splice_to(in, &sd->pos, pipe, len, flags);
+		if (unlikely(ret <= 0))
 			goto out_release;
 
 		read_len = ret;
@@ -1071,26 +1066,17 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
 		 * could get stuck data in the internal pipe:
 		 */
 		ret = actor(pipe, sd);
-		if (unlikely(ret < 0))
+		if (unlikely(ret <= 0))
 			goto out_release;
 
 		bytes += ret;
 		len -= ret;
 
-		/*
-		 * In nonblocking mode, if we got back a short read then
-		 * that was due to either an IO error or due to the
-		 * pagecache entry not being there. In the IO error case
-		 * the _next_ splice attempt will produce a clean IO error
-		 * return value (not a short read), so in both cases it's
-		 * correct to break out of the loop here:
-		 */
-		if ((flags & SPLICE_F_NONBLOCK) && (read_len < max_read_len))
-			break;
+		if (ret < read_len)
+			goto out_release;
 	}
 
 	pipe->nrbufs = pipe->curbuf = 0;
-
 	return bytes;
 
 out_release:
@@ -1152,10 +1138,12 @@ long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
 		.pos		= *ppos,
 		.u.file		= out,
 	};
-	size_t ret;
+	long ret;
 
 	ret = splice_direct_to_actor(in, &sd, direct_splice_actor);
-	*ppos = sd.pos;
+	if (ret > 0)
+		*ppos += ret;
+
 	return ret;
 }
 

-- 
Jens Axboe

