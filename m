Return-Path: <linux-kernel-owner+w=401wt.eu-S1161199AbXDEFXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161199AbXDEFXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 01:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161200AbXDEFXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 01:23:48 -0400
Received: from ns1.suse.de ([195.135.220.2]:52388 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161199AbXDEFXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 01:23:47 -0400
Date: Thu, 5 Apr 2007 07:23:36 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, npiggin@suse.de, hugh@veritas.com,
       akpm@linux-foundation.org, linux-mm@kvack.org, tee@sgi.com,
       holt@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [rfc] no ZERO_PAGE?
Message-ID: <20070405052336.GQ19587@v2.random>
References: <20070330024048.GG19407@wotan.suse.de> <20070404033726.GE18507@wotan.suse.de> <Pine.LNX.4.64.0704040830500.6730@woody.linux-foundation.org> <20070404.131111.62667528.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070404.131111.62667528.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 01:11:11PM -0700, David S. Miller wrote:
> If we're going to consider this seriously, there is a case I know of.
> Look at flush_dcache_page()'s test for ZERO_PAGE() on sparc64, there
> is an instructive comment:
> 
> 	/* Do not bother with the expensive D-cache flush if it
> 	 * is merely the zero page.  The 'bigcore' testcase in GDB
> 	 * causes this case to run millions of times.
> 	 */
> 	if (page == ZERO_PAGE(0))
> 		return;
> 
> basically what the GDB test case does it mmap() an enormous anonymous
> area, not touch it, then dump core.
> 
> As I understand the patch being considered to remove ZERO_PAGE(), this
> kind of core dump will cause a lot of pages to be allocated, probably
> eating up a lot of system time as well as memory.

Well, if we leave the zero page in because there may be too many apps
to optimize, we still have to fix the zero page handling. Current code
is far from ideal. Currently the zero page scales worse than
no-zero-page, at the very least all the page count/mapcount
increase/decrease at every map-in/zap must be dropped from memory.c,
otherwise two totally unrelated gdb running at the same time (or gdb
at the same time of fortran, or two unrelated fortran apps) will badly
trash over the zero page reference counting.

Besides the backwards compatibility argument with gdb or similar apps
I doubt the zero page is a really worthwhile optimization and I guess
we'd be better off if it never existed.
