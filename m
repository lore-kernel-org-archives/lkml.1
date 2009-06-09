Return-Path: <linux-kernel-owner+w=401wt.eu-S1760033AbZFIJ72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760033AbZFIJ72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 05:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755168AbZFIJ7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 05:59:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:54435 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760015AbZFIJ7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 05:59:18 -0400
Date: Tue, 9 Jun 2009 11:59:20 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com
Subject: Re: [PATCH] [10/16] HWPOISON: Handle poisoned pages in set_page_dirty()
Message-ID: <20090609095920.GD14820@wotan.suse.de>
References: <20090603846.816684333@firstfloor.org> <20090603184644.190E71D0281@basil.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603184644.190E71D0281@basil.firstfloor.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03, 2009 at 08:46:43PM +0200, Andi Kleen wrote:
> 
> Bail out early in set_page_dirty for poisoned pages. We don't want any
> of the dirty accounting done or file system write back started, because
> the page will be just thrown away.

I don't agree with adding overhead to fastpaths like this. Your
MCE handler should have already taken care of this so I can't
see what it can gain.

> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  mm/page-writeback.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: linux/mm/page-writeback.c
> ===================================================================
> --- linux.orig/mm/page-writeback.c	2009-06-03 19:36:20.000000000 +0200
> +++ linux/mm/page-writeback.c	2009-06-03 19:36:23.000000000 +0200
> @@ -1304,6 +1304,10 @@
>  {
>  	struct address_space *mapping = page_mapping(page);
>  
> +	if (unlikely(PageHWPoison(page))) {
> +		SetPageDirty(page);
> +		return 0;
> +	}
>  	if (likely(mapping)) {
>  		int (*spd)(struct page *) = mapping->a_ops->set_page_dirty;
>  #ifdef CONFIG_BLOCK
