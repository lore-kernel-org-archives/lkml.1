Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbXKEQqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbXKEQqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 11:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbXKEQqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 11:46:23 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:11669 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbXKEQqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 11:46:22 -0500
Date: Mon, 5 Nov 2007 08:40:42 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, Boaz Harrosh <bharrosh@panasas.com>,
       Jens Axboe <jens.axboe@oracle.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, mingo@elte.hu
Subject: Re: [RFC PATCH 1/2] sg_ring instead of scatterlist chaining
Message-Id: <20071105084042.83149a5c.randy.dunlap@oracle.com>
In-Reply-To: <200711051711.55364.rusty@rustcorp.com.au>
References: <1193076664-13652-10-git-send-email-jens.axboe@oracle.com>
	<18209.29891.911465.715995@cargo.ozlabs.ibm.com>
	<alpine.LFD.0.999.0710260742140.30120@woody.linux-foundation.org>
	<200711051711.55364.rusty@rustcorp.com.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2007 17:11:55 +1100 Rusty Russell wrote:

> Hi all,
> 
> 	This patch implements a header for a linked list of scatterlist
>  arrays, rather than using an extra entry and low pointer bits to chain them
> together.  I've tested that it's sane for virtio (which uses struct
> scatterlist).
> 
> Features:
> 1) Neatens code by including length in structure.
> 2) Avoids end ambiguity by including maximum length too.
> 3) Works fine with old "sg is an array" interfaces.
> 4) Kinda icky for stack declaration, so hence a helper is created.
> 5) Lacks magic.
> 
> I reverted (most of?) the scatterlist chaining changes to create these
> patches, so it won't apply to your kernels.  The reversion patch isn't
> interesting, so I haven't posted it.
> 
> Thanks,
> Rusty.
> 
> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> index 4efbd9c..ce7e581 100644
> --- a/include/linux/scatterlist.h
> +++ b/include/linux/scatterlist.h
> @@ -5,6 +5,51 @@
>  #include <linux/mm.h>
>  #include <linux/string.h>
>  
> +/**
> + * struct sg_ring - a ring of scatterlists
> + * @list: the list_head chaining them together
> + * @num: the number of valid sg entries
> + * @max: the maximum number of sg entries (size of the sg array).
> + * @sg: the array of scatterlist entries.
> + *
> + * This provides a convenient encapsulation of one or more scatter gather
> + * arrays. */

Hi Rusty,

I don't know where these patches are going, but please put the
trailing */ in all of these kernel-doc descriptions (nice ones :)
on a separate line.  Thanks.

> +struct sg_ring
> +{
> +	struct list_head list;
> +	unsigned int num, max;
> +	struct scatterlist sg[0];
> +};
> +
> +/* This helper declares an sg ring on the stack or in a struct. */
> +#define DECLARE_SG(name, max)			\
> +	struct {				\
> +		struct sg_ring ring;		\
> +		struct scatterlist sg[max];	\
> +	} name
> +
> +/**
> + * sg_ring_init - initialize a scatterlist ring.
> + * @sg: the sg_ring.
> + * @max: the size of the trailing sg array.
> + *
> + * After initialization sg is alone in the ring. */
> +static inline void sg_ring_init(struct sg_ring *sg, unsigned int max)
> +{
> +	INIT_LIST_HEAD(&sg->list);
> +	sg->max = max;
> +}
> +
> +/**
> + * sg_ring_next - next array in a scatterlist ring.
> + * @sg: the sg_ring.
> + *
> + * After initialization sg is alone in the ring. */
> +static inline struct sg_ring *sg_ring_next(struct sg_ring *sg)
> +{
> +	return list_first_entry(&sg->list, struct sg_ring, list);
> +}
> +
>  static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
>  			      unsigned int buflen)
>  {
> @@ -20,4 +65,20 @@ static inline void sg_init_one(struct scatterlist *sg, const void *buf,
>  	sg_set_buf(sg, buf, buflen);
>  }
>  
> +/**
> + * sg_init_single - initialize a one-element scatterlist ring.
> + * @sg: the sg_ring.
> + * @buf: the pointer to the buffer.
> + * @buflen: the length of the buffer.
> + *
> + * Does sg_ring_init and also sets up first (and only) sg element. */
> +static inline void sg_init_single(struct sg_ring *sg,
> +				  const void *buf,
> +				  unsigned int buflen)
> +{
> +	sg_ring_init(sg, 1);
> +	sg->num = 1;
> +	sg_init_one(&sg->sg[0], buf, buflen);
> +}
> +
>  #endif /* _LINUX_SCATTERLIST_H */

---
~Randy
