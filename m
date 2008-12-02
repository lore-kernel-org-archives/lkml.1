Return-Path: <linux-kernel-owner+w=401wt.eu-S1753597AbYLBVjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbYLBVjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 16:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbYLBViw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 16:38:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750982AbYLBViv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 16:38:51 -0500
Date: Tue, 2 Dec 2008 13:36:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       srostedt@redhat.com, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/5] ring-buffer: read page interface
Message-Id: <20081202133654.2dfa51cd.akpm@linux-foundation.org>
In-Reply-To: <20081202203425.040910271@goodmis.org>
References: <20081202203404.496794864@goodmis.org>
	<20081202203425.040910271@goodmis.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Dec 2008 15:34:07 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> Impact: new API to ring buffer
> 
> This patch adds a new interface into the ring buffer that allows a
> page to be read from the ring buffer on a given CPU. For every page
> read, one must also be given to allow for a "swap" of the pages.
> 
>  rpage = ring_buffer_alloc_read_page(buffer);
>  if (!rpage)
> 	goto err;
>  ret = ring_buffer_read_page(buffer, &rpage, cpu, full);
>  if (!ret)
> 	goto empty;
>  process_page(rpage);
>  ring_buffer_free_read_page(rpage);
> 
> The caller of these functions must handle any waits that are
> needed to wait for new data. The ring_buffer_read_page will simply
> return 0 if there is no data, or if "full" is set and the writer
> is still on the current page.
> 
>  ...
>
> +static inline void *
> +__rb_data_page_index(struct buffer_data_page *page, unsigned index)
> +{
> +	return page->data + index;
> +}

Many kernel developers will fall over stunned and confused when they
see a variable called `page' which does not have type `struct page *'. 
This is a very strong kernel convention and this code tromps all over
it :(

How's about renaming all of these everywhere to `bpage' or whatever?

>
> ...
>
> +	if (!local_read(&cpu_buffer->reader_page->page->commit))
>

Rusty (I think it was Rusty) has convincingly argued that local_t is
irredeemably busted.  I forget the details?

