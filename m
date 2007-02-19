Return-Path: <linux-kernel-owner+w=401wt.eu-S965145AbXBSWup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965145AbXBSWup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 17:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965148AbXBSWuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 17:50:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965145AbXBSWun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 17:50:43 -0500
To: Zach Brown <zach.brown@oracle.com>
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna bhattacharya <suparna@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Leonid Ananiev <leonid.i.ananiev@intel.com>
Subject: Re: [PATCH 2/2] aio: propogate post-EIOCBQUEUED errors to completion event
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
References: <20070219213830.4032.71308.sendpatchset@tetsuo.zabbo.net>
	<20070219213835.4032.87439.sendpatchset@tetsuo.zabbo.net>
From: Jeff Moyer <jmoyer@redhat.com>
Date: Mon, 19 Feb 2007 17:48:14 -0500
In-Reply-To: <20070219213835.4032.87439.sendpatchset@tetsuo.zabbo.net> (Zach Brown's message of "Mon, 19 Feb 2007 13:38:35 -0800 (PST)")
Message-ID: <x49y7mt4vdd.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.5-b27 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

==> On Mon, 19 Feb 2007 13:38:35 -0800 (PST), Zach Brown <zach.brown@oracle.com> said:

Zach> This addresses an oops reported by Leonid Ananiev <leonid.i.ananiev@intel.com>
Zach> as archived at http://lkml.org/lkml/2007/2/8/337.
[snip]
Zach> So this patch introduces a helper, aio_propogate_error(), 

...which is spelled incorrectly:  aio_propagate_error.

Zach> which queues post-submission errors in the iocb so that they are
Zach> given to the user completion event when aio_complete() is
Zach> finally called.

Ugly, but I can't think of a better way to do it, either.

> +
> +	if (kiocbIsInserted(req))
> +		aio_ring_insert_entry(ctx, req);
> +

This confused me at first reading.  If it's inserted, then insert it.
Perhaps KIF_COMPLETED would be a better name?

> +/*
> + * This function is used to make sure that an error is communicated to
> + * userspace on iocb completion without stopping -EIOCBQUEUED from bubbling up
> + * to fs/aio.c from the place where it originated.
> + *
> + * If we have an existing -EIOCBQUEUED it must be returned all the way to
> + * fs/aio.c so that it doesn't double-complete the iocb along with whoever
> + * returned -EIOCBQUEUED..  In that case we put the new error in the iocb.  It
> + * will be returned to userspace *intead of* the first result code given to
> + * aio_complete().  Use this only for errors which must overwrite whatever the
> + * return code might have been.  The first non-zero new_err given to this
> + * function for a given iocb will be returned to userspace.
> + */
> +static inline int aio_propogate_error(struct kiocb *iocb, int existing_err,
> +				      int new_err)
> +{
> +	if (existing_err != -EIOCBQUEUED)
> +		return new_err;
> +	if (!iocb->ki_pending_err)
> +		iocb->ki_pending_err = new_err;
> +	return -EIOCBQUEUED;
> +}
> +

I think that we would ideally cancel the I/Os in flight since we are
going to throw away the results.  However, we don't exactly support
cancellation today.  So, I have no objection to this less optimal
solution.

-Jeff
