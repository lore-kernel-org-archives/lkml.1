Return-Path: <linux-kernel-owner+w=401wt.eu-S1030235AbXAXGGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030235AbXAXGGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 01:06:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030236AbXAXGGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 01:06:04 -0500
Received: from smtp.osdl.org ([65.172.181.24]:53532 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030235AbXAXGGC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 01:06:02 -0500
Date: Tue, 23 Jan 2007 22:04:33 -0800
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
Message-Id: <20070123220433.018b40b6.akpm@osdl.org>
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

> +void lio_check(struct lio_event *lio)
> +{
> +	int ret;
> +
> +	ret = atomic_dec_and_test(&lio->lio_users);
> +
> +	if (unlikely(ret) && lio->lio_notify.notify != SIGEV_NONE) {
> +		/* last one -> notify process */
> +		if (aio_send_signal(&lio->lio_notify))
> +			sigqueue_free(lio->lio_notify.sigq);
> +		kfree(lio);
> +	}
> +}

That's a scary function.  It may (or may not) free the memory at lio,
returning no indication to the caller whether or not that memory is still
allocated.  This is most peculiar - are you really sure there's no
potential for a use-after-free here?

The function is poorly named: I'd expect something called "foo_check" to
not have any side-effects.  This one has gross side-effects.  Want to think
up a better name, please?

And given that this function has global scope, perhaps a little explanatory
comment is in order?

> +struct lio_event *lio_create(struct sigevent __user *user_event,
> +			int mode)

Here too.
