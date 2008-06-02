Return-Path: <linux-kernel-owner+w=401wt.eu-S1756340AbYFBX6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340AbYFBX6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 19:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbYFBX6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 19:58:10 -0400
Received: from smtp113.mail.mud.yahoo.com ([209.191.84.66]:41631 "HELO
	smtp113.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753716AbYFBX6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 19:58:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=lnK73DN63kkoOaQYk4xTc56wFTiZ7JeQVUKkGPAPzuOdhyosBbgKJkfbDBhf2bmT0PMdCgishz9F1Z6X+LzJRBqiql8Ek7OzwssXGR2kAURiBV/PDCtduNhSxfO/Zd3T0OZkfUTcEvaw9iTAFUdLLrDNqV2vLs8YSucJmjzsMvo=  ;
X-YMail-OSG: hDO0pg8VM1kfFoPNDkpXdWiOU32hUYfajzYfECNOamNg0Rur9fbFaYPDZgYQ0zRzQ9PDKuV85nzyGxcCvxMOf1ET.aukIIChuXe1VkjznvV68jRPv71M1IaxvLNnRND6rSFuIu_C4If.e1_Cnt_BMsEiA2qknt2wLy_7Kl_prUSSzKnt..E-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: schwidefsky@de.ibm.com
Subject: Re: [PATCH] Optimize page_remove_rmap for anon pages
Date: Tue, 3 Jun 2008 09:57:48 +1000
User-Agent: KMail/1.9.5
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
References: <1212069392.16984.25.camel@localhost>
In-Reply-To: <1212069392.16984.25.camel@localhost>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200806030957.49069.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 May 2008 23:56, Martin Schwidefsky wrote:
> Greetings,
> with a recent performance analysis we discovered something interesting
> in regard to the physical dirty bits found on s390. The page_remove_rmap
> function stands out when areas of anonymous memory gets unmapped. The
> reason is the transfer of the dirty bit from the page storage key to the
> struct page when the last mapper of a page is removed. For anonymous
> pages that cease to exist this is superfluous. Without the storage key
> operations process termination is noticable faster, e.g. for a gcc test
> case we got a speedup of 2%.
> To get this done page_remove_rmap needs to know if the page dirty bit
> can be ignored. The page_test_dirty / page_clear_dirty call can only be
> avoided if page_remove_rmap is called from zap_pte_range or do_wp_page.
> If it is called from any other place - in particular try_to_unmap_one -
> the page dirty bit may not be ignored.
> The patch below introduces a new function to do that, in lack of a
> better name I called it page_zap_rmap. Comments ?

I don't know if it is that simple, is it?

I don't know how you are guaranteeing the given page ceases to exist.
Even checking for the last mapper of the page (which you don't appear
to do anyway) isn't enough because there could be a swapcount, in which
case you should still have to mark the page as dirty.

For example (I think, unless s390 somehow propogates the dirty page
bit some other way that I've missed), wouldn't the following break:

process p1 allocates anonymous page A
p1 dirties A
p1 forks p2, A now has a mapcount of 2
p2 VM_LOCKs A (something to prevent it being swapped)
page reclaim unmaps p1's pte, fails on p2
p2 exits, page_dirty does not get checked because of this patch
page has mapcount 0, PG_dirty is clear
Page reclaim can drop it without writing it to swap


Or am I misunderstanding something?

As far as the general idea goes, it might be possible to avoid the
check somehow, but you'd want to be pretty sure of yourself before
diverging the s390 path further from the common code base, no?

The "easy" way to do it might be just unconditionally mark the page
as dirty in this path (if the pte was writeable), so you can avoid
the page_test_dirty check and be sure of not missing the dirty bit.
