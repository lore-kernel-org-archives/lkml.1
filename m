Return-Path: <linux-kernel-owner+w=401wt.eu-S1757490AbYDRHGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbYDRHGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 03:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbYDRHG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 03:06:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752828AbYDRHG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 03:06:26 -0400
Date: Fri, 18 Apr 2008 00:06:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, <linuxppc-dev@ozlabs.org>,
       <linux-kernel@vger.kernel.org>, Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 2/3] [POWERPC] Fix kernel stack allocation alignment
Message-Id: <20080418000618.0c46c78f.akpm@linux-foundation.org>
In-Reply-To: <20080418065727.5FE1CDE247@ozlabs.org>
References: <20080418065727.5FE1CDE247@ozlabs.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 16:56:17 +1000 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> The powerpc kernel stacks need to be naturally aligned, as they
> contain the thread info at the bottom, which is obtained by
> clearing the low bits of the stack pointer.
> 
> However, when using 64K pages (the stack is smaller than a page),
> we use kmalloc to allocate it, which doesn't provide that guarantee.
> 
> It appeared to work so far... until one enables SLUB debugging
> which then returns unaligned pointers. Ooops...
> 
> This patch fixes it by using a slab cache with enforced alignment
> for those. It replies on my previous patch that adds a
> thread_info_cache_init() callback.
> 
> ...
>
> +void thread_info_cache_init(void)
> +{
> +	thread_info_cache = kmem_cache_create("thread_info", THREAD_SIZE,
> +					      THREAD_SIZE, 0, NULL);
> +	BUG_ON(thread_info_cache == NULL);
> +}

so...  the "0" defeats all of SLAB_DEBUG_FREE, SLAB_RED_ZONE, SLAB_POISON
and SLAB_STORE_USER, if the comment in slab.h is to be believed.

Was that overkill?


