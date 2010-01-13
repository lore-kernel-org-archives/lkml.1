Return-Path: <linux-kernel-owner+w=401wt.eu-S1755991Ab0AMQHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab0AMQHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 11:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755885Ab0AMQHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 11:07:20 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:61192 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab0AMQHT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 11:07:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=G57cBOtclyhn1we9X278eMTXSyOt2VU0Nu8yxp3iYh0W3z4MiZAAFM3fKgRkxMMQQs
         OrBiP5nPwCtgtKOu6WcnziHe271mjkQtEQumx/TrTMPaaHhqoiL1zYyj/Vt53DYc5xUC
         M/CQh/iuUbdtUP3+8PvSFknGEJMW/ps22pNJ0=
MIME-Version: 1.0
In-Reply-To: <20100113155503.GA2902@hack>
References: <3a3680031001130654q1928df60pde0e3706ea2461c@mail.gmail.com>
	 <20100113155503.GA2902@hack>
Date: Thu, 14 Jan 2010 00:07:19 +0800
Message-ID: <3a3680031001130807nafe1246u141438935fe5fab@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm: remove function free_hot_page
From: Li Hong <lihong.hi@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just think it is needless to add a simple wrap function here whether
it is inlined
or not.

-LH

2010/1/13 Américo Wang <xiyou.wangcong@gmail.com>:
> On Wed, Jan 13, 2010 at 10:54:50PM +0800, Li Hong wrote:
>>Now fuction 'free_hot_page' is just a wrap of ' free_hot_cold_page' with
>>parameter 'cold = 0'. After adding a clear comment for 'free_hot_cold_page', it
>>is reasonable to remove a level of call.
>
> How? The compiler can certainly inline it.
>
>>
>>Signed-off-by: Li Hong <lihong.hi@gmail.com>
>>---
>> mm/page_alloc.c |    8 ++------
>> mm/swap.c       |    2 +-
>> 2 files changed, 3 insertions(+), 7 deletions(-)
>>
>>diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>index 175dd36..c88e03d 100644
>>--- a/mm/page_alloc.c
>>+++ b/mm/page_alloc.c
>>@@ -1073,6 +1073,7 @@ void mark_free_pages(struct zone *zone)
>>
>> /*
>>  * Free a 0-order page
>>+ * cold == 1 ? free a cold page : free a hot page
>>  */
>> static void free_hot_cold_page(struct page *page, int cold)
>> {
>>@@ -1135,11 +1136,6 @@ out:
>>        put_cpu();
>> }
>>
>>-void free_hot_page(struct page *page)
>>-{
>>-       free_hot_cold_page(page, 0);
>>-}
>>-
>> /*
>>  * split_page takes a non-compound higher-order page, and splits it into
>>  * n (1<<order) sub-pages: page[0..n]
>>@@ -2014,7 +2010,7 @@ void __free_pages(struct page *page, unsigned int order)
>> {
>>        if (put_page_testzero(page)) {
>>                if (order == 0)
>>-                       free_hot_page(page);
>>+                       free_hot_cold_page(page, 0);
>>                else
>>                        __free_pages_ok(page, order);
>>        }
>>diff --git a/mm/swap.c b/mm/swap.c
>>index 308e57d..9036b89 100644
>>--- a/mm/swap.c
>>+++ b/mm/swap.c
>>@@ -55,7 +55,7 @@ static void __page_cache_release(struct page *page)
>>                del_page_from_lru(zone, page);
>>                spin_unlock_irqrestore(&zone->lru_lock, flags);
>>        }
>>-       free_hot_page(page);
>>+       free_hot_cold_page(page, 0);
>> }
>>
>> static void put_compound_page(struct page *page)
>>--
>>1.6.3.3
>>--
>>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>Please read the FAQ at  http://www.tux.org/lkml/
>
> --
> Live like a child, think like the god.
>
>
