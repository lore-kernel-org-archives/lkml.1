Return-Path: <linux-kernel-owner+w=401wt.eu-S1757926AbXEJLAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926AbXEJLAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758689AbXEJLAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:00:17 -0400
Received: from gw-e.panasas.com ([65.194.124.178]:33788 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759443AbXEJLAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:00:15 -0400
Message-ID: <4642FB1B.80702@panasas.com>
Date: Thu, 10 May 2007 13:59:39 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/13] i386 sg: add support for chaining scatterlists
References: <11787925152319-git-send-email-jens.axboe@oracle.com> <11787925162760-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <11787925162760-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 May 2007 10:59:40.0587 (UTC) FILETIME=[4ED807B0:01C792F2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> +#define sg_is_chain(sg)		((unsigned long) (sg)->page & 0x01)
> +#define sg_chain_ptr(sg)	\
> +	((struct scatterlist *) ((unsigned long) (sg)->page & ~0x01))
> +
> +/*
> + * We overload the meaning of ->page for sg chaining. If the LSB is
> + * set, the page member contains a pointer to the next sgtable.
> + */
> +static inline struct scatterlist *sg_next(struct scatterlist *sg)
> +{
> +	if (sg_is_chain(sg))
> +		return sg_chain_ptr(sg);
> +
> +	return sg + 1;
> +}

Jens, should sg_next ever return the sg containing the chain link?
If sg points at the entry right before the link entry, don't we
want to skip it?

E.g.:

static inline struct scatterlist *sg_next(struct scatterlist *sg)
{
	struct scatterlist *next;

	/* just in case, shouldn't really ever be here */
	if (sg_is_chain(sg))
		return sg_chain_ptr(sg);

	next = sg + 1;

	if (sg_is_chain(next))
		return sg_chain_ptr(next);

	return next;
}
