Return-Path: <linux-kernel-owner+w=401wt.eu-S1757777Ab0ANWs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777Ab0ANWs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757125Ab0ANWsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:48:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757088Ab0ANWsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:48:23 -0500
Date: Thu, 14 Jan 2010 14:47:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Hong <lihong.hi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH 1/3] mm: page_alloc.c Remove duplicate call to
 trace_mm_page_free_direct
Message-Id: <20100114144732.6f0f82a6.akpm@linux-foundation.org>
In-Reply-To: <20100113144917.GA11934@xhl>
References: <20100113144917.GA11934@xhl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jan 2010 22:49:17 +0800
Li Hong <lihong.hi@gmail.com> wrote:

> Function 'trace_mm_page_free_direct' is called in function '__free_pages'.
> But it is called again in 'free_hot_page' if order == 0 and produce duplicate
> records in trace file for mm_page_free_direct event. As below:

When naming functions in changelogs you can just use the name of the
function followed by (), such as trace_mm_page_free_direct().  There's
no need to call it "function 'trace_mm_page_free_direct'".

> K-PID    CPU#    TIMESTAMP  FUNCTION
>   gnome-terminal-1567  [000]  4415.246466: mm_page_free_direct: page=ffffea0003db9f40 pfn=1155800 order=0
>   gnome-terminal-1567  [000]  4415.246468: mm_page_free_direct: page=ffffea0003db9f40 pfn=1155800 order=0
>   gnome-terminal-1567  [000]  4415.246506: mm_page_alloc: page=ffffea0003db9f40 pfn=1155800 order=0 migratetype=0 gfp_flags=GFP_KERNEL
>   gnome-terminal-1567  [000]  4415.255557: mm_page_free_direct: page=ffffea0003db9f40 pfn=1155800 order=0
>   gnome-terminal-1567  [000]  4415.255557: mm_page_free_direct: page=ffffea0003db9f40 pfn=1155800 order=0
> 
> This patch removes the first call and add a call to 'trace_mm_page_free_direct'
> in '__free_pages_ok'.
> 
> Signed-off-by: Li Hong <lihong.hi@gmail.com>
> ---
>  mm/page_alloc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 4e9f5cc..24344cd 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -582,6 +582,7 @@ static void __free_pages_ok(struct page *page, unsigned int order)
>         int bad = 0;
>         int wasMlocked = __TestClearPageMlocked(page);
>  
> +       trace_mm_page_free_direct(page, order);
>         kmemcheck_free_shadow(page, order);
>  
>         for (i = 0 ; i < (1 << order) ; ++i)
> @@ -2012,7 +2013,6 @@ void __pagevec_free(struct pagevec *pvec)
>  void __free_pages(struct page *page, unsigned int order)
>  {
>         if (put_page_testzero(page)) {
> -               trace_mm_page_free_direct(page, order);

Your email client replaces tabs with spaces.  I can fix that up, but
please do repair that email client.  Documentation/email-clients.txt
has some help for gmail, but it's ugly.

