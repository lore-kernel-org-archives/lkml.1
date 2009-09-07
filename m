Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbZIGOPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbZIGOPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 10:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbZIGOPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 10:15:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:59951 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbZIGOPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 10:15:51 -0400
Date: Mon, 7 Sep 2009 16:15:48 +0200
From: Nick Piggin <npiggin@suse.de>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: chris.mason@oracle.com, david@fromorbit.com,
       Andrew Morton <akpm@linux-foundation.org>,
       "Bityutskiy Artem (Nokia-M/Helsinki)" <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] mm: write_cache_pages be more sequential
Message-ID: <20090907141548.GA28054@wotan.suse.de>
References: <4AA513AA.3010206@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA513AA.3010206@nokia.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07, 2009 at 05:07:38PM +0300, Adrian Hunter wrote:
> >From 6f3bb7c26936c45d810048f59c369e8d5a5623fc Mon Sep 17 00:00:00 2001
> From: Adrian Hunter <adrian.hunter@nokia.com>
> Date: Mon, 7 Sep 2009 10:49:11 +0300
> Subject: [PATCH] mm: write_cache_pages be more sequential
> 
> If a file is written to sequentially, then writeback
> should write the pages sequentially also.  However,
> that does not always happen.  For example:
> 
> 1) user writes pages 0, 1 and 2 but 2 is incomplete
> 2) write_cache_pages writes pages 0, 1 and 2 and sets
> writeback_index to 3
> 3) user finishes writing page 2 and writes pages 3 and 4
> 4) write_cache_pages writes pages 3 and 4, and then cycles
> back and writes page 2 again.
> 
> So the pages are written out in the order 0, 1, 2, 3 ,4 ,2
> instead of 0, 1, 2, 2, 3, 4.

Why does page 2 get set dirty if the write was incomplete?

 
> This situation was noticed on UBIFS because it writes
> directly from writepage.  Hence if there is an unexpected
> power-loss, a file will end up with a hole even though
> the file was written sequentially by the user.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
> ---
> mm/page-writeback.c |    2 ++
> 1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 81627eb..7410b7a 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -960,6 +960,8 @@ int write_cache_pages(struct address_space *mapping,
> 	pagevec_init(&pvec, 0);
> 	if (wbc->range_cyclic) {
> 		writeback_index = mapping->writeback_index; /* prev offset */
> +		if (writeback_index)
> +			writeback_index -= 1;
> 		index = writeback_index;
> 		if (index == 0)
> 			cycled = 1;

Doesn't this just break range_cyclic? range_cyclic is supposed to
work across calls to write_cache_pages, and it's there I guess so
background writeout will be able to eventually get around to writing
all pages relatively fairly in the presence of redirtying operations.

