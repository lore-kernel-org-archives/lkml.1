Return-Path: <linux-kernel-owner+w=401wt.eu-S1751296AbXAXLwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296AbXAXLwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 06:52:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbXAXLwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 06:52:44 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43632 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbXAXLwn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 06:52:43 -0500
Date: Wed, 24 Jan 2007 12:51:52 +0100
From: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-aio <linux-aio@kvack.org>, Bharata B Rao <bharata@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [PATCH -mm 5/5][AIO] - Add listio syscall support
Message-ID: <20070124125152.5b1abd43@frecb000686>
In-Reply-To: <20070123215047.be8d8d79.akpm@osdl.org>
References: <20070117104601.36b2ab18@frecb000686>
	<20070117105554.346324b4@frecb000686>
	<20070123215047.be8d8d79.akpm@osdl.org>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 24/01/2007 12:53:28,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 24/01/2007 12:53:28,
	Serialize complete at 24/01/2007 12:53:28
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jan 2007 21:50:47 -0800 Andrew Morton <akpm@osdl.org> wrote:

> On Wed, 17 Jan 2007 10:55:54 +0100
> Sébastien Dugué <sebastien.dugue@bull.net> wrote:
> 
> > +asmlinkage long
> > +compat_sys_lio_submit(aio_context_t ctx_id, int mode, int nr, u32 __user *iocb,
> > +		struct compat_sigevent __user *sig_user)
> > +{
> > +	struct kioctx *ctx;
> > +	struct lio_event *lio = NULL;
> > +	struct sigevent __user *event = NULL;
> > +	long ret = 0;
> > +
> > +	if (unlikely(nr < 0))
> > +		return -EINVAL;
> > +
> > +	if (unlikely(!access_ok(VERIFY_READ, iocb, (nr * sizeof(u32)))))
> > +		return -EFAULT;
> > +
> > +	ctx = lookup_ioctx(ctx_id);
> > +	if (unlikely(!ctx))
> > +		return -EINVAL;
> > +
> > +	if (sig_user) {
> > +		struct sigevent kevent;
> > +		event = compat_alloc_user_space(sizeof(struct sigevent));
> > +		if (get_compat_sigevent(&kevent, sig_user) ||
> > +			copy_to_user(event, &kevent, sizeof(struct sigevent)))
> > +			return -EFAULT;
> 
> I think we just leaked a ref against the ioctx.

  Right, will fix.

> 
> That's two.  Please re-review the whole patchset for leaks like this.

  Well, this particular patch did not have much review so far (contrary to the
the other patches in the patchset). That's why I posted it mainly
for comments and not expecting it to make it to -mm so soon.

> 
> Please also do not do returns from the middle of functions like this.  It's just
> asking for resource leaks, either now or in the future.
> 

  Argh, yes. Who wrote that code? ;-)

  Thanks,

  Sébastien.


