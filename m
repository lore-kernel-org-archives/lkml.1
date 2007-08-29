Return-Path: <linux-kernel-owner+w=401wt.eu-S1758972AbXH2Mr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758972AbXH2Mr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 08:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259AbXH2MrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 08:47:20 -0400
Received: from ns1.suse.de ([195.135.220.2]:43446 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990AbXH2MrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 08:47:19 -0400
From: Andreas Schwab <schwab@suse.de>
To: Peter Lund <firefly@vax64.dk>
Cc: Christoph Lameter <clameter@sgi.com>,
       Christoph Hellwig <hch@infradead.org>, trivial@kernel.org,
       linux-kernel@vger.kernel.org, Momchil Velikov <velco@fadata.bg>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] avoid negative shifts in radix-tree.c, take 2
References: <1188390865.7216.5.camel@localhost.localdomain>
X-Yow: I'll eat ANYTHING that's BRIGHT BLUE!!
Date: Wed, 29 Aug 2007 14:47:17 +0200
In-Reply-To: <1188390865.7216.5.camel@localhost.localdomain> (Peter Lund's
	message of "Wed\, 29 Aug 2007 14\:34\:25 +0200")
Message-ID: <jeodgq1p9m.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Lund <firefly@vax64.dk> writes:

> Shifting by more than the width of the value on the left is also not allowed.

Shifting by the width of the value is not allowed as well.

> --- linux-2.6.22/lib/radix-tree.c.orig	2007-08-27 15:42:37.000000000 +0200
> +++ linux-2.6.22/lib/radix-tree.c	2007-08-29 13:19:19.000000000 +0200
> @@ -980,12 +980,13 @@
>  
>  static __init unsigned long __maxindex(unsigned int height)
>  {
> -	unsigned int tmp = height * RADIX_TREE_MAP_SHIFT;
> -	unsigned long index = (~0UL >> (RADIX_TREE_INDEX_BITS - tmp - 1)) >> 1;
> +	unsigned int width = height * RADIX_TREE_MAP_SHIFT;
> +	int          shift = RADIX_TREE_INDEX_BITS - width;
>  
> -	if (tmp >= RADIX_TREE_INDEX_BITS)
> -		index = ~0UL;
> -	return index;
> +	if (shift < 0)
> +		return ~0UL;
> +	else
> +		return ~0UL >> shift;

Since height can be zero, you still have undefined behaviour.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
