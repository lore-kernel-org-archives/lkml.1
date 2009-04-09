Return-Path: <linux-kernel-owner+w=401wt.eu-S937125AbZDIWlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937125AbZDIWlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 18:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765506AbZDIWix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 18:38:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764936AbZDIWiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 18:38:51 -0400
Date: Thu, 9 Apr 2009 15:37:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: steiner@sgi.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 12/13] GRU - update gru kernel self tests
Message-Id: <20090409153715.f77bfbd4.akpm@linux-foundation.org>
In-Reply-To: <20090406161015.670990000@sgi.com>
References: <20090406160809.278924000@sgi.com>
	<20090406161015.670990000@sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Apr 2009 11:08:21 -0500
steiner@sgi.com wrote:

> From: Jack Steiner <steiner@sgi.com>
> 
> Change the kernel self tests that can be optionally executed on
> GRU initialization. This is primarily for testing.
> 
> Eliminate the BUG statements on failure and return bad status.
> Add ioctl interface to execute the tests on demand.
> 
> ...
>
> +static int quicktest2(unsigned long arg)
> +{
> +	static struct completion cmp;
> +	static int inited;
> +	unsigned long han;
> +	int blade_id = 0;
> +	int numcb = 4;
> +	int ret = 0;
> +	unsigned long *buf;
> +	void *cb0, *cb;
> +	int i, k, istatus, bytes;
> +
> +	bytes = numcb * 4 * 8;
> +	buf = kmalloc(bytes, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	ret = -EBUSY;
> +	if (!inited)
> +		init_completion(&cmp);

This could have been done at compile time?

> +	inited = 1;
> +	han = gru_reserve_async_resources(blade_id, numcb, 0, &cmp);
> +	if (!han)
> +		goto done;
> +
> +	gru_lock_async_resource(han, &cb0, NULL);
> +	memset(buf, 0xee, bytes);
> +	for (i = 0; i < numcb; i++)
> +		gru_vset(cb0 + i * GRU_HANDLE_STRIDE, uv_gpa(&buf[i * 4]), 0,
> +				XTYPE_DW, 4, 1, IMA_INTERRUPT);
> +
> +	ret = 0;
> +	for (k = 0; k < numcb; k++) {
> +		gru_wait_async_cbr(han);
> +		for (i = 0; i < numcb; i++) {
> +			cb = cb0 + i * GRU_HANDLE_STRIDE;
> +			istatus = gru_check_status(cb);
> +			if (istatus == CBS_ACTIVE)
> +				continue;
> +			if (istatus == CBS_EXCEPTION)
> +				ret = -EFAULT;
> +			else if (buf[i] || buf[i + 1] || buf[i + 2] ||
> +					buf[i + 3])
> +				ret = -EIO;
> +		}
> +	}
> +	BUG_ON(cmp.done);
> +
> +	gru_unlock_async_resource(han);
> +	gru_release_async_resources(han);
> +done:
> +	kfree(buf);
> +	return ret;
> +}

