Return-Path: <linux-kernel-owner+w=401wt.eu-S1753496AbZI3ACj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbZI3ACj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 20:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbZI3ACj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 20:02:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50252 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752144AbZI3ACi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 20:02:38 -0400
Date: Tue, 29 Sep 2009 17:02:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       yehuda@newdream.net, sage@newdream.net
Subject: Re: [PATCH 04/21] ceph: ref counted buffer
Message-Id: <20090929170240.ce93d637.akpm@linux-foundation.org>
In-Reply-To: <1253641129-28434-5-git-send-email-sage@newdream.net>
References: <1253641129-28434-1-git-send-email-sage@newdream.net>
	<1253641129-28434-2-git-send-email-sage@newdream.net>
	<1253641129-28434-3-git-send-email-sage@newdream.net>
	<1253641129-28434-4-git-send-email-sage@newdream.net>
	<1253641129-28434-5-git-send-email-sage@newdream.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009 10:38:32 -0700
Sage Weil <sage@newdream.net> wrote:

> struct ceph_buffer is a simple ref-counted buffer.  We transparently
> choose between kmalloc for small buffers and vmalloc for large ones.
> 
> This is used for allocating memory for xattr data, among other things.
> 
> Signed-off-by: Sage Weil <sage@newdream.net>
> ---
>  fs/ceph/buffer.h |   83 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 83 insertions(+), 0 deletions(-)
>  create mode 100644 fs/ceph/buffer.h
> 
> diff --git a/fs/ceph/buffer.h b/fs/ceph/buffer.h
> new file mode 100644
> index 0000000..128593d
> --- /dev/null
> +++ b/fs/ceph/buffer.h
> @@ -0,0 +1,83 @@
> +#ifndef __FS_CEPH_BUFFER_H
> +#define __FS_CEPH_BUFFER_H
> +
> +#include <linux/mm.h>
> +#include <linux/types.h>
> +#include <linux/vmalloc.h>
> +
> +#include "ceph_debug.h"
> +
> +/*
> + * a simple reference counted buffer.
> + *
> + * use kmalloc for small sizes (<= one page), vmalloc for larger
> + * sizes.
> + */
> +struct ceph_buffer {
> +	atomic_t nref;
> +	struct kvec vec;
> +	size_t alloc_len;
> +	bool is_vmalloc;
> +};

vmalloc is a concern.  It is vulnerable to (and can cause) internal
fragmentation.  One that occurs, it's as good as a full machine
failure.

> +static inline struct ceph_buffer *ceph_buffer_new(gfp_t gfp)
> +{
> +	struct ceph_buffer *b;
> +
> +	b = kmalloc(sizeof(*b), gfp);
> +	if (!b)
> +		return NULL;
> +	atomic_set(&b->nref, 1);
> +	b->vec.iov_base = NULL;
> +	b->vec.iov_len = 0;
> +	b->alloc_len = 0;
> +	return b;
> +}

I was going to stop commenting on all the nutty inlining decisions but gee.

> +static inline int ceph_buffer_alloc(struct ceph_buffer *b, int len, gfp_t gfp)
> +{
> +	if (len <= PAGE_SIZE) {
> +		b->vec.iov_base = kmalloc(len, gfp);
> +		b->is_vmalloc = false;
> +	} else {
> +		b->vec.iov_base = __vmalloc(len, gfp, PAGE_KERNEL);
> +		b->is_vmalloc = true;
> +	}
> +	if (!b->vec.iov_base)
> +		return -ENOMEM;
> +	b->alloc_len = len;
> +	b->vec.iov_len = len;
> +	return 0;
> +}

Do we *really* need vmalloc here?  It much be one humongous vector! 
How large can it really get?

A still-lame-but-less-lame option here would be to attempt the kmalloc
(with __GFP_NOWARN) and if it failed, fall back to vmalloc.


>
> ...
>
> +static inline void ceph_buffer_put(struct ceph_buffer *b)
> +{
> +	if (b && atomic_dec_and_test(&b->nref)) {
> +		if (b->vec.iov_base) {
> +			if (b->is_vmalloc)
> +				vfree(b->vec.iov_base);
> +			else
> +				kfree(b->vec.iov_base);
> +		}
> +		kfree(b);
> +	}
> +}
> +
> +static inline struct ceph_buffer *ceph_buffer_new_alloc(int len, gfp_t gfp)
> +{
> +	struct ceph_buffer *b = ceph_buffer_new(gfp);
> +
> +	if (b && ceph_buffer_alloc(b, len, gfp) < 0) {
> +		ceph_buffer_put(b);
> +		b = NULL;
> +	}
> +	return b;
> +}

Do we really need to test for b==NULL here?  Is that test potentially
hiding bugs in calling code?

