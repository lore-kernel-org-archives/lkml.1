Return-Path: <linux-kernel-owner+w=401wt.eu-S1757537AbZBIOS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbZBIOS3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 09:18:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756170AbZBIOSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 09:18:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63266 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780AbZBIOSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 09:18:08 -0500
Date: Mon, 9 Feb 2009 09:18:07 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ring_buffer: fix typing mistake
In-Reply-To: <498FCB5A.5030207@cn.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0902090916340.14528@gandalf.stny.rr.com>
References: <498FCB5A.5030207@cn.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 9 Feb 2009, Lai Jiangshan wrote:

> 
> Impact: Fix bug
> 
> I found several very very curious line.
> It's so curious that it may be brought by typing mistake.
> 
> When (cpu_buffer->reader_page == cpu_buffer->commit_page):
> 
> 1) We haven't copied it for bpage is changed:
>    bpage = cpu_buffer->reader_page->page;
>    memcpy(bpage->data, cpu_buffer->reader_page->page->data + read ... )
> 2) We need update cpu_buffer->reader_page->read, but
>    "cpu_buffer->reader_page += read;" is not right.

Ouch! That is a bug.

Ingo, this is an urgent fix. Want me to pull it in and send it off to you?

-- Steve


> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  ring_buffer.c |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index bd38c5c..e97acae 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -2377,7 +2377,7 @@ void ring_buffer_free_read_page(struct ring_buffer *buffer, void *data)
>   * to swap with a page in the ring buffer.
>   *
>   * for example:
> - *	rpage = ring_buffer_alloc_page(buffer);
> + *	rpage = ring_buffer_alloc_read_page(buffer);
>   *	if (!rpage)
>   *		return error;
>   *	ret = ring_buffer_read_page(buffer, &rpage, cpu, 0);
> @@ -2432,18 +2432,17 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
>  	 */
>  	if (cpu_buffer->reader_page == cpu_buffer->commit_page) {
>  		unsigned int read = cpu_buffer->reader_page->read;
> +		unsigned int commit = rb_page_commit(cpu_buffer->reader_page);
>  
>  		if (full)
>  			goto out;
>  		/* The writer is still on the reader page, we must copy */
> -		bpage = cpu_buffer->reader_page->page;
>  		memcpy(bpage->data,
>  		       cpu_buffer->reader_page->page->data + read,
> -		       local_read(&bpage->commit) - read);
> +		       commit - read);
>  
>  		/* consume what was read */
> -		cpu_buffer->reader_page += read;
> -
> +		cpu_buffer->reader_page->read = commit;
>  	} else {
>  		/* swap the pages */
>  		rb_init_page(bpage);
> 
> 
> 
> 
> 
