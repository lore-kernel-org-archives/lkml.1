Return-Path: <linux-kernel-owner+w=401wt.eu-S1030761AbXDLXcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030761AbXDLXcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 19:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030772AbXDLXcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 19:32:42 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36996 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030761AbXDLXcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 19:32:41 -0400
Date: Thu, 12 Apr 2007 16:32:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
Message-Id: <20070412163235.dd030637.akpm@linux-foundation.org>
In-Reply-To: <20070412231050.GN2986@holomorphy.com>
References: <1.486631555@selenic.com>
	<20070412231050.GN2986@holomorphy.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2007 16:10:50 -0700
William Lee Irwin III <wli@holomorphy.com> wrote:

> On Tue, Apr 03, 2007 at 09:43:30PM -0500, Matt Mackall wrote:
> > This patch series introduces /proc/pid/pagemap and /proc/kpagemap,
> > which allow detailed run-time examination of process memory usage at a
> > page granularity.
> > The first several patches whip the page-walking code introduced for
> > /proc/pid/smaps and clear_refs into a more generic form, the next
> > couple make those interfaces optional, and the last two introduce the
> > new interfaces, also optional.
> 
> This solves a real-life problem for Oracle system monitoring software
> (specifically EM). Among the tasks it must carry out is determining
> per-process memory footprint of a set of cooperating tasks (i.e. Oracle
> processes). RSS is inadequate for this due to page sharing; this work
> provides sufficient information to determine what EM needs.
> 
> 

I'm still dying to see what the human-readable output from this
thing looks like.

<looks>

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
>
> ...
>
> +       while (count > 0) {
> +               chunk = min_t(size_t, count, PAGE_SIZE);
> +               i = 0;
> +
> +               if (pfn == -1) {
> +                       page[0] = 0;
> +                       page[1] = 0;
> +                       ((char *)page)[0] = (ntohl(1) != 1);

OK.

> +                       ((char *)page)[1] = PAGE_SHIFT;

OK.

> +                       ((char *)page)[2] = sizeof(unsigned long);

OK.

> +                       ((char *)page)[3] = KPMSIZE;

OK.

> +                       i = 2;
> +                       pfn++;
> +               }
> +
> +               for (; i < 2 * chunk / KPMSIZE; i += 2, pfn++) {
> +                       ppage = pfn_to_page(pfn);
> +                       if (!ppage) {
> +                               page[i] = 0;
> +                               page[i + 1] = 0;
> +                       } else {
> +                               page[i] = ppage->flags;
> +                               page[i + 1] = atomic_read(&ppage->_count);
> +                       }
> +               }

Not a good idea to expose raw flags in this manner - it changes at the drop
of a hat.  We'd need to also expose the kernel's PG_foo-to-bitnumber
mapping to make this viable.

Not a good idea to use page->_count: page_count() will be more stable. 
Otherwise OK, I guess: the interpretation of the page refcount is unlikely
to change much over time.

