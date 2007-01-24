Return-Path: <linux-kernel-owner+w=401wt.eu-S1030219AbXAXFxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030219AbXAXFxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 00:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030221AbXAXFx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 00:53:29 -0500
Received: from smtp.osdl.org ([65.172.181.24]:53199 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030219AbXAXFx3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 00:53:29 -0500
Date: Tue, 23 Jan 2007 21:50:47 -0800
From: Andrew Morton <akpm@osdl.org>
To: =?ISO-8859-1?B?U+liYXN0aWVuIER1Z3Xp?= <sebastien.dugue@bull.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-aio <linux-aio@kvack.org>, Bharata B Rao <bharata@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [PATCH -mm 5/5][AIO] - Add listio syscall support
Message-Id: <20070123215047.be8d8d79.akpm@osdl.org>
In-Reply-To: <20070117105554.346324b4@frecb000686>
References: <20070117104601.36b2ab18@frecb000686>
	<20070117105554.346324b4@frecb000686>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jan 2007 10:55:54 +0100
Sébastien Dugué <sebastien.dugue@bull.net> wrote:

> +asmlinkage long
> +compat_sys_lio_submit(aio_context_t ctx_id, int mode, int nr, u32 __user *iocb,
> +		struct compat_sigevent __user *sig_user)
> +{
> +	struct kioctx *ctx;
> +	struct lio_event *lio = NULL;
> +	struct sigevent __user *event = NULL;
> +	long ret = 0;
> +
> +	if (unlikely(nr < 0))
> +		return -EINVAL;
> +
> +	if (unlikely(!access_ok(VERIFY_READ, iocb, (nr * sizeof(u32)))))
> +		return -EFAULT;
> +
> +	ctx = lookup_ioctx(ctx_id);
> +	if (unlikely(!ctx))
> +		return -EINVAL;
> +
> +	if (sig_user) {
> +		struct sigevent kevent;
> +		event = compat_alloc_user_space(sizeof(struct sigevent));
> +		if (get_compat_sigevent(&kevent, sig_user) ||
> +			copy_to_user(event, &kevent, sizeof(struct sigevent)))
> +			return -EFAULT;

I think we just leaked a ref against the ioctx.

That's two.  Please re-review the whole patchset for leaks like this.

Please also do not do returns from the middle of functions like this.  It's just
asking for resource leaks, either now or in the future.


> +	}
> +
> +	lio = lio_create(event, mode);
> +
> +	ret = PTR_ERR(lio);
> +	if (IS_ERR(lio))
> +		goto out_put_ctx;
> +
> +	ret = compat_io_submit_group(ctx, nr, iocb, lio);
> +
> +	/* If we failed to submit even one request just return */
> +	if (ret < 0) {
> +		if (lio)
> +			kfree(lio);
> +		goto out_put_ctx;
> +	}
> +
> +	/*
> +	 * Drop extra ref on the lio now that we're done submitting requests.
> +	 */
> +	if (lio)
> +		lio_check(lio);
> +
> +
> +	if (mode == LIO_WAIT) {
> +		wait_event(ctx->wait, atomic_read(&lio->lio_users) == 0);
> +		kfree(lio);
> +	}
> +out_put_ctx:
>  	put_ioctx(ctx);
> -	return i ? i: ret;
> +	return ret;
>  }
