Return-Path: <linux-kernel-owner+w=401wt.eu-S1760359AbYHDGWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760359AbYHDGWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 02:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbYHDGWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 02:22:36 -0400
Received: from relay2.sgi.com ([192.48.171.30]:43753 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751972AbYHDGWf (ORCPT
	<rfc822;@sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 02:22:35 -0400
Message-ID: <4896A197.3090004@sgi.com>
Date: Mon, 04 Aug 2008 16:28:39 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Linux Memory Management List <linux-mm@kvack.org>, xfs@oss.sgi.com,
       xen-devel@lists.xensource.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       dri-devel@lists.sourceforge.net
Subject: Re: [rfc][patch 3/3] xfs: use new vmap API
References: <20080728123438.GA13926@wotan.suse.de> <20080728123703.GC13926@wotan.suse.de>
In-Reply-To: <20080728123703.GC13926@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.

Nick Piggin wrote:
> Implement XFS's large buffer support with the new vmap APIs. See the vmap
> rewrite patch for some numbers.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>
> ---
> 
> Index: linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_buf.c
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
> @@ -265,7 +265,7 @@ xfs_buf_free(
>  		uint		i;
>  
>  		if ((bp->b_flags & XBF_MAPPED) && (bp->b_page_count > 1))
> -			vunmap(bp->b_addr - bp->b_offset);
> +			vm_unmap_ram(bp->b_addr - bp->b_offset, bp->b_page_count);
>  
>  		for (i = 0; i < bp->b_page_count; i++) {
>  			struct page	*page = bp->b_pages[i];
> @@ -387,8 +387,8 @@ _xfs_buf_map_pages(
>  		bp->b_addr = page_address(bp->b_pages[0]) + bp->b_offset;
>  		bp->b_flags |= XBF_MAPPED;
>  	} else if (flags & XBF_MAPPED) {
> -		bp->b_addr = vmap(bp->b_pages, bp->b_page_count,
> -					VM_MAP, PAGE_KERNEL);
> +		bp->b_addr = vm_map_ram(bp->b_pages, bp->b_page_count,
> +					-1, PAGE_KERNEL);
>  		if (unlikely(bp->b_addr == NULL))
>  			return -ENOMEM;
>  		bp->b_addr += bp->b_offset;
> 
> 
> 
