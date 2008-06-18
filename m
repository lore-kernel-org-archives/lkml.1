Return-Path: <linux-kernel-owner+w=401wt.eu-S1751341AbYFRHk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341AbYFRHk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 03:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750737AbYFRHkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 03:40:21 -0400
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:35067 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750717AbYFRHkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 03:40:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=a269rwNGTr13x3cZb98SitQiTljY3repl6KQQT3dL9yrxaeaub2TqMiLSw8DbMuEsdoUu/KLK7MSzreOTaCm2gkBvI+gBY4LAAuy+B9GGpTLUMATPmDNp27B+XAe6d3lCZRQDSVVx6yhkBAlmaK7XwLC0Iuihm1q1ZPcYVgX57g=  ;
X-YMail-OSG: nIsmuaUVM1kfNmTlOGS02Jljjv7Iw.Q7adn6wQWsli7MUx2N5Za4IfQhlikNID7gZ0ICLM7UdXXGn_YFBRq2i_ydMMUteG1CCeCciDUR_.PTxlxX6plLVoLAQt2LRLcv9zo-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH -mm][BUGFIX] migration_entry_wait fix. v2
Date: Wed, 18 Jun 2008 17:40:07 +1000
User-Agent: KMail/1.9.5
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       "hugh@veritas.com" <hugh@veritas.com>
References: <20080611225945.4da7bb7f.akpm@linux-foundation.org> <20080618155233.7dd79312.kamezawa.hiroyu@jp.fujitsu.com> <20080618162944.2f8fd265.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080618162944.2f8fd265.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806181740.07749.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 June 2008 17:29, KAMEZAWA Hiroyuki wrote:
> In speculative page cache look up protocol, page_count(page) is set to 0
> while radix-tree modification is going on, truncation, migration, etc...
>
> While page migration, a page fault to page under migration does
>  - look up page table
>  - find it is migration_entry_pte
>  - decode pfn from migration_entry_pte and get page of pfn_page(pfn)
>  - wait until page is unlocked
>
> It does get_page() -> wait_on_page_locked() -> put_page() now.
>
> In page migration's radix-tree replacement, page_freeze_refs() ->
> page_unfreeze_refs() is called. And page_count(page) turns to be zero
> and must be kept to be zero while radix-tree replacement.
>
> If get_page() is called against a page under radix-tree replacement,
> the kernel panics(). To avoid this, we shouldn't increment page_count()
> if it is zero. This patch uses get_page_unless_zero().
>
> Even if get_page_unless_zero() fails, the caller just retries.
> But will be a bit busier.
>
> Change log v1->v2:
>  - rewrote the patch description and added comments.
>

Thanks

Acked-by: Nick Piggin <npiggin@suse.de>

Andrew, this is a bugfix to mm-speculative-page-references.patch

> From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/migrate.c |   11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> Index: test-2.6.26-rc5-mm3/mm/migrate.c
> ===================================================================
> --- test-2.6.26-rc5-mm3.orig/mm/migrate.c
> +++ test-2.6.26-rc5-mm3/mm/migrate.c
> @@ -242,8 +242,15 @@ void migration_entry_wait(struct mm_stru
>  		goto out;
>
>  	page = migration_entry_to_page(entry);
> -
> -	get_page(page);
> +	/*
> +	 * Once radix-tree replacement of page migration started, page_count
> +	 * *must* be zero. And, we don't want to call wait_on_page_locked()
> +	 * against a page without get_page().
> +	 * So, we use get_page_unless_zero(), here. Even failed, page fault
> +	 * will occur again.
> +	 */
> +	if (!get_page_unless_zero(page))
> +		goto out;
>  	pte_unmap_unlock(ptep, ptl);
>  	wait_on_page_locked(page);
>  	put_page(page);
