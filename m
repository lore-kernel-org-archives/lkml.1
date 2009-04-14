Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbZDNG4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbZDNG4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 02:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbZDNG4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 02:56:24 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:30146 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752338AbZDNG4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 02:56:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=u1u3DKOHIOafAP5IwtFytoug0id2o6pqEzTA2jGGwAKqeBdT+NcnEyea8h2DGMpM/hzlWcDe6zvbTEDq8wmMsW06b+nDpagUX99VaMrFUET5Zxd/EsbxgShr9P6Wy8ufH03RAYPw8cAndBUrnedLU0ShkvXpHcP53x/wSXr/fP4=  ;
X-YMail-OSG: 60uvVh4VM1mYwT7w2zr9etk0YQjjAoJdT.DKrpAkV.ECMQVu53hNXOMtUaQUiEjXHdGIVLC7Q7lswAvvYMxERC5uhTRHye_zFa9tbKLcg5B3EKdGqQ9339hf2gCaU958YWqVUfE5I0bNOAMLj0JB3stZgjh60_0qC0dQQdJ037dndwlBxORcHfGL0Gk7e.yuh6KP4MycnrChllQzh3oPaLRuIPeIUuZCs3KqkTMtbXYimAjor044AQUxD2jQCniA2nxATjrTdY.0hDPuBvCr7SqtXit9LFhC2.c2djvLwu860Iatj6JQ1Wv0281gMKlyV_vD_KIHpBmEqx9TINU2Fvjt3A--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH v3 6/6] fix wrong get_user_pages usage in iovlock.c
Date: Tue, 14 Apr 2009 16:56:11 +1000
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Andrea Arcangeli <aarcange@redhat.com>,
       Jeff Moyer <jmoyer@redhat.com>, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       "David S. Miller" <davem@davemloft.net>,
       Chris Leech <christopher.leech@intel.com>, netdev@vger.kernel.org
References: <20090414151204.C647.A69D9226@jp.fujitsu.com> <20090414152151.C659.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090414152151.C659.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904141656.14191.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 April 2009 16:23:13 KOSAKI Motohiro wrote:
> I don't have NET-DMA usable device. I hope to get expert review.
> 
> =========================
> Subject: [Untested][RFC][PATCH] fix wrong get_user_pages usage in iovlock.c
> 
> 	down_read(mmap_sem)
> 	get_user_pages()
> 	up_read(mmap_sem)
> 
> is fork unsafe.
> fix it.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Chris Leech <christopher.leech@intel.com>
> Cc: netdev@vger.kernel.org
> ---
>  drivers/dma/iovlock.c |   18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)
> 
> Index: b/drivers/dma/iovlock.c
> ===================================================================
> --- a/drivers/dma/iovlock.c	2009-02-21 16:53:23.000000000 +0900
> +++ b/drivers/dma/iovlock.c	2009-04-13 04:46:02.000000000 +0900
> @@ -94,18 +94,10 @@ struct dma_pinned_list *dma_pin_iovec_pa
>  		pages += page_list->nr_pages;
>  
>  		/* pin pages down */
> -		down_read(&current->mm->mmap_sem);
> -		ret = get_user_pages(
> -			current,
> -			current->mm,
> -			(unsigned long) iov[i].iov_base,
> -			page_list->nr_pages,
> -			1,	/* write */
> -			0,	/* force */
> -			page_list->pages,
> -			NULL);
> -		up_read(&current->mm->mmap_sem);
> -
> +		down_read(&current->mm->mm_pinned_sem);
> +		ret = get_user_pages_fast((unsigned long) iov[i].iov_base,
> +					  page_list->nr_pages, 1,
> +					  page_list->pages);

I would perhaps not fold gup_fast conversions into the same patch as
the fix.


