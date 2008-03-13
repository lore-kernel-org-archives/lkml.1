Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbYCMQkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbYCMQkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 12:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbYCMQke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 12:40:34 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:35191 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752383AbYCMQke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 12:40:34 -0400
Date: Thu, 13 Mar 2008 12:40:33 -0400
To: Andi Kleen <ak@suse.de>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Save some bytes in mm_struct by filling holes on 64bit
Message-ID: <20080313164033.GD1289@csclub.uwaterloo.ca>
References: <20080312142807.GA2290@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080312142807.GA2290@bingen.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 03:28:07PM +0100, Andi Kleen wrote:
> 
> Save some bytes in mm_struct by filling holes
> 
> Putting int values together for better packing on 64bit 
> shrinks sizeof(struct mm_struct) from 776 bytes to 760 bytes.

Are you going to fix the nice comments that mentioned what feature they
were part of now that things are all mixed together?  I wonder if a few
bytes aren't worth paying for readable code.

After all now some 'aio bits' things are not in the 'aio bits' labeled
section.

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
> --

--
Len Sorensen
