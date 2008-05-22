Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbYEVRiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbYEVRiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 13:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbYEVRiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 13:38:12 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:9542 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbYEVRiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 13:38:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding:sender;
        b=I8b0AGSEYly1Axm7ShIcliuQqvHosBF1DAhCe46R5XFt7S3aMQ6Jgl0otFDrkbZyRH3rveDHVCluavJlS8jHFCUEcaiiRiW8qL4kxM686wc+k8DH4eDRFiNgGl4UzpsXGvkruomlXLhXmE34uGebGVf46bzcijiGARHylkF1acI=
Date: Thu, 22 May 2008 20:38:00 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, proski@gnu.org,
       sandmann@redhat.com, a.p.zijlstra@chello.nl,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/5] ftrace: limit use of check pages
Message-ID: <20080522203800.47366817@daedalus.pq.iki.fi>
In-Reply-To: <20080522042301.622087604@goodmis.org>
References: <20080522042215.584408893@goodmis.org>
	<20080522042301.622087604@goodmis.org>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008 00:22:16 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> The check_pages function is called often enough that it can cause problems
> with trace outputs or even bringing the system to a halt.
> 
> This patch limits the check_pages to the places that are most likely to
> have problems. The check is made at the flip between the global array and
> the max save array, as well as when the size of the buffers changes and
> the self tests.
> 
> This patch also removes the BUG_ON from check_pages and replaces it with
> a WARN_ON and disabling of the tracer.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/trace.c          |   32 +++++++++++++++++++++++---------
>  kernel/trace/trace_selftest.c |    1 +
>  2 files changed, 24 insertions(+), 9 deletions(-)
> 
> Index: linux-tip.git/kernel/trace/trace.c
> ===================================================================
> --- linux-tip.git.orig/kernel/trace/trace.c	2008-05-21 13:25:34.000000000 -0400
> +++ linux-tip.git/kernel/trace/trace.c	2008-05-21 21:32:23.000000000 -0400
> @@ -249,24 +249,32 @@ __update_max_tr(struct trace_array *tr, 
>  	tracing_record_cmdline(current);
>  }
>  
> +#define CHECK_COND(cond)			\
> +	if (unlikely(cond)) {			\
> +		tracing_disabled = 0;		\

-----------------------------------^
This looks like a typo.

I also quickly read through the other patches and didn't see any
obvious problems in them.

> +		WARN_ON(1);			\
> +		return -1;			\
> +	}
> +
>  /**
>   * check_pages - integrity check of trace buffers
>   *
>   * As a safty measure we check to make sure the data pages have not
> - * been corrupted. TODO: configure to disable this because it adds
> - * a bit of overhead.
> + * been corrupted.
>   */
> -void check_pages(struct trace_array_cpu *data)
> +int check_pages(struct trace_array_cpu *data)
>  {
>  	struct page *page, *tmp;
>  
> -	BUG_ON(data->trace_pages.next->prev != &data->trace_pages);
> -	BUG_ON(data->trace_pages.prev->next != &data->trace_pages);
> +	CHECK_COND(data->trace_pages.next->prev != &data->trace_pages);
> +	CHECK_COND(data->trace_pages.prev->next != &data->trace_pages);
>  
>  	list_for_each_entry_safe(page, tmp, &data->trace_pages, lru) {
> -		BUG_ON(page->lru.next->prev != &page->lru);
> -		BUG_ON(page->lru.prev->next != &page->lru);
> +		CHECK_COND(page->lru.next->prev != &page->lru);
> +		CHECK_COND(page->lru.prev->next != &page->lru);
>  	}
> +
> +	return 0;
>  }


-- 
Pekka Paalanen
http://www.iki.fi/pq/
