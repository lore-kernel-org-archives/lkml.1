Return-Path: <linux-kernel-owner+w=401wt.eu-S1757454AbZEZTOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbZEZTOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 15:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756248AbZEZTOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 15:14:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34665 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbZEZTOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 15:14:31 -0400
Date: Tue, 26 May 2009 15:14:30 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
cc: mingo@elte.hu, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ring_buffer: use list_replace() in
 rb_get_reader_page()
In-Reply-To: <4A1A1770.6070103@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0905261510080.26705@gandalf.stny.rr.com>
References: <4A1A1770.6070103@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 25 May 2009, Xiao Guangrong wrote:

> Use list_replace() to splice list in rb_get_reader_page()

This code is very sensitive to change. But I think you actually uncovered 
a potential bug. There was a reason that I did not use list_replace, and 
it is because we need memory barriers here. And that is the bug you 
uncovered. We don't have memory barriers.

Ah, it's not a bug (yet). When we make this lockless we will need to add 
memory barriers here. Once reader->list.prev->next points to 
cpu_buffer->reader_page->list, the cpu_buffer->reader_page->list had 
better have both next and prev visible.

If we add this code now, we will just have to remove it when it goes 
lockless.

-- Steve



> 
> [ Impact: cleanup ]
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  kernel/trace/ring_buffer.c |   12 ++----------
>  1 files changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index f558b37..f88bfcc 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -2179,22 +2179,14 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
>  	if (cpu_buffer->commit_page == cpu_buffer->reader_page)
>  		goto out;
>  
> -	/*
> -	 * Splice the empty reader page into the list around the head.
> -	 * Reset the reader page to size zero.
> -	 */
> -
> +	/* Reset the reader page to size zero */
>  	reader = cpu_buffer->head_page;
> -	cpu_buffer->reader_page->list.next = reader->list.next;
> -	cpu_buffer->reader_page->list.prev = reader->list.prev;
> -
>  	local_set(&cpu_buffer->reader_page->write, 0);
>  	local_set(&cpu_buffer->reader_page->entries, 0);
>  	local_set(&cpu_buffer->reader_page->page->commit, 0);
>  
>  	/* Make the reader page now replace the head */
> -	reader->list.prev->next = &cpu_buffer->reader_page->list;
> -	reader->list.next->prev = &cpu_buffer->reader_page->list;
> +	list_replace(&reader->list, &cpu_buffer->reader_page->list);
>  
>  	/*
>  	 * If the tail is on the reader, then we must set the head
> -- 
> 1.6.1.2
> 
> 
> 
