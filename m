Return-Path: <linux-kernel-owner+w=401wt.eu-S1752648AbXE3Aox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbXE3Aox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 20:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbXE3Aoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 20:44:46 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:47443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750947AbXE3Aop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 20:44:45 -0400
Date: Tue, 29 May 2007 17:44:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch 2/2] m68k: Discontinuous memory support
Message-Id: <20070529174435.80a13c24.akpm@linux-foundation.org>
In-Reply-To: <20070528191715.597623909@mail.of.borg>
References: <20070528191630.377693320@mail.of.borg>
	<20070528191715.597623909@mail.of.borg>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 May 2007 21:16:32 +0200
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> +	for_each_online_pgdat(pgdat) {
> +		for (i = 0; i < pgdat->node_spanned_pages; i++) {
> +			struct page *page = pgdat->node_mem_map + i;
> +			total++;
> +			if (PageReserved(page))
> +				reserved++;
> +			else if (PageSwapCache(page))
> +				cached++;
> +			else if (!page_count(page))
> +				free++;

This isn't really true.  Callers of the page allocator don't _have_ to use
page_count(): they can internally perform their own refcounting.  One such
caller is slab, so this "free" count can end up being grossly wrong.

> +			else
> +				shared += page_count(page) - 1;
> +		}


