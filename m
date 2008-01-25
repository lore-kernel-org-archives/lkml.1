Return-Path: <linux-kernel-owner+w=401wt.eu-S1754946AbYAYDDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbYAYDDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 22:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbYAYDDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 22:03:32 -0500
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:27104 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752459AbYAYDDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 22:03:31 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Z9nPyN1aZDz/Clmqu+1C8J99Vb9dexdicUHd9gyNudZK4AK4PnyB9vP9jrhArotnh4dCACBZFf8J/oh0N98bvZJ3Wrk3yRQ9LFp3npUt6aiDaNbeKzBgS1BvvYg91pewSIC7VT7hWzYprupIMj3+Ku0tdfLQ1f7NRR9JvP77iDk=  ;
X-YMail-OSG: z5eKaZQVM1mlp97yHwkVfa1nlB.sH_mbCBuBqJ.0_kZ6c0OSrTu8mm_uGXaB0LYpxh2gaT2.MA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [RFC] some page can't be migrated
Date: Fri, 25 Jan 2008 14:03:23 +1100
User-Agent: KMail/1.9.5
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, clameter <clameter@sgi.com>
References: <1201069357.32059.13.camel@sli10-desk.sh.intel.com>
In-Reply-To: <1201069357.32059.13.camel@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801251403.23236.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 January 2008 17:22, Shaohua Li wrote:
> Anonymous page might have fs-private metadata, the page is truncated. As
> the page hasn't mapping, page migration refuse to migrate the page. It
> appears the page is only freed in page reclaim and if zone watermark is
> low, the page is never freed, as a result migration always fail. I
> thought we could free the metadata so such page can be freed in
> migration and make migration more reliable?

Anonymous pages should not have fs-private metadata.

Orphaned pages I guess you mean? They should not be accessable via
the pagecache or the page tables, so how do they keep tangling up
migration? Where/how is migration finding these pages?!


>
> Thanks,
> Shaohua
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 6a207e8..6bc38f7 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -633,6 +633,17 @@ static int unmap_and_move(new_page_t get_new_page,
> unsigned long private, goto unlock;
>  		wait_on_page_writeback(page);
>  	}
> +
> +	/*
> +	 * See truncate_complete_page(). Anonymous page might have
> +	 * fs-private metadata, the page is truncated. Such page can't be
> +	 * migrated. Try to free metadata, so the page can be freed.
> +	 */
> +	if (!page->mapping && !PageAnon(page) && PagePrivate(page)) {
> +		try_to_release_page(page, GFP_KERNEL);
> +		goto unlock;
> +	}
> +
>  	/*
>  	 * By try_to_unmap(), page->mapcount goes down to 0 here. In this case,
>  	 * we cannot notice that anon_vma is freed while we migrates a page.
>
>
> --
