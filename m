Return-Path: <linux-kernel-owner+w=401wt.eu-S1753053AbZIILxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbZIILxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 07:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbZIILxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 07:53:49 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:35341 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbZIILxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 07:53:49 -0400
Date: Wed, 9 Sep 2009 05:53:50 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <jens.axboe@oracle.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: aio_read const struct iovec *
Message-ID: <20090909115350.GA29320@parisc-linux.org>
References: <20090909111838.GA14369@localdomain.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090909111838.GA14369@localdomain.by>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 02:18:38PM +0300, Sergey Senozhatsky wrote:
> Hello,
> I have the following question:
> struct file_operations {
> 	ssize_t (*read) (struct file *, char __user *, size_t, loff_t *);
> 	ssize_t (*write) (struct file *, const char __user *, size_t, loff_t *);
> At the same time:
> 	ssize_t (*aio_read) (struct kiocb *, const struct iovec *, unsigned long, loff_t);
> 	ssize_t (*aio_write) (struct kiocb *, const struct iovec *, unsigned long, loff_t);
> 
> 'const struct iovec *' both for aio_write and aio_read. 
> And "char __user *" and "const char __user *" for read/write.
> 
> For example,
> pipe_read(struct kiocb *iocb, const struct iovec *_iov,
> 	    unsigned long nr_segs, loff_t ppos)
> {
> 	struct iovec *iov = (struct iovec *)_iov; 
> 
> Could we avoid 'struct iovec *iov = (struct iovec *)_iov;' by changing aio_read 'const struct iovec *'
>  to 'struct iovec *'?

If you try it, it'll be educational for you to see where it fails ;-)

But if you're too impatient, aio_rw_vect_retry() will be (one of)
the problems:

        ssize_t (*rw_op)(struct kiocb *, const struct iovec *,
                         unsigned long, loff_t);
[...]
                rw_op = file->f_op->aio_read;
[...]
                rw_op = file->f_op->aio_write;


so aio_read and aio_write need to have the same prototype.

Now, I'm not sure why it's more beneficial to have a lying const in the
aio_read prototype than simply omitting the const from the aio_write
prototype ... but I'm sure if you try that, you'll find a good reason too.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
