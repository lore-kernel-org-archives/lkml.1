Return-Path: <linux-kernel-owner+w=401wt.eu-S1754393AbYJASVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbYJASVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 14:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbYJASVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 14:21:22 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:42061 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753573AbYJASVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 14:21:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap8EACNZ40hMQWq+/2dsb2JhbACBZrxegWo
Date: Wed, 1 Oct 2008 14:21:19 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] ring_buffer: allocate buffer page pointer
Message-ID: <20081001182119.GA17524@Krystal>
References: <20080930000307.GA2929@Krystal> <alpine.DEB.1.10.0809292010530.8145@gandalf.stny.rr.com> <20080930034603.GA13801@Krystal> <alpine.DEB.1.10.0809292359030.19533@gandalf.stny.rr.com> <20080930092001.69849210@bike.lwn.net> <1222790072.24384.21.camel@twins> <alpine.LFD.2.00.0809300930090.3389@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809301242550.1984@gandalf.stny.rr.com> <alpine.LFD.2.00.0809300958120.3389@nehalem.linux-foundation.org> <alpine.DEB.1.10.0810011114000.30777@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810011114000.30777@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:20:54 up 118 days, 23:01,  8 users,  load average: 0.15, 0.49,
	1.01
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> The current method of overlaying the page frame as the buffer page pointer
> can be very dangerous and limits our ability to do other things with
> a page from the buffer, like send it off to disk.
> 
> This patch allocates the buffer_page instead of overlaying the page's
> page frame. The use of the buffer_page has hardly changed due to this.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/ring_buffer.c |   54 ++++++++++++++++++++++++++-------------------
>  1 file changed, 32 insertions(+), 22 deletions(-)
> 
> Index: linux-tip.git/kernel/trace/ring_buffer.c
> ===================================================================
> --- linux-tip.git.orig/kernel/trace/ring_buffer.c	2008-10-01 09:37:23.000000000 -0400
> +++ linux-tip.git/kernel/trace/ring_buffer.c	2008-10-01 11:03:16.000000000 -0400
> @@ -115,16 +115,10 @@ void *ring_buffer_event_data(struct ring
>   * Thanks to Peter Zijlstra for suggesting this idea.
>   */
>  struct buffer_page {
> -	union {
> -		struct {
> -			unsigned long	 flags;		/* mandatory */
> -			atomic_t	 _count;	/* mandatory */
> -			u64		 time_stamp;	/* page time stamp */
> -			unsigned	 size;		/* size of page data */
> -			struct list_head list;		/* list of free pages */
> -		};
> -		struct page page;
> -	};
> +	u64		 time_stamp;	/* page time stamp */
> +	unsigned	 size;		/* size of page data */
> +	struct list_head list;		/* list of free pages */
> +	void *page;			/* Actual data page */
>  };
>  
>  /*
> @@ -133,9 +127,9 @@ struct buffer_page {
>   */
>  static inline void free_buffer_page(struct buffer_page *bpage)
>  {
> -	reset_page_mapcount(&bpage->page);
> -	bpage->page.mapping = NULL;
> -	__free_page(&bpage->page);
> +	if (bpage->page)
> +		__free_page(bpage->page);
> +	kfree(bpage);
>  }
>  
>  /*
> @@ -237,11 +231,16 @@ static int rb_allocate_pages(struct ring
>  	unsigned i;
>  
>  	for (i = 0; i < nr_pages; i++) {
> +		page = kzalloc_node(ALIGN(sizeof(*page), cache_line_size()),
> +				    GFP_KERNEL, cpu_to_node(cpu));
> +		if (!page)
> +			goto free_pages;
> +		list_add(&page->list, &pages);
> +
>  		addr = __get_free_page(GFP_KERNEL);

You could probably use alloc_pages_node instead here...

Mathieu

>  		if (!addr)
>  			goto free_pages;
> -		page = (struct buffer_page *)virt_to_page(addr);
> -		list_add(&page->list, &pages);
> +		page->page = (void *)addr;
>  	}
>  
>  	list_splice(&pages, head);
> @@ -262,6 +261,7 @@ static struct ring_buffer_per_cpu *
>  rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
>  {
>  	struct ring_buffer_per_cpu *cpu_buffer;
> +	struct buffer_page *page;
>  	unsigned long addr;
>  	int ret;
>  
> @@ -275,10 +275,17 @@ rb_allocate_cpu_buffer(struct ring_buffe
>  	spin_lock_init(&cpu_buffer->lock);
>  	INIT_LIST_HEAD(&cpu_buffer->pages);
>  
> +	page = kzalloc_node(ALIGN(sizeof(*page), cache_line_size()),
> +			    GFP_KERNEL, cpu_to_node(cpu));
> +	if (!page)
> +		goto fail_free_buffer;
> +
> +	cpu_buffer->reader_page = page;
>  	addr = __get_free_page(GFP_KERNEL);
>  	if (!addr)
> -		goto fail_free_buffer;
> -	cpu_buffer->reader_page = (struct buffer_page *)virt_to_page(addr);
> +		goto fail_free_reader;
> +	page->page = (void *)addr;
> +
>  	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
>  	cpu_buffer->reader_page->size = 0;
>  
> @@ -523,11 +530,16 @@ int ring_buffer_resize(struct ring_buffe
>  
>  	for_each_buffer_cpu(buffer, cpu) {
>  		for (i = 0; i < new_pages; i++) {
> +			page = kzalloc_node(ALIGN(sizeof(*page),
> +						  cache_line_size()),
> +					    GFP_KERNEL, cpu_to_node(cpu));
> +			if (!page)
> +				goto free_pages;
> +			list_add(&page->list, &pages);
>  			addr = __get_free_page(GFP_KERNEL);
>  			if (!addr)
>  				goto free_pages;
> -			page = (struct buffer_page *)virt_to_page(addr);
> -			list_add(&page->list, &pages);
> +			page->page = (void *)addr;
>  		}
>  	}
>  
> @@ -567,9 +579,7 @@ static inline int rb_null_event(struct r
>  
>  static inline void *rb_page_index(struct buffer_page *page, unsigned index)
>  {
> -	void *addr = page_address(&page->page);
> -
> -	return addr + index;
> +	return page->page + index;
>  }
>  
>  static inline struct ring_buffer_event *
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
