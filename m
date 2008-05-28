Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbYE1X7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbYE1X7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 19:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYE1X6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 19:58:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751367AbYE1X6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 19:58:54 -0400
Date: Wed, 28 May 2008 16:58:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: hans-christoph.rohland@sap.com, leg@google.com, pbadari@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tmpfs: support aio
Message-Id: <20080528165815.f4e4982c.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0805290007320.7969@blonde.site>
References: <Pine.LNX.4.64.0805290007320.7969@blonde.site>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 00:13:35 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> +	struct file *filp = iocb->ki_filp;
> +	ssize_t retval;
> +	unsigned long seg;
> +	size_t count;
> +	loff_t *ppos = &iocb->ki_pos;
> +
> +	count = 0;
> +	retval = generic_segment_checks(iov, &nr_segs, &count, VERIFY_WRITE);
> +	if (retval)
> +		return retval;
> +
> +	retval = 0;
> +	if (count) {
> +		for (seg = 0; seg < nr_segs; seg++) {
> +			read_descriptor_t desc;
> +
> +			desc.written = 0;
> +			desc.arg.buf = iov[seg].iov_base;
> +			desc.count = iov[seg].iov_len;
> +			if (desc.count == 0)
> +				continue;
> +			desc.error = 0;
> +			do_shmem_file_read(filp, ppos, &desc, file_read_actor);
> +			retval += desc.written;
> +			if (desc.error) {
> +				retval = retval ?: desc.error;
> +				break;
> +			}
> +			if (desc.count > 0)
> +				break;
> +		}
> +	}
> +	return retval;
>  }

hm.  This version:

static ssize_t shmem_file_aio_read(struct kiocb *iocb,
		const struct iovec *iov, unsigned long nr_segs, loff_t pos)
{
	struct file *filp = iocb->ki_filp;
	ssize_t retval;
	unsigned long seg;
	size_t count;
	loff_t *ppos = &iocb->ki_pos;

	count = 0;
	retval = generic_segment_checks(iov, &nr_segs, &count, VERIFY_WRITE);
	if (retval)
		return retval;
	if (count == 0)
		return 0;

	retval = 0;
	for (seg = 0; seg < nr_segs; seg++) {
		if (iov[seg].iov_len) {
			read_descriptor_t desc = {
				.arg.buf = iov[seg].iov_base,
				.count = iov[seg].iov_len;
			};

			do_shmem_file_read(filp, ppos, &desc, file_read_actor);
			retval += desc.written;
			if (desc.error) {
				retval = retval ?: desc.error;
				break;
			}
			if (desc.count > 0)
				break;
		}
	}
	return retval;
}

is neater but generates 21 bytes more code.  Stupid gcc.

I don't believe we needed to check for count == 0?  We'd just loop around
N times doing nothing.

