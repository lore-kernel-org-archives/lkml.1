Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbYFNEkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbYFNEkx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 00:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbYFNEkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 00:40:42 -0400
Received: from ag-out-0708.google.com ([72.14.246.243]:18920 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbYFNEkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 00:40:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PbeMXia4drLcjg0scb70rD1dJ1krrXXBv4LcdrBd/oK58D9qjc7ufNhbMMCiSyuFmq
         z1wLFwi0BTK5pf4yaTXckvDUdyGR6hYTm/UINA2Gmjnsv46NJq4M8E3OqnFSrlcF821A
         UJzgMObx0oGsQkSq+Qns3azIIQUvxTmJv0VKU=
Subject: Re: [PATCH 1/3] relay: Fix 4 off-by-one errors occuring when
	writing to a CPU buffer.
From: Tom Zanussi <tzanussi@gmail.com>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: penberg@cs.helsinki.fi, akpm@linux-foundation.org,
       compudj@krystal.dyndns.org, linux-kernel@vger.kernel.org,
       righi.andrea@gmail.com
In-Reply-To: <20080613040947.7465b9a5@linux360.ro>
References: <20080613040947.7465b9a5@linux360.ro>
Content-Type: text/plain
Date: Fri, 13 Jun 2008 23:40:37 -0500
Message-Id: <1213418437.8237.51.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2008-06-13 at 04:09 +0300, Eduard - Gabriel Munteanu wrote:
> Semantically, start + offset is always lower than the total size in bytes,
> so the code should check against equality to size, not size + 1. When
> userspace did read() (but not necessarily restricted to this), this
> resulted in all-zeros data at the end of the buffer.
> 

I'm wondering if the all-zeroes at the end of the buffer might be
another case of the all-zeroes you were seeing due to cross-cpu reading
you decribed in the other patch.  In any case, I'm pretty sure this
patch isn't doing what you think it is, and don't see how it could have
fixed the problem (see below).  There may still be a bug somewhere, but
it would be good to be able to reproduce it.  Does it happen even when
running on a single cpu?

> Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> ---
>  include/linux/relay.h |    4 ++--
>  kernel/relay.c        |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/relay.h b/include/linux/relay.h
> index 6cd8c44..8593ca1 100644
> --- a/include/linux/relay.h
> +++ b/include/linux/relay.h
> @@ -202,7 +202,7 @@ static inline void relay_write(struct rchan *chan,
>  
>  	local_irq_save(flags);
>  	buf = chan->buf[smp_processor_id()];
> -	if (unlikely(buf->offset + length > chan->subbuf_size))
> +	if (unlikely(buf->offset + length >= chan->subbuf_size))

The original code basically says, "if the current write won't fit in the
remaining space in current subbuffer, move on to the next sub-buffer".
Your change makes it "if the current write won't fit in the current
subbuffer or if it exactly fits, move on to the next sub-buffer", which
isn't what we want.

>  		length = relay_switch_subbuf(buf, length);
>  	memcpy(buf->data + buf->offset, data, length);
>  	buf->offset += length;
> @@ -228,7 +228,7 @@ static inline void __relay_write(struct rchan *chan,
>  	struct rchan_buf *buf;
>  
>  	buf = chan->buf[get_cpu()];
> -	if (unlikely(buf->offset + length > buf->chan->subbuf_size))

Same thing here.

> +	if (unlikely(buf->offset + length >= buf->chan->subbuf_size))
>  		length = relay_switch_subbuf(buf, length);
>  	memcpy(buf->data + buf->offset, data, length);
>  	buf->offset += length;
> diff --git a/kernel/relay.c b/kernel/relay.c
> index 7de644c..07f25e7 100644
> --- a/kernel/relay.c
> +++ b/kernel/relay.c
> @@ -622,7 +622,7 @@ size_t relay_switch_subbuf(struct rchan_buf *buf, size_t length)
>  	if (unlikely(length > buf->chan->subbuf_size))
>  		goto toobig;
>  
> -	if (buf->offset != buf->chan->subbuf_size + 1) {
> +	if (buf->offset != buf->chan->subbuf_size) {

This case, offset being 1 larger than the subbuf size, is how we note a
full sub-buffer, so changing this will break full-subbuffer cases. 

>  		buf->prev_padding = buf->chan->subbuf_size - buf->offset;
>  		old_subbuf = buf->subbufs_produced % buf->chan->n_subbufs;
>  		buf->padding[old_subbuf] = buf->prev_padding;
> @@ -645,7 +645,7 @@ size_t relay_switch_subbuf(struct rchan_buf *buf, size_t length)
>  	new = buf->start + new_subbuf * buf->chan->subbuf_size;
>  	buf->offset = 0;
>  	if (!buf->chan->cb->subbuf_start(buf, new, old, buf->prev_padding)) {
> -		buf->offset = buf->chan->subbuf_size + 1;
> +		buf->offset = buf->chan->subbuf_size;

Same here.

Tom


>  		return 0;
>  	}
>  	buf->data = new;

