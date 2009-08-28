Return-Path: <linux-kernel-owner+w=401wt.eu-S1752299AbZH1MQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbZH1MQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 08:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751129AbZH1MQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 08:16:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:17277 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbZH1MQe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 08:16:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=spbmKVP60GlVm8KMGDR/OrYxDjoIVT13HdNff1fbz0L0IgJk5gNdqp07+iYZX4b78g
         Ke1kdiHBof/xOeUaaoiZ1uaOW80iEWksS1V2QTG7dTZiPHCdHdRnaul8oIVSVixDpLTz
         hCuzcZscBf058acdayC9WmTHK9KavP7/XYbO8=
MIME-Version: 1.0
In-Reply-To: <1251449067-3109-3-git-send-email-mel@csn.ul.ie>
References: <1251449067-3109-1-git-send-email-mel@csn.ul.ie>
	 <1251449067-3109-3-git-send-email-mel@csn.ul.ie>
Date: Fri, 28 Aug 2009 15:16:34 +0300
X-Google-Sender-Auth: cb778615d76af110
Message-ID: <84144f020908280516y6473a531n3f11f3e86251eba4@mail.gmail.com>
Subject: Re: [PATCH 2/2] page-allocator: Maintain rolling count of pages to 
	free from the PCP
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On Fri, Aug 28, 2009 at 11:44 AM, Mel Gorman<mel@csn.ul.ie> wrote:
> -               page = list_entry(list->prev, struct page, lru);
> -               /* have to delete it as __free_one_page list manipulates */
> -               list_del(&page->lru);
> -               trace_mm_page_pcpu_drain(page, 0, migratetype);
> -               __free_one_page(page, zone, 0, migratetype);
> +               do {
> +                       page = list_entry(list->prev, struct page, lru);
> +                       /* must delete as __free_one_page list manipulates */
> +                       list_del(&page->lru);
> +                       __free_one_page(page, zone, 0, migratetype);
> +                       trace_mm_page_pcpu_drain(page, 0, migratetype);

This calls trace_mm_page_pcpu_drain() *after* __free_one_page(). It's
probably not a good idea as __free_one_page() can alter the struct
page in various ways.

> +               } while (--count && --batch_free && !list_empty(list));
>        }
>        spin_unlock(&zone->lock);
>  }
