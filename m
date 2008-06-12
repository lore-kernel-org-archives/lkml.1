Return-Path: <linux-kernel-owner+w=401wt.eu-S1759437AbYFLTew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437AbYFLTew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 15:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbYFLTem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 15:34:42 -0400
Received: from zakalwe.fi ([80.83.5.154]:58987 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753274AbYFLTem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 15:34:42 -0400
X-Greylist: delayed 1835 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jun 2008 15:34:42 EDT
Date: Thu, 12 Jun 2008 22:04:05 +0300
From: Heikki Orsila <shdl@zakalwe.fi>
To: David Altobelli <david.altobelli@hp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HP iLO driver
Message-ID: <20080612190405.GR31039@zakalwe.fi>
References: <20080612182308.GA1091@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080612182308.GA1091@ldl.fc.hp.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 12:23:08PM -0600, David Altobelli wrote:
> +struct fifo {
> +    u64 nrents;	/* user requested number of fifo entries */
> +    u64 imask;  /* mask to extract valid fifo index */
> +    u64 merge;	/*  O/C bits to merge in during enqueue operation */
> +    u64 reset;	/* set to non-zero when the target device resets */
> +    u8  pad_0[ILO_CACHE_SZ - (sizeof(u64) * 4)];
> +
> +    u64 head;
> +    u8  pad_1[ILO_CACHE_SZ - (sizeof(u64))];
> +
> +    u64 tail;
> +    u8  pad_2[ILO_CACHE_SZ - (sizeof(u64))];
> +
> +    volatile u64 fifobar[1];
> +};

Why do you need a volatile? What you probably want is atomic ops. 
Spinlocks will create memory barriers implicitly.

> +static int fifo_enqueue(struct ilo_hwinfo *hw, char *fifobar, int entry)
> +{
> +	struct fifo *Q = FIFOBARTOHANDLE(fifobar);
> +	int ret = 0;
> +
> +	spin_lock(&hw->fifo_lock);
> +	if (!(Q->fifobar[(Q->tail + 1) & Q->imask] & ENTRY_MASK_O)) {
> +		Q->fifobar[Q->tail & Q->imask] |=
> +			((entry & ENTRY_MASK_NOSTATE) | Q->merge);
> +		Q->tail += 1;
> +		ret = 1;
> +	}
> +	spin_unlock(&hw->fifo_lock);
> +
> +	return ret;
> +}

Is writing to Q->fifobar (u64 *) endian-safe?

-- 
Heikki Orsila
heikki.orsila@iki.fi
http://www.iki.fi/shd
