Return-Path: <linux-kernel-owner+w=401wt.eu-S1750919AbXAXKAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750919AbXAXKAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 05:00:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbXAXKAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 05:00:06 -0500
Received: from ozlabs.org ([203.10.76.45]:47978 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbXAXKAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 05:00:04 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17847.8700.118329.777644@cargo.ozlabs.ibm.com>
Date: Wed, 24 Jan 2007 20:08:12 +1100
From: Paul Mackerras <paulus@samba.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Christoph Hellwig <hch@infradead.org>,
       "Martin J. Bligh" <mbligh@mbligh.org>, linuxppc-dev@ozlabs.org,
       Douglas Niehaus <niehaus@eecs.ku.edu>, ltt-dev@shafik.org,
       systemtap@sources.redhat.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 7/10] local_t : powerpc
In-Reply-To: <20061221002705.GW28643@Krystal>
References: <20061221001545.GP28643@Krystal>
	<20061221002705.GW28643@Krystal>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers writes:

> +static __inline__ int local_dec_if_positive(local_t *l)
> +{
> +	int t;
> +
> +	__asm__ __volatile__(
> +"1:	lwarx	%0,0,%1		# local_dec_if_positive\n\
> +	addic.	%0,%0,-1\n\
> +	blt-	2f\n"
> +	PPC405_ERR77(0,%1)
> +"	stwcx.	%0,0,%1\n\
> +	bne-	1b"

This has the same bugs that we fixed recently in atomic_dec_if_positive;
first, on 64-bit machines, the lwarx will zero-extend the word loaded
from memory, and so the result of the addic will be negative only if
the word was originally 0.  Secondly, even on 32-bit machines,
0x80000000 will be considered positive since decrementing it gives
0x7fffffff, which is positive.

> +/* Use these for per-cpu local_t variables: on some archs they are
> + * much more efficient than these naive implementations.  Note they take
> + * a variable, not an address.
> + *
> + * This could be done better if we moved the per cpu data directly
> + * after GS.
> + */

What's "GS"?  Does this comment really apply on powerpc?

Paul.
