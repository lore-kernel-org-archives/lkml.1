Return-Path: <linux-kernel-owner+w=401wt.eu-S1766901AbXDSRp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766901AbXDSRp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 13:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766902AbXDSRp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 13:45:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:10296 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766901AbXDSRpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 13:45:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TGJe4rrBA7mSKl3CClTCMQ/RlA83huIygUY5crZ9Wnb9tzktK/hnmG676+4SFg75myhqmC+TxNCzx1kxKLS0Y63vKfO3x1dcPn2o1ZaZBIQ4s3RxYvEC7KoxmDGSS/nqSDG4VPcVs4UXJAzPqRrCQcGo5kcm8yHeG8t2ZTKe9Dw=
Message-ID: <29495f1d0704191045u77e8d7e1g87954549b82a0306@mail.gmail.com>
Date: Thu, 19 Apr 2007 10:45:53 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [RFC 6/8] Account for pages in the page cache in terms of base pages
Cc: linux-kernel@vger.kernel.org, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>, "Andi Kleen" <ak@suse.de>,
       "Paul Jackson" <pj@sgi.com>, "Dave Chinner" <dgc@sgi.com>
In-Reply-To: <20070419163535.11948.91100.sendpatchset@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
	 <20070419163535.11948.91100.sendpatchset@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/19/07, Christoph Lameter <clameter@sgi.com> wrote:
> Variable Order Page Cache: Account for higher order pages
>
> NR_FILE_PAGES now counts pages of different order. Maybe we need to
> account in base page sized pages? If so then we need to change
> the way we update the counters. Note that the same would have to be
> done for other counters.
>
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
>
>
> ---
>  mm/filemap.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> Index: linux-2.6.21-rc7/mm/filemap.c
> ===================================================================
> --- linux-2.6.21-rc7.orig/mm/filemap.c  2007-04-19 09:11:13.000000000 -0700
> +++ linux-2.6.21-rc7/mm/filemap.c       2007-04-19 09:14:16.000000000 -0700
> @@ -119,7 +119,8 @@ void __remove_from_page_cache(struct pag
>         radix_tree_delete(&mapping->page_tree, page->index);
>         page->mapping = NULL;
>         mapping->nrpages--;
> -       __dec_zone_page_state(page, NR_FILE_PAGES);
> +       __mod_zone_page_state(page_zone(page), NR_FILE_PAGES,
> +                       -(1 << mapping->order));
>  }
>
>  void remove_from_page_cache(struct page *page)
> @@ -448,7 +449,8 @@ int add_to_page_cache(struct page *page,
>                         page->mapping = mapping;
>                         page->index = offset;
>                         mapping->nrpages++;
> -                       __inc_zone_page_state(page, NR_FILE_PAGES);
> +                       __mod_zone_page_state(page_zone(page), NR_FILE_PAGES,
> +                                       1 << mappig->order);

Typo? should be mapping->order?

Thanks,
Nish
