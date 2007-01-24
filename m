Return-Path: <linux-kernel-owner+w=401wt.eu-S1752107AbXAXSJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbXAXSJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 13:09:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbXAXSJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 13:09:31 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:39587 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107AbXAXSJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 13:09:30 -0500
Date: Wed, 24 Jan 2007 23:46:35 +0530
From: Bharata B Rao <bharata@in.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: =?iso-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-aio <linux-aio@kvack.org>, Christoph Hellwig <hch@infradead.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [PATCH -mm 5/5][AIO] - Add listio syscall support
Message-ID: <20070124181635.GC8394@in.ibm.com>
Reply-To: bharata@in.ibm.com
References: <20070117104601.36b2ab18@frecb000686> <20070117105554.346324b4@frecb000686> <20070123220433.018b40b6.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070123220433.018b40b6.akpm@osdl.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 23, 2007 at 10:04:33PM -0800, Andrew Morton wrote:
> On Wed, 17 Jan 2007 10:55:54 +0100
> Sébastien Dugué <sebastien.dugue@bull.net> wrote:
> 
> > +void lio_check(struct lio_event *lio)
> > +{
> > +	int ret;
> > +
> > +	ret = atomic_dec_and_test(&lio->lio_users);
> > +
> > +	if (unlikely(ret) && lio->lio_notify.notify != SIGEV_NONE) {
> > +		/* last one -> notify process */
> > +		if (aio_send_signal(&lio->lio_notify))
> > +			sigqueue_free(lio->lio_notify.sigq);
> > +		kfree(lio);
> > +	}
> > +}
> 
> That's a scary function.  It may (or may not) free the memory at lio,
> returning no indication to the caller whether or not that memory is still
> allocated.  This is most peculiar - are you really sure there's no
> potential for a use-after-free here?

Yes, this function looks peculiar. Actually lio gets freed here only
for LIO_NOWAIT case. For LIO_WAIT case, it gets freed at the end
of sys_lio_submit() after it is done waiting for all io's.
But yes, all this is not very obvious.

> 
> The function is poorly named: I'd expect something called "foo_check" to
> not have any side-effects.  This one has gross side-effects.  Want to think
> up a better name, please?
> 
> And given that this function has global scope, perhaps a little explanatory
> comment is in order?
> 
> > +struct lio_event *lio_create(struct sigevent __user *user_event,
> > +			int mode)
> 
> Here too.

Ok, will try to take care of all these in the next iteration.

Thanks for your review.

Regards,
Bharata.
