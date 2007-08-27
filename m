Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbXH0N3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbXH0N3D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 09:29:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbXH0N2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 09:28:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55820 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbXH0N2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 09:28:53 -0400
Date: Mon, 27 Aug 2007 14:28:43 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Peter Firefly Lund <firefly@vax64.dk>
Cc: Christoph Lameter <clameter@sgi.com>, Momchil Velikov <velco@fadata.bg>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [PATCH] avoid negative shifts in radix-tree.c
Message-ID: <20070827132843.GB21970@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Peter Firefly Lund <firefly@vax64.dk>,
	Christoph Lameter <clameter@sgi.com>,
	Momchil Velikov <velco@fadata.bg>, linux-kernel@vger.kernel.org,
	trivial@kernel.org
References: <1188051967.18306.45.camel@ls-search>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188051967.18306.45.camel@ls-search>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2007 at 04:26:07PM +0200, Peter Firefly Lund wrote:
> (linux-vax@pergamentum.com only bcc'ed because it's subscribers only,
> Lameter addressed because I think he touched the code last, Velikov and
> Hellwig because they touched the code first.)
> 
> The current code in __max_index() will shift by a negative amount first
> and only then fix the situation by ignoring the result if the shift
> amount would have been negative.  This happens to work on almost any
> architecture despite not being valid C.
> 
> Chapter and verse from the (draft) ISO C99 standard, "6.5.7 Bitwise
> shift operators", paragraph 3:
> 
>   "The integer promotions are performed on each of the operands. The
>    type of the result is that of the promoted left operand. If the
>    value of the right operand is negative or is greater than or equal
>    to the width of the promoted left operand, the behavior is
>    undefined."
> 
> Right-shifting by a negative amount causes a "reserved operand fault" on
> the VAX with some gcc versions.
> 
> 
> Applies to 2.6.22.
> Boot tested lightly on an emulated VAX.
> 
> (The function is called 7 times on booth with the values 0..6 -- I
> checked that the return values were the same + that it returns ~0UL for
> height==6 as was clearly the intention.)
> 
> -Peter
> 
> --- lib/radix-tree-old.c	2007-08-25 15:36:40.000000000 +0200
> +++ lib/radix-tree.c	2007-08-25 15:36:51.000000000 +0200
> @@ -980,12 +980,14 @@ radix_tree_node_ctor(void *node, struct 
>  
>  static __init unsigned long __maxindex(unsigned int height)
>  {
> -	unsigned int tmp = height * RADIX_TREE_MAP_SHIFT;
> -	unsigned long index = (~0UL >> (RADIX_TREE_INDEX_BITS - tmp - 1)) >> 1;
> -
> -	if (tmp >= RADIX_TREE_INDEX_BITS)
> -		index = ~0UL;
> -	return index;
> +	unsigned int	tmp   = height * RADIX_TREE_MAP_SHIFT;
> +	int		shift = RADIX_TREE_INDEX_BITS - tmp;
> +	unsigned long	index;
> +
> +	if (shift < 0)
> +		return ~0UL;
> +	else
> +		return ~0UL >> shift;

The conceptual change looks fine to me, but the code looks a little odd,
what about:

static __init unsigned long __maxindex(unsigned int height)
{
	unsigned int tmp = height * RADIX_TREE_MAP_SHIFT;
	int shift = RADIX_TREE_INDEX_BITS - tmp;

	if (shift < 0)
		return ~0UL;
	return ~0UL >> shift;
}

instead?
