Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271AbYJALDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbYJALDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 07:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbYJALDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 07:03:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60439 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbYJALDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 07:03:04 -0400
Date: Wed, 1 Oct 2008 07:03:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Nigel Hislop <hislop_nigel@emc.com>, Hannes Reinecke <hare@suse.de>
Subject: Re: [patch 21/21] Add ioctl support for EMC Symmetrix Subsystem
	Control I/O
Message-ID: <20081001110301.GB6648@infradead.org>
References: <20081001083317.782967473@de.ibm.com> <20081001084130.599948666@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001084130.599948666@de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int dasd_symm_io(struct dasd_device *device, void __user *argp)
> +{
> +	struct dasd_symmio_parms usrparm;
> +	char *psf_data, *rssd_result;
> +	struct dasd_ccw_req *cqr;
> +	struct ccw1 *ccw;
> +	int rc;
> +
> +	/* Copy parms from caller */
> +	rc = copy_from_user(&usrparm, argp, sizeof(usrparm)) ? -EFAULT : 0;
> +	if (rc)
> +		goto out;

That style is quite odd,  what about the more normal

	rc = -EFAULT;
	if (copy_from_user(&usrparm, argp, sizeof(usrparm)))
		goto out;

instead?

> +	/* alloc I/O data area */
> +	psf_data = kzalloc(usrparm.psf_data_len, GFP_KERNEL | GFP_DMA);
> +	rssd_result = kzalloc(usrparm.rssd_result_len, GFP_KERNEL | GFP_DMA);
> +	if (!psf_data || !rssd_result) {
> +		rc = -ENOMEM;
> +		goto out_free;
> +	}

just check each on individually and do individual unwinding.  Makes the
code a little more easily readable.

> +	/* get syscall header from user space */
> +	rc = copy_from_user(psf_data,
> +			    (void __user *)(unsigned long) usrparm.psf_data,
> +			    usrparm.psf_data_len) ? -EFAULT : 0;
> +	if (rc)
> +		goto out_free;

Same as the first copy_from_user

> +	rc = copy_to_user((void __user *)(unsigned long) usrparm.rssd_result,
> +			   rssd_result, usrparm.rssd_result_len) ? -EFAULT : 0;

And here again.

