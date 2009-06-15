Return-Path: <linux-kernel-owner+w=401wt.eu-S1760763AbZFONJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760763AbZFONJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 09:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbZFONJC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 09:09:02 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:60244 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbZFONJB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 09:09:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vpeb3kR5z1gFVI41ysA3Yz/3ylnVqfUCgAZBs5tPvfFps1QvXoymg9PBaaYrP15p54
         wtOThyQFMcibBOaWmodQsO38BGZ8IxDnpj9y5GP+drn7vDks0mpojgvHAr41RlnAgI+e
         I6OPHjOecO3DXiLq/YWb7D2KJr3i1d+EzPDD0=
MIME-Version: 1.0
In-Reply-To: <20090615031253.530308256@intel.com>
References: <20090615024520.786814520@intel.com>
	 <20090615031253.530308256@intel.com>
Date: Mon, 15 Jun 2009 22:09:03 +0900
Message-ID: <28c262360906150609gd736bf7p7a57de1b81cedd97@mail.gmail.com>
Subject: Re: [PATCH 09/22] HWPOISON: Handle hardware poisoned pages in 
	try_to_unmap
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Mel Gorman <mel@csn.ul.ie>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 11:45 AM, Wu Fengguang<fengguang.wu@intel.com> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> When a page has the poison bit set replace the PTE with a poison entry.
> This causes the right error handling to be done later when a process runs
> into it.
>
> Also add a new flag to not do that (needed for the memory-failure handler
> later)
>
> Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>
> ---
>  include/linux/rmap.h |    1 +
>  mm/rmap.c            |    9 ++++++++-
>  2 files changed, 9 insertions(+), 1 deletion(-)
>
> --- sound-2.6.orig/mm/rmap.c
> +++ sound-2.6/mm/rmap.c
> @@ -958,7 +958,14 @@ static int try_to_unmap_one(struct page
>        /* Update high watermark before we lower rss */
>        update_hiwater_rss(mm);
>
> -       if (PageAnon(page)) {
> +       if (PageHWPoison(page) && !(flags & TTU_IGNORE_HWPOISON)) {
> +               if (PageAnon(page))
> +                       dec_mm_counter(mm, anon_rss);
> +               else if (!is_migration_entry(pte_to_swp_entry(*pte)))

Isn't it straightforward to use !is_hwpoison_entry ?


-- 
Kinds regards,
Minchan Kim
