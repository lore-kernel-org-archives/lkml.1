Return-Path: <linux-kernel-owner+w=401wt.eu-S1758035AbYDOJfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035AbYDOJfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 05:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757762AbYDOJfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 05:35:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757457AbYDOJfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 05:35:10 -0400
Date: Tue, 15 Apr 2008 02:35:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: mm/page_alloc.c: remove hand-coded get_order()
Message-Id: <20080415023505.2c5eac5f.akpm@linux-foundation.org>
In-Reply-To: <20080415092317.GA1529@elf.ucw.cz>
References: <20080415092317.GA1529@elf.ucw.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2008 11:23:27 +0200 Pavel Machek <pavel@ucw.cz> wrote:

> 
> __get_free_pages() is strange interface:
> 
> It has underscores, yet get_free_pages() does not exists.
> 
> It returns long when most people need pointer.

It is a bit odd.

> (And it takes order, when many people want to pass size).
> 
> What about creating void *get_free_pages(flags, order) version,

Sounds sensible.  It matches free_pages().

> then slowly converting users to it?

alas, poor me.

> 
> ---
> 
> Remove hand-coded get_order() from page_alloc.c.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 402a504..c48aa45 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4339,9 +4339,7 @@ void *__init alloc_large_system_hash(con
>  		else if (hashdist)
>  			table = __vmalloc(size, GFP_ATOMIC, PAGE_KERNEL);
>  		else {
> -			unsigned long order;
> -			for (order = 0; ((1UL << order) << PAGE_SHIFT) < size; order++)
> -				;
> +			unsigned long order = get_order(size);
>  			table = (void*) __get_free_pages(GFP_ATOMIC, order);
>  			/*
>  			 * If bucketsize is not a power-of-two, we may free
> 

OK.  get_order() does round up, doesn't it?  We seem to have forgotten to
document that rather important detail.

