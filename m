Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbXGHLq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbXGHLq1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 07:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbXGHLqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 07:46:18 -0400
Received: from ozlabs.org ([203.10.76.45]:58085 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbXGHLqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 07:46:18 -0400
Subject: maps2-add-proc-kpagemap-interface.patch
From: Rusty Russell <rusty@rustcorp.com.au>
To: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 08 Jul 2007 21:46:02 +1000
Message-Id: <1183895162.6005.338.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> + * Each entry is a pair of unsigned longs representing the
> + * corresponding physical page, the first containing the page flags
> + * and the second containing the page use count.
> + *
> + * The first 4 bytes of this file form a simple header:
> + *
> + * first byte:   0 for big endian, 1 for little
> + * second byte:  page shift (eg 12 for 4096 byte pages)
> + * third byte:   entry size in bytes (currently either 4 or 8)
> + * fourth byte:  header size

Hi Matt,

	This comment is worded badly: if the "entry is a pair" then "entry size
in bytes" would be 8 or 16.

> +	pfn = src / KPMSIZE - 1;
> +	count = min_t(size_t, count, ((max_pfn + 1) * KPMSIZE) - src);

Is min_t required here?  KPMSIZE is a sizeof() expression, so I'd expect
both sides to be type-compatible...

> +	page = (unsigned long *)__get_free_page(GFP_USER);
> +	if (!page)
> +		return -ENOMEM;

An explicit "struct kpagemap { unsigned long flags, count; };" would
simplify your iteration, clear up the code and get rid of the KPMSIZE &
KPMMASK macros.

But again I'd query the necessity of this cache page at all.

> +		if (copy_to_user(buf, page, chunk)) {
> +			ret = -EFAULT;
> +			break;
> +		}
> +		ret += chunk;
> +		src += chunk;
> +		buf += chunk;
> +		count -= chunk;
> +		cond_resched();

No cond_resched() needed here, either.

Cheers,
Rusty.

