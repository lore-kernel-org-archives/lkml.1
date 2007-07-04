Return-Path: <linux-kernel-owner+w=401wt.eu-S1758375AbXGDDRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758375AbXGDDRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 23:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbXGDDRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 23:17:40 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:56308 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755009AbXGDDRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 23:17:40 -0400
Date: Tue, 3 Jul 2007 23:17:38 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Tom Zanussi <zanussi@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, dwilder@us.ibm.com, HOLZHEU@de.ibm.com
Subject: Re: [RFC PATCH 4/6] relay: add relay_reserve_cpu()
Message-ID: <20070704031738.GB24341@Krystal>
References: <1183173852.24291.140.camel@ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1183173852.24291.140.camel@ubuntu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:14:17 up 2 days, 21:57,  4 users,  load average: 0.16, 0.13, 0.13
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Tom Zanussi (zanussi@us.ibm.com) wrote:
> This patch adds the ability to explicitly specify the per-cpu buffer
> to reserve space in.  Needed for early DTI tracing.
> 

This should come with the ability to tell relay where the already
allocated static buffers are. Can you tell me a little more on why the
standard relay_reserve would not do the job? Is smp_processor_id() not
ready to output a sensible CPU id yet ?

> Signed-off-by: Tom Zanussi <zanussi@us.ibm.com>
> Signed-off-by: David Wilder <dwilder@us.ibm.com>
> ---
>  relay.h |   33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
> 
> diff --git a/include/linux/relay.h b/include/linux/relay.h
> index 6caedef..37a7306 100644
> --- a/include/linux/relay.h
> +++ b/include/linux/relay.h
> @@ -269,6 +269,39 @@ static inline void *relay_reserve(struct rchan *chan, size_t length)
>  }
>  
>  /**
> + *	relay_reserve_cpu - reserve slot in given cpu's channel buffer
> + *	@chan: relay channel
> + *	@length: number of bytes to reserve
> + *	@cpu: cpu to log to
> + *
> + *	Returns pointer to reserved slot, NULL if full.
> + *
> + *	Reserves a slot in the given cpu's channel buffer.
> + *	Does not protect the buffer at all - caller must provide
> + *	appropriate synchronization.
> + *
> + *	NOTE: this is almost certainly not the function you want -
> + *	use relay_reserve() instead for normal logging.  This version
> + *	is specialized for things like early tracing.
> + */
> +static inline void *relay_reserve_cpu(struct rchan *chan, size_t length,
> +				      unsigned int cpu)
> +{
> +	void *reserved;
> +	struct rchan_buf *buf = chan->buf[cpu];
> +
> +	if (unlikely(buf->offset + length > buf->chan->subbuf_size)) {
> +		length = relay_switch_subbuf(buf, length);
> +		if (!length)
> +			return NULL;
> +	}
> +	reserved = buf->data + buf->offset;
> +	buf->offset += length;
> +
> +	return reserved;
> +}
> +
> +/**
>   *	subbuf_start_reserve - reserve bytes at the start of a sub-buffer
>   *	@buf: relay channel buffer
>   *	@length: number of bytes to reserve
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
