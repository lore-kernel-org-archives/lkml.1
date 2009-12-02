Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbZLBOub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbZLBOub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 09:50:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZLBOub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 09:50:31 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:43166 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbZLBOua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 09:50:30 -0500
Date: Wed, 2 Dec 2009 08:50:10 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Wu Fengguang <fengguang.wu@intel.com>
cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/24] migrate: page could be locked by hwpoison, dont
 BUG()
In-Reply-To: <20091202043043.840044332@intel.com>
Message-ID: <alpine.DEB.2.00.0912020848300.31731@router.home>
References: <20091202031231.735876003@intel.com> <20091202043043.840044332@intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Dec 2009, Wu Fengguang wrote:

>  mm/migrate.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-mm.orig/mm/migrate.c	2009-11-02 10:18:45.000000000 +0800
> +++ linux-mm/mm/migrate.c	2009-11-02 10:26:16.000000000 +0800
> @@ -556,7 +556,7 @@ static int move_to_new_page(struct page
>  	 * holding a reference to the new page at this point.
>  	 */
>  	if (!trylock_page(newpage))
> -		BUG();
> +		return -EAGAIN;		/* got by hwpoison */
>
>  	/* Prepare mapping for the new page.*/
>  	newpage->index = page->index;

The error handling code in umap_and_move() assumes that the page is
locked upon return from move_to_new_page() even if it failed.

If you return EAGAIN then it may try to unlock a page that is not
locked.


