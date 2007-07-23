Return-Path: <linux-kernel-owner+w=401wt.eu-S1759207AbXGWHnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207AbXGWHnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 03:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbXGWHnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 03:43:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44050 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbXGWHne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 03:43:34 -0400
Date: Mon, 23 Jul 2007 08:43:31 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, jdike@karaya.com
Subject: Re: Fix compiling UML
Message-ID: <20070723074331.GE21668@ftp.linux.org.uk>
References: <46A4420D.8070900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A4420D.8070900@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2007 at 10:52:13PM -0700, Ulrich Drepper wrote:
>  				.aio_buf	= (unsigned long) buf,
>  				.aio_nbytes	= len,
>  				.aio_offset	= offset,
> +				.aio_flags	= 0,
> +				.aio_resfd	= 0,
>  				.aio_reserved1	= 0,
> - -				.aio_reserved2	= 0,
> - -				.aio_reserved3	= 0 });
> +				.aio_reserved2	= 0 });

Huh?  First of all, you have a corrupted tree.  No lines that would
start with " -" in that area...  As for the rest, I would argue that
leaving *any* of these fields in that compound literal is no wise, since
that's just asking for future trouble of the same kind.

FWIW, why do we need that iocb at all?  That compound literal already
gives us a modifiable object of the right type, with exactly the same
lifetime...

IOW, how about the following?

static int do_aio(aio_context_t ctx, enum aio_type type, int fd, char *buf,
		  int len, unsigned long long offset, struct aio_context *aio)
{
	struct iocb *p = & (struct iocb) {
				.aio_data 	= (unsigned long) aio,
				.aio_fildes	= fd,
				.aio_buf	= (unsigned long) buf,
				.aio_nbytes	= len,
				.aio_offset	= offset
			};
	char c;

	switch (type) {
	case AIO_READ:
		p->aio_lio_opcode = IOCB_CMD_PREAD;
		break;
	case AIO_WRITE:
		p->aio_lio_opcode = IOCB_CMD_PWRITE;
		break;
	case AIO_MMAP:
		p->aio_lio_opcode = IOCB_CMD_PREAD;
		p->aio_buf = (unsigned long) &c;
		p->aio_nbytes = sizeof(c);
		break;
	default:
		printk("Bogus op in do_aio - %d\n", type);
		return -EINVAL;
	}

	return (io_submit(ctx, 1, &p) > 0) ? 0 : -errno;
}
