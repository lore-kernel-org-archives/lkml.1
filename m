Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639AbYCLSGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbYCLSGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 14:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbYCLSGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 14:06:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751044AbYCLSGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 14:06:21 -0400
Date: Wed, 12 Mar 2008 11:05:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Save some bytes in mm_struct by filling holes on 64bit
Message-Id: <20080312110537.3f812130.akpm@linux-foundation.org>
In-Reply-To: <20080312142807.GA2290@bingen.suse.de>
References: <20080312142807.GA2290@bingen.suse.de>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008 15:28:07 +0100 Andi Kleen <ak@suse.de> wrote:

> 
> Save some bytes in mm_struct by filling holes
> 
> Putting int values together for better packing on 64bit 
> shrinks sizeof(struct mm_struct) from 776 bytes to 760 bytes.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> Index: linux-2.6.25-rc5/include/linux/mm_types.h
> ===================================================================
> --- linux-2.6.25-rc5.orig/include/linux/mm_types.h
> +++ linux-2.6.25-rc5/include/linux/mm_types.h
> @@ -172,6 +172,7 @@ struct mm_struct {
>  	atomic_t mm_users;			/* How many users with user space? */
>  	atomic_t mm_count;			/* How many references to "struct mm_struct" (users count as 1) */
>  	int map_count;				/* number of VMAs */
> +	rwlock_t		ioctx_list_lock;	/* aio lock */
>  	struct rw_semaphore mmap_sem;
>  	spinlock_t page_table_lock;		/* Protects page tables and some counters */
>  
> @@ -213,14 +214,13 @@ struct mm_struct {
>  	unsigned int token_priority;
>  	unsigned int last_interval;
>  
> +	int core_waiters;
>  	unsigned long flags; /* Must use atomic bitops to access the bits */
>  
>  	/* coredumping support */
> -	int core_waiters;
>  	struct completion *core_startup_done, core_done;
>  
>  	/* aio bits */
> -	rwlock_t		ioctx_list_lock;
>  	struct kioctx		*ioctx_list;
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR
>  	struct mem_cgroup *mem_cgroup;

The current ioctx_list_lock position is better from a cache layout POV?
