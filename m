Return-Path: <linux-kernel-owner+w=401wt.eu-S1761740AbXGDNsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761740AbXGDNsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 09:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759192AbXGDNsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 09:48:17 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:61745 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759107AbXGDNsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 09:48:16 -0400
Date: Wed, 4 Jul 2007 09:48:14 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Tom Zanussi <zanussi@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, dwilder@us.ibm.com, HOLZHEU@de.ibm.com
Subject: Re: [RFC PATCH 6/6] relay: add relay_reset_consumed()
Message-ID: <20070704134814.GA12487@Krystal>
References: <1183173861.24291.142.camel@ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1183173861.24291.142.camel@ubuntu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:42:56 up 3 days,  8:25,  3 users,  load average: 0.15, 0.22, 0.21
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Tom Zanussi (zanussi@us.ibm.com) wrote:
> +/**
> + *	__relay_reset_consumed - reset a channel buffer's consumed count
> + *	@buf: the channel buffer
> + *
> + *	See relay_reset_consumed for description of effect.
> + */
> +static inline void __relay_reset_consumed(struct rchan_buf *buf)
> +{
> +	size_t n_subbufs = buf->chan->n_subbufs;
> +	size_t produced = buf->subbufs_produced;
> +	size_t consumed = buf->subbufs_consumed;
> +
> +	if (produced < n_subbufs)
> +		buf->subbufs_consumed = 0;
> +	else {
> +		consumed = produced - n_subbufs;
> +		if (buf->offset)
> +			consumed++;
> +		buf->subbufs_consumed = consumed;
> +	}
> +	buf->bytes_consumed = 0;
> +}
> +

How do you deal with the subbufs_consumed and subbufs_produced
counter overflows?

It goes in pair with my other question about which of relay or GTSC must
do the locking here. You seem to use a size_t for the produced and
consumed counts, which implies that you have to provide external
protection against racy modification of these 64 bits offsets by the
tracer and that in no way you can do an atomic update on a 32 bits
architecture. Therefore, either you have problems with reentrancy and
can run a long time before it overflows, or you use atomic_t or local_t
types and have to deal with overflows, which will happen more often.

Mathieu

> +/**
> + *	relay_reset_consumed - reset the channel's consumed counts
> + *	@chan: the channel
> + *
> + *	This has the effect of making all data previously read (and
> + *	not overwritten by subsequent writes) from a channel available
> + *	for reading again.
> + *
> + *	NOTE: Care should be taken that the channel isn't actually
> + *	being used by anything when this call is made.
> + */
> +void relay_reset_consumed(struct rchan *chan)
> +{
> +	unsigned int i;
> +	struct rchan_buf *prev = NULL;
> +
> +	if (!chan)
> +		return;
> +
> +	for (i = 0; i < NR_CPUS; i++) {
> +		if (!chan->buf[i] || chan->buf[i] == prev)
> +			break;
> +		__relay_reset_consumed(chan->buf[i]);
> +		prev = chan->buf[i];
> +	}
> +}
> +EXPORT_SYMBOL_GPL(relay_reset_consumed);
> +
>  /*
>   *	relay_open_buf - create a new relay channel buffer
>   *
> @@ -840,11 +891,9 @@ static int relay_file_read_avail(struct rchan_buf *buf, size_t read_pos)
>  		return 1;
>  	}
>  
> -	if (unlikely(produced - consumed >= n_subbufs)) {
> -		consumed = (produced / n_subbufs) * n_subbufs;
> -		buf->subbufs_consumed = consumed;
> -	}
> -	
> +	if (unlikely(produced - consumed >= n_subbufs))
> +		__relay_reset_consumed(buf);
> +
>  	produced = (produced % n_subbufs) * subbuf_size + buf->offset;
>  	consumed = (consumed % n_subbufs) * subbuf_size + buf->bytes_consumed;
>  
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
