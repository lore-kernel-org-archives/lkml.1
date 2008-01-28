Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbYA1Fws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbYA1Fws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 00:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbYA1Fwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 00:52:37 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49677 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753870AbYA1Fwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 00:52:36 -0500
Date: Sun, 27 Jan 2008 21:52:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] Only print kernel debug information for OOMs caused by
 kernel allocations
Message-Id: <20080127215249.94db142b.akpm@linux-foundation.org>
In-Reply-To: <20080116222421.GA7953@wotan.suse.de>
References: <20080116222421.GA7953@wotan.suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2008 23:24:21 +0100 Andi Kleen <ak@suse.de> wrote:

> 
> I recently suffered an 20+ minutes oom thrash disk to death and computer
> completely unresponsive situation on my desktop when some user program
> decided to grab all memory. It eventually recovered, but left lots
> of ugly and imho misleading messages in the kernel log. here's a minor
> improvement
> 
> -Andi
> 
> ---
> 
> Only print kernel debug information for OOMs caused by kernel allocations
> 
> For any page cache allocation don't print the backtrace and the detailed
> zone debugging information. This makes the problem look less like 
> a kernel bug because it typically isn't.
> 
> I needed a new task flag for that. Since the bits are running low
> I reused an unused one (PF_STARTING) 
> 
> Also clarify the error message (OOM means nothing to a normal user) 
> 

That information is useful for working out why a userspace allocation
attempt failed.  If we don't print it, and the application gets killed and
thus frees a lot of memory, we will just never know why the allocation
failed.

>  struct page *__page_cache_alloc(gfp_t gfp)
>  {
> +	struct task_struct *me = current;
> +	unsigned old = (~me->flags) & PF_USER_ALLOC;
> +	struct page *p;
> +
> +	me->flags |= PF_USER_ALLOC;
>  	if (cpuset_do_page_mem_spread()) {
>  		int n = cpuset_mem_spread_node();
> -		return alloc_pages_node(n, gfp, 0);
> -	}
> -	return alloc_pages(gfp, 0);
> +		p = alloc_pages_node(n, gfp, 0);
> +	} else
> +		p = alloc_pages(gfp, 0);
> +	/* Clear USER_ALLOC if it wasn't set originally */
> +	me->flags ^= old;
> +	return p;
>  }

That's appreciable amount of new overhead for at best a fairly marginal
benefit.  Perhaps __GFP_USER could be [re|ab]used.

Alternatively: if we've printed the diagnostic on behalf of this process
and then decided to kill it, set some flag to prevent us from printing it
again.

