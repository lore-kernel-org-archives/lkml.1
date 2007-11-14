Return-Path: <linux-kernel-owner+w=401wt.eu-S1757465AbXKNVlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465AbXKNVlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 16:41:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755736AbXKNVkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 16:40:52 -0500
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:21874 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754381AbXKNVkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 16:40:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=UGSwWLkpg+vDIjygoRQaewmcFnnxtEcTSG9E3zZ3ZlTthmduZhwesAEqaOS7pRzuIV5ZG4173ohe+2e19E2zouHq9t4bQKFASrfwHoA43+ThUilj1IFKWMcjdZEvBffED1+MTtyoXJhNJExvVLpNCd/Qrt/EvoADKOAJpyuvPlk=  ;
X-YMail-OSG: I1Zdel4VM1mSubA0llj.TYEzl7RzvlsvFVzdBYt1lHnguLay
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Robert Bragg" <robert@sixbynine.org>
Subject: Re: [PATCH] mm: Don't allow ioremapping of ranges larger than vmalloc space
Date: Wed, 14 Nov 2007 20:16:14 +1100
User-Agent: KMail/1.9.5
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <e04d66f60711141031waeb9f1bu34a8fa4cadd5d6c3@mail.gmail.com>
In-Reply-To: <e04d66f60711141031waeb9f1bu34a8fa4cadd5d6c3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711142016.14931.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 November 2007 05:31, Robert Bragg wrote:
> When running with a 16M IOREMAP_MAX_ORDER (on armv7) we found that the
> vmlist search routine in __get_vm_area_node can mistakenly allow a driver
> to ioremap a range larger than vmalloc space.
>
> If at the time of the ioremap all existing vmlist areas sit below the
> determined alignment then the search routine continues past all entries and
> exits the for loop - straight into the found: label - without ever testing
> for integer wrapping or that the requested size fits.
>
> We were seeing a driver successfully ioremap 128M of flash even though
> there was only 120M of vmalloc space. From that point the system was left
> with the remainder
> of the first 16M of space to vmalloc/ioremap within.
>
> Signed-off-by: Robert Bragg <robert@sixbynine.org>
>
> ---
>
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index af77e17..06a7f3a 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -216,6 +216,10 @@ static struct vm_struct *__get_vm_area_node
>  		if (addr > end - size)
>  			goto out;
>  	}
> +	if ((size + addr) < addr)
> +		goto out;
> +	if (addr > end - size)
> +		goto out;
>
>  found:
>  	area->next = *p;

Yeah I noticed these missing checks when recently working in
this area as well. Weren't sure if I was missing something or
not.

Acked-by: Nick Piggin <npiggin@suse.de>
