Return-Path: <linux-kernel-owner+w=401wt.eu-S1756052AbYAHDeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbYAHDeo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 22:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbYAHDeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 22:34:37 -0500
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:41497 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752777AbYAHDeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 22:34:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=vhgcBLPYR541tQm5MdBHKiLsC2RmshLOm0Zdry0QKaHbN6qyTb+bWguTLCptLfFH17raYdq3Hq1qROHgLK5rRYnOa73DLrOwgo2Rx6sYYQBvVxGIgN8GAGYRqI/NVAnhvinzLhCsDsGCywM2PwoCQKUNfPy860x9e+/I3PvK23M=  ;
X-YMail-OSG: 8BkxmtYVM1kTN6aj5msxe523XscPOeauyeNYFaZgsbvJdZDEKjrs_8QKIsTDzS6082eP1BACtw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: free_pages_check
Date: Tue, 8 Jan 2008 14:34:14 +1100
User-Agent: KMail/1.9.5
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Adrian Bunk" <bunk@stusta.de>, LKML <linux-kernel@vger.kernel.org>
References: <86802c440801071843p583f390as53f8b600622b93b2@mail.gmail.com>
In-Reply-To: <86802c440801071843p583f390as53f8b600622b93b2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801081434.14723.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 January 2008 13:43, Yinghai Lu wrote:
> wonder why free_pages_check mm/page_alloc.c is using bit OR than logical OR
>
> @@ -450,9 +450,9 @@ static inline void __free_one_page(struc
>
>  static inline int free_pages_check(struct page *page)
>  {
> -       if (unlikely(page_mapcount(page) |
> -               (page->mapping != NULL)  |
> -               (page_count(page) != 0)  |
> +       if (unlikely(page_mapcount(page) ||
> +               (page->mapping != NULL)  ||
> +               (page_count(page) != 0)  ||
>                 (page->flags & (
>                         1 << PG_lru     |
>                         1 << PG_private |

Because the positive case is extremely rare, so there is no benefit (nor
any correctness requirement) for short-circuit evaluation, and we don't
want to have all the branches that it involves. I think it is 3 more
conditional jumps.
