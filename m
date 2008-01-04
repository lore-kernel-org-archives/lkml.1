Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbYADDKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbYADDKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 22:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYADDK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 22:10:26 -0500
Received: from ozlabs.org ([203.10.76.45]:43581 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbYADDKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 22:10:25 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] aio: partial write should not return error code.
Date: Fri, 4 Jan 2008 14:10:23 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: bcrl@kvack.org, linux-aio@kvack.org, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
References: <200801032004.08907.rusty@rustcorp.com.au> <477D3FCE.6080005@oracle.com>
In-Reply-To: <477D3FCE.6080005@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801041410.24297.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 January 2008 07:04:30 Zach Brown wrote:
> Rusty Russell wrote:
> > When an AIO write gets an error after writing some data (eg. ENOSPC),
> > it should return the amount written already, not the error.  Just like
> > write() is supposed to.
>
> Andrew, please don't queue this fix.  I think the bug is valid but the
> patch is subtly dangerous.
>
> > diff -r 18802689361a fs/aio.c
> > --- a/fs/aio.c	Thu Jan 03 15:22:24 2008 +1100
> > +++ b/fs/aio.c	Thu Jan 03 18:05:25 2008 +1100
> > @@ -1346,6 +1350,13 @@ static ssize_t aio_rw_vect_retry(struct
> >  	/* This means we must have transferred all that we could */
> >  	/* No need to retry anymore */
> >  	if ((ret == 0) || (iocb->ki_left == 0))
> > +		ret = iocb->ki_nbytes - iocb->ki_left;
> > +
> > +	/* If we managed to write some out we return that, rather than
> > +	 * the eventual error. */
> > +	if (opcode == IOCB_CMD_PWRITEV
> > +	    && ret < 0
> > +	    && iocb->ki_nbytes - iocb->ki_left)
> >  		ret = iocb->ki_nbytes - iocb->ki_left;
>
> This doesn't account for the (sigh) -EIOCB* error codes.  They must be
> returned to the caller so that it can properly handle the iocb reference
> counting.  Failure to do so can lead to oopses.
>
> To be fair, I think you'll have a really hard time finding an
> ->aio_write() implementation which would return partial progress and
> *then* one of the magical errnos.  But the infrastructure does allow it.

Erk, thanks.

> So maybe we could get a helper in aio.h that abstracts out the
>
> 	(ret < 0 && ret != -EIOCBQUEUED && ret != -EIOCBRETRY)
>
> condition.  Then I think this patch would be fine.
>
> I assigned a bug to remind myself to revisit this if you aren't excited
> by continuing with the patch:
>
>   http://bugzilla.kernel.org/show_bug.cgi?id=9681

No, that's fine, here is the new one:

When an AIO write gets a non-retry error after writing some data
(eg. ENOSPC), it should return the amount written already, not the
error.  Just like write() is supposed to.

This was found by the libaio test suite.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 fs/aio.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -r 18802689361a fs/aio.c
--- a/fs/aio.c	Thu Jan 03 15:22:24 2008 +1100
+++ b/fs/aio.c	Thu Jan 03 18:05:25 2008 +1100
@@ -1346,6 +1350,13 @@ static ssize_t aio_rw_vect_retry(struct 
 	/* This means we must have transferred all that we could */
 	/* No need to retry anymore */
 	if ((ret == 0) || (iocb->ki_left == 0))
+		ret = iocb->ki_nbytes - iocb->ki_left;
+
+	/* If we managed to write some out we return that, rather than
+	 * the eventual error. */
+	if (opcode == IOCB_CMD_PWRITEV
+	    && ret < 0 && ret != -EIOCBQUEUED && ret != -EIOCBRETRY
+	    && iocb->ki_nbytes - iocb->ki_left)
 		ret = iocb->ki_nbytes - iocb->ki_left;
 
 	return ret;


