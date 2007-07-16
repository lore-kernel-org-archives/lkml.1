Return-Path: <linux-kernel-owner+w=401wt.eu-S1760979AbXGPLQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760979AbXGPLQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 07:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757750AbXGPLQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 07:16:12 -0400
Received: from brick.kernel.dk ([80.160.20.94]:28794 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757989AbXGPLQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 07:16:11 -0400
Date: Mon, 16 Jul 2007 13:15:28 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] splice: fix wrong __splice_from_pipe() usage
Message-ID: <20070716111528.GD5195@kernel.dk>
References: <877ip1qj29.fsf@duaron.myhome.or.jp> <20070716063435.GG5328@kernel.dk> <87odiczkky.fsf@duaron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87odiczkky.fsf@duaron.myhome.or.jp>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16 2007, OGAWA Hirofumi wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
> 
> > On Mon, Jul 16 2007, OGAWA Hirofumi wrote:
> >> Hi,
> >> 
> >> I've noticed the nfsd read corruption by recent change. And this patch
> >> fixes the problem for me, is this right fix?
> >> -- 
> >> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> >> 
> >> 
> >> __splice_from_pipe() is updating the sd->pos for the actor, but those
> >> functions are passing the sd of reader side directory. So, splice
> >> updates sd->pos twice.
> >> 
> >> This fixes usage of __splice_from_pipe().
> >
> > For sendfile() usage, or the nfsd path that uses splice to send?
> 
> nfsd_vfs_read() path.
> 
> nfsd_vfs_read()
>     splice_direct_to_actor()
>         while(len) {
>             do_splice_to()                     [update sd->pos]
>                 -> generic_file_splice_read()  [read from sd->pos]
>             nfsd_direct_splice_actor()
>                 -> __splice_from_pipe()        [update sd->pos]
>         }
> 
> do_splice_to() updates sd->pos for read, and pass updated sd to
> __splice_from_pipe(), and __splice_from_pipe() updates sd->pos for
> write. So, next do_splice_to() read from wrong position.

Ah, I see. Copying the structure over would work, but it seems like a
big work-around for something that is essentially bad behaviour in the
splice core for direct splicing.

Can you check if this works for you?

diff --git a/fs/splice.c b/fs/splice.c
index 6c98286..5e5071a 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1061,8 +1061,9 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
 
 	while (len) {
 		size_t read_len;
+		loff_t pos = sd->pos;
 
-		ret = do_splice_to(in, &sd->pos, pipe, len, flags);
+		ret = do_splice_to(in, &pos, pipe, len, flags);
 		if (unlikely(ret <= 0))
 			goto out_release;
 
@@ -1080,6 +1081,7 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
 
 		bytes += ret;
 		len -= ret;
+		sd->pos = pos;
 
 		if (ret < read_len)
 			goto out_release;

-- 
Jens Axboe

