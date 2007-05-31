Return-Path: <linux-kernel-owner+w=401wt.eu-S1761187AbXEaKz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761187AbXEaKz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 06:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758742AbXEaKzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 06:55:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56662 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758691AbXEaKzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 06:55:49 -0400
Date: Thu, 31 May 2007 11:55:43 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, cotte@de.ibm.com, hugh@veritas.com,
       neilb@suse.de, zanussi@us.ibm.com, Linus Torvalds <torvalds@osdl.org>,
       hch@infradead.org
Subject: Re: [PATCH] sendfile removal
Message-ID: <20070531105543.GA25676@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
	cotte@de.ibm.com, hugh@veritas.com, neilb@suse.de,
	zanussi@us.ibm.com, Linus Torvalds <torvalds@osdl.org>
References: <20070531103316.GO32105@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531103316.GO32105@kernel.dk>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 12:33:16PM +0200, Jens Axboe wrote:
> - nfds: The ->rq_sendfile_ok optimization is gone for now. I can't
>   determine the value of it, but I'm assuming it's there for a reason.
>   Any chance this can be converted to splice, or use something else than
>   ->sendfile()? CC'ed Neil.

sendfile useage in nfsd avoids a data copy and allows to use checksum
offloading.  it's quite important for nfs server workloads.

> Apart from that, it was mostly straight forward. Almost everybody uses
> generic_file_sendfile(), which makes the conversion easy. I changed loop
> to use do_generic_file_read() instead of sendfile, it works for me...

> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 5526ead..92bac14 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -435,16 +435,24 @@ do_lo_receive(struct loop_device *lo,
>  {
>  	struct lo_read_data cookie;
>  	struct file *file;
> -	int retval;
> +	read_descriptor_t desc;
> +
> +	desc.written = 0;
> +	desc.count = bvec->bv_len;
> +	desc.arg.data = &cookie;
> +	desc.error = 0;
>  
>  	cookie.lo = lo;
>  	cookie.page = bvec->bv_page;
>  	cookie.offset = bvec->bv_offset;
>  	cookie.bsize = bsize;
>  	file = lo->lo_backing_file;
> -	retval = file->f_op->sendfile(file, &pos, bvec->bv_len,
> -			lo_read_actor, &cookie);
> -	return (retval < 0)? retval: 0;
> +
> +	do_generic_file_read(file, &pos, &desc, lo_read_actor);

This change is wrong.  loop or any existing user of ->sendfile absolutely
needs to go through a file operations vector so that file-system specific
actions such as locking are performed.  This is required at least for the
clustered filesystems and XFS.   The right way to implement this is
via do_splice_direct or something similar.

do_generic_file_read is only a library function for filesystem use
and should never be called directly.

