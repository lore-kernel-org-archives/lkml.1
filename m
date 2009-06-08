Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbZFHXFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbZFHXFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 19:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbZFHXFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 19:05:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396AbZFHXFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 19:05:46 -0400
Date: Mon, 8 Jun 2009 16:05:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: steiner@sgi.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch 02/12] GRU - add user request to explicitly unload a gru
 context
Message-Id: <20090608160525.86f38739.akpm@linux-foundation.org>
In-Reply-To: <20090608171946.000713000@sgi.com>
References: <20090608171648.988318000@sgi.com>
	<20090608171946.000713000@sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Jun 2009 12:16:50 -0500
steiner@sgi.com wrote:

>  /*
> + * Free all kernel contexts that are not currently in use.
> + *   Returns 0 if all freed, else number of inuse context.
> + */
> +static int gru_free_kernel_contexts(void)
> +{
> +	struct gru_blade_state *bs;
> +	struct gru_thread_state *kgts;
> +	int bid, ret = 0;
> +
> +	for (bid = 0; bid < GRU_MAX_BLADES; bid++) {
> +		bs = gru_base[bid];
> +		if (!bs)
> +			continue;
> +		if (down_write_trylock(&bs->bs_kgts_sema)) {

trylocks are always lame - they add a rarely-executed code path where
bugs can lurk.  They're often an admission that the locking is screwed
up.

I don't know if the latter is true here, but it would be helpful to add
a comment explaining what's going on, and why this unusual and
troublesome locking primitive is being used.

> +			kgts = bs->bs_kgts;
> +			if (kgts && kgts->ts_gru)
> +				gru_unload_context(kgts, 0);
> +			kfree(kgts);
> +			bs->bs_kgts = NULL;
> +			up_write(&bs->bs_kgts_sema);

nit: the kfree() can be moved outside the locked region.

> +		} else {
> +			ret++;
> +		}
> +	}
> +	return ret;
> +}
